Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB04732E877
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:27:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231534AbhCEM05 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:26:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:34368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231669AbhCEM0s (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:26:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E1A006502C;
        Fri,  5 Mar 2021 12:26:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614947208;
        bh=wSc8CuSoMyij4zh1jZMhcgXiidQnd1mA7kB/9GWG2xg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VBfwki1qTzNRGwSsrSkjKt/F4IaDP9Y0EYCTmVvNuKAp2n4LbaFsI6PGOvl6KD6PZ
         XGlMvXdO/09slwvPlNtKwrToe0uofheGiKh0tyAbmc55VJCGRQnjCOK3O6Dsnl//Fa
         yLoJj3rH4sQofmVhS1mSArmFP4sz5rn0iEfnQieY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 087/104] ASoC: Intel: bytcr_rt5651: Add quirk for the Jumper EZpad 7 tablet
Date:   Fri,  5 Mar 2021 13:21:32 +0100
Message-Id: <20210305120907.436348698@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210305120903.166929741@linuxfoundation.org>
References: <20210305120903.166929741@linuxfoundation.org>
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
index f289ec8563a1..148b7b1bd3e8 100644
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



