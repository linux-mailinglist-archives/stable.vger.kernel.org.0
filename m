Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E58B553592B
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 08:14:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238131AbiE0GOD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 02:14:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232773AbiE0GOD (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 02:14:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 945FE5DA4C
        for <stable@vger.kernel.org>; Thu, 26 May 2022 23:14:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B1CBB6137A
        for <stable@vger.kernel.org>; Fri, 27 May 2022 06:14:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86B61C385A9;
        Fri, 27 May 2022 06:14:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653632040;
        bh=vQUsHdJf3tnyRh6Qz+01XIYTazxP6dpLdW8jw9fvCNY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=E+2be1k9HHhJqiqBZYxQRTBY+iAukKGQFE7numTnZ5TeEOja2LvYbboMK/PivDGyp
         GXw9s06kjT5w6fSEPnLxV2b/WNBC2xFy6EUQORFprZ1J//Xnk2YOMG7W53hO+jseB4
         4k7QZPnGkQyuKGurifyjJ+pKYkuWOne5Kz2Z42wQ=
Date:   Fri, 27 May 2022 08:13:57 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Sasha Levin <sashal@kernel.org>, stable <stable@vger.kernel.org>
Subject: Re: random.c backports for 5.18, 5.17, 5.15, and prior
Message-ID: <YpBsJRiZtCEH4hC8@kroah.com>
References: <YouECCoUA6eZEwKf@zx2c4.com>
 <YouNwkU/8+hRwz9s@kroah.com>
 <Yo+SOpVZisR8iGG1@kroah.com>
 <CAHmME9oHuKcokorkRt9x264Be612Sh2iQrELveAzL1Yz6dhy5w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHmME9oHuKcokorkRt9x264Be612Sh2iQrELveAzL1Yz6dhy5w@mail.gmail.com>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 26, 2022 at 05:15:12PM +0200, Jason A. Donenfeld wrote:
> Hi Greg,
> 
> On Thu, May 26, 2022 at 4:44 PM Greg KH <gregkh@linuxfoundation.org> wrote:
> > I get build errors in the 5.15 and 5.10 trees when applying these
> > patches.
> >
> > Here's the 5.10 error:
> > In file included from ../crypto/testmgr.c:32:
> > ../include/crypto/drbg.h:139:38: error: field 'random_ready' has incomplete type
> >   139 |         struct random_ready_callback random_ready;
> >       |                                      ^~~~~~~~~~~~
> >
> >
> > And the same error in 5.15.
> >
> > So obviously I can't take them, I'm doing a simple 'make allmodconfig'
> > build for these trees on x86-64.
> 
> Sorry about that. I've fixed the broken backport (of "random: replace
> custom notifier chain with standard one") and force pushed
> linux-5.10.y and linux-5.15.y branches.

All now queued up.

These are big changes overall, but as you've broken them up into the
original bits, they seem semi-sane.  Let's see how the testing goes on
them...

thanks,

greg k-h
