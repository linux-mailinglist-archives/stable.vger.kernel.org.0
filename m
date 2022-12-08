Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1526764776C
	for <lists+stable@lfdr.de>; Thu,  8 Dec 2022 21:43:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229628AbiLHUnO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Dec 2022 15:43:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229677AbiLHUnL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Dec 2022 15:43:11 -0500
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61A5618E32;
        Thu,  8 Dec 2022 12:43:09 -0800 (PST)
Received: by mail-qt1-f170.google.com with SMTP id h16so2085902qtu.2;
        Thu, 08 Dec 2022 12:43:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=E980lveCUquKKhcMXhM1jQtjJxf2DwElGgp3q5gC3Vs=;
        b=Xh/QACz95wxzfNV8c9M7caoShX954Fna90hnGu4dpRhkQQGs2X9vESgOsuT/O+v6wp
         QziFe3GdUIZ0N16xZqPc6k9z/O/6ug03YA71YDm34jOuB0gVCwe8qZ6JitOGqjz+LgXz
         udq8rEp26j7W6Rc9B0ErorV07qHNmjLoOVkrC07HwL0EGhaZE4T9c7WviuooTqQ7RCew
         xdyYlHGJj79ly5c8DuNA41VlmzpCVbTqys09GNAPZsxWO3YEHJDW5UGlkpHYKVsDLHfh
         Rz4scucouRG9hJmXjvAEfZIBFZedmvy/2cgspyAdh6SCjr47X+UGCRE3kXTMh8WBxqP/
         up0Q==
X-Gm-Message-State: ANoB5pn34mVUJ99PrG3JPLVVOBYgbDMY/9dAyd68vkZnHXLO+Wk0HjA/
        biZyYH8k4tLe7a7EeKL9PlBWinOfD4FtXA==
X-Google-Smtp-Source: AA0mqf5HObf4/3qYSijxhiI79REfQrArlQ1P9hWH6YEg0N9nMjm1qxAejzjSFFQCJmkKZHsi81pJTQ==
X-Received: by 2002:ac8:1345:0:b0:3a7:ef31:a07b with SMTP id f5-20020ac81345000000b003a7ef31a07bmr4627184qtj.11.1670532188353;
        Thu, 08 Dec 2022 12:43:08 -0800 (PST)
Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com. [209.85.128.169])
        by smtp.gmail.com with ESMTPSA id m10-20020ac8444a000000b0039cc944ebdasm15856956qtn.54.2022.12.08.12.43.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Dec 2022 12:43:08 -0800 (PST)
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-3c21d6e2f3aso27852597b3.10;
        Thu, 08 Dec 2022 12:43:08 -0800 (PST)
X-Received: by 2002:a81:ff06:0:b0:3ab:6ff4:a598 with SMTP id
 k6-20020a81ff06000000b003ab6ff4a598mr5143379ywn.425.1670532187832; Thu, 08
 Dec 2022 12:43:07 -0800 (PST)
MIME-Version: 1.0
References: <20221208033523.122642-1-ebiggers@kernel.org>
In-Reply-To: <20221208033523.122642-1-ebiggers@kernel.org>
From:   Luca Boccassi <bluca@debian.org>
Date:   Thu, 8 Dec 2022 20:42:56 +0000
X-Gmail-Original-Message-ID: <CAMw=ZnQUmeOWQkMM9Kn5iYaT4dyDQ3j1K=dUgk9jFNcHPxxHrg@mail.gmail.com>
Message-ID: <CAMw=ZnQUmeOWQkMM9Kn5iYaT4dyDQ3j1K=dUgk9jFNcHPxxHrg@mail.gmail.com>
Subject: Re: [PATCH] fsverity: don't check builtin signatures when require_signatures=0
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-btrfs@vger.kernel.org, linux-integrity@vger.kernel.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 8 Dec 2022 at 03:35, Eric Biggers <ebiggers@kernel.org> wrote:
>
> From: Eric Biggers <ebiggers@google.com>
>
> An issue that arises when migrating from builtin signatures to userspace
> signatures is that existing files that have builtin signatures cannot be
> opened unless either CONFIG_FS_VERITY_BUILTIN_SIGNATURES is disabled or
> the signing certificate is left in the .fs-verity keyring.
>
> Since builtin signatures provide no security benefit when
> fs.verity.require_signatures=0 anyway, let's just skip the signature
> verification in this case.
>
> Fixes: 432434c9f8e1 ("fs-verity: support builtin file signatures")
> Cc: <stable@vger.kernel.org> # v5.4+
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  fs/verity/signature.c | 18 ++++++++++++++++--
>  1 file changed, 16 insertions(+), 2 deletions(-)

Acked-by: Luca Boccassi <bluca@debian.org>
