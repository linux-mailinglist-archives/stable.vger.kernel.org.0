Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDB155ED8B2
	for <lists+stable@lfdr.de>; Wed, 28 Sep 2022 11:18:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233278AbiI1JSU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Sep 2022 05:18:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233520AbiI1JR7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Sep 2022 05:17:59 -0400
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FE0361B0D;
        Wed, 28 Sep 2022 02:17:34 -0700 (PDT)
X-UUID: be06d884694b4eb3bf06e891a3658ca3-20220928
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=XXqYom0PShqqvqx1Lq9wqOLByxK/9HTGJNY8mFnsriY=;
        b=EJRiYPDe0203cIf33SGVWKn4006aT7zvRZqCJMOpJiqS/biujUFomlXkaYldZLrreIZPJOrDJoKntq7gt4x6eaDcrDsaVUritkpgVMlq5ZSgnpxevV5glF7nuPFFTiPTaRLAEdDXHWTXrJg6MCCKFwvC0tdv/s4S029omOZC5os=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.11,REQID:c900f38b-d3e3-4413-95c1-6e46600a2056,IP:0,U
        RL:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
        N:release,TS:-25
X-CID-META: VersionHash:39a5ff1,CLOUDID:79ef4d07-1cee-4c38-b21b-a45f9682fdc0,B
        ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
        RL:11|1,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0
X-UUID: be06d884694b4eb3bf06e891a3658ca3-20220928
Received: from mtkmbs11n1.mediatek.inc [(172.21.101.185)] by mailgw02.mediatek.com
        (envelope-from <chunfeng.yun@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 782486596; Wed, 28 Sep 2022 17:17:28 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
 mtkmbs11n2.mediatek.inc (172.21.101.187) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.792.15; Wed, 28 Sep 2022 17:17:27 +0800
Received: from localhost.localdomain (10.17.3.154) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 28 Sep 2022 17:17:26 +0800
From:   Chunfeng Yun <chunfeng.yun@mediatek.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Chunfeng Yun <chunfeng.yun@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        <linux-usb@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        Eddie Hung <eddie.hung@mediatek.com>,
        Min Guo <min.guo@mediatek.com>,
        Tianping Fang <tianping.fang@mediatek.com>,
        <Stable@vger.kernel.org>
Subject: [PATCH 1/2] usb: mtu3: fix ep0's stall of out data stage
Date:   Wed, 28 Sep 2022 17:17:20 +0800
Message-ID: <20220928091721.26112-1-chunfeng.yun@mediatek.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-MTK:  N
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS,UNPARSEABLE_RELAY,URIBL_CSS autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

It happens when enable uvc function, the flow as below:
the controller switch to data stage, then call
    -> foward_to_driver() -> composite_setup() -> uvc_function_setup(),
it send out an event to user layer to notify it call
    -> ioctl() -> uvc_send_response() -> usb_ep_queue(),
but before the user call ioctl to queue ep0's buffer, the host already send
out data, but the controller find that no buffer is queued to receive data,
it send out STALL handshake.

To fix the issue, don't send out ACK of setup stage to switch to out data
stage until the buffer is available.

Cc: <Stable@vger.kernel.org>
Reported-by: Min Guo <min.guo@mediatek.com>
Signed-off-by: Chunfeng Yun <chunfeng.yun@mediatek.com>
---
 drivers/usb/mtu3/mtu3.h            |  4 ++++
 drivers/usb/mtu3/mtu3_gadget_ep0.c | 22 +++++++++++++++++++---
 2 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/mtu3/mtu3.h b/drivers/usb/mtu3/mtu3.h
index 2d7b57e07eee..6b64ad17724d 100644
--- a/drivers/usb/mtu3/mtu3.h
+++ b/drivers/usb/mtu3/mtu3.h
@@ -318,6 +318,9 @@ static inline struct ssusb_mtk *dev_to_ssusb(struct device *dev)
  *		for GET_STATUS and SET_SEL
  * @setup_buf: ep0 response buffer for GET_STATUS and SET_SEL requests
  * @u3_capable: is capable of supporting USB3
+ * @delayed_setup: delay the setup stage to avoid STALL handshake in
+ *		out data stage due to the class driver doesn't queue buffer
+ *		before the host send out data
  */
 struct mtu3 {
 	spinlock_t lock;
@@ -360,6 +363,7 @@ struct mtu3 {
 	unsigned connected:1;
 	unsigned async_callbacks:1;
 	unsigned separate_fifo:1;
+	unsigned delayed_setup:1;
 
 	u8 address;
 	u8 test_mode_nr;
diff --git a/drivers/usb/mtu3/mtu3_gadget_ep0.c b/drivers/usb/mtu3/mtu3_gadget_ep0.c
index e4fd1bb14a55..f7a71cc83e15 100644
--- a/drivers/usb/mtu3/mtu3_gadget_ep0.c
+++ b/drivers/usb/mtu3/mtu3_gadget_ep0.c
@@ -162,6 +162,19 @@ static void ep0_do_status_stage(struct mtu3 *mtu)
 	mtu3_writel(mbase, U3D_EP0CSR, value | EP0_SETUPPKTRDY | EP0_DATAEND);
 }
 
+/* delay sending out ACK of setup stage to wait for OUT buffer queued */
+static void ep0_setup_stage_send_ack(struct mtu3 *mtu)
+{
+	void __iomem *mbase = mtu->mac_base;
+	u32 value;
+
+	if (mtu->delayed_setup) {
+		value = mtu3_readl(mbase, U3D_EP0CSR) & EP0_W1C_BITS;
+		mtu3_writel(mbase, U3D_EP0CSR, value | EP0_SETUPPKTRDY);
+		mtu->delayed_setup = 0;
+	}
+}
+
 static int ep0_queue(struct mtu3_ep *mep0, struct mtu3_request *mreq);
 
 static void ep0_dummy_complete(struct usb_ep *ep, struct usb_request *req)
@@ -628,8 +641,9 @@ static void ep0_read_setup(struct mtu3 *mtu, struct usb_ctrlrequest *setup)
 			csr | EP0_SETUPPKTRDY | EP0_DPHTX);
 		mtu->ep0_state = MU3D_EP0_STATE_TX;
 	} else {
-		mtu3_writel(mtu->mac_base, U3D_EP0CSR,
-			(csr | EP0_SETUPPKTRDY) & (~EP0_DPHTX));
+		mtu3_writel(mtu->mac_base, U3D_EP0CSR, csr & ~EP0_DPHTX);
+		/* send ACK when the buffer is queued */
+		mtu->delayed_setup = 1;
 		mtu->ep0_state = MU3D_EP0_STATE_RX;
 	}
 }
@@ -804,9 +818,11 @@ static int ep0_queue(struct mtu3_ep *mep, struct mtu3_request *mreq)
 
 	switch (mtu->ep0_state) {
 	case MU3D_EP0_STATE_SETUP:
-	case MU3D_EP0_STATE_RX:	/* control-OUT data */
 	case MU3D_EP0_STATE_TX:	/* control-IN data */
 		break;
+	case MU3D_EP0_STATE_RX:	/* control-OUT data */
+		ep0_setup_stage_send_ack(mtu);
+		break;
 	default:
 		dev_err(mtu->dev, "%s, error in ep0 state %s\n", __func__,
 			decode_ep0_state(mtu));
-- 
2.18.0

