Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 964DC664788
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 18:37:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233313AbjAJRht (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 12:37:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234290AbjAJRhr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 12:37:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CAE83D1ED
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 09:37:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2E43EB818EE
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 17:37:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4FCAC433EF
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 17:37:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673372263;
        bh=EvNeG+G9mHMhMReXLmADW+ap0q54xKCbATPs1cRdUqU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=C0mvYveGj+F/o1aVsLkjIqIXPcEU8W+Xux8rrUam067yUUW95MFEXheN3OgqjxBRa
         o6y1jfg2hkhRxcyniSkLCMFNLNq+0YC2pfa/EPxE/cyHFwUnq6Mk0AVN120NRVEHA5
         zMdv9Yuir8P13MT1I3ounZYS9nlBDRSvo7EgN54lIapmk5N41MIFNIYgLWvtZHEC+H
         1stLJIWVEqrIdxbl4S7fKg8AY7s4ArHAnClYb1b6GGXNd47N1G6LcQP6AW3uO/cnWS
         rs3QtoDasPJn2WUEouvaFoyZ2AjOSsdMMjJKBHhDsGu2v1xKQOQ/ECRomjXgUL/FS6
         Iatd1gfB/m98Q==
Received: by mail-lf1-f54.google.com with SMTP id bt23so19578460lfb.5
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 09:37:43 -0800 (PST)
X-Gm-Message-State: AFqh2kp562wzhhEE0bkUVf5NgnxaWref64wpr4agfyWKyacfhK+p0nFY
        ZMenqSCEPEZFR8fotzc2A/U9Kuswn6rxP07tvJA=
X-Google-Smtp-Source: AMrXdXsyA0JePme6wuiTXdTEA3Vh22qtrt5JR6nXUPxF3JZGhrZlJeTs6/3+gUQVvE/PzHGAvTCToPL6gxU5Q0WjSUc=
X-Received: by 2002:a05:6512:15a3:b0:4bc:bdf5:f163 with SMTP id
 bp35-20020a05651215a300b004bcbdf5f163mr3572392lfb.583.1673372261860; Tue, 10
 Jan 2023 09:37:41 -0800 (PST)
MIME-Version: 1.0
References: <20230110160416.2590-1-Jason@zx2c4.com> <Y72YyXw5HcsbDac1@kroah.com>
 <CAHmME9r_tDXfnvdPfyQ+m_EB_nyNHs65NMueNHnk2u5Paqt3RQ@mail.gmail.com>
 <Y72bx/IyZ0zl6opA@kroah.com> <CAHmME9qx6KtsqWFrxohOtLwzesp-aJHWzRMk7aLcvN4eRsH=rQ@mail.gmail.com>
 <CAMj1kXFFM4K6A58BPfDCDsCdzXPXJdDOn+NkJaTk81rDQRiRcw@mail.gmail.com> <CAHmME9rRasgK0E6hz-sumf9nm7mEFYobOgzKBtL15=wV7ug4dQ@mail.gmail.com>
In-Reply-To: <CAHmME9rRasgK0E6hz-sumf9nm7mEFYobOgzKBtL15=wV7ug4dQ@mail.gmail.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Tue, 10 Jan 2023 18:37:30 +0100
X-Gmail-Original-Message-ID: <CAMj1kXFj9TobXf8S-wO5vH+myx6Y6Bk0BvcuRu=TxkhxKxTrZw@mail.gmail.com>
Message-ID: <CAMj1kXFj9TobXf8S-wO5vH+myx6Y6Bk0BvcuRu=TxkhxKxTrZw@mail.gmail.com>
Subject: Re: [PATCH stable] efi: random: combine bootloader provided RNG seed
 with RNG protocol output
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 10 Jan 2023 at 18:32, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> On Tue, Jan 10, 2023 at 6:20 PM Ard Biesheuvel <ardb@kernel.org> wrote:
> >
> > On Tue, 10 Jan 2023 at 18:10, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> > >
> > > On Tue, Jan 10, 2023 at 6:09 PM Greg KH <gregkh@linuxfoundation.org> wrote:
> > > >
> > > > On Tue, Jan 10, 2023 at 05:57:21PM +0100, Jason A. Donenfeld wrote:
> > > > > Thanks! IIRC, this applies to all current stable kernels (now that
> > > > > you've sunsetted 4.9).
> > > >
> > > > It does not apply cleanly to 5.4.y or 4.19.y or 4.14.y so can you
> > > > provide working backports for them?
> > >
> > > Oh, darn. I thought it would for some reason. Okay, lemme get cranking on that.
> >
> > Should we bother? Isn't v5.10 far enough back for this? This is not a
> > bugfix after all.
>
> This *is* a bug fix. And not just because we used to clobber that
> configuration table unnecessarily, but moreover because of the forward
> secrecy issues due to the missing memzero. We did all that in a single
> patch under the assumption that this would be backported as a unit.
>
> Anyway, don't sweat it - I'm working on the backport now. Seems
> straightforward enough.
>

Fair enough.
