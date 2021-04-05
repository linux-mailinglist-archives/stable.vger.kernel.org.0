Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43B1C353E8E
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:34:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238336AbhDEJGp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:06:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:50968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238663AbhDEJG1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:06:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6F4B9613AA;
        Mon,  5 Apr 2021 09:06:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617613576;
        bh=QzOHOeJxuTMzMkr+1Bqy/LrnBegZu/BBTzh3ZpebcP4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PwYov9XWb+AHzQUuKryY3GMZZ4EfRvE6Qx6R10ujMD6MDPp7wZ902viqtSF/CDR7O
         WmuEJx0Y94zp+6EoJBLY6O6fVvhoPLXs+Saavlvq81DeBJM0ZY2lksHvcdwxniY7JL
         2VhHnxMZiMWPxjiaNK+wf6dfLnIyAHKgIh04n9kk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jon Hunter <jonathanh@nvidia.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 014/126] ASoC: soc-core: Prevent warning if no DMI table is present
Date:   Mon,  5 Apr 2021 10:52:56 +0200
Message-Id: <20210405085031.502558773@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085031.040238881@linuxfoundation.org>
References: <20210405085031.040238881@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 05a085f6dc7c..bf65cba232e6 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -31,6 +31,7 @@
 #include <linux/of.h>
 #include <linux/of_graph.h>
 #include <linux/dmi.h>
+#include <linux/acpi.h>
 #include <sound/core.h>
 #include <sound/jack.h>
 #include <sound/pcm.h>
@@ -1581,6 +1582,9 @@ int snd_soc_set_dmi_name(struct snd_soc_card *card, const char *flavour)
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



