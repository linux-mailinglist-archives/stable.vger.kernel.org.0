Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE8C114E188
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 19:45:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730745AbgA3SpU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 13:45:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:54876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731000AbgA3SpT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jan 2020 13:45:19 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 61C892082E;
        Thu, 30 Jan 2020 18:45:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580409917;
        bh=tgiIWyaWgYWNqXLGQPohVSA04eXZ04wHRLN/JX73TAA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qYpMWZ5SLDhwZilVj6iluF4pXPqtNoXnwwB4v/M/age03v35UzaP6mjXfksbu0yaK
         CEnl+zNVjdtg26yc/pa0XvhAYdCCxV5awb7Qt2J6hOvmY+WqfTvpel8/7fH+ftQgd9
         smSW9Dpz7TVopdBsK7M/V8Yao3EHV9sPeal3Wysw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 083/110] bus: ti-sysc: Handle mstandby quirk and use it for musb
Date:   Thu, 30 Jan 2020 19:38:59 +0100
Message-Id: <20200130183623.991569511@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200130183613.810054545@linuxfoundation.org>
References: <20200130183613.810054545@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit 03856e928b0e1a1c274eece1dfe4330a362c37f3 ]

We need swsup quirks for sidle and mstandby for musb to work
properly.

Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/ti-sysc.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/bus/ti-sysc.c b/drivers/bus/ti-sysc.c
index abbf281ee337b..44d4f4864ac2a 100644
--- a/drivers/bus/ti-sysc.c
+++ b/drivers/bus/ti-sysc.c
@@ -923,6 +923,9 @@ set_midle:
 		return -EINVAL;
 	}
 
+	if (ddata->cfg.quirks & SYSC_QUIRK_SWSUP_MSTANDBY)
+		best_mode = SYSC_IDLE_NO;
+
 	reg &= ~(SYSC_IDLE_MASK << regbits->midle_shift);
 	reg |= best_mode << regbits->midle_shift;
 	sysc_write(ddata, ddata->offsets[SYSC_SYSCONFIG], reg);
@@ -984,6 +987,9 @@ static int sysc_disable_module(struct device *dev)
 		return ret;
 	}
 
+	if (ddata->cfg.quirks & SYSC_QUIRK_SWSUP_MSTANDBY)
+		best_mode = SYSC_IDLE_FORCE;
+
 	reg &= ~(SYSC_IDLE_MASK << regbits->midle_shift);
 	reg |= best_mode << regbits->midle_shift;
 	sysc_write(ddata, ddata->offsets[SYSC_SYSCONFIG], reg);
@@ -1257,6 +1263,8 @@ static const struct sysc_revision_quirk sysc_revision_quirks[] = {
 	SYSC_QUIRK("gpu", 0x50000000, 0x14, -1, -1, 0x00010201, 0xffffffff, 0),
 	SYSC_QUIRK("gpu", 0x50000000, 0xfe00, 0xfe10, -1, 0x40000000 , 0xffffffff,
 		   SYSC_MODULE_QUIRK_SGX),
+	SYSC_QUIRK("usb_otg_hs", 0, 0x400, 0x404, 0x408, 0x00000050,
+		   0xffffffff, SYSC_QUIRK_SWSUP_SIDLE | SYSC_QUIRK_SWSUP_MSTANDBY),
 	SYSC_QUIRK("wdt", 0, 0, 0x10, 0x14, 0x502a0500, 0xfffff0f0,
 		   SYSC_MODULE_QUIRK_WDT),
 	/* Watchdog on am3 and am4 */
@@ -1315,8 +1323,6 @@ static const struct sysc_revision_quirk sysc_revision_quirks[] = {
 	SYSC_QUIRK("usbhstll", 0, 0, 0x10, 0x14, 0x00000008, 0xffffffff, 0),
 	SYSC_QUIRK("usb_host_hs", 0, 0, 0x10, 0x14, 0x50700100, 0xffffffff, 0),
 	SYSC_QUIRK("usb_host_hs", 0, 0, 0x10, -1, 0x50700101, 0xffffffff, 0),
-	SYSC_QUIRK("usb_otg_hs", 0, 0x400, 0x404, 0x408, 0x00000050,
-		   0xffffffff, 0),
 	SYSC_QUIRK("vfpe", 0, 0, 0x104, -1, 0x4d001200, 0xffffffff, 0),
 #endif
 };
-- 
2.20.1



