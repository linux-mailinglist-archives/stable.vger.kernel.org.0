Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DAE4664712
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 18:10:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231558AbjAJRKg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 12:10:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238473AbjAJRK0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 12:10:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD033BC2B
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 09:10:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6B9D861806
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 17:10:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73420C433D2
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 17:10:24 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="VoG+tRnB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1673370622;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jeqcNKFwyiCGXsM/eeyCBAIcc7Oi5Q6wkPBwZ90lU/I=;
        b=VoG+tRnB08B0FK2dP5S47Nz3tTAdRfCHAv9A6lu1p7FuH5FqviylfRtpTi6MLtGKIH5mkM
        vosH/Y8UIJnkQEX9LO3INDYKtjnjk5FThpzZEfGaugj+NlBwXC3unpuNY39vgmnyljAbvP
        Fa0JVA9/Nv8mGb9537wtQFvgjWee2nk=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 7d0634ee (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO)
        for <stable@vger.kernel.org>;
        Tue, 10 Jan 2023 17:10:22 +0000 (UTC)
Received: by mail-ed1-f53.google.com with SMTP id v10so17337414edi.8
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 09:10:22 -0800 (PST)
X-Gm-Message-State: AFqh2kr/uzmreD0Pd+tj9a+z4Nut4mnxqxsAj0H2uJaPlflabOIV3Zp9
        KYLLy2Utkcy+RRw/hMNEqjb0H8OpZ/CTdx2QXCA=
X-Google-Smtp-Source: AMrXdXsGxTCGOdmC92IbCqPQp3T2tfr4qrEFjFkeBcxn4iOuh6uE4Q7tXiQgqzROGWHryOG8w8TWn4IOOHMnOLWX8oM=
X-Received: by 2002:a50:cc4a:0:b0:462:1e07:1dd7 with SMTP id
 n10-20020a50cc4a000000b004621e071dd7mr7764121edi.293.1673370621136; Tue, 10
 Jan 2023 09:10:21 -0800 (PST)
MIME-Version: 1.0
References: <20230110160416.2590-1-Jason@zx2c4.com> <Y72YyXw5HcsbDac1@kroah.com>
 <CAHmME9r_tDXfnvdPfyQ+m_EB_nyNHs65NMueNHnk2u5Paqt3RQ@mail.gmail.com> <Y72bx/IyZ0zl6opA@kroah.com>
In-Reply-To: <Y72bx/IyZ0zl6opA@kroah.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Tue, 10 Jan 2023 18:10:09 +0100
X-Gmail-Original-Message-ID: <CAHmME9qx6KtsqWFrxohOtLwzesp-aJHWzRMk7aLcvN4eRsH=rQ@mail.gmail.com>
Message-ID: <CAHmME9qx6KtsqWFrxohOtLwzesp-aJHWzRMk7aLcvN4eRsH=rQ@mail.gmail.com>
Subject: Re: [PATCH stable] efi: random: combine bootloader provided RNG seed
 with RNG protocol output
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>
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

On Tue, Jan 10, 2023 at 6:09 PM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Tue, Jan 10, 2023 at 05:57:21PM +0100, Jason A. Donenfeld wrote:
> > Thanks! IIRC, this applies to all current stable kernels (now that
> > you've sunsetted 4.9).
>
> It does not apply cleanly to 5.4.y or 4.19.y or 4.14.y so can you
> provide working backports for them?

Oh, darn. I thought it would for some reason. Okay, lemme get cranking on that.
