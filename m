Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F17EF6431DD
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:21:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233713AbiLETVP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:21:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233520AbiLETU5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:20:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBA5725C75
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:17:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7F88C61314
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:17:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92794C433C1;
        Mon,  5 Dec 2022 19:17:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670267823;
        bh=dIQOBKTdiCa8LA6uxbtuDAOUpEkv2q4+ZPBM6p8X+Ew=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dnq6P3PlExalOyYugqu51VAFkOvgGwBs752xP9shD2G32gJzXPuurQNVWhq7joPNC
         En0vQiRcE+VQRGw5VC9L6MOrFxda99+dApL//krRmbzaaCPPWhIqIu9HpuGy0ZbDD7
         UXFH7clvbUUY6hCCb/l5cFkqDsGrTePKqyaVWisg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Sami Lee <sami.lee@mediatek.com>,
        James Morse <james.morse@arm.com>
Subject: [PATCH 4.14 64/77] arm64: Fix panic() when Spectre-v2 causes Spectre-BHB to re-allocate KVM vectors
Date:   Mon,  5 Dec 2022 20:09:55 +0100
Message-Id: <20221205190803.119599081@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190800.868551051@linuxfoundation.org>
References: <20221205190800.868551051@linuxfoundation.org>
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

From: James Morse <james.morse@arm.com>

Sami reports that linux panic()s when resuming from suspend to RAM. This
is because when CPUs are brought back online, they re-enable any
necessary mitigations.

The Spectre-v2 and Spectre-BHB mitigations interact as both need to
done by KVM when exiting a guest. Slots KVM can use as vectors are
allocated, and templates for the mitigation are patched into the vector.

This fails if a new slot needs to be allocated once the kernel has finished
booting as it is no-longer possible to modify KVM's vectors:
| root@adam:/sys/devices/system/cpu/cpu1# echo 1 > online
| Unable to handle kernel write to read-only memory at virtual add>
| Mem abort info:
|   ESR = 0x9600004e
|   Exception class = DABT (current EL), IL = 32 bits
|   SET = 0, FnV = 0
|   EA = 0, S1PTW = 0
| Data abort info:
|   ISV = 0, ISS = 0x0000004e
|   CM = 0, WnR = 1
| swapper pgtable: 4k pages, 48-bit VAs, pgdp = 000000000f07a71c
| [ffff800000b4b800] pgd=00000009ffff8803, pud=00000009ffff7803, p>
| Internal error: Oops: 9600004e [#1] PREEMPT SMP
| Modules linked in:
| Process swapper/1 (pid: 0, stack limit = 0x0000000063153c53)
| CPU: 1 PID: 0 Comm: swapper/1 Not tainted 4.19.252-dirty #14
| Hardware name: ARM LTD ARM Juno Development Platform/ARM Juno De>
| pstate: 000001c5 (nzcv dAIF -PAN -UAO)
| pc : __memcpy+0x48/0x180
| lr : __copy_hyp_vect_bpi+0x64/0x90

| Call trace:
|  __memcpy+0x48/0x180
|  kvm_setup_bhb_slot+0x204/0x2a8
|  spectre_bhb_enable_mitigation+0x1b8/0x1d0
|  __verify_local_cpu_caps+0x54/0xf0
|  check_local_cpu_capabilities+0xc4/0x184
|  secondary_start_kernel+0xb0/0x170
| Code: b8404423 b80044c3 36180064 f8408423 (f80084c3)
| ---[ end trace 859bcacb09555348 ]---
| Kernel panic - not syncing: Attempted to kill the idle task!
| SMP: stopping secondary CPUs
| Kernel Offset: disabled
| CPU features: 0x10,25806086
| Memory Limit: none
| ---[ end Kernel panic - not syncing: Attempted to kill the idle ]

This is only a problem on platforms where there is only one CPU that is
vulnerable to both Spectre-v2 and Spectre-BHB.

The Spectre-v2 mitigation identifies the slot it can re-use by the CPU's
'fn'. It unconditionally writes the slot number and 'template_start'
pointer. The Spectre-BHB mitigation identifies slots it can re-use by
the CPU's template_start pointer, which was previously clobbered by the
Spectre-v2 mitigation.

When there is only one CPU that is vulnerable to both issues, this causes
Spectre-v2 to try to allocate a new slot, which fails.

Change both mitigations to check whether they are changing the slot this
CPU uses before writing the percpu variables again.

This issue only exists in the stable backports for Spectre-BHB which have
to use totally different infrastructure to mainline.

Reported-by: Sami Lee <sami.lee@mediatek.com>
Fixes: 3e3904125fcc ("arm64: Mitigate spectre style branch history side channels")
Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/cpu_errata.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -135,9 +135,12 @@ static void install_bp_hardening_cb(bp_h
 		__copy_hyp_vect_bpi(slot, hyp_vecs_start, hyp_vecs_end);
 	}
 
-	__this_cpu_write(bp_hardening_data.hyp_vectors_slot, slot);
-	__this_cpu_write(bp_hardening_data.fn, fn);
-	__this_cpu_write(bp_hardening_data.template_start, hyp_vecs_start);
+	if (fn != __this_cpu_read(bp_hardening_data.fn)) {
+		__this_cpu_write(bp_hardening_data.hyp_vectors_slot, slot);
+		__this_cpu_write(bp_hardening_data.fn, fn);
+		__this_cpu_write(bp_hardening_data.template_start,
+				 hyp_vecs_start);
+	}
 	spin_unlock(&bp_lock);
 }
 #else
@@ -1061,8 +1064,11 @@ static void kvm_setup_bhb_slot(const cha
 		__copy_hyp_vect_bpi(slot, hyp_vecs_start, hyp_vecs_end);
 	}
 
-	__this_cpu_write(bp_hardening_data.hyp_vectors_slot, slot);
-	__this_cpu_write(bp_hardening_data.template_start, hyp_vecs_start);
+	if (hyp_vecs_start != __this_cpu_read(bp_hardening_data.template_start)) {
+		__this_cpu_write(bp_hardening_data.hyp_vectors_slot, slot);
+		__this_cpu_write(bp_hardening_data.template_start,
+				 hyp_vecs_start);
+	}
 	spin_unlock(&bp_lock);
 }
 #else


