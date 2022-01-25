Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B80649BA8A
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 18:43:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238260AbiAYRmj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 12:42:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384365AbiAYRmS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jan 2022 12:42:18 -0500
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A448C06173B;
        Tue, 25 Jan 2022 09:42:17 -0800 (PST)
Received: by mail-oi1-x232.google.com with SMTP id s127so32474467oig.2;
        Tue, 25 Jan 2022 09:42:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=GkhoMW3s8ud4mUDqS56CMazGwsmOxKoOKQYICxTpIPc=;
        b=VcCaq0WRXcTDQDefya7gPvZxSy6EoRZq/oGJX6encxp6qzQiBibyt90XN/oRVGjmsS
         rsn9fLxoAxpp2oORsL0UU+ZO7zuvHI98RIDnwwMeytFwzmwyK9M8Phj1yDBeeTASoP4v
         hpLe+VxKNXNsOWKobgHY68cVMc3LGgyDG2v/wFwccUEAPuatvbjIW1gWHXhAKDw9IGVm
         mBgGgCqRCyBgO+EZXP0sI5fV2JppiHmSzLTIPJSzfqVppQWxaVlUSWiETJy3Em7r29Jh
         TDs45cazm+o62LcBFpuY7spCbWiLQM3YSw9+xLWnnIVG7eG9mHTfCtLe884bMXPNfg7q
         YvXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=GkhoMW3s8ud4mUDqS56CMazGwsmOxKoOKQYICxTpIPc=;
        b=Ek0Q2DtqntWZ8WZKg0HdxkzL9QwUA5UJZxMO7pDGwc06M7fh3v5/75YWbP11n7P+NT
         qDIxBHand550nVTNwlUzAbI7zUF4fjl6BmbVYUTnXVMCV+E/IR96NsWqCBILw+vajdvE
         LXIiQ74DZalPcJB3g52/Cd1hlxeTtFl8TRaJhe6t4x+kk0GJhpVTwA1hePB2/j/7CH+y
         XT5/szPtDknnq+pnXSQZ3yuKFxhNqhIQPhWgNYPAgY4ql+nQBXblwRpbfFUyp6oxgI+4
         MbOZH2WltIqX7rJ/ycb9DUKdipmhRHxvAImIDrRN3CBm4MMoptTD6nUWSB4ucJPZPS8R
         i+tQ==
X-Gm-Message-State: AOAM532WJOCa+keTFX+wOG0aJA+8/4AcTKhK5au4wyHjOCBcsJvtuX4+
        9DFkLBfkbgQjajsHLbIJiIK0U52VFYc=
X-Google-Smtp-Source: ABdhPJw9EIQ0FIRh2buNnjVlDrTqmMZbofTLQ2meubGTPi+iquR9rm6XIQ2oSXwp3yfAKO7h8g4Ynw==
X-Received: by 2002:a54:4694:: with SMTP id k20mr1429660oic.136.1643132536671;
        Tue, 25 Jan 2022 09:42:16 -0800 (PST)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id n12sm4292688oop.5.2022.01.25.09.42.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Jan 2022 09:42:15 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <796d26d7-fc67-1a97-7166-578367e141e4@roeck-us.net>
Date:   Tue, 25 Jan 2022 09:42:13 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v1 1/2] usb: typec: tcpm: Do not disconnect while
 receiving VBUS off
Content-Language: en-US
To:     Badhri Jagan Sridharan <badhri@google.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kyle Tso <kyletso@google.com>, stable@vger.kernel.org
References: <20220122015520.332507-1-badhri@google.com>
From:   Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <20220122015520.332507-1-badhri@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/21/22 17:55, Badhri Jagan Sridharan wrote:
> With some chargers, vbus might momentarily raise above VSAFE5V and fall
> back to 0V before tcpm gets to read port->tcpc->get_vbus. This will
> will report a VBUS off event causing TCPM to transition to

s/will will/will/

> SNK_UNATTACHED where it should be waiting in either SNK_ATTACH_WAIT
> or SNK_DEBOUNCED state. This patch makes TCPM avoid vbus off events
> while in SNK_ATTACH_WAIT or SNK_DEBOUNCED state.
> 
> Stub from the spec:
>      "4.5.2.2.4.2 Exiting from AttachWait.SNK State
>      A Sink shall transition to Unattached.SNK when the state of both
>      the CC1 and CC2 pins is SNK.Open for at least tPDDebounce.
>      A DRP shall transition to Unattached.SRC when the state of both
>      the CC1 and CC2 pins is SNK.Open for at least tPDDebounce."
> 
> [23.194131] CC1: 0 -> 0, CC2: 0 -> 5 [state SNK_UNATTACHED, polarity 0, connected]
> [23.201777] state change SNK_UNATTACHED -> SNK_ATTACH_WAIT [rev3 NONE_AMS]
> [23.209949] pending state change SNK_ATTACH_WAIT -> SNK_DEBOUNCED @ 170 ms [rev3 NONE_AMS]
> [23.300579] VBUS off
> [23.300668] state change SNK_ATTACH_WAIT -> SNK_UNATTACHED [rev3 NONE_AMS]
> [23.301014] VBUS VSAFE0V
> [23.301111] Start toggling
> 
> Fixes: f0690a25a140b8 ("staging: typec: USB Type-C Port Manager (tcpm)")
> Cc: stable@vger.kernel.org
> Signed-off-by: Badhri Jagan Sridharan <badhri@google.com>
> ---
>   drivers/usb/typec/tcpm/tcpm.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/usb/typec/tcpm/tcpm.c b/drivers/usb/typec/tcpm/tcpm.c
> index 59d4fa2443f2..b8afe3d8c882 100644
> --- a/drivers/usb/typec/tcpm/tcpm.c
> +++ b/drivers/usb/typec/tcpm/tcpm.c
> @@ -5156,7 +5156,8 @@ static void _tcpm_pd_vbus_off(struct tcpm_port *port)
>   	case SNK_TRYWAIT_DEBOUNCE:
>   		break;
>   	case SNK_ATTACH_WAIT:
> -		tcpm_set_state(port, SNK_UNATTACHED, 0);
> +	case SNK_DEBOUNCED:
> +		/* Do nothing, as TCPM is still waiting for vbus to reaach VSAFE5V to connect */

s/reaach/reach/

Other than that,

Reviewed-by: Guenter Roeck <linux@roeck-us.net>

>   		break;
>   
>   	case SNK_NEGOTIATE_CAPABILITIES:

