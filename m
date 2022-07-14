Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BD305754B3
	for <lists+stable@lfdr.de>; Thu, 14 Jul 2022 20:12:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240365AbiGNSL6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jul 2022 14:11:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232432AbiGNSL6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jul 2022 14:11:58 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AD79DE1;
        Thu, 14 Jul 2022 11:11:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=4V6a/KJO4cJjMe509hS1p2ekMNPrFvs9A9TzOLsThG8=; b=JgROHQwK3u5dOQzc0AnQMCNEn7
        WNh37RWPK/HI/+khFIX2usixbCQC3CymYsWAlCoh+A1P80WTI/GUGX2g1/PXbTiftSvY0vAcY02dY
        YOhfPhEKAAAZxtVRs7kJNP9+DuGCexocuCgttiPMEq9tvT/w2MTGa9GDn73/7CxDbAvFpkOV4DkWY
        NDKmHFjx99rrZLckiwlDj84euvLLv6nb5O0Xcn2hfffEMPcPLrqDrpNK4e+niDB+wSfldVjo/OjwF
        UQg6lAOODr2sEUIZpHVbO/vtY8X43A0hi8eAwB67fKgx9WWSbG/k4xqA/CNFPofp/bxh7SUTQ+1sa
        83lne+sg==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=worktop.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oC3JI-003uAd-SE; Thu, 14 Jul 2022 18:11:37 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id 8FEC3980185; Thu, 14 Jul 2022 20:11:29 +0200 (CEST)
Date:   Thu, 14 Jul 2022 20:11:29 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Josh Poimboeuf <jpoimboe@kernel.org>
Cc:     Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        antonio.gomez.iglesias@linux.intel.com
Subject: Re: [PATCH] x86/bugs: Switch to "auto" when "ibrs" selected on
 Enhanced IBRS parts
Message-ID: <YtBcUWIqJjUdWtro@worktop.programming.kicks-ass.net>
References: <0456b35fb9ef957d9a9138e0913fb1a3fd445dff.1657747493.git.pawan.kumar.gupta@linux.intel.com>
 <Ys/7RiC9Z++38tzq@quatroqueijos>
 <YtABEwRnWrJyIKTY@worktop.programming.kicks-ass.net>
 <20220714160106.c6efowo6ptsu72ne@treble>
 <YtBMZMaOnA8g8m0a@worktop.programming.kicks-ass.net>
 <20220714173814.p5kdyimu6ho7zjt5@treble>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220714173814.p5kdyimu6ho7zjt5@treble>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 14, 2022 at 10:38:14AM -0700, Josh Poimboeuf wrote:
> On Thu, Jul 14, 2022 at 07:03:32PM +0200, Peter Zijlstra wrote:
> > On Thu, Jul 14, 2022 at 09:01:06AM -0700, Josh Poimboeuf wrote:
> > 
> > > > Yeah this; if the user asks for IBRS, we should give him IBRS. I hate
> > > > the 'I know better, let me change that for you' mentality.
> > > 
> > > eIBRS CPUs don't even have legacy IBRS so I don't see how this is even
> > > possible.
> > 
> > You can still WRMSR a lot on them. Might not make sense but it 'works'.
> 
> Even in Intel documentation, eIBRS is often referred to as IBRS. It
> wouldn't be surprising for a user to consider spectre_v2=ibrs to mean
> "use eIBRS".
> 
> I'm pretty sure there's nobody out there that wants spectre_v2=ibrs to
> mean "make it slower and possibly less secure because it's being used
> contrary to the spec".

Then make it print a big honking warning.

Most people will either use auto or off, the very few people that force
an option get what they ask for, not something else.

Like said upthread, it allows testing the code-paths at the very least.
