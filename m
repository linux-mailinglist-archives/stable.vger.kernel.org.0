Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAB4B47AFD8
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 16:20:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238006AbhLTPUd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 10:20:33 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:60322 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239302AbhLTPSO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 10:18:14 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 77C0461190;
        Mon, 20 Dec 2021 15:18:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88570C36AE8;
        Mon, 20 Dec 2021 15:18:12 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="P7CYKn6k"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1640013491;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=F8ik6QrEQpDn1qXmwY+KLe33CGrNivJ5Pk7P4AGfTy0=;
        b=P7CYKn6kmkakrryHojCHqY1uXYTASM7dtryQfFLE4N/XK0F7dtUTvTCJSd0nZNAaLxNYcy
        IEyk77xKiVl0QNEwRR+HXolYYJFyfJn+aHQEpqxWBL0PWRiianSZ7AGFnv2jssY0PCVsU9
        pQYvuoWC0USUWBsggBhqZBK6yA7P+gI=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id e5522b61 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Mon, 20 Dec 2021 15:18:11 +0000 (UTC)
Received: by mail-yb1-f172.google.com with SMTP id d10so29956027ybn.0;
        Mon, 20 Dec 2021 07:18:11 -0800 (PST)
X-Gm-Message-State: AOAM532d9u7bkLTuUM6K6Iv5f9qXV4mic9RQN0Pgf22lpJidHVtLUh75
        nfJ1W1abBKBX6c8Zwt2qRZ52LDBvRlVCDBDFsCE=
X-Google-Smtp-Source: ABdhPJwmcrnEeXzWM/ULVbe4B3+WIbv8ElBUmZDovSBE+U2qaLLqgs/Pm8YcdOcJ3mG1GTYkW2Gam8Zn/9HgADRn6QA=
X-Received: by 2002:a25:1e83:: with SMTP id e125mr22905671ybe.32.1640013490463;
 Mon, 20 Dec 2021 07:18:10 -0800 (PST)
MIME-Version: 1.0
References: <20211219025139.31085-1-ebiggers@kernel.org>
In-Reply-To: <20211219025139.31085-1-ebiggers@kernel.org>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Mon, 20 Dec 2021 16:17:59 +0100
X-Gmail-Original-Message-ID: <CAHmME9p_TwQntnDu8y0RkxweVMe=4OmNyxcDcEvc-6tAkYDRGw@mail.gmail.com>
Message-ID: <CAHmME9p_TwQntnDu8y0RkxweVMe=4OmNyxcDcEvc-6tAkYDRGw@mail.gmail.com>
Subject: Re: [PATCH RESEND] random: use correct memory barriers for crng_node_pool
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     "Theodore Ts'o" <tytso@mit.edu>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Dec 19, 2021 at 3:52 AM Eric Biggers <ebiggers@kernel.org> wrote:
> +
> +static inline struct crng_state *select_crng(void)
> +{
> +
> +static inline struct crng_state *select_crng(void)
> +{

Usually static inline is avoided in .c files. Any special reason why
we'd need this especially much here? Those functions are pretty small
and I assume will be inlined anyway on most architectures.

I just did a test on x86_64 with GCC 11, and the same file was
produced with 'static' as with 'static inline'. Was there an
arch/config/compiler combo you were concerned about here?

Jason
