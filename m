Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2642437610B
	for <lists+stable@lfdr.de>; Fri,  7 May 2021 09:16:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235223AbhEGHRE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 May 2021 03:17:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232796AbhEGHRE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 May 2021 03:17:04 -0400
Received: from mail-qv1-xf34.google.com (mail-qv1-xf34.google.com [IPv6:2607:f8b0:4864:20::f34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B20C3C061574
        for <stable@vger.kernel.org>; Fri,  7 May 2021 00:16:04 -0700 (PDT)
Received: by mail-qv1-xf34.google.com with SMTP id w9so4350971qvi.13
        for <stable@vger.kernel.org>; Fri, 07 May 2021 00:16:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=x80bxIDEUNMkFWgaxKf8Ibl2GfwTFpcErPOnCbX5l9U=;
        b=f6WCec98CEM1qB/IK4t7Z63CIOaNfzjkYcyWsu0B5OotS+95FDdNje0aWEDMc65l/m
         +/bwIspq8PG07SpBuSj5mygVSYcsOoKsSxG+J/qVNBVCmbAF+24g29i0XErATMmZ6rKt
         nzmfQ0UbzVcHypmwaUT+2B4yldVXMKwQ39tmjrrLl2F6U2+q0dKWcNL32Efo1r83BR0z
         Z90U4h59c/6+0OrxO9J3fTINHFpft4+u23eubeUD2n8F/P4E5W2ZMS7ju2byr5G51519
         k7W2XIrjb7v/lvXcXjD7hIcSe2wZfn0q+z9a8zwCo9fs/IIUw1F2CnImqjhHkGRq2THf
         6qEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=x80bxIDEUNMkFWgaxKf8Ibl2GfwTFpcErPOnCbX5l9U=;
        b=BydRs6Klj2BOQrLdJQ13YCUiTLecZHSJIBkUOBuB2ZaRv/ygt7lmCnfAset66g42x+
         5FMwbVViZPGaG/5HAYmE6nFsKJmpnaLgk31/6rG07BejGzFHYfO7albLUH/CH5WvqsXk
         D971namkbjX6eDr8YPLsI0c7dAzQqo2W9/KIb9ZGDWqmQ0lRcukm7HT6FK9jq8KQjSzn
         3ZvSU7l/v85x7+tENz0hOReP/0u3ahKtQgJtRpK/xUleQvRK+QUi4MVRgRlh86/XOciy
         5mrc4J8mAeagHW33FtxNBF0fF8UIDEnXFMNXS5bGR7Ai1afWJr1OSfZsc2Hh90OZaxpc
         01kg==
X-Gm-Message-State: AOAM533aIfayiU01XS9cUGFXBP9Z/OWQWe1ncYDTaza4ityT9ccOfyHS
        OK6ZLo4ipIqOU7Oe9TTuCdlf1BEKta31F4+hzoguPw==
X-Google-Smtp-Source: ABdhPJyo/VHxG+f6lpz+E/ekIw1U6scoduqDcetteq6ZG3T2AGr3Rf/W95UU+deZCm9udjAh6sWZb4okW/0/Jyx6gLs=
X-Received: by 2002:a05:6214:36d:: with SMTP id t13mr8545517qvu.2.1620371763401;
 Fri, 07 May 2021 00:16:03 -0700 (PDT)
MIME-Version: 1.0
References: <20210507025915.1464056-1-pcc@google.com>
In-Reply-To: <20210507025915.1464056-1-pcc@google.com>
From:   Alexander Potapenko <glider@google.com>
Date:   Fri, 7 May 2021 09:15:27 +0200
Message-ID: <CAG_fn=V_5nvNT54gFROiHGTz11g_XMqoTWjRpomG01r56ZOP6Q@mail.gmail.com>
Subject: Re: [PATCH v2] kasan: fix unit tests with CONFIG_UBSAN_LOCAL_BOUNDS enabled
To:     Peter Collingbourne <pcc@google.com>
Cc:     Andrey Konovalov <andreyknvl@gmail.com>,
        George Popescu <georgepope@android.com>,
        Elena Petrova <lenaptr@google.com>,
        Evgenii Stepanov <eugenis@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 7, 2021 at 4:59 AM Peter Collingbourne <pcc@google.com> wrote:
>
> These tests deliberately access these arrays out of bounds,
> which will cause the dynamic local bounds checks inserted by
> CONFIG_UBSAN_LOCAL_BOUNDS to fail and panic the kernel. To avoid this
> problem, access the arrays via volatile pointers, which will prevent
> the compiler from being able to determine the array bounds.

Thanks for tracking this down! These crashes have been puzzling me for a while.

> These accesses use volatile pointers to char (char *volatile) rather
> than the more conventional pointers to volatile char (volatile char *)
> because we want to prevent the compiler from making inferences about
> the pointer itself (i.e. its array bounds), not the data that it
> refers to.
>

> Signed-off-by: Peter Collingbourne <pcc@google.com>
Tested-by: Alexander Potapenko <glider@google.com>

(also note you are missing the Acked-by: here that Andrey gave)
