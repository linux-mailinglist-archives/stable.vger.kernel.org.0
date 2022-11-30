Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCC2063E042
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:55:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231598AbiK3SzN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:55:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231582AbiK3SzM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:55:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73E08900C0
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:55:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 27015B81CAF
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:55:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A478C433C1;
        Wed, 30 Nov 2022 18:55:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669834508;
        bh=Ps7VVeuETqVnufc7DkyKW+dHE8XLmU7L4GkNtGy/YQc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xJit5pYGtThgFISlipy3c80DouD4FzgbBnLMepY7Fhrsf17InZs0rChStwMSSlPSf
         7uwxjGObT++gdiObgWCQrC6ODVuJbhqA2E7p/tiiGM2Z9VNP8UtoYAu87XspWWmQhQ
         ZZniWzm8YwXnjPVtnVEK92bbWiJ3OSHeE0htEDZI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Niranjana Vishwanathapura <niranjana.vishwanathapura@intel.com>,
        Matthew Auld <matthew.auld@intel.com>,
        Andrzej Hajda <andrzej.hajda@intel.com>,
        Nirmoy Das <nirmoy.das@intel.com>,
        Nirmoy Das <Nirmoy.Das@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Subject: [PATCH 6.0 279/289] drm/i915/ttm: never purge busy objects
Date:   Wed, 30 Nov 2022 19:24:24 +0100
Message-Id: <20221130180550.427758155@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
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

From: Matthew Auld <matthew.auld@intel.com>

commit 00a6c36cca760d0b659f894dee728555b193c5e1 upstream.

In i915_gem_madvise_ioctl() we immediately purge the object is not
currently used, like when the mm.pages are NULL.  With shmem the pages
might still be hanging around or are perhaps swapped out. Similarly with
ttm we might still have the pages hanging around on the ttm resource,
like with lmem or shmem, but here we need to be extra careful since
async unbinds are possible as well as in-progress kernel moves. In
i915_ttm_purge() we expect the pipeline-gutting to nuke the ttm resource
for us, however if it's busy the memory is only moved to a ghost object,
which then leads to broken behaviour when for example clearing the
i915_tt->filp, since the actual ttm_tt is still alive and populated,
even though it's been moved to the ghost object.  When we later destroy
the ghost object we hit the following, since the filp is now NULL:

[  +0.006982] #PF: supervisor read access in kernel mode
[  +0.005149] #PF: error_code(0x0000) - not-present page
[  +0.005147] PGD 11631d067 P4D 11631d067 PUD 115972067 PMD 0
[  +0.005676] Oops: 0000 [#1] PREEMPT SMP NOPTI
[  +0.012962] Workqueue: events ttm_device_delayed_workqueue [ttm]
[  +0.006022] RIP: 0010:i915_ttm_tt_unpopulate+0x3a/0x70 [i915]
[  +0.005879] Code: 89 fb 48 85 f6 74 11 8b 55 4c 48 8b 7d 30 45 31 c0 31 c9 e8 18 6a e5 e0 80 7d 60 00 74 20 48 8b 45 68
8b 55 08 4c 89 e7 5b 5d <48> 8b 40 20 83 e2 01 41 5c 89 d1 48 8b 70
 30 e9 42 b2 ff ff 4c 89
[  +0.018782] RSP: 0000:ffffc9000bf6fd70 EFLAGS: 00010202
[  +0.005244] RAX: 0000000000000000 RBX: ffff8883e12ae380 RCX: 0000000000000000
[  +0.007150] RDX: 000000008000000e RSI: ffffffff823559b4 RDI: ffff8883e12ae3c0
[  +0.007142] RBP: ffff888103b65d48 R08: 0000000000000001 R09: 0000000000000001
[  +0.007144] R10: 0000000000000001 R11: ffff88829c2c8040 R12: ffff8883e12ae3c0
[  +0.007148] R13: 0000000000000001 R14: ffff888115184140 R15: ffff888115184248
[  +0.007154] FS:  0000000000000000(0000) GS:ffff88844db00000(0000) knlGS:0000000000000000
[  +0.008108] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  +0.005763] CR2: 0000000000000020 CR3: 000000013fdb4004 CR4: 00000000003706e0
[  +0.007152] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  +0.007145] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  +0.007154] Call Trace:
[  +0.002459]  <TASK>
[  +0.002126]  ttm_tt_unpopulate.part.0+0x17/0x70 [ttm]
[  +0.005068]  ttm_bo_tt_destroy+0x1c/0x50 [ttm]
[  +0.004464]  ttm_bo_cleanup_memtype_use+0x25/0x40 [ttm]
[  +0.005244]  ttm_bo_cleanup_refs+0x90/0x2c0 [ttm]
[  +0.004721]  ttm_bo_delayed_delete+0x235/0x250 [ttm]
[  +0.004981]  ttm_device_delayed_workqueue+0x13/0x40 [ttm]
[  +0.005422]  process_one_work+0x248/0x560
[  +0.004028]  worker_thread+0x4b/0x390
[  +0.003682]  ? process_one_work+0x560/0x560
[  +0.004199]  kthread+0xeb/0x120
[  +0.003163]  ? kthread_complete_and_exit+0x20/0x20
[  +0.004815]  ret_from_fork+0x1f/0x30

v2:
 - Just use ttm_bo_wait() directly (Niranjana)
 - Add testcase reference

Testcase: igt@gem_madvise@dontneed-evict-race
Fixes: 213d50927763 ("drm/i915/ttm: Introduce a TTM i915 gem object backend")
Reported-by: Niranjana Vishwanathapura <niranjana.vishwanathapura@intel.com>
Signed-off-by: Matthew Auld <matthew.auld@intel.com>
Cc: Andrzej Hajda <andrzej.hajda@intel.com>
Cc: Nirmoy Das <nirmoy.das@intel.com>
Cc: <stable@vger.kernel.org> # v5.15+
Reviewed-by: Niranjana Vishwanathapura <niranjana.vishwanathapura@intel.com>
Acked-by: Nirmoy Das <Nirmoy.Das@intel.com>
Reviewed-by: Andrzej Hajda <andrzej.hajda@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20221115104620.120432-1-matthew.auld@intel.com
(cherry picked from commit 5524b5e52e08f675116a93296fe5bee60bc43c03)
Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/gem/i915_gem_ttm.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/gpu/drm/i915/gem/i915_gem_ttm.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_ttm.c
@@ -642,6 +642,10 @@ static int i915_ttm_truncate(struct drm_
 
 	WARN_ON_ONCE(obj->mm.madv == I915_MADV_WILLNEED);
 
+	err = ttm_bo_wait(bo, true, false);
+	if (err)
+		return err;
+
 	err = i915_ttm_move_notify(bo);
 	if (err)
 		return err;


