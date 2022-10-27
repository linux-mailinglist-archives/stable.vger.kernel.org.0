Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFD8460FED1
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 19:08:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237053AbiJ0RIn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 13:08:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237070AbiJ0RIi (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 13:08:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54F1919DDAD
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 10:08:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E85E762404
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 17:08:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B0F2C43470;
        Thu, 27 Oct 2022 17:08:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666890516;
        bh=8/HsiE2IPC2u/gamlk86MihK6ydKfrwbkec1sM+6twU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CDSi7+s92pTXrlHivhzFxMvcaxXscn4niHFhOqP1Hc/WxPHa5uEZiwRfRDsvwB0yG
         U1lMYgvd7LH04sCtxi9M2wAIVu/Al6VhDKzVe66H9vBs9+v9/hple255OCfM6s7tig
         2IMqgI9ZqZhpQslanrUW5S0zUzYL1jdGHtqXy7fM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dave Chinner <dchinner@redhat.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Chandan Babu R <chandan.babu@oracle.com>
Subject: [PATCH 5.4 06/53] xfs: fix buffer corruption reporting when xfs_dir3_free_header_check fails
Date:   Thu, 27 Oct 2022 18:55:54 +0200
Message-Id: <20221027165050.060407343@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165049.817124510@linuxfoundation.org>
References: <20221027165049.817124510@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit ce99494c9699df58b31d0a839e957f86cd58c755 upstream.

xfs_verifier_error is supposed to be called on a corrupt metadata buffer
from within a buffer verifier function, whereas xfs_buf_mark_corrupt
is the function to be called when a piece of code has read a buffer and
catches something that a read verifier cannot.  The first function sets
b_error anticipating that the low level buffer handling code will see
the nonzero b_error and clear XBF_DONE on the buffer, whereas the second
function does not.

Since xfs_dir3_free_header_check examines fields in the dir free block
header that require more context than can be provided to read verifiers,
we must call xfs_buf_mark_corrupt when it finds a problem.

Switching the calls has a secondary effect that we no longer corrupt the
buffer state by setting b_error and leaving XBF_DONE set.  When /that/
happens, we'll trip over various state assertions (most commonly the
b_error check in xfs_buf_reverify) on a subsequent attempt to read the
buffer.

Fixes: bc1a09b8e334bf5f ("xfs: refactor verifier callers to print address of failing check")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_dir2_node.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -208,7 +208,7 @@ __xfs_dir3_free_read(
 	/* Check things that we can't do in the verifier. */
 	fa = xfs_dir3_free_header_check(dp, fbno, *bpp);
 	if (fa) {
-		xfs_verifier_error(*bpp, -EFSCORRUPTED, fa);
+		__xfs_buf_mark_corrupt(*bpp, fa);
 		xfs_trans_brelse(tp, *bpp);
 		*bpp = NULL;
 		return -EFSCORRUPTED;


