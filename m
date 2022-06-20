Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0963551979
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:06:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244163AbiFTNGC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:06:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244102AbiFTNEe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:04:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23DC3193EE;
        Mon, 20 Jun 2022 06:00:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D0C72B811A0;
        Mon, 20 Jun 2022 13:00:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 462EBC3411C;
        Mon, 20 Jun 2022 12:59:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655729999;
        bh=4eEArlpWSzPV0yFPHRd+8RXA4uz8/VX0gZoxA2wJTCg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y3J6mQqj3InNeqMkvCLmHNGmHr7/i/2s5AQZ98NO41xF5UHM6yFCKSGOC3cl6e217
         RVI62tB622prTtm519xJivHDH5FJuPjwPKd4lYLtA7+a2oPGxqYf+E2WISFzOxgxMP
         5WMU6yG59FCyQM7Fz+3kK4XPVEA679g40WOBy9CU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Martin Roukala <martin.roukala@mupuf.org>,
        Mike Lothian <mike@fireburn.co.uk>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        =?UTF-8?q?Michel=20D=C3=A4nzer?= <mdaenzer@redhat.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.18 121/141] drm/amdgpu: Fix GTT size reporting in amdgpu_ioctl
Date:   Mon, 20 Jun 2022 14:50:59 +0200
Message-Id: <20220620124733.127207927@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124729.509745706@linuxfoundation.org>
References: <20220620124729.509745706@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Michel Dänzer <mdaenzer@redhat.com>

commit c904e3acbab3fd97649cd4ab1ff7f1521ad3a255 upstream.

The commit below changed the TTM manager size unit from pages to
bytes, but failed to adjust the corresponding calculations in
amdgpu_ioctl.

Fixes: dfa714b88eb0 ("drm/amdgpu: remove GTT accounting v2")
Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/1930
Bug: https://gitlab.freedesktop.org/mesa/mesa/-/issues/6642
Tested-by: Martin Roukala <martin.roukala@mupuf.org>
Tested-by: Mike Lothian <mike@fireburn.co.uk>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Michel Dänzer <mdaenzer@redhat.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 5.18.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c
@@ -634,7 +634,6 @@ int amdgpu_info_ioctl(struct drm_device
 			    atomic64_read(&adev->visible_pin_size),
 			    vram_gtt.vram_size);
 		vram_gtt.gtt_size = ttm_manager_type(&adev->mman.bdev, TTM_PL_TT)->size;
-		vram_gtt.gtt_size *= PAGE_SIZE;
 		vram_gtt.gtt_size -= atomic64_read(&adev->gart_pin_size);
 		return copy_to_user(out, &vram_gtt,
 				    min((size_t)size, sizeof(vram_gtt))) ? -EFAULT : 0;
@@ -667,7 +666,6 @@ int amdgpu_info_ioctl(struct drm_device
 			mem.cpu_accessible_vram.usable_heap_size * 3 / 4;
 
 		mem.gtt.total_heap_size = gtt_man->size;
-		mem.gtt.total_heap_size *= PAGE_SIZE;
 		mem.gtt.usable_heap_size = mem.gtt.total_heap_size -
 			atomic64_read(&adev->gart_pin_size);
 		mem.gtt.heap_usage = ttm_resource_manager_usage(gtt_man);


