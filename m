Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D88449839C
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 16:33:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235503AbiAXPd5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 10:33:57 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:43974 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231408AbiAXPdz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 10:33:55 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8C93DB810E0
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 15:33:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34897C340E7;
        Mon, 24 Jan 2022 15:33:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643038433;
        bh=H8CSXUKprkgwQSMfZvGKY0nOZEI/6JtPV3yXxnw+z/A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SNFL9qB0UJ1VQJXSuOKFEx3AGgLDouh+HU85gDA7yFg1aAwkWfND3fwqfW1zMVXpj
         +m1a69WFyyIGRRKaZEdZ4l+vgqByjAlqMI4VYUj/ubHpTSIXkYt4UEerfD5gyOQ0wc
         x6031ocCB1OF0njWJl3IzpzJnc4xOAMgXsrxWkH+sEjNduOCUC4eVCvs6FqvCQ//2a
         0jmFTkN+4mBzSaOwLqpxbS3/w3WqLdDgnJSHeTvGFARbxkb0u6z+bijla4Nb4+nnjI
         ezVm3CJk3ivxMo/QyXP9mPQd2xTcfuxAHRtlIWvME3MiYERKiMNUJ92pZgq+Qp2qou
         jrgF83b9ZevUQ==
From:   Mark Brown <broonie@kernel.org>
To:     Liam Girdwood <lgirdwood@gmail.com>
Cc:     alsa-devel@alsa-project.org, Mark Brown <broonie@kernel.org>,
        stable@vger.kernel.org
Subject: [PATCH v1 1/3] ASoC: ops: Reject out of bounds values in snd_soc_put_volsw()
Date:   Mon, 24 Jan 2022 15:32:51 +0000
Message-Id: <20220124153253.3548853-2-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220124153253.3548853-1-broonie@kernel.org>
References: <20220124153253.3548853-1-broonie@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1419; h=from:subject; bh=H8CSXUKprkgwQSMfZvGKY0nOZEI/6JtPV3yXxnw+z/A=; b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBh7saihjCo+ozwM+QwXv6Oo2x19ONjtnaIuHg+l+Hj ZU7ydiiJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCYe7GogAKCRAk1otyXVSH0CujB/ 92G0gzebzErS14s3OjhKS66JcFgczyXwFfuQ+g8KaCw4N6kuOym+f084lSn1Dnvb0KBZxOPQAvJOS2 KaLxTSIn8Hsk8y9XDtxIzWF1HOnRfxhKUHiQ8fDlmTqhs+FehCW3ovLbYoYMmjdDdDF0KUJdUeFC4w LbP/hSYAWxu3oocFVzpHxo/N/agV7WXGynh8F7mFC7o5wLefg5a0K8RB8rKkJpSfz6QtANAymcS3Vl U4+NApoS25EGOQg70bmBTYDt2ys6yf+Bk/13XsskwtstZKV0tNdFwqZkj/y+ro7AT0oJpYjYlnUiJ5 hdlIV3cKSmljqrmk79JFm8TNCjXiJ6
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
 sound/soc/soc-ops.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/sound/soc/soc-ops.c b/sound/soc/soc-ops.c
index 08eaa9ddf191..fbe5d326b0f2 100644
--- a/sound/soc/soc-ops.c
+++ b/sound/soc/soc-ops.c
@@ -316,13 +316,27 @@ int snd_soc_put_volsw(struct snd_kcontrol *kcontrol,
 	if (sign_bit)
 		mask = BIT(sign_bit + 1) - 1;
 
-	val = ((ucontrol->value.integer.value[0] + min) & mask);
+	val = ucontrol->value.integer.value[0];
+	if (mc->platform_max && val > mc->platform_max)
+		return -EINVAL;
+	if (val > max - min)
+		return -EINVAL;
+	if (val < 0)
+		return -EINVAL;
+	val = (val + min) & mask;
 	if (invert)
 		val = max - val;
 	val_mask = mask << shift;
 	val = val << shift;
 	if (snd_soc_volsw_is_stereo(mc)) {
-		val2 = ((ucontrol->value.integer.value[1] + min) & mask);
+		val2 = ucontrol->value.integer.value[1];
+		if (mc->platform_max && val2 > mc->platform_max)
+			return -EINVAL;
+		if (val2 > max - min)
+			return -EINVAL;
+		if (val2 < 0)
+			return -EINVAL;
+		val2 = (val2 + min) & mask;
 		if (invert)
 			val2 = max - val2;
 		if (reg == reg2) {
-- 
2.30.2

