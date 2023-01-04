Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E40B765D652
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 15:44:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239660AbjADOoJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 09:44:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239668AbjADOoI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 09:44:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61C3D1ADA5
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 06:44:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 10F77B81699
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 14:44:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36EA0C433F1;
        Wed,  4 Jan 2023 14:44:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672843444;
        bh=MN7YRUbcCxk4rcYFnEnAN9XHGydSj9qqmO39auDqU7U=;
        h=Subject:To:Cc:From:Date:From;
        b=2btpYIiWJ+8VZzfiqfGcuV+h5t9S+9QFl6SiZLrJrE7yoXF+0xW5xnMazbzWq6PaM
         o7JtzYvjLF20xrcgRwgBiTlCQH/G/II2Wpp8aHRPXwfU1qyLACcHL148vigsEpJkhR
         vJXOS5uYO2mC1yfMp+rerIpzUyGbod3gRRVlTvNQ=
Subject: FAILED: patch "[PATCH] drm/amdgpu: workaround for TLB seq race" failed to apply to 6.1-stable tree
To:     christian.koenig@amd.com, Philip.Yang@amd.com,
        alexander.deucher@amd.com, stefanspr94@gmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 04 Jan 2023 15:44:00 +0100
Message-ID: <1672843440158175@kroah.com>
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


The patch below does not apply to the 6.1-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

f9e694964503 ("drm/amdgpu: workaround for TLB seq race")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From f9e69496450352fa0504fd5a8fd9134b31116558 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Date: Wed, 2 Nov 2022 14:55:13 +0100
Subject: [PATCH] drm/amdgpu: workaround for TLB seq race
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

It can happen that we query the sequence value before the callback
had a chance to run.

Workaround that by grabbing the fence lock and releasing it again.
Should be replaced by hw handling soon.

Signed-off-by: Christian König <christian.koenig@amd.com>
CC: stable@vger.kernel.org # 5.19+
Fixes: 5255e146c99a6 ("drm/amdgpu: rework TLB flushing")
Link: https://gitlab.freedesktop.org/drm/amd/-/issues/2113
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Acked-by: Philip Yang <Philip.Yang@amd.com>
Tested-by: Stefan Springer <stefanspr94@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.h
index 83acb7bd80fe..1d31771b4230 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.h
@@ -492,6 +492,21 @@ void amdgpu_debugfs_vm_bo_info(struct amdgpu_vm *vm, struct seq_file *m);
  */
 static inline uint64_t amdgpu_vm_tlb_seq(struct amdgpu_vm *vm)
 {
+	unsigned long flags;
+	spinlock_t *lock;
+
+	/*
+	 * Workaround to stop racing between the fence signaling and handling
+	 * the cb. The lock is static after initially setting it up, just make
+	 * sure that the dma_fence structure isn't freed up.
+	 */
+	rcu_read_lock();
+	lock = vm->last_tlb_flush->lock;
+	rcu_read_unlock();
+
+	spin_lock_irqsave(lock, flags);
+	spin_unlock_irqrestore(lock, flags);
+
 	return atomic64_read(&vm->tlb_seq);
 }
 

