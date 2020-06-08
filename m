Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17DBD1F14BA
	for <lists+stable@lfdr.de>; Mon,  8 Jun 2020 10:51:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729085AbgFHIvN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 04:51:13 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:35864 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726535AbgFHIvN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Jun 2020 04:51:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591606271;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=QCA2yOaDQHM6Tyw4sb9v+tX0O7Eo0l2FkdDUmJiIjLU=;
        b=FQnPS3amFvuOD3xDGHpeReQP9YPP9JDrYwmBGzPRNvPy538EgkNc/UD/RVuGhXKNCaHPT2
        Dn/mtyI8fXtYb2x2hNSJj4jnrhTE62O2bVzBc6StplTIZvhAghYZXBRKt1WMdQTg4P6LJH
        SU4HUXGr28xGmdu4Zfd/ivR7333Azss=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-372-v8lYYUmlO5axJHX9Skrp8g-1; Mon, 08 Jun 2020 04:51:09 -0400
X-MC-Unique: v8lYYUmlO5axJHX9Skrp8g-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9DF8A107ACCD;
        Mon,  8 Jun 2020 08:51:07 +0000 (UTC)
Received: from epycfail.redhat.com (unknown [10.36.110.3])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D83C419C58;
        Mon,  8 Jun 2020 08:51:05 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     kernel test robot <lkp@intel.com>, Florian Westphal <fw@strlen.de>,
        stable@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: [PATCH nf] nft_set_pipapo: Disable preemption before getting per-CPU pointer
Date:   Mon,  8 Jun 2020 10:50:29 +0200
Message-Id: <45861d795de2db1494b40bb2cc13bb36b4dacf72.1591606165.git.sbrivio@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The lkp kernel test robot reports, with CONFIG_DEBUG_PREEMPT enabled:

  [  165.316525] BUG: using smp_processor_id() in preemptible [00000000] code: nft/6247
  [  165.319547] caller is nft_pipapo_insert+0x464/0x610 [nf_tables]
  [  165.321846] CPU: 1 PID: 6247 Comm: nft Not tainted 5.6.0-rc5-01595-ge32a4dc6512ce3 #1
  [  165.332128] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.12.0-1 04/01/2014
  [  165.334892] Call Trace:
  [  165.336435]  dump_stack+0x8f/0xcb
  [  165.338128]  debug_smp_processor_id+0xb2/0xc0
  [  165.340117]  nft_pipapo_insert+0x464/0x610 [nf_tables]
  [  165.342290]  ? nft_trans_alloc_gfp+0x1c/0x60 [nf_tables]
  [  165.344420]  ? rcu_read_lock_sched_held+0x52/0x80
  [  165.346460]  ? nft_trans_alloc_gfp+0x1c/0x60 [nf_tables]
  [  165.348543]  ? __mmu_interval_notifier_insert+0xa0/0xf0
  [  165.350629]  nft_add_set_elem+0x5ff/0xa90 [nf_tables]
  [  165.352699]  ? __lock_acquire+0x241/0x1400
  [  165.354573]  ? __lock_acquire+0x241/0x1400
  [  165.356399]  ? reacquire_held_locks+0x12f/0x200
  [  165.358384]  ? nf_tables_valid_genid+0x1f/0x40 [nf_tables]
  [  165.360502]  ? nla_strcmp+0x10/0x50
  [  165.362199]  ? nft_table_lookup+0x4f/0xa0 [nf_tables]
  [  165.364217]  ? nla_strcmp+0x10/0x50
  [  165.365891]  ? nf_tables_newsetelem+0xd5/0x150 [nf_tables]
  [  165.367997]  nf_tables_newsetelem+0xd5/0x150 [nf_tables]
  [  165.370083]  nfnetlink_rcv_batch+0x4fd/0x790 [nfnetlink]
  [  165.372205]  ? __lock_acquire+0x241/0x1400
  [  165.374058]  ? __nla_validate_parse+0x57/0x8a0
  [  165.375989]  ? cap_inode_getsecurity+0x230/0x230
  [  165.377954]  ? security_capable+0x38/0x50
  [  165.379795]  nfnetlink_rcv+0x11d/0x140 [nfnetlink]
  [  165.381779]  netlink_unicast+0x1b2/0x280
  [  165.383612]  netlink_sendmsg+0x351/0x470
  [  165.385439]  sock_sendmsg+0x5b/0x60
  [  165.387133]  ____sys_sendmsg+0x200/0x280
  [  165.388871]  ? copy_msghdr_from_user+0xd9/0x160
  [  165.390805]  ___sys_sendmsg+0x88/0xd0
  [  165.392524]  ? __might_fault+0x3e/0x90
  [  165.394273]  ? sock_getsockopt+0x3d5/0xbb0
  [  165.396021]  ? __handle_mm_fault+0x545/0x6a0
  [  165.397822]  ? find_held_lock+0x2d/0x90
  [  165.399593]  ? __sys_sendmsg+0x5e/0xa0
  [  165.401338]  __sys_sendmsg+0x5e/0xa0
  [  165.402979]  do_syscall_64+0x60/0x280
  [  165.404680]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
  [  165.406621] RIP: 0033:0x7ff1fa46e783
  [  165.408299] Code: c7 c0 ff ff ff ff eb bb 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 64 8b 04 25 18 00 00 00 85 c0 75 14 b8 2e 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 55 c3 0f 1f 40 00 48 83 ec 28 89 54 24 1c 48
  [  165.414163] RSP: 002b:00007ffedf59ea78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
  [  165.416804] RAX: ffffffffffffffda RBX: 00007ffedf59fc60 RCX: 00007ff1fa46e783
  [  165.419419] RDX: 0000000000000000 RSI: 00007ffedf59fb10 RDI: 0000000000000005
  [  165.421886] RBP: 00007ffedf59fc10 R08: 00007ffedf59ea54 R09: 0000000000000001
  [  165.424445] R10: 00007ff1fa630c6c R11: 0000000000000246 R12: 0000000000020000
  [  165.426954] R13: 0000000000000280 R14: 0000000000000005 R15: 00007ffedf59ea90

Disable preemption before accessing the lookup scratch area in
nft_pipapo_insert().

Reported-by: kernel test robot <lkp@intel.com>
Analysed-by: Florian Westphal <fw@strlen.de>
Cc: <stable@vger.kernel.org> # 5.6.x
Fixes: 3c4287f62044 ("nf_tables: Add set type for arbitrary concatenation of ranges")
Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
---
 net/netfilter/nft_set_pipapo.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index 8b5acc6910fd..8c04388296b0 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -1242,7 +1242,9 @@ static int nft_pipapo_insert(const struct net *net, const struct nft_set *set,
 		end += NFT_PIPAPO_GROUPS_PADDED_SIZE(f);
 	}
 
-	if (!*this_cpu_ptr(m->scratch) || bsize_max > m->bsize_max) {
+	if (!*get_cpu_ptr(m->scratch) || bsize_max > m->bsize_max) {
+		put_cpu_ptr(m->scratch);
+
 		err = pipapo_realloc_scratch(m, bsize_max);
 		if (err)
 			return err;
@@ -1250,6 +1252,8 @@ static int nft_pipapo_insert(const struct net *net, const struct nft_set *set,
 		this_cpu_write(nft_pipapo_scratch_index, false);
 
 		m->bsize_max = bsize_max;
+	} else {
+		put_cpu_ptr(m->scratch);
 	}
 
 	*ext2 = &e->ext;
-- 
2.26.2

