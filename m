Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72A1069844C
	for <lists+stable@lfdr.de>; Wed, 15 Feb 2023 20:18:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbjBOTSB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Feb 2023 14:18:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbjBOTR7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Feb 2023 14:17:59 -0500
Received: from mail-yw1-x1132.google.com (mail-yw1-x1132.google.com [IPv6:2607:f8b0:4864:20::1132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B26A82ED54;
        Wed, 15 Feb 2023 11:17:58 -0800 (PST)
Received: by mail-yw1-x1132.google.com with SMTP id 00721157ae682-4c24993965eso295968547b3.12;
        Wed, 15 Feb 2023 11:17:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=+th/O+lEQQ2oYw1gaBmqYLCJ1+RUw5+Dxy7Tlrst6pQ=;
        b=AtTrfeIFmuXEDx8ge5BmC3z4syQQjWTI5R+iPApfiqGhLpsl7XORLoYizXxbXR7nTQ
         2DUJqAL3ZKQAhdtdNH2REcEabvcE3/A9vur+ZYyNBTejDycpL6CfngPX65tTQuO0vPHk
         6kyJlxLEnlXxH3JcjfqPYxpgOWXNlRvD2gtN1U2t8xnMvykM6+Iu1SGDp9w3TnTKvvw3
         yc2MrFYoLhndlYf1xElI8Ykgc25MqCsFedU+Pumg6uAwLao1itLc7j+EOjugQrs3jJ3g
         NVtH8bknEyRcSnVkec5N1wYhLtjWplMFe2GDO/HZ+JKQR0hy8VQSRAIjFbLSz3HWVu66
         Iglw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+th/O+lEQQ2oYw1gaBmqYLCJ1+RUw5+Dxy7Tlrst6pQ=;
        b=dk52R4XvPOu2CTxwIt7JrsXETSa5u6Cp+hh4K8L/eMNjzPUog23iAzQbRVyFgBxkSu
         snytng8MZ6RUw0rdrmK7zdDZPKgOvVnzN2cd5QFhaySzTBODaPe5kqbvqP5n1UTSGXQ0
         gfW0l7DvFTwW2Om+LguQOJGe7n89zVmnsQBhI3BkdYyVydgSGojTqwAm+anm0OUcK3xg
         6ZZKoF5m+nqw4SI+PNNK6b0QBt7n/SSzzVGBUK3uJSAbc8ULdZQkr/GXJ79ZvNqYy9pv
         usx27ONGQkWNkq3IxEpsYm90ptpRPgEkyetNFht7mSyAhqzGyAWiKRKoYzZs+JGHvlhQ
         AUXw==
X-Gm-Message-State: AO0yUKWS449s3KhHe7+AIIzXThTF3WsHw0u+5bunBlxT8XdKEnhPXsBd
        zO9lskkRHAILLG30UtkdiRkq6UoZSQccU4/qJIs=
X-Google-Smtp-Source: AK7set+mSkXFjBDrpVAa7amVvo+tHNjNU5sLleXqzsUNUNnri5/YeurRP/Kw9VFi/qTb9CHyQR4UwurO5K+rJkZIvV4=
X-Received: by 2002:a25:9a45:0:b0:92c:dee4:d2d2 with SMTP id
 r5-20020a259a45000000b0092cdee4d2d2mr259779ybo.668.1676488677984; Wed, 15 Feb
 2023 11:17:57 -0800 (PST)
MIME-Version: 1.0
References: <20230214224735.264894-1-davidgow@google.com>
In-Reply-To: <20230214224735.264894-1-davidgow@google.com>
From:   Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date:   Wed, 15 Feb 2023 20:17:47 +0100
Message-ID: <CANiq72meQeJU62P-_kzwobPS1tA5vTBnk5CnAWoiiK4GbPn4ag@mail.gmail.com>
Subject: Re: [PATCH] rust: kernel: Mark rust_fmt_argument as extern "C"
To:     David Gow <davidgow@google.com>
Cc:     Miguel Ojeda <ojeda@kernel.org>,
        Alex Gaynor <alex.gaynor@gmail.com>,
        Wedson Almeida Filho <wedsonaf@gmail.com>,
        Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
        =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
        rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 14, 2023 at 11:47 PM David Gow <davidgow@google.com> wrote:
>
> The rust_fmt_argument function is called from printk() to handle the %pA
> format specifier.
>
> Since it's called from C, we should mark it extern "C" to make sure it's
> ABI compatible.
>
> Cc: stable@vger.kernel.org
> Fixes: 247b365dc8dc ("rust: add `kernel` crate")
> Signed-off-by: David Gow <davidgow@google.com>

Thanks David -- I will apply `rustfmt` on my side.

Cheers,
Miguel
