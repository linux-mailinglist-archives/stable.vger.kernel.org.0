Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2ECA74F27D4
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:08:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233585AbiDEIJM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:09:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236042AbiDEIBL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:01:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D534D49FB3;
        Tue,  5 Apr 2022 00:59:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 97CBDB81B14;
        Tue,  5 Apr 2022 07:59:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07AD2C340EE;
        Tue,  5 Apr 2022 07:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145551;
        bh=qSRtZs8fsrIr02MXwnR3kLZ0JfjKLDShlPPya3X3rpc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lahQKRQwDol25M2vYwKcB3BHukvAdbvN7t1A7Jy4T5Xo/RQ1w16lWRQVm9Ya2q2If
         hfGPwFrd+KWC3CeQ8iTpMYRBz0GBBW3tNQRMdXmWXdA0oOtlisAGCN0s6qTOpFoEPB
         jK8KymI+nWx61rCUu+v5xI/dWTOSPSf6eUBz75Ps=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Wang <sean.wang@mediatek.com>,
        Mark Chen <mark-yw.chen@mediatek.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0446/1126] Bluetooth: mt7921s: fix firmware coredump retrieve
Date:   Tue,  5 Apr 2022 09:19:53 +0200
Message-Id: <20220405070420.715508964@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Chen <mark-yw.chen@mediatek.com>

[ Upstream commit 2fc967cc0dadad6735448cfbcbc77fe0ea30203d ]

According to the MCU firmware behavior, as the driver is aware of the
notification of the interrupt source FW_MAILBOX_INT that shows the MCU
completed delivered a core dump piece to the host, the driver must
acknowledge the MCU with the register PH2DSM0R bit PH2DSM0R_DRIVER_OWN
to notify the MCU to handle the next core dump piece.

Fixes: db57b625912a ("Bluetooth: btmtksdio: add support of processing firmware coredump and log")
Co-developed-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Mark Chen <mark-yw.chen@mediatek.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btmtksdio.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/bluetooth/btmtksdio.c b/drivers/bluetooth/btmtksdio.c
index b5ea8d3bffaa..d4e2541a4873 100644
--- a/drivers/bluetooth/btmtksdio.c
+++ b/drivers/bluetooth/btmtksdio.c
@@ -87,8 +87,12 @@ MODULE_DEVICE_TABLE(sdio, btmtksdio_table);
 #define RX_DONE_INT		BIT(1)
 #define TX_EMPTY		BIT(2)
 #define TX_FIFO_OVERFLOW	BIT(8)
+#define FW_MAILBOX_INT		BIT(15)
 #define RX_PKT_LEN		GENMASK(31, 16)
 
+#define MTK_REG_PH2DSM0R	0xc4
+#define PH2DSM0R_DRIVER_OWN	BIT(0)
+
 #define MTK_REG_CTDR		0x18
 
 #define MTK_REG_CRDR		0x1c
@@ -481,6 +485,12 @@ static void btmtksdio_txrx_work(struct work_struct *work)
 		 */
 		sdio_writel(bdev->func, int_status, MTK_REG_CHISR, NULL);
 
+		if ((int_status & FW_MAILBOX_INT) &&
+		    bdev->data->chipid == 0x7921) {
+			sdio_writel(bdev->func, PH2DSM0R_DRIVER_OWN,
+				    MTK_REG_PH2DSM0R, 0);
+		}
+
 		if (int_status & FW_OWN_BACK_INT)
 			bt_dev_dbg(bdev->hdev, "Get fw own back");
 
-- 
2.34.1



