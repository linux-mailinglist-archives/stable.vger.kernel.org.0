Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16CE164F6EF
	for <lists+stable@lfdr.de>; Sat, 17 Dec 2022 03:06:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230089AbiLQCGT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Dec 2022 21:06:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230076AbiLQCGR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Dec 2022 21:06:17 -0500
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE69410073;
        Fri, 16 Dec 2022 18:06:16 -0800 (PST)
Received: by mail-qt1-f175.google.com with SMTP id g7so4227046qts.1;
        Fri, 16 Dec 2022 18:06:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZKc6CEuQzPI93BCDJ+XZTxYCZmLQ7juv1HMMaSYki58=;
        b=DVfYOLBn8HZAISjW1goeKXgobVNs0oC6WDP9AT4P/+dbdMrLK0payuarSgePDlSg+4
         8HScN1+I74ha7xavA1IKQKvgxKKpIGYg+D6nRXAJCQ/S0mrzxxbRtEVVndsB5cWe4JC3
         oxKzuw2YBNn7sh+Z2zUDPoIeuDkmwlUmelq7cWstr1MrpD2WDFMd0w07eZx6sVWYNmeg
         oDwJQmx1OXnzrBrmV5AfTjIurNrKexJc2LtufPcGeuLE73UcAW/J31xrRVfj8PbRYSm9
         JYbAbonP5mON2aLxzyhLfdQJXPpkS/hzjEUrYOf+5510JVQ0R3ghgSLkl2o1jk1knu+m
         CFYQ==
X-Gm-Message-State: ANoB5pmbbhe0hRpqsr2K5+p81eacFMxUdGlAla5/770fyBCEk1lO0m8V
        tC25wSEpwJQ9PWPdT3WMNnOq0KUD477jkw==
X-Google-Smtp-Source: AA0mqf4rXy848Ygy5vtZRG6Ebev54YNctwJPnNvrFcHN8DVf3xCvxM4gu5VtZyW8WyPAfXMtFzOOfQ==
X-Received: by 2002:ac8:7ef2:0:b0:3a8:20e:2bb with SMTP id r18-20020ac87ef2000000b003a8020e02bbmr41297785qtc.6.1671242775900;
        Fri, 16 Dec 2022 18:06:15 -0800 (PST)
Received: from mail-yb1-f181.google.com (mail-yb1-f181.google.com. [209.85.219.181])
        by smtp.gmail.com with ESMTPSA id h5-20020ac87145000000b003a69225c2cdsm2284945qtp.56.2022.12.16.18.06.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Dec 2022 18:06:15 -0800 (PST)
Received: by mail-yb1-f181.google.com with SMTP id d128so4244927ybf.10;
        Fri, 16 Dec 2022 18:06:15 -0800 (PST)
X-Received: by 2002:a25:bac8:0:b0:6d8:186:aac8 with SMTP id
 a8-20020a25bac8000000b006d80186aac8mr88282764ybk.23.1671242775020; Fri, 16
 Dec 2022 18:06:15 -0800 (PST)
MIME-Version: 1.0
References: <20221208033523.122642-1-ebiggers@kernel.org> <CAMw=ZnQUmeOWQkMM9Kn5iYaT4dyDQ3j1K=dUgk9jFNcHPxxHrg@mail.gmail.com>
 <Y5zd6ucBc20CV7Le@sol.localdomain>
In-Reply-To: <Y5zd6ucBc20CV7Le@sol.localdomain>
From:   Luca Boccassi <bluca@debian.org>
Date:   Sat, 17 Dec 2022 02:06:04 +0000
X-Gmail-Original-Message-ID: <CAMw=ZnS5mXpQYtGHEK7-Q-VEojhooXiQVsGPT3e8NCW8uxnWyA@mail.gmail.com>
Message-ID: <CAMw=ZnS5mXpQYtGHEK7-Q-VEojhooXiQVsGPT3e8NCW8uxnWyA@mail.gmail.com>
Subject: Re: [PATCH] fsverity: don't check builtin signatures when require_signatures=0
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-btrfs@vger.kernel.org, linux-integrity@vger.kernel.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 16 Dec 2022 at 21:06, Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Thu, Dec 08, 2022 at 08:42:56PM +0000, Luca Boccassi wrote:
> > On Thu, 8 Dec 2022 at 03:35, Eric Biggers <ebiggers@kernel.org> wrote:
> > >
> > > From: Eric Biggers <ebiggers@google.com>
> > >
> > > An issue that arises when migrating from builtin signatures to userspace
> > > signatures is that existing files that have builtin signatures cannot be
> > > opened unless either CONFIG_FS_VERITY_BUILTIN_SIGNATURES is disabled or
> > > the signing certificate is left in the .fs-verity keyring.
> > >
> > > Since builtin signatures provide no security benefit when
> > > fs.verity.require_signatures=0 anyway, let's just skip the signature
> > > verification in this case.
> > >
> > > Fixes: 432434c9f8e1 ("fs-verity: support builtin file signatures")
> > > Cc: <stable@vger.kernel.org> # v5.4+
> > > Signed-off-by: Eric Biggers <ebiggers@google.com>
> > > ---
> > >  fs/verity/signature.c | 18 ++++++++++++++++--
> > >  1 file changed, 16 insertions(+), 2 deletions(-)
> >
> > Acked-by: Luca Boccassi <bluca@debian.org>
>
> So if I can't apply
> https://lore.kernel.org/linux-fscrypt/20221208033548.122704-1-ebiggers@kernel.org
> ("fsverity: mark builtin signatures as deprecated") due to IPE, wouldn't I not
> be able to apply this patch either?  Surely IPE isn't depending on
> fs.verity.require_signatures=1, given that it enforces the policy itself?

I'm not sure what you mean? Skipping verification when this syscfg is
disabled makes sense to me, as you noted it doesn't serve any purpose
in that case.

Kind regards,
Luca Boccassi
