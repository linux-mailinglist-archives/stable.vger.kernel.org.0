Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7674D566D2E
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:21:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232174AbiGEMVa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:21:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237654AbiGEMTd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:19:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E6631D331;
        Tue,  5 Jul 2022 05:15:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 43132B817CC;
        Tue,  5 Jul 2022 12:15:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98B86C341C7;
        Tue,  5 Jul 2022 12:15:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657023355;
        bh=hT7n2waLKXkXqL0BWi/NCBJbGAMUgXPDLfsH4iSWDPM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MmB4TOg8Z0T0H0efvT7S7m/LuoBFa+OVtywY7yp4QyDkeSEYPvWLffD01MmejtPgJ
         J8VhFThA/SpCSFfApRsMkxgfG14A+Nsra1W3hHjixEsK+yuz9Zg9imm8uosFik95zZ
         P79uhDtefzgvB5lJZPRl8Kus1nfMWkwt6180vjns=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ruili Ji <ruiliji2@amd.com>,
        Philip Yang <philip.yang@amd.com>,
        Aaron Liu <aaron.liu@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.18 003/102] drm/amdgpu: To flush tlb for MMHUB of RAVEN series
Date:   Tue,  5 Jul 2022 13:57:29 +0200
Message-Id: <20220705115618.511231301@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115618.410217782@linuxfoundation.org>
References: <20220705115618.410217782@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ruili Ji <ruiliji2@amd.com>

commit 5cb0e3fb2c54eabfb3f932a1574bff1774946bc0 upstream.

amdgpu: [mmhub0] no-retry page fault (src_id:0 ring:40 vmid:8 pasid:32769, for process test_basic pid 3305 thread test_basic pid 3305)
amdgpu: in page starting at address 0x00007ff990003000 from IH client 0x12 (VMC)
amdgpu: VM_L2_PROTECTION_FAULT_STATUS:0x00840051
amdgpu: Faulty UTCL2 client ID: MP1 (0x0)
amdgpu: MORE_FAULTS: 0x1
amdgpu: WALKER_ERROR: 0x0
amdgpu: PERMISSION_FAULTS: 0x5
amdgpu: MAPPING_ERROR: 0x0
amdgpu: RW: 0x1

When memory is allocated by kfd, no one triggers the tlb flush for MMHUB0.
There is page fault from MMHUB0.

v2:fix indentation
v3:change subject and fix indentation

Signed-off-by: Ruili Ji <ruiliji2@amd.com>
Reviewed-by: Philip Yang <philip.yang@amd.com>
Reviewed-by: Aaron Liu <aaron.liu@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c
@@ -703,7 +703,8 @@ int amdgpu_amdkfd_flush_gpu_tlb_pasid(st
 {
 	bool all_hub = false;
 
-	if (adev->family == AMDGPU_FAMILY_AI)
+	if (adev->family == AMDGPU_FAMILY_AI ||
+	    adev->family == AMDGPU_FAMILY_RV)
 		all_hub = true;
 
 	return amdgpu_gmc_flush_gpu_tlb_pasid(adev, pasid, flush_type, all_hub);


