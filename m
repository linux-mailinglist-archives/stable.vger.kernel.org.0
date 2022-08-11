Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5FAF5902DF
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 18:17:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238009AbiHKQQq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 12:16:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237542AbiHKQOk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 12:14:40 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B7DBAA4F0;
        Thu, 11 Aug 2022 08:58:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 83C9ECE225D;
        Thu, 11 Aug 2022 15:58:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBDA8C433D6;
        Thu, 11 Aug 2022 15:58:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660233527;
        bh=drsoLwNUyuxmaoCNziTsEssVslCYX761EjJmCqn/8AM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mLB04iNYu+xeEnrB6fHwEkREZaU16MZw74Xqc9dA3xbIzG1xELsfL1YDDsfI6RIII
         COtH3ZC//ATg8xT+hT6/yBh2npXNgjcr2Hgf285d/gq9MQP8mXLHrVOwhJFko5/rqf
         Ac1F4h0Gz1/MeM2ggv5Fu41dg8B6Cs15FC11CuoDVjQjdGCMbHZqlDcjOqUzXVFpt9
         y8+Mhl725kXyTpBzYpEh9vpETc3NeLAcq4PdpXkOJtghwqK6kWb9IGOgtURuhOXXJZ
         +MJX7yM5bcNQex6GPRemWXcK2g8NdmzqbvZdx64JZjb+BdvuUWbmJPfNg7QZ5V354T
         VkeqxCVm48Zlw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shah Dharati <dharshah@amd.com>,
        Hansen Dsouza <Hansen.Dsouza@amd.com>,
        Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>,
        Hamza Mahfooz <hamza.mahfooz@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, harry.wentland@amd.com,
        sunpeng.li@amd.com, Rodrigo.Siqueira@amd.com,
        christian.koenig@amd.com, Xinhui.Pan@amd.com, airlied@linux.ie,
        daniel@ffwll.ch, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.15 20/69] drm/amd/display: Fix monitor flash issue
Date:   Thu, 11 Aug 2022 11:55:29 -0400
Message-Id: <20220811155632.1536867-20-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811155632.1536867-1-sashal@kernel.org>
References: <20220811155632.1536867-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Shah Dharati <dharshah@amd.com>

[ Upstream commit b840b64bc8ed3fc46f6d6aa7f97c43862a33bea5 ]

[Why & How]
For a some specific monitors, when connected on boot or hot plug,
monitor flash for 1/2 seconds can happen during first HDCP query
operation. Ading some delay in the init sequence for these monitors
fixes the issue, so it is implemented as monitor specific patch.

Co-authored-by: Shah Dharati <dharshah@amd.com>
Reviewed-by: Hansen Dsouza <Hansen.Dsouza@amd.com>
Reviewed-by: Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>
Acked-by: Hamza Mahfooz <hamza.mahfooz@amd.com>
Signed-off-by: Shah Dharati <dharshah@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/modules/hdcp/hdcp2_transition.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/modules/hdcp/hdcp2_transition.c b/drivers/gpu/drm/amd/display/modules/hdcp/hdcp2_transition.c
index 1f4095b26409..c5f6c11de7e5 100644
--- a/drivers/gpu/drm/amd/display/modules/hdcp/hdcp2_transition.c
+++ b/drivers/gpu/drm/amd/display/modules/hdcp/hdcp2_transition.c
@@ -524,7 +524,7 @@ enum mod_hdcp_status mod_hdcp_hdcp2_dp_transition(struct mod_hdcp *hdcp,
 			set_watchdog_in_ms(hdcp, 3000, output);
 			set_state_id(hdcp, output, D2_A6_WAIT_FOR_RX_ID_LIST);
 		} else {
-			callback_in_ms(0, output);
+			callback_in_ms(1, output);
 			set_state_id(hdcp, output, D2_SEND_CONTENT_STREAM_TYPE);
 		}
 		break;
-- 
2.35.1

