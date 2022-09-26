Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8D975EA154
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 12:50:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237074AbiIZKug (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 06:50:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236570AbiIZKqw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 06:46:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B38B957232;
        Mon, 26 Sep 2022 03:25:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BB772B80915;
        Mon, 26 Sep 2022 10:25:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2714FC433D7;
        Mon, 26 Sep 2022 10:25:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664187955;
        bh=e/6xeRdBd9WX29GIdGG1MC2Ct7nHdPDSrGxL1c8Rg5M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UnxVW89f4ggI4TP7VkB7ZnlMO+946TTChNENx7MbzA+vSPVTW2aX9o24JrD/Cd7Ij
         ae7sLmrOx4/3Wx5DsmZAcXLfu87P8ZhjgC7lFGIqKEBgaF+1NX8nFBX5L8xlYsopkv
         XSljZ5fPMAbDGie5BOmj30L0t89Hy74GNxkbCrdM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@redhat.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Chandan Babu R <chandan.babu@oracle.com>
Subject: [PATCH 5.4 115/120] xfs: use bitops interface for buf log item AIL flag check
Date:   Mon, 26 Sep 2022 12:12:28 +0200
Message-Id: <20220926100755.121201939@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100750.519221159@linuxfoundation.org>
References: <20220926100750.519221159@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brian Foster <bfoster@redhat.com>

commit 826f7e34130a4ce756138540170cbe935c537a47 upstream.

The xfs_log_item flags were converted to atomic bitops as of commit
22525c17ed ("xfs: log item flags are racy"). The assert check for
AIL presence in xfs_buf_item_relse() still uses the old value based
check. This likely went unnoticed as XFS_LI_IN_AIL evaluates to 0
and causes the assert to unconditionally pass. Fix up the check.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Fixes: 22525c17ed ("xfs: log item flags are racy")
Reviewed-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_buf_item.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -956,7 +956,7 @@ xfs_buf_item_relse(
 	struct xfs_buf_log_item	*bip = bp->b_log_item;
 
 	trace_xfs_buf_item_relse(bp, _RET_IP_);
-	ASSERT(!(bip->bli_item.li_flags & XFS_LI_IN_AIL));
+	ASSERT(!test_bit(XFS_LI_IN_AIL, &bip->bli_item.li_flags));
 
 	bp->b_log_item = NULL;
 	if (list_empty(&bp->b_li_list))


