Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB650148717
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 15:20:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392151AbgAXOUf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 09:20:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:41714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392053AbgAXOUe (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 09:20:34 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 654762467B;
        Fri, 24 Jan 2020 14:20:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579875634;
        bh=a3q3AfdfpnZz0utkiLplW6HuR5hV2vd1W/olLkrViE0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i2aIZULskj195JrkSohACxoSZmhSUm7vMmNu5kZOvvIUotEJLjNHpM4PNBOoWkqDi
         eFsSLINjtnQRNS6TjG3H/38TgYc0f98FIfKVF0xvMxZAMuCnm5pwyAmlNGLmF5i6b6
         aa4UbiRZPVTAKw/J+13+4jotLGI966IFanSnCxhc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dmitry Osipenko <digetx@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 4.19 18/56] ASoC: rt5640: Fix NULL dereference on module unload
Date:   Fri, 24 Jan 2020 09:19:34 -0500
Message-Id: <20200124142012.29752-18-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200124142012.29752-1-sashal@kernel.org>
References: <20200124142012.29752-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Osipenko <digetx@gmail.com>

[ Upstream commit 89b71b3f02d8ae5a08a1dd6f4a2098b7b868d498 ]

The rt5640->jack is NULL if jack is already disabled at the time of
driver's module unloading.

Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
Link: https://lore.kernel.org/r/20200106014707.11378-1-digetx@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt5640.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/codecs/rt5640.c b/sound/soc/codecs/rt5640.c
index 27770143ae8f2..974e1a4491723 100644
--- a/sound/soc/codecs/rt5640.c
+++ b/sound/soc/codecs/rt5640.c
@@ -2435,6 +2435,13 @@ static void rt5640_disable_jack_detect(struct snd_soc_component *component)
 {
 	struct rt5640_priv *rt5640 = snd_soc_component_get_drvdata(component);
 
+	/*
+	 * soc_remove_component() force-disables jack and thus rt5640->jack
+	 * could be NULL at the time of driver's module unloading.
+	 */
+	if (!rt5640->jack)
+		return;
+
 	disable_irq(rt5640->irq);
 	rt5640_cancel_work(rt5640);
 
-- 
2.20.1

