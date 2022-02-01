Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 127134A60D4
	for <lists+stable@lfdr.de>; Tue,  1 Feb 2022 16:57:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240743AbiBAP5T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Feb 2022 10:57:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240742AbiBAP5T (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Feb 2022 10:57:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C208DC061714
        for <stable@vger.kernel.org>; Tue,  1 Feb 2022 07:57:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7CAB3B82EBC
        for <stable@vger.kernel.org>; Tue,  1 Feb 2022 15:57:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A160C340F2;
        Tue,  1 Feb 2022 15:57:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643731036;
        bh=VnWhYXoSublRCB+1wcOOpYhqio7frWE6T8zFex0MlxI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qyDH9x0rAubhmtN+jqn8UpfmWNRQjRyIlv/UFEuCuh9GuA2OHYdkAPqz0cB5XeWFu
         iuGD9pJ8JpxZvoPuGMTh3S/Dm6/MLjWcSPQcGao0BrsJf8fQV9LsLXRe3mvNM6bt9x
         S2+RY+ikcfmg1mE3+k9AhRSxqfQeypflHTZ3d9Qee9dPrXFjNJU28yZzU7WEJPbmx0
         UJUxMAvMdJW5wyvHWhpl1l56v38bf3uwHB7yB1MJKwhfxjVK+oUhMHkxpcNEiKNmGR
         TByrObquwXvGdofawh93oteISlUvrCxv/msUK0SvXHNRW5ZZ1A3M1BE+Cv16R1Jvsy
         pbCavoMmzQNRQ==
From:   Mark Brown <broonie@kernel.org>
To:     Liam Girdwood <lgirdwood@gmail.com>
Cc:     alsa-devel@alsa-project.org, Mark Brown <broonie@kernel.org>,
        stable@vger.kernel.org
Subject: [PATCH v1 4/4] ASoC: ops: Fix stereo change notifications in snd_soc_put_xr_sx()
Date:   Tue,  1 Feb 2022 15:56:29 +0000
Message-Id: <20220201155629.120510-5-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220201155629.120510-1-broonie@kernel.org>
References: <20220201155629.120510-1-broonie@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1062; h=from:subject; bh=VnWhYXoSublRCB+1wcOOpYhqio7frWE6T8zFex0MlxI=; b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBh+VgsLu4zMn5YXRfnMlkoi6j6z/SZ9Iy/LLhl7L29 4B/A656JATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCYflYLAAKCRAk1otyXVSH0IpLB/ 9YQ+9hIYFMiyjlW9PEgtBYLZh8roYtm/kwoGkde9MmPGlh7SxACNvDW/Chh0tEcFkERC0XxyTW3z0S OvzjU+KECDOtlqXho/YTAWdX5dpdVE7TS7xsTH6GHKylJzjDpTjvrEgKpY6NIg0F2SEPkXDZM8eUwl VyWeOXCmlgLqJ86E6+2uwRhvRELkU+KNrrp7cYyiD5OQzvGHyEBa59lyqwO2dhrU9FT8cIO8YNDtgj WkrtJIPqOB65fEltw+w7bC6ylNb7iV0YiAZStnC97dJpM0UoEPxCxASL0ND4+FkKODl2VOe1k/8/Wv 369Vu1zpxlhWaS+cIpKUOQRF79LbcS
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
 sound/soc/soc-ops.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/sound/soc/soc-ops.c b/sound/soc/soc-ops.c
index fefd4f34cbc1..6b922d12afb5 100644
--- a/sound/soc/soc-ops.c
+++ b/sound/soc/soc-ops.c
@@ -874,6 +874,7 @@ int snd_soc_put_xr_sx(struct snd_kcontrol *kcontrol,
 	unsigned long mask = (1UL<<mc->nbits)-1;
 	long max = mc->max;
 	long val = ucontrol->value.integer.value[0];
+	int ret = 0;
 	unsigned int i;
 
 	if (invert)
@@ -886,9 +887,11 @@ int snd_soc_put_xr_sx(struct snd_kcontrol *kcontrol,
 							regmask, regval);
 		if (err < 0)
 			return err;
+		if (err > 0)
+			ret = err;
 	}
 
-	return 0;
+	return ret;
 }
 EXPORT_SYMBOL_GPL(snd_soc_put_xr_sx);
 
-- 
2.30.2

