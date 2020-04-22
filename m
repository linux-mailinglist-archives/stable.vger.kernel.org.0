Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B412C1B40BE
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:48:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729712AbgDVKP2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:15:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:50780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729708AbgDVKP1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:15:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 402F12075A;
        Wed, 22 Apr 2020 10:15:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587550526;
        bh=jlCOKvLmCY4J1mQYSp+GJ52kQPnp+v36+Lyr6EuYj8A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oqbpzjOdX5CMXf+LD7XndGN1ZaMx7Yoe7+uzos2wJqdo2Ql5J6pmfab7VG+NKnQoU
         vyLU8XlcjSej0fAskW/5K/v0Kpi40w4yT4yW6oNMj7s04HSvljO/hahEfQTwgDZawy
         NdJuXqsZa04uRiAkE+12nZuqrCjzXdjx4SBRvQMI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Kelley <mikelley@microsoft.com>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>
Subject: [PATCH 4.19 15/64] x86/Hyper-V: Report crash register data or kmsg before running crash kernel
Date:   Wed, 22 Apr 2020 11:56:59 +0200
Message-Id: <20200422095015.598699528@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095008.799686511@linuxfoundation.org>
References: <20200422095008.799686511@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tianyu Lan <Tianyu.Lan@microsoft.com>

commit a11589563e96bf262767294b89b25a9d44e7303b upstream.

We want to notify Hyper-V when a Linux guest VM crash occurs, so
there is a record of the crash even when kdump is enabled.   But
crash_kexec_post_notifiers defaults to "false", so the kdump kernel
runs before the notifiers and Hyper-V never gets notified.  Fix this by
always setting crash_kexec_post_notifiers to be true for Hyper-V VMs.

Fixes: 81b18bce48af ("Drivers: HV: Send one page worth of kmsg dump over Hyper-V during panic")
Reviewed-by: Michael Kelley <mikelley@microsoft.com>
Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
Link: https://lore.kernel.org/r/20200406155331.2105-5-Tianyu.Lan@microsoft.com
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/cpu/mshyperv.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/arch/x86/kernel/cpu/mshyperv.c
+++ b/arch/x86/kernel/cpu/mshyperv.c
@@ -250,6 +250,16 @@ static void __init ms_hyperv_init_platfo
 			cpuid_eax(HYPERV_CPUID_NESTED_FEATURES);
 	}
 
+	/*
+	 * Hyper-V expects to get crash register data or kmsg when
+	 * crash enlightment is available and system crashes. Set
+	 * crash_kexec_post_notifiers to be true to make sure that
+	 * calling crash enlightment interface before running kdump
+	 * kernel.
+	 */
+	if (ms_hyperv.misc_features & HV_FEATURE_GUEST_CRASH_MSR_AVAILABLE)
+		crash_kexec_post_notifiers = true;
+
 #ifdef CONFIG_X86_LOCAL_APIC
 	if (ms_hyperv.features & HV_X64_ACCESS_FREQUENCY_MSRS &&
 	    ms_hyperv.misc_features & HV_FEATURE_FREQUENCY_MSRS_AVAILABLE) {


