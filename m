Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BF2A5EAB12
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 17:31:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236549AbiIZPbJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 11:31:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237367AbiIZPah (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 11:30:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8A174F38F;
        Mon, 26 Sep 2022 07:16:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 85292B80AB3;
        Mon, 26 Sep 2022 14:16:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 431D9C433C1;
        Mon, 26 Sep 2022 14:16:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664201776;
        bh=TUYJYqSd4jor/lxJEt262VgRMafpQ9dsUBKaWm7idrI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=nb2Ky3/q5mbHR+N52o5cXYMMAuMbt9/GsKrdxhHJF6rI23h19460jHISA14ah/wDe
         E/flHbDCVDH2veA1DNmrqsmvnAu4Id6P0ELhY1XumCfI+8AQh8RDaWuiJyTY5Iu3MJ
         te8RUQ9L7RFRNUMliLdCZYQE08CrxW9iYMe4/q/F8/7ERw4SaV2ExoVHgNAcUEYATX
         waUXRc1tsQC10RiVP12glpHdcT8H4twilZ3hCp/rnF6keg1xEOQxQM6ERWDQ5Rws3N
         iK0vw/fdftHElavp2jE+O59RVoq1M/fbVnZnZUuQEAWZV/0CHyp1CsFNPAoYTJcE07
         2dGOLZtd9LhfQ==
Received: by mail-lj1-f182.google.com with SMTP id b6so7579545ljr.10;
        Mon, 26 Sep 2022 07:16:16 -0700 (PDT)
X-Gm-Message-State: ACrzQf2mJkttg/yBbSViPLhNH1fdHJn31j1/XXC0FOSrtEcgjtYwc2IH
        WfEsICKqIulQd41oN5YPHJp1cWj9Dza0tbVMsUE=
X-Google-Smtp-Source: AMsMyM5c8d1a2UhMc5k9AjXdsbaX+2CDsE/jo+VPh5QX+kWSUXCkxCIKYhHEUsPtBoQ/aXwnkIANy39qqzI0OfykCrE=
X-Received: by 2002:a2e:8349:0:b0:26c:4311:9b84 with SMTP id
 l9-20020a2e8349000000b0026c43119b84mr8218226ljh.152.1664201774254; Mon, 26
 Sep 2022 07:16:14 -0700 (PDT)
MIME-Version: 1.0
References: <20220926100738.148626940@linuxfoundation.org> <20220926100738.463310701@linuxfoundation.org>
 <20220926110826.GE8978@amd>
In-Reply-To: <20220926110826.GE8978@amd>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Mon, 26 Sep 2022 16:16:02 +0200
X-Gmail-Original-Message-ID: <CAMj1kXHOMuaBeR_LqVBKVtmGaJQg5hznSxow5bosQ9+NzhZ72A@mail.gmail.com>
Message-ID: <CAMj1kXHOMuaBeR_LqVBKVtmGaJQg5hznSxow5bosQ9+NzhZ72A@mail.gmail.com>
Subject: Re: [PATCH 4.14 06/40] efi: libstub: Disable struct randomization
To:     Pavel Machek <pavel@denx.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Daniel Marth <daniel.marth@inso.tuwien.ac.at>,
        Kees Cook <keescook@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 26 Sept 2022 at 13:08, Pavel Machek <pavel@denx.de> wrote:
>
> Hi!
>
> > These structs look like the ideal randomization candidates to the
> > randstruct plugin (as they only carry function pointers), but of course,
> > these protocols are contracts between the firmware that exposes them,
> > and the EFI applications (including our stubbed kernel) that invoke
> > them. This means that struct randomization for EFI protocols is not a
> > great idea, and given that the stub shares very little data with the
> > core kernel that is represented as a randomizable struct, we're better
> > off just disabling it completely here.
>
> > Cc: <stable@vger.kernel.org> # v4.14+
>
> AFAICT RANDSTRUCT_CFLAGS is not available in v4.19, so we should not
> take this patch.
>

Ugh, as it turns out, this macro doesn't exist before v5.19 so it
should not be backported beyond that version at all.

Greg, can you please drop this patch from all the -stable trees except
v5.19? Thanks, and apologies for creating confusion.
