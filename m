Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 806E46231D
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:33:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390093AbfGHPcO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:32:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:33844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390088AbfGHPcO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:32:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3449E204EC;
        Mon,  8 Jul 2019 15:32:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562599933;
        bh=5T9J1DMRJ2scXKLJqck80QJlxNXpMtSCcSswKdlcZm0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FT4p9q0ule7JodqyIS+Iu0hbZIVzWyhuoxWrWKwbQGz75EvXt5fltpDjGWWI+P+hH
         Dp2gnlJT52EPpJLN4Hy3VOZols8FYTGTNBb8L+03lWuKOi40yiq0Tt4EN2H+LTEVAV
         O6cfdIbZHeXfBoszYuQqqjTFOER7ELTNYCL2F95k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= 
        <amadeuszx.slawinski@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 37/96] SoC: rt274: Fix internal jack assignment in set_jack callback
Date:   Mon,  8 Jul 2019 17:13:09 +0200
Message-Id: <20190708150528.570001223@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708150526.234572443@linuxfoundation.org>
References: <20190708150526.234572443@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 04268bf2757a125616b6c2140e6250f43b7b737a ]

When we call snd_soc_component_set_jack(component, NULL, NULL) we should
set rt274->jack to passed jack, so when interrupt is triggered it calls
snd_soc_jack_report(rt274->jack, ...) with proper value.

This fixes problem in machine where in register, we call
snd_soc_register(component, &headset, NULL), which just calls
rt274_mic_detect via callback.
Now when machine driver is removed "headset" will be gone, so we
need to tell codec driver that it's gone with:
snd_soc_register(component, NULL, NULL), but we also need to be able
to handle NULL jack argument here gracefully.
If we don't set it to NULL, next time the rt274_irq runs it will call
snd_soc_jack_report with first argument being invalid pointer and there
will be Oops.

Signed-off-by: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt274.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/soc/codecs/rt274.c b/sound/soc/codecs/rt274.c
index adf59039a3b6..cdd312db3e78 100644
--- a/sound/soc/codecs/rt274.c
+++ b/sound/soc/codecs/rt274.c
@@ -405,6 +405,8 @@ static int rt274_mic_detect(struct snd_soc_component *component,
 {
 	struct rt274_priv *rt274 = snd_soc_component_get_drvdata(component);
 
+	rt274->jack = jack;
+
 	if (jack == NULL) {
 		/* Disable jack detection */
 		regmap_update_bits(rt274->regmap, RT274_EAPD_GPIO_IRQ_CTRL,
@@ -412,7 +414,6 @@ static int rt274_mic_detect(struct snd_soc_component *component,
 
 		return 0;
 	}
-	rt274->jack = jack;
 
 	regmap_update_bits(rt274->regmap, RT274_EAPD_GPIO_IRQ_CTRL,
 				RT274_IRQ_EN, RT274_IRQ_EN);
-- 
2.20.1



