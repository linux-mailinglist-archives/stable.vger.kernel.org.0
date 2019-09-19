Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2ED38B860C
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 00:26:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404976AbfISWWG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 18:22:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:36874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404758AbfISWWC (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Sep 2019 18:22:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 514B021927;
        Thu, 19 Sep 2019 22:22:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568931721;
        bh=FTHGqCkAkH8jNAZlObvzCTNpF4r0k02QCXEPoVf6+Pg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DIaROK1c4v9JIh3bbuL3GTn1sOF1IIGo4zGKTEIIpx6r7bKWsUyqw2t+0QuL1a/SE
         xm/i2XAmziccb7+QRTVCTnUPl+WLL95csWMVqt35BrhPBLt154RPBon1r8HZePq4Pt
         hlWf2WU6VwQ7tRBnk//l9N3mVHjmxqNyxUzjaAhE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fuqian Huang <huangfq.daxian@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 4.4 16/56] KVM: x86: work around leak of uninitialized stack contents
Date:   Fri, 20 Sep 2019 00:03:57 +0200
Message-Id: <20190919214752.638662940@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190919214742.483643642@linuxfoundation.org>
References: <20190919214742.483643642@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fuqian Huang <huangfq.daxian@gmail.com>

commit 541ab2aeb28251bf7135c7961f3a6080eebcc705 upstream.

Emulation of VMPTRST can incorrectly inject a page fault
when passed an operand that points to an MMIO address.
The page fault will use uninitialized kernel stack memory
as the CR2 and error code.

The right behavior would be to abort the VM with a KVM_EXIT_INTERNAL_ERROR
exit to userspace; however, it is not an easy fix, so for now just ensure
that the error code and CR2 are zero.

Signed-off-by: Fuqian Huang <huangfq.daxian@gmail.com>
Cc: stable@vger.kernel.org
[add comment]
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/x86.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4337,6 +4337,13 @@ static int emulator_write_std(struct x86
 	if (!system && kvm_x86_ops->get_cpl(vcpu) == 3)
 		access |= PFERR_USER_MASK;
 
+	/*
+	 * FIXME: this should call handle_emulation_failure if X86EMUL_IO_NEEDED
+	 * is returned, but our callers are not ready for that and they blindly
+	 * call kvm_inject_page_fault.  Ensure that they at least do not leak
+	 * uninitialized kernel stack memory into cr2 and error code.
+	 */
+	memset(exception, 0, sizeof(*exception));
 	return kvm_write_guest_virt_helper(addr, val, bytes, vcpu,
 					   access, exception);
 }


