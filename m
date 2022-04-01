Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0625D4EEFB3
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 16:28:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347056AbiDAO3y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 10:29:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347144AbiDAO3O (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 10:29:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08335287A2E;
        Fri,  1 Apr 2022 07:27:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9368561C33;
        Fri,  1 Apr 2022 14:27:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 109F3C2BBE4;
        Fri,  1 Apr 2022 14:27:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648823228;
        bh=mOr3lNQXdbCJKrjBLq76MigGAjQCXtmASAMKe4k0eGs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dgqYvqFlugiMbIb63Z7ypu21gjUojGLk7a87MS7hc8qoKoJehw55qjbKXldIePGMU
         fC9IYBVOc5aQunoz8RV/nr/M+0GlRXnhB56rZYy91zXAWaUTNkAbt5xZ51WTMrGpjV
         hWI4ZyaF3mwVP+8tKqjwayLi7iT+G/ZNDNO3/EIr9k7zW2MNymL0vQH48aFDs9PP3g
         7Rt5YHByKGJCf3HpcIuUTj+DW8n1nJoGnvYd7nO2/OUb6VLYmcEOiEYcpY10R9D/CU
         2zGB9hS9dP+mxsAFctduMQdOkyXplVybF+NnoXfJTPHSAERxl8d4jxCUZF2q3IDeEM
         A5oVTYRwu8jWw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Tianci.Yin" <tianci.yin@amd.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Yang Wang <kevinyang.wang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, christian.koenig@amd.com,
        Xinhui.Pan@amd.com, airlied@linux.ie, daniel@ffwll.ch,
        andrey.grodzovsky@amd.com, evan.quan@amd.com, Jack.Zhang1@amd.com,
        lijo.lazar@amd.com, kevin1.wang@amd.com,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.17 024/149] drm/amdgpu: Fix an error message in rmmod
Date:   Fri,  1 Apr 2022 10:23:31 -0400
Message-Id: <20220401142536.1948161-24-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401142536.1948161-1-sashal@kernel.org>
References: <20220401142536.1948161-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: "Tianci.Yin" <tianci.yin@amd.com>

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
index ed077de426d9..b793682071b2 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -2708,11 +2708,11 @@ static int amdgpu_device_ip_fini_early(struct amdgpu_device *adev)
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
2.34.1

