Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD55E4C74AA
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:45:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238662AbiB1RqL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:46:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239662AbiB1Ro2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:44:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09A79986C0;
        Mon, 28 Feb 2022 09:36:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D2F946151D;
        Mon, 28 Feb 2022 17:36:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9D28C340F1;
        Mon, 28 Feb 2022 17:36:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646069809;
        bh=B7FyR6OsbPh4DxAfAuyYQOG/G0gHPy9kl+NpBW031cA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W5SSjjQJsT+iS1ieqXYULE7A+TZluDW/xq4XnMhY53ubz4SiTqsr7/+YrwAe29tdI
         KXbH2Qb0MPvazQOrBQdgC0nV/eA2hBw3ZSUHT20WhL8wBfexye+G7zwVIGR8HxF2VW
         AT/Wg753NZGTfIifYrU/zLetrOZkPFwSMM/ot7ao=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Menzel <pmenzel@molgen.mpg.de>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Qiang Yu <qiang.yu@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.15 020/139] drm/amdgpu: check vm ready by amdgpu_vm->evicting flag
Date:   Mon, 28 Feb 2022 18:23:14 +0100
Message-Id: <20220228172350.001376260@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172347.614588246@linuxfoundation.org>
References: <20220228172347.614588246@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qiang Yu <qiang.yu@amd.com>

commit c1a66c3bc425ff93774fb2f6eefa67b83170dd7e upstream.

Workstation application ANSA/META v21.1.4 get this error dmesg when
running CI test suite provided by ANSA/META:
[drm:amdgpu_gem_va_ioctl [amdgpu]] *ERROR* Couldn't update BO_VA (-16)

This is caused by:
1. create a 256MB buffer in invisible VRAM
2. CPU map the buffer and access it causes vm_fault and try to move
   it to visible VRAM
3. force visible VRAM space and traverse all VRAM bos to check if
   evicting this bo is valuable
4. when checking a VM bo (in invisible VRAM), amdgpu_vm_evictable()
   will set amdgpu_vm->evicting, but latter due to not in visible
   VRAM, won't really evict it so not add it to amdgpu_vm->evicted
5. before next CS to clear the amdgpu_vm->evicting, user VM ops
   ioctl will pass amdgpu_vm_ready() (check amdgpu_vm->evicted)
   but fail in amdgpu_vm_bo_update_mapping() (check
   amdgpu_vm->evicting) and get this error log

This error won't affect functionality as next CS will finish the
waiting VM ops. But we'd better clear the error log by checking
the amdgpu_vm->evicting flag in amdgpu_vm_ready() to stop calling
amdgpu_vm_bo_update_mapping() later.

Another reason is amdgpu_vm->evicted list holds all BOs (both
user buffer and page table), but only page table BOs' eviction
prevent VM ops. amdgpu_vm->evicting flag is set only for page
table BOs, so we should use evicting flag instead of evicted list
in amdgpu_vm_ready().

The side effect of this change is: previously blocked VM op (user
buffer in "evicted" list but no page table in it) gets done
immediately.

v2: update commit comments.

Acked-by: Paul Menzel <pmenzel@molgen.mpg.de>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Qiang Yu <qiang.yu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
@@ -768,11 +768,16 @@ int amdgpu_vm_validate_pt_bos(struct amd
  * Check if all VM PDs/PTs are ready for updates
  *
  * Returns:
- * True if eviction list is empty.
+ * True if VM is not evicting.
  */
 bool amdgpu_vm_ready(struct amdgpu_vm *vm)
 {
-	return list_empty(&vm->evicted);
+	bool ret;
+
+	amdgpu_vm_eviction_lock(vm);
+	ret = !vm->evicting;
+	amdgpu_vm_eviction_unlock(vm);
+	return ret;
 }
 
 /**


