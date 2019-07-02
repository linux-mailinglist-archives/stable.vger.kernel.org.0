Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB5705CB78
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 10:13:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727867AbfGBIHB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 04:07:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:54052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728180AbfGBIHB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jul 2019 04:07:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE54821479;
        Tue,  2 Jul 2019 08:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562054820;
        bh=PwDS63IozS34PatsKZ+K/OUuNN5/IbEOeNXmXngO5FY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yjSertbKYRHfBX6phdl6zK8JbVJYM9N/96eeJV4hHHGaMTNbpz70WsZeCufsp1LXJ
         +9jd8SBTw5l3E12krzIYe6XGr34ee6ykvEADqUQq7JF21EAgg7eXrQlY4RQx/jfvg1
         ePKCbOrxl18K7ob0+Enb4AXMm2/YRKrgH8dhpcIs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Palecek <jpalecek@web.de>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 4.19 44/72] KVM: x86/mmu: Allocate PAE root array when using SVMs 32-bit NPT
Date:   Tue,  2 Jul 2019 10:01:45 +0200
Message-Id: <20190702080126.920551180@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190702080124.564652899@linuxfoundation.org>
References: <20190702080124.564652899@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

commit b6b80c78af838bef17501416d5d383fedab0010a upstream.

SVM's Nested Page Tables (NPT) reuses x86 paging for the host-controlled
page walk.  For 32-bit KVM, this means PAE paging is used even when TDP
is enabled, i.e. the PAE root array needs to be allocated.

Fixes: ee6268ba3a68 ("KVM: x86: Skip pae_root shadow allocation if tdp enabled")
Cc: stable@vger.kernel.org
Reported-by: Jiri Palecek <jpalecek@web.de>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Cc: Jiri Palecek <jpalecek@web.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/mmu.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -5386,7 +5386,16 @@ static int alloc_mmu_pages(struct kvm_vc
 	struct page *page;
 	int i;
 
-	if (tdp_enabled)
+	/*
+	 * When using PAE paging, the four PDPTEs are treated as 'root' pages,
+	 * while the PDP table is a per-vCPU construct that's allocated at MMU
+	 * creation.  When emulating 32-bit mode, cr3 is only 32 bits even on
+	 * x86_64.  Therefore we need to allocate the PDP table in the first
+	 * 4GB of memory, which happens to fit the DMA32 zone.  Except for
+	 * SVM's 32-bit NPT support, TDP paging doesn't use PAE paging and can
+	 * skip allocating the PDP table.
+	 */
+	if (tdp_enabled && kvm_x86_ops->get_tdp_level(vcpu) > PT32E_ROOT_LEVEL)
 		return 0;
 
 	/*


