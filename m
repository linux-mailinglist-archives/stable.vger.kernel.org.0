Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD4FA5730E1
	for <lists+stable@lfdr.de>; Wed, 13 Jul 2022 10:22:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235572AbiGMIWJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jul 2022 04:22:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235246AbiGMIVc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Jul 2022 04:21:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDE54C0521;
        Wed, 13 Jul 2022 01:18:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 91778B81D51;
        Wed, 13 Jul 2022 08:17:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4654C34114;
        Wed, 13 Jul 2022 08:17:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657700278;
        bh=mtrH3InFG5+OdX9MDNFuhP8YVtLJH9iCPwP6kVSeQBA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RNw0ZPfZ4XDUFl1OU0KtYSNVoPrhimN9C8WUNOLkrEM2PDKIikAlXT5KtLyFvfoSj
         52tMmv00wi+C7QtuJK/LpMjgBdl8KCdG98862SBFWl3pKon531kXteZtKduprdN6lN
         xhC71mUFuMt2EDX4uTN05ViTYP2TeAELehwRG9yo=
Date:   Wed, 13 Jul 2022 10:17:54 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jiri Slaby <jirislaby@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Subject: Re: [PATCH 5.18 34/61] objtool: Update Retpoline validation
Message-ID: <Ys5/ssHL076y4niP@kroah.com>
References: <20220712183236.931648980@linuxfoundation.org>
 <20220712183238.342232911@linuxfoundation.org>
 <63e23f80-033f-f64e-7522-2816debbc367@kernel.org>
 <509dd891-73cc-31b9-18ac-2e930084c02f@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <509dd891-73cc-31b9-18ac-2e930084c02f@kernel.org>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 13, 2022 at 09:54:01AM +0200, Jiri Slaby wrote:
> On 13. 07. 22, 9:45, Jiri Slaby wrote:
> > On 12. 07. 22, 20:39, Greg Kroah-Hartman wrote:
> > > From: Peter Zijlstra <peterz@infradead.org>
> > > 
> > > commit 9bb2ec608a209018080ca262f771e6a9ff203b6f upstream.
> > > 
> > > Update retpoline validation with the new CONFIG_RETPOLINE requirement of
> > > not having bare naked RET instructions.
> > 
> > Hi,
> > 
> > this breaks compilation on i386:
> >  > arch/x86/kernel/../../x86/xen/xen-head.S:35: Error: no such
> > instruction: `annotate_unret_safe'
> > 
> > Config:
> > https://raw.githubusercontent.com/openSUSE/kernel-source/stable/config/i386/pae
> > 
> > 
> > And yeah, upstream¹⁾ is affected too.
> > 
> > ¹⁾I am at commit b047602d579b4fb028128a525f056bbdc890e7f0.
> 
> A naive fix is:
> --- a/arch/x86/kernel/head_32.S
> +++ b/arch/x86/kernel/head_32.S
> @@ -23,6 +23,7 @@
>  #include <asm/cpufeatures.h>
>  #include <asm/percpu.h>
>  #include <asm/nops.h>
> +#include <asm/nospec-branch.h>
>  #include <asm/bootparam.h>
>  #include <asm/export.h>
>  #include <asm/pgtable_32.h>
> 
> The question (I don't know answer to) is whether x86_32 should actually do
> ANNOTATE_UNRET_SAFE.

I doubt it should be doing that, but I'll let others answer more
definitively.

Your commit seems sane, for some reason I thought Boris tested i386
builds, but maybe in the end something snuck in that broke it.

thanks,

greg k-h
