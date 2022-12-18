Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B926B650279
	for <lists+stable@lfdr.de>; Sun, 18 Dec 2022 17:47:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232625AbiLRQrg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Dec 2022 11:47:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231773AbiLRQq0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Dec 2022 11:46:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96CF8117C;
        Sun, 18 Dec 2022 08:17:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3447860DB4;
        Sun, 18 Dec 2022 16:17:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B80FC433F0;
        Sun, 18 Dec 2022 16:16:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671380219;
        bh=CsNLAzcVT3fORf6e3IVn0A5FKRHKNj/8OngaaPgL4to=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jW0ihtLlRH0R1ZCF1YAuYcJpen8Q8dz5PmPA3b7styZnM4yj9nHsa8Zorn6wZrej9
         7d/XR6PQ7+jGdNXP34VibmS5pjiDm8LhpewLwmn6iH5gWXzRQnZcV4LvcynHqFUn5O
         fkI3K4hrwAH2frG5Uk1MkP08auxPXaTfQiMsHqnZnu/EHp60mc4BVtR+T9fH0656lX
         oJXSDPHr7BO9cwWFj7HpUFUBmS7Sl3jWxmwdaHvF+5jybBdtQL+HGZpZtmWzh9egHi
         ygssmIqrapIXLi9T8vffLJzws/z5GnvFoa3/Turiq9aUMyTOkT0grbmiDwvGPDb5x2
         yBv6BeH8aNEPA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nathan Chancellor <nathan@kernel.org>,
        Sami Tolvanen <samitolvanen@google.com>,
        Kees Cook <keescook@chromium.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, christian.koenig@amd.com,
        Xinhui.Pan@amd.com, airlied@gmail.com, daniel@ffwll.ch,
        ndesaulniers@google.com, Hawking.Zhang@amd.com,
        PengJu.Zhou@amd.com, lijo.lazar@amd.com, horace.chen@amd.com,
        Victor.Zhao@amd.com, victor.skvortsov@amd.com,
        danijel.slivka@amd.com, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, llvm@lists.linux.dev
Subject: [PATCH AUTOSEL 5.10 14/39] drm/amdgpu: Fix type of second parameter in trans_msg() callback
Date:   Sun, 18 Dec 2022 11:15:34 -0500
Message-Id: <20221218161559.932604-14-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221218161559.932604-1-sashal@kernel.org>
References: <20221218161559.932604-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <nathan@kernel.org>

[ Upstream commit f0d0f1087333714ee683cc134a95afe331d7ddd9 ]

With clang's kernel control flow integrity (kCFI, CONFIG_CFI_CLANG),
indirect call targets are validated against the expected function
pointer prototype to make sure the call target is valid to help mitigate
ROP attacks. If they are not identical, there is a failure at run time,
which manifests as either a kernel panic or thread getting killed. A
proposed warning in clang aims to catch these at compile time, which
reveals:

  drivers/gpu/drm/amd/amdgpu/mxgpu_ai.c:412:15: error: incompatible function pointer types initializing 'void (*)(struct amdgpu_device *, u32, u32, u32, u32)' (aka 'void (*)(struct amdgpu_device *, unsigned int, unsigned int, unsigned int, unsigned int)') with an expression of type 'void (struct amdgpu_device *, enum idh_request, u32, u32, u32)' (aka 'void (struct amdgpu_device *, enum idh_request, unsigned int, unsigned int, unsigned int)') [-Werror,-Wincompatible-function-pointer-types-strict]
          .trans_msg = xgpu_ai_mailbox_trans_msg,
                      ^~~~~~~~~~~~~~~~~~~~~~~~~
  1 error generated.

  drivers/gpu/drm/amd/amdgpu/mxgpu_nv.c:435:15: error: incompatible function pointer types initializing 'void (*)(struct amdgpu_device *, u32, u32, u32, u32)' (aka 'void (*)(struct amdgpu_device *, unsigned int, unsigned int, unsigned int, unsigned int)') with an expression of type 'void (struct amdgpu_device *, enum idh_request, u32, u32, u32)' (aka 'void (struct amdgpu_device *, enum idh_request, unsigned int, unsigned int, unsigned int)') [-Werror,-Wincompatible-function-pointer-types-strict]
          .trans_msg = xgpu_nv_mailbox_trans_msg,
                      ^~~~~~~~~~~~~~~~~~~~~~~~~
  1 error generated.

The type of the second parameter in the prototype should be 'enum
idh_request' instead of 'u32'. Update it to clear up the warnings.

Link: https://github.com/ClangBuiltLinux/linux/issues/1750
Reported-by: Sami Tolvanen <samitolvanen@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_virt.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.h
index aea49bad914f..fbd92fff8b06 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.h
@@ -62,6 +62,8 @@ struct amdgpu_vf_error_buffer {
 	uint64_t data[AMDGPU_VF_ERROR_ENTRY_SIZE];
 };
 
+enum idh_request;
+
 /**
  * struct amdgpu_virt_ops - amdgpu device virt operations
  */
@@ -71,7 +73,8 @@ struct amdgpu_virt_ops {
 	int (*req_init_data)(struct amdgpu_device *adev);
 	int (*reset_gpu)(struct amdgpu_device *adev);
 	int (*wait_reset)(struct amdgpu_device *adev);
-	void (*trans_msg)(struct amdgpu_device *adev, u32 req, u32 data1, u32 data2, u32 data3);
+	void (*trans_msg)(struct amdgpu_device *adev, enum idh_request req,
+			  u32 data1, u32 data2, u32 data3);
 };
 
 /*
-- 
2.35.1

