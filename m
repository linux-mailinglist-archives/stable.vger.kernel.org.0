Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74A134F2D43
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:36:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237168AbiDEJKR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:10:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243960AbiDEIvW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:51:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA949D0805;
        Tue,  5 Apr 2022 01:40:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9DA77B81C82;
        Tue,  5 Apr 2022 08:39:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D07C1C385A1;
        Tue,  5 Apr 2022 08:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147991;
        bh=DHI4jWw9/CbcRHomOyx8TvzxhYy3YNyYTwrJjF17aIU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SUZdhC2mNf3eIn0QzVJaj6TzfbxkipdJ7+XMxK0mWGYxjubgFEWNAJVN6+ZEXy+/D
         pDP1BoLQM2XqkDbp7KsEvsrd2qmjg39sv0cY1ijslbnAZGyyglJnbKoXivdTaBaaDS
         gOK1KdhtVnAv1U3vTBvKIjCWkn6CWHZ2PlDCkUVI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mastan Katragadda <mastanx.katragadda@intel.com>,
        Adam Zabrocki <adamza@microsoft.com>,
        Jackson Cody <cody.jackson@intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Jon Bloomfield <jon.bloomfield@intel.com>,
        Sudeep Dutt <sudeep.dutt@intel.com>,
        Matthew Auld <matthew.auld@intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Subject: [PATCH 5.16 0196/1017] drm/i915/gem: add missing boundary check in vm_access
Date:   Tue,  5 Apr 2022 09:18:29 +0200
Message-Id: <20220405070400.064397706@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mastan Katragadda <mastanx.katragadda@intel.com>

commit 3886a86e7e6cc6ce2ce93c440fecd8f42aed0ce7 upstream.

A missing bounds check in vm_access() can lead to an out-of-bounds read
or write in the adjacent memory area, since the len attribute is not
validated before the memcpy later in the function, potentially hitting:

[  183.637831] BUG: unable to handle page fault for address: ffffc90000c86000
[  183.637934] #PF: supervisor read access in kernel mode
[  183.637997] #PF: error_code(0x0000) - not-present page
[  183.638059] PGD 100000067 P4D 100000067 PUD 100258067 PMD 106341067 PTE 0
[  183.638144] Oops: 0000 [#2] PREEMPT SMP NOPTI
[  183.638201] CPU: 3 PID: 1790 Comm: poc Tainted: G      D           5.17.0-rc6-ci-drm-11296+ #1
[  183.638298] Hardware name: Intel Corporation CoffeeLake Client Platform/CoffeeLake H DDR4 RVP, BIOS CNLSFWR1.R00.X208.B00.1905301319 05/30/2019
[  183.638430] RIP: 0010:memcpy_erms+0x6/0x10
[  183.640213] RSP: 0018:ffffc90001763d48 EFLAGS: 00010246
[  183.641117] RAX: ffff888109c14000 RBX: ffff888111bece40 RCX: 0000000000000ffc
[  183.642029] RDX: 0000000000001000 RSI: ffffc90000c86000 RDI: ffff888109c14004
[  183.642946] RBP: 0000000000000ffc R08: 800000000000016b R09: 0000000000000000
[  183.643848] R10: ffffc90000c85000 R11: 0000000000000048 R12: 0000000000001000
[  183.644742] R13: ffff888111bed190 R14: ffff888109c14000 R15: 0000000000001000
[  183.645653] FS:  00007fe5ef807540(0000) GS:ffff88845b380000(0000) knlGS:0000000000000000
[  183.646570] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  183.647481] CR2: ffffc90000c86000 CR3: 000000010ff02006 CR4: 00000000003706e0
[  183.648384] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  183.649271] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  183.650142] Call Trace:
[  183.650988]  <TASK>
[  183.651793]  vm_access+0x1f0/0x2a0 [i915]
[  183.652726]  __access_remote_vm+0x224/0x380
[  183.653561]  mem_rw.isra.0+0xf9/0x190
[  183.654402]  vfs_read+0x9d/0x1b0
[  183.655238]  ksys_read+0x63/0xe0
[  183.656065]  do_syscall_64+0x38/0xc0
[  183.656882]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[  183.657663] RIP: 0033:0x7fe5ef725142
[  183.659351] RSP: 002b:00007ffe1e81c7e8 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
[  183.660227] RAX: ffffffffffffffda RBX: 0000557055dfb780 RCX: 00007fe5ef725142
[  183.661104] RDX: 0000000000001000 RSI: 00007ffe1e81d880 RDI: 0000000000000005
[  183.661972] RBP: 00007ffe1e81e890 R08: 0000000000000030 R09: 0000000000000046
[  183.662832] R10: 0000557055dfc2e0 R11: 0000000000000246 R12: 0000557055dfb1c0
[  183.663691] R13: 00007ffe1e81e980 R14: 0000000000000000 R15: 0000000000000000

Changes since v1:
     - Updated if condition with range_overflows_t [Chris Wilson]

Fixes: 9f909e215fea ("drm/i915: Implement vm_ops->access for gdb access into mmaps")
Signed-off-by: Mastan Katragadda <mastanx.katragadda@intel.com>
Suggested-by: Adam Zabrocki <adamza@microsoft.com>
Reported-by: Jackson Cody <cody.jackson@intel.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Jon Bloomfield <jon.bloomfield@intel.com>
Cc: Sudeep Dutt <sudeep.dutt@intel.com>
Cc: <stable@vger.kernel.org> # v5.8+
Reviewed-by: Matthew Auld <matthew.auld@intel.com>
[mauld: tidy up the commit message and add Cc: stable]
Signed-off-by: Matthew Auld <matthew.auld@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220303060428.1668844-1-mastanx.katragadda@intel.com
(cherry picked from commit 661412e301e2ca86799aa4f400d1cf0bd38c57c6)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/gem/i915_gem_mman.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/gem/i915_gem_mman.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_mman.c
@@ -438,7 +438,7 @@ vm_access(struct vm_area_struct *area, u
 		return -EACCES;
 
 	addr -= area->vm_start;
-	if (addr >= obj->base.size)
+	if (range_overflows_t(u64, addr, len, obj->base.size))
 		return -EINVAL;
 
 	i915_gem_ww_ctx_init(&ww, true);


