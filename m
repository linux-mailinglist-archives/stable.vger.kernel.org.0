Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BCE3509A17
	for <lists+stable@lfdr.de>; Thu, 21 Apr 2022 10:06:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386264AbiDUIBU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Apr 2022 04:01:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386261AbiDUIBT (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Apr 2022 04:01:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10E3814033;
        Thu, 21 Apr 2022 00:58:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9EF4C61A9C;
        Thu, 21 Apr 2022 07:58:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F23FDC385A5;
        Thu, 21 Apr 2022 07:58:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650527910;
        bh=4cpOHnm1lKbpsJah/8zKxEWJvRBAEiLp0Eg7bpCKpNU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vBLzYz/8W6TyxyPXZoYXU1M72RDm3yqr3OMzlNfs3UpbQMyS9PdTCZ/KKUhsNLMJv
         rnhacdd6GCpXpJY5PpNveD83C8/YzuYGQkS53wiQM1aX2DxNKaVd0q4QGeaE3BMmV3
         0FfKaf2/mKFru+Jj+iG8q/v30EjdlZ73VTcsNKrSW8KVfw39gp0Qp3dZYwUYzdY53g
         j6WFL4VHoChY90gMNMq4yj1OOD284qTgtUhIQHRTPmGnnUrFgacbXVhNxxMicTjc6l
         ap6CKzlm5+F6KN7SMGMp4vpSr+6rVyFIvE5EKu3go1s50HvKzyzs8iZAIB2/9qaeL8
         VdKQnEsvNfaAQ==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1nhRhn-0003up-8a; Thu, 21 Apr 2022 09:58:23 +0200
Date:   Thu, 21 Apr 2022 09:58:23 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     Jann Horn <jannh@google.com>, kernel test robot <lkp@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] USB: serial: Fix heap overflow in WHITEHEAT_GET_DTR_RTS
Message-ID: <YmEOn7LrVjJuybvg@hovoldconsulting.com>
References: <20220419041742.4117026-1-keescook@chromium.org>
 <Yl+8K++wZUJCthMj@hovoldconsulting.com>
 <CAG48ez2Pikm5g2RfJxae=jz1C7KSCWc99sCa7fXFBKvDOPJubA@mail.gmail.com>
 <202204201056.5A1A6BAE04@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202204201056.5A1A6BAE04@keescook>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ +CC: Arnd ]

On Wed, Apr 20, 2022 at 11:11:26AM -0700, Kees Cook wrote:
> On Wed, Apr 20, 2022 at 02:33:06PM +0200, Jann Horn wrote:
> > On Wed, Apr 20, 2022 at 10:14 AM Johan Hovold <johan@kernel.org> wrote:
> > > On Mon, Apr 18, 2022 at 09:17:42PM -0700, Kees Cook wrote:
> > > > This looks like it's harmless, as both the source and the destinations are
> > > > currently the same allocation size (4 bytes) and don't use their padding,
> > > > but if anything were to ever be added after the "mcr" member in "struct
> > > > whiteheat_private", it would be overwritten. The structs both have a
> > > > single u8 "mcr" member, but are 4 bytes in padded size. The memcpy()
> > > > destination was explicitly targeting the u8 member (size 1) with the
> > > > length of the whole structure (size 4), triggering the memcpy buffer
> > > > overflow warning:
> > >
> > > Ehh... No. The size of a structure with a single u8 is 1, not 4. There's
> > > nothing wrong with the current code even if the use of memcpy for this
> > > is a bit odd.
> 
> I thought that was surprising too, and suspected it was something
> specific to the build (as Jann also suggested). I tracked it down[1] to
> "-mabi=apcs-gnu", which is from CONFIG_AEABI=n.
> 
> whiteheat_private {
>         __u8                       mcr;                  /*     0     1 */
> 
>         /* size: 4, cachelines: 1, members: 1 */
>         /* padding: 3 */
>         /* last cacheline: 4 bytes */
> };

I stand corrected, thanks.

Do we have other ABIs that can increase the alignment of structures like
this?

Skimming lore reveals a few subsystems that have started depending on
!OABI to not have to deal with this. Apparently the old ARM ABI is
deprecated in user space since gcc-4.6:

	https://lore.kernel.org/all/20190304193723.657089-1-arnd@arndb.de/

Perhaps time to drop support from the kernel too?

> Given nothing actually uses "struct whiteheat_dr_info", except for the
> sizing (har har), I suspect the better solution is just to do:
> 
> 	info->mcr = command_info->result_buffer[0];

Yeah, that works for now. Ideally, we'd cast the result buffer to struct
whiteheat_dr_info and access its single field. But that's not what
current code does and the above is no less confusing.

Patch applied, thanks.

Johan
