Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DB3E551B66
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:47:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245381AbiFTNPI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:15:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345204AbiFTNOQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:14:16 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 442081FA7F;
        Mon, 20 Jun 2022 06:06:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6D807CE1391;
        Mon, 20 Jun 2022 13:05:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 346F9C3411B;
        Mon, 20 Jun 2022 13:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655730328;
        bh=35ASCPnS8+xGT0L0LVS2NYvX5iXNUglTyS4P5OUQwgg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XuS2mHAgv0omWgoJbTwlh4OouWfZx6nrIKQDmIVBuVQU0dZWhZeBQRliXixtpVfr+
         9lM8NaGubXRKlLeBkeFGXBjmeD3dCt9r7o3FpQHbW2Gw01hhn0g2AJbSn7PDxcS+2u
         LcxKUeEU4Zf95QfEDX5VKL6bzlN2XG9tCwW34dSA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adam Ford <aford173@gmail.com>,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 019/106] ASoC: wm8962: Fix suspend while playing music
Date:   Mon, 20 Jun 2022 14:50:38 +0200
Message-Id: <20220620124724.953424961@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124724.380838401@linuxfoundation.org>
References: <20220620124724.380838401@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adam Ford <aford173@gmail.com>

[ Upstream commit d1f5272c0f7d2e53c6f2480f46725442776f5f78 ]

If the audio CODEC is playing sound when the system is suspended,
it can be left in a state which throws the following error:

wm8962 3-001a: ASoC: error at soc_component_read_no_lock on wm8962.3-001a: -16

Once this error has occurred, the audio will not work again until rebooted.

Fix this by configuring SET_SYSTEM_SLEEP_PM_OPS.

Signed-off-by: Adam Ford <aford173@gmail.com>
Acked-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20220526182129.538472-1-aford173@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm8962.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/codecs/wm8962.c b/sound/soc/codecs/wm8962.c
index ba16bdf9e478..a5a4ae4440cc 100644
--- a/sound/soc/codecs/wm8962.c
+++ b/sound/soc/codecs/wm8962.c
@@ -3867,6 +3867,7 @@ static int wm8962_runtime_suspend(struct device *dev)
 #endif
 
 static const struct dev_pm_ops wm8962_pm = {
+	SET_SYSTEM_SLEEP_PM_OPS(pm_runtime_force_suspend, pm_runtime_force_resume)
 	SET_RUNTIME_PM_OPS(wm8962_runtime_suspend, wm8962_runtime_resume, NULL)
 };
 
-- 
2.35.1



