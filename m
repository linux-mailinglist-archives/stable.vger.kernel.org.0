Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EA5E253799
	for <lists+stable@lfdr.de>; Wed, 26 Aug 2020 20:53:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726836AbgHZSxL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Aug 2020 14:53:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726809AbgHZSxK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Aug 2020 14:53:10 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45787C061574;
        Wed, 26 Aug 2020 11:53:10 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1598467987;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NgmNT6e9V972BbRaGJi5LACq7q2882bivAeuxcsKlO8=;
        b=txtxpwlTPw0jyfbR6Wiwaf/MnCH0LQaemD8NHmqb8jwV/n8e83wQGwVlZN/5YtETRzcuXZ
        zobHrmUVBsKUeqClsNcZNmVELkb/AuBn1dxtoGbmOLQ4e/pEIdkCCz/HvMI2JdHzeXXaRk
        v3s3C5xGpuocoMwRt9poUfu7wx9CWkWafhdufLtxK39PD37gTIKDINn6oNUHE8F41h+vjF
        b4Wy/DGWk0XZ2CwKzpxY5q+cZ5XtnbsEaSSnVPihfmseDcfrfBV8yTzB6jdfj0fQZL82T4
        8ybbClqKwpsxDKncqYPxaQ1qjT8AZ/PAJYVxMnM3nt8hkLNbgZjjI+vzdsbMog==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1598467987;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NgmNT6e9V972BbRaGJi5LACq7q2882bivAeuxcsKlO8=;
        b=7/Vp+Kz8ctFKwZep8/fQNgT+OtdZU27B9OYyNQ/p8MeJLMRs8EHZV/AafwciXjGV88amMB
        22AAeVUm1HAt9kDA==
To:     Alexander Graf <graf@amazon.com>, X86 ML <x86@kernel.org>
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
        "Herrenschmidt\, Benjamin" <benh@amazon.com>, robketr@amazon.de,
        amos@scylladb.com, Brian Gerst <brgerst@gmail.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] x86/irq: Preserve vector in orig_ax for APIC code
In-Reply-To: <87blixuuny.fsf@nanos.tec.linutronix.de>
References: <20200826115357.3049-1-graf@amazon.com> <87k0xlv5w5.fsf@nanos.tec.linutronix.de> <fd87a87d-7d8a-9959-6c81-f49003a43c21@amazon.com> <87blixuuny.fsf@nanos.tec.linutronix.de>
Date:   Wed, 26 Aug 2020 20:53:07 +0200
Message-ID: <873649utm4.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 26 2020 at 20:30, Thomas Gleixner wrote:
> And it does not solve the issue that we abuse orig_ax which Andy
> mentioned.

Ha! After staring some more, it's not required at all, which is the most
elegant solution.

The vector check is pointless in that condition because there is never a
condition where an interrupt is moved from vector A to vector B on the
same CPU.

That's a left over from the old allocation model which supported
multi-cpu affinities, but this was removed as it just created trouble
for no real benefit.

Today the effective affinity which is a single CPU out of the requested
affinity. If an affinity mask change still contains the current target
CPU then there is no move happening at all. It just stays on that vector
on that CPU.

Thanks,

        tglx
---       

--- a/arch/x86/kernel/apic/vector.c
+++ b/arch/x86/kernel/apic/vector.c
@@ -909,7 +909,7 @@ void send_cleanup_vector(struct irq_cfg
 		__send_cleanup_vector(apicd);
 }
 
-static void __irq_complete_move(struct irq_cfg *cfg, unsigned vector)
+void irq_complete_move(struct irq_cfg *cfg)
 {
 	struct apic_chip_data *apicd;
 
@@ -917,15 +917,10 @@ static void __irq_complete_move(struct i
 	if (likely(!apicd->move_in_progress))
 		return;
 
-	if (vector == apicd->vector && apicd->cpu == smp_processor_id())
+	if (apicd->cpu == smp_processor_id())
 		__send_cleanup_vector(apicd);
 }
 
-void irq_complete_move(struct irq_cfg *cfg)
-{
-	__irq_complete_move(cfg, ~get_irq_regs()->orig_ax);
-}
-
 /*
  * Called from fixup_irqs() with @desc->lock held and interrupts disabled.
  */
