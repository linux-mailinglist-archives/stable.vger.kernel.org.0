Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68FD95419C3
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:27:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349370AbiFGVYD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:24:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379068AbiFGVXQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:23:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 309A2226CFA;
        Tue,  7 Jun 2022 12:00:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 46A47617D6;
        Tue,  7 Jun 2022 19:00:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51660C385A2;
        Tue,  7 Jun 2022 19:00:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628434;
        bh=YwECxjUBPNlcBAdzuS3oVPUZZ6QHWvrITawN4M2aj/Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zRwh6P7fRv9ZuQde9oxQmBeifYul9/yu3zEIiiF61Ozoc1qhxB9vnWO+oXGTKxl2Q
         a04gSJcTOJyYLUNYi7ek9ga6QHqLGUVoIKOZtRnoQ4JhnFdng51PJIi5IfpML3OGc7
         0reVrKabDhqCKpyWl8T1TIao06lSB6murt970ld4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxime Ripard <maxime@cerno.tech>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 288/879] drm/vc4: kms: Take old state core clock rate into account
Date:   Tue,  7 Jun 2022 18:56:46 +0200
Message-Id: <20220607165011.207047074@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxime Ripard <maxime@cerno.tech>

[ Upstream commit 748acfc98adab21a93ae7a1b5bed0f048463e873 ]

During a commit, the core clock, which feeds the HVS, needs to run at
a minimum of 500MHz.

While doing that commit, we can also change the mode to one that
requires a higher core clock, so we take the core clock rate associated
to that new state into account for that boost.

However, the old state also needs to be taken into account if it
requires a core clock higher that the new one and our 500MHz limit,
since it's still live in hardware at the beginning of our commit.

Fixes: 16e101051f32 ("drm/vc4: Increase the core clock based on HVS load")
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Acked-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://lore.kernel.org/r/20220331143744.777652-2-maxime@cerno.tech
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_kms.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/vc4/vc4_kms.c b/drivers/gpu/drm/vc4/vc4_kms.c
index 24de29bc1cda..992d6a240002 100644
--- a/drivers/gpu/drm/vc4/vc4_kms.c
+++ b/drivers/gpu/drm/vc4/vc4_kms.c
@@ -385,9 +385,10 @@ static void vc4_atomic_commit_tail(struct drm_atomic_state *state)
 	}
 
 	if (vc4->hvs->hvs5) {
+		unsigned long state_rate = max(old_hvs_state->core_clock_rate,
+					       new_hvs_state->core_clock_rate);
 		unsigned long core_rate = max_t(unsigned long,
-						500000000,
-						new_hvs_state->core_clock_rate);
+						500000000, state_rate);
 
 		clk_set_min_rate(hvs->core_clk, core_rate);
 	}
-- 
2.35.1



