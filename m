Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0063819D5CD
	for <lists+stable@lfdr.de>; Fri,  3 Apr 2020 13:28:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727882AbgDCL2y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Apr 2020 07:28:54 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:40463 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727927AbgDCL2x (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Apr 2020 07:28:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585913332;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XPEESavfwM63xVWOo7cUuTIhyZC7PlahLCpO+H+H8EM=;
        b=Hs0QkBevFCeYXZqhVSLAZjJXpO54q8nlYy6saKxYOvGposxlsE95wT6JwDBjDOBiPzCS+L
        Z4zPunWQonTeqldYp4RfssU6vwGI0/e1TqdmmJrwW9YkK0TPgHe5Ovs8ppcgJ7vi4s43jE
        cB0AbTOnep34FpXUmJlemPbEcXj5agc=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-98-E5Rn06QnPgeAn0NuVaEsOw-1; Fri, 03 Apr 2020 07:28:49 -0400
X-MC-Unique: E5Rn06QnPgeAn0NuVaEsOw-1
Received: by mail-qv1-f72.google.com with SMTP id v4so5499319qvt.3
        for <stable@vger.kernel.org>; Fri, 03 Apr 2020 04:28:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XPEESavfwM63xVWOo7cUuTIhyZC7PlahLCpO+H+H8EM=;
        b=n2vTEUEuUr1fStKgwZSqF+VvqlNqLZWFtT2gIt875zfDwX8A6E2nMF+e+NweuqAoys
         9xUmkpJ+w8PnJqsAaTlLKIg98Es+PJRBzN5yHKGDTQ/9vzu9EF3ELt72WCBeHdVfJQ0q
         hEdxmpRII0WM4gZ5hXnoXmk6gYwVtTk7blYoLBgwAC/91J1C1CPXEMsx7Wsxm3Y+1PEZ
         YB74H2iirvwXyBS90NkpzhvzCe/Bj0Npp7ram+YH7sRW+433F5U0FwAu8I3s2jm+CvcV
         TrUZjtyG32JNRbeMejiSDmWQNpiC2s7u/XRP8ASYe8jYmQJPMG2chiaynsxf3giJilPD
         SJeA==
X-Gm-Message-State: AGi0Pua/NzaNJ7lNIxS9GkrAIB44Knl5lRC1Ddjc5h9PUEB7GaH+Qzh7
        as4ziZLarHiDtGvb6AOW4kICKGdopXROUQooCIF9up3kKD2JuRV12Bki4Iqs0/9p+RxsNGci3fu
        GJVTTJ2rAgzmUN6DkkCwj5Ua/Ez9K80sc
X-Received: by 2002:a05:620a:1395:: with SMTP id k21mr6462408qki.230.1585913328494;
        Fri, 03 Apr 2020 04:28:48 -0700 (PDT)
X-Google-Smtp-Source: APiQypKzw2Z4lsArYbYDmYmJeoDn6UPC+SM+FM5wuTW7i+X8by6uB1fpKgjtGxQ/u8mvg42AApuy1cyioBaYs3zO7Xc=
X-Received: by 2002:a05:620a:1395:: with SMTP id k21mr6462383qki.230.1585913328025;
 Fri, 03 Apr 2020 04:28:48 -0700 (PDT)
MIME-Version: 1.0
References: <20200401212329.23305-1-jason.gerecke@wacom.com>
In-Reply-To: <20200401212329.23305-1-jason.gerecke@wacom.com>
From:   Benjamin Tissoires <benjamin.tissoires@redhat.com>
Date:   Fri, 3 Apr 2020 13:28:36 +0200
Message-ID: <CAO-hwJJMRzGpfOQtBUsOkiGO44LLudL7_rbqC4Ec9Ti8Ua-aGA@mail.gmail.com>
Subject: Re: [PATCH] HID: wacom: Read HID_DG_CONTACTMAX directly for
 non-generic devices
To:     "Gerecke, Jason" <killertofu@gmail.com>
Cc:     "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Ping Cheng <pinglinux@gmail.com>,
        Aaron Armstrong Skomra <skomra@gmail.com>,
        Jason Gerecke <jason.gerecke@wacom.com>,
        Aaron Armstrong Skomra <aaron.skomra@wacom.com>,
        "3.8+" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 1, 2020 at 11:23 PM Gerecke, Jason <killertofu@gmail.com> wrote:
>
> From: Jason Gerecke <jason.gerecke@wacom.com>
>
> We've recently switched from extracting the value of HID_DG_CONTACTMAX
> at a fixed offset (which may not be correct for all tablets) to
> injecting the report into the driver for the generic codepath to handle.
> Unfortunately, this change was made for *all* tablets, even those which
> aren't generic. Because `wacom_wac_report` ignores reports from non-
> generic devices, the contact count never gets initialized. Ultimately
> this results in the touch device itself failing to probe, and thus the
> loss of touch input.
>
> This commit adds back the fixed-offset extraction for non-generic devices.
>
> Ref: https://github.com/linuxwacom/input-wacom/issues/155

I think the official tag is "Link", not "Ref". I changed it.

> Fixes: 184eccd40389 ("HID: wacom: generic: read HID_DG_CONTACTMAX from any feature report")
> Signed-off-by: Jason Gerecke <jason.gerecke@wacom.com>
> Reviewed-by: Aaron Armstrong Skomra <aaron.skomra@wacom.com>
> CC: stable@vger.kernel.org # 5.3+
> ---

I really wish we had regression tests for Wacom devices too. This
could have been avoided in the first place.

Anyway, applied to for-5.7/upstream-fixes

Thanks!

Cheers,
Benjamin

>  drivers/hid/wacom_sys.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/hid/wacom_sys.c b/drivers/hid/wacom_sys.c
> index 5ded94b7bf68..cd71e7133944 100644
> --- a/drivers/hid/wacom_sys.c
> +++ b/drivers/hid/wacom_sys.c
> @@ -319,9 +319,11 @@ static void wacom_feature_mapping(struct hid_device *hdev,
>                         data[0] = field->report->id;
>                         ret = wacom_get_report(hdev, HID_FEATURE_REPORT,
>                                                data, n, WAC_CMD_RETRIES);
> -                       if (ret == n) {
> +                       if (ret == n && features->type == HID_GENERIC) {
>                                 ret = hid_report_raw_event(hdev,
>                                         HID_FEATURE_REPORT, data, n, 0);
> +                       } else if (ret == 2 && features->type != HID_GENERIC) {
> +                               features->touch_max = data[1];
>                         } else {
>                                 features->touch_max = 16;
>                                 hid_warn(hdev, "wacom_feature_mapping: "
> --
> 2.26.0
>

