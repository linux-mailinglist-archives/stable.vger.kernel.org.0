Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8A9139625B
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:53:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232029AbhEaOze (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:55:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:47900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234043AbhEaOxR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:53:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B4BFE61940;
        Mon, 31 May 2021 13:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622469511;
        bh=SlQlGdBtKRw7QmtPK5kNIhIjbhgwVireYQ+K5Wcy4v4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X2DkRd0YdR8mBBGxdmO/PFc3iEF1ibDhEk4Xa+4uFY/Dd6tq7rYZK3gR+GDbcreD3
         RklpzlMeBU3yqqzDkeEkY12Mr+DVhYKhNvoYDSWp3KpHu9VAsovhLEIIQq0Gpe96oR
         Sc9LSAxpEdb9vBoeuDhpZpwaMBqQTlu2ZzP/iUMk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Richard Fitzgerald <rf@opensource.cirrus.com>,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 226/296] ASoC: cs42l42: Regmap must use_single_read/write
Date:   Mon, 31 May 2021 15:14:41 +0200
Message-Id: <20210531130711.425494788@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130703.762129381@linuxfoundation.org>
References: <20210531130703.762129381@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit 0fad605fb0bdc00d8ad78696300ff2fbdee6e048 ]

cs42l42 does not support standard burst transfers so the use_single_read
and use_single_write flags must be set in the regmap config.

Because of this bug, the patch:

commit 0a0eb567e1d4 ("ASoC: cs42l42: Minor error paths fixups")

broke cs42l42 probe() because without the use_single_* flags it causes
regmap to issue a burst read.

However, the missing use_single_* could cause problems anyway because the
regmap cache can attempt burst transfers if these flags are not set.

Fixes: 2c394ca79604 ("ASoC: Add support for CS42L42 codec")
Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Acked-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20210511132855.27159-1-rf@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs42l42.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/soc/codecs/cs42l42.c b/sound/soc/codecs/cs42l42.c
index 811b7b1c9732..323a4f7f384c 100644
--- a/sound/soc/codecs/cs42l42.c
+++ b/sound/soc/codecs/cs42l42.c
@@ -398,6 +398,9 @@ static const struct regmap_config cs42l42_regmap = {
 	.reg_defaults = cs42l42_reg_defaults,
 	.num_reg_defaults = ARRAY_SIZE(cs42l42_reg_defaults),
 	.cache_type = REGCACHE_RBTREE,
+
+	.use_single_read = true,
+	.use_single_write = true,
 };
 
 static DECLARE_TLV_DB_SCALE(adc_tlv, -9600, 100, false);
-- 
2.30.2



