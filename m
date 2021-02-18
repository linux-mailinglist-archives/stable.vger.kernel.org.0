Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA98231E7FB
	for <lists+stable@lfdr.de>; Thu, 18 Feb 2021 10:27:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231490AbhBRJZf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Feb 2021 04:25:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:47552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231387AbhBRJBT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Feb 2021 04:01:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 65A226146D;
        Thu, 18 Feb 2021 08:36:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613637406;
        bh=ig1PRDkBsfJjMTNunl5XG8hqPYLolURUKj9iYucYfEI=;
        h=Date:From:To:cc:Subject:In-Reply-To:References:From;
        b=NC7dydBYMic99DW4E1gqG29vUrZfFeLKkuJ8DNFLcPuYfV9WM0Nb1S0xcjA7+H03D
         E+nDGRBSpWSLQnLy2SuyMHMNDGxKZZV2n/SUBhqNb6Wx9aw1smiZ8SuTTCB2baqzjZ
         y6PG3C8eU5hU/gXEs8Q6mkBUDNO3PGenPPySuYN/RkBTI/nf33IYFIaCOIO+IVNDts
         EHhetSotUJRkhIYX/cyhYcvElmpUhmqiI4zZnP2yDiDuxhHfSieBIVouA+vQmKxtFb
         lES2X+eyEv49Cw9UWTvu8NHJ/Sw1Qjo8OZ/N0sJU7C7OP8obp/leYEOuspKz4xy0L7
         kh6nUQqIKajiQ==
Date:   Thu, 18 Feb 2021 09:36:42 +0100 (CET)
From:   Jiri Kosina <jikos@kernel.org>
To:     Jason Gerecke <killertofu@gmail.com>
cc:     linux-input@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Ping Cheng <pinglinux@gmail.com>,
        Aaron Armstrong Skomra <skomra@gmail.com>,
        Jason Gerecke <jason.gerecke@wacom.com>, stable@vger.kernel.org
Subject: Re: [PATCH] HID: wacom: Ignore attempts to overwrite the touch_max
 value from HID
In-Reply-To: <20210216194154.111950-1-jason.gerecke@wacom.com>
Message-ID: <nycvar.YFH.7.76.2102180936340.28696@cbobk.fhfr.pm>
References: <20210216194154.111950-1-jason.gerecke@wacom.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 16 Feb 2021, Jason Gerecke wrote:

> The `wacom_feature_mapping` function is careful to only set the the
> touch_max value a single time, but this care does not extend to the
> `wacom_wac_finger_event` function. In particular, if a device sends
> multiple HID_DG_CONTACTMAX items in a single feature report, the
> driver will end up retaining the value of last item.
> 
> The HID descriptor for the Cintiq Companion 2 does exactly this. It
> incorrectly sets a "Report Count" of 2, which will cause the driver
> to process two HID_DG_CONTACTCOUNT items. The first item has the actual
> count, while the second item should have been declared as a constant
> zero. The constant zero is the value the driver ends up using, however,
> since it is the last HID_DG_CONTACTCOUNT in the report.
> 
>     Report ID (16),
>     Usage (Contact Count Maximum),  ; Contact count maximum (55h, static value)
>     Report Count (2),
>     Logical Maximum (10),
>     Feature (Variable),
> 
> To address this, we add a check that the touch_max is not already set
> within the `wacom_wac_finger_event` function that processes the
> HID_DG_TOUCHMAX item. We emit a warning if the value is set and ignore
> the updated value.
> 
> This could potentially cause problems if there is a tablet which has
> a similar issue but requires the last item to be used. This is unlikely,
> however, since it would have to have a different non-zero value for
> HID_DG_CONTACTMAX earlier in the same report, which makes no sense
> except in the case of a firmware bug. Note that cases where the
> HID_DG_CONTACTMAX items are in different reports is already handled
> (and similarly ignored) by `wacom_feature_mapping` as mentioned above.
> 
> Link: https://github.com/linuxwacom/input-wacom/issues/223
> Fixes: 184eccd40389 ("HID: wacom: generic: read HID_DG_CONTACTMAX from any feature report")
> Signed-off-by: Jason Gerecke <jason.gerecke@wacom.com>
> CC: stable@vger.kernel.org
> ---
>  drivers/hid/wacom_wac.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/hid/wacom_wac.c b/drivers/hid/wacom_wac.c
> index 1bd0eb71559c..44d715c12f6a 100644
> --- a/drivers/hid/wacom_wac.c
> +++ b/drivers/hid/wacom_wac.c
> @@ -2600,7 +2600,12 @@ static void wacom_wac_finger_event(struct hid_device *hdev,
>  		wacom_wac->is_invalid_bt_frame = !value;
>  		return;
>  	case HID_DG_CONTACTMAX:
> -		features->touch_max = value;
> +		if (!features->touch_max) {
> +			features->touch_max = value;
> +		} else {
> +			hid_warn(hdev, "%s: ignoring attempt to overwrite non-zero touch_max "
> +				 "%d -> %d\n", __func__, features->touch_max, value);
> +		}
>  		return;

Applied, thanks Jason.

-- 
Jiri Kosina
SUSE Labs

