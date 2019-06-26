Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EFCE55FDC
	for <lists+stable@lfdr.de>; Wed, 26 Jun 2019 05:44:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726681AbfFZDms (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jun 2019 23:42:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:53754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727168AbfFZDmq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 25 Jun 2019 23:42:46 -0400
Received: from sasha-vm.mshome.net (mobile-107-77-172-74.mobile.att.net [107.77.172.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9B0E72147A;
        Wed, 26 Jun 2019 03:42:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561520565;
        bh=oEKTGtKAmDrp8J0H+rxtRfGHW5GodEDDpVgWvfDwCe8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nYhNeNv2Rhoeg083igXz5RhnQ+tt3rxBft9ANYMK/m7u7kil8fdisQOiRPxWRTE55
         ajxL9OloUNkSRqftjcGdHFlnXO3ft0bv7VC5M2aVj/AwNluvwbLzmJh5PzA9wgFFYD
         qII1TJKfDLKaYVfoANyn5d7Nh/OHjya8NRF0GSpk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tzung-Bi Shih <tzungbi@google.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.1 31/51] ASoC: core: move DAI pre-links initiation to snd_soc_instantiate_card
Date:   Tue, 25 Jun 2019 23:40:47 -0400
Message-Id: <20190626034117.23247-31-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190626034117.23247-1-sashal@kernel.org>
References: <20190626034117.23247-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tzung-Bi Shih <tzungbi@google.com>

[ Upstream commit 70fc53734e71ce51f46dfcfd1a1c319e1cfe080c ]

Kernel crashes when an ASoC component rebinding.

The dai_link->platforms has been reset to NULL by soc_cleanup_platform()
in soc_cleanup_card_resources() when un-registering component.  However,
it has no chance to re-allocate the dai_link->platforms when registering
the component again.

Move the DAI pre-links initiation from snd_soc_register_card() to
snd_soc_instantiate_card() to make sure all DAI pre-links get initiated
when component rebinding.

As an example, by using the following commands:
- echo -n max98357a > /sys/bus/platform/drivers/max98357a/unbind
- echo -n max98357a > /sys/bus/platform/drivers/max98357a/bind

Got the error message:
"Unable to handle kernel NULL pointer dereference at virtual address".

The call trace:
snd_soc_is_matching_component+0x30/0x6c
soc_bind_dai_link+0x16c/0x240
snd_soc_bind_card+0x1e4/0xb10
snd_soc_add_component+0x270/0x300
snd_soc_register_component+0x54/0x6c

Signed-off-by: Tzung-Bi Shih <tzungbi@google.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-core.c | 27 ++++++++++-----------------
 1 file changed, 10 insertions(+), 17 deletions(-)

diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
index a4668a788ed5..9df3bdeb5c47 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -2069,6 +2069,16 @@ static int snd_soc_instantiate_card(struct snd_soc_card *card)
 	int ret, i, order;
 
 	mutex_lock(&client_mutex);
+	for_each_card_prelinks(card, i, dai_link) {
+		ret = soc_init_dai_link(card, dai_link);
+		if (ret) {
+			soc_cleanup_platform(card);
+			dev_err(card->dev, "ASoC: failed to init link %s: %d\n",
+				dai_link->name, ret);
+			mutex_unlock(&client_mutex);
+			return ret;
+		}
+	}
 	mutex_lock_nested(&card->mutex, SND_SOC_CARD_CLASS_INIT);
 
 	card->dapm.bias_level = SND_SOC_BIAS_OFF;
@@ -2793,26 +2803,9 @@ static int snd_soc_bind_card(struct snd_soc_card *card)
  */
 int snd_soc_register_card(struct snd_soc_card *card)
 {
-	int i, ret;
-	struct snd_soc_dai_link *link;
-
 	if (!card->name || !card->dev)
 		return -EINVAL;
 
-	mutex_lock(&client_mutex);
-	for_each_card_prelinks(card, i, link) {
-
-		ret = soc_init_dai_link(card, link);
-		if (ret) {
-			soc_cleanup_platform(card);
-			dev_err(card->dev, "ASoC: failed to init link %s\n",
-				link->name);
-			mutex_unlock(&client_mutex);
-			return ret;
-		}
-	}
-	mutex_unlock(&client_mutex);
-
 	dev_set_drvdata(card->dev, card);
 
 	snd_soc_initialize_card_lists(card);
-- 
2.20.1

