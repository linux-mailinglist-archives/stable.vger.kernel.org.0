Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A52A13C4EE4
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:42:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241318AbhGLHWM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:22:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:58420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344471AbhGLHUg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:20:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D6381613C7;
        Mon, 12 Jul 2021 07:17:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626074267;
        bh=1ngdc0xFKuW9eIhg8qbvrnn31GJhOOAefnCBuqDfHLg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rmGZ1iLlU4TeRtno2XDoOsg0uI2bXEtRkguMEjkOf4PdNZCVgWiXb8R3EVDHO0uOk
         tuCqCXY52j62zTRO24+/qjM6wfHBBaNvU9QcFWNq50vzvLqzJsVxMr3YcXueh17d8K
         BkgphtbUbqMa6ghZcDTV0jVSyCb1M7XceV8rQ0Jw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jairaj Arava <jairaj.arava@intel.com>,
        Sathyanarayana Nujella <sathyanarayana.nujella@intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@intel.com>,
        Shuming Fan <shumingf@realtek.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Stephen Boyd <swboyd@chromium.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 521/700] ASoC: rt5682: Disable irq on shutdown
Date:   Mon, 12 Jul 2021 08:10:04 +0200
Message-Id: <20210712061031.898858812@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephen Boyd <swboyd@chromium.org>

[ Upstream commit 47bcb1c7108363418cd578283333d72e310dfeaa ]

We cancel the work queues, and reset the device on shutdown, but the irq
isn't disabled so the work queues could be queued again. Let's disable
the irq during shutdown so that we don't have to worry about this device
trying to do anything anymore. This fixes a problem seen where the i2c
bus is shutdown at reboot but this device irq still comes in and tries
to make another i2c transaction when the bus doesn't work.

Cc: Jairaj Arava <jairaj.arava@intel.com>
Cc: Sathyanarayana Nujella <sathyanarayana.nujella@intel.com>
Cc: Pierre-Louis Bossart <pierre-louis.bossart@intel.com>
Cc: Shuming Fan <shumingf@realtek.com>
Cc: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Fixes: 45a2702ce109 ("ASoC: rt5682: Fix panic in rt5682_jack_detect_handler happening during system shutdown")
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
Link: https://lore.kernel.org/r/20210508075151.1626903-1-swboyd@chromium.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt5682-i2c.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/codecs/rt5682-i2c.c b/sound/soc/codecs/rt5682-i2c.c
index 93c1603b42f1..8265b537ff4f 100644
--- a/sound/soc/codecs/rt5682-i2c.c
+++ b/sound/soc/codecs/rt5682-i2c.c
@@ -273,6 +273,7 @@ static void rt5682_i2c_shutdown(struct i2c_client *client)
 {
 	struct rt5682_priv *rt5682 = i2c_get_clientdata(client);
 
+	disable_irq(client->irq);
 	cancel_delayed_work_sync(&rt5682->jack_detect_work);
 	cancel_delayed_work_sync(&rt5682->jd_check_work);
 
-- 
2.30.2



