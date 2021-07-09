Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F3F83C247A
	for <lists+stable@lfdr.de>; Fri,  9 Jul 2021 15:20:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232380AbhGINXG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 09:23:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:54226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231701AbhGINXF (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 09:23:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2C7BE6128A;
        Fri,  9 Jul 2021 13:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1625836821;
        bh=Gi3l/YXUT+DpuMT/pUnDKDxwBy0HvyT/ln4Glvx9Nno=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rmRfF9e2c14/F5KGNoy7RUwbcdM+gqOk09LlpNP+RhLc2yE0xHqhn2S9XGzWQyVyO
         vEeGQy3Gz9if03l2ldmZzGaFwmFyDKY1zynIgo1Gwoib72dI3K0diZNVBp6pgyode9
         U8UF/b1HBj7he0LEtznWqhYzq2vsWJLuJerzSi9U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Rientjes <rientjes@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Nobuhiro Iwamatsu (CIP)" <nobuhiro1.iwamatsu@toshiba.co.jp>
Subject: [PATCH 5.4 1/4] KVM: SVM: Periodically schedule when unregistering regions on destroy
Date:   Fri,  9 Jul 2021 15:20:15 +0200
Message-Id: <20210709131532.805541633@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210709131531.277334979@linuxfoundation.org>
References: <20210709131531.277334979@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1960,6 +1960,7 @@ static void sev_vm_destroy(struct kvm *k
 		list_for_each_safe(pos, q, head) {
 			__unregister_enc_region_locked(kvm,
 				list_entry(pos, struct enc_region, list));
+			cond_resched();
 		}
 	}
 


