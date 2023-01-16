Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5DBF66C5BE
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:09:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232654AbjAPQJ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:09:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232676AbjAPQIp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:08:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EACC274B2
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:06:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B22B4B81065
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:06:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7877C433EF;
        Mon, 16 Jan 2023 16:06:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673885168;
        bh=Qv7sX9riBLfnwr9jgSEv2x8bXXxFIkib6WfNt/igeCc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H98v/29r3P6b4fxu2p0+atJO55F+d5gYwJvxuoUVwjAQnsvqd0ZoXIYB9muqkJHDW
         dlVUjJYCTUqInF+Fgv4TAMMhd5EewMNhgoL3mB1nY1iBC8I/NqatrEzS9pRPR/fZG+
         ABGDM+qZFVnR1vpDDDJKH2ZhANd1G/Ww+9bWRrEI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Oliver Upton <oliver.upton@linux.dev>,
        Ard Biesheuvel <ardb@kernel.org>, Marc Zyngier <maz@kernel.org>
Subject: [PATCH 5.10 03/64] KVM: arm64: Fix S1PTW handling on RO memslots
Date:   Mon, 16 Jan 2023 16:51:10 +0100
Message-Id: <20230116154743.731881575@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154743.577276578@linuxfoundation.org>
References: <20230116154743.577276578@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

commit 406504c7b0405d74d74c15a667cd4c4620c3e7a9 upstream.

A recent development on the EFI front has resulted in guests having
their page tables baked in the firmware binary, and mapped into the
IPA space as part of a read-only memslot. Not only is this legitimate,
but it also results in added security, so thumbs up.

It is possible to take an S1PTW translation fault if the S1 PTs are
unmapped at stage-2. However, KVM unconditionally treats S1PTW as a
write to correctly handle hardware AF/DB updates to the S1 PTs.
Furthermore, KVM injects an exception into the guest for S1PTW writes.
In the aforementioned case this results in the guest taking an abort
it won't recover from, as the S1 PTs mapping the vectors suffer from
the same problem.

So clearly our handling is... wrong.

Instead, switch to a two-pronged approach:

- On S1PTW translation fault, handle the fault as a read

- On S1PTW permission fault, handle the fault as a write

This is of no consequence to SW that *writes* to its PTs (the write
will trigger a non-S1PTW fault), and SW that uses RO PTs will not
use HW-assisted AF/DB anyway, as that'd be wrong.

Only in the case described in c4ad98e4b72c ("KVM: arm64: Assume write
fault on S1PTW permission fault on instruction fetch") do we end-up
with two back-to-back faults (page being evicted and faulted back).
I don't think this is a case worth optimising for.

Fixes: c4ad98e4b72c ("KVM: arm64: Assume write fault on S1PTW permission fault on instruction fetch")
Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
Regression-tested-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/kvm_emulate.h |   22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -382,8 +382,26 @@ static __always_inline int kvm_vcpu_sys_
 
 static inline bool kvm_is_write_fault(struct kvm_vcpu *vcpu)
 {
-	if (kvm_vcpu_abt_iss1tw(vcpu))
-		return true;
+	if (kvm_vcpu_abt_iss1tw(vcpu)) {
+		/*
+		 * Only a permission fault on a S1PTW should be
+		 * considered as a write. Otherwise, page tables baked
+		 * in a read-only memslot will result in an exception
+		 * being delivered in the guest.
+		 *
+		 * The drawback is that we end-up faulting twice if the
+		 * guest is using any of HW AF/DB: a translation fault
+		 * to map the page containing the PT (read only at
+		 * first), then a permission fault to allow the flags
+		 * to be set.
+		 */
+		switch (kvm_vcpu_trap_get_fault_type(vcpu)) {
+		case ESR_ELx_FSC_PERM:
+			return true;
+		default:
+			return false;
+		}
+	}
 
 	if (kvm_vcpu_trap_is_iabt(vcpu))
 		return false;


