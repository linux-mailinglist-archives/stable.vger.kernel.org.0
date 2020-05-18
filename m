Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE4BF1D7238
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 09:49:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727005AbgERHtT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 03:49:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726872AbgERHtT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 May 2020 03:49:19 -0400
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com [IPv6:2607:f8b0:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0125EC05BD09
        for <stable@vger.kernel.org>; Mon, 18 May 2020 00:49:19 -0700 (PDT)
Received: by mail-oi1-x241.google.com with SMTP id j145so8244469oib.5
        for <stable@vger.kernel.org>; Mon, 18 May 2020 00:49:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9Kg9Ix3G7gt7x5w/7wJrycMf+fayHlF4h5k5vb0LVNE=;
        b=gus+oTfRxh3dY9mcRGgv3VOc5RsBFCunI6dbDnm8adq9ral2CBEqTqlLwgGZxLm+vC
         ziYG7DBHGzpTHqRd83GWYvVnGeYWg9smIvSXqP5cyK/iu7h5UQBMjjhltZiDQWNeVx6a
         66AWjtaqp1SsfXdxM56EJ48c7p3hz8fW9o0sh9Dr7PmZiGAeXNCazO5b+ff1+o8dq9io
         k0pr0szNYEf8Cxe4cIYeIeKRbHNX66FHH2jcNZmosYXup3Kc8XpgnOakF4ujC281AOzU
         D2zf1hyCLD05cRgt/INkOKnbu97DFMfcRV9R1eZDR+TTmcDTvLCns9Poal2NPZ2pRGNS
         lgSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9Kg9Ix3G7gt7x5w/7wJrycMf+fayHlF4h5k5vb0LVNE=;
        b=sW4iqA8Zcx+EUOn/SGdrIp+h35Gqwc27F5Xg/cOy1h1YU6JIU8wLlpnKvD6A46/Kam
         GdyYln8J6E3Gsssql0yVfGF+KFe3QKfYbVAowA0IoLo0M4M0RqbojfBDCvC+IVKS4B0z
         s2Y2PiVfs0wnduaXt9rPr6/r4A+zLGjUbOzmBkbIUZP/OXCFpu0SELBeM0dFlLBRQWjV
         naf8XljQ3lro+Q4TjgXKZHITFCo6yr+oV5g4tyKac5NIRzQLsAHTDfafevfzDf0MhjEG
         XjiXv7NYGpEZaBdbNZiqrclvfmv2FmVy88CU3RHSb2U9noqe4DykEU/BM0QL8fF0HXl8
         MBfw==
X-Gm-Message-State: AOAM5311Litpcxs3oSN5Uza/wSfPv9rnmING7zG07VSPZ5moZagZ8r6l
        tIrC0Q4RbXsL7gl+4E3J5S8zBa4QkcjGWy2aDL7FUw==
X-Google-Smtp-Source: ABdhPJzGlx8lai6LNz1Oy0wFUl8yeME9wOla1JSZsaTpsJyonIKVxhd06lQMams06G8wlnYAhhrBg89+S3pwR+SytsU=
X-Received: by 2002:aca:f1c2:: with SMTP id p185mr3962337oih.69.1589788158197;
 Mon, 18 May 2020 00:49:18 -0700 (PDT)
MIME-Version: 1.0
References: <20200516080718.166676-1-saravanak@google.com>
In-Reply-To: <20200516080718.166676-1-saravanak@google.com>
From:   Saravana Kannan <saravanak@google.com>
Date:   Mon, 18 May 2020 00:48:42 -0700
Message-ID: <CAGETcx8Ro_tsmYEQwzZKsm2xzimw=MBcChbSW5Nx9arUni53wQ@mail.gmail.com>
Subject: Re: [PATCH v1] driver core: Fix memory leak when adding
 SYNC_STATE_ONLY device links
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Saravana Kannan <saravanak@google.com>
Cc:     stable <stable@vger.kernel.org>,
        Android Kernel Team <kernel-team@android.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, May 16, 2020 at 1:07 AM Saravana Kannan <saravanak@google.com> wrote:
>
> When SYNC_STATE_ONLY support was added in commit 05ef983e0d65 ("driver
> core: Add device link support for SYNC_STATE_ONLY flag"),
> device_link_add() incorrectly skipped adding the new SYNC_STATE_ONLY
> device link to the supplier's and consumer's "device link" list. So the
> "device link" is lost forever from driver core if the caller didn't keep
> track of it (typically isn't expected to).
>
> If the same SYNC_STATE_ONLY device link is created again using
> device_link_add(), instead of returning the pointer to the previously
> created device link, a new device link is created and returned. This can
> cause memory leaks in conjunction with fw_devlinks.
>
> Cc: stable@vger.kernel.org
> Fixes: 05ef983e0d65 ("driver core: Add device link support for SYNC_STATE_ONLY flag")
> Signed-off-by: Saravana Kannan <saravanak@google.com>

Greg/Rafael,

This patch causes a warning for SYNC_STATE_ONLY links because they
allow consumers to probe before suppliers but the device link
status/state change code wasn't written with that possibility in mind.
So I need to fix up that warning or state change code.

Depending on how urgent you think memory leak fixes are, you can take
it as is for now and I can send a separate patch to fix the
warning/state change code later. Or if we can sit on this memory leak
for a week, I might be able to fix the warning before then.

Thanks,
Saravana
