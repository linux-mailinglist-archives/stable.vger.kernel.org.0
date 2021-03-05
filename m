Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5949332EB90
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:49:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229682AbhCEMsl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:48:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:35290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229737AbhCEMsi (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:48:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2AAC76501E;
        Fri,  5 Mar 2021 12:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614948518;
        bh=XwLA/G1jeHumWFbEMRQ1AkAfirCPryMhgXYYO9H4ah0=;
        h=From:Date:Subject:To:From;
        b=Kxb+gKahDeiPwjUl2X553EKuPRB/sEen1DNzxkDgtIfAqb4UkqW84aF3wKtXbph6W
         8re1l0UdgQA01yM8ala467Efa4ijxx9BXyqKEh06C++xtEC17DA7LC9UzO/sBeGD8R
         4ugyTVc0LH1H4JPYj52Y7Tpa0nU0G1/sapP87aENiRcMTm0AheM+7HT0Lw8o29xTeA
         LZt0SmaPLkdclL9QSrurdoREkUtwFxbYLbtSRAf18Q571wJc/x6gRcgKnkOS7Ds71/
         +9DlXnYeJLPpyYHJTj46UdU1g0UuJPqWnVXCMgJNCe2f4H0Q2qFpPZtHiDuDwbvKUa
         8HBcrFSmOtUaw==
Received: by mail-oi1-f174.google.com with SMTP id l133so2368918oib.4;
        Fri, 05 Mar 2021 04:48:38 -0800 (PST)
X-Gm-Message-State: AOAM532NgmO2MpUz3Kdak5cnchwlu/j6XMcEdItVPqjLTxYo5qHfYFGy
        tVkuaSdg5FVacCHHei8CJCF6v+avrmWyPM5hhmI=
X-Google-Smtp-Source: ABdhPJzbZvMAcqHYBIdger/9WJVb8SwvSKoP1MsglwCgSK5gaI6xYNyjtJ5qJr0yTgBowZBjX1D2ZjmVGx7my4tRi4k=
X-Received: by 2002:aca:538c:: with SMTP id h134mr6867959oib.174.1614948517536;
 Fri, 05 Mar 2021 04:48:37 -0800 (PST)
MIME-Version: 1.0
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Fri, 5 Mar 2021 13:48:26 +0100
X-Gmail-Original-Message-ID: <CAMj1kXFhAmy746r+2VqtLHSwtM4-hcKsqqQRRMsFJkrQ99Yf2g@mail.gmail.com>
Message-ID: <CAMj1kXFhAmy746r+2VqtLHSwtM4-hcKsqqQRRMsFJkrQ99Yf2g@mail.gmail.com>
Subject: please apply 660d2062190db131 to v5.4+
To:     stable@vger.kernel.org,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Android Kernel Team <kernel-team@android.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Please consider applying the following upstream patch to stable trees
v5.4 and up

commit 660d2062190db131d2feaf19914e90f868fe285c
Author: Ard Biesheuvel <ardb@kernel.org>
Date:   Wed Jan 13 10:11:35 2021 +0100

crypto - shash: reduce minimum alignment of shash_desc structure

On architectures such as arm64, it reduces the worst case memory
footprint of a SHASH_DESC_ON_STACK() allocation (which reserves space
for two struct shash_desc instances) by ~350 bytes.
