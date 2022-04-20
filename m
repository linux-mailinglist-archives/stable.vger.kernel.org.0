Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FBAC508E3F
	for <lists+stable@lfdr.de>; Wed, 20 Apr 2022 19:16:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381024AbiDTRSc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Apr 2022 13:18:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381012AbiDTRSb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Apr 2022 13:18:31 -0400
X-Greylist: delayed 963 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 20 Apr 2022 10:15:43 PDT
Received: from brightrain.aerifal.cx (brightrain.aerifal.cx [216.12.86.13])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A7E73EF10
        for <stable@vger.kernel.org>; Wed, 20 Apr 2022 10:15:42 -0700 (PDT)
Date:   Wed, 20 Apr 2022 12:59:37 -0400
From:   Rich Felker <dalias@libc.org>
To:     Palmer Dabbelt <palmer@dabbelt.com>
Cc:     ebiederm@xmission.com, damien.lemoal@opensource.wdc.com,
        keescook@chromium.org, Niklas.Cassel@wdc.com,
        viro@zeniv.linux.org.uk, Paul Walmsley <paul.walmsley@sifive.com>,
        aou@eecs.berkeley.edu, vapier@gentoo.org, stable@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-riscv@lists.infradead.org, linux-arch@vger.kernel.org,
        geert@linux-m68k.org, linux-m68k@lists.linux-m68k.org,
        gerg@linux-m68k.org, linux-arm-kernel@lists.infradead.org,
        linux-sh@vger.kernel.org, ysato@users.sourceforge.jp
Subject: Re: [PATCH] binfmt_flat: Remove shared library support
Message-ID: <20220420165935.GA12207@brightrain.aerifal.cx>
References: <87levzzts4.fsf_-_@email.froward.int.ebiederm.org>
 <mhng-32cab6aa-87a3-4a5c-bf83-836c25432fdd@palmer-ri-x1c9>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <mhng-32cab6aa-87a3-4a5c-bf83-836c25432fdd@palmer-ri-x1c9>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 20, 2022 at 09:17:22AM -0700, Palmer Dabbelt wrote:
> On Wed, 20 Apr 2022 07:58:03 PDT (-0700), ebiederm@xmission.com wrote:
> >
> >In a recent discussion[1] it was reported that the binfmt_flat library
> >support was only ever used on m68k and even on m68k has not been used
> >in a very long time.
> >
> >The structure of binfmt_flat is different from all of the other binfmt
> >implementations becasue of this shared library support and it made
> >life and code review more effort when I refactored the code in fs/exec.c.
> >
> >Since in practice the code is dead remove the binfmt_flat shared libarary
> >support and make maintenance of the code easier.
> >
> >[1] https://lkml.kernel.org/r/81788b56-5b15-7308-38c7-c7f2502c4e15@linux-m68k.org
> >Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
> >---
> >
> >Can the binfmt_flat folks please verify that the shared library support
> >really isn't used?
> 
> I don't actually know follow the RISC-V flat support, last I heard it was still
> sort of just in limbo (some toolchain/userspace bugs th at needed to be sorted
> out).  Damien would know better, though, he's already on the thread.  I'll
> leave it up to him to ack this one, if you were even looking for anything from
> the RISC-V folks at all (we don't have this in any defconfigs).

For what it's worth, bimfmt_flat (with or without shared library
support) should be simple to implement as a binfmt_misc handler if
anyone needs the old shared library support (or if kernel wanted to
drop it entirely, which I would be in favor of). That's how I handled
old aout binaries I wanted to run after aout was removed: trivial
binfmt_misc loader.

Rich
