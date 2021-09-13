Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E918F408F59
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:44:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243183AbhIMNmH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:42:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:40602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243776AbhIMNkC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:40:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 756BF614C8;
        Mon, 13 Sep 2021 13:29:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631539746;
        bh=deuDyUC7ukFY9Dx4K5QWJ5oIG8ywpuqET6D2sF01QNM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ErbGmJX5aqbQh0p+MCIpJpTH/a0LsBbBT4Evg1LGNpdD3YpeIIX9VZ1KTG7/Mrh0M
         M93Cz9srA1t/AFPZJhyPLN0fFzx66LeD1cpbkVNmQgr05u8BpZri6Z/wEaKKthU4zK
         UdxAMk82lku+7zYpNJnhW5xZ9Aqozqm0E22HSf+0=
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
Subject: [PATCH 5.10 145/236] ASoC: rt5682: Implement remove callback
Date:   Mon, 13 Sep 2021 15:14:10 +0200
Message-Id: <20210913131105.300916075@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131100.316353015@linuxfoundation.org>
References: <20210913131100.316353015@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephen Boyd <swboyd@chromium.org>

[ Upstream commit 87b42abae99d3d851aec64cd4d0f7def8113950e ]

Let's implement a remove callback for this driver that's similar to the
shutdown hook, but also disables the regulators before they're put by
devm code.

Cc: Jairaj Arava <jairaj.arava@intel.com>
Cc: Sathyanarayana Nujella <sathyanarayana.nujella@intel.com>
Cc: Pierre-Louis Bossart <pierre-louis.bossart@intel.com>
Cc: Shuming Fan <shumingf@realtek.com>
Cc: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
Link: https://lore.kernel.org/r/20210508075151.1626903-2-swboyd@chromium.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt5682-i2c.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/sound/soc/codecs/rt5682-i2c.c b/sound/soc/codecs/rt5682-i2c.c
index 547445d1e3c6..e2b4b10e679a 100644
--- a/sound/soc/codecs/rt5682-i2c.c
+++ b/sound/soc/codecs/rt5682-i2c.c
@@ -275,6 +275,16 @@ static void rt5682_i2c_shutdown(struct i2c_client *client)
 	rt5682_reset(rt5682);
 }
 
+static int rt5682_i2c_remove(struct i2c_client *client)
+{
+	struct rt5682_priv *rt5682 = i2c_get_clientdata(client);
+
+	rt5682_i2c_shutdown(client);
+	regulator_bulk_disable(ARRAY_SIZE(rt5682->supplies), rt5682->supplies);
+
+	return 0;
+}
+
 static const struct of_device_id rt5682_of_match[] = {
 	{.compatible = "realtek,rt5682i"},
 	{},
@@ -301,6 +311,7 @@ static struct i2c_driver rt5682_i2c_driver = {
 		.probe_type = PROBE_PREFER_ASYNCHRONOUS,
 	},
 	.probe = rt5682_i2c_probe,
+	.remove = rt5682_i2c_remove,
 	.shutdown = rt5682_i2c_shutdown,
 	.id_table = rt5682_i2c_id,
 };
-- 
2.30.2



