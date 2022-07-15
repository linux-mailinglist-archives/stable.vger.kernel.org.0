Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A14C75764D1
	for <lists+stable@lfdr.de>; Fri, 15 Jul 2022 18:00:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229550AbiGOQAL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jul 2022 12:00:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbiGOQAK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jul 2022 12:00:10 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4241E958C;
        Fri, 15 Jul 2022 09:00:09 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id C617334706;
        Fri, 15 Jul 2022 16:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1657900807; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PmxgdbvxN1/lfrPzGsVJbbJYjv4n4eZUn1st8Pyud1c=;
        b=Pp7kVSGsWY466CZ1qFGSNRDkhPmHn/u9goTaAqs2/WE8qQOHSHmG+BNk3IRkqT9Yt++P2R
        g3aKdXGwyrby2L4UmhbAIEzDIxmc09knKMXBzXD/og4vcJCd50+z/Ti41ckR9z/fV9klD1
        zWd2d6WjWHKfY2LDq/1DEzAZYnqZ+K4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1657900807;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PmxgdbvxN1/lfrPzGsVJbbJYjv4n4eZUn1st8Pyud1c=;
        b=/hSNKCiAIoNQ9mboeeqD94aXqaTdvW2Sp2lj+FfzOYmCyn15JPqbejyqYWq4OEf/TfsUBX
        BDuLuwo1UjJAJnAg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id B846513AC3;
        Fri, 15 Jul 2022 16:00:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id tLP0LAeP0WLeZgAAMHmgww
        (envelope-from <bp@suse.de>); Fri, 15 Jul 2022 16:00:07 +0000
Date:   Fri, 15 Jul 2022 18:00:00 +0200
From:   Borislav Petkov <bp@suse.de>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        clang-built-linux <llvm@lists.linux.dev>,
        stable <stable@vger.kernel.org>,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH v2] x86/speculation: Use DECLARE_PER_CPU for
 x86_spec_ctrl_current
Message-ID: <YtGPAG0ZBqvotud1@zn.tnic>
References: <20220713152436.2294819-1-nathan@kernel.org>
 <20220714143005.73c71cf8@kernel.org>
 <CAHk-=wi+O_3+uef45jxj1+GhT+H0vXs9iz8rpjk49vCiyLS4DA@mail.gmail.com>
 <20220714145652.22cf4878@kernel.org>
 <CAHk-=wgqJFV45497fBfc1HS3Oaoqi3pfenZ0XM3uqFGYz8wTQQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHk-=wgqJFV45497fBfc1HS3Oaoqi3pfenZ0XM3uqFGYz8wTQQ@mail.gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 14, 2022 at 03:14:53PM -0700, Linus Torvalds wrote:
> Anyway, I cherry-picked Nathan's patch from my clang tree and pushed
> it out as commit db886979683a ("x86/speculation: Use DECLARE_PER_CPU
> for x86_spec_ctrl_current").

... and I've zapped it from my lineup.

Thx.

-- 
Regards/Gruss,
    Boris.

SUSE Software Solutions Germany GmbH
GF: Ivo Totev, Andrew Myers, Andrew McDonald, Martje Boudien Moerman
(HRB 36809, AG Nürnberg)
