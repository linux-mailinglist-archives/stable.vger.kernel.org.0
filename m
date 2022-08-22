Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC1C359C1FF
	for <lists+stable@lfdr.de>; Mon, 22 Aug 2022 17:01:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234698AbiHVPBX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Aug 2022 11:01:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235826AbiHVPAn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Aug 2022 11:00:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E6B51E3FB
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 08:00:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 968C360FB5
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 15:00:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 609A1C433D6;
        Mon, 22 Aug 2022 15:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661180442;
        bh=3N7NWwYmQcjSInNgVpjn7l+OrM/Cf9onzkkRQTPeT1M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Caj1lb2i2rF0XRq5PKzqMDUJZ7SWHTZDUl5Jf8iGyrwpjNjDeYpb+GM405yg8AwuH
         my+Gd1B24+9H6bGI2XoWpZVL7OyNKJrAGLHC2FLYAGMwVMs7x7Qtknqhbdw8nmeGK1
         QLGkUzg6yr9HgbkRKVqC7yD8QO+x1U5SQlJSjhOI=
Date:   Mon, 22 Aug 2022 17:00:32 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     marcan@marcan.st, arnd@arndb.de, will@kernel.org,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] locking/atomic: Make test_and_*_bit()
 ordered on failure" failed to apply to 5.10-stable tree
Message-ID: <YwOaEI2XV7XiNWzH@kroah.com>
References: <1661089567161107@kroah.com>
 <CAHk-=whSXK98xy6szeyYrG2q7V5TUhk=aaEmU-joB3a8p7EA=Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=whSXK98xy6szeyYrG2q7V5TUhk=aaEmU-joB3a8p7EA=Q@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Aug 21, 2022 at 09:28:52AM -0700, Linus Torvalds wrote:
> On Sun, Aug 21, 2022 at 6:46 AM <gregkh@linuxfoundation.org> wrote:
> >
> > The patch below does not apply to the 5.10-stable tree.
> 
> I think the reason is that "atomic_long_fetch_xyz()" got renamed to
> "arch_atomic_long_fetch_or()" by commit cf3ee3c8c29d ("locking/atomic:
> add generic arch_*() bitops") in the meantime.
> 
> Afaik, the patch should apply by literally just doing
> 
>    sed 's/arch_atomic_long/atomic_long/'
> 
> on the patch before applying it.
> 
> That should fix it all the way back to the 4.19 backport.

That worked, thanks!
