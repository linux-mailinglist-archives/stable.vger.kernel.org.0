Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C4C921C1B3
	for <lists+stable@lfdr.de>; Sat, 11 Jul 2020 03:59:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727081AbgGKB74 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jul 2020 21:59:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726605AbgGKB74 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Jul 2020 21:59:56 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 420DBC08C5DC;
        Fri, 10 Jul 2020 18:59:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Type:Cc:To:Subject:Message-ID:
        Date:From:In-Reply-To:References:MIME-Version:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=GJ2VXjaXhltgn72DqcDl/jnnOyZmVWOtXKtl2Y057oo=; b=tk4vRva+QY4640r/s8MZLCMbZV
        cVXZMSneHNkeVaHz5yIRAH4KL12fr02XWi/CmEi+sHYaMqB5j4bD3IWUgchxIaTgXlXeLHbfI7ROE
        5PY/GS2BxhijpdLfeUR17GFU689anJpACJNXncCMlWv/6nYeyKT4VZf/6Wb3v6WJmB1VbTXhkJ6i+
        wSjHR5CxUM1DIRVpmJZJzHiKoXs4fEpFXUjaZ+IhIesRMibdUFviWaP0UZsytNK1uAoLZEckoBl+T
        3y6+BNnbcseJzWZjrFDeaeg4gghcSd/d2WiBMQumxK73PqoqDMX7fqm1m+h2d4hNgUBLo99xhvVSh
        DMIbde9Q==;
Received: from mail-pl1-f169.google.com ([209.85.214.169])
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ju4ny-0006nL-8h; Sat, 11 Jul 2020 01:59:54 +0000
Received: by mail-pl1-f169.google.com with SMTP id x9so2978314plr.2;
        Fri, 10 Jul 2020 18:59:54 -0700 (PDT)
X-Gm-Message-State: AOAM5328m+FspgbAyQToMM1XM+K/ID0iRzaSYNgKo44dlY+vz3pe9y3i
        DOhtLKcKK8f/HEb+g3icCYanQHW8mEaRZQ5ehRU=
X-Google-Smtp-Source: ABdhPJy9VCFQi6K1gZSN++kbomTkvoCuFXvMgXWCiF21Lt+lovEI91BXTIDGuLt+jC7SpNJ1amw5FQDlw3XP0HqmAiE=
X-Received: by 2002:a17:902:121:: with SMTP id 30mr62096147plb.44.1594432793558;
 Fri, 10 Jul 2020 18:59:53 -0700 (PDT)
MIME-Version: 1.0
References: <20200710151939.4894-1-grant.likely@arm.com>
In-Reply-To: <20200710151939.4894-1-grant.likely@arm.com>
From:   Darren Hart <dvhart@infradead.org>
Date:   Fri, 10 Jul 2020 18:59:42 -0700
X-Gmail-Original-Message-ID: <CAJuF2pzvh2G7_2q88a4e=dpB1RATrdF8jsOkpVuuueZLGGbsiQ@mail.gmail.com>
Message-ID: <CAJuF2pzvh2G7_2q88a4e=dpB1RATrdF8jsOkpVuuueZLGGbsiQ@mail.gmail.com>
Subject: Re: [PATCH] hid-input: Fix devices that return multiple bytes in
 battery report
To:     Grant Likely <grant.likely@secretlab.ca>
Cc:     LKML <linux-kernel@vger.kernel.org>, linux-input@vger.kernel.org,
        Grant Likely <grant.likely@arm.com>,
        Darren Hart <darren@dvhart.com>,
        Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 10, 2020 at 8:19 AM Grant Likely <grant.likely@secretlab.ca> wrote:
>
> Some devices, particularly the 3DConnexion Spacemouse wireless 3D
> controllers, return more than just the battery capacity in the battery
> report. The Spacemouse devices return an additional byte with a device
> specific field. However, hidinput_query_battery_capacity() only
> requests a 2 byte transfer.
>
> When a spacemouse is connected via USB (direct wire, no wireless dongle)
> and it returns a 3 byte report instead of the assumed 2 byte battery
> report the larger transfer confuses and frightens the USB subsystem
> which chooses to ignore the transfer. Then after 2 seconds assume the
> device has stopped responding and reset it. This can be reproduced
> easily by using a wired connection with a wireless spacemouse. The
> Spacemouse will enter a loop of resetting every 2 seconds which can be
> observed in dmesg.
>
> This patch solves the problem by increasing the transfer request to 4
> bytes instead of 2. The fix isn't particularly elegant, but it is simple
> and safe to backport to stable kernels. A further patch will follow to
> more elegantly handle battery reports that contain additional data.
>

Applied and tested on 5.8.0-rc4+ (aa0c9086b40c) with a 3Dconnexion
SpaceMouse Wireless (tested connected via USB). Observed the same
behavior Grant reports before the patch. After the patch, the device stays
connected successfully.

Tested-by: Darren Hart <dvhart@infradead.org>

Thanks Grant!

> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> Cc: Darren Hart <darren@dvhart.com>
> Cc: Jiri Kosina <jikos@kernel.org>
> Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> Cc: stable@vger.kernel.org
> ---
>  drivers/hid/hid-input.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
> index dea9cc65bf80..e8641ce677e4 100644
> --- a/drivers/hid/hid-input.c
> +++ b/drivers/hid/hid-input.c
> @@ -350,13 +350,13 @@ static int hidinput_query_battery_capacity(struct hid_device *dev)
>         u8 *buf;
>         int ret;
>
> -       buf = kmalloc(2, GFP_KERNEL);
> +       buf = kmalloc(4, GFP_KERNEL);
>         if (!buf)
>                 return -ENOMEM;
>
> -       ret = hid_hw_raw_request(dev, dev->battery_report_id, buf, 2,
> +       ret = hid_hw_raw_request(dev, dev->battery_report_id, buf, 4,
>                                  dev->battery_report_type, HID_REQ_GET_REPORT);
> -       if (ret != 2) {
> +       if (ret < 2) {
>                 kfree(buf);
>                 return -ENODATA;
>         }
> --
> 2.20.1
>
