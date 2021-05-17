Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55429383192
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:42:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240172AbhEQOh3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:37:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:34294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240903AbhEQOfZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:35:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 550BC61929;
        Mon, 17 May 2021 14:17:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261031;
        bh=0+9Xdgeq1Rpqm/DtwPbsBg2XLXCA4ICNfobY8GCq/VY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1FwRS5RH5H9A2QprOmqbV86j2AWb8OTmdAtvQekAeiwfW01ECKdFA3VD/Kw/DW15+
         VBov7hGHKIL00MRHjkL3LknyM4KeziOb9O3FCCSurCw609SzJiDOKw3ZXMjCqK4cZI
         knY9ENehVXp0MwVDY8HwMvJH6gB+xWZG9DTCYN9w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 046/329] ASoC: rt5670: Add a quirk for the Dell Venue 10 Pro 5055
Date:   Mon, 17 May 2021 15:59:17 +0200
Message-Id: <20210517140303.601586364@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.043055203@linuxfoundation.org>
References: <20210517140302.043055203@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 84cb0d5581b6a7bd5d96013f67e9f2eb0c7b4378 ]

Add a quirk with the jack-detect and dmic settings necessary to make
jack-detect and the builtin mic work on Dell Venue 10 Pro 5055 tablets.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20210402140747.174716-5-hdegoede@redhat.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt5670.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/sound/soc/codecs/rt5670.c b/sound/soc/codecs/rt5670.c
index a0c8f58d729b..47ce074289ca 100644
--- a/sound/soc/codecs/rt5670.c
+++ b/sound/soc/codecs/rt5670.c
@@ -2908,6 +2908,18 @@ static const struct dmi_system_id dmi_platform_intel_quirks[] = {
 						 RT5670_GPIO1_IS_IRQ |
 						 RT5670_JD_MODE3),
 	},
+	{
+		.callback = rt5670_quirk_cb,
+		.ident = "Dell Venue 10 Pro 5055",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Venue 10 Pro 5055"),
+		},
+		.driver_data = (unsigned long *)(RT5670_DMIC_EN |
+						 RT5670_DMIC2_INR |
+						 RT5670_GPIO1_IS_IRQ |
+						 RT5670_JD_MODE1),
+	},
 	{
 		.callback = rt5670_quirk_cb,
 		.ident = "Aegex 10 tablet (RU2)",
-- 
2.30.2



