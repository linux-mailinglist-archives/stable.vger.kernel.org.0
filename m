Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D59966723C
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 13:31:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbjALMbh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 07:31:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229639AbjALMbe (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 07:31:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 231911006
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 04:31:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B06D260AB2
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 12:31:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ED73C433D2
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 12:31:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673526693;
        bh=hEMCYkefnTcycdJzAqfsz5g5ckBqTwlO0q9kx2B451I=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=tgfnpsiC2Hyvpd2vRkUPNQ/FeSqxMW0Ir235gAFWplwsxDw4btyzTY9YkzvhdeOzi
         E06Ix2BQ8SeqgOjTyhriZP6WSG3Hqs8lipwsEXf/5LBqOxmysbgZqJN14PAKG9MYZX
         DBeY0vk3oZCNGLPa2BLp0ubQ5j4SbufJsL2fqN0ZKdEHOOtSL4mXyqVWTPqgwM5X0c
         39okLG1cjiKsjCklIDiEXYVz9qEFHatHBgIlulyHtq2asyR7Dzdn6N408+g0fY+qS0
         sKem6cS5sbHm9YvNVpWPBRvNrMKlg0EzCTzORa7ILnNUwnpeeeEU/dcgZcPIdVEiGy
         dSNV7znO/YcUA==
Received: by mail-lj1-f180.google.com with SMTP id f21so14757012ljc.7
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 04:31:33 -0800 (PST)
X-Gm-Message-State: AFqh2kpW5nygI3ExgpWSizb3Zn+PK5iZPTF7WafZStA12LPUMSjWE1Du
        NJ7Krf0x/g6UBVjXiFxkkyxXqaCDJBoAj4BTr7s=
X-Google-Smtp-Source: AMrXdXutOQwl4byjm/vDY7/2QllE43svwCvFuyAcoLDYL5OdOkGECgPMYz4ZAVztOAAxdYjtAePJzfFvg675LJQoYkc=
X-Received: by 2002:a2e:98d2:0:b0:289:7fc6:e1d with SMTP id
 s18-20020a2e98d2000000b002897fc60e1dmr165228ljj.69.1673526691116; Thu, 12 Jan
 2023 04:31:31 -0800 (PST)
MIME-Version: 1.0
References: <CAHmME9oomMCxw=OQZpSp+hwLM78hZV+gNyn8ZPJgN99s2e=tuw@mail.gmail.com>
 <20230110194540.463983-1-Jason@zx2c4.com> <Y7/9Qq91/tjMy1Yn@kroah.com>
In-Reply-To: <Y7/9Qq91/tjMy1Yn@kroah.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Thu, 12 Jan 2023 13:31:19 +0100
X-Gmail-Original-Message-ID: <CAMj1kXECPUXHyB4Ub5d79uB7Y2LuJryench6oa++tFw8Bb-A4g@mail.gmail.com>
Message-ID: <CAMj1kXECPUXHyB4Ub5d79uB7Y2LuJryench6oa++tFw8Bb-A4g@mail.gmail.com>
Subject: Re: [PATCH stable 5.4.y] efi: random: combine bootloader provided RNG
 seed with RNG protocol output
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 12 Jan 2023 at 13:29, Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Tue, Jan 10, 2023 at 08:45:40PM +0100, Jason A. Donenfeld wrote:
> > From: Ard Biesheuvel <ardb@kernel.org>
> >
> > commit 196dff2712ca5a2e651977bb2fe6b05474111a83 upstream.
> >
>
> Now queued up, thanks.
>

Queued up where? Not v5.4 I hope?
