Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D93D8408E39
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:31:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242117AbhIMNai (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:30:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:34848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241355AbhIMNX4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:23:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B5B99610F9;
        Mon, 13 Sep 2021 13:21:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631539301;
        bh=bOvRzoq8iYuF1+SrAaotocRKtSikggHxC12v29IJ35k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wHFo698ef0OMbTkW62q5ZEqk5WZX81UnAjjI96MXwAjdkJylBnZXjRUwtWsAKo7Vv
         gIrDH0KNaGq8Rs50IffjZtGls3XP/U09UiyspKfzOYdmUpaw1tIYi3q89xXnyqGZYG
         CyhAlADSCno4zlYraUlsimKQuWQNn1rIdfAdAV78=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 117/144] ASoC: wcd9335: Disable irq on slave ports in the remove function
Date:   Mon, 13 Sep 2021 15:14:58 +0200
Message-Id: <20210913131051.842348284@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131047.974309396@linuxfoundation.org>
References: <20210913131047.974309396@linuxfoundation.org>
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
index 5ec63217ad02..016aff97e2fb 100644
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



