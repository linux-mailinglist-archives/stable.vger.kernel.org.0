Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DD41624B4
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:45:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388021AbfGHPWm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:22:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:49352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388018AbfGHPWl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:22:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DF280216C4;
        Mon,  8 Jul 2019 15:22:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562599360;
        bh=3OOO7NvkNSeJp6gSWkgAG1k2KMdEBv/7K2mAQpAKhZs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NZU8ERAHxV9YRYeqKiV4cI7BgWQP38Z941pis2aoouMOM29SLLEnH0PwSqGkbglTz
         4sFLY0o3B+uyFeimp9aozOHX9An/Dzo8kKBuR/45NM/i4R8NPqEQnF3istTeWatZoG
         t6lQPq1+f9tUFpS2wSkC5qy7hUEMYP5My+93z1Cs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Liam Merwick <liam.merwick@oracle.com>,
        Mark Kanda <mark.kanda@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>, bp@alien8.de,
        rkrcmar@redhat.com, kvm@vger.kernel.org
Subject: [PATCH 4.9 049/102] x86/speculation: Allow guests to use SSBD even if host does not
Date:   Mon,  8 Jul 2019 17:12:42 +0200
Message-Id: <20190708150528.978179446@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708150525.973820964@linuxfoundation.org>
References: <20190708150525.973820964@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>

commit c1f7fec1eb6a2c86d01bc22afce772c743451d88 upstream.

The bits set in x86_spec_ctrl_mask are used to calculate the guest's value
of SPEC_CTRL that is written to the MSR before VMENTRY, and control which
mitigations the guest can enable.  In the case of SSBD, unless the host has
enabled SSBD always on mode (by passing "spec_store_bypass_disable=on" in
the kernel parameters), the SSBD bit is not set in the mask and the guest
can not properly enable the SSBD always on mitigation mode.

This has been confirmed by running the SSBD PoC on a guest using the SSBD
always on mitigation mode (booted with kernel parameter
"spec_store_bypass_disable=on"), and verifying that the guest is vulnerable
unless the host is also using SSBD always on mode. In addition, the guest
OS incorrectly reports the SSB vulnerability as mitigated.

Always set the SSBD bit in x86_spec_ctrl_mask when the host CPU supports
it, allowing the guest to use SSBD whether or not the host has chosen to
enable the mitigation in any of its modes.

Fixes: be6fcb5478e9 ("x86/bugs: Rework spec_ctrl base and mask logic")
Signed-off-by: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Liam Merwick <liam.merwick@oracle.com>
Reviewed-by: Mark Kanda <mark.kanda@oracle.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Cc: bp@alien8.de
Cc: rkrcmar@redhat.com
Cc: kvm@vger.kernel.org
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/1560187210-11054-1-git-send-email-alejandro.j.jimenez@oracle.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/cpu/bugs.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -829,6 +829,16 @@ static enum ssb_mitigation __init __ssb_
 	}
 
 	/*
+	 * If SSBD is controlled by the SPEC_CTRL MSR, then set the proper
+	 * bit in the mask to allow guests to use the mitigation even in the
+	 * case where the host does not enable it.
+	 */
+	if (static_cpu_has(X86_FEATURE_SPEC_CTRL_SSBD) ||
+	    static_cpu_has(X86_FEATURE_AMD_SSBD)) {
+		x86_spec_ctrl_mask |= SPEC_CTRL_SSBD;
+	}
+
+	/*
 	 * We have three CPU feature flags that are in play here:
 	 *  - X86_BUG_SPEC_STORE_BYPASS - CPU is susceptible.
 	 *  - X86_FEATURE_SSBD - CPU is able to turn off speculative store bypass
@@ -845,7 +855,6 @@ static enum ssb_mitigation __init __ssb_
 			x86_amd_ssb_disable();
 		} else {
 			x86_spec_ctrl_base |= SPEC_CTRL_SSBD;
-			x86_spec_ctrl_mask |= SPEC_CTRL_SSBD;
 			wrmsrl(MSR_IA32_SPEC_CTRL, x86_spec_ctrl_base);
 		}
 	}


