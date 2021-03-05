Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3264132EA10
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:38:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232105AbhCEMgI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:36:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:48436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229901AbhCEMgB (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:36:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4E90165004;
        Fri,  5 Mar 2021 12:36:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614947760;
        bh=5pLIBrGcrGGo/t1daVCjK9MoHkca4h837IwbcbBBmG0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KRksh2k/CLOEjynntBRvpdlC6gLiPlYi9sCq+dZHgV6D8WCSrhlfayRV1QrZldf1T
         9l+n5B6Hl0n84UXjkShh+gm9kuHO8sBW4hZrkbhzxpPPh4U2HoCsYShpYk+QpRdRfm
         T1gol02FIUnVVOKS2z3hhT267aaEYZdt8U5ujkRw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 59/72] ASoC: Intel: bytcr_rt5651: Add quirk for the Jumper EZpad 7 tablet
Date:   Fri,  5 Mar 2021 13:22:01 +0100
Message-Id: <20210305120900.232006142@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210305120857.341630346@linuxfoundation.org>
References: <20210305120857.341630346@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit df8359c512fa770ffa6b0b0309807d9b9825a47f ]

Add a DMI quirk for the Jumper EZpad 7 tablet, this tablet has
a jack-detect switch which reads 1/high when a jack is inserted,
rather then using the standard active-low setup which most
jack-detect switches use. All other settings are using the defaults.

Add a DMI-quirk setting the defaults + the BYT_RT5651_JD_NOT_INV
flags for this.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20210216213555.36555-4-hdegoede@redhat.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/bytcr_rt5651.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/sound/soc/intel/boards/bytcr_rt5651.c b/sound/soc/intel/boards/bytcr_rt5651.c
index 4606f6f582d6..921c09cdb480 100644
--- a/sound/soc/intel/boards/bytcr_rt5651.c
+++ b/sound/soc/intel/boards/bytcr_rt5651.c
@@ -435,6 +435,19 @@ static const struct dmi_system_id byt_rt5651_quirk_table[] = {
 					BYT_RT5651_SSP0_AIF1 |
 					BYT_RT5651_MONO_SPEAKER),
 	},
+	{
+		/* Jumper EZpad 7 */
+		.callback = byt_rt5651_quirk_cb,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Jumper"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "EZpad"),
+			/* Jumper12x.WJ2012.bsBKRCP05 with the version dropped */
+			DMI_MATCH(DMI_BIOS_VERSION, "Jumper12x.WJ2012.bsBKRCP"),
+		},
+		.driver_data = (void *)(BYT_RT5651_DEFAULT_QUIRKS |
+					BYT_RT5651_IN2_MAP |
+					BYT_RT5651_JD_NOT_INV),
+	},
 	{
 		/* KIANO SlimNote 14.2 */
 		.callback = byt_rt5651_quirk_cb,
-- 
2.30.1



