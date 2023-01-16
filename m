Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FD0566C47C
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 16:55:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231480AbjAPPzn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 10:55:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231572AbjAPPzS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 10:55:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45FF7233D1
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 07:55:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CBAEF6102D
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 15:55:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDF65C433EF;
        Mon, 16 Jan 2023 15:55:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673884511;
        bh=UHMleYj28Var9XWt26p16aNi0j25slWiFQFsWkx5IEo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mMQYtI42pzt6qCT6fGs2Z83FLdGxExm/+0etSk3hHS1HF/Um725GD5vN4GxOkHQ9q
         cMPUCXPEVT+BgGw2BaWzg42S7hQwe0tiy2Sc0I1B4Q+K88KgCHtFOPhFz8tkryT8gp
         ob59AZlyxlc9/32Hiq77hbXebzKy/Z0qM8PcTvVs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, YiPeng Chai <YiPeng.Chai@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 033/183] drm/amdgpu: Fixed bug on error when unloading amdgpu
Date:   Mon, 16 Jan 2023 16:49:16 +0100
Message-Id: <20230116154804.764767650@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
References: <20230116154803.321528435@linuxfoundation.org>
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

From: YiPeng Chai <YiPeng.Chai@amd.com>

commit 99f1a36c90a7524972be5a028424c57fa17753ee upstream.

Fixed bug on error when unloading amdgpu.

The error message is as follows:
[  377.706202] kernel BUG at drivers/gpu/drm/drm_buddy.c:278!
[  377.706215] invalid opcode: 0000 [#1] PREEMPT SMP NOPTI
[  377.706222] CPU: 4 PID: 8610 Comm: modprobe Tainted: G          IOE      6.0.0-thomas #1
[  377.706231] Hardware name: ASUS System Product Name/PRIME Z390-A, BIOS 2004 11/02/2021
[  377.706238] RIP: 0010:drm_buddy_free_block+0x26/0x30 [drm_buddy]
[  377.706264] Code: 00 00 00 90 0f 1f 44 00 00 48 8b 0e 89 c8 25 00 0c 00 00 3d 00 04 00 00 75 10 48 8b 47 18 48 d3 e0 48 01 47 28 e9 fa fe ff ff <0f> 0b 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 41 54 55 48 89 f5 53
[  377.706282] RSP: 0018:ffffad2dc4683cb8 EFLAGS: 00010287
[  377.706289] RAX: 0000000000000000 RBX: ffff8b1743bd5138 RCX: 0000000000000000
[  377.706297] RDX: ffff8b1743bd5160 RSI: ffff8b1743bd5c78 RDI: ffff8b16d1b25f70
[  377.706304] RBP: ffff8b1743bd59e0 R08: 0000000000000001 R09: 0000000000000001
[  377.706311] R10: ffff8b16c8572400 R11: ffffad2dc4683cf0 R12: ffff8b16d1b25f70
[  377.706318] R13: ffff8b16d1b25fd0 R14: ffff8b1743bd59c0 R15: ffff8b16d1b25f70
[  377.706325] FS:  00007fec56c72c40(0000) GS:ffff8b1836500000(0000) knlGS:0000000000000000
[  377.706334] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  377.706340] CR2: 00007f9b88c1ba50 CR3: 0000000110450004 CR4: 00000000003706e0
[  377.706347] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  377.706354] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  377.706361] Call Trace:
[  377.706365]  <TASK>
[  377.706369]  drm_buddy_free_list+0x2a/0x60 [drm_buddy]
[  377.706376]  amdgpu_vram_mgr_fini+0xea/0x180 [amdgpu]
[  377.706572]  amdgpu_ttm_fini+0x12e/0x1a0 [amdgpu]
[  377.706650]  amdgpu_bo_fini+0x22/0x90 [amdgpu]
[  377.706727]  gmc_v11_0_sw_fini+0x26/0x30 [amdgpu]
[  377.706821]  amdgpu_device_fini_sw+0xa1/0x3c0 [amdgpu]
[  377.706897]  amdgpu_driver_release_kms+0x12/0x30 [amdgpu]
[  377.706975]  drm_dev_release+0x20/0x40 [drm]
[  377.707006]  release_nodes+0x35/0xb0
[  377.707014]  devres_release_all+0x8b/0xc0
[  377.707020]  device_unbind_cleanup+0xe/0x70
[  377.707027]  device_release_driver_internal+0xee/0x160
[  377.707033]  driver_detach+0x44/0x90
[  377.707039]  bus_remove_driver+0x55/0xe0
[  377.707045]  pci_unregister_driver+0x3b/0x90
[  377.707052]  amdgpu_exit+0x11/0x6c [amdgpu]
[  377.707194]  __x64_sys_delete_module+0x142/0x2b0
[  377.707201]  ? fpregs_assert_state_consistent+0x22/0x50
[  377.707208]  ? exit_to_user_mode_prepare+0x3e/0x190
[  377.707215]  do_syscall_64+0x38/0x90
[  377.707221]  entry_SYSCALL_64_after_hwframe+0x63/0xcd

Signed-off-by: YiPeng Chai <YiPeng.Chai@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c
@@ -882,7 +882,7 @@ void amdgpu_vram_mgr_fini(struct amdgpu_
 		kfree(rsv);
 
 	list_for_each_entry_safe(rsv, temp, &mgr->reserved_pages, blocks) {
-		drm_buddy_free_list(&mgr->mm, &rsv->blocks);
+		drm_buddy_free_list(&mgr->mm, &rsv->allocated);
 		kfree(rsv);
 	}
 	drm_buddy_fini(&mgr->mm);


