Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BBEE5419A5
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:23:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377913AbiFGVXf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:23:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378618AbiFGVWj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:22:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B146A226556;
        Tue,  7 Jun 2022 12:00:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DC89D617E8;
        Tue,  7 Jun 2022 18:59:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBF66C385A2;
        Tue,  7 Jun 2022 18:59:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628399;
        bh=gmKKWmpotjYcp8qIaAw1Rg5fTRetCkoV8RD+koRbpAk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nq5mviCJyF/d2YiVq4+5SRUtp2dg/Tkqlg5g+M2HW9LSops+wOzgoiCwU4zIFURRi
         wZ6U9LUsk3NlFtcveDLtOApBz5zYYRRkzxnLs1NAE1LRNJomS+j09Pnt4uhoRc9rsd
         fQ/CKVj1lj//6nTwXpxgCKaN7HYtJXe1YnmA2Evw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Deucher <alexander.deucher@amd.com>,
        Gavin Wan <Gavin.Wan@amd.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 314/879] drm/amd/amdgpu: Remove static from variable in RLCG Reg RW
Date:   Tue,  7 Jun 2022 18:57:12 +0200
Message-Id: <20220607165011.961968301@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gavin Wan <Gavin.Wan@amd.com>

[ Upstream commit d68cf992ded575928cf4ddf7c64faff0d8dcce14 ]

[why]
These static variables save the RLC Scratch registers address.
When we install multiple GPUs (for example: XGMI setting) and
multiple GPUs call the function at same time. The RLC Scratch
registers address are changed each other. Then it caused
reading/writing from/to wrong GPU.

[how]
Removed the static from the variables. The variables are
on the stack.

Fixes: 5d447e29670148 ("drm/amdgpu: add helper for rlcg indirect reg access")
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Gavin Wan <Gavin.Wan@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c
index 5e3756643da3..1d55b2bae37e 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c
@@ -864,11 +864,11 @@ static u32 amdgpu_virt_rlcg_reg_rw(struct amdgpu_device *adev, u32 offset, u32 v
 	uint32_t timeout = 50000;
 	uint32_t i, tmp;
 	uint32_t ret = 0;
-	static void *scratch_reg0;
-	static void *scratch_reg1;
-	static void *scratch_reg2;
-	static void *scratch_reg3;
-	static void *spare_int;
+	void *scratch_reg0;
+	void *scratch_reg1;
+	void *scratch_reg2;
+	void *scratch_reg3;
+	void *spare_int;
 
 	if (!adev->gfx.rlc.rlcg_reg_access_supported) {
 		dev_err(adev->dev,
-- 
2.35.1



