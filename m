Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECA6A4CF757
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:44:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238312AbiCGJpl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:45:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240973AbiCGJln (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:41:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B11206C1CA;
        Mon,  7 Mar 2022 01:38:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 392C4B8102B;
        Mon,  7 Mar 2022 09:38:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73EFCC340F3;
        Mon,  7 Mar 2022 09:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646645928;
        bh=Ljpn8FdyEg3DeGHMfdNwKAXkMrJs/1K06M6QjXTJynQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d+4GFnPo+NGMku5ctl6vTPh7ZNUoS8xH6WCamUda8Lar1oMz4SnQgvywckPqGLDkw
         /A1GqFMBNgihf5i3d76rMDgQWUV71xw16ZzVswqx3cfS+uJ4Qi3Dhql4YR19F3GaaG
         txNHgn50N7Sm13degQ2STguVvEbwzdKHT7lsjrU0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matthew Auld <matthew.auld@intel.com>,
        =?UTF-8?q?Thomas=20Hellstr=C3=B6m?= 
        <thomas.hellstrom@linux.intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 079/262] drm/i915: dont call free_mmap_offset when purging
Date:   Mon,  7 Mar 2022 10:17:03 +0100
Message-Id: <20220307091704.720213737@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091702.378509770@linuxfoundation.org>
References: <20220307091702.378509770@linuxfoundation.org>
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

From: Matthew Auld <matthew.auld@intel.com>

[ Upstream commit 4c2602ba8d74c35d550ed3d518809c697de08d88 ]

The TTM backend is in theory the only user here(also purge should only
be called once we have dropped the pages), where it is setup at object
creation and is only removed once the object is destroyed. Also
resetting the node here might be iffy since the ttm fault handler
uses the stored fake offset to determine the page offset within the pages
array.

This also blows up in the dontneed-before-mmap test, since the
expectation is that the vma_node will live on, until the object is
destroyed:

<2> [749.062902] kernel BUG at drivers/gpu/drm/i915/gem/i915_gem_ttm.c:943!
<4> [749.062923] invalid opcode: 0000 [#1] PREEMPT SMP NOPTI
<4> [749.062928] CPU: 0 PID: 1643 Comm: gem_madvise Tainted: G     U  W         5.16.0-rc8-CI-CI_DRM_11046+ #1
<4> [749.062933] Hardware name: Gigabyte Technology Co., Ltd. GB-Z390 Garuda/GB-Z390 Garuda-CF, BIOS IG1c 11/19/2019
<4> [749.062937] RIP: 0010:i915_ttm_mmap_offset.cold.35+0x5b/0x5d [i915]
<4> [749.063044] Code: 00 48 c7 c2 a0 23 4e a0 48 c7 c7 26 df 4a a0 e8 95 1d d0 e0 bf 01 00 00 00 e8 8b ec cf e0 31 f6 bf 09 00 00 00 e8 5f 30 c0 e0 <0f> 0b 48 c7 c1 24 4b 56 a0 ba 5b 03 00 00 48 c7 c6 c0 23 4e a0 48
<4> [749.063052] RSP: 0018:ffffc90002ab7d38 EFLAGS: 00010246
<4> [749.063056] RAX: 0000000000000240 RBX: ffff88811f2e61c0 RCX: 0000000000000006
<4> [749.063060] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000009
<4> [749.063063] RBP: ffffc90002ab7e58 R08: 0000000000000001 R09: 0000000000000001
<4> [749.063067] R10: 000000000123d0f8 R11: ffffc90002ab7b20 R12: ffff888112a1a000
<4> [749.063071] R13: 0000000000000004 R14: ffff88811f2e61c0 R15: ffff888112a1a000
<4> [749.063074] FS:  00007f6e5fcad500(0000) GS:ffff8884ad600000(0000) knlGS:0000000000000000
<4> [749.063078] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
<4> [749.063081] CR2: 00007efd264e39f0 CR3: 0000000115fd6005 CR4: 00000000003706f0
<4> [749.063085] Call Trace:
<4> [749.063087]  <TASK>
<4> [749.063089]  __assign_mmap_offset+0x41/0x300 [i915]
<4> [749.063171]  __assign_mmap_offset_handle+0x159/0x270 [i915]
<4> [749.063248]  ? i915_gem_dumb_mmap_offset+0x70/0x70 [i915]
<4> [749.063325]  drm_ioctl_kernel+0xae/0x140
<4> [749.063330]  drm_ioctl+0x201/0x3d0
<4> [749.063333]  ? i915_gem_dumb_mmap_offset+0x70/0x70 [i915]
<4> [749.063409]  ? do_user_addr_fault+0x200/0x670
<4> [749.063415]  __x64_sys_ioctl+0x6d/0xa0
<4> [749.063419]  do_syscall_64+0x3a/0xb0
<4> [749.063423]  entry_SYSCALL_64_after_hwframe+0x44/0xae
<4> [749.063428] RIP: 0033:0x7f6e5f100317

Testcase: igt/gem_madvise/dontneed-before-mmap
Fixes: cf3e3e86d779 ("drm/i915: Use ttm mmap handling for ttm bo's.")
Signed-off-by: Matthew Auld <matthew.auld@intel.com>
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Reviewed-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220106174910.280616-1-matthew.auld@intel.com
(cherry picked from commit 658a0c632625e1db51837ff754fe18a6a7f2ccf8)
Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gem/i915_gem_pages.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/gem/i915_gem_pages.c b/drivers/gpu/drm/i915/gem/i915_gem_pages.c
index 8d6c38a622016..9053cea3395a6 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_pages.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_pages.c
@@ -162,7 +162,6 @@ int i915_gem_object_pin_pages_unlocked(struct drm_i915_gem_object *obj)
 /* Immediately discard the backing storage */
 void i915_gem_object_truncate(struct drm_i915_gem_object *obj)
 {
-	drm_gem_free_mmap_offset(&obj->base);
 	if (obj->ops->truncate)
 		obj->ops->truncate(obj);
 }
-- 
2.34.1



