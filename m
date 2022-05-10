Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF0DB5218F2
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:39:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243491AbiEJNkn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:40:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245201AbiEJNii (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:38:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E2E7DF5F;
        Tue, 10 May 2022 06:28:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 249F0B81DA2;
        Tue, 10 May 2022 13:28:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79D23C385C6;
        Tue, 10 May 2022 13:28:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652189322;
        bh=ighqq+8BTA6i60Rh16ci84mBTU+PHJGizR7t8a8h21o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gv0ANQXoEqGTUJeppdWf7GMxaG3t5FpHUZaCDnQdD3n50aZdGXFeuzWnaxTrecRtP
         U10fLuFI5hVmjuMJQKoKtxjgnbkdcBZ8hj9c5jtv/lKmSIB4kUO0LrOylzCRbF2wBs
         2WjDa13bnGEdlcSI8qF7UeYy2AySUD74ciGJsG04=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Marek=20Marczykowski-G=C3=B3recki?= 
        <marmarek@invisiblethingslab.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.15 014/135] drm/amdgpu: do not use passthrough mode in Xen dom0
Date:   Tue, 10 May 2022 15:06:36 +0200
Message-Id: <20220510130740.808126555@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130740.392653815@linuxfoundation.org>
References: <20220510130740.392653815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>

commit 19965d8259fdabc6806da92adda49684f5bcbec5 upstream.

While technically Xen dom0 is a virtual machine too, it does have
access to most of the hardware so it doesn't need to be considered a
"passthrough". Commit b818a5d37454 ("drm/amdgpu/gmc: use PCI BARs for
APUs in passthrough") changed how FB is accessed based on passthrough
mode. This breaks amdgpu in Xen dom0 with message like this:

    [drm:dc_dmub_srv_wait_idle [amdgpu]] *ERROR* Error waiting for DMUB idle: status=3

While the reason for this failure is unclear, the passthrough mode is
not really necessary in Xen dom0 anyway. So, to unbreak booting affected
kernels, disable passthrough mode in this case.

Link: https://gitlab.freedesktop.org/drm/amd/-/issues/1985
Fixes: b818a5d37454 ("drm/amdgpu/gmc: use PCI BARs for APUs in passthrough")
Signed-off-by: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c
@@ -24,6 +24,7 @@
 #include <linux/module.h>
 
 #include <drm/drm_drv.h>
+#include <xen/xen.h>
 
 #include "amdgpu.h"
 #include "amdgpu_ras.h"
@@ -694,7 +695,8 @@ void amdgpu_detect_virtualization(struct
 		adev->virt.caps |= AMDGPU_SRIOV_CAPS_ENABLE_IOV;
 
 	if (!reg) {
-		if (is_virtual_machine())	/* passthrough mode exclus sriov mod */
+		/* passthrough mode exclus sriov mod */
+		if (is_virtual_machine() && !xen_initial_domain())
 			adev->virt.caps |= AMDGPU_PASSTHROUGH_MODE;
 	}
 


