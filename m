Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56B9049839E
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 16:33:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234218AbiAXPd5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 10:33:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231408AbiAXPd5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 10:33:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60D91C06173D
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 07:33:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 093BBB810E7
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 15:33:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC587C340E5;
        Mon, 24 Jan 2022 15:33:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643038434;
        bh=+kjikJbyX399n8l4YflLelzMjQvpmTCrZ53Skgl4Wow=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PiY/5+LebGVnVcRv12epRwh9GBgt7ihfy/GW1+ug3+xb5aBevE0uUMabcMQLsd7oT
         AlKxuiSaN4BDEM5ogMpAjvmP/3fPd/Guxchl2fP3bEtGD0tHeIqSRILVGk1gx/J92l
         GhcMWMLIy6METfxBcdYDj7zYo0CeYokmJz1/TYK8n65N23hgbeTAPwooXpxO/wXSos
         gQsvW9alv4jhNHicMvWYbtTtHnuAO+yP7m4H+wvHcX22o/CXdRbwvzAkqwHG2qLtse
         StFoFmWFUbYSSpzDl26rwZOvxoX8mogio3W5evYV4zgsnsRR7V1yvyGBcsDZIArVAB
         dkNxBzxvuwMSA==
From:   Mark Brown <broonie@kernel.org>
To:     Liam Girdwood <lgirdwood@gmail.com>
Cc:     alsa-devel@alsa-project.org, Mark Brown <broonie@kernel.org>,
        stable@vger.kernel.org
Subject: [PATCH v1 2/3] ASoC: ops: Reject out of bounds values in snd_soc_put_volsw_sx()
Date:   Mon, 24 Jan 2022 15:32:52 +0000
Message-Id: <20220124153253.3548853-3-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220124153253.3548853-1-broonie@kernel.org>
References: <20220124153253.3548853-1-broonie@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1041; h=from:subject; bh=+kjikJbyX399n8l4YflLelzMjQvpmTCrZ53Skgl4Wow=; b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBh7sajUonxcZUECf7NrKKuplLQtpL6DGJ0fCoa8VRN DdN8i+GJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCYe7GowAKCRAk1otyXVSH0L/WB/ 4oX3rubzi3wIUKvCjUETO3MCs6jkJxZSYSSVXstEcuV9nYfE+hPsG6BmKluWzNPwoBLzpunV6DFZ4Z oV6r2gm2XHc/5IePEH4aGs2X9fCAX6Gz7VZLysiTuqVpB+ANtfDfXiJqG9n6yTk3+M0J9l/Q+F/d22 VWc9HCleWQ71Wz7kplzGwp1SF1GK6Ns7PrNZHtH2pu2ovbhiRbf1M0LFCkL8CsavvpJ/e4rBV9MPaQ P6ccATfgAsltv4UWy4xU1UsNnvU4IQpvu04U7xmIvzjbgMq8XqspqMYHxIYk2jPiMbu9+UI/ASbpzb nSyPRULGSRlX1FSAWHiM0uYsQsCkfD
X-Developer-Key: i=broonie@kernel.org; a=openpgp; fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

We don't currently validate that the values being set are within the range
we advertised to userspace as being valid, do so and reject any values
that are out of range.

Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: stable@vger.kernel.org
---
 sound/soc/soc-ops.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/sound/soc/soc-ops.c b/sound/soc/soc-ops.c
index fbe5d326b0f2..c31e63b27193 100644
--- a/sound/soc/soc-ops.c
+++ b/sound/soc/soc-ops.c
@@ -423,8 +423,15 @@ int snd_soc_put_volsw_sx(struct snd_kcontrol *kcontrol,
 	int err = 0;
 	unsigned int val, val_mask;
 
+	val = ucontrol->value.integer.value[0];
+	if (mc->platform_max && val > mc->platform_max)
+		return -EINVAL;
+	if (val > max - min)
+		return -EINVAL;
+	if (val < 0)
+		return -EINVAL;
 	val_mask = mask << shift;
-	val = (ucontrol->value.integer.value[0] + min) & mask;
+	val = (val + min) & mask;
 	val = val << shift;
 
 	err = snd_soc_component_update_bits(component, reg, val_mask, val);
-- 
2.30.2

