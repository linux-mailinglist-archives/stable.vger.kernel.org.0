Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE986FC0D
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 17:00:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726065AbfD3PAJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 11:00:09 -0400
Received: from sender4-pp-o95.zoho.com ([136.143.188.95]:25548 "EHLO
        sender4-pp-o95.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726050AbfD3PAJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Apr 2019 11:00:09 -0400
X-Greylist: delayed 1433 seconds by postgrey-1.27 at vger.kernel.org; Tue, 30 Apr 2019 11:00:08 EDT
ARC-Seal: i=1; a=rsa-sha256; t=1556636388; cv=none; 
        d=zoho.com; s=zohoarc; 
        b=ISc3FMBJUbN1BF6Y1R+xlonfL81WMeQaTCeQqCL+gJ6jyENdg9a5nHPDKrpTgOoNIJOQPeXhChGRNrRH7h2UmjJ3GuI6ZJ2dZSjdChPusM3jluARnUJn0noyrqufTHeGGIkeNX7d+BNpDuEOJODpK7BrhuuZ1ziwhQWOIot19J8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com; s=zohoarc; 
        t=1556636388; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:Reply-To:References:Subject:To:ARC-Authentication-Results; 
        bh=HMgaTitL8kvMn3jaf+g1LoViQSlseCLxkeWYshZFlZw=; 
        b=GK7sNuldSNQoordrips7yJaP+UyaFSBNWgiYHOJl7Pp5boWcj3iuw+d0cBbQ1s58J2mjVxhqTyVI51tBZrv6NFj82vgjGndXtM0NQgEyXWhuRQcnJ9Tx5XpcJzCTLIjSKBrIhP+KQRYjtQcr2NbsMNk4Sr1rDD1fOXrdd00WKQU=
ARC-Authentication-Results: i=1; mx.zoho.com;
        dkim=pass  header.i=zoho.com;
        spf=pass  smtp.mailfrom=strongbox8@zoho.com;
        dmarc=pass header.from=<strongbox8@zoho.com> header.from=<strongbox8@zoho.com>
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; 
  s=zapps768; d=zoho.com; 
  h=date:from:reply-to:to:cc:message-id:in-reply-to:references:subject:mime-version:content-type:user-agent; 
  b=FhyOH4QCF0LSpWvhxHOXEAR46OEeFG5PUjCvNOSU45Lr6TsCPIaiSz0kyOTUYaMwwdnjEbJ1KfHK
    iCEsCJvN/8XA7Ff+1iyMd2aDhZYm2Ch4Bi9E0IJUzf3o4lzAnmhk  
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1556636388;
        s=default; d=zoho.com; i=strongbox8@zoho.com;
        h=Date:From:Reply-To:To:Cc:Message-ID:In-Reply-To:References:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding;
        l=1925; bh=HMgaTitL8kvMn3jaf+g1LoViQSlseCLxkeWYshZFlZw=;
        b=GXRj6oFkafRfo0eRg0JPuYQ0x/OqLmv066mur4cdmvjSQZ/TlcaYpirXp5s+3L1l
        8yZcUSTV8xDWd47hplI/HVD1puSax0pfPE1gzRnblpdH4asfgeeh8gXs3SZ/RjPq4Xy
        8sf38xj8imtMVX8AhVkqqVQuI++L8LLQD8SQbrIs=
Received: from mail.zoho.com by mx.zohomail.com
        with SMTP id 1556636282842350.4909935898663; Tue, 30 Apr 2019 07:58:02 -0700 (PDT)
Received: from  [157.230.163.183] by mail.zoho.com
        with HTTP;Tue, 30 Apr 2019 07:58:02 -0700 (PDT)
Date:   Tue, 30 Apr 2019 22:58:02 +0800
From:   Perr Zhang <strongbox8@zoho.com>
Reply-To: strongbox8@zoho.com
To:     "Peter Zijlstra" <peterz@infradead.org>
Cc:     "pbonzini" <pbonzini@redhat.com>, "rkrcmar" <rkrcmar@redhat.com>,
        "tglx" <tglx@linutronix.de>, "stable" <stable@vger.kernel.org>,
        "mingo" <mingo@redhat.com>, "x86" <x86@kernel.org>,
        "kvm" <kvm@vger.kernel.org>,
        "linux-kernel" <linux-kernel@vger.kernel.org>
Message-ID: <16a6ec0afd8.10d96b0bf79755.8849251462286427289@zoho.com>
In-Reply-To: <20190430143201.GH2589@hirez.programming.kicks-ass.net>
References: <20190430142423.3393-1-strongbox8@zoho.com> <20190430143201.GH2589@hirez.programming.kicks-ass.net>
Subject: Re: [PATCH] KVM: x86: revert the order of calls in kvm_fast_pio()
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Priority: Medium
User-Agent: Zoho Mail
X-Mailer: Zoho Mail
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


 ---- On Tue, 30 Apr 2019 22:32:01 +0800 Peter Zijlstra <peterz@infradead.org> wrote ----
 > On Tue, Apr 30, 2019 at 10:24:23PM +0800, Perr Zhang wrote:
 > > In commit 45def77ebf79, the order of function calls in kvm_fast_pio()
 > > was changed. This causes that the vm(XP,and also XP's iso img) failed
 > > to boot. This doesn't happen with win10 or ubuntu.
 > > 
 > > After revert the order, the vm(XP) succeedes to boot. In addition, the
 > > change of calls's order of kvm_fast_pio() in commit 45def77ebf79 has no
 > > obvious reason.
 > 
 > This Changelog fails to explain why the order is important and equally
 > fails to inform the future reader of that code. So this very same thing
 > will happen again in 6 months time or thereabout.

 I'm not familiar with KVM,  don't know the particular reason.

 > 
 > > Fixes: 45def77ebf79 ("KVM: x86: update %rip after emulating IO")
 > > Cc: <stable@vger.kernel.org>
 > > Signed-off-by: Perr Zhang <strongbox8@zoho.com>
 > > ---
 > >  arch/x86/kvm/x86.c | 7 +++----
 > >  1 file changed, 3 insertions(+), 4 deletions(-)
 > > 
 > > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
 > > index a0d1fc80ac5a..248753cb94a1 100644
 > > --- a/arch/x86/kvm/x86.c
 > > +++ b/arch/x86/kvm/x86.c
 > > @@ -6610,13 +6610,12 @@ static int kvm_fast_pio_in(struct kvm_vcpu *vcpu, int size,
 > >  
 > >  int kvm_fast_pio(struct kvm_vcpu *vcpu, int size, unsigned short port, int in)
 > >  {
 > > -    int ret;
 > > +    int ret = kvm_skip_emulated_instruction(vcpu);
 > >  
 > >      if (in)
 > > -        ret = kvm_fast_pio_in(vcpu, size, port);
 > > +        return kvm_fast_pio_in(vcpu, size, port) && ret;
 > >      else
 > > -        ret = kvm_fast_pio_out(vcpu, size, port);
 > > -    return ret && kvm_skip_emulated_instruction(vcpu);
 > > +        return kvm_fast_pio_out(vcpu, size, port) && ret;
 > >  }
 > >  EXPORT_SYMBOL_GPL(kvm_fast_pio);
 > >  
 > > -- 
 > > 2.21.0
 > > 
 > > 
 > > 
 > 

