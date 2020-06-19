Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC0922018BF
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 19:01:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393343AbgFSQwR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 12:52:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:54912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387807AbgFSOh6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 10:37:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B9E9E208B8;
        Fri, 19 Jun 2020 14:37:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592577478;
        bh=iLjWZsmu0Rn0x35R4xyLdtYKUIZVFRInmRCFwXWnp3s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oNwURdBNkS22UBTf9n05+dulNaYFLU6+rUS56aHVvZJHGW6qyA+LR6+pLn+3j4Hh/
         boMLPQba7DNWwMgommhFjEiZjl/XmTe0mhXpRr3SqdEfLAhoW41ySMxnxk3Z4bseHm
         P+f6SavaD28WVI6C2KYJAR4o+HRwL6m0pfb50Fm8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, James Morse <james.morse@arm.com>,
        Marc Zyngier <maz@kernel.org>
Subject: [PATCH 4.4 037/101] KVM: arm64: Make vcpu_cp1x() work on Big Endian hosts
Date:   Fri, 19 Jun 2020 16:32:26 +0200
Message-Id: <20200619141616.058407633@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141614.001544111@linuxfoundation.org>
References: <20200619141614.001544111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

commit 3204be4109ad681523e3461ce64454c79278450a upstream.

AArch32 CP1x registers are overlayed on their AArch64 counterparts
in the vcpu struct. This leads to an interesting problem as they
are stored in their CPU-local format, and thus a CP1x register
doesn't "hit" the lower 32bit portion of the AArch64 register on
a BE host.

To workaround this unfortunate situation, introduce a bias trick
in the vcpu_cp1x() accessors which picks the correct half of the
64bit register.

Cc: stable@vger.kernel.org
Reported-by: James Morse <james.morse@arm.com>
Tested-by: James Morse <james.morse@arm.com>
Acked-by: James Morse <james.morse@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/include/asm/kvm_host.h |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -178,8 +178,10 @@ struct kvm_vcpu_arch {
  * CP14 and CP15 live in the same array, as they are backed by the
  * same system registers.
  */
-#define vcpu_cp14(v,r)		((v)->arch.ctxt.copro[(r)])
-#define vcpu_cp15(v,r)		((v)->arch.ctxt.copro[(r)])
+#define CPx_BIAS		IS_ENABLED(CONFIG_CPU_BIG_ENDIAN)
+
+#define vcpu_cp14(v,r)		((v)->arch.ctxt.copro[(r) ^ CPx_BIAS])
+#define vcpu_cp15(v,r)		((v)->arch.ctxt.copro[(r) ^ CPx_BIAS])
 
 #ifdef CONFIG_CPU_BIG_ENDIAN
 #define vcpu_cp15_64_high(v,r)	vcpu_cp15((v),(r))


