Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 909DD4C9076
	for <lists+stable@lfdr.de>; Tue,  1 Mar 2022 17:35:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235901AbiCAQfj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Mar 2022 11:35:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236162AbiCAQfj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Mar 2022 11:35:39 -0500
Received: from elvis.franken.de (elvis.franken.de [193.175.24.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9615C6007D;
        Tue,  1 Mar 2022 08:34:56 -0800 (PST)
Received: from uucp (helo=alpha)
        by elvis.franken.de with local-bsmtp (Exim 3.36 #1)
        id 1nP5SV-0006n6-02; Tue, 01 Mar 2022 17:34:43 +0100
Received: by alpha.franken.de (Postfix, from userid 1000)
        id E24A9C28F1; Tue,  1 Mar 2022 17:34:11 +0100 (CET)
Date:   Tue, 1 Mar 2022 17:34:11 +0100
From:   Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To:     Alexander Lobakin <alobakin@pm.me>
Cc:     "Eric W. Biederman" <ebiederm@xmission.com>,
        Mike Rapoport <rppt@kernel.org>,
        Davidlohr Bueso <dbueso@suse.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Liam Howlett <liam.howlett@oracle.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Atsushi Nemoto <anemo@mba.ocn.ne.jp>,
        linux-mips@vger.kernel.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH mips-fixes] MIPS: fix fortify panic when copying asm
 exception handlers
Message-ID: <20220301163411.GC13091@alpha.franken.de>
References: <20220223012338.262041-1-alobakin@pm.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220223012338.262041-1-alobakin@pm.me>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,T_SPF_HELO_PERMERROR autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 23, 2022 at 01:30:23AM +0000, Alexander Lobakin wrote:
> With KCFLAGS="-O3", I was able to trigger a fortify-source
> memcpy() overflow panic on set_vi_srs_handler().
> Although O3 level is not supported in the mainline, under some
> conditions that may've happened with any optimization settings,
> it's just a matter of inlining luck. The panic itself is correct,
> more precisely, 50/50 false-positive and not at the same time.
> >From the one side, no real overflow happens. Exception handler
> defined in asm just gets copied to some reserved places in the
> memory.
> But the reason behind is that C code refers to that exception
> handler declares it as `char`, i.e. something of 1 byte length.
> It's obvious that the asm function itself is way more than 1 byte,
> so fortify logics thought we are going to past the symbol declared.
> The standard way to refer to asm symbols from C code which is not
> supposed to be called from C is to declare them as
> `extern const u8[]`. This is fully correct from any point of view,
> as any code itself is just a bunch of bytes (including 0 as it is
> for syms like _stext/_etext/etc.), and the exact size is not known
> at the moment of compilation.
> Adjust the type of the except_vec_vi_*() and related variables.
> Make set_handler() take `const` as a second argument to avoid
> cast-away warnings and give a little more room for optimization.
> 
> Fixes: e01402b115cc ("More AP / SP bits for the 34K, the Malta bits and things. Still wants")
> Fixes: c65a5480ff29 ("[MIPS] Fix potential latency problem due to non-atomic cpu_wait.")
> Cc: stable@vger.kernel.org # 3.10+

I like your patch, but I have a problem with these tags. If I understand
your description correctly there is no bug, but because of the way the
code is written fortify-source gets confused. So if it doesn't fix
anything, there shouldn't be Fixes tags, IMHO. If you agree, I'll
apply this patch to mips-next and remove the tags.

Thomas.

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessarily a
good idea.                                                [ RFC1925, 2.3 ]
