Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8451047B025
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 16:26:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239765AbhLTP0T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 10:26:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240104AbhLTPZm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 10:25:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36824C09B134;
        Mon, 20 Dec 2021 07:07:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C35FC61183;
        Mon, 20 Dec 2021 15:07:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA3E1C36AE9;
        Mon, 20 Dec 2021 15:07:41 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="aPupP9kj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1640012860;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oAsc3YprQ6FgGJHxcPGw3/DqBtjZ2J9beUNauVhWwbA=;
        b=aPupP9kj75WK/PtqIMzBZs4KjIxMNGRfWfqMHhaThLM8xvIrcxMNa/LovCtPjZHKP75I/c
        KbGrRuriDWF5dWYuPYO2Ovn38U9Ku1VCMHEZnjxjOR+/eYRQ6ZT+51xnj+IbpXIgv8X57M
        YEjT5TlTFS28t5uPueuHSjVANwuAnXE=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 137499dd (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Mon, 20 Dec 2021 15:07:40 +0000 (UTC)
Received: by mail-yb1-f179.google.com with SMTP id f9so29650971ybq.10;
        Mon, 20 Dec 2021 07:07:40 -0800 (PST)
X-Gm-Message-State: AOAM533abn5kRiwS79MdWAo9TcE4eaxRvAUkpSrMpAJOKqA8qdqetnsS
        z+jCndnbYigXMCsIxR4omYsBsJz6Hmh7vsuVkAk=
X-Google-Smtp-Source: ABdhPJxjl0OfxTfadBI9gYggUPvoirNaCHNBvVb8gXYAuMjh6IbdW0F4p2gD2dSAnIHzuv9eG1S/QJ+RSLcsV7KiU90=
X-Received: by 2002:a25:13c6:: with SMTP id 189mr23069037ybt.113.1640012859536;
 Mon, 20 Dec 2021 07:07:39 -0800 (PST)
MIME-Version: 1.0
References: <20211219025139.31085-1-ebiggers@kernel.org>
In-Reply-To: <20211219025139.31085-1-ebiggers@kernel.org>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Mon, 20 Dec 2021 16:07:28 +0100
X-Gmail-Original-Message-ID: <CAHmME9pQ4vp0jHpOyQXHRbJ-xQKYapQUsWPrLouK=dMO56y1zA@mail.gmail.com>
Message-ID: <CAHmME9pQ4vp0jHpOyQXHRbJ-xQKYapQUsWPrLouK=dMO56y1zA@mail.gmail.com>
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

Hi Eric,

This patch seems fine to me, and I'll apply it in a few days after
sitting on the list for comments, but:

> Note: READ_ONCE() could be used instead of smp_load_acquire(), but it is
> harder to verify that it is correct, so I'd prefer not to use it here.
> (https://lore.kernel.org/lkml/20200916233042.51634-1-ebiggers@kernel.org/T/#u),
> and though it's a correct fix, it was derailed by a debate about whether
> it's safe to use READ_ONCE() instead of smp_load_acquire() or not.

But holy smokes... I chuckled at your, "please explain in English." :)

Paul - if you'd like to look at this patch and confirm that this
specific patch and usage is fine to be changed into READ_ONCE()
instead of smp_load_acquire(), please pipe up here. And I really do
mean this specific patch and usage, not to be confused with any other
usage elsewhere in the kernel or question about general things, which
doubtlessly involve larger discussions like the one Eric linked to
above. If you're certain this patch here is READ_ONCE()able, I'd
appreciate your saying so with a simple, "it is safe; go for it",
since I'd definitely like the optimization if it's safe. If I don't
hear from you, I'll apply this as-is from Eric, as I'd rather be safe
than sorry.

Jason
