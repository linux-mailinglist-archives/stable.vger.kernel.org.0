Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04409291A52
	for <lists+stable@lfdr.de>; Sun, 18 Oct 2020 21:23:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730241AbgJRTXS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Oct 2020 15:23:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:36396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730225AbgJRTXR (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 18 Oct 2020 15:23:17 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2AAFE222E9;
        Sun, 18 Oct 2020 19:23:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603048996;
        bh=MkgMDcccSHwun46vYipogs2oopYDY7nk+d6mYmDSuyM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ek/JhMCTz4ZzWgPR3iclI7Z6LTFbgvauh8SGrvl57Na1Q/sW53EB5IlHMPxUVNXjN
         MnDq97Wglt/vbVsBNGJ1BWXsurk/uBPDnR6ybS6bz27JLdqT/dA9dG9ds9ifU5nTPo
         YLks3xSbtga7iTfxB3s1w5vGczOi3DTAdqSn0yI8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sherry Sun <sherry.sun@nxp.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 34/80] mic: vop: copy data to kernel space then write to io memory
Date:   Sun, 18 Oct 2020 15:21:45 -0400
Message-Id: <20201018192231.4054535-34-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201018192231.4054535-1-sashal@kernel.org>
References: <20201018192231.4054535-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sherry Sun <sherry.sun@nxp.com>

[ Upstream commit 675f0ad4046946e80412896436164d172cd92238 ]

Read and write io memory should address align on ARCH ARM. Change to use
memcpy_toio to avoid kernel panic caused by the address un-align issue.

Signed-off-by: Sherry Sun <sherry.sun@nxp.com>
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
Link: https://lore.kernel.org/r/20200929091106.24624-5-sherry.sun@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/mic/vop/vop_vringh.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/misc/mic/vop/vop_vringh.c b/drivers/misc/mic/vop/vop_vringh.c
index 30eac172f0170..d069947b09345 100644
--- a/drivers/misc/mic/vop/vop_vringh.c
+++ b/drivers/misc/mic/vop/vop_vringh.c
@@ -602,6 +602,7 @@ static int vop_virtio_copy_from_user(struct vop_vdev *vdev, void __user *ubuf,
 	size_t partlen;
 	bool dma = VOP_USE_DMA && vi->dma_ch;
 	int err = 0;
+	size_t offset = 0;
 
 	if (dma) {
 		dma_alignment = 1 << vi->dma_ch->device->copy_align;
@@ -655,13 +656,20 @@ static int vop_virtio_copy_from_user(struct vop_vdev *vdev, void __user *ubuf,
 	 * We are copying to IO below and should ideally use something
 	 * like copy_from_user_toio(..) if it existed.
 	 */
-	if (copy_from_user((void __force *)dbuf, ubuf, len)) {
-		err = -EFAULT;
-		dev_err(vop_dev(vdev), "%s %d err %d\n",
-			__func__, __LINE__, err);
-		goto err;
+	while (len) {
+		partlen = min_t(size_t, len, VOP_INT_DMA_BUF_SIZE);
+
+		if (copy_from_user(vvr->buf, ubuf + offset, partlen)) {
+			err = -EFAULT;
+			dev_err(vop_dev(vdev), "%s %d err %d\n",
+				__func__, __LINE__, err);
+			goto err;
+		}
+		memcpy_toio(dbuf + offset, vvr->buf, partlen);
+		offset += partlen;
+		vdev->out_bytes += partlen;
+		len -= partlen;
 	}
-	vdev->out_bytes += len;
 	err = 0;
 err:
 	vpdev->hw_ops->unmap(vpdev, dbuf);
-- 
2.25.1

