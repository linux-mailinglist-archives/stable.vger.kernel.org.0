Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BF704B4775
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 10:54:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244750AbiBNJrH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 04:47:07 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245291AbiBNJpw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 04:45:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F431706EF;
        Mon, 14 Feb 2022 01:38:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CDBAAB80DA9;
        Mon, 14 Feb 2022 09:38:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1471C340E9;
        Mon, 14 Feb 2022 09:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644831529;
        bh=4z0v3PPvCg4WiVwNoyKv8OfaYZmEcK4u21TEwyIWMEA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bdLAQeOX1sdqILT0X5/CtXisOpxZvGT/wriVV8YNGel83EqJ6//UFIGqdeiCQxC3C
         7qSuA7Aq0su1NS0Ze0TV5u4bZ+TqQRifMpAdAHWgnKTOUPaHh/WEuc94FC7Nm94474
         CcB2V374fE+Sui3jiMOQFggtglWBelRbd7La+MhA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rui Wang <wangr@lemote.com>,
        Huacai Chen <chenhc@lemote.com>,
        Xi Ruoyao <xry111@mengyan1223.wang>,
        =?UTF-8?q?Dan=20Hor=C3=A1k?= <dan@danny.cz>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Timothy Pearson <tpearson@raptorengineering.com>,
        Salvatore Bonaccorso <carnil@debian.org>
Subject: [PATCH 5.10 012/116] drm/amdgpu: Set a suitable dev_info.gart_page_size
Date:   Mon, 14 Feb 2022 10:25:11 +0100
Message-Id: <20220214092459.108124663@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092458.668376521@linuxfoundation.org>
References: <20220214092458.668376521@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Huacai Chen <chenhc@lemote.com>

commit f4d3da72a76a9ce5f57bba64788931686a9dc333 upstream.

In Mesa, dev_info.gart_page_size is used for alignment and it was
set to AMDGPU_GPU_PAGE_SIZE(4KB). However, the page table of AMDGPU
driver requires an alignment on CPU pages.  So, for non-4KB page system,
gart_page_size should be max_t(u32, PAGE_SIZE, AMDGPU_GPU_PAGE_SIZE).

Signed-off-by: Rui Wang <wangr@lemote.com>
Signed-off-by: Huacai Chen <chenhc@lemote.com>
Link: https://github.com/loongson-community/linux-stable/commit/caa9c0a1
[Xi: rebased for drm-next, use max_t for checkpatch,
     and reworded commit message.]
Signed-off-by: Xi Ruoyao <xry111@mengyan1223.wang>
BugLink: https://gitlab.freedesktop.org/drm/amd/-/issues/1549
Tested-by: Dan Horák <dan@danny.cz>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
[Salvatore Bonaccorso: Backport to 5.10.y which does not contain
a5a52a43eac0 ("drm/amd/amdgpu/amdgpu_kms: Remove 'struct
drm_amdgpu_info_device dev_info' from the stack") which removes dev_info
from the stack and places it on the heap.]
Tested-by: Timothy Pearson <tpearson@raptorengineering.com>
Signed-off-by: Salvatore Bonaccorso <carnil@debian.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c
@@ -766,9 +766,9 @@ static int amdgpu_info_ioctl(struct drm_
 			dev_info.high_va_offset = AMDGPU_GMC_HOLE_END;
 			dev_info.high_va_max = AMDGPU_GMC_HOLE_END | vm_size;
 		}
-		dev_info.virtual_address_alignment = max((int)PAGE_SIZE, AMDGPU_GPU_PAGE_SIZE);
+		dev_info.virtual_address_alignment = max_t(u32, PAGE_SIZE, AMDGPU_GPU_PAGE_SIZE);
 		dev_info.pte_fragment_size = (1 << adev->vm_manager.fragment_size) * AMDGPU_GPU_PAGE_SIZE;
-		dev_info.gart_page_size = AMDGPU_GPU_PAGE_SIZE;
+		dev_info.gart_page_size = max_t(u32, PAGE_SIZE, AMDGPU_GPU_PAGE_SIZE);
 		dev_info.cu_active_number = adev->gfx.cu_info.number;
 		dev_info.cu_ao_mask = adev->gfx.cu_info.ao_cu_mask;
 		dev_info.ce_ram_size = adev->gfx.ce_ram_size;


