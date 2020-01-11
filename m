Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 900BE137DE3
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:02:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729109AbgAKKCe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 05:02:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:32954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728819AbgAKKCe (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 05:02:34 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 86CEA20848;
        Sat, 11 Jan 2020 10:02:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578736953;
        bh=0t7sFC/dghiBRKtxczAFkc+MQIDlbu6/0fLf7MkGFtU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2v2E2Di5AwU+i1LgdWHFDzrhaXYUUQgma23YcTo8/P1ypmbN7l/cs29pm4BVXAxMU
         kj7QNsAwH3dZuG/QGSfYZvBkaR8uUmX95XAnRiVk408PjN+LcQEhUXJyfiNWOcqQYM
         C/rL1YmmmKP5dTIsE6UHVKLIGzI6wguiAIfrnHK8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4.9 27/91] ata: ahci_brcm: Allow optional reset controller to be used
Date:   Sat, 11 Jan 2020 10:49:20 +0100
Message-Id: <20200111094854.595033052@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094844.748507863@linuxfoundation.org>
References: <20200111094844.748507863@linuxfoundation.org>
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
@@ -88,6 +89,7 @@ struct brcm_ahci_priv {
 	u32 port_mask;
 	u32 quirks;
 	enum brcm_ahci_version version;
+	struct reset_control *rcdev;
 };
 
 static const struct ata_port_info ahci_brcm_port_info = {
@@ -332,6 +334,11 @@ static int brcm_ahci_probe(struct platfo
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


