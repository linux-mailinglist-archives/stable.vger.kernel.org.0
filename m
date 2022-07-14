Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A200A5753B4
	for <lists+stable@lfdr.de>; Thu, 14 Jul 2022 19:03:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232527AbiGNRDx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jul 2022 13:03:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240133AbiGNRDv (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jul 2022 13:03:51 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66BE2101D6;
        Thu, 14 Jul 2022 10:03:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=oRwEr6A1IVEPWhQvPx2mv6RXTE8efFlDv1Ac9Jh+3F0=; b=W8cAbI9PJJ2ZuOKisQBeoqGNwX
        S49wbRFE4KYRcnaaELLQA+KryloAn8zV5zk+qE7uRMb7hM9vXr3PVXcRuwviUc5UWZzjY6OzAkWU2
        ujKZZsakaWz3GQFF0k5R7h9ORar+A/QBhuQHlPXAWQ+q2mqI5/cEK8mecOpcmj2R7v/7DGyNxosGB
        t1DXcjK1UPWyBJR4R2wVmyEVGrx9KLXnFww+d51IdyvO/rSTlMW4Ra/vuRmvRm1r2Tr1/AU0fXrqd
        R5sUiIts3pMitsoBB/u68f/6BZenuUeu9dPb7J1VC1ko+igtM+mKWbsipGB/D7kn4VAB2KYsSRWxD
        5mJ5V/5g==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=worktop.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oC2FS-003t8G-Jo; Thu, 14 Jul 2022 17:03:35 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id 4E297980185; Thu, 14 Jul 2022 19:03:32 +0200 (CEST)
Date:   Thu, 14 Jul 2022 19:03:32 +0200
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
Message-ID: <YtBMZMaOnA8g8m0a@worktop.programming.kicks-ass.net>
References: <0456b35fb9ef957d9a9138e0913fb1a3fd445dff.1657747493.git.pawan.kumar.gupta@linux.intel.com>
 <Ys/7RiC9Z++38tzq@quatroqueijos>
 <YtABEwRnWrJyIKTY@worktop.programming.kicks-ass.net>
 <20220714160106.c6efowo6ptsu72ne@treble>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220714160106.c6efowo6ptsu72ne@treble>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 14, 2022 at 09:01:06AM -0700, Josh Poimboeuf wrote:

> > Yeah this; if the user asks for IBRS, we should give him IBRS. I hate
> > the 'I know better, let me change that for you' mentality.
> 
> eIBRS CPUs don't even have legacy IBRS so I don't see how this is even
> possible.

You can still WRMSR a lot on them. Might not make sense but it 'works'.
