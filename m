Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD29B3AEF03
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:33:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232069AbhFUQf2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:35:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:55204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231918AbhFUQcT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:32:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D6090613C5;
        Mon, 21 Jun 2021 16:26:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624292762;
        bh=CL1FZxBMXtZzqlodM+oS8fWPPciTagavnSrueaHbjIg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TFhvH9wgx4xNBvoAuTtd2WRT0A0VpOAnsNRVxoEik38VVwdrvDE6avYvOS6bVEGRK
         cASBCo80VVlModmBX4A/kKxQdQB7mN50t7hwAUzqeUfphaV7sBeKixCUsas/8jNW4S
         m6qx+SIDp8hYSNMfJ8l/FprE1zAi/HtURh5R7RkM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oder Chiou <oder_chiou@realtek.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 087/146] ASoC: rt5682: Fix the fast discharge for headset unplugging in soundwire mode
Date:   Mon, 21 Jun 2021 18:15:17 +0200
Message-Id: <20210621154916.605940345@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154911.244649123@linuxfoundation.org>
References: <20210621154911.244649123@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



