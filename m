Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07F154A4244
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:11:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359163AbiAaLLC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:11:02 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:42128 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359440AbiAaLHu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:07:50 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 16F8360E76;
        Mon, 31 Jan 2022 11:07:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F20A2C340E8;
        Mon, 31 Jan 2022 11:07:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627268;
        bh=m3LZqmH1nbge2TQOPSDQjTtRd5XlahkS46mn4dWGeJM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iCf8XoLa5K9/hX0faMTs+fBFV0WMZ6OukOkQ208oWOxgoCSEGSjP3hECtlTahyGDV
         M08wBC+bKW6IQJgP9LdhjVQrkTlolEBmeEadRibzZEEiJW7++F+T0AMDzx6RoJ2DJQ
         0JnItHJZioYK/5NNO3IQ11LjD1FCL4EDXjXdeVPU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Fuad Tabba <tabba@google.com>
Subject: [PATCH 5.15 007/171] KVM: arm64: Use shadow SPSR_EL1 when injecting exceptions on !VHE
Date:   Mon, 31 Jan 2022 11:54:32 +0100
Message-Id: <20220131105230.223736832@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105229.959216821@linuxfoundation.org>
References: <20220131105229.959216821@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

commit 278583055a237270fac70518275ba877bf9e4013 upstream.

Injecting an exception into a guest with non-VHE is risky business.
Instead of writing in the shadow register for the switch code to
restore it, we override the CPU register instead. Which gets
overriden a few instructions later by said restore code.

The result is that although the guest correctly gets the exception,
it will return to the original context in some random state,
depending on what was there the first place... Boo.

Fix the issue by writing to the shadow register. The original code
is absolutely fine on VHE, as the state is already loaded, and writing
to the shadow register in that case would actually be a bug.

Fixes: bb666c472ca2 ("KVM: arm64: Inject AArch64 exceptions from HYP")
Cc: stable@vger.kernel.org
Signed-off-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Fuad Tabba <tabba@google.com>
Link: https://lore.kernel.org/r/20220121184207.423426-1-maz@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/hyp/exception.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/arch/arm64/kvm/hyp/exception.c
+++ b/arch/arm64/kvm/hyp/exception.c
@@ -38,7 +38,10 @@ static inline void __vcpu_write_sys_reg(
 
 static void __vcpu_write_spsr(struct kvm_vcpu *vcpu, u64 val)
 {
-	write_sysreg_el1(val, SYS_SPSR);
+	if (has_vhe())
+		write_sysreg_el1(val, SYS_SPSR);
+	else
+		__vcpu_sys_reg(vcpu, SPSR_EL1) = val;
 }
 
 static void __vcpu_write_spsr_abt(struct kvm_vcpu *vcpu, u64 val)


