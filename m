Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72BE960FECF
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 19:08:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237067AbiJ0RIg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 13:08:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237052AbiJ0RIf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 13:08:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B677C19C06E
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 10:08:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5384F623EE
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 17:08:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63A92C433C1;
        Thu, 27 Oct 2022 17:08:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666890513;
        bh=jlSHTMrWnjf5XEvnmgdpBz3RtSwCo0F1E/pkJgVt/v0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mNxYU9LZ3UCu+WBNhyzp+Y0uLCA+kwsjZk71vdFqjlgwBTDsgMFmgA0Onwxzp5Ady
         LO8arBw2Ik4SICwZ1ZY0e5Ewi+yTC/UNET9AVth5aC9eZ4VPqThIvTTu2+YdWRR1Jm
         7RkqVSJG8GUMyczZETEqE4EYpKKX7jS6gMd1RSho=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dave Chinner <dchinner@redhat.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Chandan Babu R <chandan.babu@oracle.com>
Subject: [PATCH 5.4 05/53] xfs: xfs_buf_corruption_error should take __this_address
Date:   Thu, 27 Oct 2022 18:55:53 +0200
Message-Id: <20221027165050.023983282@linuxfoundation.org>
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

commit e83cf875d67a6cb9ddfaa8b45d2fa93d12b5c66f upstream.

Add a xfs_failaddr_t parameter to this function so that callers can
potentially pass in (and therefore report) the exact point in the code
where we decided that a metadata buffer was corrupt.  This enables us to
wire it up to checking functions that have to run outside of verifiers.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_buf.c   |    2 +-
 fs/xfs/xfs_error.c |    5 +++--
 fs/xfs/xfs_error.h |    2 +-
 3 files changed, 5 insertions(+), 4 deletions(-)

--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1564,7 +1564,7 @@ __xfs_buf_mark_corrupt(
 {
 	ASSERT(bp->b_flags & XBF_DONE);
 
-	xfs_buf_corruption_error(bp);
+	xfs_buf_corruption_error(bp, fa);
 	xfs_buf_stale(bp);
 }
 
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -350,13 +350,14 @@ xfs_corruption_error(
  */
 void
 xfs_buf_corruption_error(
-	struct xfs_buf		*bp)
+	struct xfs_buf		*bp,
+	xfs_failaddr_t		fa)
 {
 	struct xfs_mount	*mp = bp->b_mount;
 
 	xfs_alert_tag(mp, XFS_PTAG_VERIFIER_ERROR,
 		  "Metadata corruption detected at %pS, %s block 0x%llx",
-		  __return_address, bp->b_ops->name, bp->b_bn);
+		  fa, bp->b_ops->name, bp->b_bn);
 
 	xfs_alert(mp, "Unmount and run xfs_repair");
 
--- a/fs/xfs/xfs_error.h
+++ b/fs/xfs/xfs_error.h
@@ -15,7 +15,7 @@ extern void xfs_corruption_error(const c
 			struct xfs_mount *mp, const void *buf, size_t bufsize,
 			const char *filename, int linenum,
 			xfs_failaddr_t failaddr);
-void xfs_buf_corruption_error(struct xfs_buf *bp);
+void xfs_buf_corruption_error(struct xfs_buf *bp, xfs_failaddr_t fa);
 extern void xfs_buf_verifier_error(struct xfs_buf *bp, int error,
 			const char *name, const void *buf, size_t bufsz,
 			xfs_failaddr_t failaddr);


