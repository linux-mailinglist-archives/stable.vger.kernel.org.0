Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B45ED28B7F9
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:48:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731935AbgJLNsV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:48:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:55742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731920AbgJLNsT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:48:19 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1BA63222EA;
        Mon, 12 Oct 2020 13:48:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602510491;
        bh=DzT6gbTJUZoK6JQ5CGfo5bGoJnSMRuUub6QWRkR6brg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z8wDj2gaqcaCVN+LgR4R9RUulWfKUkprbtDqjsCAq9w4YDpzuz7SCyKtl2G8ZIEWB
         6yK2Sg750SQr5FbcKJopWn6Y3xCIUJgpUiKErdAXUGlwhR9XcN2k1Sj7DjUbJGOQ+O
         rNtfjZW8HMBKtw+aZAXWTa7ct1853AgllYwLFsiM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hariprasad Kelam <hkelam@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 082/124] octeontx2-pf: Fix synchnorization issue in mbox
Date:   Mon, 12 Oct 2020 15:31:26 +0200
Message-Id: <20201012133150.831240408@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012133146.834528783@linuxfoundation.org>
References: <20201012133146.834528783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hariprasad Kelam <hkelam@marvell.com>

[ Upstream commit 66a5209b53418111757716d71e52727b782eabd4 ]

Mbox implementation in octeontx2 driver has three states
alloc, send and reset in mbox response. VF allocate and
sends message to PF for processing, PF ACKs them back and
reset the mbox memory. In some case we see synchronization
issue where after msgs_acked is incremented and before
mbox_reset API is called, if current execution is scheduled
out and a different thread is scheduled in which checks for
msgs_acked. Since the new thread sees msgs_acked == msgs_sent
it will try to allocate a new message and to send a new mbox
message to PF.Now if mbox_reset is scheduled in, PF will see
'0' in msgs_send.
This patch fixes the issue by calling mbox_reset before
incrementing msgs_acked flag for last processing message and
checks for valid message size.

Fixes: d424b6c02 ("octeontx2-pf: Enable SRIOV and added VF mbox handling")
Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/mbox.c     | 12 ++++++++++--
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h     |  1 +
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c | 11 ++++++-----
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c |  4 ++--
 4 files changed, 19 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.c b/drivers/net/ethernet/marvell/octeontx2/af/mbox.c
index 387e33fa417aa..2718fe201c147 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.c
@@ -17,7 +17,7 @@
 
 static const u16 msgs_offset = ALIGN(sizeof(struct mbox_hdr), MBOX_MSG_ALIGN);
 
-void otx2_mbox_reset(struct otx2_mbox *mbox, int devid)
+void __otx2_mbox_reset(struct otx2_mbox *mbox, int devid)
 {
 	void *hw_mbase = mbox->hwbase + (devid * MBOX_SIZE);
 	struct otx2_mbox_dev *mdev = &mbox->dev[devid];
@@ -26,13 +26,21 @@ void otx2_mbox_reset(struct otx2_mbox *mbox, int devid)
 	tx_hdr = hw_mbase + mbox->tx_start;
 	rx_hdr = hw_mbase + mbox->rx_start;
 
-	spin_lock(&mdev->mbox_lock);
 	mdev->msg_size = 0;
 	mdev->rsp_size = 0;
 	tx_hdr->num_msgs = 0;
 	tx_hdr->msg_size = 0;
 	rx_hdr->num_msgs = 0;
 	rx_hdr->msg_size = 0;
+}
+EXPORT_SYMBOL(__otx2_mbox_reset);
+
+void otx2_mbox_reset(struct otx2_mbox *mbox, int devid)
+{
+	struct otx2_mbox_dev *mdev = &mbox->dev[devid];
+
+	spin_lock(&mdev->mbox_lock);
+	__otx2_mbox_reset(mbox, devid);
 	spin_unlock(&mdev->mbox_lock);
 }
 EXPORT_SYMBOL(otx2_mbox_reset);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
index 6dfd0f90cd704..ab433789d2c31 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -93,6 +93,7 @@ struct mbox_msghdr {
 };
 
 void otx2_mbox_reset(struct otx2_mbox *mbox, int devid);
+void __otx2_mbox_reset(struct otx2_mbox *mbox, int devid);
 void otx2_mbox_destroy(struct otx2_mbox *mbox);
 int otx2_mbox_init(struct otx2_mbox *mbox, void __force *hwbase,
 		   struct pci_dev *pdev, void __force *reg_base,
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index 5d620a39ea802..2fb45670aca49 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -370,8 +370,8 @@ static int otx2_forward_vf_mbox_msgs(struct otx2_nic *pf,
 		dst_mbox = &pf->mbox;
 		dst_size = dst_mbox->mbox.tx_size -
 				ALIGN(sizeof(*mbox_hdr), MBOX_MSG_ALIGN);
-		/* Check if msgs fit into destination area */
-		if (mbox_hdr->msg_size > dst_size)
+		/* Check if msgs fit into destination area and has valid size */
+		if (mbox_hdr->msg_size > dst_size || !mbox_hdr->msg_size)
 			return -EINVAL;
 
 		dst_mdev = &dst_mbox->mbox.dev[0];
@@ -526,10 +526,10 @@ static void otx2_pfvf_mbox_up_handler(struct work_struct *work)
 
 end:
 		offset = mbox->rx_start + msg->next_msgoff;
+		if (mdev->msgs_acked == (vf_mbox->up_num_msgs - 1))
+			__otx2_mbox_reset(mbox, 0);
 		mdev->msgs_acked++;
 	}
-
-	otx2_mbox_reset(mbox, vf_idx);
 }
 
 static irqreturn_t otx2_pfvf_mbox_intr_handler(int irq, void *pf_irq)
@@ -803,10 +803,11 @@ static void otx2_pfaf_mbox_handler(struct work_struct *work)
 		msg = (struct mbox_msghdr *)(mdev->mbase + offset);
 		otx2_process_pfaf_mbox_msg(pf, msg);
 		offset = mbox->rx_start + msg->next_msgoff;
+		if (mdev->msgs_acked == (af_mbox->num_msgs - 1))
+			__otx2_mbox_reset(mbox, 0);
 		mdev->msgs_acked++;
 	}
 
-	otx2_mbox_reset(mbox, 0);
 }
 
 static void otx2_handle_link_event(struct otx2_nic *pf)
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
index 92a3db69a6cd6..2f90f17214415 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
@@ -99,10 +99,10 @@ static void otx2vf_vfaf_mbox_handler(struct work_struct *work)
 		msg = (struct mbox_msghdr *)(mdev->mbase + offset);
 		otx2vf_process_vfaf_mbox_msg(af_mbox->pfvf, msg);
 		offset = mbox->rx_start + msg->next_msgoff;
+		if (mdev->msgs_acked == (af_mbox->num_msgs - 1))
+			__otx2_mbox_reset(mbox, 0);
 		mdev->msgs_acked++;
 	}
-
-	otx2_mbox_reset(mbox, 0);
 }
 
 static int otx2vf_process_mbox_msg_up(struct otx2_nic *vf,
-- 
2.25.1



