Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F79D4F2CFF
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:34:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244373AbiDEJQc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:16:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244993AbiDEIxA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:53:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEE502AD6;
        Tue,  5 Apr 2022 01:48:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 94C94B81A32;
        Tue,  5 Apr 2022 08:48:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF353C385A1;
        Tue,  5 Apr 2022 08:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649148529;
        bh=3739oQgdb/geZIZN2jKhqTo7WUCFX1HT8z90/QnwQvs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cGd164hjLUL6gBM3AdBOXJ1YF8k+497j1tZZHXf6PyrWNtmJFne3cRR1sYW/B7+Am
         VL9ABaoh7gPw9lRbloqktJoheh58qYr4dDE2ndZOgF/XT4f2SM65ja64c3bgF1duDn
         tD6hYagKinufHog1wnEdeOLozgAG/b1Z6O4l0GF8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, TOTE Robot <oslab@tsinghua.edu.cn>,
        Jia-Ju Bai <baijiaju1990@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0350/1017] ASoC: rt5663: check the return value of devm_kzalloc() in rt5663_parse_dp()
Date:   Tue,  5 Apr 2022 09:21:03 +0200
Message-Id: <20220405070404.672082483@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jia-Ju Bai <baijiaju1990@gmail.com>

[ Upstream commit 4d06f92f38b799295ae22c98be7a20cac3e2a1a7 ]

The function devm_kzalloc() in rt5663_parse_dp() can fail, so its return
value should be checked.

Fixes: 457c25efc592 ("ASoC: rt5663: Add the function of impedance sensing")
Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
Link: https://lore.kernel.org/r/20220225131030.27248-1-baijiaju1990@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt5663.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/codecs/rt5663.c b/sound/soc/codecs/rt5663.c
index 2138f62e6af5..3a8fba101b20 100644
--- a/sound/soc/codecs/rt5663.c
+++ b/sound/soc/codecs/rt5663.c
@@ -3478,6 +3478,8 @@ static int rt5663_parse_dp(struct rt5663_priv *rt5663, struct device *dev)
 		table_size = sizeof(struct impedance_mapping_table) *
 			rt5663->pdata.impedance_sensing_num;
 		rt5663->imp_table = devm_kzalloc(dev, table_size, GFP_KERNEL);
+		if (!rt5663->imp_table)
+			return -ENOMEM;
 		ret = device_property_read_u32_array(dev,
 			"realtek,impedance_sensing_table",
 			(u32 *)rt5663->imp_table, table_size);
-- 
2.34.1



