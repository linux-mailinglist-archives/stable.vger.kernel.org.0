Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 636DD3A613D
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 12:44:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233460AbhFNKpn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 06:45:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:45950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233541AbhFNKmm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 06:42:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7CC26613EF;
        Mon, 14 Jun 2021 10:35:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623666946;
        bh=d0EUx4wg6qvxXvLLpCgP6kzYXfD6HajjbSgHVQF5cyQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yN6JUrtR60doJ9UwQk2nJg+niWgiiVmGUdHVqJH3mDxvsC2/Zs/FBrGSGWQ35smQZ
         kgTC5VdKJIqFFE4SK77axiMHHsJ09M/kbcJBAbwN/EcbG84jD+pDD5epWMEQvPieKg
         KBMwz1/Swg2SaZ6wSmH3d4a0rFYazfEC/KJY2JIE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 05/67] ASoC: Intel: bytcr_rt5640: Add quirk for the Lenovo Miix 3-830 tablet
Date:   Mon, 14 Jun 2021 12:26:48 +0200
Message-Id: <20210614102643.968386334@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102643.797691914@linuxfoundation.org>
References: <20210614102643.797691914@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit f0353e1f53f92f7b3da91e6669f5d58ee222ebe8 ]

The Lenovo Miix 3-830 tablet has only 1 speaker, has an internal analog
mic on IN1 and uses JD2 for jack-detect, add a quirk to automatically
apply these settings on Lenovo Miix 3-830 tablets.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20210508150146.28403-2-hdegoede@redhat.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/bytcr_rt5640.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/sound/soc/intel/boards/bytcr_rt5640.c b/sound/soc/intel/boards/bytcr_rt5640.c
index 077529113ee7..186c0ee059da 100644
--- a/sound/soc/intel/boards/bytcr_rt5640.c
+++ b/sound/soc/intel/boards/bytcr_rt5640.c
@@ -643,6 +643,20 @@ static const struct dmi_system_id byt_rt5640_quirk_table[] = {
 					BYT_RT5640_MONO_SPEAKER |
 					BYT_RT5640_MCLK_EN),
 	},
+	{	/* Lenovo Miix 3-830 */
+		.matches = {
+			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_EXACT_MATCH(DMI_PRODUCT_VERSION, "Lenovo MIIX 3-830"),
+		},
+		.driver_data = (void *)(BYT_RT5640_IN1_MAP |
+					BYT_RT5640_JD_SRC_JD2_IN4N |
+					BYT_RT5640_OVCD_TH_2000UA |
+					BYT_RT5640_OVCD_SF_0P75 |
+					BYT_RT5640_MONO_SPEAKER |
+					BYT_RT5640_DIFF_MIC |
+					BYT_RT5640_SSP0_AIF1 |
+					BYT_RT5640_MCLK_EN),
+	},
 	{	/* Linx Linx7 tablet */
 		.matches = {
 			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "LINX"),
-- 
2.30.2



