Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 651C14CFA4D
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 11:16:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234412AbiCGKPP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 05:15:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240095AbiCGKNV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 05:13:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F26D68EB4D;
        Mon,  7 Mar 2022 01:56:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 55BBAB80E70;
        Mon,  7 Mar 2022 09:56:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D916C340F5;
        Mon,  7 Mar 2022 09:56:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646647003;
        bh=a59L6cbCaihpl0CgpDK8YABw6K8r1Qt65ZHzx/JCx9U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1yonRPmleBzCzpgMOY2xln3xArRL1SVnZMUQ7fea4VUZfx9KPvdvF8Nij6lYUN3g2
         ycU88+q3XByB92/m4seBfBGEgxORKUDvx47YeCyJ16nbt9IUUyGu6yXAodvzsM2JiZ
         d41XMRTHZeH/sSRCSVQ1ulVHhhAD32lf6QTJVFzA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Qiang Yu <qiang.yu@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 162/186] drm/amdgpu: fix suspend/resume hang regression
Date:   Mon,  7 Mar 2022 10:20:00 +0100
Message-Id: <20220307091658.605408817@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091654.092878898@linuxfoundation.org>
References: <20220307091654.092878898@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qiang Yu <qiang.yu@amd.com>

[ Upstream commit f1ef17011c765495c876fa75435e59eecfdc1ee4 ]

Regression has been reported that suspend/resume may hang with
the previous vm ready check commit.

So bring back the evicted list check as a temp fix.

Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/1922
Fixes: c1a66c3bc425 ("drm/amdgpu: check vm ready by amdgpu_vm->evicting flag")
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Qiang Yu <qiang.yu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
index bc8d83698880..e73c09d05b6e 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
@@ -777,7 +777,8 @@ bool amdgpu_vm_ready(struct amdgpu_vm *vm)
 	amdgpu_vm_eviction_lock(vm);
 	ret = !vm->evicting;
 	amdgpu_vm_eviction_unlock(vm);
-	return ret;
+
+	return ret && list_empty(&vm->evicted);
 }
 
 /**
-- 
2.34.1



