Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53BA8469C91
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:20:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347922AbhLFPXi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:23:38 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:40032 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347711AbhLFPVg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:21:36 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 87E7161329;
        Mon,  6 Dec 2021 15:18:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68EEDC341C1;
        Mon,  6 Dec 2021 15:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638803886;
        bh=p15ZnFikex20BkbZRjpWjfG734+ljeA7LYKNoXvuQnM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jKHHAxqwNMjMU4az6P1GYlpJFbkiAY2nAhri+q/rMgktFeFiR+trNaQUSBrj4kl2O
         LkTkoXfPHp12nBbFpnWMbOyivsVb5K4a05kVf4fGGF+b9yb9dGzX8+EwsW9Wjow8zO
         n4IdvQWe2XlwPouuyvUlNYZXKBzBjAzaGUZoVkjQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sameer Pujar <spujar@nvidia.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Mark Brown <broonie@kernel.org>, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 082/130] ASoC: tegra: Fix kcontrol put callback in AHUB
Date:   Mon,  6 Dec 2021 15:56:39 +0100
Message-Id: <20211206145602.499758849@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145559.607158688@linuxfoundation.org>
References: <20211206145559.607158688@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sameer Pujar <spujar@nvidia.com>

commit a4e37950c9e9b126f9cbee79b8ab94a94646dcf1 upstream.

The kcontrol put callback is expected to return 1 when there is change
in HW or when the update is acknowledged by driver. This would ensure
that change notifications are sent to subscribed applications. Update
the AHUB driver accordingly.

Fixes: 16e1bcc2caf4 ("ASoC: tegra: Add Tegra210 based AHUB driver")
Signed-off-by: Sameer Pujar <spujar@nvidia.com>
Suggested-by: Jaroslav Kysela <perex@perex.cz>
Suggested-by: Mark Brown <broonie@kernel.org>
Reviewed-by: Takashi Iwai <tiwai@suse.de>
Link: https://lore.kernel.org/r/1637219231-406-12-git-send-email-spujar@nvidia.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/tegra/tegra210_ahub.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/sound/soc/tegra/tegra210_ahub.c
+++ b/sound/soc/tegra/tegra210_ahub.c
@@ -62,6 +62,7 @@ static int tegra_ahub_put_value_enum(str
 	unsigned int *item = uctl->value.enumerated.item;
 	unsigned int value = e->values[item[0]];
 	unsigned int i, bit_pos, reg_idx = 0, reg_val = 0;
+	int change = 0;
 
 	if (item[0] >= e->items)
 		return -EINVAL;
@@ -86,12 +87,14 @@ static int tegra_ahub_put_value_enum(str
 
 		/* Update widget power if state has changed */
 		if (snd_soc_component_test_bits(cmpnt, update[i].reg,
-						update[i].mask, update[i].val))
-			snd_soc_dapm_mux_update_power(dapm, kctl, item[0], e,
-						      &update[i]);
+						update[i].mask,
+						update[i].val))
+			change |= snd_soc_dapm_mux_update_power(dapm, kctl,
+								item[0], e,
+								&update[i]);
 	}
 
-	return 0;
+	return change;
 }
 
 static struct snd_soc_dai_driver tegra210_ahub_dais[] = {


