Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F35BE4A6385
	for <lists+stable@lfdr.de>; Tue,  1 Feb 2022 19:18:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241909AbiBASRw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Feb 2022 13:17:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241867AbiBASRv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Feb 2022 13:17:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAA28C06173D;
        Tue,  1 Feb 2022 10:17:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7C6526137A;
        Tue,  1 Feb 2022 18:17:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40511C340EC;
        Tue,  1 Feb 2022 18:17:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643739469;
        bh=dHutdZ5BY8QS8fL7Ycyd6sYxmBYm9nSHFZmiQkOj2N4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W6pHFSkAT0/jtu72KkkKmK2k2J1QnHVe2dLohK0pD09o0xdUwGYTQjvhLLDJKE5yZ
         HFZZqMzHrfZX83CTau4Jy7lsOl8wFdLfxPg/SeZF50dJj2bB/1OPtGYYgcLj9NY9l1
         DiiEsYJfLL/8sWjEgPrgWNkPXoiJNYoHbF22OLi4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "stable@vger.kernel.org, Guillaume Bertholon" 
        <guillaume.bertholon@ens.fr>,
        Guillaume Bertholon <guillaume.bertholon@ens.fr>
Subject: [PATCH 4.4 25/25] KVM: x86: Fix misplaced backport of "work around leak of uninitialized stack contents"
Date:   Tue,  1 Feb 2022 19:16:49 +0100
Message-Id: <20220201180822.970781574@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220201180822.148370751@linuxfoundation.org>
References: <20220201180822.148370751@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guillaume Bertholon <guillaume.bertholon@ens.fr>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/x86.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4417,13 +4417,6 @@ static int emulator_write_std(struct x86
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
@@ -4431,6 +4424,13 @@ static int emulator_write_std(struct x86
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


