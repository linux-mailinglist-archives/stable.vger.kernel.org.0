Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B73F02536B0
	for <lists+stable@lfdr.de>; Wed, 26 Aug 2020 20:22:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726753AbgHZSWW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Aug 2020 14:22:22 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:5846 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726241AbgHZSWV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Aug 2020 14:22:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1598466140; x=1630002140;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:mime-version:content-transfer-encoding;
  bh=4u2E+0R69kRraLKpaxVrEycUDCu2mmKu3H7Kl7FDJbw=;
  b=Cq+RfC+OJu17N24QRpIepqNIuvpY6xukI+8H4pNkIHJRzs8i0LigJ8wd
   GAqGwBjcv9fty3wNGOwfTN4293rpLJj++th5eDqXI3PSSkeJDI6PkB8EN
   haf8Qp9wBhIt6RwyF5h0ZS50YHkepJmBGqtiWZwYkmbconL33YN6+3e3g
   Y=;
X-IronPort-AV: E=Sophos;i="5.76,356,1592870400"; 
   d="scan'208";a="51617283"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2b-859fe132.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 26 Aug 2020 18:22:12 +0000
Received: from EX13MTAUWC001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2b-859fe132.us-west-2.amazon.com (Postfix) with ESMTPS id B4572222269;
        Wed, 26 Aug 2020 18:22:10 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 26 Aug 2020 18:22:10 +0000
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 26 Aug 2020 18:22:09 +0000
Received: from EX13D20UWC001.ant.amazon.com ([10.43.162.244]) by
 EX13D20UWC001.ant.amazon.com ([10.43.162.244]) with mapi id 15.00.1497.006;
 Wed, 26 Aug 2020 18:22:09 +0000
From:   "Graf (AWS), Alexander" <graf@amazon.de>
To:     Andy Lutomirski <luto@kernel.org>
CC:     Thomas Gleixner <tglx@linutronix.de>, X86 ML <x86@kernel.org>,
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
        "Joel Fernandes" <joel@joelfernandes.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Will Deacon <will@kernel.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Wei Liu <wei.liu@kernel.org>,
        Michael Kelley <mikelley@microsoft.com>,
        Jason Chen CJ <jason.cj.chen@intel.com>,
        Zhao Yakui <yakui.zhao@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "Avi Kivity" <avi@scylladb.com>,
        "Herrenschmidt, Benjamin" <benh@amazon.com>,
        "robketr@amazon.de" <robketr@amazon.de>,
        Amos Kong <amos@scylladb.com>,
        "Brian Gerst" <brgerst@gmail.com>, stable <stable@vger.kernel.org>
Subject: Re: [PATCH] x86/irq: Preserve vector in orig_ax for APIC code
Thread-Topic: [PATCH] x86/irq: Preserve vector in orig_ax for APIC code
Thread-Index: AQHWe9XPb47wB6d5z0uF8BBPksZN1Q==
Date:   Wed, 26 Aug 2020 18:22:09 +0000
Message-ID: <E79B5023-DF83-4E3A-8F33-D2DEB31463F9@amazon.de>
References: <20200826115357.3049-1-graf@amazon.com>
 <87k0xlv5w5.fsf@nanos.tec.linutronix.de>
 <CALCETrX-8a61k03+XJop=k11-TkE+7JOiGTH=81sHXPmXsA+Tw@mail.gmail.com>
 <87eentuwn8.fsf@nanos.tec.linutronix.de>,<CALCETrWG9UZUuygcTtYi51UFnaENW8Cv8xhuMXSZprP+_dQrFA@mail.gmail.com>
In-Reply-To: <CALCETrWG9UZUuygcTtYi51UFnaENW8Cv8xhuMXSZprP+_dQrFA@mail.gmail.com>
Accept-Language: en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> Am 26.08.2020 um 20:03 schrieb Andy Lutomirski <luto@kernel.org>:
> =

>> On Wed, Aug 26, 2020 at 10:47 AM Thomas Gleixner <tglx@linutronix.de> wr=
ote:
>> =

>> Andy,
>> =

>>> On Wed, Aug 26 2020 at 09:13, Andy Lutomirski wrote:
>>> On Wed, Aug 26, 2020 at 7:27 AM Thomas Gleixner <tglx@linutronix.de> wr=
ote:
>>>> The below nasty hack cures it, but I hate it with a passion. I'll look
>>>> deeper for a sane variant.
>>>> =

>>> Fundamentally, the way we overload orig_ax is problematic.  I have a
>>> half-written series to improve it, but my series is broken.  I think
>>> it's fixable, though.
>>> =

>>> First is this patch to use some __csh bits to indicate the entry type.
>>> As far as I know, this patch is correct:
>>> =

>>> https://git.kernel.org/pub/scm/linux/kernel/git/luto/linux.git/commit/?=
h=3Dx86/entry&id=3Ddfff54208072a27909ae97ebce644c251a233ff2
>> =

>> Yes, that looks about right.
>> =

>>> Then I wrote this incorrect patch:
>>> =

>>> https://git.kernel.org/pub/scm/linux/kernel/git/luto/linux.git/commit/?=
h=3Dx86/entry&id=3D3a5087acb8a2cc1e88b1a55fa36c2f8bef370572
>>> =

>>> That one is wrong because the orig_ax wreckage seems to have leaked
>>> into user ABI -- user programs think that orig_ax has certain
>>> semantics on user-visible entries.
>> =

>> Yes, orig_ax is pretty much user ABI for a very long time.
>> =

>>> But I think that the problem in this thread could be fixed quite
>>> nicely by the first patch, plus a new CS_ENTRY_IRQ and allocating
>>> eight bits of __csh to store the vector.  Then we could read out the
>>> vector.
>> =

>> That works. Alternatively I can just store the vector in the irq
>> descriptor itself. That's trivial enough and can be done completely in C
>> independent of the stuff above.
> =

> The latter sounds quite sensible to me.  It does seem vaguely
> ridiculous to be trying to fish the vector out of pt_regs in the APIC
> code.

I like that option much better than the orig_ax hacks. Is this going to be =
something useable enough for stable?

Also, Thomas, will you have a look at moving the vector info? If so, I'd ho=
ld still on this patch for a bit.

Alex




Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



