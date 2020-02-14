Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E33515ED11
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:32:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388485AbgBNRbr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 12:31:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:57764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390383AbgBNQG5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:06:57 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2938322314;
        Fri, 14 Feb 2020 16:06:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696416;
        bh=6DSdMFjxgWRdypq5833DUzQbfzCUretx9y9XI87VwjY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MaLy1uiI71EZAV6y632w9nMn/KTQiU2q3XOt4pozsdWYHtuzHZirkoX8pYG7lLkWJ
         6mnRt9j1pbJLxEMkABaSX8z9SfJH5LkvKljB5YOU/LqpT77/6J28zpcZVZnC8MeEvt
         Db51kACCRo4liUfjblNkKmoR3ZxHpgcw5u9A2QC0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.4 238/459] ASoC: soc-topology: fix endianness issues
Date:   Fri, 14 Feb 2020 10:58:08 -0500
Message-Id: <20200214160149.11681-238-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214160149.11681-1-sashal@kernel.org>
References: <20200214160149.11681-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit 72bbeda0222bcd382ee33b3aff71346074410c21 ]

Sparse complains about a series of easy warnings, fix.

Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20200102195952.9465-3-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-topology.c | 42 +++++++++++++++++++++-------------------
 1 file changed, 22 insertions(+), 20 deletions(-)

diff --git a/sound/soc/soc-topology.c b/sound/soc/soc-topology.c
index fef01e1dd15c5..d00203ef8305f 100644
--- a/sound/soc/soc-topology.c
+++ b/sound/soc/soc-topology.c
@@ -604,9 +604,11 @@ static int soc_tplg_kcontrol_bind_io(struct snd_soc_tplg_ctl_hdr *hdr,
 		ext_ops = tplg->bytes_ext_ops;
 		num_ops = tplg->bytes_ext_ops_count;
 		for (i = 0; i < num_ops; i++) {
-			if (!sbe->put && ext_ops[i].id == be->ext_ops.put)
+			if (!sbe->put &&
+			    ext_ops[i].id == le32_to_cpu(be->ext_ops.put))
 				sbe->put = ext_ops[i].put;
-			if (!sbe->get && ext_ops[i].id == be->ext_ops.get)
+			if (!sbe->get &&
+			    ext_ops[i].id == le32_to_cpu(be->ext_ops.get))
 				sbe->get = ext_ops[i].get;
 		}
 
@@ -621,11 +623,11 @@ static int soc_tplg_kcontrol_bind_io(struct snd_soc_tplg_ctl_hdr *hdr,
 	num_ops = tplg->io_ops_count;
 	for (i = 0; i < num_ops; i++) {
 
-		if (k->put == NULL && ops[i].id == hdr->ops.put)
+		if (k->put == NULL && ops[i].id == le32_to_cpu(hdr->ops.put))
 			k->put = ops[i].put;
-		if (k->get == NULL && ops[i].id == hdr->ops.get)
+		if (k->get == NULL && ops[i].id == le32_to_cpu(hdr->ops.get))
 			k->get = ops[i].get;
-		if (k->info == NULL && ops[i].id == hdr->ops.info)
+		if (k->info == NULL && ops[i].id == le32_to_cpu(hdr->ops.info))
 			k->info = ops[i].info;
 	}
 
@@ -638,11 +640,11 @@ static int soc_tplg_kcontrol_bind_io(struct snd_soc_tplg_ctl_hdr *hdr,
 	num_ops = ARRAY_SIZE(io_ops);
 	for (i = 0; i < num_ops; i++) {
 
-		if (k->put == NULL && ops[i].id == hdr->ops.put)
+		if (k->put == NULL && ops[i].id == le32_to_cpu(hdr->ops.put))
 			k->put = ops[i].put;
-		if (k->get == NULL && ops[i].id == hdr->ops.get)
+		if (k->get == NULL && ops[i].id == le32_to_cpu(hdr->ops.get))
 			k->get = ops[i].get;
-		if (k->info == NULL && ops[i].id == hdr->ops.info)
+		if (k->info == NULL && ops[i].id == le32_to_cpu(hdr->ops.info))
 			k->info = ops[i].info;
 	}
 
@@ -931,7 +933,7 @@ static int soc_tplg_denum_create_texts(struct soc_enum *se,
 	if (se->dobj.control.dtexts == NULL)
 		return -ENOMEM;
 
-	for (i = 0; i < ec->items; i++) {
+	for (i = 0; i < le32_to_cpu(ec->items); i++) {
 
 		if (strnlen(ec->texts[i], SNDRV_CTL_ELEM_ID_NAME_MAXLEN) ==
 			SNDRV_CTL_ELEM_ID_NAME_MAXLEN) {
@@ -1325,7 +1327,7 @@ static struct snd_kcontrol_new *soc_tplg_dapm_widget_dmixer_create(
 		if (kc[i].name == NULL)
 			goto err_sm;
 		kc[i].iface = SNDRV_CTL_ELEM_IFACE_MIXER;
-		kc[i].access = mc->hdr.access;
+		kc[i].access = le32_to_cpu(mc->hdr.access);
 
 		/* we only support FL/FR channel mapping atm */
 		sm->reg = tplc_chan_get_reg(tplg, mc->channel,
@@ -1337,10 +1339,10 @@ static struct snd_kcontrol_new *soc_tplg_dapm_widget_dmixer_create(
 		sm->rshift = tplc_chan_get_shift(tplg, mc->channel,
 			SNDRV_CHMAP_FR);
 
-		sm->max = mc->max;
-		sm->min = mc->min;
-		sm->invert = mc->invert;
-		sm->platform_max = mc->platform_max;
+		sm->max = le32_to_cpu(mc->max);
+		sm->min = le32_to_cpu(mc->min);
+		sm->invert = le32_to_cpu(mc->invert);
+		sm->platform_max = le32_to_cpu(mc->platform_max);
 		sm->dobj.index = tplg->index;
 		INIT_LIST_HEAD(&sm->dobj.list);
 
@@ -1401,7 +1403,7 @@ static struct snd_kcontrol_new *soc_tplg_dapm_widget_denum_create(
 			goto err_se;
 
 		tplg->pos += (sizeof(struct snd_soc_tplg_enum_control) +
-				ec->priv.size);
+			      le32_to_cpu(ec->priv.size));
 
 		dev_dbg(tplg->dev, " adding DAPM widget enum control %s\n",
 			ec->hdr.name);
@@ -1411,7 +1413,7 @@ static struct snd_kcontrol_new *soc_tplg_dapm_widget_denum_create(
 		if (kc[i].name == NULL)
 			goto err_se;
 		kc[i].iface = SNDRV_CTL_ELEM_IFACE_MIXER;
-		kc[i].access = ec->hdr.access;
+		kc[i].access = le32_to_cpu(ec->hdr.access);
 
 		/* we only support FL/FR channel mapping atm */
 		se->reg = tplc_chan_get_reg(tplg, ec->channel, SNDRV_CHMAP_FL);
@@ -1420,8 +1422,8 @@ static struct snd_kcontrol_new *soc_tplg_dapm_widget_denum_create(
 		se->shift_r = tplc_chan_get_shift(tplg, ec->channel,
 						  SNDRV_CHMAP_FR);
 
-		se->items = ec->items;
-		se->mask = ec->mask;
+		se->items = le32_to_cpu(ec->items);
+		se->mask = le32_to_cpu(ec->mask);
 		se->dobj.index = tplg->index;
 
 		switch (le32_to_cpu(ec->hdr.ops.info)) {
@@ -1523,9 +1525,9 @@ static struct snd_kcontrol_new *soc_tplg_dapm_widget_dbytes_create(
 		if (kc[i].name == NULL)
 			goto err_sbe;
 		kc[i].iface = SNDRV_CTL_ELEM_IFACE_MIXER;
-		kc[i].access = be->hdr.access;
+		kc[i].access = le32_to_cpu(be->hdr.access);
 
-		sbe->max = be->max;
+		sbe->max = le32_to_cpu(be->max);
 		INIT_LIST_HEAD(&sbe->dobj.list);
 
 		/* map standard io handlers and check for external handlers */
-- 
2.20.1

