Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51D344A4495
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:33:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240002AbiAaLbW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:31:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377085AbiAaLZw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:25:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28C57C034014;
        Mon, 31 Jan 2022 03:15:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E2F2EB82A5F;
        Mon, 31 Jan 2022 11:15:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 109EDC340E8;
        Mon, 31 Jan 2022 11:15:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627754;
        bh=m3LZqmH1nbge2TQOPSDQjTtRd5XlahkS46mn4dWGeJM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nFfvVsBAkPVwXiK1I1AMFAYPEXRW1Hpw/6Xht4D+HKRr9UiEL826syh3olJd2rSLJ
         qCU6NMFfvmVWseNFk3A2N4xbar9TRW3L0PQGhdPJMGMfuZ7Yl/I2hBRtmTgokVr6Ac
         fTlkv88ZM773vbKR8I4nV64bXRd1MkG3ZiXehWzw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Fuad Tabba <tabba@google.com>
Subject: [PATCH 5.16 015/200] KVM: arm64: Use shadow SPSR_EL1 when injecting exceptions on !VHE
Date:   Mon, 31 Jan 2022 11:54:38 +0100
Message-Id: <20220131105234.075471979@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105233.561926043@linuxfoundation.org>
References: <20220131105233.561926043@linuxfoundation.org>
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


