Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EC1E4CBBB6
	for <lists+stable@lfdr.de>; Thu,  3 Mar 2022 11:50:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231442AbiCCKvU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Mar 2022 05:51:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229996AbiCCKvU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Mar 2022 05:51:20 -0500
X-Greylist: delayed 403 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 03 Mar 2022 02:50:34 PST
Received: from mail.bitwise.fi (mail.bitwise.fi [109.204.228.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AD7117B882
        for <stable@vger.kernel.org>; Thu,  3 Mar 2022 02:50:34 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by mail.bitwise.fi (Postfix) with ESMTP id DAA73460031;
        Thu,  3 Mar 2022 12:43:46 +0200 (EET)
X-Virus-Scanned: Debian amavisd-new at 
Received: from mail.bitwise.fi ([127.0.0.1])
        by localhost (mustetatti.dmz.bitwise.fi [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id dwczB84-Dbc9; Thu,  3 Mar 2022 12:43:44 +0200 (EET)
Received: from [192.168.5.238] (fw1.dmz.bitwise.fi [192.168.69.1])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: anssiha)
        by mail.bitwise.fi (Postfix) with ESMTPSA id 8916F46001C;
        Thu,  3 Mar 2022 12:43:44 +0200 (EET)
Message-ID: <4343c187-e40e-2804-5444-4a45c22e3781@bitwise.fi>
Date:   Thu, 3 Mar 2022 12:43:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH 3/9] xhci: fix uninitialized string returned by
 xhci_decode_ctrl_ctx()
Content-Language: en-US
To:     Mathias Nyman <mathias.nyman@linux.intel.com>
Cc:     linux-usb@vger.kernel.org, stable@vger.kernel.org,
        gregkh@linuxfoundation.org
References: <20220303102656.1661407-1-mathias.nyman@linux.intel.com>
 <20220303102656.1661407-4-mathias.nyman@linux.intel.com>
From:   Anssi Hannula <anssi.hannula@bitwise.fi>
In-Reply-To: <20220303102656.1661407-4-mathias.nyman@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 3.3.2022 12.26, Mathias Nyman wrote:
> From: Anssi Hannula <anssi.hannula@bitwise.fi>
>
> xhci_decode_ctrl_ctx() returns the untouched buffer as-is if both "drop"
> and "add" parameters are zero.
>
> Fix the function to return an empty string in that case.
>
> It was not immediately clear from the possible call chains whether this
> issue is currently actually triggerable or not.
>
> Note that before commit 4843b4b5ec64 ("xhci: fix even more unsafe memory
> Cc: stable@vger.kernel.org
> usage in xhci tracing") the result effect in the failure case was different
> as a static buffer was used here, but the code still worked incorrectly.

You added the Cc-stable line a few lines too early above :)

> Fixes: 90d6d5731da7 ("xhci: Add tracing for input control context")
> Signed-off-by: Anssi Hannula <anssi.hannula@bitwise.fi>
> Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
>
> commit 4843b4b5ec64 ("xhci: fix even more unsafe memory usage in xhci tracing")
> ---
>  drivers/usb/host/xhci.h | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
> index 1d83ddace482..473a33ce299e 100644
> --- a/drivers/usb/host/xhci.h
> +++ b/drivers/usb/host/xhci.h
> @@ -2468,6 +2468,8 @@ static inline const char *xhci_decode_ctrl_ctx(char *str,
>  	unsigned int	bit;
>  	int		ret = 0;
>  
> +	str[0] = '\0';
> +
>  	if (drop) {
>  		ret = sprintf(str, "Drop:");
>  		for_each_set_bit(bit, &drop, 32)


-- 
Anssi Hannula / Bitwise Oy
+358 503803997

