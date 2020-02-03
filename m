Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABB5E150C4E
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 17:36:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730917AbgBCQfJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 11:35:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:49784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730901AbgBCQfI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Feb 2020 11:35:08 -0500
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A82B42087E;
        Mon,  3 Feb 2020 16:35:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580747708;
        bh=9ty3tMdqE5fKLEoeDFTtG79USBsuNwJvzjucfUNDR0E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C6kd/Lcj4Y+37CyYYv76a1g7AReUEujwnsUnXXcwxZhUI/bJsO/cnlyXBcB9iqkL4
         r81lV/R3FcckIuLUun1ThEWvnOWRsQXoBhv7CgQ+wA2qkQTZ6b7pECwhUPY9g0yROJ
         Ev8OhPcvv8Euej7gWrSEoN9+NjCG0IZpHBOFH0xA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Osipenko <digetx@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 36/90] ASoC: rt5640: Fix NULL dereference on module unload
Date:   Mon,  3 Feb 2020 16:19:39 +0000
Message-Id: <20200203161922.450876464@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200203161917.612554987@linuxfoundation.org>
References: <20200203161917.612554987@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index adbae1f36a8af..747ca248bf10c 100644
--- a/sound/soc/codecs/rt5640.c
+++ b/sound/soc/codecs/rt5640.c
@@ -2432,6 +2432,13 @@ static void rt5640_disable_jack_detect(struct snd_soc_component *component)
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



