Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 144A64832AF
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 15:31:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233839AbiACOaO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 09:30:14 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:59328 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234470AbiACO3V (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 09:29:21 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EDFE861113;
        Mon,  3 Jan 2022 14:29:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDA88C36AEB;
        Mon,  3 Jan 2022 14:29:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641220160;
        bh=CRHlpZ/k7qgCu9yP+xEGcp4K1hZv6Ldobe3tOC1Ql9U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mBk2mG6BqNBfwozcnvcpeyX6mVBc7yD7FqK3CVcYBUuDXGClR2AFzM3TMo+RfU7s3
         X6gYF4adny8AueCarskfnyDZdSURGN/8LbG1ePA8D8I4dGtvzV8rc+6qqnYfhJfZGl
         egGbDv0ZEPqSfF9PyniC3crww6RfNNLA14NdnkJE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 22/48] NFC: st21nfca: Fix memory leak in device probe and remove
Date:   Mon,  3 Jan 2022 15:23:59 +0100
Message-Id: <20220103142054.219230321@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220103142053.466768714@linuxfoundation.org>
References: <20220103142053.466768714@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

[ Upstream commit 1b9dadba502234eea7244879b8d5d126bfaf9f0c ]

'phy->pending_skb' is alloced when device probe, but forgot to free
in the error handling path and remove path, this cause memory leak
as follows:

unreferenced object 0xffff88800bc06800 (size 512):
  comm "8", pid 11775, jiffies 4295159829 (age 9.032s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<00000000d66c09ce>] __kmalloc_node_track_caller+0x1ed/0x450
    [<00000000c93382b3>] kmalloc_reserve+0x37/0xd0
    [<000000005fea522c>] __alloc_skb+0x124/0x380
    [<0000000019f29f9a>] st21nfca_hci_i2c_probe+0x170/0x8f2

Fix it by freeing 'pending_skb' in error and remove.

Fixes: 68957303f44a ("NFC: ST21NFCA: Add driver for STMicroelectronics ST21NFCA NFC Chip")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nfc/st21nfca/i2c.c | 29 ++++++++++++++++++++---------
 1 file changed, 20 insertions(+), 9 deletions(-)

diff --git a/drivers/nfc/st21nfca/i2c.c b/drivers/nfc/st21nfca/i2c.c
index 23ed11f91213d..6ea59426ab0bf 100644
--- a/drivers/nfc/st21nfca/i2c.c
+++ b/drivers/nfc/st21nfca/i2c.c
@@ -533,7 +533,8 @@ static int st21nfca_hci_i2c_probe(struct i2c_client *client,
 	phy->gpiod_ena = devm_gpiod_get(dev, "enable", GPIOD_OUT_LOW);
 	if (IS_ERR(phy->gpiod_ena)) {
 		nfc_err(dev, "Unable to get ENABLE GPIO\n");
-		return PTR_ERR(phy->gpiod_ena);
+		r = PTR_ERR(phy->gpiod_ena);
+		goto out_free;
 	}
 
 	phy->se_status.is_ese_present =
@@ -544,7 +545,7 @@ static int st21nfca_hci_i2c_probe(struct i2c_client *client,
 	r = st21nfca_hci_platform_init(phy);
 	if (r < 0) {
 		nfc_err(&client->dev, "Unable to reboot st21nfca\n");
-		return r;
+		goto out_free;
 	}
 
 	r = devm_request_threaded_irq(&client->dev, client->irq, NULL,
@@ -553,15 +554,23 @@ static int st21nfca_hci_i2c_probe(struct i2c_client *client,
 				ST21NFCA_HCI_DRIVER_NAME, phy);
 	if (r < 0) {
 		nfc_err(&client->dev, "Unable to register IRQ handler\n");
-		return r;
+		goto out_free;
 	}
 
-	return st21nfca_hci_probe(phy, &i2c_phy_ops, LLC_SHDLC_NAME,
-					ST21NFCA_FRAME_HEADROOM,
-					ST21NFCA_FRAME_TAILROOM,
-					ST21NFCA_HCI_LLC_MAX_PAYLOAD,
-					&phy->hdev,
-					&phy->se_status);
+	r = st21nfca_hci_probe(phy, &i2c_phy_ops, LLC_SHDLC_NAME,
+			       ST21NFCA_FRAME_HEADROOM,
+			       ST21NFCA_FRAME_TAILROOM,
+			       ST21NFCA_HCI_LLC_MAX_PAYLOAD,
+			       &phy->hdev,
+			       &phy->se_status);
+	if (r)
+		goto out_free;
+
+	return 0;
+
+out_free:
+	kfree_skb(phy->pending_skb);
+	return r;
 }
 
 static int st21nfca_hci_i2c_remove(struct i2c_client *client)
@@ -574,6 +583,8 @@ static int st21nfca_hci_i2c_remove(struct i2c_client *client)
 
 	if (phy->powered)
 		st21nfca_hci_i2c_disable(phy);
+	if (phy->pending_skb)
+		kfree_skb(phy->pending_skb);
 
 	return 0;
 }
-- 
2.34.1



