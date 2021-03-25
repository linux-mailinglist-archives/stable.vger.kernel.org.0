Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55EC4348EFD
	for <lists+stable@lfdr.de>; Thu, 25 Mar 2021 12:26:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230233AbhCYLZf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Mar 2021 07:25:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:33738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230085AbhCYLZS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Mar 2021 07:25:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5637961A2C;
        Thu, 25 Mar 2021 11:25:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616671518;
        bh=5mITberqG7UgwW6RZuOELf841627VhEq59zXJ/OyvFo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Np3dwTTufqkJ+YhSer5+jF9dTewgZGePyFfA0S9F4/zuenuL9a43UtbA6xQN7k5L4
         P57OjoHBY1lqEpr947wOnYsHDKvNwBn35yDIejgZIP0Tj+uHEBf+85k4h+y2misLah
         EtbPQBzOJDhCirdjhGXNk6b74ChQc9iIdfYGvEaU7sJZagiDkb3JmS35bU3i6ieGRZ
         PaJOoJ012n7yRRBaDWtCbbUJxvyb9J1XIkFDAAxLgK5ud4lPoKLOH6YOaH4vCdTfe0
         EJX47URzrmaetDfcEGVK2JIRiEaUKAjoyQtQcT2FdsHA10RwVDyVIsHYtZRtsFCNpo
         czaXn1PiGnrbg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jon Hunter <jonathanh@nvidia.com>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.11 14/44] ASoC: soc-core: Prevent warning if no DMI table is present
Date:   Thu, 25 Mar 2021 07:24:29 -0400
Message-Id: <20210325112459.1926846-14-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210325112459.1926846-1-sashal@kernel.org>
References: <20210325112459.1926846-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jon Hunter <jonathanh@nvidia.com>

[ Upstream commit 7de14d581dbed57c2b3c6afffa2c3fdc6955a3cd ]

Many systems do not use ACPI and hence do not provide a DMI table. On
non-ACPI systems a warning, such as the following, is printed on boot.

 WARNING KERN tegra-audio-graph-card sound: ASoC: no DMI vendor name!

The variable 'dmi_available' is not exported and so currently cannot be
used by kernel modules without adding an accessor. However, it is
possible to use the function is_acpi_device_node() to determine if the
sound card is an ACPI device and hence indicate if we expect a DMI table
to be present. Therefore, call is_acpi_device_node() to see if we are
using ACPI and only parse the DMI table if we are booting with ACPI.

Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
Link: https://lore.kernel.org/r/20210303115526.419458-1-jonathanh@nvidia.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-core.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
index f6d4e99b590c..0cffc9527e28 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -31,6 +31,7 @@
 #include <linux/of.h>
 #include <linux/of_graph.h>
 #include <linux/dmi.h>
+#include <linux/acpi.h>
 #include <sound/core.h>
 #include <sound/pcm.h>
 #include <sound/pcm_params.h>
@@ -1573,6 +1574,9 @@ int snd_soc_set_dmi_name(struct snd_soc_card *card, const char *flavour)
 	if (card->long_name)
 		return 0; /* long name already set by driver or from DMI */
 
+	if (!is_acpi_device_node(card->dev->fwnode))
+		return 0;
+
 	/* make up dmi long name as: vendor-product-version-board */
 	vendor = dmi_get_system_info(DMI_BOARD_VENDOR);
 	if (!vendor || !is_dmi_valid(vendor)) {
-- 
2.30.1

