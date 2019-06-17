Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AAD449267
	for <lists+stable@lfdr.de>; Mon, 17 Jun 2019 23:19:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727077AbfFQVT4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 17:19:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:43922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728974AbfFQVTz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Jun 2019 17:19:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA07020861;
        Mon, 17 Jun 2019 21:19:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560806395;
        bh=f/SzpYjd0lhy06NyDMf28RJygr0QXRE60ZLcfnmLH+A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jcBMTGqlBkOBxDZRG5/bEeRyMPZ5zrxc27jmhcEAaozXJ+GAv8kbrp8YgUVUDSpZ7
         Zu6FeTSUrK+ByRN5/BYN9CdZ0tlILJA50T/5f7Mh8L+e/cdvQKOpCcOYQ1KHuSKjay
         wgnoJgpMr1JhIkuU4CV8fZ1Yik3saj6WfJOb/rTE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.1 036/115] ASoC: soc-core: fixup references at soc_cleanup_card_resources()
Date:   Mon, 17 Jun 2019 23:08:56 +0200
Message-Id: <20190617210801.831121133@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190617210759.929316339@linuxfoundation.org>
References: <20190617210759.929316339@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>

commit 29040d1ac569606fece70966179de272cfc0d4db upstream.

commit 53e947a0e1f7 ("ASoC: soc-core: merge card resources cleanup
method") merged cleanup method of snd_soc_instantiate_card() and
soc_cleanup_card_resources().

But, after this commit, if user uses unbind/bind to Component factor
drivers, Kernel might indicates refcount error at
soc_cleanup_card_resources().

The 1st reason is card->snd_card is still exist even though
snd_card_free() was called, but it is already cleaned.
We need to set NULL to it.

2nd is card->dapm and card create debugfs, but its dentry is still
exist even though it was removed. We need to set NULL to it.

Fixes: 53e947a0e1f7 ("ASoC: soc-core: merge card resources cleanup method")
Cc: stable@vger.kernel.org # for v5.1
Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/soc-core.c |    7 ++++++-
 sound/soc/soc-dapm.c |    3 +++
 2 files changed, 9 insertions(+), 1 deletion(-)

--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -228,7 +228,10 @@ static void soc_init_card_debugfs(struct
 
 static void soc_cleanup_card_debugfs(struct snd_soc_card *card)
 {
+	if (!card->debugfs_card_root)
+		return;
 	debugfs_remove_recursive(card->debugfs_card_root);
+	card->debugfs_card_root = NULL;
 }
 
 static void snd_soc_debugfs_init(void)
@@ -2034,8 +2037,10 @@ static void soc_check_tplg_fes(struct sn
 static int soc_cleanup_card_resources(struct snd_soc_card *card)
 {
 	/* free the ALSA card at first; this syncs with pending operations */
-	if (card->snd_card)
+	if (card->snd_card) {
 		snd_card_free(card->snd_card);
+		card->snd_card = NULL;
+	}
 
 	/* remove and free each DAI */
 	soc_remove_dai_links(card);
--- a/sound/soc/soc-dapm.c
+++ b/sound/soc/soc-dapm.c
@@ -2192,7 +2192,10 @@ static void dapm_debugfs_add_widget(stru
 
 static void dapm_debugfs_cleanup(struct snd_soc_dapm_context *dapm)
 {
+	if (!dapm->debugfs_dapm)
+		return;
 	debugfs_remove_recursive(dapm->debugfs_dapm);
+	dapm->debugfs_dapm = NULL;
 }
 
 #else


