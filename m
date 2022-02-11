Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D5F34B19FB
	for <lists+stable@lfdr.de>; Fri, 11 Feb 2022 01:02:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239080AbiBKACY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Feb 2022 19:02:24 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346001AbiBKACX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Feb 2022 19:02:23 -0500
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39313B54
        for <stable@vger.kernel.org>; Thu, 10 Feb 2022 16:02:24 -0800 (PST)
Received: by mail-yb1-xb34.google.com with SMTP id v47so20200623ybi.4
        for <stable@vger.kernel.org>; Thu, 10 Feb 2022 16:02:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6amdZdKfUfxoy5toKt49P0SHUxAj1DnsrZFrMaxvyJI=;
        b=D7RIFrpCEJQ0wQuEprUdX1acbuAgEexUqcq/lvB14jnOS5ogi4JDn/yVt37yPAdUMv
         cdG+nJNyOiGBDs3Q7oBoxOk7+iJSjIOlc6+IK2Bo0YF1NfrU7itoVPmXEYUvDhcqcaYB
         hN3zRzKzMppQgi6wfwPJ1m5WBsBSndmRbAyqYA6MlnovRWIZxiveV6bMATOtuXsQHLVV
         W8L3zrILKJNEnsKWMLf7ddGjcvQycJkut3j1TnkMzJUBHpWRzZgrreAbRmWW+jFZjIXv
         jBuuvqDKDT8EzktRiQkPY1LS+so+kqF8V0hVR+kwNWdVS4zgqM+IL37eryTfYMXXMUKG
         duqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6amdZdKfUfxoy5toKt49P0SHUxAj1DnsrZFrMaxvyJI=;
        b=dfcmKt8/8VVdLnZQl5XuGSME2VZ0DrZ+y4F5CpOr4TqvQ0EZTkAp2XdDDKRQ2bVv/n
         YdWi1ytWjv/Xh9fXjaPC7ldrBfloGkvpO5OjakXx98e6n0RACPNcTdL/rXwcovlsiDcV
         rUyiU9ppF4OCNSLVDoOrkqTOld/2BI4o5z9Zg0ySIVNCQ8w+o3ZxBQjIvl9hTnaaQBQt
         nDf+7u33KF8dfNUVkkGsvhmo7IN2Pg2da3HCNrwnZxr03mNm+PMwlML4lVKs28RSY2UX
         dkK3WqemcSFnc73Bl8x9T5cuKV0dIG16ziLWgBHkXVkN4M3nYXRdlUqzCmMVWX85NA9p
         V3Fw==
X-Gm-Message-State: AOAM533+MbG3lDVPTwgb8ftsjOfDSn347VVwO1CVORl4wvMcd/1u4X3X
        VdIQtKfb0pHD5HIgVRT9jslQ/LUFpqbpErdw7IxRWA==
X-Google-Smtp-Source: ABdhPJz8e25o2s6cN31+acUzC45sbRdhVmC27Ml34E9Ew1Pqg581u0yFka+g4I69kuUy5l+0FIhMy3qtizaDRqxhAvA=
X-Received: by 2002:a25:684a:: with SMTP id d71mr9513602ybc.284.1644537743422;
 Thu, 10 Feb 2022 16:02:23 -0800 (PST)
MIME-Version: 1.0
References: <20211217153555.9413-1-marcelo.jimenez@gmail.com>
In-Reply-To: <20211217153555.9413-1-marcelo.jimenez@gmail.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Fri, 11 Feb 2022 01:02:12 +0100
Message-ID: <CACRpkdbzk55pmK9XMwc470O8vJFUBQ6zs35shOYCFKr+YaOezw@mail.gmail.com>
Subject: Re: [PATCH] gpio: Revert regression in sysfs-gpio (gpiolib.c)
To:     Marcelo Roberto Jimenez <marcelo.jimenez@gmail.com>
Cc:     stable@vger.kernel.org, regressions@lists.linux.dev,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        linux-gpio@vger.kernel.org, Thierry Reding <treding@nvidia.com>,
        Vidya Sagar <vidyas@nvidia.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Edmond Chung <edmondchung@google.com>,
        Andrew Chant <achant@google.com>,
        Will McVicker <willmcvicker@google.com>,
        Sergio Tanzilli <tanzilli@acmesystems.it>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 17, 2021 at 4:36 PM Marcelo Roberto Jimenez
<marcelo.jimenez@gmail.com> wrote:

> My system is ARM926EJ-S rev 5 (v5l) (AT91SAM9G25), the board is an ACME Systems Arietta.

Which devicetree or boardfile in the upstream Linux kernel is this system
using?

Yours,
Linus Walleij
