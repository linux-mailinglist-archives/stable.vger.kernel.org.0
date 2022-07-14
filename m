Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2818F575781
	for <lists+stable@lfdr.de>; Fri, 15 Jul 2022 00:18:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241065AbiGNWSw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jul 2022 18:18:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232129AbiGNWSw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jul 2022 18:18:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CFC718E3F;
        Thu, 14 Jul 2022 15:18:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6692BB829D7;
        Thu, 14 Jul 2022 22:18:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79B57C34115;
        Thu, 14 Jul 2022 22:18:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657837127;
        bh=1Aqwr4YFqfGgDa0bG3vB0f3cqZWIAVz8aqAVl9OSS+s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mp0AHknd+XA/uw2dc8IvLvTyMr/8Z+2WjR8HL/0QnxBwakyYZ8WwteB8dbKYiFssA
         ORKewj7/ZxlpjF4+reE6tAVbOcVoQzZ5RgWme33H82QdkxGeAhjLBAqYKjH0UyH7TF
         K8crPXQ+jS2ZpaKxJrLNaqMXhPBcT2hu4okc2acAxpxrlN+TK1JU9rJxtGpALtRWUx
         jTUgxRnugd8KGiYo7C67MNe5zZnSRqgRN6SPGbMP2Z/d3toHyQglIzLnYrzCjMbmeE
         d7sDjKv2yT1Q6pm03GTU/jzejOvhg95odFgIwl2/8QDm8jMggsWMUy2dYk86w4SRaI
         +KWmYMn0rusDg==
Date:   Thu, 14 Jul 2022 15:18:45 -0700
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
Message-ID: <20220714151845.59905190@kernel.org>
In-Reply-To: <CAHk-=wgqJFV45497fBfc1HS3Oaoqi3pfenZ0XM3uqFGYz8wTQQ@mail.gmail.com>
References: <20220713152436.2294819-1-nathan@kernel.org>
        <20220714143005.73c71cf8@kernel.org>
        <CAHk-=wi+O_3+uef45jxj1+GhT+H0vXs9iz8rpjk49vCiyLS4DA@mail.gmail.com>
        <20220714145652.22cf4878@kernel.org>
        <CAHk-=wgqJFV45497fBfc1HS3Oaoqi3pfenZ0XM3uqFGYz8wTQQ@mail.gmail.com>
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

On Thu, 14 Jul 2022 15:14:53 -0700 Linus Torvalds wrote:
> On Thu, Jul 14, 2022 at 2:56 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > I have clang 13, let me double check this fix is enough for the build
> > to complete without disabling WERROR.  
> 
> I have clang 14 locally, and it builds fine with that (and doesn't
> build without it).

FWIW I can confirm - builds with clang 13 as well.

> I actually normally build the kernel with both gcc and clang. My
> "upstream" kernel I build with gcc, and then I have my "private random
> collection of patches" kernel that I build with clang and that are
> just rebased on top of the kernel-of-the-day.
> 
> This is all entirely for historical reasons - part of my "private
> random collection of patches" used to be the "asm goto with outputs",
> which had clang support first.
> 
> But then the reason I never even noticed the build breakage with the
> retbleed patches until much too late was that those I just had as a
> third fork off my upstream kernel, so despite me usually building with
> clang too, that only got attention from gcc.
> 
> So it's really just a microcosm version of the exact same bigger issue
> we always have with those embargoed hw security patches: they end up
> missing out on all the usual test environments.
> 
> Anyway, I cherry-picked Nathan's patch from my clang tree and pushed
> it out as commit db886979683a ("x86/speculation: Use DECLARE_PER_CPU
> for x86_spec_ctrl_current").

Awesome, thanks!
