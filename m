Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B1A069EDC4
	for <lists+stable@lfdr.de>; Wed, 22 Feb 2023 05:04:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229686AbjBVEEL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Feb 2023 23:04:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbjBVEEK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Feb 2023 23:04:10 -0500
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACE4D1A490
        for <stable@vger.kernel.org>; Tue, 21 Feb 2023 20:04:08 -0800 (PST)
Received: by mail-lf1-x130.google.com with SMTP id f41so8365138lfv.13
        for <stable@vger.kernel.org>; Tue, 21 Feb 2023 20:04:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=2Yt/rtAUjC8oE//IhVQKInejbXflDY4md7Xx+ezyrLY=;
        b=PlCZNxI6YaoiNHUimwzbfONmZvR3sfewbs0X07QALDVOrrxpCUFYZsoOhBAOI6wa74
         qGIZyVqEkF9Loyx7H3H9ZH8O/m08FrEGlDX6iP31P2VKJIixcgaVqjWx5PkDEaHo2GOd
         QWdqEo6qaObAubvJSssFXGDcKGgi/kFMrI/4c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2Yt/rtAUjC8oE//IhVQKInejbXflDY4md7Xx+ezyrLY=;
        b=gLcRTzVB9DCn/XcLetdaqzPIuKR0YNPOSvhoSCc/Ymm/GHN9RsmAkAe0Omat1QNpDl
         cKNzJPq4A5bBmpb+AkifpTHOsuA6sdhlKbqcr2ujJvBXmSXP2miBGap8cxQgRZ13PbbC
         SpUxT+7297N5YPaxbYNxy9DO2bzkfrcyOS4fogRtVI882PZg0h1V4tGUqzgh9iTF4Xth
         SP919Pc0BXb2tOo2gmXZE5Ib0G03hst5INXbpKLH5aykAVSA8o67QpFsPRhr/OQ4cyGE
         JtAYCK1V7fARGTJ9S1Ukr5nf1vy0ISEVdX5mW7wppyzcFI9TkwEuGy8BvuKdaw6UBa4k
         Sc1Q==
X-Gm-Message-State: AO0yUKXlesTGYKkk5De98pBqMeAoDD6+iXL/k/608c7vjaWRQFH58gmz
        wkwtqtQf5cmYNRNZl1XeSu+6JJo0ww4eLLxIfcCUdA==
X-Google-Smtp-Source: AK7set8y2i/Pyooxg/uGB4gmq0f1CWgV03knLK+LIWN1PjLs9XMWKgkHNXYCRaI11gv0/HSn9Wh9/Q0yJf7QGtRUCQ0=
X-Received: by 2002:ac2:46db:0:b0:4d5:ca32:6aec with SMTP id
 p27-20020ac246db000000b004d5ca326aecmr2399509lfo.12.1677038646988; Tue, 21
 Feb 2023 20:04:06 -0800 (PST)
MIME-Version: 1.0
References: <20230221214344.609226-1-peterx@redhat.com>
In-Reply-To: <20230221214344.609226-1-peterx@redhat.com>
From:   David Stevens <stevensd@chromium.org>
Date:   Wed, 22 Feb 2023 13:03:55 +0900
Message-ID: <CAD=HUj7FkbyJ6WKVwNhsFv9RMgbXz5KSisnWcTNF5jZe4YdiaQ@mail.gmail.com>
Subject: Re: [PATCH] mm/khugepaged: alloc_charge_hpage() take care of mem
 charge errors
To:     Peter Xu <peterx@redhat.com>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Yang Shi <shy828301@gmail.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 22, 2023 at 6:43 AM Peter Xu <peterx@redhat.com> wrote:
>
> If memory charge failed, the caller shouldn't call mem_cgroup_uncharge().
> Let alloc_charge_hpage() handle the error itself and clear hpage properly
> if mem charge fails.
>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Yang Shi <shy828301@gmail.com>
> Cc: David Stevens <stevensd@chromium.org>
> Cc: stable@vger.kernel.org
> Fixes: 9d82c69438d0 ("mm: memcontrol: convert anon and file-thp to new mem_cgroup_charge() API")
> Signed-off-by: Peter Xu <peterx@redhat.com>

Reviewed-by: David Stevens <stevensd@chromium.org>
