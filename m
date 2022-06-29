Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C00455F43F
	for <lists+stable@lfdr.de>; Wed, 29 Jun 2022 05:44:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229559AbiF2Dl5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jun 2022 23:41:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbiF2Dl4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Jun 2022 23:41:56 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E57AF1A05D;
        Tue, 28 Jun 2022 20:41:55 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id i15so25756525ybp.1;
        Tue, 28 Jun 2022 20:41:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=L6va5NDTwhJBkQ/f4NSo1vfSeL4VeLOONQBkSqjkrqQ=;
        b=C0oG3HmJ1pdcmuByCMI6OoEAquSla/w5ibP3mlFqfDQ0x3lgh7/WXpBpJWO76k/ypr
         LFwZxIAjbE3NeOXW8fgUNoDaWe6bOlw5Sw9WJly5zIMN/qHNTp2g3SZ3vPNy9q4TKa3V
         1VLcyoozI+ypv2ps0WDvpZgkoUpA0Fr9MVSDeR/LfKLOguEreikiJCqCzqlbtiiFSoUq
         tbDIz6MK0J7WbGAEDCvMozy2iIBMs01slrPaOugeYjfnYMj0zL/m1uJMAkV2gC4zNLAj
         TBb0NC/jIjDsrYOLwTMfqcjo0VQxF14gvoroxTbNTcOeuIjGtwK0CfOoClYZZhNURYRP
         N5Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=L6va5NDTwhJBkQ/f4NSo1vfSeL4VeLOONQBkSqjkrqQ=;
        b=ELMg5Yj6tIsL22h2Jd5ZQjpO9Qg5JCkkDLulMxlO6cvudGu4LtsMHrZHahNNIaw9qy
         yKSkA0KCSsbV7y/ePFKwcs+J/OVdnTS9snntuQvWDzqESgQxad0iZdrtayIe8V0OsIjz
         yhACY52qZEpwzWQ/sPr0BuJPEH8SOeGmXZOFzYfaZxyDp6biwdocZtyjE8UoWmzthnP3
         rKDIVJsDCAuanUBIEY+EpWiHYUJKSj/AEWG8CPiLpuizfyu7ZbaJeyO6n3yzoxdSBHlB
         stjEU0MHRXAnS+uzmC3N3828zO49qLgdMXukfaegBUyLGt89D/g3DcBqxFohIYAIvFZB
         JqYw==
X-Gm-Message-State: AJIora/7e//4gZithfwcT+QtOhflnwtaeWsaZom9ATEHkfWnkttn7R+4
        vi0Pse3gJEYD4bIMIQqNGxVzAoeVKFiBc1Mqalk=
X-Google-Smtp-Source: AGRyM1vntT7JV2vrSjSDqX+JKmsQG97Jg1jk7dN1GujAu5qh5R8UKZi3BnUXWIa9WvEOm4yIAH2YJ+T3w7zWcoilG6Y=
X-Received: by 2002:a05:6902:1021:b0:66d:43a7:f79f with SMTP id
 x1-20020a056902102100b0066d43a7f79fmr1122586ybt.564.1656474115111; Tue, 28
 Jun 2022 20:41:55 -0700 (PDT)
MIME-Version: 1.0
References: <20220628151840.867592-1-Jason@zx2c4.com>
In-Reply-To: <20220628151840.867592-1-Jason@zx2c4.com>
From:   Gregory Erwin <gregerwin256@gmail.com>
Date:   Tue, 28 Jun 2022 20:41:44 -0700
Message-ID: <CAO+Okf56VAqKt5a6OoGUnMAoMsbQoBd7V_tcLf9yuqheWKH1SA@mail.gmail.com>
Subject: Re: [PATCH v7] ath9k: let sleep be interrupted when unregistering hwrng
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Kalle Valo <kvalo@kernel.org>,
        Rui Salvaterra <rsalvaterra@gmail.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hmm, set_notify_signal() calls wake_up_state() in kernel/sched/core.c, which
is not currently exported. Only by including EXPORT_SYMBOL(wake_up_state) and
rebuilding vmlinux was I able to build rng-core.ko and load it successfully.

That said, this patch allows 'ip link set wlan0 down' to wake a blocked process
reading from /dev/hwrng, eliminating the delay as described. I'll give my
sign-off with the EXPORT_SYMBOL sorted out.
