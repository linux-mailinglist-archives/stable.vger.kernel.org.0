Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 181E74F6288
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 17:08:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235360AbiDFPB5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 11:01:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235443AbiDFPBt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 11:01:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A54BA2102A8;
        Wed,  6 Apr 2022 04:46:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 078E6B8225B;
        Wed,  6 Apr 2022 11:44:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC284C385A3;
        Wed,  6 Apr 2022 11:44:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649245443;
        bh=NxeimgFKXbpME/i8GbhGeyomnmNXOaXJQCJ3je+GzkE=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Ib9hdNGGYkrCQaXv+Wa1skJOD2XxfidXfz1pqcxFsyXCCzxmlx4Q3Iv3zMczs0oKa
         FQe0DNtq44xqgLu38lKgQlYFw3Ij795WPlkExr4Ro8+jAkTyioR9A9BMIhk91q9J+R
         QabboGRB4qGh2cnlhPER2Onwrw5Q/VSEu3RqX41pc3se7y9sXoIwT3O2RDYpgi6Z8l
         CNg8ObMUpX+4Zv4u9Bk/mM3AAvhsbWPbeyNFTQSoXvExtLE6vXtR5ciAv6Yh1XrMBw
         O1wSUjRp0lg0zIDtO2k54+FomdDRCXHT/n5i7rQLiEC8H5aU6PZ2AIaF9+r4Ajgm4Q
         iJs2PmQtEfQ7A==
Received: by mail-ot1-f52.google.com with SMTP id x8-20020a9d6288000000b005b22c373759so1519896otk.8;
        Wed, 06 Apr 2022 04:44:03 -0700 (PDT)
X-Gm-Message-State: AOAM533HDRs+1aVPN4Log4NvSw4lyrz6mEWkVlB0UFC7qu6e/WVj85nf
        l1xJEwSD2btu6yqjLqvrcQk+d5RhKHpwj0Adn7Q=
X-Google-Smtp-Source: ABdhPJwgIpRNFG6qcoAVBzxDEl4cLier8VLEXG9sCYAAHpDzoTvzxVWsFwYD+jTe+LzI54KUubxiebLt/6VhtToTqKA=
X-Received: by 2002:a05:6830:2e7:b0:5b2:68c1:182a with SMTP id
 r7-20020a05683002e700b005b268c1182amr2838747ote.71.1649245442897; Wed, 06 Apr
 2022 04:44:02 -0700 (PDT)
MIME-Version: 1.0
References: <20220405070339.801210740@linuxfoundation.org> <20220405070402.195698649@linuxfoundation.org>
 <CAMj1kXFL4abn9xg1ZrNpFg54Pmw1Kw8OPbDpMevSjQDNg0r5Pg@mail.gmail.com> <Yk14LhswMSlPGrmJ@sashalap>
In-Reply-To: <Yk14LhswMSlPGrmJ@sashalap>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Wed, 6 Apr 2022 13:43:51 +0200
X-Gmail-Original-Message-ID: <CAMj1kXHxGjO9ctZ5kSd0MZztOTZz8j02rTPJgPdANODqUH5JGg@mail.gmail.com>
Message-ID: <CAMj1kXHxGjO9ctZ5kSd0MZztOTZz8j02rTPJgPdANODqUH5JGg@mail.gmail.com>
Subject: Re: [PATCH 5.15 746/913] ARM: ftrace: avoid redundant loads or
 clobbering IP
To:     Sasha Levin <sashal@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
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

On Wed, 6 Apr 2022 at 13:23, Sasha Levin <sashal@kernel.org> wrote:
>
> On Tue, Apr 05, 2022 at 12:01:19PM +0200, Ard Biesheuvel wrote:
> >On Tue, 5 Apr 2022 at 11:54, Greg Kroah-Hartman
> ><gregkh@linuxfoundation.org> wrote:
> >>
> >> From: Ard Biesheuvel <ardb@kernel.org>
> >>
> >> [ Upstream commit d11967870815b5ab89843980e35aab616c97c463 ]
> >>
> >> Tweak the ftrace return paths to avoid redundant loads of SP, as well as
> >> unnecessary clobbering of IP.
> >>
> >> This also fixes the inconsistency of using MOV to perform a function
> >> return, which is sub-optimal on recent micro-architectures but more
> >> importantly, does not perform an interworking return, unlike compiler
> >> generated function returns in Thumb2 builds.
> >>
> >> Let's fix this by popping PC from the stack like most ordinary code
> >> does.
> >>
> >> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> >> Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> >> Signed-off-by: Sasha Levin <sashal@kernel.org>
> >
> >Please drop all the 32-bit ARM patches authored by me from the stable
> >queues except the ones that have fixes tags. These are highly likely
>
> I can drop you from future selections as well.
>

Yes, please. Just disregard all of my patches, unless they have a
fixes or cc:stable, or someone suggests them explicitly.

> >to cause an explosion of regressions, and they should have never been
> >selected, as I don't remember anyone proposing these for stable.
>
> They were proposed by the bot last week
> (https://lore.kernel.org/lkml/20220330115005.1671090-22-sashal@kernel.org/).
>

Yeah, we should really not be using a bot for that.
