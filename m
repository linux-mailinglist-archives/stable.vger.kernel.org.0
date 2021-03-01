Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CAA2328D42
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:11:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241095AbhCATIL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:08:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:34118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240931AbhCATBZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:01:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D1DAA651D3;
        Mon,  1 Mar 2021 17:17:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619049;
        bh=2NVndUT7dS67kVUETNfHqFdwMr3cq1s8T/7KdfD5vl0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w8/WPb/SraOtCuU0ZkgjVuhIodqnd5/hTO9wCKiH6PdWKzMlvWFM9383Id4AMUXXb
         od5XS65VQ9v9hzg4sAjLgGZnmvp+5u72sFBIkwqzG38dOhPaGiqCTQKhHbxItuMe5f
         4F2YpK3VEXpAXDCe381QapciYKnl1ikI1wmOTej0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Osipenko <digetx@gmail.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 313/663] power: supply: smb347-charger: Fix interrupt usage if interrupt is unavailable
Date:   Mon,  1 Mar 2021 17:09:21 +0100
Message-Id: <20210301161157.329350288@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Osipenko <digetx@gmail.com>

[ Upstream commit 6996312642d2dad3070c3d276c7621f35e721f30 ]

The IRQ=0 could be a valid interrupt number in kernel because interrupt
numbers are virtual in a modern kernel. Hence fix the interrupt usage in
a case if interrupt is unavailable by not overriding the interrupt number
which is used by the driver.

Note that currently Nexus 7 is the only know device which uses SMB347
kernel diver and it has a properly working interrupt, hence this patch
doesn't fix any real problems, it's a minor cleanup/improvement.

Fixes: 99298de5df92 ("power: supply: smb347-charger: Replace mutex with IRQ disable/enable")
Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/smb347-charger.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/power/supply/smb347-charger.c b/drivers/power/supply/smb347-charger.c
index d3bf35ed12cee..8cfbd8d6b4786 100644
--- a/drivers/power/supply/smb347-charger.c
+++ b/drivers/power/supply/smb347-charger.c
@@ -137,6 +137,7 @@
  * @mains_online: is AC/DC input connected
  * @usb_online: is USB input connected
  * @charging_enabled: is charging enabled
+ * @irq_unsupported: is interrupt unsupported by SMB hardware
  * @max_charge_current: maximum current (in uA) the battery can be charged
  * @max_charge_voltage: maximum voltage (in uV) the battery can be charged
  * @pre_charge_current: current (in uA) to use in pre-charging phase
@@ -193,6 +194,7 @@ struct smb347_charger {
 	bool			mains_online;
 	bool			usb_online;
 	bool			charging_enabled;
+	bool			irq_unsupported;
 
 	unsigned int		max_charge_current;
 	unsigned int		max_charge_voltage;
@@ -862,6 +864,9 @@ static int smb347_irq_set(struct smb347_charger *smb, bool enable)
 {
 	int ret;
 
+	if (smb->irq_unsupported)
+		return 0;
+
 	ret = smb347_set_writable(smb, true);
 	if (ret < 0)
 		return ret;
@@ -923,8 +928,6 @@ static int smb347_irq_init(struct smb347_charger *smb,
 	ret = regmap_update_bits(smb->regmap, CFG_STAT,
 				 CFG_STAT_ACTIVE_HIGH | CFG_STAT_DISABLED,
 				 CFG_STAT_DISABLED);
-	if (ret < 0)
-		client->irq = 0;
 
 	smb347_set_writable(smb, false);
 
@@ -1345,6 +1348,7 @@ static int smb347_probe(struct i2c_client *client,
 		if (ret < 0) {
 			dev_warn(dev, "failed to initialize IRQ: %d\n", ret);
 			dev_warn(dev, "disabling IRQ support\n");
+			smb->irq_unsupported = true;
 		} else {
 			smb347_irq_enable(smb);
 		}
@@ -1357,8 +1361,8 @@ static int smb347_remove(struct i2c_client *client)
 {
 	struct smb347_charger *smb = i2c_get_clientdata(client);
 
-	if (client->irq)
-		smb347_irq_disable(smb);
+	smb347_irq_disable(smb);
+
 	return 0;
 }
 
-- 
2.27.0



