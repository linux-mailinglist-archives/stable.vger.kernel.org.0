Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E2AD4F47F2
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 01:44:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348097AbiDEVXQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 17:23:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1457875AbiDEQyN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 12:54:13 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B7D6326E9;
        Tue,  5 Apr 2022 09:52:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id EC474CE1BE1;
        Tue,  5 Apr 2022 16:52:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B165C385A0;
        Tue,  5 Apr 2022 16:52:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649177532;
        bh=poRB8B2FuBtCIIZNBvi5x128WVA6VtVUiXU61lbpEBY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TG6JZgYEg7jQWabdXKKhw9T+Mlw6+RPQ0sgOsFVe9vRQmqpIcDWKq8onF0ySaaHNX
         r/lYiXkiFnuXcfMLS00lQpn/insSguaeHkwCOw0ycjwkbmK0IZL6zV8+CcEBxPVKMw
         j0c6N9/JuW76fcgMpF9wHudOxTRqkc8AoWHzPyP0=
Date:   Tue, 5 Apr 2022 18:52:09 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.15 746/913] ARM: ftrace: avoid redundant loads or
 clobbering IP
Message-ID: <YkxzuSjVpIyjzdsZ@kroah.com>
References: <20220405070339.801210740@linuxfoundation.org>
 <20220405070402.195698649@linuxfoundation.org>
 <CAMj1kXFL4abn9xg1ZrNpFg54Pmw1Kw8OPbDpMevSjQDNg0r5Pg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXFL4abn9xg1ZrNpFg54Pmw1Kw8OPbDpMevSjQDNg0r5Pg@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 05, 2022 at 12:01:19PM +0200, Ard Biesheuvel wrote:
> On Tue, 5 Apr 2022 at 11:54, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > From: Ard Biesheuvel <ardb@kernel.org>
> >
> > [ Upstream commit d11967870815b5ab89843980e35aab616c97c463 ]
> >
> > Tweak the ftrace return paths to avoid redundant loads of SP, as well as
> > unnecessary clobbering of IP.
> >
> > This also fixes the inconsistency of using MOV to perform a function
> > return, which is sub-optimal on recent micro-architectures but more
> > importantly, does not perform an interworking return, unlike compiler
> > generated function returns in Thumb2 builds.
> >
> > Let's fix this by popping PC from the stack like most ordinary code
> > does.
> >
> > Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> > Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
> Please drop all the 32-bit ARM patches authored by me from the stable
> queues except the ones that have fixes tags. These are highly likely
> to cause an explosion of regressions, and they should have never been
> selected, as I don't remember anyone proposing these for stable.

From what I can tell, that is only this commit.  I'll go drop it from
all trees, thanks.

greg k-h
