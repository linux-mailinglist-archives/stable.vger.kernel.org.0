Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AE456961D
	for <lists+stable@lfdr.de>; Mon, 15 Jul 2019 17:02:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388860AbfGOOLl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jul 2019 10:11:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:47786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388608AbfGOOLk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jul 2019 10:11:40 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E0B2D212F5;
        Mon, 15 Jul 2019 14:11:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563199900;
        bh=bNyd6KJbBf6XaTkANNz5YNQDDdmIq/vmA8Rov+DAflw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oxXESnPxcjG8xpv9/4iTJCOR5XhHvY66aBNSSZIDwHAXT2/Jh+fBBVF9X57LO3c13
         Gel5+NKiT3i7SKD4x7mTfUOT0BzTytfl19/mnw6bsJHlin6DRKOAn91lsP+lgOwLAl
         a8THjd1TA2sR3TPlJ0EsyA05fDWUzctADqUnxM6o=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.1 131/219] ASoC: soc-core: call snd_soc_unbind_card() under mutex_lock;
Date:   Mon, 15 Jul 2019 10:02:12 -0400
Message-Id: <20190715140341.6443-131-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715140341.6443-1-sashal@kernel.org>
References: <20190715140341.6443-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>

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
index c010cc864cf3..f05a5c0a8aff 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -2834,14 +2834,12 @@ static void snd_soc_unbind_card(struct snd_soc_card *card, bool unregister)
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
@@ -2860,7 +2858,9 @@ static void snd_soc_unbind_card(struct snd_soc_card *card, bool unregister)
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

