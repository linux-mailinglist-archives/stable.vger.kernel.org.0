Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62EB534CA15
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:40:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234209AbhC2Iev (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:34:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:52660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234770AbhC2Idg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:33:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 43A516195B;
        Mon, 29 Mar 2021 08:33:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006812;
        bh=h4OZxiti7/owytu2eagIjXICQNY7RDtRoMMrqZEKWYw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qj8KmuTvu79V0Rkbm6JWjSJt/ymMM2HSCmMySpqLIu85GLfsH1vLeEANJXT4SE+vF
         B1A+U1+LALVXdT6hU3xuN6HvLo/4PArDZ2V1qxkTLS8P+IrZRXlXMaGXVQcB1lOIEl
         XBeCfgaRUDAt/yBtaEDdPwOuS4zekwbsk+PGaKzs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kishon Vijay Abraham I <kishon@ti.com>,
        Yongqin Liu <yongqin.liu@linaro.org>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 107/254] soc: ti: omap-prm: Fix reboot issue with invalid pcie reset map for dra7
Date:   Mon, 29 Mar 2021 09:57:03 +0200
Message-Id: <20210329075636.723789994@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075633.135869143@linuxfoundation.org>
References: <20210329075633.135869143@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit a249ca66d15fa4b54dc6deaff4155df3db1308e1 ]

Yongqin Liu <yongqin.liu@linaro.org> reported an issue where reboot hangs
on beagleboard-x15. This started happening after commit 7078a5ba7a58
("soc: ti: omap-prm: Fix boot time errors for rst_map_012 bits 0 and 1").

We now assert any 012 type resets on init to prevent unconfigured
accelerator MMUs getting enabled on init depending on the bootloader or
kexec configured state.

Turns out that we now also wrongly assert dra7 l3init domain PCIe reset
bits causing a hang during reboot. Let's fix the l3init reset bits to
use a 01 map instead of 012 map. There are only two rstctrl bits and not
three. This is documented in TRM "Table 3-1647. RM_PCIESS_RSTCTRL".

Fixes: 5a68c87afde0 ("soc: ti: omap-prm: dra7: add genpd support for remaining PRM instances")
Fixes: 7078a5ba7a58 ("soc: ti: omap-prm: Fix boot time errors for rst_map_012 bits 0 and 1")
Cc: Kishon Vijay Abraham I <kishon@ti.com>
Reported-by: Yongqin Liu <yongqin.liu@linaro.org>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/ti/omap_prm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/soc/ti/omap_prm.c b/drivers/soc/ti/omap_prm.c
index bf1468e5bccb..17ea6a74a988 100644
--- a/drivers/soc/ti/omap_prm.c
+++ b/drivers/soc/ti/omap_prm.c
@@ -332,7 +332,7 @@ static const struct omap_prm_data dra7_prm_data[] = {
 	{
 		.name = "l3init", .base = 0x4ae07300,
 		.pwrstctrl = 0x0, .pwrstst = 0x4, .dmap = &omap_prm_alwon,
-		.rstctrl = 0x10, .rstst = 0x14, .rstmap = rst_map_012,
+		.rstctrl = 0x10, .rstst = 0x14, .rstmap = rst_map_01,
 		.clkdm_name = "pcie"
 	},
 	{
-- 
2.30.1



