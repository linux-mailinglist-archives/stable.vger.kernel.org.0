Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2B73524A48
	for <lists+stable@lfdr.de>; Thu, 12 May 2022 12:31:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352629AbiELKae (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 May 2022 06:30:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352638AbiELKac (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 May 2022 06:30:32 -0400
Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com [209.85.128.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B027622308F;
        Thu, 12 May 2022 03:30:31 -0700 (PDT)
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-2f7ca2ce255so50599887b3.7;
        Thu, 12 May 2022 03:30:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DznYDTXJFA0HssmMIscX0UQ6FL2uFsbT209IcQLUNKU=;
        b=SUTLkiyhs72bcFVEodWWfJiz13zYpT5qMd8wfY9UPHmkztsAHknDLcgqaA88056QNb
         Bc2y+2VIFbFITRlv9PiIqUGsLzNaMSZdzMsaE1ss+/hwRDgz+uvSUz1J4ZGrLojzqXeQ
         M9UYmvm4cvNxg1lnJExjzUjYquNenBUO3SDvyRguhfxemGkvbivz5lrivKw8iZfBqj2M
         Dqq2gUQWqKQ6koR/JC+eYUexZDk3cDM8Oip8gg5RsNLzIb8uhu+fDcJE/A+lSB24dWaM
         f6eqUhkka8GWOm5Wpl9+Ccx4ZUU3Hbj8rryK8O2YfEjxo1AToT7elVMSYm1gnd2hru0p
         CfoQ==
X-Gm-Message-State: AOAM532Z5QFgpAsaHUkYVPGKyP0cf/RITldPeKNDmLsS9+y16VQ6R/c7
        tYuB1YDE2Qmm3jJitA/gkVz3tyHaIHkK1bTcULw=
X-Google-Smtp-Source: ABdhPJybiRZHO9cH0p8EVh00RpAoFILmE24SwCtaAYWKyhu93JjxbXApgUNEAhrWSeh26UHaJ/QdSG0pvm/JFs4TU8g=
X-Received: by 2002:a0d:ddce:0:b0:2f8:c9f7:8f7c with SMTP id
 g197-20020a0dddce000000b002f8c9f78f7cmr30685978ywe.301.1652351430973; Thu, 12
 May 2022 03:30:30 -0700 (PDT)
MIME-Version: 1.0
References: <20220510182221.3990256-1-srinivas.pandruvada@linux.intel.com>
 <CAJZ5v0hDN=iGBQei6XeJ1b3qLiRxPDm+ZFtKU1PcHbBcyxGpZw@mail.gmail.com> <408701ca2c7704c146c806740eabb5a99f30c945.camel@linux.intel.com>
In-Reply-To: <408701ca2c7704c146c806740eabb5a99f30c945.camel@linux.intel.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Thu, 12 May 2022 12:30:19 +0200
Message-ID: <CAJZ5v0hT8UBDn3Lo5znFTao1bbjVUOgk8fPxkW9x4wC7XME1-A@mail.gmail.com>
Subject: Re: [UPDATE][PATCH] thermal: int340x: Mode setting with new OS handshake
To:     srinivas pandruvada <srinivas.pandruvada@linux.intel.com>
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Amit Kucheria <amitk@kernel.org>,
        "Zhang, Rui" <rui.zhang@intel.com>,
        Linux PM <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 11, 2022 at 9:56 PM srinivas pandruvada
<srinivas.pandruvada@linux.intel.com> wrote:
>
> On Wed, 2022-05-11 at 20:14 +0200, Rafael J. Wysocki wrote:
> > On Tue, May 10, 2022 at 8:22 PM Srinivas Pandruvada
> > <srinivas.pandruvada@linux.intel.com> wrote:
> > >
> > > With the new OS handshake introduced with the commit: "c7ff29763989
> > > ("thermal: int340x: Update OS policy capability handshake")",
> > > thermal zone mode "enabled" doesn't work in the same way as the
> > > legacy
> > > handshake. The mode "enabled" fails with -EINVAL using new
> > > handshake.
> > >
> > > To address this issue, when the new OS UUID mask is set:
> > > - When mode is "enabled", return 0 as the firmware already has the
> > > latest policy mask.
> > > - When mode is "disabled", update the firmware with UUID mask of
> > > zero.
> > > In this way firmware can take control of the thermal control. Also
> > > reset the OS UUID mask. This allows user space to update with new
> > > set of policies.
> > >
> > > Fixes: c7ff29763989 ("thermal: int340x: Update OS policy capability
> > > handshake")
> > > Signed-off-by: Srinivas Pandruvada
> > > <srinivas.pandruvada@linux.intel.com>
> > > Cc: stable@vger.kernel.org
> >
> > This is not -stable material yet.
> I thought it will wait for 5.19 merge window.

It is better to avoid making a major release with a known-broken
interface if possible.

> >
> > > ---
> > > update:
> > > Added Fixes tag
> > >
> > >
>
> [...]
>
> > > +               if (priv->os_uuid_mask) {
> > > +                       if (!enabled) {
> > > +                               priv->os_uuid_mask = 0;
> > > +                               result = set_os_uuid_mask(priv,
> > > priv->os_uuid_mask);
> >
> > This change worries me a bit, because it means replaying an already
> > established _OSC handshake which shouldn't be done by the spec.
> >
> I checked with the firmware team. The _OSC changes dynamically is
> validated and is recommended when enable/disable user space thermal
> control.

OK

> Looking at ACPI Spec
> "OSPM may evaluate _OSC multiple times to indicate changes in OSPM
> capability to the device but this may be precluded by specific device
> requirements"

Well, different paragraphs say different things, but it is fine as
long as the firmware and the OS are on the same page in the given use
case.

> > But I suppose you have tested this?
> I tested on TigerLake system.

OK

> >
> > > +                       }
> > > +
>
> [...]
>
> >
> > Patch applied as 5.18-rc material, but I've removed some unneeded
> > parens from the new code, so please double check the result in
> > bleeding-edge.
> I tested the patch from bleeding edge.
> Works fine.

Good.

I'll queue it up for -rc7 then (I will be offline for the next few
days, most likely, and I'm not ready to send a pull request today).

Thanks!
