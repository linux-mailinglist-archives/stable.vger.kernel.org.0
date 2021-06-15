Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D78EB3A84C5
	for <lists+stable@lfdr.de>; Tue, 15 Jun 2021 17:50:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232252AbhFOPv6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Jun 2021 11:51:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:45776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232140AbhFOPvf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Jun 2021 11:51:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F2E0D614A7;
        Tue, 15 Jun 2021 15:49:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623772170;
        bh=CL1FZxBMXtZzqlodM+oS8fWPPciTagavnSrueaHbjIg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XsRRTJSc1HEkNY+Yczp8hw1GWjrrexdK82gl0p6S3VWDaiK3tLnZPGmDHfw9pzD8H
         +Ee3iLWRaufyqKrTN4VNgaOhQiD0eardfXE0HrA+4ZcaeB1pe4Z6aBGyAyddpI5yE7
         ry5c4lxxJT31jtXfGbBy9xpPJy7zk2S1VMvmGmdAq/Au15TZTjNSA0ICEspFIDIYge
         /c/Y6hxHQmkh70ff0dtAJmGhvdYgQfKvUSeptoVCLf31c93/vbS/b7Rn4IkoCBpw2Q
         QOCSxLPj9w3U+EkoQKgs/ode7TcgQ/WBmmZfnJFDfIn8JF7heh4SCkYCYbHqQkCklY
         ywCn+sc6VXt/A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Oder Chiou <oder_chiou@realtek.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.10 18/30] ASoC: rt5682: Fix the fast discharge for headset unplugging in soundwire mode
Date:   Tue, 15 Jun 2021 11:48:55 -0400
Message-Id: <20210615154908.62388-18-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210615154908.62388-1-sashal@kernel.org>
References: <20210615154908.62388-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oder Chiou <oder_chiou@realtek.com>

[ Upstream commit 49783c6f4a4f49836b5a109ae0daf2f90b0d7713 ]

Based on ("5a15cd7fce20b1fd4aece6a0240e2b58cd6a225d"), the setting also
should be set in soundwire mode.

Signed-off-by: Oder Chiou <oder_chiou@realtek.com>
Link: https://lore.kernel.org/r/20210604063150.29925-1-oder_chiou@realtek.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt5682-sdw.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/soc/codecs/rt5682-sdw.c b/sound/soc/codecs/rt5682-sdw.c
index 58fb13132602..aa6c325faeab 100644
--- a/sound/soc/codecs/rt5682-sdw.c
+++ b/sound/soc/codecs/rt5682-sdw.c
@@ -455,7 +455,8 @@ static int rt5682_io_init(struct device *dev, struct sdw_slave *slave)
 
 	regmap_update_bits(rt5682->regmap, RT5682_CBJ_CTRL_2,
 		RT5682_EXT_JD_SRC, RT5682_EXT_JD_SRC_MANUAL);
-	regmap_write(rt5682->regmap, RT5682_CBJ_CTRL_1, 0xd042);
+	regmap_write(rt5682->regmap, RT5682_CBJ_CTRL_1, 0xd142);
+	regmap_update_bits(rt5682->regmap, RT5682_CBJ_CTRL_5, 0x0700, 0x0600);
 	regmap_update_bits(rt5682->regmap, RT5682_CBJ_CTRL_3,
 		RT5682_CBJ_IN_BUF_EN, RT5682_CBJ_IN_BUF_EN);
 	regmap_update_bits(rt5682->regmap, RT5682_SAR_IL_CMD_1,
-- 
2.30.2

