Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7054FD158D
	for <lists+stable@lfdr.de>; Wed,  9 Oct 2019 19:24:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732121AbfJIRYG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Oct 2019 13:24:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:48592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732108AbfJIRYF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Oct 2019 13:24:05 -0400
Received: from sasha-vm.mshome.net (unknown [167.220.2.234])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 39229222BD;
        Wed,  9 Oct 2019 17:24:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570641845;
        bh=hgWiUJDqFhtiAu2EufDq0H/kyP+i6BeWCEBmU9Aiu3U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WrWEUih8E7BWeS6xn+OyrF5GCN5QHYV06QSef4tXlbDr2aSbfmFZoXQRkfdS4bbXt
         Uxod9siqTCSXBrdg5hXcYRS6fGpbmx2Ilycg4DQSrZI015wwWBayPBx2C7DqVvplMe
         iGN+UZwJSVF4RBgYJQYYnlG+9VuEHdk6GImUxpMU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tony Lindgren <tony@atomide.com>, Sasha Levin <sashal@kernel.org>,
        linux-omap@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 06/26] ARM: OMAP2+: Fix missing reset done flag for am3 and am43
Date:   Wed,  9 Oct 2019 13:05:38 -0400
Message-Id: <20191009170558.32517-6-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191009170558.32517-1-sashal@kernel.org>
References: <20191009170558.32517-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit 8ad8041b98c665b6147e607b749586d6e20ba73a ]

For ti,sysc-omap4 compatible devices with no sysstatus register, we do have
reset done status available in the SOFTRESET bit that clears when the reset
is done. This is documented for example in am437x TRM for DMTIMER_TIOCP_CFG
register. The am335x TRM just says that SOFTRESET bit value 1 means reset is
ongoing, but it behaves the same way clearing after reset is done.

With the ti-sysc driver handling this automatically based on no sysstatus
register defined, we see warnings if SYSC_HAS_RESET_STATUS is missing in the
legacy platform data:

ti-sysc 48042000.target-module: sysc_flags 00000222 != 00000022
ti-sysc 48044000.target-module: sysc_flags 00000222 != 00000022
ti-sysc 48046000.target-module: sysc_flags 00000222 != 00000022
...

Let's fix these warnings by adding SYSC_HAS_RESET_STATUS. Let's also
remove the useless parentheses while at it.

If it turns out we do have ti,sysc-omap4 compatible devices without a
working SOFTRESET bit we can set up additional quirk handling for it.

Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-omap2/omap_hwmod_33xx_43xx_ipblock_data.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-omap2/omap_hwmod_33xx_43xx_ipblock_data.c b/arch/arm/mach-omap2/omap_hwmod_33xx_43xx_ipblock_data.c
index 9ded7bf972e71..3b8fe014a3e94 100644
--- a/arch/arm/mach-omap2/omap_hwmod_33xx_43xx_ipblock_data.c
+++ b/arch/arm/mach-omap2/omap_hwmod_33xx_43xx_ipblock_data.c
@@ -946,7 +946,8 @@ static struct omap_hwmod_class_sysconfig am33xx_timer_sysc = {
 	.rev_offs	= 0x0000,
 	.sysc_offs	= 0x0010,
 	.syss_offs	= 0x0014,
-	.sysc_flags	= (SYSC_HAS_SIDLEMODE | SYSC_HAS_SOFTRESET),
+	.sysc_flags	= SYSC_HAS_SIDLEMODE | SYSC_HAS_SOFTRESET |
+			  SYSC_HAS_RESET_STATUS,
 	.idlemodes	= (SIDLE_FORCE | SIDLE_NO | SIDLE_SMART |
 			  SIDLE_SMART_WKUP),
 	.sysc_fields	= &omap_hwmod_sysc_type2,
-- 
2.20.1

