Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F9542539DC
	for <lists+stable@lfdr.de>; Wed, 26 Aug 2020 23:37:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726753AbgHZVhI convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 26 Aug 2020 17:37:08 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:22618 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726783AbgHZVhH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Aug 2020 17:37:07 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-161-enTojJ1dOhq1TVkyyVBsDg-1; Wed, 26 Aug 2020 22:37:01 +0100
X-MC-Unique: enTojJ1dOhq1TVkyyVBsDg-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Wed, 26 Aug 2020 22:37:00 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Wed, 26 Aug 2020 22:37:00 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Thomas Gleixner' <tglx@linutronix.de>,
        Alexander Graf <graf@amazon.com>, X86 ML <x86@kernel.org>
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
        "Herrenschmidt, Benjamin" <benh@amazon.com>,
        "robketr@amazon.de" <robketr@amazon.de>,
        "amos@scylladb.com" <amos@scylladb.com>,
        Brian Gerst <brgerst@gmail.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Alex bykov" <alex.bykov@scylladb.com>
Subject: RE: x86/irq: Unbreak interrupt affinity setting
Thread-Topic: x86/irq: Unbreak interrupt affinity setting
Thread-Index: AQHWe+aKb+AhwM2rPkq6/MK3Hcp5nKlK5iEA
Date:   Wed, 26 Aug 2020 21:37:00 +0000
Message-ID: <db3e28b59d404f55aff83120c077d6f6@AcuMS.aculab.com>
References: <20200826115357.3049-1-graf@amazon.com>
 <87k0xlv5w5.fsf@nanos.tec.linutronix.de>
 <fd87a87d-7d8a-9959-6c81-f49003a43c21@amazon.com>
 <87blixuuny.fsf@nanos.tec.linutronix.de>
 <873649utm4.fsf@nanos.tec.linutronix.de>
 <87wo1ltaxz.fsf@nanos.tec.linutronix.de>
In-Reply-To: <87wo1ltaxz.fsf@nanos.tec.linutronix.de>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0.001
X-Mimecast-Originator: aculab.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner
> Sent: 26 August 2020 21:22
...
> Moving interrupts on x86 happens in several steps. A new vector on a
> different CPU is allocated and the relevant interrupt source is
> reprogrammed to that. But that's racy and there might be an interrupt
> already in flight to the old vector. So the old vector is preserved until
> the first interrupt arrives on the new vector and the new target CPU. Once
> that happens the old vector is cleaned up, but this cleanup still depends
> on the vector number being stored in pt_regs::orig_ax, which is now -1.

I suspect that it is much more 'racy' than that for PCI-X interrupts.
On the hardware side there is an interrupt disable bit, and address
and a value.
To raise an interrupt the hardware must write the value to the address.

If the cpu needs to move an interrupt both the address and value
need changing, but the cpu wont write the address and value using
the same TLP, so the hardware could potentially write a value to
the wrong address.
Worse than that, the hardware could easily only look at the address
and value in the clocks after checking the interrupt is enabled.
So masking the interrupt immediately prior to changing the vector
info may not be enough.

It is likely that a read-back of the mask before updating the vector
is enough.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

