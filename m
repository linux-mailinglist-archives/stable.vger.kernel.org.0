Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A83BD54963B
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:34:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378298AbiFMNlA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 09:41:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378994AbiFMNjf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 09:39:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E67F7937F;
        Mon, 13 Jun 2022 04:28:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 068D36114A;
        Mon, 13 Jun 2022 11:28:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 122A5C3411E;
        Mon, 13 Jun 2022 11:28:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655119705;
        bh=8PGhjs0A2YdVyurjxtWzr47UU3TE7+riO+Iw8NBZlA8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l7ZE1NUunO3w4Sp4gwbDHLMiz6K0V/1M8WyJcY3uzW+AmNXh1+bkWPPyoIRVNUJ8c
         OHS1FUK6aTGuvAKudIvKqLPUDg4wpL0fXc531oQ4LaqywA4QiBWs7+XHG/lwhIp/2d
         sOOyFsllkxgJ7er0OtI9ZdXy0yyf3xEgIX8MtTBQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Harry Wentland <harry.wentland@amd.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 091/339] drm/amdgpu: Off by one in dm_dmub_outbox1_low_irq()
Date:   Mon, 13 Jun 2022 12:08:36 +0200
Message-Id: <20220613094929.275871423@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094926.497929857@linuxfoundation.org>
References: <20220613094926.497929857@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit a35faec3db0e13aac8ea720bc1a3503081dd5a3d ]

The > ARRAY_SIZE() should be >= ARRAY_SIZE() to prevent an out of bounds
access.

Fixes: e27c41d5b068 ("drm/amd/display: Support for DMUB HPD interrupt handling")
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 62139ff35476..8dd03de7c277 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -771,7 +771,7 @@ static void dm_dmub_outbox1_low_irq(void *interrupt_params)
 
 		do {
 			dc_stat_get_dmub_notification(adev->dm.dc, &notify);
-			if (notify.type > ARRAY_SIZE(dm->dmub_thread_offload)) {
+			if (notify.type >= ARRAY_SIZE(dm->dmub_thread_offload)) {
 				DRM_ERROR("DM: notify type %d invalid!", notify.type);
 				continue;
 			}
-- 
2.35.1



