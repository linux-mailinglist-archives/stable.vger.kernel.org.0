Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B6473D2A4D
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 19:07:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230040AbhGVQK2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 12:10:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:51588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235585AbhGVQJc (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 12:09:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1C1186139A;
        Thu, 22 Jul 2021 16:49:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626972574;
        bh=tfFLnZJ5cbp46h2m1QVdO6q4hAjT1hWrCrz6ppi0hWU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2vHCNWlkNj8PmyGHxQcs35jmcVNPFGqDjiRB3QlrdvaWrxnFG/tExY4MKTsOaIcwH
         FjVlVcGxaBSTcVbxjPVAEbGqsXdklXOEgOQtKDYfWrhKfbjATbl7EVseFbeT4SrFCt
         hR39e5E9zk4alGAyQnrwqBrH6oaHnpVjnZ/SF07U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aaron Ma <aaron.ma@canonical.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.13 156/156] mt76: mt7921: continue to probe driver when fw already downloaded
Date:   Thu, 22 Jul 2021 18:32:11 +0200
Message-Id: <20210722155633.397039609@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155628.371356843@linuxfoundation.org>
References: <20210722155628.371356843@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aaron Ma <aaron.ma@canonical.com>

commit c34269041185dad1bab7a34f42ef9fab967a1684 upstream.

When reboot system, no power cycles, firmware is already downloaded,
return -EIO will break driver as error:
mt7921e: probe of 0000:03:00.0 failed with error -5

Skip firmware download and continue to probe.

Signed-off-by: Aaron Ma <aaron.ma@canonical.com>
Fixes: 1c099ab44727c ("mt76: mt7921: add MCU support")
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
@@ -921,7 +921,7 @@ static int mt7921_load_firmware(struct m
 	ret = mt76_get_field(dev, MT_CONN_ON_MISC, MT_TOP_MISC2_FW_N9_RDY);
 	if (ret) {
 		dev_dbg(dev->mt76.dev, "Firmware is already download\n");
-		return -EIO;
+		goto fw_loaded;
 	}
 
 	ret = mt7921_load_patch(dev);
@@ -939,6 +939,7 @@ static int mt7921_load_firmware(struct m
 		return -EIO;
 	}
 
+fw_loaded:
 	mt76_queue_tx_cleanup(dev, dev->mt76.q_mcu[MT_MCUQ_FWDL], false);
 
 #ifdef CONFIG_PM


