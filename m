Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABE774FD3E4
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:00:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352681AbiDLHgi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:36:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345177AbiDLHbX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:31:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE86150058;
        Tue, 12 Apr 2022 00:08:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 47248B81B4E;
        Tue, 12 Apr 2022 07:08:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3A1BC385B7;
        Tue, 12 Apr 2022 07:08:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649747309;
        bh=h1/zFxNl/9AODl5mu6g3Vx4iIcbiKVoR2kXvfkVY7UY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ql95LVOiyFF2/zHywtuAjRI5hKez0WuxzvkSpVlZsaWbKO1Q8PrynGrt18cd/kxiS
         Ek8XTf0nPDuH9pUpTe1XkWg2wYOafxCf696CapApNIPKSO1bndvDz75QsA4h5AAGa1
         /tHwrkjoEqGkLQ1Iu0y7TlZFJcTCrPpH2BthYafY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felix Kuehling <Felix.Kuehling@amd.com>,
        Yang Wang <kevinyang.wang@amd.com>,
        "Tianci.Yin" <tianci.yin@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 033/343] drm/amdgpu: Fix an error message in rmmod
Date:   Tue, 12 Apr 2022 08:27:31 +0200
Message-Id: <20220412062952.062299541@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062951.095765152@linuxfoundation.org>
References: <20220412062951.095765152@linuxfoundation.org>
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

From: Tianci.Yin <tianci.yin@amd.com>

[ Upstream commit 7270e8957eb9aacf5914605d04865f3829a14bce ]

[why]
In rmmod procedure, kfd sends cp a dequeue request, but the
request does not get response, then an error message "cp
queue pipe 4 queue 0 preemption failed" printed.

[how]
Performing kfd suspending after disabling gfxoff can fix it.

Acked-by: Felix Kuehling <Felix.Kuehling@amd.com>
Reviewed-by: Yang Wang <kevinyang.wang@amd.com>
Signed-off-by: Tianci.Yin <tianci.yin@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index f18c698137a6..b87dca6d09fa 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -2723,11 +2723,11 @@ static int amdgpu_device_ip_fini_early(struct amdgpu_device *adev)
 		}
 	}
 
-	amdgpu_amdkfd_suspend(adev, false);
-
 	amdgpu_device_set_pg_state(adev, AMD_PG_STATE_UNGATE);
 	amdgpu_device_set_cg_state(adev, AMD_CG_STATE_UNGATE);
 
+	amdgpu_amdkfd_suspend(adev, false);
+
 	/* Workaroud for ASICs need to disable SMC first */
 	amdgpu_device_smu_fini_early(adev);
 
-- 
2.35.1



