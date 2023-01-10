Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54CAE664750
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 18:22:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231241AbjAJRWB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 12:22:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233353AbjAJRVb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 12:21:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E423B58D03
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 09:20:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9FE24B818DD
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 17:20:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FB52C433D2
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 17:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673371221;
        bh=QCGCDJ1bLE98tPbSdgFPgDJmEogI/HFi/9mzKmWX6yI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=JDBsjiNoEzwSCaRRZy87U7oqNqM3cvBjWMaidhLI6IVo5NOjEOlhw2yQFlKdya98/
         IINJoNyDaAqNj7zGIu7SapVlt7kyuxPtM0tv6CXYidNRDELOReyH8vUoPKRAHuN5CD
         wzyHPbJsab2MLnFSPC1+iJ81/uxjtY+cJ5M2SPD/kCHVXSCz9Uf8ubV1ODUXExmT92
         ZhDeXIO1uaFZIGPY4a1yvoI6HhWOKWuS30+JXME/PEqyx5R12ZKW/7bbKxrG36CDvj
         95Dw9EUQFCcfIxisykxR/ap8TugAYENOMVEFBaIr04eVYIzVK/IvQAsrOLDs1e1AEB
         wPYVj/Y2tbChw==
Received: by mail-lf1-f45.google.com with SMTP id y25so19540351lfa.9
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 09:20:21 -0800 (PST)
X-Gm-Message-State: AFqh2krp6uC3aEtBUmD4W1z+41MJqhAcz9WsYWeOJxv5Uoj0cLWYKVly
        OSjJBCvVP/Ru6Th99YQyoW9AYBe2kc4YatG+Q4U=
X-Google-Smtp-Source: AMrXdXu0OVLiZs8J0UMCeZp8xyOcJWbEGiyEyXmJUm66uWp/RhUQzc0AOrT+Yf1vJ3gVZY+6DLgKGcOyTh4Q1scMd+Y=
X-Received: by 2002:ac2:5e65:0:b0:4a2:740b:5b02 with SMTP id
 a5-20020ac25e65000000b004a2740b5b02mr2825301lfr.122.1673371219384; Tue, 10
 Jan 2023 09:20:19 -0800 (PST)
MIME-Version: 1.0
References: <20230110160416.2590-1-Jason@zx2c4.com> <Y72YyXw5HcsbDac1@kroah.com>
 <CAHmME9r_tDXfnvdPfyQ+m_EB_nyNHs65NMueNHnk2u5Paqt3RQ@mail.gmail.com>
 <Y72bx/IyZ0zl6opA@kroah.com> <CAHmME9qx6KtsqWFrxohOtLwzesp-aJHWzRMk7aLcvN4eRsH=rQ@mail.gmail.com>
In-Reply-To: <CAHmME9qx6KtsqWFrxohOtLwzesp-aJHWzRMk7aLcvN4eRsH=rQ@mail.gmail.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Tue, 10 Jan 2023 18:20:08 +0100
X-Gmail-Original-Message-ID: <CAMj1kXFFM4K6A58BPfDCDsCdzXPXJdDOn+NkJaTk81rDQRiRcw@mail.gmail.com>
Message-ID: <CAMj1kXFFM4K6A58BPfDCDsCdzXPXJdDOn+NkJaTk81rDQRiRcw@mail.gmail.com>
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

On Tue, 10 Jan 2023 at 18:10, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
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
> Oh, darn. I thought it would for some reason. Okay, lemme get cranking on that.

Should we bother? Isn't v5.10 far enough back for this? This is not a
bugfix after all.
