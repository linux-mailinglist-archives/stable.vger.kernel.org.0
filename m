Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E57563D603A
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:02:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237179AbhGZPV1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:21:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:35542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236204AbhGZPVX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:21:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0ABDD60240;
        Mon, 26 Jul 2021 16:01:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315312;
        bh=HNgwgOgXKcrDBopskhkaetrvqIyczd7na3SKqGo66K0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q9GQTSy9HnyLxFe34hT6S3px63Iq4nZRI2kEu2kNGWchEaMjjZ+VrqTGbcIH3m2I+
         K3OsIQljYdOIfdShGeAOPzWVoag7KSk9s3VQ++1UtTTm2r7adZU7TLJeKYylGiK9l9
         tWS2WmaM9/aL36G8YSPuIQpxRW+rUTdM9OrjOB8Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 048/167] ASoC: wm_adsp: Correct wm_coeff_tlv_get handling
Date:   Mon, 26 Jul 2021 17:38:01 +0200
Message-Id: <20210726153841.014185263@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153839.371771838@linuxfoundation.org>
References: <20210726153839.371771838@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit dd6fb8ff2210f74b056bf9234d0605e8c26a8ac0 ]

When wm_coeff_tlv_get was updated it was accidentally switch to the _raw
version of the helper causing it to ignore the current DSP state it
should be checking. Switch the code back to the correct helper so that
users can't read the controls when they arn't available.

Fixes: 73ecf1a673d3 ("ASoC: wm_adsp: Correct cache handling of new kernel control API")
Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20210626155941.12251-1-ckeepax@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm_adsp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/wm_adsp.c b/sound/soc/codecs/wm_adsp.c
index 985b2dcecf13..51d95437e0fd 100644
--- a/sound/soc/codecs/wm_adsp.c
+++ b/sound/soc/codecs/wm_adsp.c
@@ -1221,7 +1221,7 @@ static int wm_coeff_tlv_get(struct snd_kcontrol *kctl,
 
 	mutex_lock(&ctl->dsp->pwr_lock);
 
-	ret = wm_coeff_read_ctrl_raw(ctl, ctl->cache, size);
+	ret = wm_coeff_read_ctrl(ctl, ctl->cache, size);
 
 	if (!ret && copy_to_user(bytes, ctl->cache, size))
 		ret = -EFAULT;
-- 
2.30.2



