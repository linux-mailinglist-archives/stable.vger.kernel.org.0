Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 056F12F562
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:47:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728640AbfE3Eqw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:46:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:51622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728631AbfE3DLi (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:11:38 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7C677244A6;
        Thu, 30 May 2019 03:11:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185898;
        bh=pegDi5gcAt2itKaulnEPA9b3IfsIsZpoclWPbRF2Cks=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n+gN0+l2O0ea1JByB/dtzjCTkVksnZyrQcSQGiB4/jk+2lQEqAL9PgqhvG+D8XuDE
         skO6EIwvdcZ9GhTuvZ1A5fqYqhaZxUqTBiYUbR39rWOF8LE8QzFqprUVa4STND9/HR
         AFpoTLbb/PLLgwU/mE1UIWVE1iflJBUlTVlBtxfM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 238/405] ASoC: core: remove link components before cleaning up card resources
Date:   Wed, 29 May 2019 20:03:56 -0700
Message-Id: <20190530030553.048558415@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.291644921@linuxfoundation.org>
References: <20190530030540.291644921@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit f96fb7d198ca624fe33c4145a004eb5a3d0eddec ]

When the card is registered by the machine driver,
dai link components are probed after the snd_card is
created. This is done in snd_soc_bind_card() which calls
snd_soc_instantiate_card() to first create the snd_card
and then probes the link components by calling
soc_probe_link_components(). The snd_card is used by the
component driver to add the kcontrols associated
with dapm widgets to the card.

When the machine driver is unregistered, the snd_card
is freed when the card resources are cleaned up.
But the snd_card needs to be valid while unloading the
topology dapm widgets in order to remove the kcontrols
from the card.

Since, unloading topology is done when the component
driver is removed, the link components should be removed
in snd_soc_unbind_card(). This will ensure that the kcontrols
are removed before the card resources are cleaned up and
the snd_card itself is freed.

Signed-off-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-core.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
index 46e3ab0fced47..fe99b02bbf171 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -2828,10 +2828,21 @@ EXPORT_SYMBOL_GPL(snd_soc_register_card);
 
 static void snd_soc_unbind_card(struct snd_soc_card *card, bool unregister)
 {
+	struct snd_soc_pcm_runtime *rtd;
+	int order;
+
 	if (card->instantiated) {
 		card->instantiated = false;
 		snd_soc_dapm_shutdown(card);
 		snd_soc_flush_all_delayed_work(card);
+
+		/* remove all components used by DAI links on this card */
+		for_each_comp_order(order) {
+			for_each_card_rtds(card, rtd) {
+				soc_remove_link_components(card, rtd, order);
+			}
+		}
+
 		soc_cleanup_card_resources(card);
 		if (!unregister)
 			list_add(&card->list, &unbind_card_list);
-- 
2.20.1



