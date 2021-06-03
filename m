Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63AE039A7FC
	for <lists+stable@lfdr.de>; Thu,  3 Jun 2021 19:11:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232846AbhFCRN1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Jun 2021 13:13:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:43558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232684AbhFCRMH (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Jun 2021 13:12:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ED0D861418;
        Thu,  3 Jun 2021 17:10:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622740203;
        bh=yzoWExcW1c5i7/lzVcVXYieuT2+fWopdCVviHmOuSOw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XJ06qnTa/e+bMkY027Fy6XdaETmFkGB5hJ3PasxfwDTH/heQLQbu8bmiX2fco9N6R
         d/059gZM/oABIPUAda6oxR6ta+moNdwpmZUPlSVQJKSUv7T0f6WFAsNgW/N32zlVLm
         garFcXMGaKY9djWlg5qBBTUJxAmIym1U2XVNui3NUUH5lWnWbyw+9KUC3cC+laBJKs
         24JCqj7DZe32NPNx4Dv+B7UxSAlQTnINL6xRVjuyz3oAkeV8Me57bA3/yqd3y5zlCy
         4VKpt2tx54gkA9KGYIbo98ZwvF/UvdlGe87JB62ytvUaNdlFIdQoG7RUK5rlpm1mh5
         MqeY77/vpoPUQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 4.19 03/23] ASoC: Intel: bytcr_rt5640: Add quirk for the Glavey TM800A550L tablet
Date:   Thu,  3 Jun 2021 13:09:39 -0400
Message-Id: <20210603170959.3169420-3-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210603170959.3169420-1-sashal@kernel.org>
References: <20210603170959.3169420-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 28c268d3acdd4cbcd2ac320b85609e77f84e74a7 ]

Add a quirk for the Glavey TM800A550L tablet, this BYTCR tablet has no CHAN
package in its ACPI tables and uses SSP0-AIF1 rather then SSP0-AIF2 which
is the default for BYTCR devices.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20210508150146.28403-1-hdegoede@redhat.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/bytcr_rt5640.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/sound/soc/intel/boards/bytcr_rt5640.c b/sound/soc/intel/boards/bytcr_rt5640.c
index 4ebc023f1507..077529113ee7 100644
--- a/sound/soc/intel/boards/bytcr_rt5640.c
+++ b/sound/soc/intel/boards/bytcr_rt5640.c
@@ -565,6 +565,17 @@ static const struct dmi_system_id byt_rt5640_quirk_table[] = {
 					BYT_RT5640_SSP0_AIF1 |
 					BYT_RT5640_MCLK_EN),
 	},
+	{	/* Glavey TM800A550L */
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "AMI Corporation"),
+			DMI_MATCH(DMI_BOARD_NAME, "Aptio CRB"),
+			/* Above strings are too generic, also match on BIOS version */
+			DMI_MATCH(DMI_BIOS_VERSION, "ZY-8-BI-PX4S70VTR400-X423B-005-D"),
+		},
+		.driver_data = (void *)(BYTCR_INPUT_DEFAULTS |
+					BYT_RT5640_SSP0_AIF1 |
+					BYT_RT5640_MCLK_EN),
+	},
 	{
 		.matches = {
 			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
-- 
2.30.2

