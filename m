Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A74A16AD78
	for <lists+stable@lfdr.de>; Tue, 16 Jul 2019 19:12:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728004AbfGPRMz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jul 2019 13:12:55 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:43384 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725926AbfGPRMz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Jul 2019 13:12:55 -0400
Received: by mail-pf1-f194.google.com with SMTP id i189so9417881pfg.10
        for <stable@vger.kernel.org>; Tue, 16 Jul 2019 10:12:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=bj4PUduePCFFH7G3vNIoi90kiAQ5C9aB+GAzSep2R/g=;
        b=gwuMabF7POt4nLLlyy+MJcyTlok2tg7T+AbBpt40cUFbt1AdkkQ6tANuggJnJ0vC5u
         nybMoUdSLOVx3rkFOOFd68zTZj+2qfqSPkzEVVK04DJDXZ9s5HaLXNbwBT+v5pLfjwCo
         i43INLyFc22EB/3cCJ2koliFdevI2kHoJNPBA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=bj4PUduePCFFH7G3vNIoi90kiAQ5C9aB+GAzSep2R/g=;
        b=bjZL1cOpS7FEwVh9Zyg4WcRojKf2SIzdKJdVcY98cHyKJKK/HKlwDrwQuPMMx7wbev
         He/AqjKRCnyV+7FamU+fIQQGlslvgO2uyjFYCYChLS9vniSLY+NnUG8+dlpkKlZgd+HG
         VRMUvAhA8sDNmk50E4jJigR+7LExmPpfmhP9rgtBJLAR8FyG1A2xyXEAxS1BLJmtOXsq
         und9vzERkk2lhqJQjxKjaKcelUN3JmahR95PaM9DN38o6fn/p+4ykuOL+SFSU0GGeBK4
         lACHnTbHYpTOJVMLHInGKkWFZmWX/PlokOCN0MOyhVByqyQ4V8Uxl/Nih0c87Y8ue5KV
         mA2Q==
X-Gm-Message-State: APjAAAVX57oWkpMc75Im4MrMi4BLxkK0fZhtsnqceGU0aplkDUSG+i3q
        puGDqiBS+vju/+Y1uhjA6nBKWIkUs2c=
X-Google-Smtp-Source: APXvYqwc5aIcnuT3w5HZcekmzXG6Ln283mvr1gZUtJbddBkQSPyXJWMplA9nYDayXsullGB2VGq+Hw==
X-Received: by 2002:a17:90a:30e4:: with SMTP id h91mr36610625pjb.37.1563297174512;
        Tue, 16 Jul 2019 10:12:54 -0700 (PDT)
Received: from google.com ([2620:15c:202:201:49ea:b78f:4f04:4d25])
        by smtp.googlemail.com with ESMTPSA id i124sm42137747pfe.61.2019.07.16.10.12.53
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 16 Jul 2019 10:12:54 -0700 (PDT)
Date:   Tue, 16 Jul 2019 10:12:48 -0700
From:   Zubin Mithra <zsm@chromium.org>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, groeck@chromium.org,
        pbonzini@redhat.com, rkrcmar@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com
Subject: b21629da120d ("kvm: x86: avoid warning on repeated KVM_SET_TSS_ADDR")
Message-ID: <20190716171247.GA7816@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

Syzkaller has triggered a kernel WARNING when fuzzing a 4.4 kernel with the following stacktrace.
Call Trace:
 [<ffffffff81989d3d>] __dump_stack lib/dump_stack.c:15 [inline]
 [<ffffffff81989d3d>] dump_stack+0xbf/0x113 lib/dump_stack.c:51
 [<ffffffff813be4aa>] panic+0x1a6/0x361 kernel/panic.c:116
 [<ffffffff811c2c00>] __warn+0x168/0x1b0 kernel/panic.c:470
 [<ffffffff813be6a1>] warn_slowpath_null+0x3c/0x40 kernel/panic.c:514
 [<ffffffff81030f13>] __x86_set_memory_region+0x1c2/0x3ef arch/x86/kvm/x86.c:7792
 [<ffffffff81031185>] x86_set_memory_region+0x45/0x5c arch/x86/kvm/x86.c:7838
 [<ffffffff810add1e>] vmx_set_tss_addr+0x8c/0x246 arch/x86/kvm/vmx.c:5171
 [<ffffffff8103a798>] kvm_vm_ioctl_set_tss_addr arch/x86/kvm/x86.c:3520 [inline]
 [<ffffffff8103a798>] kvm_arch_vm_ioctl+0x26b/0x17db arch/x86/kvm/x86.c:3788
 [<ffffffff81013cb4>] kvm_vm_ioctl+0xb7d/0xbfa arch/x86/kvm/../../../virt/kvm/kvm_main.c:2959
 [<ffffffff8149d51a>] vfs_ioctl fs/ioctl.c:43 [inline]
 [<ffffffff8149d51a>] do_vfs_ioctl+0xcb0/0xd0f fs/ioctl.c:630
 [<ffffffff8149d5ea>] SYSC_ioctl fs/ioctl.c:645 [inline]
 [<ffffffff8149d5ea>] SyS_ioctl+0x71/0xad fs/ioctl.c:636
 [<ffffffff832bca35>] tracesys_phase2+0xa3/0xa8

Could the following patch be applied to v4.4.y. The patch is present in v4.9.y.
* b21629da120d ("kvm: x86: avoid warning on repeated KVM_SET_TSS_ADDR")

Tests run:
* Syzkaller reproducer
* Chrome OS tryjobs



Thanks,
- Zubin
