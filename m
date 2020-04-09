Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B33321A36C9
	for <lists+stable@lfdr.de>; Thu,  9 Apr 2020 17:17:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728000AbgDIPRk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Apr 2020 11:17:40 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:39153 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727865AbgDIPRk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Apr 2020 11:17:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586445459;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Xz/x7+R3F325gRCdi+IZ/dfc0jmeQMCDLQzXTFYiwII=;
        b=ILHC9TwdRqFWUn1c4+2x2uVdf+FZ1IpXuI/ougN8rK9Q+gqm7spcKO9e603l3m8FQClLOx
        qCdF5jhzmDl04oD0GqWynalKoO7P2HaYAlGUC6gznt9YSpE3mF6LdyyLSec8G9pi05Rs55
        h1vV6f/Z0btHZlKvBctnmUFi4foSJbQ=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-254-UZhrSDOdMB-6I7NSSyFJsQ-1; Thu, 09 Apr 2020 11:17:36 -0400
X-MC-Unique: UZhrSDOdMB-6I7NSSyFJsQ-1
Received: by mail-wm1-f70.google.com with SMTP id d134so2129393wmd.0
        for <stable@vger.kernel.org>; Thu, 09 Apr 2020 08:17:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Xz/x7+R3F325gRCdi+IZ/dfc0jmeQMCDLQzXTFYiwII=;
        b=OrTttqsgNVJ1gZIXvfpQKKeH/VGqO+oUT9kiX+OceB7taBApOf7Zb290s6BD3nSRsu
         HH31Ho00xM4fStjbckH9Y/pkfjpxUZq2s1gz5Sw8Vz412Hi/qreJnVXBdWPRE3mPhFYO
         nsHK7UlQ+J4i38jvrncRLSRQi8+feJ/7vUWsSC24ViGyBpWdfAU7/gidxauB5M9qVMaV
         k2AB2r7wQgwOBOy+DS1A0hPzcBoFGCCLbiAikrUm8Uc3mHX/9eRE1rpixDJL5U5IBTnq
         TSxJuklQUyUh5TdbnyuqFbBVeYOP9zwT1GfUr4IjSrhAZpPZVutI8LJw6cIAmfrOzdRA
         sYtA==
X-Gm-Message-State: AGi0PuZuVu+Wf6RXb/OVrStFfb7Gjj4YjlYXKnLcNpvhXuwUtd8Y7kNN
        iSSp4cA3ZQPJfxV2hDq8i1aNusDe6FBjbszXljZDzX8fEHaax4qqYHh16R+G5Tge2P6J5hFdtRn
        83XKLkYIXi91R5hzz
X-Received: by 2002:a5d:6183:: with SMTP id j3mr14822037wru.83.1586445454640;
        Thu, 09 Apr 2020 08:17:34 -0700 (PDT)
X-Google-Smtp-Source: APiQypIHzBMEQqCXfIoBEX+rooZW9MeTLAzADd/bCoZQger9W2poqui6FuOadw72A9pT8T34FS1Qfg==
X-Received: by 2002:a5d:6183:: with SMTP id j3mr14822020wru.83.1586445454436;
        Thu, 09 Apr 2020 08:17:34 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.170.5])
        by smtp.gmail.com with ESMTPSA id w15sm31255987wra.25.2020.04.09.08.17.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Apr 2020 08:17:33 -0700 (PDT)
Subject: Re: [PATCH v2] x86/kvm: Disable KVM_ASYNC_PF_SEND_ALWAYS
To:     Andy Lutomirski <luto@amacapital.net>
Cc:     Andrew Cooper <andrew.cooper3@citrix.com>,
        Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        kvm list <kvm@vger.kernel.org>, stable <stable@vger.kernel.org>
References: <c09dd91f-c280-85a6-c2a2-d44a0d378bbc@redhat.com>
 <4EB5D96F-F322-45BB-9169-6BF932D413D4@amacapital.net>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <931f6e6d-ac17-05f9-0605-ac8f89f40b2b@redhat.com>
Date:   Thu, 9 Apr 2020 17:17:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <4EB5D96F-F322-45BB-9169-6BF932D413D4@amacapital.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 09/04/20 17:03, Andy Lutomirski wrote:
>> No, I think we wouldn't use a paravirt #VE at this point, we would
>> use the real thing if available.
>> 
>> It would still be possible to switch from the IST to the main
>> kernel stack before writing 0 to the reentrancy word.
> 
> Almost but not quite. We do this for NMI-from-usermode, and it’s
> ugly. But we can’t do this for NMI-from-kernel or #VE-from-kernel
> because there might not be a kernel stack.  Trying to hack around
> this won’t be pretty.
> 
> Frankly, I think that we shouldn’t even try to report memory failure
> to the guest if it happens with interrupts off. Just kill the guest
> cleanly and keep it simple. Or inject an intentionally unrecoverable
> IST exception.

But it would be nice to use #VE for all host-side page faults, not just
for memory failure.

So the solution would be the same as for NMIs, duplicating the stack
frame and patching the outer handler's stack from the recursive #VE
(https://lwn.net/Articles/484932/).  It's ugly but it's a known ugliness.

Paolo

