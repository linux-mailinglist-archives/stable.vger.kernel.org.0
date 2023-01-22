Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B82F676F59
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:20:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231236AbjAVPUa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:20:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231238AbjAVPU3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:20:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85F852203F
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:20:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 41A80B80B1B
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:20:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91C14C433EF;
        Sun, 22 Jan 2023 15:20:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674400825;
        bh=iWBhOR3tiqHKL6w7EWqf1jPTFmfJiAK171phNrqQBR0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UEZJ0OpTPt4mAqY6C4oJwdQ9bj4pdcCPWEWNYF4QYrO6tXfT71z+BJmdeE0KSXm48
         SzyNLGnaD/A46jcgj7MUtkolj3Qg96BvcZl/N9ubcnVc9/gbiLUV5gP0VWfu+Bl/sk
         Z21a9Bjrlpi8wyvqYVx6rC3W155iK5P0n8T4rtF0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Alex Deucher <alexander.deucher@amd.com>,
        kolAflash@kolahilft.de, jrf@mailbox.org, mario.limonciello@amd.com
Subject: [PATCH 5.15 103/117] Revert "drm/amdgpu: make display pinning more flexible (v2)"
Date:   Sun, 22 Jan 2023 16:04:53 +0100
Message-Id: <20230122150237.119191565@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150232.736358800@linuxfoundation.org>
References: <20230122150232.736358800@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Deucher <alexander.deucher@amd.com>

This reverts commit 78623b10fc9f8231802536538c85527dc54640a0 which is
commit 81d0bcf9900932633d270d5bc4a54ff599c6ebdb upstream.

This commit causes hiberation regressions on some platforms on kernels
older than 6.1.x (6.1.x and newer kernels works fine) so let's revert it
from 5.15 and older stable kernels.  This should be reverted from 6.0.x
as well, but that kernel is no longer supported.

Bug: https://bugzilla.kernel.org/show_bug.cgi?id=216917
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: kolAflash@kolahilft.de
Cc: jrf@mailbox.org
Cc: mario.limonciello@amd.com
Cc: stable@vger.kernel.org # 5.15.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_object.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
@@ -1510,8 +1510,7 @@ u64 amdgpu_bo_gpu_offset_no_check(struct
 uint32_t amdgpu_bo_get_preferred_domain(struct amdgpu_device *adev,
 					    uint32_t domain)
 {
-	if ((domain == (AMDGPU_GEM_DOMAIN_VRAM | AMDGPU_GEM_DOMAIN_GTT)) &&
-	    ((adev->asic_type == CHIP_CARRIZO) || (adev->asic_type == CHIP_STONEY))) {
+	if (domain == (AMDGPU_GEM_DOMAIN_VRAM | AMDGPU_GEM_DOMAIN_GTT)) {
 		domain = AMDGPU_GEM_DOMAIN_VRAM;
 		if (adev->gmc.real_vram_size <= AMDGPU_SG_THRESHOLD)
 			domain = AMDGPU_GEM_DOMAIN_GTT;


