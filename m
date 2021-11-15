Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90A54451F19
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:36:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355582AbhKPAid (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:38:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:45404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344442AbhKOTYl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:24:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D23BC6348F;
        Mon, 15 Nov 2021 18:57:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002665;
        bh=l192d7uiPDmOygLE1ZTTALz/cbKkMFAV6jYQQ1aqX4A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=btv/xynuGujTiXh37nI11t5yFf+URZYvM1MgZ410P2Q001y7WlMCTOAAYdhP6O5vF
         3phIY2Re8+QHuk50w0KzZju4hNXw8b33MRfI5jRansbBD70EaAaAnrz+SFkVI1WwfO
         Si4i54hYG3sV/Vo3fYOyUiGBNYZWKe6Sc+UCD8Sc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>,
        Amelie Delaunay <amelie.delaunay@foss.st.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 652/917] usb: dwc2: drd: fix dwc2_force_mode call in dwc2_ovr_init
Date:   Mon, 15 Nov 2021 18:02:27 +0100
Message-Id: <20211115165450.978900581@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amelie Delaunay <amelie.delaunay@foss.st.com>

[ Upstream commit b2cab2a24fb5d13ce1d384ecfb6de827fa08a048 ]

Instead of forcing the role to Device, check the dr_mode configuration.
If the core is Host only, force the mode to Host, this to avoid the
dwc2_force_mode warning:
WARNING: CPU: 1 PID: 21 at drivers/usb/dwc2/core.c:615 dwc2_drd_init+0x104/0x17c

When forcing mode to Host, dwc2_force_mode may sleep the time the host
role is applied. To avoid sleeping while atomic context, move the call
to dwc2_force_mode after spin_unlock_irqrestore. It is safe, as
interrupts are not yet unmasked here.

Fixes: 17f934024e84 ("usb: dwc2: override PHY input signals with usb role switch support")
Acked-by: Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>
Signed-off-by: Amelie Delaunay <amelie.delaunay@foss.st.com>
Link: https://lore.kernel.org/r/20211005095305.66397-2-amelie.delaunay@foss.st.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc2/drd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/dwc2/drd.c b/drivers/usb/dwc2/drd.c
index 2d4176f5788eb..80eae88d76dda 100644
--- a/drivers/usb/dwc2/drd.c
+++ b/drivers/usb/dwc2/drd.c
@@ -25,9 +25,9 @@ static void dwc2_ovr_init(struct dwc2_hsotg *hsotg)
 	gotgctl &= ~(GOTGCTL_BVALOVAL | GOTGCTL_AVALOVAL | GOTGCTL_VBVALOVAL);
 	dwc2_writel(hsotg, gotgctl, GOTGCTL);
 
-	dwc2_force_mode(hsotg, false);
-
 	spin_unlock_irqrestore(&hsotg->lock, flags);
+
+	dwc2_force_mode(hsotg, (hsotg->dr_mode == USB_DR_MODE_HOST));
 }
 
 static int dwc2_ovr_avalid(struct dwc2_hsotg *hsotg, bool valid)
-- 
2.33.0



