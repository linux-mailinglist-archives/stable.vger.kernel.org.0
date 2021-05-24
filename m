Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 193DB38EBB2
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:06:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234128AbhEXPGn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:06:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:37310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234247AbhEXPCV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:02:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 145D861581;
        Mon, 24 May 2021 14:50:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621867823;
        bh=fZ7ZyR35+gTZDKlGqi1NIYsxIkTtZ7Fl1Oyo9dZ3W8I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mwd602ltLbVBP8Paghleaxx44AzCazMD4gDYsm6eNnaJQQdCFRFq0V2AZ/nSku450
         Zxdfo1YndHMjVL/3to89ZV2uq6AqsBQL6RjGxS7Wjf4drHKG9NI+UfdNQh9Oo7R0AB
         aeBbRg/dYnhEeO/EpVBTZBtVuGBNBIDKPcSJWzzkmr0flgcod8eh5rNV4EIaif+ocG
         tL9+28OegEKq4w04GmEgk6mcvrdxJeN8d7ctSNqcssYFn9OOX19zAaL1DD+v8OH8V3
         2+IwYHgYv9HuU7uTEp4wiBS5x8vyfUVlL0nMYDFE+ZjyujlTZ/WToM2VoVw8//K3AM
         /dPlagytSZhdw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org,
        patches@opensource.cirrus.com
Subject: [PATCH AUTOSEL 4.19 12/25] ASoC: cs43130: handle errors in cs43130_probe() properly
Date:   Mon, 24 May 2021 10:49:55 -0400
Message-Id: <20210524145008.2499049-12-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210524145008.2499049-1-sashal@kernel.org>
References: <20210524145008.2499049-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit 2da441a6491d93eff8ffff523837fd621dc80389 ]

cs43130_probe() does not do any valid error checking of things it
initializes, OR what it does, it does not unwind properly if there are
errors.

Fix this up by moving the sysfs files to an attribute group so the
driver core will correctly add/remove them all at once and handle errors
with them, and correctly check for creating a new workqueue and
unwinding if that fails.

Cc: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20210503115736.2104747-58-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs43130.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/sound/soc/codecs/cs43130.c b/sound/soc/codecs/cs43130.c
index 80dc42197154..cf29dec28b5e 100644
--- a/sound/soc/codecs/cs43130.c
+++ b/sound/soc/codecs/cs43130.c
@@ -1738,6 +1738,14 @@ static DEVICE_ATTR(hpload_dc_r, 0444, cs43130_show_dc_r, NULL);
 static DEVICE_ATTR(hpload_ac_l, 0444, cs43130_show_ac_l, NULL);
 static DEVICE_ATTR(hpload_ac_r, 0444, cs43130_show_ac_r, NULL);
 
+static struct attribute *hpload_attrs[] = {
+	&dev_attr_hpload_dc_l.attr,
+	&dev_attr_hpload_dc_r.attr,
+	&dev_attr_hpload_ac_l.attr,
+	&dev_attr_hpload_ac_r.attr,
+};
+ATTRIBUTE_GROUPS(hpload);
+
 static struct reg_sequence hp_en_cal_seq[] = {
 	{CS43130_INT_MASK_4, CS43130_INT_MASK_ALL},
 	{CS43130_HP_MEAS_LOAD_1, 0},
@@ -2305,23 +2313,15 @@ static int cs43130_probe(struct snd_soc_component *component)
 
 	cs43130->hpload_done = false;
 	if (cs43130->dc_meas) {
-		ret = device_create_file(component->dev, &dev_attr_hpload_dc_l);
-		if (ret < 0)
-			return ret;
-
-		ret = device_create_file(component->dev, &dev_attr_hpload_dc_r);
-		if (ret < 0)
-			return ret;
-
-		ret = device_create_file(component->dev, &dev_attr_hpload_ac_l);
-		if (ret < 0)
-			return ret;
-
-		ret = device_create_file(component->dev, &dev_attr_hpload_ac_r);
-		if (ret < 0)
+		ret = sysfs_create_groups(&component->dev->kobj, hpload_groups);
+		if (ret)
 			return ret;
 
 		cs43130->wq = create_singlethread_workqueue("cs43130_hp");
+		if (!cs43130->wq) {
+			sysfs_remove_groups(&component->dev->kobj, hpload_groups);
+			return -ENOMEM;
+		}
 		INIT_WORK(&cs43130->work, cs43130_imp_meas);
 	}
 
-- 
2.30.2

