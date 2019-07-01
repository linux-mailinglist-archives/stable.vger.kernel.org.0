Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D151419241
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 21:06:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727798AbfEISrW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 14:47:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:39892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727769AbfEISrT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 May 2019 14:47:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 61AFA2184B;
        Thu,  9 May 2019 18:47:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557427638;
        bh=L7LiBg8b87YxHI+ehl0PGs0I5NZhj7bgJrz5e0yXmDE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ltfGF4xv9cuIRF4TvDEGt0nWTLgFg5LMxN+aZQULGEFA+Zd567fk+WguT4+BX1rky
         yDS4/f/jGeOO0QhOCQcsRUAGpCfpKnfQZSeU5tp6klCJBBYioYpUj438KKaT5CLoRK
         IwuxBdI8ESYlJjxea2qWfxkQgv+um03YN+6HJAYQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Philipp Puschmann <philipp.puschmann@emlix.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 07/66] ASoC: tlv320aic3x: fix reset gpio reference counting
Date:   Thu,  9 May 2019 20:41:42 +0200
Message-Id: <20190509181302.623871892@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190509181301.719249738@linuxfoundation.org>
References: <20190509181301.719249738@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 82ad759143ed77673db0d93d53c1cde7b99917ee ]

This patch fixes a bug that prevents freeing the reset gpio on unloading
the module.

aic3x_i2c_probe is called when loading the module and it calls list_add
with a probably uninitialized list entry aic3x->list (next = prev = NULL)).
So even if list_del is called it does nothing and in the end the gpio_reset
is not freed. Then a repeated module probing fails silently because
gpio_request fails.

When moving INIT_LIST_HEAD to aic3x_i2c_probe we also have to move
list_del to aic3x_i2c_remove because aic3x_remove may be called
multiple times without aic3x_i2c_remove being called which leads to
a NULL pointer dereference.

Signed-off-by: Philipp Puschmann <philipp.puschmann@emlix.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/tlv320aic3x.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/tlv320aic3x.c b/sound/soc/codecs/tlv320aic3x.c
index 6a271e6e6b8fc..6c0a3dad44b89 100644
--- a/sound/soc/codecs/tlv320aic3x.c
+++ b/sound/soc/codecs/tlv320aic3x.c
@@ -1599,7 +1599,6 @@ static int aic3x_probe(struct snd_soc_component *component)
 	struct aic3x_priv *aic3x = snd_soc_component_get_drvdata(component);
 	int ret, i;
 
-	INIT_LIST_HEAD(&aic3x->list);
 	aic3x->component = component;
 
 	for (i = 0; i < ARRAY_SIZE(aic3x->supplies); i++) {
@@ -1682,7 +1681,6 @@ static void aic3x_remove(struct snd_soc_component *component)
 	struct aic3x_priv *aic3x = snd_soc_component_get_drvdata(component);
 	int i;
 
-	list_del(&aic3x->list);
 	for (i = 0; i < ARRAY_SIZE(aic3x->supplies); i++)
 		regulator_unregister_notifier(aic3x->supplies[i].consumer,
 					      &aic3x->disable_nb[i].nb);
@@ -1880,6 +1878,7 @@ static int aic3x_i2c_probe(struct i2c_client *i2c,
 	if (ret != 0)
 		goto err_gpio;
 
+	INIT_LIST_HEAD(&aic3x->list);
 	list_add(&aic3x->list, &reset_list);
 
 	return 0;
@@ -1896,6 +1895,8 @@ static int aic3x_i2c_remove(struct i2c_client *client)
 {
 	struct aic3x_priv *aic3x = i2c_get_clientdata(client);
 
+	list_del(&aic3x->list);
+
 	if (gpio_is_valid(aic3x->gpio_reset) &&
 	    !aic3x_is_shared_reset(aic3x)) {
 		gpio_set_value(aic3x->gpio_reset, 0);
-- 
2.20.1



