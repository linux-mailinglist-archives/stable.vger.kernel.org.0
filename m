Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2DB363DE45
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:35:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbiK3Sfb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:35:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230372AbiK3SfU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:35:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DF0193A79
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:35:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2B3FD61D6F
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:35:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BE5FC433C1;
        Wed, 30 Nov 2022 18:35:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669833318;
        bh=ZAwl0ACzd3+G4lbTVx/VqBe3fLgAPj+hpodVWq+QNA8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bb4GxVn4qAzTUVFv6X617snY2fKBm5UZIqzjb7IcxLatJ5mziltsyYly484HYNUK0
         O+xBTKJrDFmaAMK6A0Sw9SYa8bMnsxoyDnvSx4zQ2rRfNJT0WN3TNoqy0u68tbpGub
         3PlkmOM+EtmauXT7GmxSyiizw1BPBMYwuOwGjtg4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 064/206] ASoC: max98373: Add checks for devm_kcalloc
Date:   Wed, 30 Nov 2022 19:21:56 +0100
Message-Id: <20221130180534.627991536@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180532.974348590@linuxfoundation.org>
References: <20221130180532.974348590@linuxfoundation.org>
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

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

[ Upstream commit 60591bbf6d5eb44f275eb733943b7757325c1b60 ]

As the devm_kcalloc may return NULL pointer,
it should be better to check the return value
in order to avoid NULL poineter dereference.

Fixes: 349dd23931d1 ("ASoC: max98373: don't access volatile registers in bias level off")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Link: https://lore.kernel.org/r/20221116082508.17418-1-jiasheng@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/max98373-i2c.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/sound/soc/codecs/max98373-i2c.c b/sound/soc/codecs/max98373-i2c.c
index ddb6436835d7..68497a4521dd 100644
--- a/sound/soc/codecs/max98373-i2c.c
+++ b/sound/soc/codecs/max98373-i2c.c
@@ -551,6 +551,10 @@ static int max98373_i2c_probe(struct i2c_client *i2c,
 	max98373->cache = devm_kcalloc(&i2c->dev, max98373->cache_num,
 				       sizeof(*max98373->cache),
 				       GFP_KERNEL);
+	if (!max98373->cache) {
+		ret = -ENOMEM;
+		return ret;
+	}
 
 	for (i = 0; i < max98373->cache_num; i++)
 		max98373->cache[i].reg = max98373_i2c_cache_reg[i];
-- 
2.35.1



