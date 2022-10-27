Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4481D60FED3
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 19:08:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236786AbiJ0RIq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 13:08:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237062AbiJ0RIn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 13:08:43 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD91E19C06E
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 10:08:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 3C24CCE27B1
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 17:08:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B033C433D6;
        Thu, 27 Oct 2022 17:08:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666890519;
        bh=uGYPfYYkc1TtEswX7nRZimrzhucPIs5kIr4u7uUOjyI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QF+LEqb4wibJMnSrVw9TWbhkmQG4zhQpTaBhVyaP0z1O+fB039ury3ZbKRobZjdUh
         d6r/MReOyYDlIwVg9Boh9lJ4EC+cxvAOc/hd35zQ7jOajYuUYTbBkGLKqKs93kRvXa
         bJvrXrAhjTT35bcog6X3UuDINU0M/rXn5/VzTNjE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dave Chinner <dchinner@redhat.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Chandan Babu R <chandan.babu@oracle.com>
Subject: [PATCH 5.4 07/53] xfs: check owner of dir3 data blocks
Date:   Thu, 27 Oct 2022 18:55:55 +0200
Message-Id: <20221027165050.094729532@linuxfoundation.org>
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

commit a10c21ed5d5241d11cf1d5a4556730840572900b upstream.

[Slightly edit xfs_dir3_data_read() to work with existing mapped_bno argument instead
of flag values introduced in later kernels]

Check the owner field of dir3 data block headers.  If it's corrupt,
release the buffer and return EFSCORRUPTED.  All callers handle this
properly.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_dir2_data.c |   32 ++++++++++++++++++++++++++++++--
 1 file changed, 30 insertions(+), 2 deletions(-)

--- a/fs/xfs/libxfs/xfs_dir2_data.c
+++ b/fs/xfs/libxfs/xfs_dir2_data.c
@@ -348,6 +348,22 @@ static const struct xfs_buf_ops xfs_dir3
 	.verify_write = xfs_dir3_data_write_verify,
 };
 
+static xfs_failaddr_t
+xfs_dir3_data_header_check(
+	struct xfs_inode	*dp,
+	struct xfs_buf		*bp)
+{
+	struct xfs_mount	*mp = dp->i_mount;
+
+	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+		struct xfs_dir3_data_hdr *hdr3 = bp->b_addr;
+
+		if (be64_to_cpu(hdr3->hdr.owner) != dp->i_ino)
+			return __this_address;
+	}
+
+	return NULL;
+}
 
 int
 xfs_dir3_data_read(
@@ -357,12 +373,24 @@ xfs_dir3_data_read(
 	xfs_daddr_t		mapped_bno,
 	struct xfs_buf		**bpp)
 {
+	xfs_failaddr_t		fa;
 	int			err;
 
 	err = xfs_da_read_buf(tp, dp, bno, mapped_bno, bpp,
 				XFS_DATA_FORK, &xfs_dir3_data_buf_ops);
-	if (!err && tp && *bpp)
-		xfs_trans_buf_set_type(tp, *bpp, XFS_BLFT_DIR_DATA_BUF);
+	if (err || !*bpp)
+		return err;
+
+	/* Check things that we can't do in the verifier. */
+	fa = xfs_dir3_data_header_check(dp, *bpp);
+	if (fa) {
+		__xfs_buf_mark_corrupt(*bpp, fa);
+		xfs_trans_brelse(tp, *bpp);
+		*bpp = NULL;
+		return -EFSCORRUPTED;
+	}
+
+	xfs_trans_buf_set_type(tp, *bpp, XFS_BLFT_DIR_DATA_BUF);
 	return err;
 }
 


