Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69D164CFABE
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 11:24:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234240AbiCGKWh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 05:22:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241454AbiCGKUd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 05:20:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EE6390CCE;
        Mon,  7 Mar 2022 01:58:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BC69660A27;
        Mon,  7 Mar 2022 09:57:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD686C340E9;
        Mon,  7 Mar 2022 09:57:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646647076;
        bh=aTBoFzea2VDWZAwplzr9/WG4T19S1+TQrCpCXTAxJKk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OMvG09zvwWNA+HAZ7baJfQchQfVBYfWXud6igkDHEo/bsL/i56vuLPq6fvORylZQJ
         36FHrEgKNc+0THtL4+9i+0DBd4ulsdFhVkB6L+XPF10ISS/t2s1QqYRTi12Hi9RV2w
         DiQEXuKEoHExPdrekWJkST7tV34nSrbT9Hv33YnY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>,
        Dexuan Cui <decui@microsoft.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.16 183/186] x86/kvmclock: Fix Hyper-V Isolated VMs boot issue when vCPUs > 64
Date:   Mon,  7 Mar 2022 10:20:21 +0100
Message-Id: <20220307091659.198746831@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091654.092878898@linuxfoundation.org>
References: <20220307091654.092878898@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dexuan Cui <decui@microsoft.com>

commit 92e68cc558774de01024c18e8b35cdce4731c910 upstream.

When Linux runs as an Isolated VM on Hyper-V, it supports AMD SEV-SNP
but it's partially enlightened, i.e. cc_platform_has(
CC_ATTR_GUEST_MEM_ENCRYPT) is true but sev_active() is false.

Commit 4d96f9109109 per se is good, but with it now
kvm_setup_vsyscall_timeinfo() -> kvmclock_init_mem() calls
set_memory_decrypted(), and later gets stuck when trying to zere out
the pages pointed by 'hvclock_mem', if Linux runs as an Isolated VM on
Hyper-V. The cause is that here now the Linux VM should no longer access
the original guest physical addrss (GPA); instead the VM should do
memremap() and access the original GPA + ms_hyperv.shared_gpa_boundary:
see the example code in drivers/hv/connection.c: vmbus_connect() or
drivers/hv/ring_buffer.c: hv_ringbuffer_init(). If the VM tries to
access the original GPA, it keepts getting injected a fault by Hyper-V
and gets stuck there.

Here the issue happens only when the VM has >=65 vCPUs, because the
global static array hv_clock_boot[] can hold 64 "struct
pvclock_vsyscall_time_info" (the sizeof of the struct is 64 bytes), so
kvmclock_init_mem() only allocates memory in the case of vCPUs > 64.

Since the 'hvclock_mem' pages are only useful when the kvm clock is
supported by the underlying hypervisor, fix the issue by returning
early when Linux VM runs on Hyper-V, which doesn't support kvm clock.

Fixes: 4d96f9109109 ("x86/sev: Replace occurrences of sev_active() with cc_platform_has()")
Tested-by: Andrea Parri (Microsoft) <parri.andrea@gmail.com>
Signed-off-by: Andrea Parri (Microsoft) <parri.andrea@gmail.com>
Signed-off-by: Dexuan Cui <decui@microsoft.com>
Message-Id: <20220225084600.17817-1-decui@microsoft.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/kvmclock.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -239,6 +239,9 @@ static void __init kvmclock_init_mem(voi
 
 static int __init kvm_setup_vsyscall_timeinfo(void)
 {
+	if (!kvm_para_available())
+		return 0;
+
 	kvmclock_init_mem();
 
 #ifdef CONFIG_X86_64


