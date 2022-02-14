Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74FA24B4BC4
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:43:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347846AbiBNKbt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:31:49 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347858AbiBNKaj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:30:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86D0270CE0;
        Mon, 14 Feb 2022 01:59:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E8024B80DC8;
        Mon, 14 Feb 2022 09:59:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E483EC340EF;
        Mon, 14 Feb 2022 09:59:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832744;
        bh=9gahyeLnbkRBgOkWxxyP2q3atLHrR6v1XwsdkB7+PGE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i20lY47uCKLP/CaazcpUsMneyzTy+zPuJ6OeUdMd8EGa2xRtQZSODRJ0xSMCIT6Vo
         hwm2SDYi+GP74CRte8c+sTMv2NWmp8wxVHcsGGkai0yqn7LsNjb7OLNAaOk1vjXUdL
         B4J+0drK72KCYrPNwcvr/ZH+Q9yf+wNR0qzgVqr4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH 5.16 079/203] Revert "gfs2: check context in gfs2_glock_put"
Date:   Mon, 14 Feb 2022 10:25:23 +0100
Message-Id: <20220214092512.963476086@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092510.221474733@linuxfoundation.org>
References: <20220214092510.221474733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andreas Gruenbacher <agruenba@redhat.com>

commit 356b8103d4c495d5440e3e687db9026ec2b76043 upstream.

It turns out that the might_sleep() call that commit 660a6126f8c3 adds
is triggering occasional data corruption in testing.  We're not sure
about the root cause yet, but since this commit was added as a debugging
aid only, revert it for now.

This reverts commit 660a6126f8c3208f6df8d552039cda078a8426d1.

Fixes: 660a6126f8c3 ("gfs2: check context in gfs2_glock_put")
Cc: stable@vger.kernel.org # v5.16+
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/gfs2/glock.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -301,9 +301,6 @@ void gfs2_glock_queue_put(struct gfs2_gl
 
 void gfs2_glock_put(struct gfs2_glock *gl)
 {
-	/* last put could call sleepable dlm api */
-	might_sleep();
-
 	if (lockref_put_or_lock(&gl->gl_lockref))
 		return;
 


