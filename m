Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AE626B4934
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 16:10:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233983AbjCJPKi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 10:10:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233947AbjCJPKS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 10:10:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2104D13845C
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 07:02:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 816EA61A2D
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:53:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7430BC433D2;
        Fri, 10 Mar 2023 14:53:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678460014;
        bh=kzXc2RUPuJwZ+k+KzwAaWOMMOs1615upUcGsuIMEf6A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w9urVZ5n5tVGhkVdZckswZuEjbtHEp3Yukfq0hCXieeAaXYeQcU7gnzlOQfSRRe9H
         8IWNfkHWOW7MCB4wKAyu62ecnXF03h1Z+gbTuLQemMh+vtTamyIR1mW+8GZBxGG7Sh
         B9YaoQNgR6JP9GDrlTvCjF2qKdUsvD55ALYh1e7M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 195/529] ASoC: mchp-spdifrx: fix return value in case completion times out
Date:   Fri, 10 Mar 2023 14:35:38 +0100
Message-Id: <20230310133814.029930615@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Claudiu Beznea <claudiu.beznea@microchip.com>

[ Upstream commit a4c4161d6eae3ef5f486d1638ef452d9bc1376b0 ]

wait_for_completion_interruptible_timeout() returns 0 in case of
timeout. Check this into account when returning from function.

Fixes: ef265c55c1ac ("ASoC: mchp-spdifrx: add driver for SPDIF RX")
Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Link: https://lore.kernel.org/r/20230130120647.638049-3-claudiu.beznea@microchip.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/atmel/mchp-spdifrx.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/sound/soc/atmel/mchp-spdifrx.c b/sound/soc/atmel/mchp-spdifrx.c
index 3962ce00ad34a..076a78fd0b125 100644
--- a/sound/soc/atmel/mchp-spdifrx.c
+++ b/sound/soc/atmel/mchp-spdifrx.c
@@ -524,9 +524,10 @@ static int mchp_spdifrx_cs_get(struct mchp_spdifrx_dev *dev,
 	ret = wait_for_completion_interruptible_timeout(&ch_stat->done,
 							msecs_to_jiffies(100));
 	/* IP might not be started or valid stream might not be present */
-	if (ret < 0) {
+	if (ret <= 0) {
 		dev_dbg(dev->dev, "channel status for channel %d timeout\n",
 			channel);
+		return ret ? : -ETIMEDOUT;
 	}
 
 	memcpy(uvalue->value.iec958.status, ch_stat->data,
@@ -580,7 +581,7 @@ static int mchp_spdifrx_subcode_ch_get(struct mchp_spdifrx_dev *dev,
 		dev_dbg(dev->dev, "user data for channel %d timeout\n",
 			channel);
 		mchp_spdifrx_isr_blockend_dis(dev);
-		return ret;
+		return ret ? : -ETIMEDOUT;
 	}
 
 	spin_lock_irqsave(&user_data->lock, flags);
-- 
2.39.2



