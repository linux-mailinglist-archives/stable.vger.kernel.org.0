Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 059314891EC
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 08:43:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241055AbiAJHhM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 02:37:12 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:41718 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239828AbiAJHdN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 02:33:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AF692611C0;
        Mon, 10 Jan 2022 07:33:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97598C36AED;
        Mon, 10 Jan 2022 07:33:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641799992;
        bh=twezZ0T1oF934WqErVlqXAgbsR0+9X2fsgYIG7ynZOo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AzhUsT1myRIkUkcDr/S3b+o6IA0JSh91OpzPLA8hFG9GPtb3/UT7b8ol6iUoDRP7n
         ipE8eNXV6Z4mYh4i7GuReOJX2lBGnNjlOV81tfaIZ7nKIoEm2aZOJjduVX+E7x7dxl
         G/mlOMgACXWu4zUtwK8NYJI/OxRjkOjCjHF7BVhM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vasant Hegde <vasant.hegde@amd.com>,
        Nikunj A Dadhania <nikunj@amd.com>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.15 34/72] KVM: x86: Check for rmaps allocation
Date:   Mon, 10 Jan 2022 08:23:11 +0100
Message-Id: <20220110071822.706749841@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220110071821.500480371@linuxfoundation.org>
References: <20220110071821.500480371@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nikunj A Dadhania <nikunj@amd.com>

commit fffb5323780786c81ba005f8b8603d4a558aad28 upstream.

With TDP MMU being the default now, access to mmu_rmaps_stat debugfs
file causes following oops:

BUG: kernel NULL pointer dereference, address: 0000000000000000
PGD 0 P4D 0
Oops: 0000 [#1] PREEMPT SMP NOPTI
CPU: 7 PID: 3185 Comm: cat Not tainted 5.16.0-rc4+ #204
RIP: 0010:pte_list_count+0x6/0x40
 Call Trace:
  <TASK>
  ? kvm_mmu_rmaps_stat_show+0x15e/0x320
  seq_read_iter+0x126/0x4b0
  ? aa_file_perm+0x124/0x490
  seq_read+0xf5/0x140
  full_proxy_read+0x5c/0x80
  vfs_read+0x9f/0x1a0
  ksys_read+0x67/0xe0
  __x64_sys_read+0x19/0x20
  do_syscall_64+0x3b/0xc0
  entry_SYSCALL_64_after_hwframe+0x44/0xae
 RIP: 0033:0x7fca6fc13912

Return early when rmaps are not present.

Reported-by: Vasant Hegde <vasant.hegde@amd.com>
Tested-by: Vasant Hegde <vasant.hegde@amd.com>
Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20220105040337.4234-1-nikunj@amd.com>
Cc: stable@vger.kernel.org
Fixes: 3bcd0662d66f ("KVM: X86: Introduce mmu_rmaps_stat per-vm debugfs file")
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/debugfs.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/x86/kvm/debugfs.c
+++ b/arch/x86/kvm/debugfs.c
@@ -95,6 +95,9 @@ static int kvm_mmu_rmaps_stat_show(struc
 	unsigned int *log[KVM_NR_PAGE_SIZES], *cur;
 	int i, j, k, l, ret;
 
+	if (!kvm_memslots_have_rmaps(kvm))
+		return 0;
+
 	ret = -ENOMEM;
 	memset(log, 0, sizeof(log));
 	for (i = 0; i < KVM_NR_PAGE_SIZES; i++) {


