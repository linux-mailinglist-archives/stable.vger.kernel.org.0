Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C956155A59C
	for <lists+stable@lfdr.de>; Sat, 25 Jun 2022 02:42:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231144AbiFYAkT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jun 2022 20:40:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230355AbiFYAkS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Jun 2022 20:40:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C195766BF;
        Fri, 24 Jun 2022 17:40:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9AC7561BF7;
        Sat, 25 Jun 2022 00:40:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79C7AC341C0;
        Sat, 25 Jun 2022 00:40:16 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="TfEub4LW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1656117614;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=S7X90idJ9rXzD5pTzKHAJDruFCM590yA3AopBZB2zIk=;
        b=TfEub4LWJ1iZSvkev72tKmSqVZBkJowsDuBYF4QD9poG0P3o5rcMOtaryPqNM5x39DLZQP
        cq3jMTxZ96IcE+L+0sEhawroAAOYcbQ7VLwmOfvO8oG2Djm86KFMScHR7pm9U7iRaQbpfU
        EFQ8gxct0oo8xhqsnsuZL5ctPhCrKpM=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id d67b303f (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Sat, 25 Jun 2022 00:40:13 +0000 (UTC)
Received: by mail-il1-f173.google.com with SMTP id 9so2524565ill.5;
        Fri, 24 Jun 2022 17:40:13 -0700 (PDT)
X-Gm-Message-State: AJIora8GS6kqYoLvFhdKKm8GdTlNBoVH1XtsqULIFuVI0aII6ximKI4k
        dPd72kFSJ/8Fver2/Myw5IVbYR1/Npj3G7k5ztY=
X-Google-Smtp-Source: AGRyM1vNCccuTjgcvumRTFVKAtjIBanPWQrL4I7MTC2RKRd4J1EbLkyNHgMe8r0FvrFC7QWrfhWKfNAh0ND3uIuo940=
X-Received: by 2002:a05:6e02:20c6:b0:2d8:e62f:349f with SMTP id
 6-20020a056e0220c600b002d8e62f349fmr935894ilq.160.1656117612299; Fri, 24 Jun
 2022 17:40:12 -0700 (PDT)
MIME-Version: 1.0
References: <YrYMqqqoK7HBAXgJ@zx2c4.com> <20220624204433.2371980-1-Jason@zx2c4.com>
 <CAO+Okf7z0EQN19N_g=pLq71GY+pNejAWEQQDG5VsX=z=J3EM5A@mail.gmail.com>
In-Reply-To: <CAO+Okf7z0EQN19N_g=pLq71GY+pNejAWEQQDG5VsX=z=J3EM5A@mail.gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Sat, 25 Jun 2022 02:40:01 +0200
X-Gmail-Original-Message-ID: <CAHmME9o0MKz3zA3BejM7h7PBOEXFxER626z_VnQMvKBA3m3prg@mail.gmail.com>
Message-ID: <CAHmME9o0MKz3zA3BejM7h7PBOEXFxER626z_VnQMvKBA3m3prg@mail.gmail.com>
Subject: Re: [PATCH v2] ath9k: sleep for less time when unregistering hwrng
To:     Gregory Erwin <gregerwin256@gmail.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Kalle Valo <kvalo@kernel.org>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Rui Salvaterra <rsalvaterra@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        stable <stable@vger.kernel.org>
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

Hi Gregory,

On Sat, Jun 25, 2022 at 2:13 AM Gregory Erwin <gregerwin256@gmail.com> wrote:
> This patch is working as you described. Trying to read from /dev/hwrng
> consistently blocks for only 1.3s before returning an IO error. The longest
> that I observed 'ip link set wlan0 down' to block was also about 1.3s,
> and that was immediately after 'cat /dev/hwrng'. Additionally, the longest
> duration that I observed for wiphy_suspend() to return was just under 100ms.
>
> Tested-by: Gregory Erwin <gregerwin256@gmail.com>

Great, thanks for testing. I think that barring more invasive changes
to the hwrng subsystem, a heuristic approach like this is the best
we're going to do inside the ath9k driver itself.

So Toke/Kalle - can you queue this up?

Jason
