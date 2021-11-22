Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFFFF459887
	for <lists+stable@lfdr.de>; Tue, 23 Nov 2021 00:46:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231852AbhKVXtQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Nov 2021 18:49:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231801AbhKVXtP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Nov 2021 18:49:15 -0500
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49952C061574
        for <stable@vger.kernel.org>; Mon, 22 Nov 2021 15:46:01 -0800 (PST)
Received: by mail-ot1-x32b.google.com with SMTP id x19-20020a9d7053000000b0055c8b39420bso31183916otj.1
        for <stable@vger.kernel.org>; Mon, 22 Nov 2021 15:46:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=HIB1oiHZ0iiGMICUTKXSMj/pebpoygCKH0iu3f2KlXo=;
        b=j8oaVLNLXUURGEz6MidWqEUBxbHKtCc7+5kr8NpBqGN8Fql3A3SSQ7oL16VTULcvKR
         O1NBWt/nOpsVbaEz0DJhinp3WPzht9FZwyWVJQV9tCluWbytuZbacLLTO+FU0PGY7/vl
         7VkIYvFjHc519CIVZ1Dc67u6XAk5F0WUjNV4UwDvW65B1/qTb2ZT8hz1PT1wkbo+fHAw
         9j+syovs/uXDNjw6484D9jVU43BL1WozFcFO+KEg/+C9UESrSlORsLxtP1HyD12BthmY
         9/9v1xKho+rb1z5qc/P1ce+zcLtGTCfz66ce/ywer17yZ8ni9UltMC5xfk3dfNKpPWhR
         iFXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=HIB1oiHZ0iiGMICUTKXSMj/pebpoygCKH0iu3f2KlXo=;
        b=2DSCOt2tCwIHmkDewbKWEzidiBaXRjxOV2LcSVHbqu4BL+TiMI78MxeBeijh9MXF2q
         n6kr/3PM+Wt6zwQnZzziWcfgXYh13cbCLzlUh/axWJiPtyxvx0s/L2RYp6P7b69QfVwI
         XHcLhdUqBYkAbGjUUYOJqwPABMd8WULeXH3F2l5ZgKoreRXjB8JXhDEXO+130KlrOmQ6
         WiPij/DoL8QVcX6DkmO2yVhh+Mlc2+zct+egva2BTchw7E1L/GO7UOBE1GmM1LJe/sTH
         WF6jkYBhk6HwiHKNAW0FvSkTHTFDSfGEa1aZNNkDoocAMFXUXiJHz6aqwFVM452m8/mH
         PLbg==
X-Gm-Message-State: AOAM5335rvPn0F0Bt8oIhc8GX9LalpA/4Z+mxYHodQwEI7vzDNjj26Gj
        9gflXmAqU7pP+Yyn04rKkS8giz1mXfJ3tTk3X9fXMexAXaM=
X-Google-Smtp-Source: ABdhPJxpWRmJuQc45Mu2zDtBT8Yxx3zT/6RR/yC2BBhjIHeod2k0wQ/3KgvX7nHp9bI3uNpu/Wi17209pUXDUIvOQB0=
X-Received: by 2002:a9d:ed6:: with SMTP id 80mr209544otj.35.1637624760387;
 Mon, 22 Nov 2021 15:46:00 -0800 (PST)
MIME-Version: 1.0
References: <20211018112201.25424-1-noralf@tronnes.org> <CACRpkdZQSB+McOGK9HZUNAr2p+FX=6ddbY=5-sQ8difh1pEqGg@mail.gmail.com>
 <56881c23-8659-04e2-e7c1-264f7ef1b752@tronnes.org>
In-Reply-To: <56881c23-8659-04e2-e7c1-264f7ef1b752@tronnes.org>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Tue, 23 Nov 2021 00:45:48 +0100
Message-ID: <CACRpkdaGyiNubyxsTQtQ=VPj5-GiHwDS61L9kMVHEyNAN-yoBw@mail.gmail.com>
Subject: Re: [PATCH] gpio: dln2: Fix interrupts when replugging the device
To:     =?UTF-8?Q?Noralf_Tr=C3=B8nnes?= <noralf@tronnes.org>
Cc:     "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        stable <stable@vger.kernel.org>,
        Daniel Baluta <daniel.baluta@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 22, 2021 at 9:28 PM Noralf Tr=C3=B8nnes <noralf@tronnes.org> wr=
ote:

> Has this been applied, I can't see it in -next?

Bartosz is applying patches for the recent kernels, I bet he will
get to it.

Yours,
Linus Walleij
