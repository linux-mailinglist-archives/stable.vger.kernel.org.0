Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D0A262158A
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 15:13:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235269AbiKHONC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 09:13:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235357AbiKHOMt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 09:12:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7FB357B78
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 06:12:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 52935615BF
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 14:12:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E489C433D7;
        Tue,  8 Nov 2022 14:12:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667916761;
        bh=JMX0+L+kjPI4ze7HOqqWQD1de9VHVUvP+QHe6Mn7MB8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fy/D03YQ+PRDacbC4kVJfaa/RL9UmJzmHyJsgC1b9Oh8aSR4exLzLzcddpGTr2YAa
         lfWbexPCcFQSPwQQH5zAvk9j5aQJtBlZ16ngTEf/1D4qe3CCK7lp+OavHKg1ezMlCL
         SvlJuUSepri371N9l07S7F/A/58+/6TCDECq/7ww=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 086/197] drm/amdkfd: Fix type of reset_type parameter in hqd_destroy() callback
Date:   Tue,  8 Nov 2022 14:38:44 +0100
Message-Id: <20221108133358.746856141@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133354.787209461@linuxfoundation.org>
References: <20221108133354.787209461@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



