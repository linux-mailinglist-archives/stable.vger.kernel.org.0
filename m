Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D31F45D072
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 23:50:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352266AbhKXWxZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 17:53:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352240AbhKXWxY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Nov 2021 17:53:24 -0500
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86972C061574;
        Wed, 24 Nov 2021 14:50:14 -0800 (PST)
Received: by mail-oi1-x22d.google.com with SMTP id 7so8345793oip.12;
        Wed, 24 Nov 2021 14:50:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8z5DnL294+kOFa8KKsJ6CHxEPrBW46Q9Z5g6TD/+y1E=;
        b=Vi69ecp+OK1BFt/lyxSqyIwScNgLAfQuPrPT7nmHe0LTrjdyheWg3nzWqKBBcd4Bcy
         YxLVgtTip8k8eDG+6tMqX2c95yBwRkjsyN9uM2U0N3iYrQJWeLqhpwBe8OHMRCFySnvP
         NH8O3UL+9qVZYDh5R1nwKiJVyYJOR6mFozm3iZAX+QJq6fveY2irosDM2k5EKhdrrwrI
         69zt1e/Io0cp0epGWDbSgVA+QyuVT7MG/gZ1hrGT334LRnIZBqhtw6rt4VFjHY0vkfz8
         DOCbvrRbM9BRldo+2+EsWD3M2rNVUG+bqpuhP3NVqgfgM6ah3Ar4a3/6WmUaxCgDZ6Z0
         krEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8z5DnL294+kOFa8KKsJ6CHxEPrBW46Q9Z5g6TD/+y1E=;
        b=ohBXAjgRZh5dWasMv7OCTcDa0/RXR0s7hNSFVcIof3+q5ZAKumwbY3y7GF1xCHeV5/
         SmSprW3/o4RIAjisjNLqVbCVNQewblz3QjPPzbmDa+dLW0lsg5AHutAijb9rZ6kCr5jS
         3k7y3vMc4I+2pD1VBVydfLnhTZOko+ikJ6aXL8D5xNMfVIOXFZ8Ohk2HfCNK1K1of3nE
         u/V11HSUZ3XCsg5AoFXcOw06f1j24KCeWx75oKA9t7TJs315WwKuWd+RFSpttAQxlTu2
         eF2kR8sCdrjzuU5UqOY1AwPUYNtF3H+BdlJ+p4/Y74Z2frjckvPVJo4V/uPJ/+BaqK7B
         Ax3Q==
X-Gm-Message-State: AOAM530qLLYDIPXcFLTVNpxkbQCpxuABDVqU/6tj4dp2AM5/fxvwJsEX
        IGTkulKPzm3Jj/oEuL10lDsMmwLk9xA=
X-Google-Smtp-Source: ABdhPJxRwZN4Qhz2hoXYzxSAhk2VBlsljaT00vzZfbQ7LC64tys+B/5+Co3g98aiE/xHJG1uIfN2uA==
X-Received: by 2002:a05:6808:f08:: with SMTP id m8mr10039518oiw.5.1637794213695;
        Wed, 24 Nov 2021 14:50:13 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id g4sm217942oof.40.2021.11.24.14.50.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Nov 2021 14:50:12 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Subject: Re: [PATCH v1] usb: typec: tcpm: Wait in SNK_DEBOUNCED until
 disconnect
To:     Badhri Jagan Sridharan <badhri@google.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kyle Tso <kyletso@google.com>, stable@vger.kernel.org
References: <20211124224036.734679-1-badhri@google.com>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <e9b8ec9f-6790-3b83-2298-4032e169cea2@roeck-us.net>
Date:   Wed, 24 Nov 2021 14:50:10 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211124224036.734679-1-badhri@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/24/21 2:40 PM, Badhri Jagan Sridharan wrote:
> Stub from the spec:
> "4.5.2.2.4.2 Exiting from AttachWait.SNK State
> A Sink shall transition to Unattached.SNK when the state of both
> the CC1 and CC2 pins is SNK.Open for at least tPDDebounce.
> A DRP shall transition to Unattached.SRC when the state of both
> the CC1 and CC2 pins is SNK.Open for at least tPDDebounce."
> 
> This change makes TCPM to wait in SNK_DEBOUNCED state until
> CC1 and CC2 pins is SNK.Open for at least tPDDebounce. Previously,
> TCPM resets the port if vbus is not present in PD_T_PS_SOURCE_ON.
> This causes TCPM to loop continuously when connected to a
> faulty power source that does not present vbus. Waiting in
> SNK_DEBOUNCED also ensures that TCPM is adherant to
> "4.5.2.2.4.2 Exiting from AttachWait.SNK State" requirements.
> 
> [ 6169.280751] CC1: 0 -> 0, CC2: 0 -> 5 [state TOGGLING, polarity 0, connected]
> [ 6169.280759] state change TOGGLING -> SNK_ATTACH_WAIT [rev2 NONE_AMS]
> [ 6169.280771] pending state change SNK_ATTACH_WAIT -> SNK_DEBOUNCED @ 170 ms [rev2 NONE_AMS]
> [ 6169.282427] CC1: 0 -> 0, CC2: 5 -> 5 [state SNK_ATTACH_WAIT, polarity 0, connected]
> [ 6169.450825] state change SNK_ATTACH_WAIT -> SNK_DEBOUNCED [delayed 170 ms]
> [ 6169.450834] pending state change SNK_DEBOUNCED -> PORT_RESET @ 480 ms [rev2 NONE_AMS]
> [ 6169.930892] state change SNK_DEBOUNCED -> PORT_RESET [delayed 480 ms]
> [ 6169.931296] disable vbus discharge ret:0
> [ 6169.931301] Setting usb_comm capable false
> [ 6169.932783] Setting voltage/current limit 0 mV 0 mA
> [ 6169.932802] polarity 0
> [ 6169.933706] Requesting mux state 0, usb-role 0, orientation 0
> [ 6169.936689] cc:=0
> [ 6169.936812] pending state change PORT_RESET -> PORT_RESET_WAIT_OFF @ 100 ms [rev2 NONE_AMS]
> [ 6169.937157] CC1: 0 -> 0, CC2: 5 -> 0 [state PORT_RESET, polarity 0, disconnected]
> [ 6170.036880] state change PORT_RESET -> PORT_RESET_WAIT_OFF [delayed 100 ms]
> [ 6170.036890] state change PORT_RESET_WAIT_OFF -> SNK_UNATTACHED [rev2 NONE_AMS]
> [ 6170.036896] Start toggling
> [ 6170.041412] CC1: 0 -> 0, CC2: 0 -> 0 [state TOGGLING, polarity 0, disconnected]
> [ 6170.042973] CC1: 0 -> 0, CC2: 0 -> 5 [state TOGGLING, polarity 0, connected]
> [ 6170.042976] state change TOGGLING -> SNK_ATTACH_WAIT [rev2 NONE_AMS]
> [ 6170.042981] pending state change SNK_ATTACH_WAIT -> SNK_DEBOUNCED @ 170 ms [rev2 NONE_AMS]
> [ 6170.213014] state change SNK_ATTACH_WAIT -> SNK_DEBOUNCED [delayed 170 ms]
> [ 6170.213019] pending state change SNK_DEBOUNCED -> PORT_RESET @ 480 ms [rev2 NONE_AMS]
> [ 6170.693068] state change SNK_DEBOUNCED -> PORT_RESET [delayed 480 ms]
> [ 6170.693304] disable vbus discharge ret:0
> [ 6170.693308] Setting usb_comm capable false
> [ 6170.695193] Setting voltage/current limit 0 mV 0 mA
> [ 6170.695210] polarity 0
> [ 6170.695990] Requesting mux state 0, usb-role 0, orientation 0
> [ 6170.701896] cc:=0
> [ 6170.702181] pending state change PORT_RESET -> PORT_RESET_WAIT_OFF @ 100 ms [rev2 NONE_AMS]
> [ 6170.703343] CC1: 0 -> 0, CC2: 5 -> 0 [state PORT_RESET, polarity 0, disconnected]
> 
> Fixes: f0690a25a140b8 ("staging: typec: USB Type-C Port Manager (tcpm)")
> Signed-off-by: Badhri Jagan Sridharan <badhri@google.com>

Reviewed-by: Guenter Roeck <linux@roeck-us.net>

> ---
>   drivers/usb/typec/tcpm/tcpm.c | 4 ----
>   1 file changed, 4 deletions(-)
> 
> diff --git a/drivers/usb/typec/tcpm/tcpm.c b/drivers/usb/typec/tcpm/tcpm.c
> index 7f2f3ff1b391..6010b9901126 100644
> --- a/drivers/usb/typec/tcpm/tcpm.c
> +++ b/drivers/usb/typec/tcpm/tcpm.c
> @@ -4110,11 +4110,7 @@ static void run_state_machine(struct tcpm_port *port)
>   				       tcpm_try_src(port) ? SRC_TRY
>   							  : SNK_ATTACHED,
>   				       0);
> -		else
> -			/* Wait for VBUS, but not forever */
> -			tcpm_set_state(port, PORT_RESET, PD_T_PS_SOURCE_ON);
>   		break;
> -
>   	case SRC_TRY:
>   		port->try_src_count++;
>   		tcpm_set_cc(port, tcpm_rp_cc(port));
> 

