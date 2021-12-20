Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39C4C47B2B7
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 19:17:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240343AbhLTSRE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 13:17:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236184AbhLTSRE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 13:17:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27A1AC061574;
        Mon, 20 Dec 2021 10:17:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7F8A16127D;
        Mon, 20 Dec 2021 18:17:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B949C36AE2;
        Mon, 20 Dec 2021 18:17:02 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="akD1bjA2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1640024221;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FCVwvnkm9fI07dSfjsYyMXgN/q0HPamfYTNYYqD66eE=;
        b=akD1bjA2u7JI8OP/j5HFbYwxVl6VmewYTAdC79TzSq6ulr4lk9gEwNpQ5iSqw4QxwnDfkl
        ic9ZDjQOvsDQpR2DnNA5f8dJpkXD0nYi6Vl1qb7KjYHMrJkNte87LNcKF/pw7vgZlPUq+i
        fBUALUFYSHylvYJRyeAn/zmxfwc0yjo=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 0c730aaf (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Mon, 20 Dec 2021 18:17:01 +0000 (UTC)
Received: by mail-yb1-f181.google.com with SMTP id d10so31411447ybe.3;
        Mon, 20 Dec 2021 10:17:00 -0800 (PST)
X-Gm-Message-State: AOAM532tiIo2zbcoOPh4DSgapLphPL4ighnSXS+rA8pXaX+m7yrK6Iwf
        zg1utxcsoXe6IyfoksI90nfZILUqNL4FnXwZoKk=
X-Google-Smtp-Source: ABdhPJywVvgbmxTIFkZjHFLIj2A9OeATX659iaGZaVyuGC+lcsukwRs0mbbXClRz3G8Lz8OYH4ggd1Ga3/565q0p6cM=
X-Received: by 2002:a25:d393:: with SMTP id e141mr26681402ybf.255.1640024220119;
 Mon, 20 Dec 2021 10:17:00 -0800 (PST)
MIME-Version: 1.0
References: <20211219025139.31085-1-ebiggers@kernel.org> <CAHmME9pQ4vp0jHpOyQXHRbJ-xQKYapQUsWPrLouK=dMO56y1zA@mail.gmail.com>
 <20211220181115.GZ641268@paulmck-ThinkPad-P17-Gen-1>
In-Reply-To: <20211220181115.GZ641268@paulmck-ThinkPad-P17-Gen-1>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Mon, 20 Dec 2021 19:16:48 +0100
X-Gmail-Original-Message-ID: <CAHmME9qZDNz2uxPa13ZtBMT2RR+sP1OU=b73tcZ9BTD1T_MJOg@mail.gmail.com>
Message-ID: <CAHmME9qZDNz2uxPa13ZtBMT2RR+sP1OU=b73tcZ9BTD1T_MJOg@mail.gmail.com>
Subject: Re: [PATCH RESEND] random: use correct memory barriers for crng_node_pool
To:     "Paul E . McKenney" <paulmck@kernel.org>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 20, 2021 at 7:11 PM Paul E. McKenney <paulmck@kernel.org> wrote:
> First I would want

It looks like you've answered my question with four other questions,
which seem certainly technically warranted, but also indicates we're
probably not going to get to the nice easy resting place of, "it is
safe; go for it" that I was hoping for. In light of that, it seems
like merging Eric's patch is reasonable.

Jason
