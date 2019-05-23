Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA22428B89
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 22:31:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387920AbfEWUbb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 16:31:31 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58861 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387531AbfEWUba (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 May 2019 16:31:30 -0400
Received: from mail-wr1-f70.google.com ([209.85.221.70])
        by youngberry.canonical.com with esmtps (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <guilherme.piccoli@canonical.com>)
        id 1hTuN6-0007vx-Nh
        for stable@vger.kernel.org; Thu, 23 May 2019 20:31:28 +0000
Received: by mail-wr1-f70.google.com with SMTP id q2so2630909wrr.18
        for <stable@vger.kernel.org>; Thu, 23 May 2019 13:31:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0dW+h03iOHL9hXzrG72krYhdVbEtg0vyFtbtFz1jJYI=;
        b=b57j1EGLQFqZxeAIm/ED1bGMTwjjzPJanP/oYml49j//ixQmcOBbGpKesMQeyMq2li
         Xr2NuQpBHhkZ6JwAj6gwl4L2zrUiDEx17dpN2X6FdquCUZZgBOLpQoJma8dk6KJwZ6dC
         SAHISpkQdiDePnX/ndQSHHrYByoTc9Mz5VQ1I2QVF//lxZmQodNIA/JVnBFv/2cNeohb
         ECEKa+IYKXnfaBmGH93w1602COaY6soiadxX3hdvZXqQ16dgxcNGZqWRPviL/tOG9jwa
         ItyvOKpxiR83UF9wUFAdEca5YHevOCO+SR63lKltgqhJthp46O5P86ZAXi0J5cnlOOle
         itRA==
X-Gm-Message-State: APjAAAVP2gkXhqPW3hGMviUKxekCBmYBDWLKAXpbz3DKTaslzjDoGn/j
        FDEz3SYUo1qc+YqG8LloQdDqNqm2XjKqMu9sVIK47Sthy4/26RO/ia2HOK2dx+pb1M8fNyUBTXA
        MhtdLFica5x58v7CT8SLfDbCsIV5XKId9aNY3ZM+VulUN9wuXlw==
X-Received: by 2002:a1c:7d8e:: with SMTP id y136mr12828720wmc.129.1558643488518;
        Thu, 23 May 2019 13:31:28 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxzZrVtJmlEUBWpf3yRAcENU+Y5IToKvqA0uAnb6p0nV/TUnSml7P2OrLKKphRhi6bSed9/gBVCt8Ff7XZ2eEU=
X-Received: by 2002:a1c:7d8e:: with SMTP id y136mr12828709wmc.129.1558643488390;
 Thu, 23 May 2019 13:31:28 -0700 (PDT)
MIME-Version: 1.0
References: <20190520220911.25192-1-gpiccoli@canonical.com>
 <CAPhsuW6KayaNR-0eFHpvPG-LVuPFL_1OFjvZpOcnapVFe2vC9Q@mail.gmail.com>
 <3e583b2d-742a-3238-69ed-7a2e6cce417b@canonical.com> <CAPhsuW7o9bj5DYnUDkCqDeW7NnfNTSBBWJC5_ZVxhoomDEEJcg@mail.gmail.com>
In-Reply-To: <CAPhsuW7o9bj5DYnUDkCqDeW7NnfNTSBBWJC5_ZVxhoomDEEJcg@mail.gmail.com>
From:   Guilherme Piccoli <gpiccoli@canonical.com>
Date:   Thu, 23 May 2019 17:30:52 -0300
Message-ID: <CAHD1Q_zCkmiDN24Njjr5Nfuc11hSxN5fgw98MX9j5LJoiwgXPA@mail.gmail.com>
Subject: Re: [PATCH V2 1/2] block: Fix a NULL pointer dereference in generic_make_request()
To:     Song Liu <liu.song.a23@gmail.com>
Cc:     linux-block@vger.kernel.org,
        linux-raid <linux-raid@vger.kernel.org>, dm-devel@redhat.com,
        Jens Axboe <axboe@kernel.dk>,
        Gavin Guo <gavin.guo@canonical.com>,
        Jay Vosburgh <jay.vosburgh@canonical.com>,
        "Guilherme G. Piccoli" <kernel@gpiccoli.net>,
        stable@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Ming Lei <ming.lei@redhat.com>,
        Eric Ren <renzhengeek@gmail.com>,
        Christoph Hellwig <hch@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 23, 2019 at 2:06 PM Song Liu <liu.song.a23@gmail.com> wrote:
>
>
> Sorry for the confusion and delay. I will send patches to stable@.
>
> Song


Hi Song, no problem at all! Thanks a lot for the clarification.
Cheers,


Guilherme
