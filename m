Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2BE32540D4
	for <lists+stable@lfdr.de>; Thu, 27 Aug 2020 10:28:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728213AbgH0I2w convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Thu, 27 Aug 2020 04:28:52 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:32370 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728068AbgH0I2u (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Aug 2020 04:28:50 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-114-cyAKyHkbOAOvWmpU6WpmIQ-1; Thu, 27 Aug 2020 09:28:46 +0100
X-MC-Unique: cyAKyHkbOAOvWmpU6WpmIQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Thu, 27 Aug 2020 09:28:45 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Thu, 27 Aug 2020 09:28:45 +0100
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
Thread-Index: AQHWe+aKb+AhwM2rPkq6/MK3Hcp5nKlK5iEA///7/wCAALxiUA==
Date:   Thu, 27 Aug 2020 08:28:45 +0000
Message-ID: <620d67af76554a558061c8df5e2cb038@AcuMS.aculab.com>
References: <20200826115357.3049-1-graf@amazon.com>
 <87k0xlv5w5.fsf@nanos.tec.linutronix.de>
 <fd87a87d-7d8a-9959-6c81-f49003a43c21@amazon.com>
 <87blixuuny.fsf@nanos.tec.linutronix.de>
 <873649utm4.fsf@nanos.tec.linutronix.de>
 <87wo1ltaxz.fsf@nanos.tec.linutronix.de>
 <db3e28b59d404f55aff83120c077d6f6@AcuMS.aculab.com>
 <87ft89kqmd.fsf@nanos.tec.linutronix.de>
In-Reply-To: <87ft89kqmd.fsf@nanos.tec.linutronix.de>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0.002
X-Mimecast-Originator: aculab.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner
> Sent: 26 August 2020 23:08
...
> > I suspect that it is much more 'racy' than that for PCI-X interrupts.
> > On the hardware side there is an interrupt disable bit, and address
> > and a value.
> > To raise an interrupt the hardware must write the value to the
> > address.
> 
> Really?

Yep, anyone with write access to the msi-x table can get the device
to write to any physical location (allowed by any IOMMU) instead of
raising an interrupt.

> > If the cpu needs to move an interrupt both the address and value
> > need changing, but the cpu wont write the address and value using
> > the same TLP, so the hardware could potentially write a value to
> > the wrong address.
> 
> Now I understand finally why msi_set_affinity() in x86 has to be so
> convoluted.

Updating the registers should be much the same on all architectures.
I probably should have looked at what msi_set_affinity() does before
deciding which order the fpga logic should read the four 32bit registers
in; but they are read in increasing order - so enable bit last.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

