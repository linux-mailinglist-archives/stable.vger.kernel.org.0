Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74E0A53685E
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 23:10:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352765AbiE0VKr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 17:10:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351372AbiE0VKq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 17:10:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 079E6132A14;
        Fri, 27 May 2022 14:10:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B7364B8263F;
        Fri, 27 May 2022 21:10:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4291C385A9;
        Fri, 27 May 2022 21:10:41 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="n2VZbk1b"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1653685840;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IKwI7jUD4cp6DNyjvmyEnFFzr0sjgKK8xxrfvUi+/Do=;
        b=n2VZbk1br7hz83V4nYy2OCr7rbuD3zY7XrDuj8//toCCr/zFp/XD9lsW6AeffFBfOc324Z
        GsCMIY3qHr+jDNxiatMV0adQidjuVGJIhWqjKcvaSEBUhzQXreNtl09BxBMAUK/CFhKr6a
        +vkKw0y6iuJVmRhy3mrnIX8Mqd8FtAQ=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id ac0b28ae (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Fri, 27 May 2022 21:10:39 +0000 (UTC)
Date:   Fri, 27 May 2022 23:10:35 +0200
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pavel Machek <pavel@denx.de>, Chris.Paterson2@renesas.com,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.10 000/163] 5.10.119-rc1 review
Message-ID: <YpE+S2H301IsZYzv@zx2c4.com>
References: <20220527084828.156494029@linuxfoundation.org>
 <20220527141421.GA13810@duo.ucw.cz>
 <YpD0CVWSiEqiM+8b@kroah.com>
 <6aed0c5c-bb99-0593-1609-87371db26f44@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <6aed0c5c-bb99-0593-1609-87371db26f44@roeck-us.net>
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Guenter,

On Fri, May 27, 2022 at 09:59:14AM -0700, Guenter Roeck wrote:
> Given that we (ChromeOS) have been hit by rng related
> issues before (specifically boot stalls on some hardware), I am quite
> concerned about the possible impact of this series for stable releases.

The urandom try_to_generate_entropy() change from 5.18 wasn't backported.

zx2c4@thinkpad ~/Projects/random-linux $ git diff linux-5.10.y:drivers/char/random.c master:drivers/char/random.c
[...snip...]
@@ -1292,6 +1311,13 @@ static ssize_t urandom_read_iter(struct kiocb *kiocb, struct iov_iter *iter)
 {
        static int maxwarn = 10;

+       /*
+        * Opportunistically attempt to initialize the RNG on platforms that
+        * have fast cycle counters, but don't (for now) require it to succeed.
+        */
+       if (!crng_ready())
+               try_to_generate_entropy();
+
        if (!crng_ready()) {
                if (!ratelimit_disable && maxwarn <= 0)
                        ++urandom_warning.missed;



Jason
