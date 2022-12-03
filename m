Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB84D6415BD
	for <lists+stable@lfdr.de>; Sat,  3 Dec 2022 11:25:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229685AbiLCKZQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 3 Dec 2022 05:25:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbiLCKZP (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 3 Dec 2022 05:25:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8825E4A05A;
        Sat,  3 Dec 2022 02:25:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 28C76B802BE;
        Sat,  3 Dec 2022 10:25:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93045C433C1;
        Sat,  3 Dec 2022 10:25:09 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="OE1z0XMB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1670063106;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=B99/rGGxOgBt2SCG0ilJmP42Uqhic94NePrcyql2Y30=;
        b=OE1z0XMB2PBjouhlOhHQ1424GlPkFJvMb4D+3b+9O03547ABcw8eq7lOWNL27O9hAAzN8E
        e/THcxh1t18VPT9Uzst/p2p5xJ+MpjH2Km7wJtEjXNVf6QMvuPJvCop2WIM76zxmER/cBa
        MLrdEdSPaW+11jEn7cc8GHuhP/j+e4Q=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 6d6b524c (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Sat, 3 Dec 2022 10:25:06 +0000 (UTC)
Date:   Sat, 3 Dec 2022 11:25:02 +0100
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Thorsten Leemhuis <regressions@leemhuis.info>,
        torvalds@linux-foundation.org
Cc:     Jarkko Sakkinen <jarkko@kernel.org>, peterhuewe@gmx.de,
        stable@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>,
        Jan =?utf-8?B?RMSFYnJvxZs=?= <jsd@semihalf.com>,
        linux-integrity@vger.kernel.org, jgg@ziepe.ca,
        gregkh@linuxfoundation.org, arnd@arndb.de, rrangel@chromium.org,
        timvp@google.com, apronin@google.com, mw@semihalf.com,
        upstream@semihalf.com, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH v3] char: tpm: Protect tpm_pm_suspend with locks
Message-ID: <Y4sj/knxLqqF2Tqr@zx2c4.com>
References: <20221128195651.322822-1-Jason@zx2c4.com>
 <9793c74f-2dd0-d510-d8b6-b475e34f3587@leemhuis.info>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <9793c74f-2dd0-d510-d8b6-b475e34f3587@leemhuis.info>
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Thorsten / Linus,

On Fri, Dec 02, 2022 at 10:32:31AM +0100, Thorsten Leemhuis wrote:
> Hi, this is your Linux kernel regression tracker.
> 
> On 28.11.22 20:56, Jason A. Donenfeld wrote:
> 
> BTW, many thx for taking care of this Jason!
> 
> > From: Jan Dabros <jsd@semihalf.com>
> > 
> > Currently tpm transactions are executed unconditionally in
> > tpm_pm_suspend() function, which may lead to races with other tpm
> > accessors in the system. Specifically, the hw_random tpm driver makes
> > use of tpm_get_random(), and this function is called in a loop from a
> > kthread, which means it's not frozen alongside userspace, and so can
> > race with the work done during system suspend:
> 
> Peter, Jarkko, did you look at this patch or even applied it already to
> send it to Linus soon? Doesn't look like it from here, but maybe I
> missed something.
> 
> Thing is: the linked regression afaics is overdue fixing (for details
> see "Prioritize work on fixing regressions" in
> https://www.kernel.org/doc/html/latest/process/handling-regressions.html
> ). Hence if this doesn't make any progress I'll likely have to point
> Linus to this patch and suggest to apply it directly if it looks okay
> from his perspective.

I'm very concerned about this. Jan posted the original fix a month ago,
and then it fizzled out. Then I got word of the bug last week and
revived the fix [1], while also figuring out how to reproduce it
together with the reporter. I emailed the tpm maintainers offlist to
poke them, and nobody woke up. And tomorrow is rc8 day. Given that this
patch is pretty simple, has been tested to fix an annoying regression,
and that neither of the three maintainers has popped up this week to get
things rolling, I think we should just commit this now anyway, to make
sure it gets in for rc8. This way there's still a solid week of testing.
I'm in general not a big fan of the "nuclear option" of not waiting for
out to lunch maintainers, but given that it is now December 3, it seems
like the right decision.

[1] https://lore.kernel.org/all/20221128195651.322822-1-Jason@zx2c4.com/ 

Jason
