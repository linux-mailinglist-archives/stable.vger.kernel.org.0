Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DDF74CE13D
	for <lists+stable@lfdr.de>; Sat,  5 Mar 2022 00:55:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230054AbiCDX43 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Mar 2022 18:56:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiCDX42 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Mar 2022 18:56:28 -0500
Received: from mail-4322.protonmail.ch (mail-4322.protonmail.ch [185.70.43.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 518E01E2FF0;
        Fri,  4 Mar 2022 15:55:39 -0800 (PST)
Date:   Fri, 04 Mar 2022 23:55:30 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
        s=protonmail2; t=1646438136;
        bh=7iQsbSfGsE+f1tC4tYMCvNcqThKw+2jGothi5mFcCCI=;
        h=Date:To:From:Cc:Reply-To:Subject:Message-ID:In-Reply-To:
         References:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
         Message-ID;
        b=UK7u3n1SZq50J3Aw2I1DEiuetRd2HHVjlZE3QvcV6iPKP3tXK1/8u4GflGLVr67Os
         DtF0yVoisgLRoRC6jD/VytER49hooQtTybS/KlnPlYK9mL67A3UWb/D2qz1soAaDkN
         a8SrfQAQXmgZc1Eu8u01l77fWdyyG8nxs8q3xZuyBDyykvZqOIE1ScmHRkDc3E30XI
         5liUTHgHmP+Q2Mh+5G5/9UnqvAeVgKDfVZJipUTGXCLL8QnBESvYT5PP3S93VKTDKj
         iWbhAimmcq1vWj0jfY0vG4W0KZaFMrsFJqJRCOlAOd6j5R3vaOTWibi7CLk/PbfwAR
         iozr0O3sQHUEg==
To:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Alexander Lobakin <alobakin@pm.me>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Mike Rapoport <rppt@kernel.org>,
        Davidlohr Bueso <dbueso@suse.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Liam Howlett <liam.howlett@oracle.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Atsushi Nemoto <anemo@mba.ocn.ne.jp>,
        linux-mips@vger.kernel.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: Re: [PATCH mips-fixes] MIPS: fix fortify panic when copying asm exception handlers
Message-ID: <20220304234818.153517-1-alobakin@pm.me>
In-Reply-To: <20220301163411.GC13091@alpha.franken.de>
References: <20220223012338.262041-1-alobakin@pm.me> <20220301163411.GC13091@alpha.franken.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Date: Tue, 1 Mar 2022 17:34:11 +0100

> On Wed, Feb 23, 2022 at 01:30:23AM +0000, Alexander Lobakin wrote:
> > With KCFLAGS=3D"-O3", I was able to trigger a fortify-source
> > memcpy() overflow panic on set_vi_srs_handler().
> > Although O3 level is not supported in the mainline, under some
> > conditions that may've happened with any optimization settings,
> > it's just a matter of inlining luck. The panic itself is correct,
> > more precisely, 50/50 false-positive and not at the same time.
> > >From the one side, no real overflow happens. Exception handler
> > defined in asm just gets copied to some reserved places in the
> > memory.
> > But the reason behind is that C code refers to that exception
> > handler declares it as `char`, i.e. something of 1 byte length.
> > It's obvious that the asm function itself is way more than 1 byte,
> > so fortify logics thought we are going to past the symbol declared.
> > The standard way to refer to asm symbols from C code which is not
> > supposed to be called from C is to declare them as
> > `extern const u8[]`. This is fully correct from any point of view,
> > as any code itself is just a bunch of bytes (including 0 as it is
> > for syms like _stext/_etext/etc.), and the exact size is not known
> > at the moment of compilation.
> > Adjust the type of the except_vec_vi_*() and related variables.
> > Make set_handler() take `const` as a second argument to avoid
> > cast-away warnings and give a little more room for optimization.
> >
> > Fixes: e01402b115cc ("More AP / SP bits for the 34K, the Malta bits and=
 things. Still wants")
> > Fixes: c65a5480ff29 ("[MIPS] Fix potential latency problem due to non-a=
tomic cpu_wait.")
> > Cc: stable@vger.kernel.org # 3.10+
>
> I like your patch, but I have a problem with these tags. If I understand
> your description correctly there is no bug, but because of the way the
> code is written fortify-source gets confused. So if it doesn't fix
> anything, there shouldn't be Fixes tags, IMHO. If you agree, I'll
> apply this patch to mips-next and remove the tags.

Oh, sorry for the late reply.
Sure, feel free to apply to mips-next. Yeah, there is no real bug,
just not-really-100%-clean-code which works anyways.

>
> Thomas.
>
> --
> Crap can work. Given enough thrust pigs will fly, but it's not necessaril=
y a
> good idea.                                                [ RFC1925, 2.3 =
]

Thanks,
Al

