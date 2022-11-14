Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42BF06280B0
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 14:08:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237861AbiKNNIK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 08:08:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237863AbiKNNIJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 08:08:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71F7C2AE18
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 05:08:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 281E0B80EBB
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 13:08:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77AEBC433C1;
        Mon, 14 Nov 2022 13:08:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668431285;
        bh=9f13ZuhC2LHdWwnP5YQSA1OSY48VKJX1DhHtGAAQlpw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kPPvW6Sk29kP82ecEu09iiZ8+JER7/eItus5vwtTrkJNVenEh0LBm0zpgYeeuCdvC
         DLjjMX0ypSnve2tTj6zr+Bra6g0c7lU8Qoh5cQu2/3skMSRYUdpzTTQ0QYrxTuhlI7
         KHCwyijsG/zb6MylZNBhg5VnX/Vtnm4SPZNFv8jc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Philip Yang <Philip.Yang@amd.com>,
        Stefan Springer <stefanspr94@gmail.com>
Subject: [PATCH 6.0 140/190] drm/amdgpu: workaround for TLB seq race
Date:   Mon, 14 Nov 2022 13:46:04 +0100
Message-Id: <20221114124504.924870162@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
References: <20221114124458.806324402@linuxfoundation.org>
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

From: Christian König <christian.koenig@amd.com>

commit 77c092e054262b594614bad5e5f47e57c5d29639 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.h |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.h
@@ -485,6 +485,21 @@ void amdgpu_debugfs_vm_bo_info(struct am
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
 


