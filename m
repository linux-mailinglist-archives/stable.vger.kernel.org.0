Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0CCF4E9253
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 12:10:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237628AbiC1KLo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 06:11:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235601AbiC1KLn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 06:11:43 -0400
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0E9552E12;
        Mon, 28 Mar 2022 03:10:02 -0700 (PDT)
Received: by mail-ej1-f49.google.com with SMTP id yy13so27586996ejb.2;
        Mon, 28 Mar 2022 03:10:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=9VEDMDRK+F+NgdG+/BTht0bpzUjaEb9tTJF4uHum5G4=;
        b=EnU8FnKFHyjtj4seCppcFejs7e/5Lq4FB6AN7IpDN60ingGOj41EgOEnbJhnyeYQCq
         OXoMs+E0lzXpBe7PapKNSDlAr2O9xmCJUMnEnhjd8G9owrXt1PJ9U2VjKRalNnaCtf2e
         TgeL4FWkHdEA7iy1vA9axgnA4fvNXCbWPWqgLx/NiPU0b56e6TgdVP4fMtq4FNPOlQTr
         TUmffKrK5cgVpnVTqD06irSwoy8C2NAK+ntyn7kHB/SSv4ZDdb95HR/Ly+9wlystnRRf
         ZKVcpBRvqf56o7CMuYtQ71Ys0Z1VlY1t6FBM889A6QSKzbTffZbaUiVvkpldkofCfwy4
         tVyA==
X-Gm-Message-State: AOAM533xWMy57MrJ1hVTN8G2Bov5UK/kZ0czqqe0zgxl1I8tOz/aXTT1
        USCCzN06E0EzJPtV2wb5iJmuJMc7i7M=
X-Google-Smtp-Source: ABdhPJyGhS8Oi+4QpGbrtyBLN6s4x2Oj8INuB/XnTVveVQwyOTorpU06yRa8+Z0xmcfK0AeShFaykQ==
X-Received: by 2002:a17:906:27d1:b0:6df:ccdd:1a8d with SMTP id k17-20020a17090627d100b006dfccdd1a8dmr27581256ejc.751.1648462201277;
        Mon, 28 Mar 2022 03:10:01 -0700 (PDT)
Received: from ?IPV6:2a0b:e7c0:0:107::49? ([2a0b:e7c0:0:107::49])
        by smtp.gmail.com with ESMTPSA id 22-20020a17090600d600b006dfbc46efabsm5724836eji.126.2022.03.28.03.10.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Mar 2022 03:10:00 -0700 (PDT)
Message-ID: <47a6e396-3d51-79f5-a544-8942470fa2fd@kernel.org>
Date:   Mon, 28 Mar 2022 12:09:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH v3] char: tty3270: fix a missing check on list iterator
Content-Language: en-US
To:     Xiaomeng Tong <xiam0nd.tong@gmail.com>, hca@linux.ibm.com,
        gor@linux.ibm.com, agordeev@linux.ibm.com
Cc:     borntraeger@linux.ibm.com, svens@linux.ibm.com,
        gregkh@linuxfoundation.org, jcmvbkbc@gmail.com, elder@linaro.org,
        dsterba@suse.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20220328093505.27902-1-xiam0nd.tong@gmail.com>
From:   Jiri Slaby <jirislaby@kernel.org>
In-Reply-To: <20220328093505.27902-1-xiam0nd.tong@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 28. 03. 22, 11:35, Xiaomeng Tong wrote:
> The bug is here:
> 	if (s->len != flen) {
> 
> The list iterator 's' will point to a bogus position containing
> HEAD if the list is empty or no element is found.

Could you also explain how that can happen?

> This case must
> be checked before any use of the iterator, otherwise it may bpass
> the 'if (s->len != flen) {' in theory iif s->len's value is flen,

bpass + iif -- others already commented on that and you ignored them.

> or/and lead to an invalid memory access.
> 
> To fix this bug, use a new variable 'iter' as the list iterator,
> while using the origin variable 's' as a dedicated pointer to
> point to the found element. And if the list is empty or no element
> is found, WARN_ON and return.
> 
> Cc: stable@vger.kernel.org
> Fixes: ^1da177e4c3f4 ("Linux-2.6.12-rc2")

That's barely the commit introducing the behavior.

> Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
> ---
> changes since v2:
>   - WARN_ON and return (Sven Schnelle)
> 
> changes since v1:
>   - reallocate s when s == NULL (Sven Schnelle)
> 
> v1:https://lore.kernel.org/lkml/20220327064931.7775-1-xiam0nd.tong@gmail.com/
> v2:https://lore.kernel.org/lkml/20220328070543.24671-1-xiam0nd.tong@gmail.com/
> 
> ---
>   drivers/s390/char/tty3270.c | 11 ++++++++---
>   1 file changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/s390/char/tty3270.c b/drivers/s390/char/tty3270.c
> index 5c83f71c1d0e..9d0952178322 100644
> --- a/drivers/s390/char/tty3270.c
> +++ b/drivers/s390/char/tty3270.c
> @@ -1109,9 +1109,9 @@ static void tty3270_put_character(struct tty3270 *tp, char ch)
>   static void
>   tty3270_convert_line(struct tty3270 *tp, int line_nr)
>   {
> +	struct string *s = NULL, *n, *iter;
>   	struct tty3270_line *line;
>   	struct tty3270_cell *cell;
> -	struct string *s, *n;
>   	unsigned char highlight;
>   	unsigned char f_color;
>   	char *cp;
> @@ -1142,9 +1142,14 @@ tty3270_convert_line(struct tty3270 *tp, int line_nr)
>   
>   	/* Find the line in the list. */
>   	i = tp->view.rows - 2 - line_nr;
> -	list_for_each_entry_reverse(s, &tp->lines, list)
> -		if (--i <= 0)
> +	list_for_each_entry_reverse(iter, &tp->lines, list)
> +		if (--i <= 0) {
> +			s = iter;
>   			break;
> +		 }
> +
> +	if(WARN_ON(!s))
> +		return;
>   	/*
>   	 * Check if the line needs to get reallocated.
>   	 */

thanks,
-- 
js
suse labs
