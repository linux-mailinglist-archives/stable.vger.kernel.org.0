Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 560565412E4
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 21:56:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357113AbiFGTyv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 15:54:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358575AbiFGTwn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 15:52:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 126DFBE179;
        Tue,  7 Jun 2022 11:21:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BF455B82368;
        Tue,  7 Jun 2022 18:21:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29D43C385A2;
        Tue,  7 Jun 2022 18:21:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654626068;
        bh=YwECxjUBPNlcBAdzuS3oVPUZZ6QHWvrITawN4M2aj/Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qs/EuL1IN3AlML2zhJu1w6BEx3JXkJOqvnqDFvxtwQOkQHKS0AjgYAJxFI4C+Vy0a
         ynVPROYqurQwf1ztmiwAoXYwsjqvYL3j6lx8mxjmbc1YgWOfYIK6uEnu1BdyhD+HXT
         1BiSkZm7/gkGSnlYHGKM5WfumRCZrSYXiO5KVgbc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxime Ripard <maxime@cerno.tech>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 245/772] drm/vc4: kms: Take old state core clock rate into account
Date:   Tue,  7 Jun 2022 18:57:17 +0200
Message-Id: <20220607164956.246082246@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
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



