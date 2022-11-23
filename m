Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11586635777
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:43:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237915AbiKWJnU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:43:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237958AbiKWJmK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:42:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 357A01157A9
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:40:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B6922B81E54
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:40:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB4A7C433C1;
        Wed, 23 Nov 2022 09:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669196406;
        bh=GnFHhqJgy5Blx6aSCEt1Q21ZwsxFFTu/xTF3zjzbjCI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E/5hgRoJLrmh4IYclkc8pByuOoHLikjPLNlFZ+rZwPK4RKdGlcS1TfHqkFL2Gf+PS
         CdNdykFI2e0bAcpriZxAF47BfBcpTBdDGVBikD06KB4IgGW4BRQVSPchLjFPBjiWO8
         A1N55hgj4UGcPnwr9BBOaKMw1Vg+jw72omU3xNK8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Shuming Fan <shumingf@realtek.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 022/314] ASoC: rt1308-sdw: add the default value of some registers
Date:   Wed, 23 Nov 2022 09:47:47 +0100
Message-Id: <20221123084626.512339686@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 6668e19d85d4..b5f231f708cb 100644
--- a/sound/soc/codecs/rt1308-sdw.h
+++ b/sound/soc/codecs/rt1308-sdw.h
@@ -139,10 +139,12 @@ static const struct reg_default rt1308_reg_defaults[] = {
 	{ 0x3005, 0x23 },
 	{ 0x3008, 0x02 },
 	{ 0x300a, 0x00 },
+	{ 0xc000 | (RT1308_DATA_PATH << 4), 0x00 },
 	{ 0xc003 | (RT1308_DAC_SET << 4), 0x00 },
 	{ 0xc000 | (RT1308_POWER << 4), 0x00 },
 	{ 0xc001 | (RT1308_POWER << 4), 0x00 },
 	{ 0xc002 | (RT1308_POWER << 4), 0x00 },
+	{ 0xc000 | (RT1308_POWER_STATUS << 4), 0x00 },
 };
 
 #define RT1308_SDW_OFFSET 0xc000
-- 
2.35.1



