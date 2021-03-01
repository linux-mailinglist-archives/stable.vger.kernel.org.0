Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A59C328676
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:12:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237209AbhCARKi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:10:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:35322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236647AbhCAREU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:04:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C682F64F78;
        Mon,  1 Mar 2021 16:39:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614616761;
        bh=xus7r0Ib1H8G6cveWjGRQV0sauCd/dArh4uwYmEtteA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zm8aYWp2Nz2ooqhAPCl3MENVDrY6emMc7V/P3lBLGbCdafK769yJ5uv24vT8s5BYk
         CTD9DHgR1e+l6QsJZqR+2E2t+f3Ht+zfCR99ANNrBhyP6PUC6y42m1IyQgLewfbBMN
         +GuwGsB3J9599GqhvYI9YgpdD0iLQ5sELXT2lRdg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 086/247] ASoC: cs42l56: fix up error handling in probe
Date:   Mon,  1 Mar 2021 17:11:46 +0100
Message-Id: <20210301161035.888526470@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161031.684018251@linuxfoundation.org>
References: <20210301161031.684018251@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 856fe64da84c95a1d415564b981ae3908eea2a76 ]

There are two issues with this code.  The first error path forgot to set
the error code and instead returns success.  The second error path
doesn't clean up.

Fixes: 272b5edd3b8f ("ASoC: Add support for CS42L56 CODEC")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lore.kernel.org/r/X9NE/9nK9/TuxuL+@mwanda
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs42l56.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/soc/codecs/cs42l56.c b/sound/soc/codecs/cs42l56.c
index a5c8736fad777..04f89b751304c 100644
--- a/sound/soc/codecs/cs42l56.c
+++ b/sound/soc/codecs/cs42l56.c
@@ -1260,6 +1260,7 @@ static int cs42l56_i2c_probe(struct i2c_client *i2c_client,
 		dev_err(&i2c_client->dev,
 			"CS42L56 Device ID (%X). Expected %X\n",
 			devid, CS42L56_DEVID);
+		ret = -EINVAL;
 		goto err_enable;
 	}
 	alpha_rev = reg & CS42L56_AREV_MASK;
@@ -1317,7 +1318,7 @@ static int cs42l56_i2c_probe(struct i2c_client *i2c_client,
 	ret =  devm_snd_soc_register_component(&i2c_client->dev,
 			&soc_component_dev_cs42l56, &cs42l56_dai, 1);
 	if (ret < 0)
-		return ret;
+		goto err_enable;
 
 	return 0;
 
-- 
2.27.0



