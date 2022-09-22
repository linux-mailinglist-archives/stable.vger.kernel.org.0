Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FF505E5D40
	for <lists+stable@lfdr.de>; Thu, 22 Sep 2022 10:18:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230213AbiIVISC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Sep 2022 04:18:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230220AbiIVIR4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Sep 2022 04:17:56 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC503CD1F6;
        Thu, 22 Sep 2022 01:17:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=qFznKR8LE1hs5qx50v8ZXbR+2FR7aIXxVNAOIFHaJP0=; b=YrrcmJKNHKRAJseBmsEUuL5P3G
        tfTSPLqLeBO5/WHziL3uhgDlFMhOTjewoCtJnvnm6bdXdgbH0xr1d+fTXzDrom99AjhX+LT0V+AcL
        0xZC/tXBVWZmm+0O3PAC+Piucm3c27rkwOYeiRXVsa9gIxoL0JcOI5iVr0/uHa28/Gtovc3QLM/Wp
        GWT1bUpF3x/83YfLRs4nZW9i6azPMdGfQy+gNAoBsr/RQ2jBi7V7R9+vBfo4jt+qm+mq9apy5OORX
        7RBPsus6LHbfNubhkk64o8Xtw+Y1YCjdrXjA3mq5T5NCoDdGA+4a4T2bJHHrU8T1vxXguuxsEXk4I
        iOuArs4g==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1obHOP-006s1C-U4; Thu, 22 Sep 2022 08:17:10 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 8C4413001FD;
        Thu, 22 Sep 2022 10:17:05 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 3A529200FBDFB; Thu, 22 Sep 2022 10:17:05 +0200 (CEST)
Date:   Thu, 22 Sep 2022 10:17:05 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Borislav Petkov <bp@alien8.de>
Cc:     K Prateek Nayak <kprateek.nayak@amd.com>,
        linux-kernel@vger.kernel.org, rafael@kernel.org, lenb@kernel.org,
        linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org,
        dave.hansen@linux.intel.com, tglx@linutronix.de, andi@lisas.de,
        puwen@hygon.cn, mario.limonciello@amd.com, rui.zhang@intel.com,
        gpiccoli@igalia.com, daniel.lezcano@linaro.org,
        ananth.narayan@amd.com, gautham.shenoy@amd.com,
        Calvin Ong <calvin.ong@amd.com>, stable@vger.kernel.org,
        regressions@lists.linux.dev
Subject: Re: [PATCH] ACPI: processor_idle: Skip dummy wait for processors
 based on the Zen microarchitecture
Message-ID: <YywaAcTdLSuDlRfl@hirez.programming.kicks-ass.net>
References: <20220921063638.2489-1-kprateek.nayak@amd.com>
 <YysnE8rcZAOOj28A@hirez.programming.kicks-ass.net>
 <YytqfVUCWfv0XyZO@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YytqfVUCWfv0XyZO@zn.tnic>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 21, 2022 at 09:48:13PM +0200, Borislav Petkov wrote:
> On Wed, Sep 21, 2022 at 05:00:35PM +0200, Peter Zijlstra wrote:
> > On Wed, Sep 21, 2022 at 12:06:38PM +0530, K Prateek Nayak wrote:
> > > Processors based on the Zen microarchitecture support IOPORT based deeper
> > > C-states. 
> > 
> > I've just gotta ask; why the heck are you using IO port based idle
> > states in 2022 ?!?! You have have MWAIT, right?
> 
> They have both. And both is Intel technology. And as I'm sure you
> know AMD can't do their own thing - they kinda have to follow Intel.
> Unfortunately.
> 
> Are you saying modern Intel chipsets don't do IO-based C-states anymore?

I've no idea what they do, but Linux exclusively uses MWAIT on Intel as
per intel_idle.c.

MWAIT also cuts down on IPIs because it wakes from the TIF write.

