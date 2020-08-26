Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 594D12538EC
	for <lists+stable@lfdr.de>; Wed, 26 Aug 2020 22:10:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726753AbgHZUK0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Aug 2020 16:10:26 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:22674 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726734AbgHZUKZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Aug 2020 16:10:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1598472625; x=1630008625;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=aU2RaGMPuG6AQMjQ4p0fBBiz8S4VHOimEKgTasXFcpE=;
  b=qT+TAY8lOvnJVPkPOB+gIcwNForgvxyIpJkLbdAlp/rzo5IdjdnqxfXL
   KwfCmPeSch9YzDociQMBGiCdTiPPj+H3vR4feVwz0bW37zpmXi1v18eaS
   p+YTS2awMwTPtHqyo73IpXPUXoDAMYv0lr4ciBVdz3jXBMSFlEpg1rw/d
   g=;
X-IronPort-AV: E=Sophos;i="5.76,356,1592870400"; 
   d="scan'208";a="50106232"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2b-baacba05.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 26 Aug 2020 20:10:10 +0000
Received: from EX13MTAUWC002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2b-baacba05.us-west-2.amazon.com (Postfix) with ESMTPS id B320AA239C;
        Wed, 26 Aug 2020 20:10:01 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC002.ant.amazon.com (10.43.162.240) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 26 Aug 2020 20:09:59 +0000
Received: from vpn-10-85-95-61.fra53.corp.amazon.com (10.43.161.85) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 26 Aug 2020 20:09:52 +0000
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
 <fd87a87d-7d8a-9959-6c81-f49003a43c21@amazon.com>
 <87blixuuny.fsf@nanos.tec.linutronix.de>
 <873649utm4.fsf@nanos.tec.linutronix.de>
From:   Alexander Graf <graf@amazon.com>
Message-ID: <9f351750-f652-f9c5-ca79-fc90273ee3c8@amazon.com>
Date:   Wed, 26 Aug 2020 22:09:49 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.1.1
MIME-Version: 1.0
In-Reply-To: <873649utm4.fsf@nanos.tec.linutronix.de>
Content-Language: en-US
X-Originating-IP: [10.43.161.85]
X-ClientProxiedBy: EX13D15UWB004.ant.amazon.com (10.43.161.61) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="windows-1252"; format="flowed"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 26.08.20 20:53, Thomas Gleixner wrote:
> =

> =

> On Wed, Aug 26 2020 at 20:30, Thomas Gleixner wrote:
>> And it does not solve the issue that we abuse orig_ax which Andy
>> mentioned.
> =

> Ha! After staring some more, it's not required at all, which is the most
> elegant solution.
> =

> The vector check is pointless in that condition because there is never a
> condition where an interrupt is moved from vector A to vector B on the
> same CPU.
> =

> That's a left over from the old allocation model which supported
> multi-cpu affinities, but this was removed as it just created trouble
> for no real benefit.
> =

> Today the effective affinity which is a single CPU out of the requested
> affinity. If an affinity mask change still contains the current target
> CPU then there is no move happening at all. It just stays on that vector
> on that CPU.
> =

> Thanks,
> =

>          tglx
> ---
> =

> --- a/arch/x86/kernel/apic/vector.c
> +++ b/arch/x86/kernel/apic/vector.c
> @@ -909,7 +909,7 @@ void send_cleanup_vector(struct irq_cfg
>                  __send_cleanup_vector(apicd);
>   }
> =

> -static void __irq_complete_move(struct irq_cfg *cfg, unsigned vector)
> +void irq_complete_move(struct irq_cfg *cfg)
>   {
>          struct apic_chip_data *apicd;
> =

> @@ -917,15 +917,10 @@ static void __irq_complete_move(struct i
>          if (likely(!apicd->move_in_progress))
>                  return;
> =

> -       if (vector =3D=3D apicd->vector && apicd->cpu =3D=3D smp_processo=
r_id())
> +       if (apicd->cpu =3D=3D smp_processor_id())
>                  __send_cleanup_vector(apicd);
>   }
> =

> -void irq_complete_move(struct irq_cfg *cfg)
> -{
> -       __irq_complete_move(cfg, ~get_irq_regs()->orig_ax);
> -}
> -
>   /*
>    * Called from fixup_irqs() with @desc->lock held and interrupts disabl=
ed.
>    */
> =



As expected, this also fixes the issue at hand. Do you want to send a =

real patch? :)

Tested-by: Alexander Graf <graf@amazon.com>


Alex



Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



