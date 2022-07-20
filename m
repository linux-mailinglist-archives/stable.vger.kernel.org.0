Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4464757AB9C
	for <lists+stable@lfdr.de>; Wed, 20 Jul 2022 03:15:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240852AbiGTBOU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 21:14:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240918AbiGTBN6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 21:13:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C928675BF;
        Tue, 19 Jul 2022 18:12:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F3873B81DDD;
        Wed, 20 Jul 2022 01:12:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 038B7C341CA;
        Wed, 20 Jul 2022 01:12:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658279570;
        bh=1EQpcFTZlk54ZdjOp1LnLv7GXGgLmqXYhR43h8huLFE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nAJcd4mAz0WxgC2Rzr4O/vRuhzhaI5r7Fcfl1ecU7pmu1jYsUWNWGDVrjhP2xr4BL
         J/MbhrfvbzYKWRReEfyysUomibjuLfXvvThOEWRNxgpApciALoKviZ9ba+58yCXQOe
         afEspmhm7cEaXlU6HeVI2czN/4AWazxBh4gWuGoZfqVcrl45pGG3GB5Am+XTZkgX1R
         kfevfv7N9TccosOtpJVcvLB1vJkaWhHHeOmAyjGHtsIY21nnZXKLpSF9ENEDqLZUwf
         rktcIhT9UuPmYep3E3HSbuGFSibIDgaom0ZzLCRKKSuotNgZ6CQ+MTkPQ7N803lS14
         HTg3V9qvp3VqQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
        Javier Martinez Canillas <javierm@redhat.com>,
        Sasha Levin <sashal@kernel.org>, airlied@linux.ie,
        daniel@ffwll.ch, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.18 35/54] drm/ssd130x: Fix pre-charge period setting
Date:   Tue, 19 Jul 2022 21:10:12 -0400
Message-Id: <20220720011031.1023305-35-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220720011031.1023305-1-sashal@kernel.org>
References: <20220720011031.1023305-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>

[ Upstream commit b68277f19e31a25312c4acccadb5cf1502e52e84 ]

Fix small typo which causes the mask for the 'precharge1' setting
to be used with the 'precharge2' value.

Signed-off-by: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Acked-by: Javier Martinez Canillas <javierm@redhat.com>
Signed-off-by: Javier Martinez Canillas <javierm@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220706184133.210888-1-ezequiel@vanguardiasur.com.ar
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/solomon/ssd130x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/solomon/ssd130x.c b/drivers/gpu/drm/solomon/ssd130x.c
index 38b6c2c14f53..9a8a8f5606fd 100644
--- a/drivers/gpu/drm/solomon/ssd130x.c
+++ b/drivers/gpu/drm/solomon/ssd130x.c
@@ -293,7 +293,7 @@ static int ssd130x_init(struct ssd130x_device *ssd130x)
 
 	/* Set precharge period in number of ticks from the internal clock */
 	precharge = (SSD130X_SET_PRECHARGE_PERIOD1_SET(ssd130x->prechargep1) |
-		     SSD130X_SET_PRECHARGE_PERIOD1_SET(ssd130x->prechargep2));
+		     SSD130X_SET_PRECHARGE_PERIOD2_SET(ssd130x->prechargep2));
 	ret = ssd130x_write_cmd(ssd130x, 2, SSD130X_SET_PRECHARGE_PERIOD, precharge);
 	if (ret < 0)
 		return ret;
-- 
2.35.1

