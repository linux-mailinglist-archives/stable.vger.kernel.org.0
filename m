Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 249A757541F
	for <lists+stable@lfdr.de>; Thu, 14 Jul 2022 19:38:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238459AbiGNRiT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jul 2022 13:38:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229686AbiGNRiS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jul 2022 13:38:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9074B5F10C;
        Thu, 14 Jul 2022 10:38:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2F00662109;
        Thu, 14 Jul 2022 17:38:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 175A1C34114;
        Thu, 14 Jul 2022 17:38:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657820296;
        bh=I+JR2vuCoo4TsjHs0xtWLheVFBc/lFgWZka+PVI97jQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bbzrVmFt3ESKn/syjc7nTkCggq0bopPdVbbmq6nlS92dKqrK2/qGOnmisoEfRQ8GZ
         AAR7H0Ds1HMwIiG8VgxpHikOq/nBat8+2JphE78F7BJeg8mfhS83ZQcpKXD27Jk4M5
         AyHok7VHNCwSqxjkvERpnvvIoeUZtldhsJqnK/W6yKBHEK1t/mhyz9OPhAMABT4C6z
         KQGC/OyNAalN8pYU0yV25thSq+OChMn6DNW3SlJpDR8sFNByaSR6RkEodACoj3D7jL
         3wKWSsVyA7CGJWrw98Ix3x/hcIuDfuQnLKQGZTDqQ1pXk49Fh0BK0sUByEMnjoW9N8
         FV/Dw0mSH8Dmw==
Date:   Thu, 14 Jul 2022 10:38:14 -0700
From:   Josh Poimboeuf <jpoimboe@kernel.org>
To:     Peter Zijlstra <peterz@infradead.org>
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
Message-ID: <20220714173814.p5kdyimu6ho7zjt5@treble>
References: <0456b35fb9ef957d9a9138e0913fb1a3fd445dff.1657747493.git.pawan.kumar.gupta@linux.intel.com>
 <Ys/7RiC9Z++38tzq@quatroqueijos>
 <YtABEwRnWrJyIKTY@worktop.programming.kicks-ass.net>
 <20220714160106.c6efowo6ptsu72ne@treble>
 <YtBMZMaOnA8g8m0a@worktop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YtBMZMaOnA8g8m0a@worktop.programming.kicks-ass.net>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 14, 2022 at 07:03:32PM +0200, Peter Zijlstra wrote:
> On Thu, Jul 14, 2022 at 09:01:06AM -0700, Josh Poimboeuf wrote:
> 
> > > Yeah this; if the user asks for IBRS, we should give him IBRS. I hate
> > > the 'I know better, let me change that for you' mentality.
> > 
> > eIBRS CPUs don't even have legacy IBRS so I don't see how this is even
> > possible.
> 
> You can still WRMSR a lot on them. Might not make sense but it 'works'.

Even in Intel documentation, eIBRS is often referred to as IBRS. It
wouldn't be surprising for a user to consider spectre_v2=ibrs to mean
"use eIBRS".

I'm pretty sure there's nobody out there that wants spectre_v2=ibrs to
mean "make it slower and possibly less secure because it's being used
contrary to the spec".

-- 
Josh
