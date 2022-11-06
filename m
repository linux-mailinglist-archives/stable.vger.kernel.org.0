Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5039961E42E
	for <lists+stable@lfdr.de>; Sun,  6 Nov 2022 18:08:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230370AbiKFRIV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Nov 2022 12:08:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230405AbiKFRHs (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Nov 2022 12:07:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7A9610B61;
        Sun,  6 Nov 2022 09:05:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 082CDB80BFC;
        Sun,  6 Nov 2022 17:05:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4C6FC43147;
        Sun,  6 Nov 2022 17:05:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667754347;
        bh=iH5pRu/Qm6PDTYS5IDVqIZpylnS22TVALPbkNjuUfwI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OrFkbgkk2mgRwoLaRXXkUMYcDZdfk4bWX4taeihg5G/kE8zCcS6sgy4LcjjCxJe3k
         +DOtXnLHVpE7/oShl5E1X2TrsxZqm9dyzB+CZVKNMJEWhkAU8S+xhXNM3vLMDFo+ny
         nK9N8iF9vJ0/oDFNZrwQGKTgn3ORxMNhaNSBCUaD7wIHBuR4PNpULk16MpCWorJtMN
         yKtdvq6/bRgJ7CbM183ARjgopHJOHDmhP9ZB5vvroLcfTOueRYIsOyQyxdZsINxcCU
         a8DATVXc1EWc38OTV7IowTiJqIOjG6BWHz2gknHZdcrppnJTEID3iLh3h9kynsarq6
         7pAJKzxC1otzg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shuming Fan <shumingf@realtek.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, oder_chiou@realtek.com,
        lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.com,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.15 16/18] ASoC: rt1308-sdw: add the default value of some registers
Date:   Sun,  6 Nov 2022 12:05:05 -0500
Message-Id: <20221106170509.1580304-16-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221106170509.1580304-1-sashal@kernel.org>
References: <20221106170509.1580304-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shuming Fan <shumingf@realtek.com>

[ Upstream commit 75d8b1662ca5c20cf8365575222abaef18ff1f50 ]

The driver missed the default value of register 0xc070/0xc360.
This patch adds that default value to avoid invalid register access
when the device doesn't be enumerated yet.
BugLink: https://github.com/thesofproject/linux/issues/3924

Signed-off-by: Shuming Fan <shumingf@realtek.com>
Link: https://lore.kernel.org/r/20221019095715.31082-1-shumingf@realtek.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt1308-sdw.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/codecs/rt1308-sdw.h b/sound/soc/codecs/rt1308-sdw.h
index c5ce75666dcc..98293d73ebab 100644
--- a/sound/soc/codecs/rt1308-sdw.h
+++ b/sound/soc/codecs/rt1308-sdw.h
@@ -139,9 +139,11 @@ static const struct reg_default rt1308_reg_defaults[] = {
 	{ 0x3005, 0x23 },
 	{ 0x3008, 0x02 },
 	{ 0x300a, 0x00 },
+	{ 0xc000 | (RT1308_DATA_PATH << 4), 0x00 },
 	{ 0xc003 | (RT1308_DAC_SET << 4), 0x00 },
 	{ 0xc001 | (RT1308_POWER << 4), 0x00 },
 	{ 0xc002 | (RT1308_POWER << 4), 0x00 },
+	{ 0xc000 | (RT1308_POWER_STATUS << 4), 0x00 },
 };
 
 #define RT1308_SDW_OFFSET 0xc000
-- 
2.35.1

