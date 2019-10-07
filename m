Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67477CE1DD
	for <lists+stable@lfdr.de>; Mon,  7 Oct 2019 14:36:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727604AbfJGMg4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Oct 2019 08:36:56 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:37241 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727467AbfJGMg4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Oct 2019 08:36:56 -0400
Received: by mail-ed1-f65.google.com with SMTP id r4so12267695edy.4
        for <stable@vger.kernel.org>; Mon, 07 Oct 2019 05:36:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Uk1e+rSPPPcmq510EQwwN56zulkU+2rXsUn/nNSrfq4=;
        b=sJNwkWXU6kKbUTh3eKPhFGy3nF1R1rQBzn+N4YztB7Vy5aiQzp9HICgP4qVPO2socD
         V2E95imIM7ENYcm+5pdRNdQFLacyguzz9uHhtW5Y0HYnUSMb+i8zVIGYtPQJcUEY4A1k
         RbTx/On2sSTK8WvqR09LstsahRXTguw9J9+LXu6iudO5pwUnxof/+8QMYJra5ogDZEQS
         tjVEXMbpaCYOmUt/84njAMDa7bIm5dQOogs8Y5y2Qxbocb055FjGvHIH02bLipyyU/ou
         /aukpxBuHFaMDFxM8NF9h7qIdpZiKecOuybeDPjEePlXvwhiFXuLdDcDs3NXeDtmm2iq
         LGRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Uk1e+rSPPPcmq510EQwwN56zulkU+2rXsUn/nNSrfq4=;
        b=toQt7qUbokaRG50fH+qVOPvYbrwiHMr3kfHF/8dgqu6uBQ3bqhjRFLnYRb5xuwVjwF
         C2vW8TIum8sj+xC6jUWUdokWWxmtz5MK3ptjyqn8sywP2/i+0p7+Z/L5ZHTV6/FYaDAy
         0IwXt4FGpuOXKoLHir+yr0RtlaCqI18KwQEtLq1jEo6KYUz6Tc5YCVmwGpzn8vW1/Guw
         ZN3jf4lJJTCYxqjbGKe8XGlxjwTHWR/HTCoNYYinqFTaXS2mooSS6ja/ccNBFaG4eguZ
         MGF3oc8Dk392P2TCh5A2W/8ILyzROXxopA19XOOLRM0ZHEvKO7o+ECMcr3fx4nSsXzlp
         i8zg==
X-Gm-Message-State: APjAAAWtnWiRqK6nNSLq61RDyKpMqN+q47Mhgr+2RXHDJQfi3AcDJMvI
        piSr5LDMmmN2rCVmCUCGfIk=
X-Google-Smtp-Source: APXvYqyhnPxtJz29+hXsuwkdLwEbB6hRlq0PnjcKYKYnrWhUSdoZrqqKZIQCjpPufWCZT/6+C4ftAw==
X-Received: by 2002:aa7:d688:: with SMTP id d8mr28745644edr.156.1570451814850;
        Mon, 07 Oct 2019 05:36:54 -0700 (PDT)
Received: from jwang-Latitude-5491.pb.local ([2001:1438:4010:2558:f50b:fd6b:fe5b:ba84])
        by smtp.gmail.com with ESMTPSA id w16sm3400256edd.93.2019.10.07.05.36.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Oct 2019 05:36:54 -0700 (PDT)
From:   Jack Wang <jinpuwang@gmail.com>
To:     gregkh@linuxfoundation.org, sashal@kernel.org,
        stable@vger.kernel.org, pbonzini@redhat.com
Cc:     Jack Wang <jinpu.wang@cloud.ionos.com>
Subject: [stable 4.4/4.9/4.14/4.19] KVM: nVMX: handle page fault in vmread fix
Date:   Mon,  7 Oct 2019 14:36:53 +0200
Message-Id: <20191007123653.17961-1-jinpuwang@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jack Wang <jinpu.wang@cloud.ionos.com>

During backport f7eea636c3d5 ("KVM: nVMX: handle page fault in vmread"),
there was a mistake the exception reference should be passed to function
kvm_write_guest_virt_system, instead of NULL, other wise, we will get
NULL pointer deref, eg

kvm-unit-test triggered a NULL pointer deref below:
[  948.518437] kvm [24114]: vcpu0, guest rIP: 0x407ef9 kvm_set_msr_common: MSR_IA32_DEBUGCTLMSR 0x3, nop
[  949.106464] BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
[  949.106707] PGD 0 P4D 0
[  949.106872] Oops: 0002 [#1] SMP
[  949.107038] CPU: 2 PID: 24126 Comm: qemu-2.7 Not tainted 4.19.77-pserver #4.19.77-1+feature+daily+update+20191005.1625+a4168bb~deb9
[  949.107283] Hardware name: Dell Inc. Precision Tower 3620/09WH54, BIOS 2.7.3 01/31/2018
[  949.107549] RIP: 0010:kvm_write_guest_virt_system+0x12/0x40 [kvm]
[  949.107719] Code: c0 5d 41 5c 41 5d 41 5e 83 f8 03 41 0f 94 c0 41 c1 e0 02 e9 b0 ed ff ff 0f 1f 44 00 00 48 89 f0 c6 87 59 56 00 00 01 48 89 d6 <49> c7 00 00 00 00 00 89 ca 49 c7 40 08 00 00 00 00 49 c7 40 10 00
[  949.108044] RSP: 0018:ffffb31b0a953cb0 EFLAGS: 00010202
[  949.108216] RAX: 000000000046b4d8 RBX: ffff9e9f415b0000 RCX: 0000000000000008
[  949.108389] RDX: ffffb31b0a953cc0 RSI: ffffb31b0a953cc0 RDI: ffff9e9f415b0000
[  949.108562] RBP: 00000000d2e14928 R08: 0000000000000000 R09: 0000000000000000
[  949.108733] R10: 0000000000000000 R11: 0000000000000000 R12: ffffffffffffffc8
[  949.108907] R13: 0000000000000002 R14: ffff9e9f4f26f2e8 R15: 0000000000000000
[  949.109079] FS:  00007eff8694c700(0000) GS:ffff9e9f51a80000(0000) knlGS:0000000031415928
[  949.109318] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  949.109495] CR2: 0000000000000000 CR3: 00000003be53b002 CR4: 00000000003626e0
[  949.109671] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  949.109845] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  949.110017] Call Trace:
[  949.110186]  handle_vmread+0x22b/0x2f0 [kvm_intel]
[  949.110356]  ? vmexit_fill_RSB+0xc/0x30 [kvm_intel]
[  949.110549]  kvm_arch_vcpu_ioctl_run+0xa98/0x1b30 [kvm]
[  949.110725]  ? kvm_vcpu_ioctl+0x388/0x5d0 [kvm]
[  949.110901]  kvm_vcpu_ioctl+0x388/0x5d0 [kvm]
[  949.111072]  do_vfs_ioctl+0xa2/0x620

Signed-off-by: Jack Wang <jinpu.wang@cloud.ionos.com>
---
 arch/x86/kvm/vmx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index f6b0f5c01546..3bfdbb5fced5 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -8026,7 +8026,7 @@ static int handle_vmread(struct kvm_vcpu *vcpu)
 		/* _system ok, nested_vmx_check_permission has verified cpl=0 */
 		if (kvm_write_guest_virt_system(vcpu, gva, &field_value,
 						(is_long_mode(vcpu) ? 8 : 4),
-						NULL))
+						&e))
 			kvm_inject_page_fault(vcpu, &e);
 	}
 
-- 
2.17.1

