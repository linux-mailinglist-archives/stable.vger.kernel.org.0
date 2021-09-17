Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DD4640F4E2
	for <lists+stable@lfdr.de>; Fri, 17 Sep 2021 11:36:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241089AbhIQJhx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Sep 2021 05:37:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241256AbhIQJhu (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Sep 2021 05:37:50 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CBE7C061764;
        Fri, 17 Sep 2021 02:36:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=p4JKQZLvY28YAWtmOrT5h9vdEtIffVYjwaqM8dQlSuk=; b=QQ1aRlrpBKnxNb39uc5Qg3Q7Mr
        mtZkjFZ5HTcmaUZIpBhEXzPz8Jnq6weWSkgUpL2ZOUKilOgIzFGCCQ2JsASe/UWeepzzTAjnuDSq/
        d6jWrwALsAtBH8rcEhZ+gYCxsXuVXFUGJOMOaY7EEWS0badAoBtcsot+9NjjB9RUWHxdKrXSpyoWO
        SsUpBM5dYmSkstVKdjvPRDnp/KwGbaSrzJz1ye5fIQ+BmZREMveigINbT/jf2nETmaC4DVkZTgQty
        TBmtDdFa01zzoYOtyQRMOP/09HS+XUE9of6QOoTBGDhK6xQ/sDImSguyhQk0jy0WfDEywITFiV7p3
        fsnyYQIg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mRAGX-00070u-2K; Fri, 17 Sep 2021 09:34:59 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 1C000300260;
        Fri, 17 Sep 2021 11:34:40 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id EF47A2083B0E0; Fri, 17 Sep 2021 11:34:39 +0200 (CEST)
Date:   Fri, 17 Sep 2021 11:34:39 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>, x86@kernel.org,
        jose.souza@intel.com, hpa@zytor.com, bp@alien8.de,
        mingo@redhat.com, tglx@linutronix.de, kai.heng.feng@canonical.com,
        bhelgaas@google.com, linux-pci@vger.kernel.org, rudolph@fb.com,
        xapienz@fb.com, bmilton@fb.com, stable@vger.kernel.org
Subject: Re: [PATCH] x86/intel: Disable HPET on another Intel Coffee Lake
 platform
Message-ID: <YURhL33YyXRMkdC6@hirez.programming.kicks-ass.net>
References: <20210916131739.1260552-1-kuba@kernel.org>
 <20210916150707.GA1611532@bjorn-Precision-5520>
 <YURb1bzc3L4gNI9Q@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YURb1bzc3L4gNI9Q@hirez.programming.kicks-ass.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 17, 2021 at 11:11:49AM +0200, Peter Zijlstra wrote:
> On Thu, Sep 16, 2021 at 10:07:07AM -0500, Bjorn Helgaas wrote:
> > This seems to be an ongoing issue, not just a point defect in a single
> > product, and I really hate the onesy-twosy nature of this.  Is there
> > really no way to detect this issue automatically or fix whatever Linux
> > bug makes us trip over this?  I am no clock expert, so I have
> > absolutely no idea whether this is possible.
> 
> X86 is gifted with the grant total of _0_ reliable clocks. Given no
> accurate time, it is impossible to tell which one of them is broken
> worst. Although I suppose we could attempt to synchronize against the
> PMU or MPERF..
> 
> We could possibly disable the tsc watchdog for
> X86_FEATURE_TSC_KNOWN_FREQ && X86_FEATURE_TSC_ADJUST I suppose.
> 
> And then have people with 'creative' BIOS get to keep the pieces.

Alternatively, we can change what the TSC watchdog does for
X86_FEATURE_TSC_ADJUST machines. Instead of checking time against HPET
it can check if TSC_ADJUST changes. That should make it more resillient
vs HPET time itself being off.
