Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67796561AFD
	for <lists+stable@lfdr.de>; Thu, 30 Jun 2022 15:06:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233871AbiF3NGu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 09:06:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230305AbiF3NGt (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 09:06:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B307D2018A;
        Thu, 30 Jun 2022 06:06:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5776DB82A7D;
        Thu, 30 Jun 2022 13:06:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32766C34115;
        Thu, 30 Jun 2022 13:06:36 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="jndr58+J"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1656594394;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rGcLJq6zV9jR0Q8DNCiClMyvR+DmkE2AoEf5lAfLL3A=;
        b=jndr58+JS68G0z6dMmPnbyvIl4nJYyZ0b0p4f1Tw1wziWSBSdIgZg+1jmK7kUgww4dPSBp
        zyScPLddoQIWLYM5GAvnqlJpO39aeSxK0L/U/ppgXGc2paL6QWyuD+s+7ZBsiPmhCuczlG
        yvpI9CQ1Sqdt/hs6w7EUPotVlyBY0zY=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 2d9908bd (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Thu, 30 Jun 2022 13:06:34 +0000 (UTC)
Date:   Thu, 30 Jun 2022 15:06:31 +0200
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     tglx@linutronix.de
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        stable@vger.kernel.org, ebiggers@kernel.org
Subject: Re: [PATCH v4] timekeeping: contribute wall clock to rng on time
 change
Message-ID: <Yr2f13QhFsyxdDS7@zx2c4.com>
References: <CAHmME9qGQrgCEGgQpomq6W2EMUy_D5AxqgYHykmmgND+PPVjjw@mail.gmail.com>
 <20220623191249.1357363-1-Jason@zx2c4.com>
 <YrTAt2g4gg/2e+5L@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YrTAt2g4gg/2e+5L@sol.localdomain>
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Thomas,

On Thu, Jun 23, 2022 at 12:36:23PM -0700, Eric Biggers wrote:
> On Thu, Jun 23, 2022 at 09:12:49PM +0200, Jason A. Donenfeld wrote:
> > The rng's random_init() function contributes the real time to the rng at
> > boot time, so that events can at least start in relation to something
> > particular in the real world. But this clock might not yet be set that
> > point in boot, so nothing is contributed. In addition, the relation
> > between minor clock changes from, say, NTP, and the cycle counter is
> > potentially useful entropic data.
> > 
> > This commit addresses this by mixing in a time stamp on calls to
> > settimeofday and adjtimex. No entropy is credited in doing so, so it
> > doesn't make initialization faster, but it is still useful input to
> > have.
> > 
> > Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> > ---
> >  kernel/time/timekeeping.c | 7 ++++++-
> >  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> Reviewed-by: Eric Biggers <ebiggers@google.com>

Thought I should bump this patch in case you missed it.

Jason
