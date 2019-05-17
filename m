Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DA2121B8E
	for <lists+stable@lfdr.de>; Fri, 17 May 2019 18:25:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726078AbfEQQYw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 May 2019 12:24:52 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:46927 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725989AbfEQQYw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 May 2019 12:24:52 -0400
Received: by mail-qt1-f196.google.com with SMTP id z19so8584202qtz.13
        for <stable@vger.kernel.org>; Fri, 17 May 2019 09:24:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nLuc7mQGuXrZ93LGpIUnVmMLZfQJE+kJAvXw64IpPHQ=;
        b=lid4LUjdWdzUqvpZ1NPoOQvIy0CehKrE8fAgzwWkaz+G9lJCCBIa85e/cfhLTWR8nt
         lG+VOo1X+xt9ONwtPtOlWFDiA93HgfNmTd7u7hi+/c+onyQfwqvOrcJToOkCheRSHC2n
         PlXxZc2mb5rZDUGykCkT2j4ISePiXRCDtRO2dpk/F3Nh7NHS5/GQ8V3oVBBWLTOXvdWX
         K1L+bxu4+R94F/OjgA+fnVyBp3gWZJYFzjG9CQDBo4bfbAV7Hu+YaieyaXNQ93ooLOK5
         ztOTuKelJeV3tYenObkFJ1aP0g/l+RMcD/JGRzUiabGO1pflzBIoDWY1HTcwXG4nRbIP
         UtxQ==
X-Gm-Message-State: APjAAAU7OSNDmim1gvDkBmedw5NHyQ73uKuwpB8IFnIieq2skUH0QbfD
        qhxTjpTSH8p7KFzMI8QPY+a1BmmFIJd5Ovk8a6tUgA==
X-Google-Smtp-Source: APXvYqzPoKC1qs9E1DM3+eBqj4N6qE0Eg8hJ1VhdQNYm21O/Q8NY2dDFVJ8O8yz+Cumhk42wvfkY3Mu1J7wU2ua2sdg=
X-Received: by 2002:a0c:87da:: with SMTP id 26mr26823801qvk.192.1558110291827;
 Fri, 17 May 2019 09:24:51 -0700 (PDT)
MIME-Version: 1.0
References: <20190507185322.7168-1-jason.gerecke@wacom.com> <20190507185322.7168-3-jason.gerecke@wacom.com>
In-Reply-To: <20190507185322.7168-3-jason.gerecke@wacom.com>
From:   Benjamin Tissoires <benjamin.tissoires@redhat.com>
Date:   Fri, 17 May 2019 18:24:40 +0200
Message-ID: <CAO-hwJJHFW3TJX-JU2OAHHa_FDTTZcwCduy2vQMU2F=i8ZSr7A@mail.gmail.com>
Subject: Re: [PATCH 3/3] HID: wacom: Sync INTUOSP2_BT touch state after each
 frame if necessary
To:     "Gerecke, Jason" <killertofu@gmail.com>
Cc:     "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        Ping Cheng <pinglinux@gmail.com>,
        Aaron Armstrong Skomra <skomra@gmail.com>,
        Jason Gerecke <jason.gerecke@wacom.com>,
        "3.8+" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 7, 2019 at 8:53 PM Gerecke, Jason <killertofu@gmail.com> wrote:
>
> From: Jason Gerecke <jason.gerecke@wacom.com>
>
> The Bluetooth interface of the 2nd-gen Intuos Pro batches together four
> independent "frames" of finger data into a single report. Each frame
> is essentially equivalent to a single USB report, with the up-to-10
> fingers worth of information being spread across two frames. At the
> moment the driver only calls `input_sync` after processing all four
> frames have been processed, which can result in the driver sending
> multiple updates for a single slot within the same SYN_REPORT. This
> can confuse userspace, so modify the driver to sync more often if
> necessary (i.e., after reporting the state of all fingers).
>
> Fixes: 4922cd26f0 ("HID: wacom: Support 2nd-gen Intuos Pro's Bluetooth classic interface")
> Cc: <stable@vger.kernel.org> # 4.11+
> Signed-off-by: Jason Gerecke <jason.gerecke@wacom.com>
> ---

series applied to for-5.2/upstream-fixes

Cheers,
Benjamin

>  drivers/hid/wacom_wac.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/hid/wacom_wac.c b/drivers/hid/wacom_wac.c
> index e848445236d8..09b8e4aac82f 100644
> --- a/drivers/hid/wacom_wac.c
> +++ b/drivers/hid/wacom_wac.c
> @@ -1371,11 +1371,17 @@ static void wacom_intuos_pro2_bt_touch(struct wacom_wac *wacom)
>                 if (wacom->num_contacts_left <= 0) {
>                         wacom->num_contacts_left = 0;
>                         wacom->shared->touch_down = wacom_wac_finger_count_touches(wacom);
> +                       input_sync(touch_input);
>                 }
>         }
>
> -       input_report_switch(touch_input, SW_MUTE_DEVICE, !(data[281] >> 7));
> -       input_sync(touch_input);
> +       if (wacom->num_contacts_left == 0) {
> +               // Be careful that we don't accidentally call input_sync with
> +               // only a partial set of fingers of processed
> +               input_report_switch(touch_input, SW_MUTE_DEVICE, !(data[281] >> 7));
> +               input_sync(touch_input);
> +       }
> +
>  }
>
>  static void wacom_intuos_pro2_bt_pad(struct wacom_wac *wacom)
> --
> 2.21.0
>
