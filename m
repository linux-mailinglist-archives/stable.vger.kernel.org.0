Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D095D6C668
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 05:16:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727541AbfGRDQn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jul 2019 23:16:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:51878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391963AbfGRDPJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jul 2019 23:15:09 -0400
Received: from localhost (115.42.148.210.bf.2iij.net [210.148.42.115])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6155321851;
        Thu, 18 Jul 2019 03:15:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563419708;
        bh=85YpcDmppaGqjPf78UKpVnm5N7xmEXTllliY6TV9Mko=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H/LZq9JljM59XGueBpWU2kCT+Gjm2MExXylwpqWJZ4ESWTbB/EjxpdjNGwARwfbEB
         CpicY6efNRyFmCLiWuqnvFHUVvZXxgYiovDaW05vLPTea4HjRBAl9OPbRNad2scvzo
         sqb9Zr2tOdqvM5rAp56wox7URJhEZzdmWO+GcO/I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Vyukov <dvyukov@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Zubin Mithra <zsm@chromium.org>
Subject: [PATCH 4.4 35/40] kvm: x86: avoid warning on repeated KVM_SET_TSS_ADDR
Date:   Thu, 18 Jul 2019 12:02:31 +0900
Message-Id: <20190718030050.133509558@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190718030039.676518610@linuxfoundation.org>
References: <20190718030039.676518610@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

commit b21629da120dd6145d14dbd6d028e1bba680a92b upstream.

Found by syzkaller:

    WARNING: CPU: 3 PID: 15175 at arch/x86/kvm/x86.c:7705 __x86_set_memory_region+0x1dc/0x1f0 [kvm]()
    CPU: 3 PID: 15175 Comm: a.out Tainted: G        W       4.4.6-300.fc23.x86_64 #1
    Hardware name: LENOVO 2325F51/2325F51, BIOS G2ET32WW (1.12 ) 05/30/2012
     0000000000000286 00000000950899a7 ffff88011ab3fbf0 ffffffff813b542e
     0000000000000000 ffffffffa0966496 ffff88011ab3fc28 ffffffff810a40f2
     00000000000001fd 0000000000003000 ffff88014fc50000 0000000000000000
    Call Trace:
     [<ffffffff813b542e>] dump_stack+0x63/0x85
     [<ffffffff810a40f2>] warn_slowpath_common+0x82/0xc0
     [<ffffffff810a423a>] warn_slowpath_null+0x1a/0x20
     [<ffffffffa09251cc>] __x86_set_memory_region+0x1dc/0x1f0 [kvm]
     [<ffffffffa092521b>] x86_set_memory_region+0x3b/0x60 [kvm]
     [<ffffffffa09bb61c>] vmx_set_tss_addr+0x3c/0x150 [kvm_intel]
     [<ffffffffa092f4d4>] kvm_arch_vm_ioctl+0x654/0xbc0 [kvm]
     [<ffffffffa091d31a>] kvm_vm_ioctl+0x9a/0x6f0 [kvm]
     [<ffffffff81241248>] do_vfs_ioctl+0x298/0x480
     [<ffffffff812414a9>] SyS_ioctl+0x79/0x90
     [<ffffffff817a04ee>] entry_SYSCALL_64_fastpath+0x12/0x71

Testcase:

    #include <unistd.h>
    #include <sys/ioctl.h>
    #include <fcntl.h>
    #include <string.h>
    #include <linux/kvm.h>

    long r[8];

    int main()
    {
        memset(r, -1, sizeof(r));
	r[2] = open("/dev/kvm", O_RDONLY|O_TRUNC);
        r[3] = ioctl(r[2], KVM_CREATE_VM, 0x0ul);
        r[5] = ioctl(r[3], KVM_SET_TSS_ADDR, 0x20000000ul);
        r[7] = ioctl(r[3], KVM_SET_TSS_ADDR, 0x20000000ul);
        return 0;
    }

Reported-by: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Radim Krčmář <rkrcmar@redhat.com>
Cc: Zubin Mithra <zsm@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/x86.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7799,7 +7799,7 @@ int __x86_set_memory_region(struct kvm *
 
 	slot = id_to_memslot(slots, id);
 	if (size) {
-		if (WARN_ON(slot->npages))
+		if (slot->npages)
 			return -EEXIST;
 
 		/*


