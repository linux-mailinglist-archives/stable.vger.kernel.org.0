Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC1081331C4
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 22:04:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728967AbgAGVDs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 16:03:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:46558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728974AbgAGVDr (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 16:03:47 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B5BDB2081E;
        Tue,  7 Jan 2020 21:03:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578431027;
        bh=/A8G4m5/CbKB3q8Lhatro960Z/QFZjCCGpHHAiIAzfU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BGN4sjKO7PFBr17ah4R7ou8QMhPZ5S7WEjcBJ9ClByXBpYNq7w/BWZaAqoAd78gUZ
         hvIkhiARKLk6eNvj7bK/Dr89sixZPPBmjMZSmgM3Of4yPqwCD03UPT+JxF8gwpIdXl
         LXzYlMtKW7TBvtOLFalBnmfwx2m+hJLOQy09sV/w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephen Boyd <swboyd@chromium.org>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Felipe Balbi <felipe.balbi@linux.intel.com>
Subject: [PATCH 5.4 168/191] phy: renesas: rcar-gen3-usb2: Use platform_get_irq_optional() for optional irq
Date:   Tue,  7 Jan 2020 21:54:48 +0100
Message-Id: <20200107205341.994942891@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205332.984228665@linuxfoundation.org>
References: <20200107205332.984228665@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

commit b049e03ca57f238e74a79e44ffc85904db465e72 upstream.

As platform_get_irq() now prints an error when the interrupt does not
exist, a scary warning may be printed for an optional interrupt:

    phy_rcar_gen3_usb2 ee0a0200.usb-phy: IRQ index 0 not found

Fix this by calling platform_get_irq_optional() instead.

Fixes: 7723f4c5ecdb8d83 ("driver core: platform: Add an error message to platform_get_irq*()")
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Reviewed-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Tested-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/phy/renesas/phy-rcar-gen3-usb2.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/phy/renesas/phy-rcar-gen3-usb2.c
+++ b/drivers/phy/renesas/phy-rcar-gen3-usb2.c
@@ -615,7 +615,7 @@ static int rcar_gen3_phy_usb2_probe(stru
 		return PTR_ERR(channel->base);
 
 	/* call request_irq for OTG */
-	irq = platform_get_irq(pdev, 0);
+	irq = platform_get_irq_optional(pdev, 0);
 	if (irq >= 0) {
 		INIT_WORK(&channel->work, rcar_gen3_phy_usb2_work);
 		irq = devm_request_irq(dev, irq, rcar_gen3_phy_usb2_irq,


