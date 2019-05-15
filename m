Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6C081F3B3
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 14:16:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727903AbfEOLCS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:02:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:59514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727897AbfEOLCR (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:02:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 85A8E2173C;
        Wed, 15 May 2019 11:02:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918137;
        bh=2/YV439l1scOh3VwnwfIHQRd6ydhco11GaZ9+3sTKM0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2mcKYNPQ+8iK3di9i33Jhs4a321rM3VSbx/kP9WnAwWT2wRnGy1dfRxpvMNZ6lpzl
         QtUSrPPIJuK4x7aD9WmoDVOxFAS0gWZB1IRA7+PWBK3U/Q5FjpZUpXAw4T/WDMvePN
         u5aArVZtfJJev6cswDa7giPVFPC/J/+BGrfepiBM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Vyukov <dvyukov@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Zubin Mithra <zsm@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 002/266] KVM: fail KVM_SET_VCPU_EVENTS with invalid exception number
Date:   Wed, 15 May 2019 12:51:49 +0200
Message-Id: <20190515090722.774789694@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090722.696531131@linuxfoundation.org>
References: <20190515090722.696531131@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 78e546c824fa8f96d323b7edd6f5cad5b74af057 upstream

This cannot be returned by KVM_GET_VCPU_EVENTS, so it is okay to return
EINVAL.  It causes a WARN from exception_type:

    WARNING: CPU: 3 PID: 16732 at arch/x86/kvm/x86.c:345 exception_type+0x49/0x50 [kvm]()
    CPU: 3 PID: 16732 Comm: a.out Tainted: G        W       4.4.6-300.fc23.x86_64 #1
    Hardware name: LENOVO 2325F51/2325F51, BIOS G2ET32WW (1.12 ) 05/30/2012
     0000000000000286 000000006308a48b ffff8800bec7fcf8 ffffffff813b542e
     0000000000000000 ffffffffa0966496 ffff8800bec7fd30 ffffffff810a40f2
     ffff8800552a8000 0000000000000000 00000000002c267c 0000000000000001
    Call Trace:
     [<ffffffff813b542e>] dump_stack+0x63/0x85
     [<ffffffff810a40f2>] warn_slowpath_common+0x82/0xc0
     [<ffffffff810a423a>] warn_slowpath_null+0x1a/0x20
     [<ffffffffa0924809>] exception_type+0x49/0x50 [kvm]
     [<ffffffffa0934622>] kvm_arch_vcpu_ioctl_run+0x10a2/0x14e0 [kvm]
     [<ffffffffa091c04d>] kvm_vcpu_ioctl+0x33d/0x620 [kvm]
     [<ffffffff81241248>] do_vfs_ioctl+0x298/0x480
     [<ffffffff812414a9>] SyS_ioctl+0x79/0x90
     [<ffffffff817a04ee>] entry_SYSCALL_64_fastpath+0x12/0x71
    ---[ end trace b1a0391266848f50 ]---

Testcase (beautified/reduced from syzkaller output):

    #include <unistd.h>
    #include <sys/syscall.h>
    #include <string.h>
    #include <stdint.h>
    #include <fcntl.h>
    #include <sys/ioctl.h>
    #include <linux/kvm.h>

    long r[31];

    int main()
    {
        memset(r, -1, sizeof(r));
        r[2] = open("/dev/kvm", O_RDONLY);
        r[3] = ioctl(r[2], KVM_CREATE_VM, 0);
        r[7] = ioctl(r[3], KVM_CREATE_VCPU, 0);

        struct kvm_vcpu_events ve = {
                .exception.injected = 1,
                .exception.nr = 0xd4
        };
        r[27] = ioctl(r[7], KVM_SET_VCPU_EVENTS, &ve);
        r[30] = ioctl(r[7], KVM_RUN, 0);
        return 0;
    }

Reported-by: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Radim Krčmář <rkrcmar@redhat.com>
Signed-off-by: Zubin Mithra <zsm@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/x86.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2972,6 +2972,10 @@ static int kvm_vcpu_ioctl_x86_set_vcpu_e
 			      | KVM_VCPUEVENT_VALID_SMM))
 		return -EINVAL;
 
+	if (events->exception.injected &&
+	    (events->exception.nr > 31 || events->exception.nr == NMI_VECTOR))
+		return -EINVAL;
+
 	/* INITs are latched while in SMM */
 	if (events->flags & KVM_VCPUEVENT_VALID_SMM &&
 	    (events->smi.smm || events->smi.pending) &&


