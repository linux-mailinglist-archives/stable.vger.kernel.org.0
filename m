Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 840484092B0
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:14:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240212AbhIMOOG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:14:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:59952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244031AbhIMOMA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:12:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CDDBA61ACE;
        Mon, 13 Sep 2021 13:42:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540550;
        bh=ew6QFRbpjf61wu36p4LAqhVfJLhKx4rYLGyQkXg1Dp4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pT+H3DldxCjCn5b87yUyYkcbBwWmAV8NBdyEZ4qg+u0060ndYfy4cuLgkJ2nMXnfr
         2i+xZs73sN60/LqMiUj7qQrvQzucqz8gu+C0R/dznv3Q5Oof0wdC42/VKlyovgtVZl
         ly9KIuE0aNDco+v41ttjfarAE217/oDTPdOgN9uY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 240/300] ASoC: wcd9335: Disable irq on slave ports in the remove function
Date:   Mon, 13 Sep 2021 15:15:01 +0200
Message-Id: <20210913131117.463083548@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131109.253835823@linuxfoundation.org>
References: <20210913131109.253835823@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit d3efd26af2e044ff2b48d38bb871630282d77e60 ]

The probe calls 'wcd9335_setup_irqs()' to enable interrupts on all slave
ports.
This must be undone in the remove function.

Add a 'wcd9335_teardown_irqs()' function that undoes 'wcd9335_setup_irqs()'
function, and call it from the remove function.

Fixes: 20aedafdf492 ("ASoC: wcd9335: add support to wcd9335 codec")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Message-Id: <8f761244d79bd4c098af8a482be9121d3a486d1b.1629091028.git.christophe.jaillet@wanadoo.fr>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wcd9335.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/sound/soc/codecs/wcd9335.c b/sound/soc/codecs/wcd9335.c
index 47fe68edea3a..d885ced34f60 100644
--- a/sound/soc/codecs/wcd9335.c
+++ b/sound/soc/codecs/wcd9335.c
@@ -4076,6 +4076,16 @@ static int wcd9335_setup_irqs(struct wcd9335_codec *wcd)
 	return ret;
 }
 
+static void wcd9335_teardown_irqs(struct wcd9335_codec *wcd)
+{
+	int i;
+
+	/* disable interrupts on all slave ports */
+	for (i = 0; i < WCD9335_SLIM_NUM_PORT_REG; i++)
+		regmap_write(wcd->if_regmap, WCD9335_SLIM_PGD_PORT_INT_EN0 + i,
+			     0x00);
+}
+
 static void wcd9335_cdc_sido_ccl_enable(struct wcd9335_codec *wcd,
 					bool ccl_flag)
 {
@@ -4878,6 +4888,7 @@ static void wcd9335_codec_remove(struct snd_soc_component *comp)
 	struct wcd9335_codec *wcd = dev_get_drvdata(comp->dev);
 
 	wcd_clsh_ctrl_free(wcd->clsh_ctrl);
+	wcd9335_teardown_irqs(wcd);
 }
 
 static int wcd9335_codec_set_sysclk(struct snd_soc_component *comp,
-- 
2.30.2



