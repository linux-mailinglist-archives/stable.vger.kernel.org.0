Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0042D3EE100
	for <lists+stable@lfdr.de>; Tue, 17 Aug 2021 02:35:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235462AbhHQAgP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 20:36:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:34894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235363AbhHQAgM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 20:36:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 391F060FA0;
        Tue, 17 Aug 2021 00:35:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629160540;
        bh=d6nwFUt6VjHfJhTwsTeTPvBApRxDuqUwS984hXWMpVQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gFEgwmkGLmTjwxZJ4XL0cM+dpO52CMYP7GrmroAyg+8WYxwyw7rd3xVB5o7z3cpca
         1xIaFt+1AYxrj4Vi90oF95Em2iNAOn6MHFzjrEyzV9tCAnnJSoFrLRLtj/Bh7KkoEk
         8EAO7ZLRJco0hRvUWV0H818K7UDOteVX+C9Y+oM4kaHueQGkxseWF/wRDnT0IUVV5P
         CGqX5hGzpHimuxSix+V65Msqom/+vP9+z1QuR4xhGa923ZS/E8r/NtYia4tBfWltYZ
         O1uDrwrb3rmEQ5rJGnUz2OORaRusnagPL4yC1bO6x53iackEQEkKcNyDSX1wKT9Pcs
         XLL7bnN+zyiCg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mark Brown <broonie@kernel.org>,
        Richard Fitzgerald <rf@opensource.cirrus.com>,
        Lucas Tanure <tanureal@opensource.cirrus.com>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.13 02/12] ASoC: component: Remove misplaced prefix handling in pin control functions
Date:   Mon, 16 Aug 2021 20:35:26 -0400
Message-Id: <20210817003536.83063-2-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210817003536.83063-1-sashal@kernel.org>
References: <20210817003536.83063-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Brown <broonie@kernel.org>

[ Upstream commit 31428c78748cafdd9352e1f622eb89bf453d9700 ]

When the component level pin control functions were added they for some
no longer obvious reason handled adding prefixing of widget names. This
meant that when the lack of prefix handling in the DAPM level pin
operations was fixed by ae4fc532244b3bb4d (ASoC: dapm: use component
prefix when checking widget names) the one device using the component
level API ended up with the prefix being applied twice, causing all
lookups to fail.

Fix this by removing the redundant prefixing from the component code,
which has the nice side effect of also making that code much simpler.

Reported-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Tested-by: Lucas Tanure <tanureal@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20210726194123.54585-1-broonie@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-component.c | 63 +++++++++++++++++----------------------
 1 file changed, 27 insertions(+), 36 deletions(-)

diff --git a/sound/soc/soc-component.c b/sound/soc/soc-component.c
index 3a5e84e16a87..c8dfd0de30e4 100644
--- a/sound/soc/soc-component.c
+++ b/sound/soc/soc-component.c
@@ -148,86 +148,75 @@ int snd_soc_component_set_bias_level(struct snd_soc_component *component,
 	return soc_component_ret(component, ret);
 }
 
-static int soc_component_pin(struct snd_soc_component *component,
-			     const char *pin,
-			     int (*pin_func)(struct snd_soc_dapm_context *dapm,
-					     const char *pin))
-{
-	struct snd_soc_dapm_context *dapm =
-		snd_soc_component_get_dapm(component);
-	char *full_name;
-	int ret;
-
-	if (!component->name_prefix) {
-		ret = pin_func(dapm, pin);
-		goto end;
-	}
-
-	full_name = kasprintf(GFP_KERNEL, "%s %s", component->name_prefix, pin);
-	if (!full_name) {
-		ret = -ENOMEM;
-		goto end;
-	}
-
-	ret = pin_func(dapm, full_name);
-	kfree(full_name);
-end:
-	return soc_component_ret(component, ret);
-}
-
 int snd_soc_component_enable_pin(struct snd_soc_component *component,
 				 const char *pin)
 {
-	return soc_component_pin(component, pin, snd_soc_dapm_enable_pin);
+	struct snd_soc_dapm_context *dapm =
+		snd_soc_component_get_dapm(component);
+	return snd_soc_dapm_enable_pin(dapm, pin);
 }
 EXPORT_SYMBOL_GPL(snd_soc_component_enable_pin);
 
 int snd_soc_component_enable_pin_unlocked(struct snd_soc_component *component,
 					  const char *pin)
 {
-	return soc_component_pin(component, pin, snd_soc_dapm_enable_pin_unlocked);
+	struct snd_soc_dapm_context *dapm =
+		snd_soc_component_get_dapm(component);
+	return snd_soc_dapm_enable_pin_unlocked(dapm, pin);
 }
 EXPORT_SYMBOL_GPL(snd_soc_component_enable_pin_unlocked);
 
 int snd_soc_component_disable_pin(struct snd_soc_component *component,
 				  const char *pin)
 {
-	return soc_component_pin(component, pin, snd_soc_dapm_disable_pin);
+	struct snd_soc_dapm_context *dapm =
+		snd_soc_component_get_dapm(component);
+	return snd_soc_dapm_disable_pin(dapm, pin);
 }
 EXPORT_SYMBOL_GPL(snd_soc_component_disable_pin);
 
 int snd_soc_component_disable_pin_unlocked(struct snd_soc_component *component,
 					   const char *pin)
 {
-	return soc_component_pin(component, pin, snd_soc_dapm_disable_pin_unlocked);
+	struct snd_soc_dapm_context *dapm = 
+		snd_soc_component_get_dapm(component);
+	return snd_soc_dapm_disable_pin_unlocked(dapm, pin);
 }
 EXPORT_SYMBOL_GPL(snd_soc_component_disable_pin_unlocked);
 
 int snd_soc_component_nc_pin(struct snd_soc_component *component,
 			     const char *pin)
 {
-	return soc_component_pin(component, pin, snd_soc_dapm_nc_pin);
+	struct snd_soc_dapm_context *dapm =
+		snd_soc_component_get_dapm(component);
+	return snd_soc_dapm_nc_pin(dapm, pin);
 }
 EXPORT_SYMBOL_GPL(snd_soc_component_nc_pin);
 
 int snd_soc_component_nc_pin_unlocked(struct snd_soc_component *component,
 				      const char *pin)
 {
-	return soc_component_pin(component, pin, snd_soc_dapm_nc_pin_unlocked);
+	struct snd_soc_dapm_context *dapm =
+		snd_soc_component_get_dapm(component);
+	return snd_soc_dapm_nc_pin_unlocked(dapm, pin);
 }
 EXPORT_SYMBOL_GPL(snd_soc_component_nc_pin_unlocked);
 
 int snd_soc_component_get_pin_status(struct snd_soc_component *component,
 				     const char *pin)
 {
-	return soc_component_pin(component, pin, snd_soc_dapm_get_pin_status);
+	struct snd_soc_dapm_context *dapm =
+		snd_soc_component_get_dapm(component);
+	return snd_soc_dapm_get_pin_status(dapm, pin);
 }
 EXPORT_SYMBOL_GPL(snd_soc_component_get_pin_status);
 
 int snd_soc_component_force_enable_pin(struct snd_soc_component *component,
 				       const char *pin)
 {
-	return soc_component_pin(component, pin, snd_soc_dapm_force_enable_pin);
+	struct snd_soc_dapm_context *dapm =
+		snd_soc_component_get_dapm(component);
+	return snd_soc_dapm_force_enable_pin(dapm, pin);
 }
 EXPORT_SYMBOL_GPL(snd_soc_component_force_enable_pin);
 
@@ -235,7 +224,9 @@ int snd_soc_component_force_enable_pin_unlocked(
 	struct snd_soc_component *component,
 	const char *pin)
 {
-	return soc_component_pin(component, pin, snd_soc_dapm_force_enable_pin_unlocked);
+	struct snd_soc_dapm_context *dapm =
+		snd_soc_component_get_dapm(component);
+	return snd_soc_dapm_force_enable_pin_unlocked(dapm, pin);
 }
 EXPORT_SYMBOL_GPL(snd_soc_component_force_enable_pin_unlocked);
 
-- 
2.30.2

