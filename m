Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7927B76D7D
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 17:35:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389112AbfGZPeA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 11:34:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:49514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389755AbfGZPeA (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 11:34:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5A2732054F;
        Fri, 26 Jul 2019 15:33:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564155239;
        bh=HeXPMqH5tAKQGHu9NocNCCP0qUlEnYkyuaHmGmv0X7k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NS2l73f0uPNs+U/SDJJOTxleWVlishza9EuHTw1KXUdi0wUQF8iqTpdUgGmi6JSIY
         CE2kfC7Dt3/t8tSKNd+VLxhi2L+1aK4PEewQk6e9JcvLE6Kua7nC2TGIoLeEcgMVJG
         XQKWk+nrbdq8iBlFU3I5T5uYgJd1C4Xfy3njGOW4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Kiszka <jan.kiszka@siemens.com>,
        Liran Alon <liran.alon@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 4.19 49/50] KVM: nVMX: Clear pending KVM_REQ_GET_VMCS12_PAGES when leaving nested
Date:   Fri, 26 Jul 2019 17:25:24 +0200
Message-Id: <20190726152305.944211946@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190726152300.760439618@linuxfoundation.org>
References: <20190726152300.760439618@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kiszka <jan.kiszka@siemens.com>

commit cf64527bb33f6cec2ed50f89182fc4688d0056b6 upstream.

Letting this pend may cause nested_get_vmcs12_pages to run against an
invalid state, corrupting the effective vmcs of L1.

This was triggerable in QEMU after a guest corruption in L2, followed by
a L1 reset.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Reviewed-by: Liran Alon <liran.alon@oracle.com>
Cc: stable@vger.kernel.org
Fixes: 7f7f1ba33cf2 ("KVM: x86: do not load vmcs12 pages while still in SMM")
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/vmx.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -8490,6 +8490,8 @@ static void free_nested(struct vcpu_vmx
 	if (!vmx->nested.vmxon && !vmx->nested.smm.vmxon)
 		return;
 
+	kvm_clear_request(KVM_REQ_GET_VMCS12_PAGES, &vmx->vcpu);
+
 	hrtimer_cancel(&vmx->nested.preemption_timer);
 	vmx->nested.vmxon = false;
 	vmx->nested.smm.vmxon = false;


