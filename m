Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB8721A35EC
	for <lists+stable@lfdr.de>; Thu,  9 Apr 2020 16:32:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727464AbgDIOcn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Apr 2020 10:32:43 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:45312 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727104AbgDIOcn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Apr 2020 10:32:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586442762;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xIXFUb0FLYNgUdK3hFqZoE5yfn+6FlS4ae+mygMLncw=;
        b=VlZUaYdomXF+0DUXO5gokf8Sp2HzqgWZpEOiilmAyAn4ZAfDuWEba6pv2bRUgGAMqoccLs
        fgZUg1iXLeFrzHy+QBoXcgx/bDDBmN94fODp/9ym1TbcZXPumZJ68TErUXqMOTc524Fmm9
        oorPUzSIJ/vixSk3e3Dha0idfccDsTo=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-253-MEw4OEBHPaatXJZ7zVDh3g-1; Thu, 09 Apr 2020 10:32:41 -0400
X-MC-Unique: MEw4OEBHPaatXJZ7zVDh3g-1
Received: by mail-wr1-f69.google.com with SMTP id e10so6469205wru.6
        for <stable@vger.kernel.org>; Thu, 09 Apr 2020 07:32:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xIXFUb0FLYNgUdK3hFqZoE5yfn+6FlS4ae+mygMLncw=;
        b=UdwzWyvbz5H/HlyzQ1/CISyp5pb/FrMoCN1W1X15j54ewhlffhFsZZyNGek2i5i/2i
         abA/96YP/VPIVB4/EbeoOscP829oslKTKvpZMi2/R2cjjVmXtVBJelZLtppmyZy3nlBl
         yhZVUe6ijXx4X4NwO5zipjit2CneeqS7LbBrUS+iaGTiNTRcYKbPc4AxqU9CMxgbVO4o
         sd4bRDtDQh6sYitX/tGXdz/Wu8cDQ2PJ+3w358iF7yu4c/tnjiGir2frZTkaoGrV5eE8
         ZnMQ51gxWHzl247XfTGt6nCwEIZe+rUXFCu5FuhD8nQISDd2P3yj7QryUzc6S93fo7hK
         2RVA==
X-Gm-Message-State: AGi0PuZKvl+SZcL4SUGXFiQJISdKby1XqujLRifdV9x+EQIfqrZJjgAh
        tv3Eswg8NJJKWOS7Lt8ar28grwk9f1SMVgM8GW96NCrV9GCM7lTBaKUtKFk1rUhwMkdb+d7uvRW
        y3Z+C7722Q+ylIVI0
X-Received: by 2002:a5d:5273:: with SMTP id l19mr14487601wrc.412.1586442759623;
        Thu, 09 Apr 2020 07:32:39 -0700 (PDT)
X-Google-Smtp-Source: APiQypIA8jQ/YNBcSy1O4qlAFCIG59y1UDzF7PctL0/nohtHqv/spzcNo8KSRotFgDfwh2a+KlfeCw==
X-Received: by 2002:a5d:5273:: with SMTP id l19mr14487568wrc.412.1586442759328;
        Thu, 09 Apr 2020 07:32:39 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:e8a3:73c:c711:b995? ([2001:b07:6468:f312:e8a3:73c:c711:b995])
        by smtp.gmail.com with ESMTPSA id a18sm18693254wrw.82.2020.04.09.07.32.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Apr 2020 07:32:38 -0700 (PDT)
Subject: Re: [PATCH v2] x86/kvm: Disable KVM_ASYNC_PF_SEND_ALWAYS
To:     Andrew Cooper <andrew.cooper3@citrix.com>,
        Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        kvm list <kvm@vger.kernel.org>, stable <stable@vger.kernel.org>
References: <20200407172140.GB64635@redhat.com>
 <772A564B-3268-49F4-9AEA-CDA648F6131F@amacapital.net>
 <87eeszjbe6.fsf@nanos.tec.linutronix.de>
 <ce81c95f-8674-4012-f307-8f32d0e386c2@redhat.com>
 <874ktukhku.fsf@nanos.tec.linutronix.de>
 <274f3d14-08ac-e5cc-0b23-e6e0274796c8@redhat.com>
 <20200408153413.GA11322@linux.intel.com>
 <ce28e893-2ed0-ea6f-6c36-b08bb0d814f2@redhat.com>
 <87d08hc0vz.fsf@nanos.tec.linutronix.de>
 <CALCETrWG2Y4SPmVkugqgjZcMfpQiq=YgsYBmWBm1hj_qx3JNVQ@mail.gmail.com>
 <04aca08a-cfce-b4db-559a-23aee0a0b7aa@redhat.com>
 <0b632fb1-b662-89bf-2b95-6888bd64b3a9@citrix.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <c09dd91f-c280-85a6-c2a2-d44a0d378bbc@redhat.com>
Date:   Thu, 9 Apr 2020 16:32:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <0b632fb1-b662-89bf-2b95-6888bd64b3a9@citrix.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 09/04/20 16:13, Andrew Cooper wrote:
> On 09/04/2020 13:47, Paolo Bonzini wrote:
>> On 09/04/20 06:50, Andy Lutomirski wrote:
>>> The small
>>> (or maybe small) one is that any fancy protocol where the guest
>>> returns from an exception by doing, logically:
>>>
>>> Hey I'm done;  /* MOV somewhere, hypercall, MOV to CR4, whatever */
>>> IRET;
>>>
>>> is fundamentally racy.  After we say we're done and before IRET, we
>>> can be recursively reentered.  Hi, NMI!
>> That's possible in theory.  In practice there would be only two levels
>> of nesting, one for the original page being loaded and one for the tail
>> of the #VE handler.  The nested #VE would see IF=0, resolve the EPT
>> violation synchronously and both handlers would finish.  For the tail
>> page to be swapped out again, leading to more nesting, the host's LRU
>> must be seriously messed up.
>>
>> With IST it would be much messier, and I haven't quite understood why
>> you believe the #VE handler should have an IST.
> 
> Any interrupt/exception which can possibly occur between a SYSCALL and
> re-establishing a kernel stack (several instructions), must be IST to
> avoid taking said exception on a user stack and being a trivial
> privilege escalation.

Doh, of course.  I always confuse SYSCALL and SYSENTER.

> Therefore, it doesn't really matter if KVM's paravirt use of #VE does
> respect the interrupt flag.  It is not sensible to build a paravirt
> interface using #VE who's safety depends on never turning on
> hardware-induced #VE's.

No, I think we wouldn't use a paravirt #VE at this point, we would use
the real thing if available.

It would still be possible to switch from the IST to the main kernel
stack before writing 0 to the reentrancy word.

Paolo

