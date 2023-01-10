Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D1C6664774
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 18:32:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234204AbjAJRcg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 12:32:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234244AbjAJRcf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 12:32:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 061645B157
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 09:32:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A93616182A
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 17:32:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA289C433F0
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 17:32:30 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="VlqOGQw0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1673371948;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YOj1FcaYN5jqxgDkw9De5glaO8FHzFgO+80GQN/xdZs=;
        b=VlqOGQw0NjHW+JzYZx73MyPpTDxeWBlsibjJlXHEnDjNMOycuiJAp2WaTUAoIPKq1CWmw7
        8ArRKcXpZ6eMlGzUHfVcp6mGUjU8LCiAFl8jOc4n/l7UnV40/pLJmi+iFqyzZO4z074cpG
        fPzfnJ4AlPetL88SlW9JHMb7rKa/2ow=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id e28a3e40 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO)
        for <stable@vger.kernel.org>;
        Tue, 10 Jan 2023 17:32:28 +0000 (UTC)
Received: by mail-ej1-f41.google.com with SMTP id fy8so30501141ejc.13
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 09:32:28 -0800 (PST)
X-Gm-Message-State: AFqh2kq9968IcbzfoRwiiixGFHdHesLO7n1l5b7bE+fm7ZGCTkHy6lpb
        wMa8xY6+601oy9eX0FjzE/JrIj+flxQF+30H30E=
X-Google-Smtp-Source: AMrXdXvKAy0qjpR2F8l4S+phsivEVgxKUpAAoUWG22Kwf15lzymSt0Dz3ws6Y4bAwcbtSGDVC7P6TDKq308GX/n5aMM=
X-Received: by 2002:a17:906:268f:b0:82e:a03c:3960 with SMTP id
 t15-20020a170906268f00b0082ea03c3960mr3768401ejc.359.1673371947346; Tue, 10
 Jan 2023 09:32:27 -0800 (PST)
MIME-Version: 1.0
References: <20230110160416.2590-1-Jason@zx2c4.com> <Y72YyXw5HcsbDac1@kroah.com>
 <CAHmME9r_tDXfnvdPfyQ+m_EB_nyNHs65NMueNHnk2u5Paqt3RQ@mail.gmail.com>
 <Y72bx/IyZ0zl6opA@kroah.com> <CAHmME9qx6KtsqWFrxohOtLwzesp-aJHWzRMk7aLcvN4eRsH=rQ@mail.gmail.com>
 <CAMj1kXFFM4K6A58BPfDCDsCdzXPXJdDOn+NkJaTk81rDQRiRcw@mail.gmail.com>
In-Reply-To: <CAMj1kXFFM4K6A58BPfDCDsCdzXPXJdDOn+NkJaTk81rDQRiRcw@mail.gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Tue, 10 Jan 2023 18:32:15 +0100
X-Gmail-Original-Message-ID: <CAHmME9rRasgK0E6hz-sumf9nm7mEFYobOgzKBtL15=wV7ug4dQ@mail.gmail.com>
Message-ID: <CAHmME9rRasgK0E6hz-sumf9nm7mEFYobOgzKBtL15=wV7ug4dQ@mail.gmail.com>
Subject: Re: [PATCH stable] efi: random: combine bootloader provided RNG seed
 with RNG protocol output
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Greg KH <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 10, 2023 at 6:20 PM Ard Biesheuvel <ardb@kernel.org> wrote:
>
> On Tue, 10 Jan 2023 at 18:10, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> >
> > On Tue, Jan 10, 2023 at 6:09 PM Greg KH <gregkh@linuxfoundation.org> wrote:
> > >
> > > On Tue, Jan 10, 2023 at 05:57:21PM +0100, Jason A. Donenfeld wrote:
> > > > Thanks! IIRC, this applies to all current stable kernels (now that
> > > > you've sunsetted 4.9).
> > >
> > > It does not apply cleanly to 5.4.y or 4.19.y or 4.14.y so can you
> > > provide working backports for them?
> >
> > Oh, darn. I thought it would for some reason. Okay, lemme get cranking on that.
>
> Should we bother? Isn't v5.10 far enough back for this? This is not a
> bugfix after all.

This *is* a bug fix. And not just because we used to clobber that
configuration table unnecessarily, but moreover because of the forward
secrecy issues due to the missing memzero. We did all that in a single
patch under the assumption that this would be backported as a unit.

Anyway, don't sweat it - I'm working on the backport now. Seems
straightforward enough.

Jason
