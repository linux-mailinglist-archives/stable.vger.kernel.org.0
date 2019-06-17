Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 284E3490CF
	for <lists+stable@lfdr.de>; Mon, 17 Jun 2019 22:07:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726455AbfFQUHI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 16:07:08 -0400
Received: from mga03.intel.com ([134.134.136.65]:23679 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726443AbfFQUHI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Jun 2019 16:07:08 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Jun 2019 13:07:01 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by fmsmga005.fm.intel.com with ESMTP; 17 Jun 2019 13:07:01 -0700
Date:   Mon, 17 Jun 2019 13:07:01 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, vkuznets@redhat.com, stable@vger.kernel.org
Subject: Re: [PATCH 22/43] KVM: nVMX: Don't dump VMCS if virtual APIC page
 can't be mapped
Message-ID: <20190617200700.GA30158@linux.intel.com>
References: <1560445409-17363-1-git-send-email-pbonzini@redhat.com>
 <1560445409-17363-23-git-send-email-pbonzini@redhat.com>
 <20190617191724.GA26860@flask>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190617191724.GA26860@flask>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 17, 2019 at 09:17:24PM +0200, Radim Krčmář wrote:
> 2019-06-13 19:03+0200, Paolo Bonzini:
> > From: Sean Christopherson <sean.j.christopherson@intel.com>
> > 
> > ... as a malicious userspace can run a toy guest to generate invalid
> > virtual-APIC page addresses in L1, i.e. flood the kernel log with error
> > messages.
> > 
> > Fixes: 690908104e39d ("KVM: nVMX: allow tests to use bad virtual-APIC page address")
> > Cc: stable@vger.kernel.org
> > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> > ---
> 
> Makes me wonder why it looks like this in kvm/queue. :)

Presumably something is wonky in Paolo's workflow, this happened before.

commit d69129b4e46a7b61dc956af038d143eb791f22c7
Author: Sean Christopherson <sean.j.christopherson@xxxxxxxxx>
Date:   Wed May 8 07:32:15 2019 -0700

    KVM: nVMX: Disable intercept for FS/GS base MSRs in vmcs02 when possible

    If L1 is using an MSR bitmap, unconditionally merge the MSR bitmaps from
    L0 and L1 for MSR_{KERNEL,}_{FS,GS}_BASE.  KVM unconditionally exposes
    MSRs L1.  If KVM is also running in L1 then it's highly likely L1 is
    also exposing the MSRs to L2, i.e. KVM doesn't need to intercept L2
    accesses.

    Based on code from Jintack Lim.

    Cc: Jintack Lim <jintack@xxxxxxxxxxxxxxx>
    Signed-off-by: Sean Christopherson <sean.j.christopherson@xxxxxxxxx>
    Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

> 
>   commit 1971a835297f9098ce5a735d38916830b8313a65
>   Author:     Sean Christopherson <sean.j.christopherson@xxxxxxxxx>
>   AuthorDate: Tue May 7 09:06:26 2019 -0700
>   Commit:     Paolo Bonzini <pbonzini@redhat.com>
>   CommitDate: Thu Jun 13 16:23:13 2019 +0200
>   
>       KVM: nVMX: Don't dump VMCS if virtual APIC page can't be mapped
>       
>       ... as a malicious userspace can run a toy guest to generate invalid
>       virtual-APIC page addresses in L1, i.e. flood the kernel log with error
>       messages.
>       
>       Fixes: 690908104e39d ("KVM: nVMX: allow tests to use bad virtual-APIC page address")
>       Cc: stable@xxxxxxxxxxxxxxx
>       Cc: Paolo Bonzini <pbonzini@xxxxxxxxxx>
>       Signed-off-by: Sean Christopherson <sean.j.christopherson@xxxxxxxxx>
>       Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
