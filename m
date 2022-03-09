Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A1B84D3CBB
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 23:15:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237245AbiCIWQo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 17:16:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235827AbiCIWQn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 17:16:43 -0500
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04C54F9558
        for <stable@vger.kernel.org>; Wed,  9 Mar 2022 14:15:44 -0800 (PST)
Received: by mail-lj1-x232.google.com with SMTP id u7so5170112ljk.13
        for <stable@vger.kernel.org>; Wed, 09 Mar 2022 14:15:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qw8gxVd/jhZj3HT7A23dlpB9LW84F+FNi7JNdvrCukQ=;
        b=hfb8CzPyalPIpFuwiwa0XbPwPxNPzZJjxvpkX0YTX0v7YvhBIERsAprnsVo4Mi1DmR
         4qFwJ01VcC+MJzk9PZGJezEgtQV+T3wEqf8LNqSCwTbbfn6hWblrjmdv5juTbexxLXut
         AtIufaImJ0J1z49EJGYA2H1DuFgPj6qxEGoIQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qw8gxVd/jhZj3HT7A23dlpB9LW84F+FNi7JNdvrCukQ=;
        b=cjJxL2F6VcVRUXiIYQyPVKedW51YKtZstgX2JfYoq3+XR98TUDFZ06ixG7GuuXIOmv
         7BKXCmI6Ki1arKuqQe/RUfX9GRzRKwZ6U+0TV4Xb3ZW8PNaR3oQcBUyrErGeXsa1UZF8
         dCv9XWAiCP/tzcemsXrRoqp0jeT2387lJpqFvLWRkC6tkk640/hvQrAFtJEKbW+OcaZw
         Gt9qs3qSGa+xCYJGdattC3To0p7KrErnzeuvdR8ASvFMzva9aJYLGfB+joTK0aeLUs1n
         RHqvYem4E/787yMuVcy9xtBcjEECs6wQroJMUZt0Xnl4ENJIJNJv2ea5j4uJglXlobl7
         BwMQ==
X-Gm-Message-State: AOAM533HpM3NxoZuGDQMpgt8WtBgTir34uQSjx/DzjTB0WTKl2IzQ/be
        4O5k9DSmr8JiSO28UGEFhXZKeOBquUz+PrFU9Q0=
X-Google-Smtp-Source: ABdhPJxaeHv/Dol4UFmbvFlk9tQlhvT5wt7WNnCM3fvh+H6Cm2/wvmxlCYZ3elUeT+1kmMLderrQPg==
X-Received: by 2002:a2e:b946:0:b0:244:beb1:72b2 with SMTP id 6-20020a2eb946000000b00244beb172b2mr1135608ljs.240.1646864142170;
        Wed, 09 Mar 2022 14:15:42 -0800 (PST)
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com. [209.85.167.54])
        by smtp.gmail.com with ESMTPSA id w9-20020a05651203c900b0044399c17e58sm612664lfp.224.2022.03.09.14.15.39
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Mar 2022 14:15:40 -0800 (PST)
Received: by mail-lf1-f54.google.com with SMTP id l20so6186038lfg.12
        for <stable@vger.kernel.org>; Wed, 09 Mar 2022 14:15:39 -0800 (PST)
X-Received: by 2002:a05:6512:6c6:b0:447:ca34:b157 with SMTP id
 u6-20020a05651206c600b00447ca34b157mr1112657lff.435.1646864139462; Wed, 09
 Mar 2022 14:15:39 -0800 (PST)
MIME-Version: 1.0
References: <20220309220726.1525113-1-nathan@kernel.org>
In-Reply-To: <20220309220726.1525113-1-nathan@kernel.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 9 Mar 2022 14:15:23 -0800
X-Gmail-Original-Message-ID: <CAHk-=wi23APrArHX7bcrvKBDZYpHXbeyEW7dRsirwoSPCKgqJg@mail.gmail.com>
Message-ID: <CAHk-=wi23APrArHX7bcrvKBDZYpHXbeyEW7dRsirwoSPCKgqJg@mail.gmail.com>
Subject: Re: [PATCH] ARM: Do not use NOCROSSREFS directive with ld.lld
To:     Nathan Chancellor <nathan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Russell King <linux@armlinux.org.uk>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        llvm@lists.linux.dev, stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 9, 2022 at 2:11 PM Nathan Chancellor <nathan@kernel.org> wrote:
>
> It would be nice if this could be applied directly to unblock our CI if
> there are no objections.

Applied.

Greg - yet another small fixup. It's commit 36168e387fa7 in my tree.

                Linus
