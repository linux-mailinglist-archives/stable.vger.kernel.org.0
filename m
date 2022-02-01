Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 086B94A6228
	for <lists+stable@lfdr.de>; Tue,  1 Feb 2022 18:18:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240924AbiBARSC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Feb 2022 12:18:02 -0500
Received: from nef2.ens.fr ([129.199.96.40]:54513 "EHLO nef.ens.fr"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240981AbiBARSB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Feb 2022 12:18:01 -0500
X-ENS-nef-client:   129.199.1.22 ( name = clipper-gw.ens.fr )
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ens.fr; s=default;
        t=1643735880; bh=HP2hfOu/xEREZTYBSfGb6sZ0yN0dsgbdS1i5x+3P+B0=;
        h=From:To:Cc:Subject:Date:From;
        b=Oyid24yOA8lQWnde2rQ5MZZdaMg4SB6C0hDQ86GHkcjDg/RW7KQIvsA5uJF9OSPQV
         DiWmmrs/caCrogJ3jkO9crN5Qye1l0MfJqfeCaMWpF4wtWVxquzwaiCYnrO06Wxtb5
         NBbUmBhkgQpBe0xFq6yy4ogzZdtfHDCh+Bi9hSsM=
Received: from clipper.ens.fr (clipper-gw.ens.fr [129.199.1.22])
          by nef.ens.fr (8.14.4/1.01.28121999) with ESMTP id 211HHxHN015886
          ; Tue, 1 Feb 2022 18:17:59 +0100
Received: from  optiplex-7.sg.lan using smtps by clipper.ens.fr (8.14.4/jb-1.1)
       id 211HHtQg094754 ; Tue, 1 Feb 2022 18:17:59 +0100 (authenticated user gbertholon)
X-ENS-Received:  (maths.r-prg.net.univ-paris7.fr [81.194.27.158])
From:   Guillaume Bertholon <guillaume.bertholon@ens.fr>
To:     gregkh@linuxfoundation.org
Cc:     stable@vger.kernel.org,
        Guillaume Bertholon <guillaume.bertholon@ens.fr>
Subject: [PATCH stable 4.4] KVM: x86: Fix misplaced backport of "work around leak of uninitialized stack contents"
Date:   Tue,  1 Feb 2022 18:17:51 +0100
Message-Id: <1643735871-15065-1-git-send-email-guillaume.bertholon@ens.fr>
X-Mailer: git-send-email 2.7.4
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.4.3 (nef.ens.fr [129.199.96.32]); Tue, 01 Feb 2022 18:18:00 +0100 (CET)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The upstream commit 541ab2aeb282 ("KVM: x86: work around leak of
uninitialized stack contents") resets `exception` in the function
`kvm_write_guest_virt_system`.
However, its backported version in stable (commit ba7f1c934f2e
("KVM: x86: work around leak of uninitialized stack contents")) applied
the change in `emulator_write_std` instead.

This patch moves the memset instruction back to
`kvm_write_guest_virt_system`.

Fixes: ba7f1c934f2e ("KVM: x86: work around leak of uninitialized stack contents")
Signed-off-by: Guillaume Bertholon <guillaume.bertholon@ens.fr>
---
 arch/x86/kvm/x86.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 8dce61c..9101002 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4417,13 +4417,6 @@ static int emulator_write_std(struct x86_emulate_ctxt *ctxt, gva_t addr, void *v
 	if (!system && kvm_x86_ops->get_cpl(vcpu) == 3)
 		access |= PFERR_USER_MASK;

-	/*
-	 * FIXME: this should call handle_emulation_failure if X86EMUL_IO_NEEDED
-	 * is returned, but our callers are not ready for that and they blindly
-	 * call kvm_inject_page_fault.  Ensure that they at least do not leak
-	 * uninitialized kernel stack memory into cr2 and error code.
-	 */
-	memset(exception, 0, sizeof(*exception));
 	return kvm_write_guest_virt_helper(addr, val, bytes, vcpu,
 					   access, exception);
 }
@@ -4431,6 +4424,13 @@ static int emulator_write_std(struct x86_emulate_ctxt *ctxt, gva_t addr, void *v
 int kvm_write_guest_virt_system(struct kvm_vcpu *vcpu, gva_t addr, void *val,
 				unsigned int bytes, struct x86_exception *exception)
 {
+	/*
+	 * FIXME: this should call handle_emulation_failure if X86EMUL_IO_NEEDED
+	 * is returned, but our callers are not ready for that and they blindly
+	 * call kvm_inject_page_fault.  Ensure that they at least do not leak
+	 * uninitialized kernel stack memory into cr2 and error code.
+	 */
+	memset(exception, 0, sizeof(*exception));
 	return kvm_write_guest_virt_helper(addr, val, bytes, vcpu,
 					   PFERR_WRITE_MASK, exception);
 }
--
2.7.4

