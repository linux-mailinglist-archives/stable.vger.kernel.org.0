Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D84C59497E
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:14:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354185AbiHOXnt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:43:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354354AbiHOXl6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:41:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCDA3326CD;
        Mon, 15 Aug 2022 13:13:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 75949B80EA8;
        Mon, 15 Aug 2022 20:13:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FC26C433D6;
        Mon, 15 Aug 2022 20:13:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594391;
        bh=gvF9vfJBn1E/u+Vk2cnTqk824szUc7KavKwz//HsATE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RMUgFb9jogQUfpWJzZ/5SMEdPzk4BHA2fiY8knFPGYMr/n56Bg4MiqRVdTS1CYPC+
         FVrMt2Fe4wcLcz8gVFkfJOEaJv4Ibhh03D1im8S8duQrz1Az+jaqbBr7hj4IxiEtqX
         hCEMLpUF1OmingnXL3x/iF9M5jnpJ3A2TyY6fJJ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxime Ripard <maxime@cerno.tech>,
        Dave Stevenson <dave.stevenson@raspberrypi.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0406/1157] drm/vc4: kms: Use maximum FIFO load for the HVS clock rate
Date:   Mon, 15 Aug 2022 19:56:02 +0200
Message-Id: <20220815180455.904644417@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Maxime Ripard <maxime@cerno.tech>

[ Upstream commit 1701a23a4ef0993964ccc2f2d5d13f83a5ff4c70 ]

The core clock computation takes into account both the load due to the
input (ie, planes) and its output (ie, encoders).

However, while the input load needs to consider all the planes, and thus
sum all of their associated loads, the output happens mostly in
parallel.

Therefore, we need to consider only the maximum of all the output loads,
and not the sum like we were doing. This resulted in a clock rate way
too high which could be discarded for being too high by the clock
framework.

Since recent changes, the clock framework will even downright reject it,
leading to a core clock being too low for its current needs.

Fixes: 16e101051f32 ("drm/vc4: Increase the core clock based on HVS load")
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Reviewed-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Link: https://lore.kernel.org/r/20220613144800.326124-4-maxime@cerno.tech
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_kms.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/vc4/vc4_kms.c b/drivers/gpu/drm/vc4/vc4_kms.c
index 893d831b24aa..b7353d4c0811 100644
--- a/drivers/gpu/drm/vc4/vc4_kms.c
+++ b/drivers/gpu/drm/vc4/vc4_kms.c
@@ -950,7 +950,9 @@ vc4_core_clock_atomic_check(struct drm_atomic_state *state)
 			continue;
 
 		num_outputs++;
-		cob_rate += hvs_new_state->fifo_state[i].fifo_load;
+		cob_rate = max_t(unsigned long,
+				 hvs_new_state->fifo_state[i].fifo_load,
+				 cob_rate);
 	}
 
 	pixel_rate = load_state->hvs_load;
-- 
2.35.1



