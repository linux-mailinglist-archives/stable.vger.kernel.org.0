Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70D8F55D70D
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:17:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239822AbiF1MGo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jun 2022 08:06:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242799AbiF1MGn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Jun 2022 08:06:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CECD3334A;
        Tue, 28 Jun 2022 05:06:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D1CD060F54;
        Tue, 28 Jun 2022 12:05:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51B71C3411D;
        Tue, 28 Jun 2022 12:05:38 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="f87+Ag8P"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1656417936;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LOixUzeTmki9ATEVoZe9cxBT2jfJld9EW2WAc0Tq7RM=;
        b=f87+Ag8PMdM6OshA6cdM+pCANwGl+qs7HJGW1zI88p99tuM1yDfJT97kjLE9zzhIWAeREM
        ZkRUO1gimoWlk/VJ/62t1csWE9mQcU+hDYNh9r3O7f26yGqOL0Vpi6Au6DSDw4g291PJkN
        XxxjEYpDQblRONuuQdb4LpRUQN/Rlg4=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id f0d6a814 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Tue, 28 Jun 2022 12:05:36 +0000 (UTC)
Date:   Tue, 28 Jun 2022 14:05:34 +0200
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Gregory Erwin <gregerwin256@gmail.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Kalle Valo <kvalo@kernel.org>,
        Rui Salvaterra <rsalvaterra@gmail.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH v6] ath9k: sleep for less time when unregistering hwrng
Message-ID: <YrrujrAlLwhzbn0m@zx2c4.com>
References: <20220627113749.564132-1-Jason@zx2c4.com>
 <20220627120735.611821-1-Jason@zx2c4.com>
 <87y1xib8pv.fsf@toke.dk>
 <CAO+Okf5r-rVVqwYiCHXEt_jh0StmVoUikqYfSn7y3QpGZMR3Vg@mail.gmail.com>
 <CAHmME9o4m5MNvDtQUc3OiYLVzNgk3u2i0EF4NhNV4uifZZLJ3g@mail.gmail.com>
 <CAHmME9prgW60P+CO1JSdf5o1hBh8JtciBxcYm25ZO6oTCkwkxg@mail.gmail.com>
 <YrrdTcRCKBt15HLz@gondor.apana.org.au>
 <CAHmME9qm49R6i8Y9LpQXPuxEoTZx2nFSizxX-VEH6UDfLEji1g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAHmME9qm49R6i8Y9LpQXPuxEoTZx2nFSizxX-VEH6UDfLEji1g@mail.gmail.com>
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi again,

On Tue, Jun 28, 2022 at 12:55:57PM +0200, Jason A. Donenfeld wrote:
> > Oh wait you're checking kthread_should_stop before the schedule
> > call instead of afterwards, that would do it.
> 
> Oh, that's a really good observation, thank you! 

Wait, no. I already am kthread_should_stop() it afterwards. That
"continue" goes to the top of the loop, which checks it in the while()
statement. So something else is amiss. I guess I'll investigate.

Jason
