Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4740F4A60D3
	for <lists+stable@lfdr.de>; Tue,  1 Feb 2022 16:57:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240744AbiBAP5R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Feb 2022 10:57:17 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:52682 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240742AbiBAP5Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Feb 2022 10:57:16 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EEAF7B82EBD
        for <stable@vger.kernel.org>; Tue,  1 Feb 2022 15:57:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74BDBC340ED;
        Tue,  1 Feb 2022 15:57:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643731034;
        bh=QTGmCkc8xHsSc4UxccqN8v9eMK0ZjM1hmtWk5qpf5Bc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qY/b0b96iQv7eSGC7spV5Be59adzduJK4OVNElpUiBBcHLAxoF48IHxJJkKwML1AM
         Fbh1cgEGb5WSEDpnboi9DNJAqurwLUOWkZ6V70WtV1yC7cxbKGt4gsObqc2+yW9S4C
         cqz/hlG9w+b8wAFINeHb1QwtbIeK1W2GTSaheHmKyu7VcTijUG8vGFMrc3jezlQBXL
         LnBVVWm4cKw7icB0d+Tbk7ikXL8HdhBveHp5XOAmCLEsBFaon+fWfFKhicdOhEBPMw
         7eBycBxYhxRpDBx1Q9tmjPNTve2Vjr2/qU42xEQ+ncBPPdOYKbJ5hQEXHpdeANjv17
         XeBvS85dQd1xw==
From:   Mark Brown <broonie@kernel.org>
To:     Liam Girdwood <lgirdwood@gmail.com>
Cc:     alsa-devel@alsa-project.org, Mark Brown <broonie@kernel.org>,
        stable@vger.kernel.org
Subject: [PATCH v1 3/4] ASoC: ops: Fix stereo change notifications in snd_soc_put_volsw_range()
Date:   Tue,  1 Feb 2022 15:56:28 +0000
Message-Id: <20220201155629.120510-4-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220201155629.120510-1-broonie@kernel.org>
References: <20220201155629.120510-1-broonie@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1710; h=from:subject; bh=QTGmCkc8xHsSc4UxccqN8v9eMK0ZjM1hmtWk5qpf5Bc=; b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBh+VgrYf8FNriLi0uMk58JVTX8BJUYs7WiQ7xNh/dI koeyceWJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCYflYKwAKCRAk1otyXVSH0LpZB/ 0ZRFFHtp2uv2bLQO3T/zGiXDAcmgEGJZRITphls0zTCdtLdwPhVE+6vDRc70aZdcim9wnvoZoDi0TE cImeaGr11aVqGVitwsd/Osfzvtie2q8yfJXpOciEHWZe6ZfYK6nxYvGOfS4gxo69OJ9OP2JyoDHjNo vr1nibIBP1h1HAo6B+roTYMYKMuN2CcZB6KuFZP9vVTR39aC6chHeCvaOUfmyxXnTFAWyWzAcpGVdX NzBspuFT4cd1NNau2lSsw11tINGl+oArZ4LBwdbkMucFWGmOgiOnNdPhaA4ae19tCTXUcbq+xnmBNH N0WgH7zjbbtkUhTRjm6q4l5PD6dXDy
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
 sound/soc/soc-ops.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/sound/soc/soc-ops.c b/sound/soc/soc-ops.c
index f0d1aeb38346..fefd4f34cbc1 100644
--- a/sound/soc/soc-ops.c
+++ b/sound/soc/soc-ops.c
@@ -498,7 +498,7 @@ int snd_soc_put_volsw_range(struct snd_kcontrol *kcontrol,
 	unsigned int mask = (1 << fls(max)) - 1;
 	unsigned int invert = mc->invert;
 	unsigned int val, val_mask;
-	int ret;
+	int err, ret;
 
 	if (invert)
 		val = (max - ucontrol->value.integer.value[0]) & mask;
@@ -507,9 +507,10 @@ int snd_soc_put_volsw_range(struct snd_kcontrol *kcontrol,
 	val_mask = mask << shift;
 	val = val << shift;
 
-	ret = snd_soc_component_update_bits(component, reg, val_mask, val);
-	if (ret < 0)
-		return ret;
+	err = snd_soc_component_update_bits(component, reg, val_mask, val);
+	if (err < 0)
+		return err;
+	ret = err;
 
 	if (snd_soc_volsw_is_stereo(mc)) {
 		if (invert)
@@ -519,8 +520,12 @@ int snd_soc_put_volsw_range(struct snd_kcontrol *kcontrol,
 		val_mask = mask << shift;
 		val = val << shift;
 
-		ret = snd_soc_component_update_bits(component, rreg, val_mask,
+		err = snd_soc_component_update_bits(component, rreg, val_mask,
 			val);
+		/* Don't discard any error code or drop change flag */
+		if (ret == 0 || err < 0) {
+			ret = err;
+		}
 	}
 
 	return ret;
-- 
2.30.2

