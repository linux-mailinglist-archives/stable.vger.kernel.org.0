Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBC874F47D6
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 01:44:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344135AbiDEVVy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 17:21:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1572911AbiDERTe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 13:19:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B581C25DA;
        Tue,  5 Apr 2022 10:17:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 58F7CB81EB9;
        Tue,  5 Apr 2022 17:17:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 145E0C385A5;
        Tue,  5 Apr 2022 17:17:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649179053;
        bh=3hpZgI8DwU3o+PMi946nSnlTTAPscob69R04+gbt/ns=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=SVJ5vJ+m8lV9VPlHGpavrEtDnV/jLFdGsRXcA9iQliJZKo+Sw+4zlkdeEvisoeMQP
         k8tU/+T7sIX7AroAjZfOaZKYotzjz76OYUGapslQO4TuMoKx6l48aSqhjez3H/qU6U
         6Ue7pQycxI91rbxJMNMtBp6meWF6AFz5qo0unI7R2t4sC/+nZY7RMngIGM1jDM3QQA
         OMxHJ+pK8FZYgstG8roHzofPs7E3xPbbazGbjnrbUqfsQzTWjP8CkPbefd/8fUOGHS
         Rnndrd1OSlBdlroBLieW4wYLOvV7tSBLgV7YFvGogt2rAaegHmNzMkJrFDq7rxDlS/
         rKoHkjZHOs6Mg==
Received: by mail-oa1-f48.google.com with SMTP id 586e51a60fabf-df02f7e2c9so46978fac.10;
        Tue, 05 Apr 2022 10:17:32 -0700 (PDT)
X-Gm-Message-State: AOAM531lTOGWWWuRW3kbk+jlZySTwfTDXIvoebFbRnPImOvFMNx8XlWg
        zOFmyPjmc7Zzu18AjSXI+vkwsFEJspOWi9JzHdI=
X-Google-Smtp-Source: ABdhPJyzdUYMadNIRVj0N1dlLqM/HehduXFfWLLFplIs0ccxxr8Svh/SwwhsVa1WusBPNBbCvFanc9MDCwW5huONrGc=
X-Received: by 2002:a05:6870:eaa5:b0:da:b3f:2b45 with SMTP id
 s37-20020a056870eaa500b000da0b3f2b45mr2133837oap.228.1649179052186; Tue, 05
 Apr 2022 10:17:32 -0700 (PDT)
MIME-Version: 1.0
References: <20220405070339.801210740@linuxfoundation.org> <20220405070402.195698649@linuxfoundation.org>
 <CAMj1kXFL4abn9xg1ZrNpFg54Pmw1Kw8OPbDpMevSjQDNg0r5Pg@mail.gmail.com> <YkxzuSjVpIyjzdsZ@kroah.com>
In-Reply-To: <YkxzuSjVpIyjzdsZ@kroah.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Tue, 5 Apr 2022 19:17:21 +0200
X-Gmail-Original-Message-ID: <CAMj1kXEiOkmMWGr2TT=SdTqPVZotqwAho=rWLuF9=xiGSgGB0w@mail.gmail.com>
Message-ID: <CAMj1kXEiOkmMWGr2TT=SdTqPVZotqwAho=rWLuF9=xiGSgGB0w@mail.gmail.com>
Subject: Re: [PATCH 5.15 746/913] ARM: ftrace: avoid redundant loads or
 clobbering IP
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 5 Apr 2022 at 18:52, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Tue, Apr 05, 2022 at 12:01:19PM +0200, Ard Biesheuvel wrote:
> > On Tue, 5 Apr 2022 at 11:54, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > From: Ard Biesheuvel <ardb@kernel.org>
> > >
> > > [ Upstream commit d11967870815b5ab89843980e35aab616c97c463 ]
> > >
> > > Tweak the ftrace return paths to avoid redundant loads of SP, as well as
> > > unnecessary clobbering of IP.
> > >
> > > This also fixes the inconsistency of using MOV to perform a function
> > > return, which is sub-optimal on recent micro-architectures but more
> > > importantly, does not perform an interworking return, unlike compiler
> > > generated function returns in Thumb2 builds.
> > >
> > > Let's fix this by popping PC from the stack like most ordinary code
> > > does.
> > >
> > > Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> > > Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> > > Signed-off-by: Sasha Levin <sashal@kernel.org>
> >
> > Please drop all the 32-bit ARM patches authored by me from the stable
> > queues except the ones that have fixes tags. These are highly likely
> > to cause an explosion of regressions, and they should have never been
> > selected, as I don't remember anyone proposing these for stable.
>
> From what I can tell, that is only this commit.  I'll go drop it from
> all trees, thanks.
>

Ah ok, that's not so bad then. But still better to avoid it.
