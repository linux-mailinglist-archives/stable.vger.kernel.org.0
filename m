Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D47CA578215
	for <lists+stable@lfdr.de>; Mon, 18 Jul 2022 14:20:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234913AbiGRMUl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jul 2022 08:20:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234365AbiGRMUk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Jul 2022 08:20:40 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D76EE11A3A;
        Mon, 18 Jul 2022 05:20:39 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1658146837;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rgca+W97yGzAdTqNoDPR7Ko97SdqXwVMZUB5c8uEWJk=;
        b=ztSM75orOC4JlQlt1JPaxzlKmSqwhp99+eRE6FDQrv48+DOpQu1q5J8grCdAtOb9+4CEBY
        T3t/n+T5trx8iskWAAb0CK4NMBcLnotlYdEFmqv8I0UrUNDVvU5UcGVjUemfX+0QV084mV
        t9qoZCS9DalbcjQRm5HZTdZxTUYpEmhb82k+c+L1i6ql14623+4G/IqGdQVGJq8vhYThU7
        tJXZDVo726Sm+q1X10bfEX7eULIS1UVW6THb/Ir3URPs2a2dvBxiXJAy+qImDX904abLX/
        thlKEk0MYjp/Q+dYV73OBwFmOoGzIGq3ykoy03VQDFdBU0RB+cuBhLCtWQ9hMw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1658146837;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rgca+W97yGzAdTqNoDPR7Ko97SdqXwVMZUB5c8uEWJk=;
        b=9yNh0e4KcQJ+8gU5vaipj479uYNb5YlVw5BpHXQd40uNhycbj+jo863SgXTZEUuO98tzJi
        emsibGOebRu4lGAg==
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        linux-kernel@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>, stable@vger.kernel.org,
        Eric Biggers <ebiggers@google.com>
Subject: Re: [PATCH v4 RESEND] timekeeping: contribute wall clock to rng on
 time change
In-Reply-To: <20220717215334.221236-1-Jason@zx2c4.com>
References: <Yr2f13QhFsyxdDS7@zx2c4.com>
 <20220717215334.221236-1-Jason@zx2c4.com>
Date:   Mon, 18 Jul 2022 14:20:37 +0200
Message-ID: <87a696wr1m.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jul 17 2022 at 23:53, Jason A. Donenfeld wrote:

> The rng's random_init() function contributes the real time to the rng at
> boot time, so that events can at least start in relation to something
> particular in the real world. But this clock might not yet be set that
> point in boot, so nothing is contributed. In addition, the relation
> between minor clock changes from, say, NTP, and the cycle counter is
> potentially useful entropic data.
>
> This commit addresses this by mixing in a time stamp on calls to
> settimeofday and adjtimex. No entropy is credited in doing so, so it
> doesn't make initialization faster, but it is still useful input to
> have.
>
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Cc: stable@vger.kernel.org
> Reviewed-by: Eric Biggers <ebiggers@google.com>
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>

Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
