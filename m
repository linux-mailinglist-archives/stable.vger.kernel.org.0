Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6F1F3A7449
	for <lists+stable@lfdr.de>; Tue, 15 Jun 2021 04:46:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230215AbhFOCsp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 22:48:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230286AbhFOCsj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Jun 2021 22:48:39 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1311C061574
        for <stable@vger.kernel.org>; Mon, 14 Jun 2021 19:46:31 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id nd37so12133844ejc.3
        for <stable@vger.kernel.org>; Mon, 14 Jun 2021 19:46:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vVu/q50mLKZC8+FmqE6RzI+X9/hmuWYOAB854u4sNe0=;
        b=lH8grbcFhCAO4tnhWvsAdMiBjS0dTx3HutQQBO9coicIiuYTgrOeRLwpRjHXqMce1/
         jlap8x9hVMfojCAQL0TmYXz+FyLqz+bqKIlRSJS3e+s2DHZplVtmv0r7hBkVZzC2o+er
         nxlHTtAb3r4mchIxkgI5MOGYLAzko3i2pecmOL0Z42EF0b3ox+/Pmr1dSd7003L0FrDr
         aoAuPuvRiIIuj+kiBzu5zJQcJDus9CmYTMuIB9AyBdYK4OnA7adx7M6L4FlbGfyhjdmq
         I8QALrFxn/N9hR0DJ6Xv8/n4+4+0/0zRI6bM7liU6yRbMP0oPJL0Pt48DtbAVjrqTH/u
         BxVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vVu/q50mLKZC8+FmqE6RzI+X9/hmuWYOAB854u4sNe0=;
        b=o2aUK6IcfkNqZRhKR74zDBZhGFry4yVTMNg3Q2zeESfUTm+OR7aFTQd7lfwaGpHi0W
         RCsMc4IW7sD2FiZi2PZ3nJecX7v1LAWG+tzxEVD5OxWBptozHKKwNWFtI9QYu76ImL3T
         kLuWQeUwAHB2E+wMCxKC5NVF7Bexa7ddzwsiTKVTu0deJDOalaea7CrG40HhyflfQU9d
         rWunX6YvQZeWgaHph+mbF1RSNZO3emCUcTjnxM1z/FWzswSHnrogrzqJKAtq97bZwzJk
         2X1z5phh770ZR/LaaAWtQVFUz2xLJabLCoAlpv4iMsTVYdqzu9lWXkQRmnYDFVa5ufT7
         wJUg==
X-Gm-Message-State: AOAM530Hv2/xjCnl0A79aUIkZcuANSbMDBGd2uh32kUvHcEInbsTA136
        OoRym2BwDzMVsyHSlau4lgMBF7v0ofK6gL2KbAYi2qr2QhYHlA==
X-Google-Smtp-Source: ABdhPJxZ/dgSfmoQFiza4iMe8qVVuP8sYLGcxHmV82OdFool6B9csSY6OkHOGeXlUVIIywTaOOGzKuIwejrZQ+CsBo0=
X-Received: by 2002:a05:6512:1144:: with SMTP id m4mr14563109lfg.390.1623724714373;
 Mon, 14 Jun 2021 19:38:34 -0700 (PDT)
MIME-Version: 1.0
References: <20210615012014.1100672-1-jannh@google.com> <20210614190032.09d8b7ac530c8b14ace44b82@linux-foundation.org>
 <CAG48ez1nZcrJPO-hOLyE08g8HKSGEambCp6mNv6FNR2c9+6sJg@mail.gmail.com>
In-Reply-To: <CAG48ez1nZcrJPO-hOLyE08g8HKSGEambCp6mNv6FNR2c9+6sJg@mail.gmail.com>
From:   Jann Horn <jannh@google.com>
Date:   Tue, 15 Jun 2021 04:38:08 +0200
Message-ID: <CAG48ez1uODg-_6LrLsLzCoBr=VEBisfeNhSkTmYgwG0Ldq+Dxg@mail.gmail.com>
Subject: Re: [PATCH v2] mm/gup: fix try_grab_compound_head() race with split_huge_page()
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Linux-MM <linux-mm@kvack.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        John Hubbard <jhubbard@nvidia.com>, Jan Kara <jack@suse.cz>,
        stable <stable@vger.kernel.org>, Michal Hocko <mhocko@suse.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 15, 2021 at 4:36 AM Jann Horn <jannh@google.com> wrote:
> If you don't like the ifdeffery in this patch, can you please merge
> the v1 patch? It's not like I was adding a new BUG_ON(), I was just
> refactoring an existing BUG_ON() into a helper function, so I wasn't
> making things worse; and I don't want to think about how to best
> design WARN/BUG macros for the VM subsystem in order to land this
> bugfix.

Ah, nevermind, I hadn't seen that you already merged this one.
