Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 806E820E966
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 01:35:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726841AbgF2XeM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 19:34:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726291AbgF2XeL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Jun 2020 19:34:11 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCE5BC03E979
        for <stable@vger.kernel.org>; Mon, 29 Jun 2020 16:34:11 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id i4so8685787pjd.0
        for <stable@vger.kernel.org>; Mon, 29 Jun 2020 16:34:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dabbelt-com.20150623.gappssmtp.com; s=20150623;
        h=date:subject:in-reply-to:cc:from:to:message-id:mime-version
         :content-transfer-encoding;
        bh=Hg4NcTCj/IpKtz7wajO6KOiH6Qh4hIgKqaxhF9d2K/Y=;
        b=RX9BaxYF4c36rrH3fZ1WkWZFU/gGAw817z2vWTfYSuQf1p9IDNfZrcvAjhuo3olA9y
         oKplBpngaTSAtUmcLlARTdE5t2NAY4sE/Bxo7St9RETviaRPdLKgMgImUusuRBm1em6L
         xFzA9hlwtK6Y8VtfTNeVf8FRa0ppBhMFEXN4MKbKo55+OBAHE7v4I1qvLOsuYB0R7ZXt
         CVQfdZL9tqEbPG4rA9LCYTyZOR8bpTZZvNDFTf/SBtUA8y+uyjqOspxkD+Yz0845l9nC
         oGhNqZ+AihyPlUXQpiO4dL+2wPkgnoarJZTNKIo4Oz30xV1Rr6l9O0veq0iuxSttxXAT
         FJ7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:subject:in-reply-to:cc:from:to:message-id
         :mime-version:content-transfer-encoding;
        bh=Hg4NcTCj/IpKtz7wajO6KOiH6Qh4hIgKqaxhF9d2K/Y=;
        b=PAAvmBdbav9kcVPLbJ52u6Aa4UaJT+CsQHzXktsVvlV53GK1uhYqbRE0PJfKq2dHj+
         aI9SfkC0SFnUI6uNTS3ar1A84KjIs3lnE7Pb3iJ9f2qe+95SiHmj0Ke0zVsQQCRVmW7t
         PIlUSQVamqE61pp1BJxs6D0XX/iMjV/gIeRE/2/EudtJjkmA1SjjEQ8nUVxkrrhmAgmK
         iDyA7fumi5mQTmOqr48zyPMtjGtcFckfbPw00hEmbHmz5v2v639++OutqkiJRoh63QQq
         tcJYjmS8eQB/9RB0qizjxP7fygTkVNniUzp6KENQiSlWEZ4UN54e5s1zxdD7tBUV+Wca
         1F5A==
X-Gm-Message-State: AOAM531QigCANTZYiaEJ0PCaujzTRDCi+mFr44YdpoiEbqa2+2gKzTEe
        ExcNBufmhN98vlKJEOxvXhBoDg==
X-Google-Smtp-Source: ABdhPJyeXKsR9/YkJWUi1Eb9n61S2PLpkQv/VrGe7uSNFC57NxbCXC6ZwbfII55jb66BZ7S8+q0iWQ==
X-Received: by 2002:a17:90b:3d7:: with SMTP id go23mr19731077pjb.157.1593473651120;
        Mon, 29 Jun 2020 16:34:11 -0700 (PDT)
Received: from localhost (76-210-143-223.lightspeed.sntcca.sbcglobal.net. [76.210.143.223])
        by smtp.gmail.com with ESMTPSA id n189sm653777pfn.108.2020.06.29.16.34.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2020 16:34:10 -0700 (PDT)
Date:   Mon, 29 Jun 2020 16:34:10 -0700 (PDT)
X-Google-Original-Date: Mon, 29 Jun 2020 16:34:08 PDT (-0700)
Subject:     Re: [PATCH] clk: sifive: allocate sufficient memory for struct __prci_data
In-Reply-To: <159347302727.1987609.17461999827407726291@swboyd.mtv.corp.google.com>
CC:     vincent.chen@sifive.com, mturquette@baylibre.com,
        Paul Walmsley <paul.walmsley@sifive.com>,
        linux-riscv@lists.infradead.org, schwab@suse.de,
        vincent.chen@sifive.com, stable@vger.kernel.org
From:   Palmer Dabbelt <palmer@dabbelt.com>
To:     sboyd@kernel.org
Message-ID: <mhng-f15789ef-8446-4dbe-a483-19d2f6c37b96@palmerdabbelt-glaptop1>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 29 Jun 2020 16:23:47 PDT (-0700), sboyd@kernel.org wrote:
> Quoting Palmer Dabbelt (2020-06-25 15:13:39)
>> On Mon, 22 Jun 2020 18:24:17 PDT (-0700), vincent.chen@sifive.com wrote:
>> > The (struct __prci_data).hw_clks.hws is an array with dynamic elements.
>> > Using struct_size(pd, hw_clks.hws, ARRAY_SIZE(__prci_init_clocks))
>> > instead of sizeof(*pd) to get the correct memory size of
>> > struct __prci_data for sifive/fu540-prci. After applying this
>> > modifications, the kernel runs smoothly with CONFIG_SLAB_FREELIST_RANDOM
>> > enabled on the HiFive unleashed board.
>> >
>> > Fixes: 30b8e27e3b58 ("clk: sifive: add a driver for the SiFive FU540 PRCI IP block")
>> > Cc: stable@vger.kernel.org
>> > Signed-off-by: Vincent Chen <vincent.chen@sifive.com>
>> > ---
>> >  drivers/clk/sifive/fu540-prci.c | 5 ++++-
>> >  1 file changed, 4 insertions(+), 1 deletion(-)
>> >
>> > diff --git a/drivers/clk/sifive/fu540-prci.c b/drivers/clk/sifive/fu540-prci.c
>> > index 6282ee2f361c..a8901f90a61a 100644
>> > --- a/drivers/clk/sifive/fu540-prci.c
>> > +++ b/drivers/clk/sifive/fu540-prci.c
>> > @@ -586,7 +586,10 @@ static int sifive_fu540_prci_probe(struct platform_device *pdev)
>> >       struct __prci_data *pd;
>> >       int r;
>> >
>> > -     pd = devm_kzalloc(dev, sizeof(*pd), GFP_KERNEL);
>> > +     pd = devm_kzalloc(dev,
>> > +                       struct_size(pd, hw_clks.hws,
>> > +                                   ARRAY_SIZE(__prci_init_clocks)),
>> > +                       GFP_KERNEL);
>> >       if (!pd)
>> >               return -ENOMEM;
>> 
>> This is on fixes, thanks!
>
> Does that mean applied to sifive tree? I see it in next but only noticed
> this by chance because it wasn't sent to the linux-clk mailing list.

Sorry, I was going a bit too fast and didn't realize this wasn't in arch/riscv/
so I didn't wait for an ack.  I put it on my fixes branch, which is what I sent
for the RCs.  That's merged into linux-next as well, as far as I understand
that's the normal way to do things.  It ended up in Linus' tree as d0a5fdf4cc83
("clk: sifive: allocate sufficient memory for struct __prci_data"), which is in
rc3.

We don't really have a SiFive tree, the SiFive stuff just goes in through the
RISC-V tree.  In theory I've been meaning to split them up for a while, but
given the maintainers are the same I just never got around to doing so.

LMK if I screwed something up.
