Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 656AA133258
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 22:09:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729383AbgAGVJt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 16:09:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:35768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729736AbgAGVJt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 16:09:49 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0DA122077B;
        Tue,  7 Jan 2020 21:09:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578431388;
        bh=6VoqeGveJREBkuplXC7wYAfH0Bl22wXTQobbpVsqYLo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RxjXAMoJDugxgHHps4ddcWOMHGssMiwm0wd0JtACcyT7y+5Kr9NhgbAijw7qYvmqN
         R/4zcbEnyWeC5s4K39j1uWQfBflbvbMcf9txi7qJDDYkqd8/INPj7+qPoRFmvtqqbY
         Du+67KQY2rRRR1P6vF9Ad/vB7L4eUYXaeCjEnUNo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4.14 37/74] ata: ahci_brcm: Allow optional reset controller to be used
Date:   Tue,  7 Jan 2020 21:55:02 +0100
Message-Id: <20200107205207.390016921@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205135.369001641@linuxfoundation.org>
References: <20200107205135.369001641@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

commit 2b2c47d9e1fe90311b725125d6252a859ee87a79 upstream.

On BCM63138, we need to reset the AHCI core prior to start utilizing it,
grab the reset controller device cookie and do that.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/ata/ahci_brcm.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/ata/ahci_brcm.c
+++ b/drivers/ata/ahci_brcm.c
@@ -25,6 +25,7 @@
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
+#include <linux/reset.h>
 #include <linux/string.h>
 
 #include "ahci.h"
@@ -87,6 +88,7 @@ struct brcm_ahci_priv {
 	u32 port_mask;
 	u32 quirks;
 	enum brcm_ahci_version version;
+	struct reset_control *rcdev;
 };
 
 static const struct ata_port_info ahci_brcm_port_info = {
@@ -327,6 +329,11 @@ static int brcm_ahci_probe(struct platfo
 	if (IS_ERR(priv->top_ctrl))
 		return PTR_ERR(priv->top_ctrl);
 
+	/* Reset is optional depending on platform */
+	priv->rcdev = devm_reset_control_get(&pdev->dev, "ahci");
+	if (!IS_ERR_OR_NULL(priv->rcdev))
+		reset_control_deassert(priv->rcdev);
+
 	if ((priv->version == BRCM_SATA_BCM7425) ||
 		(priv->version == BRCM_SATA_NSP)) {
 		priv->quirks |= BRCM_AHCI_QUIRK_NO_NCQ;


