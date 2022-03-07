Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAB814CF77A
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:45:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238419AbiCGJqM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:46:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240983AbiCGJlo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:41:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E06E6D194;
        Mon,  7 Mar 2022 01:38:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 016F2B810CC;
        Mon,  7 Mar 2022 09:33:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AF16C340F3;
        Mon,  7 Mar 2022 09:33:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646645633;
        bh=FKaTv4ewBvPPtU04iar21AHuOmepis0nGGadrUm3lE0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t7OsAvqbtDJDEnuCOsP8RGVIEUbJTVmmglIeRRS2B/wZQeWH6lMeVpsitU/u0syiD
         aqFF6Lqmh3Q+AA7mkCtfkX8uGof6CXL6OVcygO14BX8jZfij6zLVL4Oh/BA/ysxK+1
         V/Kb6zKhjmR+D+USm4cdTLCqhBea4QlNA1UdzEoM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Qiang Yu <qiang.yu@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 093/105] drm/amdgpu: fix suspend/resume hang regression
Date:   Mon,  7 Mar 2022 10:19:36 +0100
Message-Id: <20220307091646.793701042@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091644.179885033@linuxfoundation.org>
References: <20220307091644.179885033@linuxfoundation.org>
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
index 47cc038d7d50..635601d8b131 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
@@ -724,7 +724,8 @@ bool amdgpu_vm_ready(struct amdgpu_vm *vm)
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



