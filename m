Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 434A0A7D48
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 10:07:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728504AbfIDIHM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 04:07:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47122 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727544AbfIDIHM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 04:07:12 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9395C875221
        for <stable@vger.kernel.org>; Wed,  4 Sep 2019 08:07:11 +0000 (UTC)
Received: from localhost (unknown [10.40.205.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3599A5D6C8
        for <stable@vger.kernel.org>; Wed,  4 Sep 2019 08:07:11 +0000 (UTC)
Date:   Wed, 4 Sep 2019 10:07:10 +0200
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     stable@vger.kernel.org
Subject: [PATCH 4.19] mt76: mt76x0u: do not reset radio on resume
Message-ID: <20190904080704.GA2704@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.68]); Wed, 04 Sep 2019 08:07:11 +0000 (UTC)
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
---
 drivers/net/wireless/mediatek/mt76/mt76x0/init.c   | 4 ++--
 drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h | 2 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/usb.c    | 4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
index 0a3e046d78db..da2ba51dec35 100644
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
index fc9857f61771..f9dfe5097b09 100644
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
index 54ae1f113be2..5aacb1f6a841 100644
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
