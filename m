Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE614531D24
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:58:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241436AbiEWRdV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:33:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241445AbiEWRau (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:30:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E891960D9D;
        Mon, 23 May 2022 10:26:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 25A9EB81218;
        Mon, 23 May 2022 17:26:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FE86C385A9;
        Mon, 23 May 2022 17:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653326783;
        bh=bfoCqacksBvKVXB6toCt+XCrQuXm+1nXdkvk2XHfhG8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pYcx4agvR8ivdDoWrNjIEvIj7FS0ErLt8RJ+cOgBIFOhEjewdOQ73tMeZjAFd6lyT
         hqH3ON/wH/Zga1V6xGw0oNUNvLY7AhDqFEBx25aDvBlIOyWkxY5vrnhc5WuNGhwA31
         U9zZLFAqUQ6wquN5t9GqlTcFYR+xlJXlGz6oiKTQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+8606b8a9cc97a63f1c87@syzkaller.appspotmail.com,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.17 057/158] KVM: Free new dirty bitmap if creating a new memslot fails
Date:   Mon, 23 May 2022 19:03:34 +0200
Message-Id: <20220523165840.249161905@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165830.581652127@linuxfoundation.org>
References: <20220523165830.581652127@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

commit c87661f855c3f2023e40ddc364002601ee234367 upstream.

Fix a goof in kvm_prepare_memory_region() where KVM fails to free the
new memslot's dirty bitmap during a CREATE action if
kvm_arch_prepare_memory_region() fails.  The logic is supposed to detect
if the bitmap was allocated and thus needs to be freed, versus if the
bitmap was inherited from the old memslot and thus needs to be kept.  If
there is no old memslot, then obviously the bitmap can't have been
inherited

The bug was exposed by commit 86931ff7207b ("KVM: x86/mmu: Do not create
SPTEs for GFNs that exceed host.MAXPHYADDR"), which made it trivally easy
for syzkaller to trigger failure during kvm_arch_prepare_memory_region(),
but the bug can be hit other ways too, e.g. due to -ENOMEM when
allocating x86's memslot metadata.

The backtrace from kmemleak:

  __vmalloc_node_range+0xb40/0xbd0 mm/vmalloc.c:3195
  __vmalloc_node mm/vmalloc.c:3232 [inline]
  __vmalloc+0x49/0x50 mm/vmalloc.c:3246
  __vmalloc_array mm/util.c:671 [inline]
  __vcalloc+0x49/0x70 mm/util.c:694
  kvm_alloc_dirty_bitmap virt/kvm/kvm_main.c:1319
  kvm_prepare_memory_region virt/kvm/kvm_main.c:1551
  kvm_set_memslot+0x1bd/0x690 virt/kvm/kvm_main.c:1782
  __kvm_set_memory_region+0x689/0x750 virt/kvm/kvm_main.c:1949
  kvm_set_memory_region virt/kvm/kvm_main.c:1962
  kvm_vm_ioctl_set_memory_region virt/kvm/kvm_main.c:1974
  kvm_vm_ioctl+0x377/0x13a0 virt/kvm/kvm_main.c:4528
  vfs_ioctl fs/ioctl.c:51
  __do_sys_ioctl fs/ioctl.c:870
  __se_sys_ioctl fs/ioctl.c:856
  __x64_sys_ioctl+0xfc/0x140 fs/ioctl.c:856
  do_syscall_x64 arch/x86/entry/common.c:50
  do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
  entry_SYSCALL_64_after_hwframe+0x44/0xae

And the relevant sequence of KVM events:

  ioctl(3, KVM_CREATE_VM, 0)              = 4
  ioctl(4, KVM_SET_USER_MEMORY_REGION, {slot=0,
                                        flags=KVM_MEM_LOG_DIRTY_PAGES,
                                        guest_phys_addr=0x10000000000000,
                                        memory_size=4096,
                                        userspace_addr=0x20fe8000}
       ) = -1 EINVAL (Invalid argument)

Fixes: 244893fa2859 ("KVM: Dynamically allocate "new" memslots from the get-go")
Cc: stable@vger.kernel.org
Reported-by: syzbot+8606b8a9cc97a63f1c87@syzkaller.appspotmail.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20220518003842.1341782-1-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 virt/kvm/kvm_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1539,7 +1539,7 @@ static int kvm_prepare_memory_region(str
 	r = kvm_arch_prepare_memory_region(kvm, old, new, change);
 
 	/* Free the bitmap on failure if it was allocated above. */
-	if (r && new && new->dirty_bitmap && old && !old->dirty_bitmap)
+	if (r && new && new->dirty_bitmap && (!old || !old->dirty_bitmap))
 		kvm_destroy_dirty_bitmap(new);
 
 	return r;


