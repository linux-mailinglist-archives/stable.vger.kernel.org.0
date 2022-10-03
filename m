Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D65735F2CF6
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 11:11:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231220AbiJCJLs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 05:11:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231267AbiJCJLa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 05:11:30 -0400
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90CC218E27;
        Mon,  3 Oct 2022 02:09:26 -0700 (PDT)
Received: by mail-qt1-f169.google.com with SMTP id f26so5979307qto.11;
        Mon, 03 Oct 2022 02:09:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=trTfDJMo708QkzlgeeP2MRgqzTNqQkR+d0aIDLbnGMQ=;
        b=CM73RZ3xNKNAiwdHoewawhkDzR+4Ar8kMGAbhAphtIcAKAPRenXHwAmsKWivlq4jT8
         2glXVxYhxwkQBE84n+vnUo1Z3xPEALnmprsckEJh6t+Lmg/OLT/1dRMsExoWeHL3XKLY
         bnKdjAbeP+OWIyDjQnDMsI96AhRIozudMYoX85Dd969TYNLKcSQH6TEUOmqR7M0pTFmV
         4hYjLX3nmhODMj2NRmZZWEz9PkzTHe899oDtSW3KygSAS4FqCHR0u3mYqf2qbHJzWgqH
         bsaZGGFto9UgEQeZmUUpcTV3kBmqxu/o0RRJEpobCYkaFeZgjSgWhI0fdQxyuAMSgkt4
         tc/Q==
X-Gm-Message-State: ACrzQf3YlRX4lw+BbYL2jX19yYGmNCJqvbzXtNDsJGd2pq7Frwh1AXSF
        3eRuRPTSaezlfwBF7GjdMEljN1xM03mQuA==
X-Google-Smtp-Source: AMsMyM6Lu+98pbw7nZyM3mtVAOOiFgdp408U9x6rwhHYOtp9U6afIsQxpCHEzlUcQ5o7ScH9SizVfQ==
X-Received: by 2002:a05:622a:14d0:b0:35c:c205:7d25 with SMTP id u16-20020a05622a14d000b0035cc2057d25mr15135703qtx.5.1664788165084;
        Mon, 03 Oct 2022 02:09:25 -0700 (PDT)
Received: from mail-yb1-f177.google.com (mail-yb1-f177.google.com. [209.85.219.177])
        by smtp.gmail.com with ESMTPSA id g9-20020a05620a40c900b006bbe6e89bdcsm11202173qko.31.2022.10.03.02.09.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Oct 2022 02:09:24 -0700 (PDT)
Received: by mail-yb1-f177.google.com with SMTP id 207so9018391ybn.1;
        Mon, 03 Oct 2022 02:09:24 -0700 (PDT)
X-Received: by 2002:a05:6902:45:b0:6ae:ce15:a08d with SMTP id
 m5-20020a056902004500b006aece15a08dmr18338529ybh.380.1664788164575; Mon, 03
 Oct 2022 02:09:24 -0700 (PDT)
MIME-Version: 1.0
References: <20221003070724.490989164@linuxfoundation.org> <20221003070726.658463729@linuxfoundation.org>
In-Reply-To: <20221003070726.658463729@linuxfoundation.org>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 3 Oct 2022 11:09:12 +0200
X-Gmail-Original-Message-ID: <CAMuHMdXqjz2BbPX3TGd40o=A-gDx6ZEYEe1rf3AadqOf_E4V_A@mail.gmail.com>
Message-ID: <CAMuHMdXqjz2BbPX3TGd40o=A-gDx6ZEYEe1rf3AadqOf_E4V_A@mail.gmail.com>
Subject: Re: [PATCH 5.19 089/101] dont use __kernel_write() on kmap_local_page()
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>,
        Sasha Levin <sashal@kernel.org>
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

Hi Greg,

On Mon, Oct 3, 2022 at 9:28 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> From: Al Viro <viro@zeniv.linux.org.uk>
>
> [ Upstream commit 06bbaa6dc53cb72040db952053432541acb9adc7 ]
>
> passing kmap_local_page() result to __kernel_write() is unsafe -
> random ->write_iter() might (and 9p one does) get unhappy when
> passed ITER_KVEC with pointer that came from kmap_local_page().
>
> Fix by providing a variant of __kernel_write() that takes an iov_iter
> from caller (__kernel_write() becomes a trivial wrapper) and adding
> dump_emit_page() that parallels dump_emit(), except that instead of
> __kernel_write() it uses __kernel_write_iter() with ITER_BVEC source.
>
> Fixes: 3159ed57792b "fs/coredump: use kmap_local_page()"
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

This will need a follow-up patch, which I have just posted[1], to
not break the build if CONFIG_ELF_CORE is not set.

[1] https://lore.kernel.org/20221003090657.2053236-1-geert@linux-m68k.org

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
