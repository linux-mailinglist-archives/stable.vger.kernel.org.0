Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 784373D8B00
	for <lists+stable@lfdr.de>; Wed, 28 Jul 2021 11:44:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235012AbhG1Jof (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Jul 2021 05:44:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:53220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231408AbhG1Jod (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 28 Jul 2021 05:44:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4C7AC60F9C;
        Wed, 28 Jul 2021 09:44:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627465472;
        bh=VAUZjyg+BAF8EV3Hg0K31vHi7rqtqopGlzdb86UM9FI=;
        h=Date:From:To:cc:Subject:In-Reply-To:References:From;
        b=ETlaB0Tg2k7j4XxG1jZnDv1lMR1GRxhBxswCSC52pZ0rlvLTPKsio5cRMv7Ug9wlj
         E9WEQzURspnI9QKgGXqMxfLydzw7oGzZmcSaIKbsIzlsBUnRD+fB6hYdtEnqObOJzd
         myFj9qlKfyPXheS1OlHCka7J0qNuGLmWS2ruLf9JG16Taz49X69If741fzjhVAVSfz
         uPf3/swod3xZizj5eLaK6RzB/B6XV949r1fajkrRniz2Q0oU8ilteDiXqOA3KoN6qz
         Gi20DGOjiZvzIACqEZFpG/jQkYqMPNBwI5hJaC8zMJ5m3f1Lc61jtbQA26/qcpaOnG
         6BjsLZkSgCwuQ==
Date:   Wed, 28 Jul 2021 11:44:29 +0200 (CEST)
From:   Jiri Kosina <jikos@kernel.org>
To:     Jason Gerecke <killertofu@gmail.com>
cc:     linux-input@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Ping Cheng <pinglinux@gmail.com>,
        Jason Gerecke <jason.gerecke@wacom.com>,
        stable@vger.kernel.org, Ping Cheng <ping.cheng@wacom.com>
Subject: Re: [PATCH 1/6] HID: wacom: Re-enable touch by default for Cintiq
 24HDT / 27QHDT
In-Reply-To: <20210719205533.2189804-1-jason.gerecke@wacom.com>
Message-ID: <nycvar.YFH.7.76.2107281143510.8253@cbobk.fhfr.pm>
References: <20210719205533.2189804-1-jason.gerecke@wacom.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 19 Jul 2021, Jason Gerecke wrote:

> Commit 670e90924bfe ("HID: wacom: support named keys on older devices")
> added support for sending named events from the soft buttons on the
> 24HDT and 27QHDT. In the process, however, it inadvertantly disabled the
> touchscreen of the 24HDT and 27QHDT by default. The
> `wacom_set_shared_values` function would normally enable touch by default
> but because it checks the state of the non-shared `has_mute_touch_switch`
> flag and `wacom_setup_touch_input_capabilities` sets the state of the
> /shared/ version, touch ends up being disabled by default.
> 
> This patch sets the non-shared flag, letting `wacom_set_shared_values`
> take care of copying the value over to the shared version and setting
> the default touch state to "on".
> 
> Fixes: 670e90924bfe ("HID: wacom: support named keys on older devices")
> CC: stable@vger.kernel.org # 5.4+
> Signed-off-by: Jason Gerecke <jason.gerecke@wacom.com>
> Reviewed-by: Ping Cheng <ping.cheng@wacom.com>
> ---
>  drivers/hid/wacom_wac.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/hid/wacom_wac.c b/drivers/hid/wacom_wac.c
> index 81d7d12bcf34..496a000ef862 100644
> --- a/drivers/hid/wacom_wac.c
> +++ b/drivers/hid/wacom_wac.c
> @@ -3831,7 +3831,7 @@ int wacom_setup_touch_input_capabilities(struct input_dev *input_dev,
>  		    wacom_wac->shared->touch->product == 0xF6) {
>  			input_dev->evbit[0] |= BIT_MASK(EV_SW);
>  			__set_bit(SW_MUTE_DEVICE, input_dev->swbit);
> -			wacom_wac->shared->has_mute_touch_switch = true;
> +			wacom_wac->has_mute_touch_switch = true;
>  		}
>  		fallthrough;
>  

This patch series looks strangely like not really a series at all :) I am 
applying 1/6 and 4/6 for 5.14 and queuing the rest for 5.15. Please shout 
if you disagree with that. Thanks,

-- 
Jiri Kosina
SUSE Labs

