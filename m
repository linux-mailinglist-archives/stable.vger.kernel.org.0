Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26180461B93
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 17:10:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344874AbhK2QNz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 11:13:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344982AbhK2QLz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 11:11:55 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A29DC08EA7F
        for <stable@vger.kernel.org>; Mon, 29 Nov 2021 06:12:22 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id x15so72398923edv.1
        for <stable@vger.kernel.org>; Mon, 29 Nov 2021 06:12:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=WXujHn+Aip39eencB3cYJstRytLHPrA412s3PzKkRco=;
        b=V3zhlwIh+7LH4uTvC23CMLbQlwvYZnHy+ROCn8LRXCKnFEZVSRIrhZGfAClV76ruOX
         qyZ492YWajWymxzQ3/F6R2yw96ue2B+DVw7W9MgtHGCOUQsx9o0mehgJfvk/ZReTByzS
         hD8ymJqREvaKqkMCyvzwWBm7lUhwsfsBlB0Kdt97syfYBMHXIgLUEJOPwimJ+LGBQTOk
         7b4ycgApjUTI0viZYugpUZz6+a/SGzhafYrnW1+Ov3KAoykdly4DIwaQG4k/TeJQu9aE
         o0GdKL0poTB3oIBinIA7jRzGZyCIdL1gOsMtGK1q5AhyDKaQ7pAZrdHqk6pD3bnP/66g
         dXbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=WXujHn+Aip39eencB3cYJstRytLHPrA412s3PzKkRco=;
        b=w4fP9gx81FlsX6+minOAnQfg0vEtyYzWVY0V/eW0mjSRHENCFvt70PUB0jgg1U0fql
         w9TQz0gmZrahWHv/MQ9xJialDoXd0BPBjpoyWk8mRWsuvwIC+7fdk7d1RBS+BptzYHj6
         QJk5mFWH+hEZZqNsLXzBA86fDlHAwcw8BMNYBGVXhwTVzaEmFqj+9AGLLcpenlmawuTB
         KzUkJFX4MBFJiH2jl5Sg+3o07af1a6TMQw5vWxxFHiW5A0xtr+YZL5oDUzAWCkMJMY2o
         pM7xYQnzKuu4fkWUhk1buw+n5m+1epVUkIbQE9buXXMgpR/IoK9WFplYNqLKQSzATIf0
         HACQ==
X-Gm-Message-State: AOAM5336i+dl8PlVOCMncFxDZVj02erRjDwRcOLi52tNQU10XgVFCeY7
        eeyvxhlM6u1MUxrSCMNATRy396PnA3FSk8b1vRPaGg==
X-Google-Smtp-Source: ABdhPJyOWcBqYLt3xsTFWkdfwWgdcm6Pbz0GM4HJmiB3ACpPnLqOnZEOLTUPwpaSgVHCZKlQOZ6vSDnidcT3Kw8xmM4=
X-Received: by 2002:a05:6402:2813:: with SMTP id h19mr75154365ede.267.1638195140132;
 Mon, 29 Nov 2021 06:12:20 -0800 (PST)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 29 Nov 2021 19:42:07 +0530
Message-ID: <CA+G9fYuzzknDMdu3q8ARyVHqd-cLYD_tsMLMH-ig-k-WVeTPAg@mail.gmail.com>
Subject: Doesn't build 32 bit vDSO for arm64
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     linux-stable <stable@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Antonio Terceiro <antonio.terceiro@linaro.org>,
        Vishal Bhoj <vishal.bhoj@linaro.org>,
        Anders Roxell <anders.roxell@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg and Antonio,

The stable-rc 5.4 build is failing.
( 5.10 and 5.15 builds pass )
because new build getting these two extra configs.

CONFIG_GENERIC_COMPAT_VDSO=y
CONFIG_COMPAT_VDSO=y

These two configs are getting added by extra build variable

CROSS_COMPILE_COMPAT=arm-linux-gnueabihf-

This extra variable is coming from new tuxmake tool.

Doesn't build 32 bit vDSO for arm64
https://gitlab.com/Linaro/tuxmake/-/issues/160

ref:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/


Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

--
Linaro LKFT
https://lkft.linaro.org
