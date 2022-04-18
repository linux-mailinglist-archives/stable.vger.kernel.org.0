Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9EEA50533B
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:53:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240488AbiDRM4K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:56:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240344AbiDRMzK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:55:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA336322;
        Mon, 18 Apr 2022 05:36:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4462B6118A;
        Mon, 18 Apr 2022 12:36:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38611C385A1;
        Mon, 18 Apr 2022 12:36:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650285406;
        bh=zH/7jHL6dugySW0mO3c1m2IWKyPePtsE1XQOH3B06Ns=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OfYWN+f3r/HygpbJZONm3VfwgXt8THEDwmxGwgoaz1XnwlJkDqRlUxxiqrhPQwsRl
         Bk8uqOh3IMOsdjikIXvIosCaOuT3zoCeAaX9eOMjBks6oYuDY2GVu7wdeKXQosrz0u
         zm44JK2ArF09JZZH4vYIVDNCUZLnAknsxPSHXmo0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felix Kuehling <Felix.Kuehling@amd.com>,
        Philip Yang <philip.yang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 5.10 001/105] drm/amdkfd: Use drm_priv to pass VM from KFD to amdgpu
Date:   Mon, 18 Apr 2022 14:12:03 +0200
Message-Id: <20220418121145.230114351@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121145.140991388@linuxfoundation.org>
References: <20220418121145.140991388@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
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

From: Felix Kuehling <Felix.Kuehling@amd.com>

commit b40a6ab2cf9213923bf8e821ce7fa7f6a0a26990 upstream.

amdgpu_amdkfd_gpuvm_alloc_memory_of_gpu needs the drm_priv to allow mmap
to access the BO through the corresponding file descriptor. The VM can
also be extracted from drm_priv, so drm_priv can replace the vm parameter
in the kfd2kgd interface.

Signed-off-by: Felix Kuehling <Felix.Kuehling@amd.com>
Reviewed-by: Philip Yang <philip.yang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
[This is a partial cherry-pick of the upstream commit.]
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
@@ -1024,11 +1024,15 @@ int amdgpu_amdkfd_gpuvm_acquire_process_
 					   struct dma_fence **ef)
 {
 	struct amdgpu_device *adev = get_amdgpu_device(kgd);
-	struct drm_file *drm_priv = filp->private_data;
-	struct amdgpu_fpriv *drv_priv = drm_priv->driver_priv;
-	struct amdgpu_vm *avm = &drv_priv->vm;
+	struct amdgpu_fpriv *drv_priv;
+	struct amdgpu_vm *avm;
 	int ret;
 
+	ret = amdgpu_file_to_fpriv(filp, &drv_priv);
+	if (ret)
+		return ret;
+	avm = &drv_priv->vm;
+
 	/* Already a compute VM? */
 	if (avm->process_info)
 		return -EINVAL;


