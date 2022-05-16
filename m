Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DDA8528FF7
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 22:43:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347010AbiEPUFZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 16:05:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348920AbiEPT7D (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 15:59:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C1CE36B53;
        Mon, 16 May 2022 12:52:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CEEDF60A50;
        Mon, 16 May 2022 19:52:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8B92C385AA;
        Mon, 16 May 2022 19:52:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652730772;
        bh=4GxQ34/+ri7Qh6zlKXsr+5UTPU54ZBwlSGvG+PEYU6g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BmjGDpLWvbkypYEP6NojjKXF7hVuypjFUOyaBbdZ6PMqINNoiploo9NMbKZfMsohL
         FBXj2Uc9aZVYikpiiVsLPitCd+FmiFC7dMdympbe7TZO7N68m9M+lyTcLpCOsIM58I
         4v+cHBXJgHxy9IgJ64+1oZsRQpCTys5hqbc4tAtA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lijo Lazar <lijo.lazar@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.15 096/102] Revert "drm/amd/pm: keep the BACO feature enabled for suspend"
Date:   Mon, 16 May 2022 21:37:10 +0200
Message-Id: <20220516193626.757688026@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516193623.989270214@linuxfoundation.org>
References: <20220516193623.989270214@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Deucher <alexander.deucher@amd.com>

commit a56f445f807b0276fc0660c330bf93a9ea78e8ea upstream.

This reverts commit eaa090538e8d21801c6d5f94590c3799e6a528b5.

Commit ebc002e3ee78 ("drm/amdgpu: don't use BACO for reset in S3")
stops using BACO for reset during suspend, so it's no longer
necessary to leave BACO enabled during suspend.  This fixes
resume from suspend on the navy flounder dGPU in the ASUS ROG
Strix G513QY.

Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/2008
Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/1982
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

--- a/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
@@ -1386,14 +1386,8 @@ static int smu_disable_dpms(struct smu_c
 {
 	struct amdgpu_device *adev = smu->adev;
 	int ret = 0;
-	/*
-	 * TODO: (adev->in_suspend && !adev->in_s0ix) is added to pair
-	 * the workaround which always reset the asic in suspend.
-	 * It's likely that workaround will be dropped in the future.
-	 * Then the change here should be dropped together.
-	 */
 	bool use_baco = !smu->is_apu &&
-		(((amdgpu_in_reset(adev) || (adev->in_suspend && !adev->in_s0ix)) &&
+		((amdgpu_in_reset(adev) &&
 		  (amdgpu_asic_reset_method(adev) == AMD_RESET_METHOD_BACO)) ||
 		 ((adev->in_runpm || adev->in_s4) && amdgpu_asic_supports_baco(adev)));
 


