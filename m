Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 222795756EC
	for <lists+stable@lfdr.de>; Thu, 14 Jul 2022 23:30:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239842AbiGNVaL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jul 2022 17:30:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240877AbiGNVaK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jul 2022 17:30:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0704C6EE92;
        Thu, 14 Jul 2022 14:30:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B36C8B8295D;
        Thu, 14 Jul 2022 21:30:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAECAC34115;
        Thu, 14 Jul 2022 21:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657834206;
        bh=pGm0dsNASTYMf22ud+Wu7McUirHoIf7rEXRhC4vp9qA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IMaYBh8EsSajCKtn5/TqeXYalivBUf6PZbpfG7e0JeKW2C9/2EGF2wGihOgv3byEx
         6e06ZJCjE8fYREe3JS363dDB98jnUFQK3xqzbfc4pyxDuBY2Nvvip+89OyrgU6D8fB
         jGuwUzExoDmHyLLtSV1xAkLEHzP/gTCokcOdl6YzTySRvv/CfqOVesKXoNkSg5ocuE
         +I02B2a+BNiPztvpW62iP0T/+blURoDpWwKm9iyAiezO9XXYnX/rxp09i24ZENhCnn
         n6x05JW7a00mUXf97nSoM6rnPTpB5GM6a3Nd1BQBpETyQI4hO+HN8WZF0H/aKMWwlF
         lT9IzoMQ2Tknw==
Date:   Thu, 14 Jul 2022 14:30:05 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Nathan Chancellor <nathan@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>, x86@kernel.org,
        Nick Desaulniers <ndesaulniers@google.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>
Subject: Re: [PATCH v2] x86/speculation: Use DECLARE_PER_CPU for
 x86_spec_ctrl_current
Message-ID: <20220714143005.73c71cf8@kernel.org>
In-Reply-To: <20220713152436.2294819-1-nathan@kernel.org>
References: <20220713152436.2294819-1-nathan@kernel.org>
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

On Wed, 13 Jul 2022 08:24:37 -0700 Nathan Chancellor wrote:
> Clang warns:
> 
>   arch/x86/kernel/cpu/bugs.c:58:21: error: section attribute is specified on redeclared variable [-Werror,-Wsection]
>   DEFINE_PER_CPU(u64, x86_spec_ctrl_current);
>                       ^
>   arch/x86/include/asm/nospec-branch.h:283:12: note: previous declaration is here
>   extern u64 x86_spec_ctrl_current;
>              ^
>   1 error generated.
> 
> The declaration should be using DECLARE_PER_CPU instead so all
> attributes stay in sync.
> 
> Cc: stable@vger.kernel.org
> Fixes: fc02735b14ff ("KVM: VMX: Prevent guest RSB poisoning attacks with eIBRS")
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Hi, sorry to bother, any idea on the ETA for this fix getting into
Linus's tree? I'm trying to figure out if we should wait with 
forwarding the networking trees or this will take a while.
