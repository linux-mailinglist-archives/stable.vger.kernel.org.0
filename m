Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3F1E63580F
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:50:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236638AbiKWJuS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:50:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238150AbiKWJtv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:49:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7402D59863
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:46:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2A04FB81EEB
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:46:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54D99C433C1;
        Wed, 23 Nov 2022 09:46:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669196810;
        bh=1nZIFsBLETaHVlBjF+KRhcubpVHezQcCC8KqLfNBNvA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wZMtVCeNtCcChbRKDuqB+zUUohoamSMSwrDkhvBg7zA7b1MoHb079ShZoTSwv+Pag
         fNOADFyHpn74zg76/fVve8t/hmFU610IVVGTRSiOo8ZKTe2er9rscuNnSd9DLjaFoS
         b+4laiSKp0si7f5NQeLE5IQGNyRY0rWx6m7Q7AZg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Shang XiaoJing <shangxiaojing@huawei.com>,
        Lyude Paul <lyude@redhat.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 130/314] drm: Fix potential null-ptr-deref in drm_vblank_destroy_worker()
Date:   Wed, 23 Nov 2022 09:49:35 +0100
Message-Id: <20221123084631.425929232@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
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

From: Shang XiaoJing <shangxiaojing@huawei.com>

[ Upstream commit 4979524f5a2a8210e87fde2f642b0dc060860821 ]

drm_vblank_init() call drmm_add_action_or_reset() with
drm_vblank_init_release() as action. If __drmm_add_action() failed, will
directly call drm_vblank_init_release() with the vblank whose worker is
NULL. As the resule, a null-ptr-deref will happen in
kthread_destroy_worker(). Add the NULL check before calling
drm_vblank_destroy_worker().

BUG: null-ptr-deref
KASAN: null-ptr-deref in range [0x0000000000000068-0x000000000000006f]
CPU: 5 PID: 961 Comm: modprobe Not tainted 6.0.0-11331-gd465bff130bf-dirty
RIP: 0010:kthread_destroy_worker+0x25/0xb0
  Call Trace:
    <TASK>
    drm_vblank_init_release+0x124/0x220 [drm]
    ? drm_crtc_vblank_restore+0x8b0/0x8b0 [drm]
    __drmm_add_action_or_reset+0x41/0x50 [drm]
    drm_vblank_init+0x282/0x310 [drm]
    vkms_init+0x35f/0x1000 [vkms]
    ? 0xffffffffc4508000
    ? lock_is_held_type+0xd7/0x130
    ? __kmem_cache_alloc_node+0x1c2/0x2b0
    ? lock_is_held_type+0xd7/0x130
    ? 0xffffffffc4508000
    do_one_initcall+0xd0/0x4f0
    ...
    do_syscall_64+0x35/0x80
    entry_SYSCALL_64_after_hwframe+0x46/0xb0

Fixes: 5e6c2b4f9161 ("drm/vblank: Add vblank works")
Signed-off-by: Shang XiaoJing <shangxiaojing@huawei.com>
Reviewed-by: Lyude Paul <lyude@redhat.com>
Signed-off-by: Lyude Paul <lyude@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20221101070716.9189-3-shangxiaojing@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_internal.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_internal.h b/drivers/gpu/drm/drm_internal.h
index 7bb98e6a446d..5ea5e260118c 100644
--- a/drivers/gpu/drm/drm_internal.h
+++ b/drivers/gpu/drm/drm_internal.h
@@ -104,7 +104,8 @@ static inline void drm_vblank_flush_worker(struct drm_vblank_crtc *vblank)
 
 static inline void drm_vblank_destroy_worker(struct drm_vblank_crtc *vblank)
 {
-	kthread_destroy_worker(vblank->worker);
+	if (vblank->worker)
+		kthread_destroy_worker(vblank->worker);
 }
 
 int drm_vblank_worker_init(struct drm_vblank_crtc *vblank);
-- 
2.35.1



