Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEFE2492A19
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 17:07:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346256AbiARQGz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 11:06:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346237AbiARQGz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 11:06:55 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD4A9C061574;
        Tue, 18 Jan 2022 08:06:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 0A83FCE1A2D;
        Tue, 18 Jan 2022 16:06:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4D1AC00446;
        Tue, 18 Jan 2022 16:06:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642522011;
        bh=+KDz16PgXGFJjDUD7XqTJPiBtSbrcQFJUFu5hSBafbM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xvHEBe6gAgpbP9cIi+Eil8vYqrMaek+RYMHs9cdOpTJVDDQLjZVtmrRf9AI4G00MM
         peLS1cQsxIfrNylx5gxl6t43uprkKEveNlhWxMtjCRz1RGci90NTPAyT3ZpCjGzEAw
         mCOHVFIIf11jVu3p7I2V1bDIAPCYNPOMQ+XScTyM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wei Wang <wei.w.wang@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.4 12/15] KVM: x86: remove PMU FIXED_CTR3 from msrs_to_save_all
Date:   Tue, 18 Jan 2022 17:05:51 +0100
Message-Id: <20220118160450.451898047@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118160450.062004175@linuxfoundation.org>
References: <20220118160450.062004175@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Wang <wei.w.wang@intel.com>

commit 9fb12fe5b93b94b9e607509ba461e17f4cc6a264 upstream.

The fixed counter 3 is used for the Topdown metrics, which hasn't been
enabled for KVM guests. Userspace accessing to it will fail as it's not
included in get_fixed_pmc(). This breaks KVM selftests on ICX+ machines,
which have this counter.

To reproduce it on ICX+ machines, ./state_test reports:
==== Test Assertion Failure ====
lib/x86_64/processor.c:1078: r == nmsrs
pid=4564 tid=4564 - Argument list too long
1  0x000000000040b1b9: vcpu_save_state at processor.c:1077
2  0x0000000000402478: main at state_test.c:209 (discriminator 6)
3  0x00007fbe21ed5f92: ?? ??:0
4  0x000000000040264d: _start at ??:?
 Unexpected result from KVM_GET_MSRS, r: 17 (failed MSR was 0x30c)

With this patch, it works well.

Signed-off-by: Wei Wang <wei.w.wang@intel.com>
Message-Id: <20211217124934.32893-1-wei.w.wang@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Fixes: e2ada66ec418 ("kvm: x86: Add Intel PMU MSRs to msrs_to_save[]")
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/x86.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1218,7 +1218,7 @@ static const u32 msrs_to_save_all[] = {
 	MSR_IA32_UMWAIT_CONTROL,
 
 	MSR_ARCH_PERFMON_FIXED_CTR0, MSR_ARCH_PERFMON_FIXED_CTR1,
-	MSR_ARCH_PERFMON_FIXED_CTR0 + 2, MSR_ARCH_PERFMON_FIXED_CTR0 + 3,
+	MSR_ARCH_PERFMON_FIXED_CTR0 + 2,
 	MSR_CORE_PERF_FIXED_CTR_CTRL, MSR_CORE_PERF_GLOBAL_STATUS,
 	MSR_CORE_PERF_GLOBAL_CTRL, MSR_CORE_PERF_GLOBAL_OVF_CTRL,
 	MSR_ARCH_PERFMON_PERFCTR0, MSR_ARCH_PERFMON_PERFCTR1,


