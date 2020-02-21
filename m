Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 661781670E3
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 08:50:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728780AbgBUHtO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 02:49:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:45602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728295AbgBUHtM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 02:49:12 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DDCA8222C4;
        Fri, 21 Feb 2020 07:49:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582271352;
        bh=vAcka8fHr6mFiJZkIqQNpXN3P/qJC9ZOA4MvldSnGKc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=awJuXkvMRMSasY/df93VCZ6HaGq//N17FopRnVbMp8PaEHTP37EzNrQZlG/sJoSwG
         /v0FhKHLkI7PXow5QKiI2ujVd+i+fHI/DxWbOAm9cMW+6t/qeyEcHyfdZlkyRbgxwZ
         T84mKdyyLORUtklvGxnc6qeJVdSJDq4BpSm/9Jmw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Keerthy <j-keerthy@ti.com>,
        Roger Quadros <rogerq@ti.com>, Tero Kristo <t-kristo@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 133/399] bus: ti-sysc: Implement quirk handling for CLKDM_NOAUTO
Date:   Fri, 21 Feb 2020 08:37:38 +0100
Message-Id: <20200221072415.398762898@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072402.315346745@linuxfoundation.org>
References: <20200221072402.315346745@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index ccb44fe790a71..3d79b074f9581 100644
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



