Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56D4242908C
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 16:08:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240064AbhJKOJ4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 10:09:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:56584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237834AbhJKOH4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 10:07:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 33F6761074;
        Mon, 11 Oct 2021 14:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960866;
        bh=Pa13U5hxARgtFVKae3Wm6fj98i02tJyzekyTyThNBLg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O8RMv9so9bTHsu4B3p0HpbY+dnyscYaUujTpPE1MWExbKYELXcOAQAyDgYGLT0g5F
         WanjMWbghIH/WD0/obwREgoe85awmHVQurvNAxP8GJ8Qlzv588c/3J8hUwvqq3PmcO
         htBHLhNJx3zD73x9ZXM9vwg+Y9m5qZy4ME09C1ME=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 098/151] bus: ti-sysc: Use CLKDM_NOAUTO for dra7 dcan1 for errata i893
Date:   Mon, 11 Oct 2021 15:46:10 +0200
Message-Id: <20211011134520.993519683@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134517.833565002@linuxfoundation.org>
References: <20211011134517.833565002@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit b13a270ace2e4c70653aa1d1d0394c553905802f ]

Commit 94f6345712b3 ("bus: ti-sysc: Implement quirk handling for
CLKDM_NOAUTO") should have also added the quirk for dra7 dcan1 in
addition to dcan2 for errata i893 handling.

Let's also pass the quirk flag for legacy mode booting for if "ti,hwmods"
dts property is used with related dcan hwmod data. This should be only
needed if anybody needs to git bisect earlier stable trees though.

Fixes: 94f6345712b3 ("bus: ti-sysc: Implement quirk handling for CLKDM_NOAUTO")
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-omap2/omap_hwmod.c | 2 ++
 drivers/bus/ti-sysc.c            | 3 +++
 2 files changed, 5 insertions(+)

diff --git a/arch/arm/mach-omap2/omap_hwmod.c b/arch/arm/mach-omap2/omap_hwmod.c
index 12b26e04686f..0c2936c7a379 100644
--- a/arch/arm/mach-omap2/omap_hwmod.c
+++ b/arch/arm/mach-omap2/omap_hwmod.c
@@ -3614,6 +3614,8 @@ int omap_hwmod_init_module(struct device *dev,
 		oh->flags |= HWMOD_SWSUP_SIDLE_ACT;
 	if (data->cfg->quirks & SYSC_QUIRK_SWSUP_MSTANDBY)
 		oh->flags |= HWMOD_SWSUP_MSTANDBY;
+	if (data->cfg->quirks & SYSC_QUIRK_CLKDM_NOAUTO)
+		oh->flags |= HWMOD_CLKDM_NOAUTO;
 
 	error = omap_hwmod_check_module(dev, oh, data, sysc_fields,
 					rev_offs, sysc_offs, syss_offs,
diff --git a/drivers/bus/ti-sysc.c b/drivers/bus/ti-sysc.c
index 10fcb75df68a..418ada474a85 100644
--- a/drivers/bus/ti-sysc.c
+++ b/drivers/bus/ti-sysc.c
@@ -1468,6 +1468,9 @@ static const struct sysc_revision_quirk sysc_revision_quirks[] = {
 	/* Quirks that need to be set based on detected module */
 	SYSC_QUIRK("aess", 0, 0, 0x10, -ENODEV, 0x40000000, 0xffffffff,
 		   SYSC_MODULE_QUIRK_AESS),
+	/* Errata i893 handling for dra7 dcan1 and 2 */
+	SYSC_QUIRK("dcan", 0x4ae3c000, 0x20, -ENODEV, -ENODEV, 0xa3170504, 0xffffffff,
+		   SYSC_QUIRK_CLKDM_NOAUTO),
 	SYSC_QUIRK("dcan", 0x48480000, 0x20, -ENODEV, -ENODEV, 0xa3170504, 0xffffffff,
 		   SYSC_QUIRK_CLKDM_NOAUTO),
 	SYSC_QUIRK("dss", 0x4832a000, 0, 0x10, 0x14, 0x00000020, 0xffffffff,
-- 
2.33.0



