Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92B7155FEED
	for <lists+stable@lfdr.de>; Wed, 29 Jun 2022 13:41:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230288AbiF2LlA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jun 2022 07:41:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231370AbiF2Lk6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Jun 2022 07:40:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E0FA3EF34;
        Wed, 29 Jun 2022 04:40:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5D5E661ABC;
        Wed, 29 Jun 2022 11:40:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3387C34114;
        Wed, 29 Jun 2022 11:40:55 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="pDxtBw6x"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1656502854;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CNxXkwtze2gyLyEUtULoRKSzgQuTYXqXAG+m5bX1wsI=;
        b=pDxtBw6xdDJL3Wa1muwS6frh5fa39fWvP1sX7oh3mCLRkLoOl2XjXA+cp2DpJTNsvwGsZz
        1yMqbTi4b/x+ACmJf7e4LY6rncjYZqf9x4DmGI4niqt7DWHdaPHhzADF5LN1K1uCQ38Hdq
        cmbD5/dY4xsGS8ueptBPRhqTI31Jrbk=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 30260718 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Wed, 29 Jun 2022 11:40:54 +0000 (UTC)
Date:   Wed, 29 Jun 2022 13:40:52 +0200
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        Gregory Erwin <gregerwin256@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        Rui Salvaterra <rsalvaterra@gmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH v7] ath9k: let sleep be interrupted when unregistering
 hwrng
Message-ID: <Yrw6RDvSly6Zstb8@zx2c4.com>
References: <20220628151840.867592-1-Jason@zx2c4.com>
 <87pmirakke.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87pmirakke.fsf@toke.dk>
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Toke,

On Wed, Jun 29, 2022 at 11:24:49AM +0200, Toke Høiland-Jørgensen wrote:
> > +			wait = !(filp->f_flags & O_NONBLOCK);
> > +			if (wait && cmpxchg(&current_waiting_reader, NULL, current) != NULL) {
> > +				err = -EINTR;
> > +				goto out_unlock_reading;
> > +			}
> >  			bytes_read = rng_get_data(rng, rng_buffer,
> > -				rng_buffer_size(),
> > -				!(filp->f_flags & O_NONBLOCK));
> > +				rng_buffer_size(), wait);
> > +			if (wait && cmpxchg(&current_waiting_reader, current, NULL) != current)
> > +				synchronize_rcu();
> 
> So this synchronize_rcu() is to ensure the hwrng_unregister() thread has
> exited the rcu_read_lock() section below? Isn't that a bit... creative...
> use of RCU? :)

It's to handle the extreeeeemely unlikely race in which
hwrng_unregister() does its xchg, and then the thread calling
rng_dev_read() entirely exits. In practice, the only way I'm able to
trigger this race is by synthetically adding `msleep()` in the right
spot. But anyway, for that reason, it's only synchronized if that second
cmpxchg indicates that indeed the value was changed out from under us.

> Also, synchronize_rcu() can potentially take a while on a busy system,
> is it OK to call it while holding the mutex?

The reading mutex won't be usable by anything anyway at this point, so I
don't think it matters.

Jason
