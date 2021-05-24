Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D11A38EB32
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:00:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233227AbhEXPBQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:01:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:34172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233460AbhEXO67 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 10:58:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 61E7F61460;
        Mon, 24 May 2021 14:49:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621867779;
        bh=ZqLak8BtxpSBoSac6F+jFOun1e3iSVOTf+B9UAhpitk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g0Y8dHBB9Q/9/13NDSJHfQNZwEaW+OvLZB23QG2ZJUFrBiQMb+nItxGsfwfTVdUBx
         7LnrpJZgzKAtfifTI4L4c2RSMdM0RdQ3bJcEtNRihVbI9dgIWXGslKfN7pG3Tf1mAL
         e+uoq3to3YE0yTLoCIPcjMZI77qwzRBZbkMDtqJNku3eMvDc0WTXue/uyIRO7QlKfJ
         9TX6zdalp2ZtfDSeAjsmGi7JnlWSf75h3Ra/TVQICgdPfXT3ryBnOc6SEkDxAcA9aJ
         eGUmM1DKemVmHlQtNWbVGsgciqWrzjB1uZjuTbJSu3kJPnjnwuNg3S3+ZH/xlzP9oF
         6BhZ9KW972e4A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org,
        patches@opensource.cirrus.com
Subject: [PATCH AUTOSEL 5.4 29/52] ASoC: cs43130: handle errors in cs43130_probe() properly
Date:   Mon, 24 May 2021 10:48:39 -0400
Message-Id: <20210524144903.2498518-29-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210524144903.2498518-1-sashal@kernel.org>
References: <20210524144903.2498518-1-sashal@kernel.org>
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
index bb46e993c353..8f70dee95878 100644
--- a/sound/soc/codecs/cs43130.c
+++ b/sound/soc/codecs/cs43130.c
@@ -1735,6 +1735,14 @@ static DEVICE_ATTR(hpload_dc_r, 0444, cs43130_show_dc_r, NULL);
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
@@ -2302,23 +2310,15 @@ static int cs43130_probe(struct snd_soc_component *component)
 
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

