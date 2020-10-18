Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7127291BF5
	for <lists+stable@lfdr.de>; Sun, 18 Oct 2020 21:35:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728092AbgJRT0D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Oct 2020 15:26:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:41032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731527AbgJRT0C (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 18 Oct 2020 15:26:02 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 80A4F2231B;
        Sun, 18 Oct 2020 19:26:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603049162;
        bh=QWMvPqkn4Zv3OynYGV21SYqtVsu7u/KB6Eu+sCemUms=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MlgipxBNwaq35YSTGHryl/HU2bqsKEias9dA/R0x2Nczv0FOXSmmBcHmbiI0YRDIZ
         iRGyfCe6Xadlw5rnFgp7CnjkWciW+6ogXx7zk0fnruZaEBBMs4lk2/4kwTs5ggCeRh
         cHhawPEWW/OQj+FBXLKrtIeG0dXoqNm/Ui2YYdtE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sherry Sun <sherry.sun@nxp.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 26/52] mic: vop: copy data to kernel space then write to io memory
Date:   Sun, 18 Oct 2020 15:25:03 -0400
Message-Id: <20201018192530.4055730-26-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201018192530.4055730-1-sashal@kernel.org>
References: <20201018192530.4055730-1-sashal@kernel.org>
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
index fed992e2c2583..99bde52a3a256 100644
--- a/drivers/misc/mic/vop/vop_vringh.c
+++ b/drivers/misc/mic/vop/vop_vringh.c
@@ -611,6 +611,7 @@ static int vop_virtio_copy_from_user(struct vop_vdev *vdev, void __user *ubuf,
 	size_t partlen;
 	bool dma = VOP_USE_DMA;
 	int err = 0;
+	size_t offset = 0;
 
 	if (daddr & (dma_alignment - 1)) {
 		vdev->tx_dst_unaligned += len;
@@ -659,13 +660,20 @@ static int vop_virtio_copy_from_user(struct vop_vdev *vdev, void __user *ubuf,
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
 	vpdev->hw_ops->iounmap(vpdev, dbuf);
-- 
2.25.1

