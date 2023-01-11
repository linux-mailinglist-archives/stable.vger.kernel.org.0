Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38D6E665666
	for <lists+stable@lfdr.de>; Wed, 11 Jan 2023 09:45:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229592AbjAKIpb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Jan 2023 03:45:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237948AbjAKIo7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Jan 2023 03:44:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B8E8E0A0
        for <stable@vger.kernel.org>; Wed, 11 Jan 2023 00:44:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D5ED7B81B32
        for <stable@vger.kernel.org>; Wed, 11 Jan 2023 08:44:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CB66C433D2
        for <stable@vger.kernel.org>; Wed, 11 Jan 2023 08:44:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673426688;
        bh=ITFAfLh5Kf/+w95clH+QdRt1gyfo5a1mAWuQ+rDDtf8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=uHSI+H967DH62Ay9uIJ1czzzXgkhfupqMimwb2FEBtbsbbw9RwJgqsJdOhl9MN2se
         +NWJ2TdCw0BluWr6CrqZNPyGn1zYPBVH6LebcvqgMYH9C5eRSiRdWykcS/kmKD049J
         li/h4VvffPYLUx/LrswAY1qvVLQun0MndCfluu24E/82JvqBHMjslF9b1Lw8tqH9Eu
         fMKP5PhkzwlmNz1HQ9zvyCvnN5GPH4kjiVGqPcWthASEtLrHxkKu039311kPTSRxGQ
         lc6knlcH0LHara18lOeSQfMf+dCDKutJ32NmvOJh8z4HBYGsQtzGnqEjJrM67O1ZNY
         AF9kgFKrhDSuA==
Received: by mail-lf1-f43.google.com with SMTP id bq39so22487188lfb.0
        for <stable@vger.kernel.org>; Wed, 11 Jan 2023 00:44:48 -0800 (PST)
X-Gm-Message-State: AFqh2kp+RHmkdei4zmWZfApHmaWF74hCbryZfaddn1Um+nzegHaLeNaD
        Jj9YnapmnENq9AOZWNGgntvy4jCgdM4EkNvYBkU=
X-Google-Smtp-Source: AMrXdXuQTjjAPX1YM64bJeNLtQ7LpMUsmvs9b1kdKu1wF65QnuCN//9hQPT+FGZelgFtv5miWdRdnM2qZ5aT+vMa4Uc=
X-Received: by 2002:a05:6512:3d93:b0:4b8:9001:a694 with SMTP id
 k19-20020a0565123d9300b004b89001a694mr3442602lfv.426.1673426686526; Wed, 11
 Jan 2023 00:44:46 -0800 (PST)
MIME-Version: 1.0
References: <20230110160416.2590-1-Jason@zx2c4.com> <Y72YyXw5HcsbDac1@kroah.com>
 <CAHmME9r_tDXfnvdPfyQ+m_EB_nyNHs65NMueNHnk2u5Paqt3RQ@mail.gmail.com>
 <Y72bx/IyZ0zl6opA@kroah.com> <CAHmME9oomMCxw=OQZpSp+hwLM78hZV+gNyn8ZPJgN99s2e=tuw@mail.gmail.com>
In-Reply-To: <CAHmME9oomMCxw=OQZpSp+hwLM78hZV+gNyn8ZPJgN99s2e=tuw@mail.gmail.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Wed, 11 Jan 2023 09:44:34 +0100
X-Gmail-Original-Message-ID: <CAMj1kXFXxuWuM7gfMxRnF9tKvJSFO=dFMbkn97jPC2gafC7jvA@mail.gmail.com>
Message-ID: <CAMj1kXFXxuWuM7gfMxRnF9tKvJSFO=dFMbkn97jPC2gafC7jvA@mail.gmail.com>
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

On Tue, 10 Jan 2023 at 20:45, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> On Tue, Jan 10, 2023 at 6:09 PM Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > On Tue, Jan 10, 2023 at 05:57:21PM +0100, Jason A. Donenfeld wrote:
> > > Thanks! IIRC, this applies to all current stable kernels (now that
> > > you've sunsetted 4.9).
> >
> > It does not apply cleanly to 5.4.y or 4.19.y or 4.14.y so can you
> > provide working backports for them?
>
> I did 5.4.y, which turned out to be hairy than I wanted. You and Ard
> can decide if you want it or not. I'll leave 4.19 and 4.14 for another
> day.

I appreciate you spending the effort, but I'm not convinced this is
worth the risk. You are backporting new functionality (invoking the
firmware's RNG protocol at boot on x86), and we might end up
regressing on systems where the firmware's implementation is
problematic, even if the patch by itself is correct. This applies to
mixed mode especially, as the conversion between Win64 and i386
calling conventions has kicked up some very surprising issues in the
past.
