Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B52192534FE
	for <lists+stable@lfdr.de>; Wed, 26 Aug 2020 18:34:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726834AbgHZQei (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Aug 2020 12:34:38 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:4769 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726772AbgHZQeh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Aug 2020 12:34:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1598459677; x=1629995677;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=vNUOxnUmVSAav21F70Mtkdnqy345FUiYJAS/P4eC49M=;
  b=cPX4DAqL/xHX6HYFvS1TMDLpLu66Q4fiQpEOQwp9FhkqB9ILnIQvNbCY
   URme70TIXuD1uT8v3zDKU3oCrDlsmBEo90Kx5eyaAykHtxeF3euirZ/9d
   BVCMw+3NRk+MHp5Uf7yVRmhqYRlr1HV/E+nIxiH/cCKi6Ab4TTL9LhRlZ
   c=;
X-IronPort-AV: E=Sophos;i="5.76,356,1592870400"; 
   d="scan'208";a="71127687"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2a-538b0bfb.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 26 Aug 2020 16:34:07 +0000
Received: from EX13MTAUWC001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2a-538b0bfb.us-west-2.amazon.com (Postfix) with ESMTPS id 21A16A1921;
        Wed, 26 Aug 2020 16:33:58 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 26 Aug 2020 16:33:57 +0000
Received: from vpn-10-85-95-61.fra53.corp.amazon.com (10.43.162.55) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 26 Aug 2020 16:33:49 +0000
Subject: Re: [PATCH] x86/irq: Preserve vector in orig_ax for APIC code
To:     Thomas Gleixner <tglx@linutronix.de>, X86 ML <x86@kernel.org>
CC:     Andy Lutomirski <luto@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Alexandre Chartre <alexandre.chartre@oracle.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Petr Mladek <pmladek@suse.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Joel Fernandes <joel@joelfernandes.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        "Will Deacon" <will@kernel.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Wei Liu <wei.liu@kernel.org>,
        Michael Kelley <mikelley@microsoft.com>,
        Jason Chen CJ <jason.cj.chen@intel.com>,
        Zhao Yakui <yakui.zhao@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Avi Kivity <avi@scylladb.com>,
        "Herrenschmidt, Benjamin" <benh@amazon.com>, <robketr@amazon.de>,
        <amos@scylladb.com>, Brian Gerst <brgerst@gmail.com>,
        <stable@vger.kernel.org>
References: <20200826115357.3049-1-graf@amazon.com>
 <87k0xlv5w5.fsf@nanos.tec.linutronix.de>
From:   Alexander Graf <graf@amazon.com>
Message-ID: <fd87a87d-7d8a-9959-6c81-f49003a43c21@amazon.com>
Date:   Wed, 26 Aug 2020 18:33:46 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.1.1
MIME-Version: 1.0
In-Reply-To: <87k0xlv5w5.fsf@nanos.tec.linutronix.de>
Content-Language: en-US
X-Originating-IP: [10.43.162.55]
X-ClientProxiedBy: EX13D46UWC002.ant.amazon.com (10.43.162.67) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="windows-1252"; format="flowed"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 26.08.20 16:27, Thomas Gleixner wrote:
> =

> On Wed, Aug 26 2020 at 13:53, Alexander Graf wrote:
>> Commit 633260fa143 ("x86/irq: Convey vector as argument and not in ptreg=
s")
>> changed the handover logic of the vector identifier from ~vector in orig=
_ax
>> to purely register based. Unfortunately, this field has another consumer
>> in the APIC code which the commit did not touch. The net result was that
>> IRQ balancing did not work and instead resulted in interrupt storms, slo=
wing
>> down the system.
> =

> The net result is an observationof the symptom but that does not explain
> what the underlying technical issue is.
> =

>> This patch restores the original semantics that orig_ax contains the vec=
tor.
>> When we receive an interrupt now, the actual vector number stays stored =
in
>> the orig_ax field which then gets consumed by the APIC code.
>>
>> To ensure that nobody else trips over this in the future, the patch also=
 adds
>> comments at strategic places to warn anyone who would refactor the code =
that
>> there is another consumer of the field.
>>
>> With this patch in place, IRQ balancing works as expected and performance
>> levels are restored to previous levels.
> =

> There's a lot of 'This patch and we' in that changelog. Care to grep
> for 'This patch' in Documentation/process/ ?
> =

>> diff --git a/arch/x86/entry/entry_32.S b/arch/x86/entry/entry_32.S
>> index df8c017..22e829c 100644
>> --- a/arch/x86/entry/entry_32.S
>> +++ b/arch/x86/entry/entry_32.S
>> @@ -727,7 +727,7 @@ SYM_CODE_START_LOCAL(asm_\cfunc)
>>        ENCODE_FRAME_POINTER
>>        movl    %esp, %eax
>>        movl    PT_ORIG_EAX(%esp), %edx         /* get the vector from st=
ack */
>> -     movl    $-1, PT_ORIG_EAX(%esp)          /* no syscall to restart */
>> +     /* keep vector on stack for APIC's irq_complete_move() */
> =

> Yes that's fixing your observed wreckage, but it introduces a worse one.
> =

> user space
>    -> interrupt
>         push vector into orig_ax (values are in the ranges of 0-127 and -=
128 - 255
>                                   except for the system vectors which do
>                                   not go through this code)
>        handle()
>        ...
>        exit_to_user_mode_loop()
>           arch_do_signal()
>              /* Did we come from a system call? */
>              if (syscall_get_nr(current, regs) >=3D 0) {
> =

>                 ---> BOOM for any vector 0-127 because syscall_get_nr()
>                           resolves to regs->orig_ax
> =

> Going to be fun to debug.

Hah, that's the code flow I was looking for to understand why the value =

was negative in the first place. Thanks a lot for pointing it out!

> =

> The below nasty hack cures it, but I hate it with a passion. I'll look
> deeper for a sane variant.

An alternative (that doesn't make the code easier to read, but would fix =

the issue at hand) would be touse a pushq imm16 with vector | 0x8000 =

instead to always make the value negative, no?


Alex



Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



