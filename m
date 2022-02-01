Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 723544A60D2
	for <lists+stable@lfdr.de>; Tue,  1 Feb 2022 16:57:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240740AbiBAP5O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Feb 2022 10:57:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237158AbiBAP5O (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Feb 2022 10:57:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AEF3C061714
        for <stable@vger.kernel.org>; Tue,  1 Feb 2022 07:57:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 650E2B82EBD
        for <stable@vger.kernel.org>; Tue,  1 Feb 2022 15:57:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDEDDC340F0;
        Tue,  1 Feb 2022 15:57:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643731031;
        bh=vyfCmVN4cP8EJFev5OlGD4JMevMybuuoL0d1c6/ahXU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rFLvO9q33ilRsyRpuuaAOyMwzfnEoc7VwsL6ZG/E/GFi0kGaR8pit7H+026pKe+8w
         Rfis/CFcufQzJ6Njb4phuaXcR2dEbvlxbYus9esOd7+PoTL5bJEhzJAzhu1dHZUIp4
         aapswsTlHupOn5poJo/5vpw7emw/H5qfQ8kqvsUBDEKZxF0Qld3sO3vHOYpkwBmK8D
         DcG7WlWqibaTeCx6cmYujEMSyK3SgKY/sEdUVWgMYpnYAnj6zsp347PYio9D6U4fou
         DP5Aricyd1HsDnC5LHNbOuWXzppgKsGxEGLspr3pKafcyPzH54t5InAP8NyeP6yzdF
         IJVrjNT2YKBVQ==
From:   Mark Brown <broonie@kernel.org>
To:     Liam Girdwood <lgirdwood@gmail.com>
Cc:     alsa-devel@alsa-project.org, Mark Brown <broonie@kernel.org>,
        stable@vger.kernel.org
Subject: [PATCH v1 1/4] ASoC: ops: Fix stereo change notifications in snd_soc_put_volsw()
Date:   Tue,  1 Feb 2022 15:56:26 +0000
Message-Id: <20220201155629.120510-2-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220201155629.120510-1-broonie@kernel.org>
References: <20220201155629.120510-1-broonie@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1412; h=from:subject; bh=vyfCmVN4cP8EJFev5OlGD4JMevMybuuoL0d1c6/ahXU=; b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBh+Vgqyj3RRowfIomn2gl40mR6v6m93MVSOT9peFNo UnaPOZCJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCYflYKgAKCRAk1otyXVSH0PoFB/ 4r5HJraZKdm/GamVCaxo8UcM5+n/RiGAWKCHOE3U7GZt9DlAU20uvlPf9A/Co1camFVTuc+//1wa4O dqHJIbCQK4lt+DK0fMaI62GQLqbTAf0Mzsef7E5zG5eJhhOELAjkhEhYMRH/2Yu5BWqqJqox+RIZnD O7W8h6en+X9MNjnBp59/YOSTJ5yy+9cZPadfvWbrp0scKufNBK/jj4AWfjobowyowrqvi+GxGcyM3H ldaBWnjKpNQw3+MKjUGAetYixsGrXuIx9y9LbEN6rOXTVvj04sXJijjAv8hFhDyM+Y3BF3/wkyekvW 3IVNjvYdR2LUL8tWToITRzAnLjj/+9
X-Developer-Key: i=broonie@kernel.org; a=openpgp; fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When writing out a stereo control we discard the change notification from
the first channel, meaning that events are only generated based on changes
to the second channel. Ensure that we report a change if either channel
has changed.

Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: stable@vger.kernel.org
---
 sound/soc/soc-ops.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/sound/soc/soc-ops.c b/sound/soc/soc-ops.c
index 08eaa9ddf191..73c9d53de25b 100644
--- a/sound/soc/soc-ops.c
+++ b/sound/soc/soc-ops.c
@@ -308,7 +308,7 @@ int snd_soc_put_volsw(struct snd_kcontrol *kcontrol,
 	unsigned int sign_bit = mc->sign_bit;
 	unsigned int mask = (1 << fls(max)) - 1;
 	unsigned int invert = mc->invert;
-	int err;
+	int err, ret;
 	bool type_2r = false;
 	unsigned int val2 = 0;
 	unsigned int val, val_mask;
@@ -336,12 +336,18 @@ int snd_soc_put_volsw(struct snd_kcontrol *kcontrol,
 	err = snd_soc_component_update_bits(component, reg, val_mask, val);
 	if (err < 0)
 		return err;
+	ret = err;
 
-	if (type_2r)
+	if (type_2r) {
 		err = snd_soc_component_update_bits(component, reg2, val_mask,
-			val2);
+						    val2);
+		/* Don't discard any error code or drop change flag */
+		if (ret == 0 || err < 0) {
+			ret = err;
+		}
+	}
 
-	return err;
+	return ret;
 }
 EXPORT_SYMBOL_GPL(snd_soc_put_volsw);
 
-- 
2.30.2

