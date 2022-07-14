Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3C88575745
	for <lists+stable@lfdr.de>; Thu, 14 Jul 2022 23:56:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239913AbiGNV45 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jul 2022 17:56:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232646AbiGNV44 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jul 2022 17:56:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E13E1C934;
        Thu, 14 Jul 2022 14:56:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 393E7B8298F;
        Thu, 14 Jul 2022 21:56:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2949CC34115;
        Thu, 14 Jul 2022 21:56:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657835812;
        bh=TDT225qtaJiJJ/sXK+/mfrJByrAF7WxNY1oTf+wrD3M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=p36/IcPA5ZX2ESPnYXBlSmk2tUJvSnLWpfdDN8GYJoWCo8FyaK5ixOTUqSVleYptd
         MPaAL6ANoeXynr6hHNdeZ8OS6xJO/1GoMbmczHnfdyovr4prIBN/LzT2UV2uv1bdZP
         EKqrhUZKIVNO2pMOWb+3EGK3raN6XbeSdV24aBkL7tpsqI0xLf+sb8h+PwxuTECki5
         RzEvbTtqrgDnTSquk9TYwBtKgeu1Q0x6jtARj4pBFBK6T6CmFVzygq8BVyuZi1G1o9
         IhXTMLDf4GxtdhtfsMBaV2W8W5f+lzHIyj6kSEBf0Tz0Jtn4W0yRpJG1w7+GRcIXwG
         l2EoJowRxV2cw==
Date:   Thu, 14 Jul 2022 14:56:52 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Nathan Chancellor <nathan@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        clang-built-linux <llvm@lists.linux.dev>,
        stable <stable@vger.kernel.org>,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH v2] x86/speculation: Use DECLARE_PER_CPU for
 x86_spec_ctrl_current
Message-ID: <20220714145652.22cf4878@kernel.org>
In-Reply-To: <CAHk-=wi+O_3+uef45jxj1+GhT+H0vXs9iz8rpjk49vCiyLS4DA@mail.gmail.com>
References: <20220713152436.2294819-1-nathan@kernel.org>
        <20220714143005.73c71cf8@kernel.org>
        <CAHk-=wi+O_3+uef45jxj1+GhT+H0vXs9iz8rpjk49vCiyLS4DA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 14 Jul 2022 14:51:52 -0700 Linus Torvalds wrote:
> On Thu, Jul 14, 2022 at 2:30 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > Hi, sorry to bother, any idea on the ETA for this fix getting into
> > Linus's tree? I'm trying to figure out if we should wait with
> > forwarding the networking trees or this will take a while.  
> 
> Well, I have that patch by now in my own clang tree, but was holding
> it off just because I was expecting a few other fixes for the fallout.
> 
> But if this particular one causes problems for maintainers, I can
> easily just take it right away just cherry-pick it from my own
> test-tree to my "main" tree.

I have clang 13, let me double check this fix is enough for the build
to complete without disabling WERROR. If it's not a hassle it'd
certainly make my life easier if the fix gotten applied now...
