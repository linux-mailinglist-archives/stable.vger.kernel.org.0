Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FDEA253A1B
	for <lists+stable@lfdr.de>; Thu, 27 Aug 2020 00:08:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726939AbgHZWH7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Aug 2020 18:07:59 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:33814 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726836AbgHZWH6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Aug 2020 18:07:58 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1598479675;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4utsE2QnYLTwl7fFsiKLdj2uLDQ8VVZxXiuVQb2kEpw=;
        b=sRBRcIPcojSh91o3SVSNtR9BZjT/ERarAeteZurQB8clmaozva95uXsZnerPHQIaUJ2bCf
        2V4LkENb+OOoqPHwDREL5YNcGUyY+O4JE9iu7ReWTkWJMDW+bCpWEa7Kxtrp6mAIxNvWDK
        ZXCAIzJz6ZZPVVJS1hIiPo5ryCeVOSUc105c72syPlRg2KyAIBO87N5nhtx9Duega2fnmX
        qFLWSY8o0h+0OV8bUdMloYebDCRGlIyMGkjeHPlsvNXg0qcvPRTKPFYzOg1VsPm4hzAHP7
        5+Zyk7BVUMHvNsg3oQVwTI6XsAtb5yYknFQ5eTJHb1k+tJb1x11zFz44ScF7dw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1598479675;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4utsE2QnYLTwl7fFsiKLdj2uLDQ8VVZxXiuVQb2kEpw=;
        b=XlvoNOGDvY6g0zKRImvQ46z5lE62vPkFVn4F20bQCs9QuFc75x28/28A2X0OXjQbJLMT2o
        jMU+gEVelqOOzDAw==
To:     David Laight <David.Laight@ACULAB.COM>,
        Alexander Graf <graf@amazon.com>, X86 ML <x86@kernel.org>
Cc:     Andy Lutomirski <luto@kernel.org>,
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
        Will Deacon <will@kernel.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Wei Liu <wei.liu@kernel.org>,
        Michael Kelley <mikelley@microsoft.com>,
        Jason Chen CJ <jason.cj.chen@intel.com>,
        Zhao Yakui <yakui.zhao@intel.com>,
        "Peter Zijlstra \(Intel\)" <peterz@infradead.org>,
        Avi Kivity <avi@scylladb.com>,
        "Herrenschmidt\, Benjamin" <benh@amazon.com>,
        "robketr\@amazon.de" <robketr@amazon.de>,
        "amos\@scylladb.com" <amos@scylladb.com>,
        Brian Gerst <brgerst@gmail.com>,
        "stable\@vger.kernel.org" <stable@vger.kernel.org>,
        Alex bykov <alex.bykov@scylladb.com>
Subject: RE: x86/irq: Unbreak interrupt affinity setting
In-Reply-To: <db3e28b59d404f55aff83120c077d6f6@AcuMS.aculab.com>
References: <20200826115357.3049-1-graf@amazon.com> <87k0xlv5w5.fsf@nanos.tec.linutronix.de> <fd87a87d-7d8a-9959-6c81-f49003a43c21@amazon.com> <87blixuuny.fsf@nanos.tec.linutronix.de> <873649utm4.fsf@nanos.tec.linutronix.de> <87wo1ltaxz.fsf@nanos.tec.linutronix.de> <db3e28b59d404f55aff83120c077d6f6@AcuMS.aculab.com>
Date:   Thu, 27 Aug 2020 00:07:54 +0200
Message-ID: <87ft89kqmd.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 26 2020 at 21:37, David Laight wrote:
> From: Thomas Gleixner
>> Sent: 26 August 2020 21:22
> ...
>> Moving interrupts on x86 happens in several steps. A new vector on a
>> different CPU is allocated and the relevant interrupt source is
>> reprogrammed to that. But that's racy and there might be an interrupt
>> already in flight to the old vector. So the old vector is preserved until
>> the first interrupt arrives on the new vector and the new target CPU. Once
>> that happens the old vector is cleaned up, but this cleanup still depends
>> on the vector number being stored in pt_regs::orig_ax, which is now -1.
>
> I suspect that it is much more 'racy' than that for PCI-X interrupts.
> On the hardware side there is an interrupt disable bit, and address
> and a value.
> To raise an interrupt the hardware must write the value to the
> address.

Really?

> If the cpu needs to move an interrupt both the address and value
> need changing, but the cpu wont write the address and value using
> the same TLP, so the hardware could potentially write a value to
> the wrong address.

Now I understand finally why msi_set_affinity() in x86 has to be so
convoluted.

Thanks a lot for the enlightment!

       tglx
