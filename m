Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69ACF4EA723
	for <lists+stable@lfdr.de>; Tue, 29 Mar 2022 07:31:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232020AbiC2Fdb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Mar 2022 01:33:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231612AbiC2Fda (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Mar 2022 01:33:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3A92232D19;
        Mon, 28 Mar 2022 22:31:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 845A2B80E5E;
        Tue, 29 Mar 2022 05:31:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1B19C34100;
        Tue, 29 Mar 2022 05:31:44 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="bD1y1M7K"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1648531901;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0DnQZrbeMIl/jPEL4/NKQa5kO0JP14Wyo3i+LOhThwg=;
        b=bD1y1M7KWSGBLRw4W/83PYO7ezAjW2nCVq+4u4ERRn0NWFsjB0xmgVFtAUyMNo52PISYxg
        GCfBDbH8ifjATEh7Y/zQILB5PEyxSLgjC1Od2h56OxOOQ64ejsHgOGrWSB3Jo7LPweEVDT
        f+GGhIY5+oPosV/+6BJdi3QH/hrulK8=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id b2f47cc8 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Tue, 29 Mar 2022 05:31:41 +0000 (UTC)
Received: by mail-yb1-f179.google.com with SMTP id e203so20884929ybc.12;
        Mon, 28 Mar 2022 22:31:40 -0700 (PDT)
X-Gm-Message-State: AOAM530IzVIaO3kQsFoXa/gaMLMcsFixM0jYuGgNXAqcTVj/NnBpDVKx
        Heqva2c4x+Y4Tw30M4X84DjpR653RhjbEOfkTKk=
X-Google-Smtp-Source: ABdhPJwFAnSwrfSjbcLI6+p0f1ulm4t4V/JJ5gZl8ZD3byHHDsFzm9CK1g3baSj456k5LxpPylLbJ2gSKU/8vedAUUU=
X-Received: by 2002:a25:2517:0:b0:634:63cb:68fe with SMTP id
 l23-20020a252517000000b0063463cb68femr25915454ybl.271.1648531900027; Mon, 28
 Mar 2022 22:31:40 -0700 (PDT)
MIME-Version: 1.0
References: <20220328111828.1554086-1-sashal@kernel.org> <20220328111828.1554086-16-sashal@kernel.org>
 <YkH5mhYokPB87FtE@google.com>
In-Reply-To: <YkH5mhYokPB87FtE@google.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Tue, 29 Mar 2022 01:31:29 -0400
X-Gmail-Original-Message-ID: <CAHmME9oTiJ5ZTtsecisOp7cLurm+r0gOtPSozgPvr+phDjiACQ@mail.gmail.com>
Message-ID: <CAHmME9oTiJ5ZTtsecisOp7cLurm+r0gOtPSozgPvr+phDjiACQ@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 5.17 16/43] random: use computational hash for
 entropy extraction
To:     Eric Biggers <ebiggers@google.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>, "Theodore Ts'o" <tytso@mit.edu>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sasha,

On Mon, Mar 28, 2022 at 2:08 PM Eric Biggers <ebiggers@google.com> wrote:
>
> On Mon, Mar 28, 2022 at 07:18:00AM -0400, Sasha Levin wrote:
> > From: "Jason A. Donenfeld" <Jason@zx2c4.com>
> >
> > [ Upstream commit 6e8ec2552c7d13991148e551e3325a624d73fac6 ]
> >
>
> I don't think it's a good idea to start backporting random commits to random.c
> that weren't marked for stable.  There were a lot of changes in v5.18, and
> sometimes they relate to each other in subtle ways, so the individual commits
> aren't necessarily safe to pick.
>
> IMO, you shouldn't backport any non-stable-Cc'ed commits to random.c unless
> Jason explicitly reviews the exact sequence of commits that you're backporting.

I'm inclined to agree with Eric here that you might be a bit careful
about autosel'ing 5.18, given how extensive the changes were. In
theory they should all be properly sequenced so that nothing breaks,
but I'd still be cautious. However, if you want, maybe we can work out
some plan for backporting. I'll take a look and maybe will ping you on
IRC about it.

Jason
