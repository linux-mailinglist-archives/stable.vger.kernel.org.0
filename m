Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3566F4F2C3E
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:24:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241890AbiDEIf6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:35:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239146AbiDEITv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:19:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9D7D6D4E7;
        Tue,  5 Apr 2022 01:10:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 477416062B;
        Tue,  5 Apr 2022 08:10:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52CBAC385A0;
        Tue,  5 Apr 2022 08:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649146216;
        bh=+wbSIDzTNb3sO7zBqVhP0gA4qqrOV/7Y+d5H8QZWGzA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cgP2nLp7xabnyUCRqaVG8+DweVK9R+kiqQNS/F4L1sczs3KLXc6d9QnimJtODvUj4
         qtVavH9JCHFeg5nudTi4tpoGOHijO/Qgs413Q8AVwj8wALKXLegECkmaOGrLLBKRsl
         ZuevQ680LwrT0n6Vcph2tWbXXONKv02q7pWt4sqQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Chen <markyawenchen@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Yake Yang <yake.yang@mediatek.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0685/1126] Bluetooth: btmtksdio: Fix kernel oops in btmtksdio_interrupt
Date:   Tue,  5 Apr 2022 09:23:52 +0200
Message-Id: <20220405070427.724005589@linuxfoundation.org>
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

From: Yake Yang <yake.yang@mediatek.com>

[ Upstream commit b062a0b9c1dc1ff63094337dccfe1568d5b62023 ]

Fix the following kernel oops in btmtksdio_interrrupt

[   14.339134]  btmtksdio_interrupt+0x28/0x54
[   14.339139]  process_sdio_pending_irqs+0x68/0x1a0
[   14.339144]  sdio_irq_work+0x40/0x70
[   14.339154]  process_one_work+0x184/0x39c
[   14.339160]  worker_thread+0x228/0x3e8
[   14.339168]  kthread+0x148/0x3ac
[   14.339176]  ret_from_fork+0x10/0x30

That happened because hdev->power_on is already called before
sdio_set_drvdata which btmtksdio_interrupt handler relies on is not
properly set up.

The details are shown as the below: hci_register_dev would run
queue_work(hdev->req_workqueue, &hdev->power_on) as WQ_HIGHPRI
workqueue_struct to complete the power-on sequeunce and thus hci_power_on
may run before sdio_set_drvdata is done in btmtksdio_probe.

The hci_dev_do_open in hci_power_on would initialize the device and enable
the interrupt and thus it is possible that btmtksdio_interrupt is being
called right before sdio_set_drvdata is filled out.

When btmtksdio_interrupt is being called and sdio_set_drvdata is not filled
, the kernel oops is going to happen because btmtksdio_interrupt access an
uninitialized pointer.

Fixes: 9aebfd4a2200 ("Bluetooth: mediatek: add support for MediaTek MT7663S and MT7668S SDIO devices")
Reviewed-by: Mark Chen <markyawenchen@gmail.com>
Co-developed-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Yake Yang <yake.yang@mediatek.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btmtksdio.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/bluetooth/btmtksdio.c b/drivers/bluetooth/btmtksdio.c
index 86a52eb77e01..9b868f187316 100644
--- a/drivers/bluetooth/btmtksdio.c
+++ b/drivers/bluetooth/btmtksdio.c
@@ -1095,6 +1095,8 @@ static int btmtksdio_probe(struct sdio_func *func,
 	hdev->manufacturer = 70;
 	set_bit(HCI_QUIRK_NON_PERSISTENT_SETUP, &hdev->quirks);
 
+	sdio_set_drvdata(func, bdev);
+
 	err = hci_register_dev(hdev);
 	if (err < 0) {
 		dev_err(&func->dev, "Can't register HCI device\n");
@@ -1102,8 +1104,6 @@ static int btmtksdio_probe(struct sdio_func *func,
 		return err;
 	}
 
-	sdio_set_drvdata(func, bdev);
-
 	/* pm_runtime_enable would be done after the firmware is being
 	 * downloaded because the core layer probably already enables
 	 * runtime PM for this func such as the case host->caps &
-- 
2.34.1



