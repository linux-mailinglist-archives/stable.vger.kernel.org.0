Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20AF1396086
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:26:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232517AbhEaO1j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:27:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:48838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233803AbhEaOZe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:25:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A108C610C9;
        Mon, 31 May 2021 13:46:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468808;
        bh=NgqBK5O0c8z+xdSceHuA/JFflWomRRH/0/Ht41mjRBA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hedgdZjTAJMOa7rNQac4Do5w11NNmfp2QKEtU66jC7gwiZ3SBYfdFZ8J085jP9gxe
         B11BfV1Zegsb+LTU976XYR3ldEdCu6OcVvfdHdTWPZho729TQ2WF9i3cuJaGZEDYNA
         YnjIC0smCdbRANXumyURvhCbWr+n0ahb1tB39j7o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Richard Fitzgerald <rf@opensource.cirrus.com>,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 137/177] ASoC: cs42l42: Regmap must use_single_read/write
Date:   Mon, 31 May 2021 15:14:54 +0200
Message-Id: <20210531130652.667575878@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130647.887605866@linuxfoundation.org>
References: <20210531130647.887605866@linuxfoundation.org>
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
index dcd2acb2c3ce..5faf8877137a 100644
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



