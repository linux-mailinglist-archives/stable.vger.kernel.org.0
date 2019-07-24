Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23CE173F36
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:32:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729355AbfGXT3p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:29:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:49226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729049AbfGXT3m (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:29:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D651522ADA;
        Wed, 24 Jul 2019 19:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563996582;
        bh=hH3OD1I2+8UPX765o8lm5X+iCCRRXeoTuVL7zMeLBrg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QCzjq0eNZ4Y5OGJnX7DmtpEntzBmeK0VsC0WLXBgpVAPpJi2Ll3Szr6+7f6aIfeYo
         xsg6TkKkZdfauB3wPcD1q45jHLw0qWApxNvqJkXLfKyWnbalmdGRZ3mjFfII9AV3uZ
         r9mhrCCD/xFg46dxkGwoQUsK8kfLRLMvV0obLz3U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 146/413] ASoC: soc-core: call snd_soc_unbind_card() under mutex_lock;
Date:   Wed, 24 Jul 2019 21:17:17 +0200
Message-Id: <20190724191745.389752092@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191735.096702571@linuxfoundation.org>
References: <20190724191735.096702571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit b545542a0b866f7975254e41c595836e9bc0ff2f ]

commit 34ac3c3eb8f0c07 ("ASoC: core: lock client_mutex while removing
link components") added mutex_lock() at soc_remove_link_components().

Is is called from snd_soc_unbind_card()

	snd_soc_unbind_card()
=>		soc_remove_link_components()
		soc_cleanup_card_resources()
			soc_remove_dai_links()
=>				soc_remove_link_components()

And, there are 2 way to call it.

(1)
	snd_soc_unregister_component()
**		mutex_lock()
			snd_soc_component_del_unlocked()
=>				snd_soc_unbind_card()
**		mutex_unlock()

(2)
	snd_soc_unregister_card()
=>		snd_soc_unbind_card()

(1) case is already using mutex_lock() when it calles
snd_soc_unbind_card(), thus, we will get lockdep warning.

commit 495f926c68ddb90 ("ASoC: core: Fix deadlock in
snd_soc_instantiate_card()") tried to fixup it, but still not
enough. We still have lockdep warning when we try unbind/bind.

We need mutex_lock() under snd_soc_unregister_card()
instead of snd_remove_link_components()/snd_soc_unbind_card().

Fixes: 34ac3c3eb8f0c07 ("ASoC: core: lock client_mutex while removing link components")
Fixes: 495f926c68ddb90 ("ASoC: core: Fix deadlock in snd_soc_instantiate_card()")
Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
index 41c0cfaf2db5..9138fcb15cd3 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -2837,14 +2837,12 @@ static void snd_soc_unbind_card(struct snd_soc_card *card, bool unregister)
 		snd_soc_dapm_shutdown(card);
 		snd_soc_flush_all_delayed_work(card);
 
-		mutex_lock(&client_mutex);
 		/* remove all components used by DAI links on this card */
 		for_each_comp_order(order) {
 			for_each_card_rtds(card, rtd) {
 				soc_remove_link_components(card, rtd, order);
 			}
 		}
-		mutex_unlock(&client_mutex);
 
 		soc_cleanup_card_resources(card);
 		if (!unregister)
@@ -2863,7 +2861,9 @@ static void snd_soc_unbind_card(struct snd_soc_card *card, bool unregister)
  */
 int snd_soc_unregister_card(struct snd_soc_card *card)
 {
+	mutex_lock(&client_mutex);
 	snd_soc_unbind_card(card, true);
+	mutex_unlock(&client_mutex);
 	dev_dbg(card->dev, "ASoC: Unregistered card '%s'\n", card->name);
 
 	return 0;
-- 
2.20.1



