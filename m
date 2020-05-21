Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25E621DD272
	for <lists+stable@lfdr.de>; Thu, 21 May 2020 17:56:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729030AbgEUPzn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 May 2020 11:55:43 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:20530 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728825AbgEUPzn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 May 2020 11:55:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590076542;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RP0V13tfcBHFjiQL2Hum0eIuWeC/sr9fMRiGZyHGqdo=;
        b=ZbCe0UcFLFY4jMxEf/JnZqLOumwANtHGyBuh3T5DnWCNSpRPfmnBolFA0XJwTBp6GCNeci
        oXeZKqiBwuwDBth2ycWUs8VOW4aVN/l9PuHCF2Rpo0yDLk4zbD2Nj02jvnJc5A97EvIRdp
        H2wJHTqlGgCLrpjALVy3nbnkQ5xEujY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-394-xpwtyieaP4mfkdsladJA_w-1; Thu, 21 May 2020 11:55:38 -0400
X-MC-Unique: xpwtyieaP4mfkdsladJA_w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 04D52107ACCD;
        Thu, 21 May 2020 15:55:37 +0000 (UTC)
Received: from horse.redhat.com (ovpn-116-233.rdu2.redhat.com [10.10.116.233])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D40A95C1B0;
        Thu, 21 May 2020 15:55:36 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id 4354822036E; Thu, 21 May 2020 11:55:36 -0400 (EDT)
Date:   Thu, 21 May 2020 11:55:36 -0400
From:   Vivek Goyal <vgoyal@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Andy Lutomirski <luto@amacapital.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        kvm list <kvm@vger.kernel.org>, stable <stable@vger.kernel.org>
Subject: Re: [PATCH v2] x86/kvm: Disable KVM_ASYNC_PF_SEND_ALWAYS
Message-ID: <20200521155536.GA38602@redhat.com>
References: <87eeszjbe6.fsf@nanos.tec.linutronix.de>
 <B85606B0-71B5-4B7D-A892-293CB9C1B434@amacapital.net>
 <2776fced-54c2-40eb-7921-1c68236c7f70@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2776fced-54c2-40eb-7921-1c68236c7f70@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 08, 2020 at 12:07:22AM +0200, Paolo Bonzini wrote:
> On 07/04/20 23:41, Andy Lutomirski wrote:
> > 2. Access to bad memory results in #MC.  Sure, #MC is a turd, but
> > it’s an *architectural* turd. By all means, have a nice simple PV
> > mechanism to tell the #MC code exactly what went wrong, but keep the
> > overall flow the same as in the native case.
> > 
> > I think I like #2 much better. It has another nice effect: a good
> > implementation will serve as a way to exercise the #MC code without
> > needing to muck with EINJ or with whatever magic Tony uses. The
> > average kernel developer does not have access to a box with testable
> > memory failure reporting.
> 
> I prefer #VE, but I can see how #MC has some appeal. 

I have spent some time looking at #MC and trying to figure out if we
can use it. I have encountered couple of issues.

- Uncorrected Action required machine checks are generated when poison
  is consumed. So typically all kernel code and exception handling is
  assuming MCE can be encoutered synchronously only on load and not
  store. stores don't generate MCE (atleast not AR one, IIUC). If we were
  to use #MC, we will need to generate it on store as well and then that
  requires changing assumptions in kernel which assumes stores can't
  generate #MC (Change all copy_to_user()/copy_from_user() and friends)

- Machine check is generated for poisoned memory. And in this it is not
  exaclty poisoning. It feels like as if memory has gone missing. And
  failure might be temporary that is if file is truncated again to extend,
  then next load/store to same memory location will work just fine. My
  understanding is that sending #MC will mark that page poisoned and
  it will sort of become permanent failure. 

I am less concerned about point 2, but not sure how to get past the
first issue.

Thanks
Vivek

