Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 521724094F6
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:35:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345876AbhIMOgl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:36:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:51896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347529AbhIMOem (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:34:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7727E61BC1;
        Mon, 13 Sep 2021 13:53:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631541186;
        bh=rRx3NDe80nk8bVQz81/OKq3+2X6WDqoLCmczXwRbQBU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lwgZD9C3eC38kvT///+HrE0oPgSnrh8v4Z56CrqeDtQC7Dkg0TVBKhwitTOMnVLxZ
         bdGC8pP/ONprd06qcEKlmtkn7NmGnHN2liyjpX42G3cPEba5gLFXz5iZi8RexHgdT9
         PbR/n3VAG2vF53P+mGe/qeuPRrIOFkd4x5KoaDCo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Douglas Anderson <dianders@chromium.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 197/334] ASoC: rt5682: Properly turn off regulators if wrong device ID
Date:   Mon, 13 Sep 2021 15:14:11 +0200
Message-Id: <20210913131120.071440452@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131113.390368911@linuxfoundation.org>
References: <20210913131113.390368911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Douglas Anderson <dianders@chromium.org>

[ Upstream commit 772d44526e203c062171786e514373f129616278 ]

When I booted up on a board that had a slightly different codec
stuffed on it, I got this message at bootup:

  rt5682 9-001a: Device with ID register 6749 is not rt5682

That's normal/expected, but what wasn't normal was the splat that I
got after:

  WARNING: CPU: 7 PID: 176 at drivers/regulator/core.c:2151 _regulator_put+0x150/0x158
  pc : _regulator_put+0x150/0x158
  ...
  Call trace:
   _regulator_put+0x150/0x158
   regulator_bulk_free+0x48/0x70
   devm_regulator_bulk_release+0x20/0x2c
   release_nodes+0x1cc/0x244
   devres_release_all+0x44/0x60
   really_probe+0x17c/0x378
   ...

This is because the error paths don't turn off the regulator. Let's
fix that.

Fixes: 0ddce71c21f0 ("ASoC: rt5682: add rt5682 codec driver")
Fixes: 87b42abae99d ("ASoC: rt5682: Implement remove callback")
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Link: https://lore.kernel.org/r/20210811081751.v2.1.I4a1d9aa5d99e05aeee15c2768db600158d76cab8@changeid
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt5682-i2c.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/sound/soc/codecs/rt5682-i2c.c b/sound/soc/codecs/rt5682-i2c.c
index 4a56a52adab5..e559b965a0a6 100644
--- a/sound/soc/codecs/rt5682-i2c.c
+++ b/sound/soc/codecs/rt5682-i2c.c
@@ -117,6 +117,13 @@ static struct snd_soc_dai_driver rt5682_dai[] = {
 	},
 };
 
+static void rt5682_i2c_disable_regulators(void *data)
+{
+	struct rt5682_priv *rt5682 = data;
+
+	regulator_bulk_disable(ARRAY_SIZE(rt5682->supplies), rt5682->supplies);
+}
+
 static int rt5682_i2c_probe(struct i2c_client *i2c,
 		const struct i2c_device_id *id)
 {
@@ -157,6 +164,11 @@ static int rt5682_i2c_probe(struct i2c_client *i2c,
 		return ret;
 	}
 
+	ret = devm_add_action_or_reset(&i2c->dev, rt5682_i2c_disable_regulators,
+				       rt5682);
+	if (ret)
+		return ret;
+
 	ret = regulator_bulk_enable(ARRAY_SIZE(rt5682->supplies),
 				    rt5682->supplies);
 	if (ret) {
@@ -285,7 +297,6 @@ static int rt5682_i2c_remove(struct i2c_client *client)
 	struct rt5682_priv *rt5682 = i2c_get_clientdata(client);
 
 	rt5682_i2c_shutdown(client);
-	regulator_bulk_disable(ARRAY_SIZE(rt5682->supplies), rt5682->supplies);
 
 	return 0;
 }
-- 
2.30.2



