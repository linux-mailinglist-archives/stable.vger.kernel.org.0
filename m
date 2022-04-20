Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7969650915D
	for <lists+stable@lfdr.de>; Wed, 20 Apr 2022 22:23:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382104AbiDTU0M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Apr 2022 16:26:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350611AbiDTU0L (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Apr 2022 16:26:11 -0400
Received: from brightrain.aerifal.cx (brightrain.aerifal.cx [216.12.86.13])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A10392E9D2
        for <stable@vger.kernel.org>; Wed, 20 Apr 2022 13:23:23 -0700 (PDT)
Date:   Wed, 20 Apr 2022 16:23:22 -0400
From:   Rich Felker <dalias@libc.org>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Kees Cook <keescook@chromium.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Niklas.Cassel@wdc.com, Al Viro <viro@zeniv.linux.org.uk>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Mike Frysinger <vapier@gentoo.org>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        linux-riscv <linux-riscv@lists.infradead.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        linux-m68k <linux-m68k@lists.linux-m68k.org>,
        Greg Ungerer <gerg@linux-m68k.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        Yoshinori Sato <ysato@users.sourceforge.jp>
Subject: Re: [PATCH] binfmt_flat: Remove shared library support
Message-ID: <20220420202321.GD7074@brightrain.aerifal.cx>
References: <87levzzts4.fsf_-_@email.froward.int.ebiederm.org>
 <mhng-32cab6aa-87a3-4a5c-bf83-836c25432fdd@palmer-ri-x1c9>
 <20220420165935.GA12207@brightrain.aerifal.cx>
 <202204201044.ACFEB0C@keescook>
 <CAK8P3a2KvK78bbW_5DWKsrxLvKxYDqoCkii-kxi-mB7W9DCvNA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK8P3a2KvK78bbW_5DWKsrxLvKxYDqoCkii-kxi-mB7W9DCvNA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 20, 2022 at 10:04:32PM +0200, Arnd Bergmann wrote:
> On Wed, Apr 20, 2022 at 7:47 PM Kees Cook <keescook@chromium.org> wrote:
> >
> > Yeah, I was trying to understand why systems were using binfmt_flat and
> > not binfmt_elf, given the mention of elf2flat -- is there really such a
> > large kernel memory footprint savings to be had from removing
> > binfmt_elf?
> 
> I think the main reason for using flat binaries is nommu support on
> m68k, xtensa and risc-v. The regular binfmt_elf support requires
> an MMU, and the elf-fdpic variant is only available for arm and sh
> at this point (the other nommu architectures got removed over time).

I believe I made the elf-fdpic loader so that it's capable of loading
normal non-fdpic elf files on nommu (1bde925d23), unless somebody
broke that. I also seem to recall that capability being added to the
main elf loader later.

Rich
