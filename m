Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87F193BF4F5
	for <lists+stable@lfdr.de>; Thu,  8 Jul 2021 07:10:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229579AbhGHFNg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Jul 2021 01:13:36 -0400
Received: from mo-csw-fb1516.securemx.jp ([210.130.202.172]:43468 "EHLO
        mo-csw-fb.securemx.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbhGHFNf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Jul 2021 01:13:35 -0400
X-Greylist: delayed 462 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Jul 2021 01:13:35 EDT
Received: by mo-csw-fb.securemx.jp (mx-mo-csw-fb1516) id 16853AEx006751; Thu, 8 Jul 2021 14:03:11 +0900
Received: by mo-csw.securemx.jp (mx-mo-csw1516) id 16852xCX011764; Thu, 8 Jul 2021 14:02:59 +0900
X-Iguazu-Qid: 34tMQyetGqxOwDtXk9
X-Iguazu-QSIG: v=2; s=0; t=1625720578; q=34tMQyetGqxOwDtXk9; m=om0/MT42/M7qUcisJqqNBVyJ4caSpew5qbE9LLratRw=
Received: from imx12-a.toshiba.co.jp (imx12-a.toshiba.co.jp [61.202.160.135])
        by relay.securemx.jp (mx-mr1510) id 16852w2q037734
        (version=TLSv1.2 cipher=AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 8 Jul 2021 14:02:58 +0900
Received: from enc02.toshiba.co.jp (enc02.toshiba.co.jp [61.202.160.51])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by imx12-a.toshiba.co.jp (Postfix) with ESMTPS id 05CD21000F7;
        Thu,  8 Jul 2021 14:02:58 +0900 (JST)
Received: from hop101.toshiba.co.jp ([133.199.85.107])
        by enc02.toshiba.co.jp  with ESMTP id 16852vr9026178;
        Thu, 8 Jul 2021 14:02:57 +0900
From:   Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, sashal@kernel.org,
        David Rientjes <rientjes@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Subject: [PATCH for 4.19, 5.4] KVM: SVM: Periodically schedule when unregistering regions on destroy
Date:   Thu,  8 Jul 2021 14:02:53 +0900
X-TSB-HOP: ON
Message-Id: <20210708050253.341098-1-nobuhiro1.iwamatsu@toshiba.co.jp>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Rientjes <rientjes@google.com>

commit 7be74942f184fdfba34ddd19a0d995deb34d4a03 upstream.

There may be many encrypted regions that need to be unregistered when a
SEV VM is destroyed.  This can lead to soft lockups.  For example, on a
host running 4.15:

watchdog: BUG: soft lockup - CPU#206 stuck for 11s! [t_virtual_machi:194348]
CPU: 206 PID: 194348 Comm: t_virtual_machi
RIP: 0010:free_unref_page_list+0x105/0x170
...
Call Trace:
 [<0>] release_pages+0x159/0x3d0
 [<0>] sev_unpin_memory+0x2c/0x50 [kvm_amd]
 [<0>] __unregister_enc_region_locked+0x2f/0x70 [kvm_amd]
 [<0>] svm_vm_destroy+0xa9/0x200 [kvm_amd]
 [<0>] kvm_arch_destroy_vm+0x47/0x200
 [<0>] kvm_put_kvm+0x1a8/0x2f0
 [<0>] kvm_vm_release+0x25/0x30
 [<0>] do_exit+0x335/0xc10
 [<0>] do_group_exit+0x3f/0xa0
 [<0>] get_signal+0x1bc/0x670
 [<0>] do_signal+0x31/0x130

Although the CLFLUSH is no longer issued on every encrypted region to be
unregistered, there are no other changes that can prevent soft lockups for
very large SEV VMs in the latest kernel.

Periodically schedule if necessary.  This still holds kvm->lock across the
resched, but since this only happens when the VM is destroyed this is
assumed to be acceptable.

Signed-off-by: David Rientjes <rientjes@google.com>
Message-Id: <alpine.DEB.2.23.453.2008251255240.2987727@chino.kir.corp.google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
[iwamatsu: adjust filename.]
Reference: CVE-2020-36311
Signed-off-by: Nobuhiro Iwamatsu (CIP) <nobuhiro1.iwamatsu@toshiba.co.jp>
---
 arch/x86/kvm/svm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index c5673bda4b66df..3f776e654e3aec 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1910,6 +1910,7 @@ static void sev_vm_destroy(struct kvm *kvm)
 		list_for_each_safe(pos, q, head) {
 			__unregister_enc_region_locked(kvm,
 				list_entry(pos, struct enc_region, list));
+			cond_resched();
 		}
 	}
 
-- 
2.31.1

