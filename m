Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C160B566BA9
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:09:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234342AbiGEMJX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:09:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234428AbiGEMHd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:07:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E25D01902C;
        Tue,  5 Jul 2022 05:06:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8051B61806;
        Tue,  5 Jul 2022 12:06:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87D7EC385A2;
        Tue,  5 Jul 2022 12:06:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657022783;
        bh=36+4ZDYC4CLujRBchcBNuJ618y3mx5X8Y/pZqGVeE1s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TSWPdIXo2MDmc7wDxdFmy6w1lWBhbX1u/17ggSU+6IrItKTlw2a1psP9sHn7hEFEm
         VJNdMD4NKELc2AyFfMPmFn73EzRAK2fFLti7cVPNLCXbhiQlmfUlicdhK/p+62opI7
         GSlt0qvzuNu25dfN+vWUfmJXTO/OTfd+A0uD+/ZQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ruili Ji <ruiliji2@amd.com>,
        Philip Yang <philip.yang@amd.com>,
        Aaron Liu <aaron.liu@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.10 01/84] drm/amdgpu: To flush tlb for MMHUB of RAVEN series
Date:   Tue,  5 Jul 2022 13:57:24 +0200
Message-Id: <20220705115615.369222070@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115615.323395630@linuxfoundation.org>
References: <20220705115615.323395630@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
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
@@ -689,7 +689,8 @@ int amdgpu_amdkfd_flush_gpu_tlb_pasid(st
 	const uint32_t flush_type = 0;
 	bool all_hub = false;
 
-	if (adev->family == AMDGPU_FAMILY_AI)
+	if (adev->family == AMDGPU_FAMILY_AI ||
+	    adev->family == AMDGPU_FAMILY_RV)
 		all_hub = true;
 
 	return amdgpu_gmc_flush_gpu_tlb_pasid(adev, pasid, flush_type, all_hub);


