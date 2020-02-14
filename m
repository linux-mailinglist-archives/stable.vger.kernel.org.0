Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57AE815EDCB
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:36:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390067AbgBNRgH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 12:36:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:55656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390202AbgBNQFl (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:05:41 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6F4052067D;
        Fri, 14 Feb 2020 16:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696340;
        bh=AOoUCVz+M6lYYlM1lQNzSbPm93ZmILm9W0AXjwEgkTM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZBFCpQuUHRfUFUfHK6eYzkOD8mnP5C3hWBwk6v6VKaRKR/W4cusdRjNX0tjNF374t
         dsdm3VobqKDWlwd/+PkB0IFD8mit0j5RDls4grmoB8WigrS/0xmhMCD28DcOvL/FrS
         CrXA/R7/uesvNwvpEcZ4uwSXYm8We25xTD9fgfCY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tony Lindgren <tony@atomide.com>, Keerthy <j-keerthy@ti.com>,
        Roger Quadros <rogerq@ti.com>, Tero Kristo <t-kristo@ti.com>,
        Sasha Levin <sashal@kernel.org>, linux-omap@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 176/459] bus: ti-sysc: Implement quirk handling for CLKDM_NOAUTO
Date:   Fri, 14 Feb 2020 10:57:06 -0500
Message-Id: <20200214160149.11681-176-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214160149.11681-1-sashal@kernel.org>
References: <20200214160149.11681-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit 94f6345712b37e4bb23cb265ce4c65b9d177e75a ]

For dra7 dcan and dwc3 instances we need to block clockdomain autoidle.
Let's do this with CLKDM_NOAUTO quirk flag and enable it for dcan and
dwc3.

Cc: Keerthy <j-keerthy@ti.com>
Cc: Roger Quadros <rogerq@ti.com>
Cc: Tero Kristo <t-kristo@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/ti-sysc.c                 | 10 ++++++++--
 include/linux/platform_data/ti-sysc.h |  1 +
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/bus/ti-sysc.c b/drivers/bus/ti-sysc.c
index d9846265a5cd9..a0cecb12b6f96 100644
--- a/drivers/bus/ti-sysc.c
+++ b/drivers/bus/ti-sysc.c
@@ -479,7 +479,7 @@ static void sysc_clkdm_deny_idle(struct sysc *ddata)
 {
 	struct ti_sysc_platform_data *pdata;
 
-	if (ddata->legacy_mode)
+	if (ddata->legacy_mode || (ddata->cfg.quirks & SYSC_QUIRK_CLKDM_NOAUTO))
 		return;
 
 	pdata = dev_get_platdata(ddata->dev);
@@ -491,7 +491,7 @@ static void sysc_clkdm_allow_idle(struct sysc *ddata)
 {
 	struct ti_sysc_platform_data *pdata;
 
-	if (ddata->legacy_mode)
+	if (ddata->legacy_mode || (ddata->cfg.quirks & SYSC_QUIRK_CLKDM_NOAUTO))
 		return;
 
 	pdata = dev_get_platdata(ddata->dev);
@@ -1251,6 +1251,12 @@ static const struct sysc_revision_quirk sysc_revision_quirks[] = {
 	/* Quirks that need to be set based on detected module */
 	SYSC_QUIRK("aess", 0, 0, 0x10, -1, 0x40000000, 0xffffffff,
 		   SYSC_MODULE_QUIRK_AESS),
+	SYSC_QUIRK("dcan", 0x48480000, 0x20, -1, -1, 0xa3170504, 0xffffffff,
+		   SYSC_QUIRK_CLKDM_NOAUTO),
+	SYSC_QUIRK("dwc3", 0x48880000, 0, 0x10, -1, 0x500a0200, 0xffffffff,
+		   SYSC_QUIRK_CLKDM_NOAUTO),
+	SYSC_QUIRK("dwc3", 0x488c0000, 0, 0x10, -1, 0x500a0200, 0xffffffff,
+		   SYSC_QUIRK_CLKDM_NOAUTO),
 	SYSC_QUIRK("hdq1w", 0, 0, 0x14, 0x18, 0x00000006, 0xffffffff,
 		   SYSC_MODULE_QUIRK_HDQ1W),
 	SYSC_QUIRK("hdq1w", 0, 0, 0x14, 0x18, 0x0000000a, 0xffffffff,
diff --git a/include/linux/platform_data/ti-sysc.h b/include/linux/platform_data/ti-sysc.h
index 8cfe570fdece6..2cbde6542849d 100644
--- a/include/linux/platform_data/ti-sysc.h
+++ b/include/linux/platform_data/ti-sysc.h
@@ -49,6 +49,7 @@ struct sysc_regbits {
 	s8 emufree_shift;
 };
 
+#define SYSC_QUIRK_CLKDM_NOAUTO		BIT(21)
 #define SYSC_QUIRK_FORCE_MSTANDBY	BIT(20)
 #define SYSC_MODULE_QUIRK_AESS		BIT(19)
 #define SYSC_MODULE_QUIRK_SGX		BIT(18)
-- 
2.20.1

