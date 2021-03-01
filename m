Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A757F32847F
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 17:37:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231718AbhCAQhL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 11:37:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:36898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231625AbhCAQ37 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:29:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E1D2B64EEA;
        Mon,  1 Mar 2021 16:23:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614615806;
        bh=Gu6kYjc3NvCQdtDvNf7qDiSBgRNU/1TmPlRoTSwyCxw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JRH06MmYzszDjYDE/zvSWsWUQuogIZbTKkEop8GF0nZM6JXRouVNJm+QuYHGO4J3n
         rJUwfQzPnYDwdE3qWZzfISTVCuye/S4sKJ/jgvA1ara9fomeYtZ+IpOGY89yllouMH
         70l5eq105yLKjvcb5kibdebVAOLpDc8onDB2EniE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 037/134] ASoC: cs42l56: fix up error handling in probe
Date:   Mon,  1 Mar 2021 17:12:18 +0100
Message-Id: <20210301161015.403932642@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161013.585393984@linuxfoundation.org>
References: <20210301161013.585393984@linuxfoundation.org>
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
index 54c1768bc8185..a2535a7eb4bbd 100644
--- a/sound/soc/codecs/cs42l56.c
+++ b/sound/soc/codecs/cs42l56.c
@@ -1270,6 +1270,7 @@ static int cs42l56_i2c_probe(struct i2c_client *i2c_client,
 		dev_err(&i2c_client->dev,
 			"CS42L56 Device ID (%X). Expected %X\n",
 			devid, CS42L56_DEVID);
+		ret = -EINVAL;
 		goto err_enable;
 	}
 	alpha_rev = reg & CS42L56_AREV_MASK;
@@ -1325,7 +1326,7 @@ static int cs42l56_i2c_probe(struct i2c_client *i2c_client,
 	ret =  snd_soc_register_codec(&i2c_client->dev,
 			&soc_codec_dev_cs42l56, &cs42l56_dai, 1);
 	if (ret < 0)
-		return ret;
+		goto err_enable;
 
 	return 0;
 
-- 
2.27.0



