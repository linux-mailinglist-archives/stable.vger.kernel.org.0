Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BCCE6148D7
	for <lists+stable@lfdr.de>; Tue,  1 Nov 2022 12:30:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230369AbiKALah (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 07:30:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230385AbiKAL32 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 07:29:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F2A4631F;
        Tue,  1 Nov 2022 04:28:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D1EED615C9;
        Tue,  1 Nov 2022 11:28:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D24A6C433D7;
        Tue,  1 Nov 2022 11:28:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667302129;
        bh=JMX0+L+kjPI4ze7HOqqWQD1de9VHVUvP+QHe6Mn7MB8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZAEnADy11twRDuKz4PV3Qwkr1nQvNnzcIna+PG6ssHIRUPzU5PT7/M1fJWdxLV5WZ
         d0eIn+NupjgxSYjNYKGAJw6umrMt49BF+wMmoeiFTIcEbL/R/tGenu8Jj6PVYNqr4Y
         tM/7Y1jIPyVsYmJoojE753xu5OnM+e8ZPy3FA4t39PrtnqibaKbUQMIQURxJaG9EzM
         6tDCthHtyqPnsusnbTWYDaptrxV8S0rpqyuumJmR/h/SQHyDhC3nj7H7iN4A7WBvJo
         JbF4/YPTcrqx42YQyyoZQ0p0CJXFcVx+Q/ryGVhsx9gIdoRRjWbAAAXDtIF6gDu0ld
         obgHv0th1Bq9w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nathan Chancellor <nathan@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, Felix.Kuehling@amd.com,
        christian.koenig@amd.com, Xinhui.Pan@amd.com, airlied@gmail.com,
        daniel@ffwll.ch, ndesaulniers@google.com,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        llvm@lists.linux.dev
Subject: [PATCH AUTOSEL 6.0 28/34] drm/amdkfd: Fix type of reset_type parameter in hqd_destroy() callback
Date:   Tue,  1 Nov 2022 07:27:20 -0400
Message-Id: <20221101112726.799368-28-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221101112726.799368-1-sashal@kernel.org>
References: <20221101112726.799368-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <nathan@kernel.org>

[ Upstream commit e688ba3e276422aa88eae7a54186a95320836081 ]

When booting a kernel compiled with CONFIG_CFI_CLANG on a machine with
an RX 6700 XT, there is a CFI failure in kfd_destroy_mqd_cp():

  [   12.894543] CFI failure at kfd_destroy_mqd_cp+0x2a/0x40 [amdgpu] (target: hqd_destroy_v10_3+0x0/0x260 [amdgpu]; expected type: 0x8594d794)

Clang's kernel Control Flow Integrity (kCFI) makes sure that all
indirect call targets have a type that exactly matches the function
pointer prototype. In this case, hqd_destroy()'s third parameter,
reset_type, should have a type of 'uint32_t' but every implementation of
this callback has a third parameter type of 'enum kfd_preempt_type'.

Update the function pointer prototype to match reality so that there is
no more CFI violation.

Link: https://github.com/ClangBuiltLinux/linux/issues/1738
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/include/kgd_kfd_interface.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/include/kgd_kfd_interface.h b/drivers/gpu/drm/amd/include/kgd_kfd_interface.h
index e85364dff4e0..5cb3e8634739 100644
--- a/drivers/gpu/drm/amd/include/kgd_kfd_interface.h
+++ b/drivers/gpu/drm/amd/include/kgd_kfd_interface.h
@@ -262,8 +262,9 @@ struct kfd2kgd_calls {
 				uint32_t queue_id);
 
 	int (*hqd_destroy)(struct amdgpu_device *adev, void *mqd,
-				uint32_t reset_type, unsigned int timeout,
-				uint32_t pipe_id, uint32_t queue_id);
+				enum kfd_preempt_type reset_type,
+				unsigned int timeout, uint32_t pipe_id,
+				uint32_t queue_id);
 
 	bool (*hqd_sdma_is_occupied)(struct amdgpu_device *adev, void *mqd);
 
-- 
2.35.1

