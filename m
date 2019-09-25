Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9586BE83E
	for <lists+stable@lfdr.de>; Thu, 26 Sep 2019 00:23:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729237AbfIYWXm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Sep 2019 18:23:42 -0400
Received: from mga03.intel.com ([134.134.136.65]:55986 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727010AbfIYWXm (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 25 Sep 2019 18:23:42 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Sep 2019 15:23:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,549,1559545200"; 
   d="scan'208";a="340549867"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga004.jf.intel.com with ESMTP; 25 Sep 2019 15:23:41 -0700
Date:   Wed, 25 Sep 2019 15:23:41 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, stable@vger.kernel.org
Subject: Re: [PATCH v3] KVM: X86: Fix userspace set invalid CR4
Message-ID: <20190925222341.GO31852@linux.intel.com>
References: <1568800210-3127-1-git-send-email-wanpengli@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1568800210-3127-1-git-send-email-wanpengli@tencent.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 18, 2019 at 05:50:10PM +0800, Wanpeng Li wrote:
> From: Wanpeng Li <wanpengli@tencent.com>
> 
> Reported by syzkaller:
> 
> 	WARNING: CPU: 0 PID: 6544 at /home/kernel/data/kvm/arch/x86/kvm//vmx/vmx.c:4689 handle_desc+0x37/0x40 [kvm_intel]
> 	CPU: 0 PID: 6544 Comm: a.out Tainted: G           OE     5.3.0-rc4+ #4
> 	RIP: 0010:handle_desc+0x37/0x40 [kvm_intel]
> 	Call Trace:
> 	 vmx_handle_exit+0xbe/0x6b0 [kvm_intel]
> 	 vcpu_enter_guest+0x4dc/0x18d0 [kvm]
> 	 kvm_arch_vcpu_ioctl_run+0x407/0x660 [kvm]
> 	 kvm_vcpu_ioctl+0x3ad/0x690 [kvm]
> 	 do_vfs_ioctl+0xa2/0x690
> 	 ksys_ioctl+0x6d/0x80
> 	 __x64_sys_ioctl+0x1a/0x20
> 	 do_syscall_64+0x74/0x720
> 	 entry_SYSCALL_64_after_hwframe+0x49/0xbe
> 
> When CR4.UMIP is set, guest should have UMIP cpuid flag. Current
> kvm set_sregs function doesn't have such check when userspace inputs
> sregs values. SECONDARY_EXEC_DESC is enabled on writes to CR4.UMIP
> in vmx_set_cr4 though guest doesn't have UMIP cpuid flag. The testcast
> triggers handle_desc warning when executing ltr instruction since
> guest architectural CR4 doesn't set UMIP. This patch fixes it by
> adding valid CR4 and CPUID combination checking in __set_sregs.
> 
> syzkaller source: https://syzkaller.appspot.com/x/repro.c?x=138efb99600000
> 
> Reported-by: syzbot+0f1819555fbdce992df9@syzkaller.appspotmail.com
> Cc: stable@vger.kernel.org
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---

Per Paolo, the additional checks should be ok:

  https://lkml.kernel.org/r/d0c35f21-b262-2c4e-9109-4ab803487705@redhat.com

I'm pretty sure userspace can still induce a WARN storm by setting the
cr4_fixed0/1 MSRs for a nested guest, but this is a good change regardless.

Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
