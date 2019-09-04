Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8517A905B
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:37:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389902AbfIDSJL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 14:09:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:52324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389137AbfIDSJL (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 14:09:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7FD78206BA;
        Wed,  4 Sep 2019 18:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567620550;
        bh=DnrHmSJpqDeIhtpXZ1Tbd3urK6dLmwpYYGMRDUeovSw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sHlelJjefZcCjMyMBtcUMHonVc7jlRFZkpZ4uuA9u70luNQF8L/aLWpwQdUYexh4H
         wlI386ZuogawDeYJ6JwkmhQvUXsdPF73usnIkRp7x2dO6WY3ADZqpMgyGioS4Vzl2d
         sXFLt43cxUPl1GGWNWxtbeWDs31/YTQFdRjCkl+s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stanislaw Gruszka <sgruszka@redhat.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 93/93] mt76: mt76x0u: do not reset radio on resume
Date:   Wed,  4 Sep 2019 19:54:35 +0200
Message-Id: <20190904175311.152213295@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175302.845828956@linuxfoundation.org>
References: <20190904175302.845828956@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 8f2d163cb26da87e7d8e1677368b8ba1ba4d30b3 upstream.

On some machines mt76x0u firmware can hung during resume,
what result on messages like below:

[  475.480062] mt76x0 1-8:1.0: Error: MCU response pre-completed!
[  475.990066] mt76x0 1-8:1.0: Error: send MCU cmd failed:-110
[  475.990075] mt76x0 1-8:1.0: Error: MCU response pre-completed!
[  476.500003] mt76x0 1-8:1.0: Error: send MCU cmd failed:-110
[  476.500012] mt76x0 1-8:1.0: Error: MCU response pre-completed!
[  477.010046] mt76x0 1-8:1.0: Error: send MCU cmd failed:-110
[  477.010055] mt76x0 1-8:1.0: Error: MCU response pre-completed!
[  477.529997] mt76x0 1-8:1.0: Error: send MCU cmd failed:-110
[  477.530006] mt76x0 1-8:1.0: Error: MCU response pre-completed!
[  477.824907] mt76x0 1-8:1.0: Error: send MCU cmd failed:-71
[  477.824916] mt76x0 1-8:1.0: Error: MCU response pre-completed!
[  477.825029] usb 1-8: USB disconnect, device number 6

and possible whole system freeze.

This can be avoided, if we do not perform mt76x0_chip_onoff() reset.

Cc: stable@vger.kernel.org
Fixes: 134b2d0d1fcf ("mt76x0: init files")
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/init.c   | 4 ++--
 drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h | 2 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/usb.c    | 4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
index 0a3e046d78db3..da2ba51dec352 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
@@ -369,7 +369,7 @@ static void mt76x0_stop_hardware(struct mt76x0_dev *dev)
 	mt76x0_chip_onoff(dev, false, false);
 }
 
-int mt76x0_init_hardware(struct mt76x0_dev *dev)
+int mt76x0_init_hardware(struct mt76x0_dev *dev, bool reset)
 {
 	static const u16 beacon_offsets[16] = {
 		/* 512 byte per beacon */
@@ -382,7 +382,7 @@ int mt76x0_init_hardware(struct mt76x0_dev *dev)
 
 	dev->beacon_offsets = beacon_offsets;
 
-	mt76x0_chip_onoff(dev, true, true);
+	mt76x0_chip_onoff(dev, true, reset);
 
 	ret = mt76x0_wait_asic_ready(dev);
 	if (ret)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
index fc9857f61771c..f9dfe5097b099 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
@@ -279,7 +279,7 @@ void mt76x0_addr_wr(struct mt76x0_dev *dev, const u32 offset, const u8 *addr);
 
 /* Init */
 struct mt76x0_dev *mt76x0_alloc_device(struct device *dev);
-int mt76x0_init_hardware(struct mt76x0_dev *dev);
+int mt76x0_init_hardware(struct mt76x0_dev *dev, bool reset);
 int mt76x0_register_device(struct mt76x0_dev *dev);
 void mt76x0_cleanup(struct mt76x0_dev *dev);
 void mt76x0_chip_onoff(struct mt76x0_dev *dev, bool enable, bool reset);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
index 54ae1f113be23..5aacb1f6a841d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
@@ -300,7 +300,7 @@ static int mt76x0_probe(struct usb_interface *usb_intf,
 	if (!(mt76_rr(dev, MT_EFUSE_CTRL) & MT_EFUSE_CTRL_SEL))
 		dev_warn(dev->mt76.dev, "Warning: eFUSE not present\n");
 
-	ret = mt76x0_init_hardware(dev);
+	ret = mt76x0_init_hardware(dev, true);
 	if (ret)
 		goto err;
 
@@ -354,7 +354,7 @@ static int mt76x0_resume(struct usb_interface *usb_intf)
 	struct mt76x0_dev *dev = usb_get_intfdata(usb_intf);
 	int ret;
 
-	ret = mt76x0_init_hardware(dev);
+	ret = mt76x0_init_hardware(dev, false);
 	if (ret)
 		return ret;
 
-- 
2.20.1



