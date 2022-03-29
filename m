Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5C8E4EA7AD
	for <lists+stable@lfdr.de>; Tue, 29 Mar 2022 08:07:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231264AbiC2GJD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Mar 2022 02:09:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232877AbiC2GJC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Mar 2022 02:09:02 -0400
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D4557E5A2;
        Mon, 28 Mar 2022 23:07:20 -0700 (PDT)
Received: by mail-ed1-f51.google.com with SMTP id r23so19467201edb.0;
        Mon, 28 Mar 2022 23:07:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=gvQ/9gQ/B0lb7gHEOmG+kLyRme2tw7zftepJYR7kDD4=;
        b=qIL4ZSERqPdSk00cNDmOvaiytVz29AB/pVycVC/jcw6J6VM5OlNHL5WmH3QPXozzHg
         D05qH4nv88qoOer5b4vKbkYz+KoRAfEXM1Vev5Rn5snFNeuVfMIEinHUKNq6NkIqP+bm
         w0fQwfIoCbYymflaMXGgQxCzmpvdc47OwIMThoz4LxvDoAjdInQfYZBrlrCrsTMAurVg
         08dUSaqAQLUcP6crb2ytvhCD0y/gb+JvB4tvFU0lAQpPArXvvES04TpZ7tKOLk9Y4B7m
         TRYk4DMV5O35I2FAwtjFMTFlgCSdiqtLes7AieKr4a/bsW1yRwzyZnU3pOTYjrz8SVJ/
         ekGg==
X-Gm-Message-State: AOAM531OyjYiTmEAGjNzE/lA/VT/P5rjtaTZbEYIjxlej3zR1XtKXj2X
        vTJDGEhyxD4oU8iKT+heU7c=
X-Google-Smtp-Source: ABdhPJy13Dh+GCUIf3m1FsmrzHZhkeJDLNtwFU0FgDNehXHXptSP1dXYg1i+M7udTgWubT5081w5qQ==
X-Received: by 2002:a05:6402:5211:b0:419:583d:bb58 with SMTP id s17-20020a056402521100b00419583dbb58mr2344846edd.198.1648534038507;
        Mon, 28 Mar 2022 23:07:18 -0700 (PDT)
Received: from ?IPV6:2a0b:e7c0:0:107::70f? ([2a0b:e7c0:0:107::70f])
        by smtp.gmail.com with ESMTPSA id g2-20020aa7dc42000000b00418ef55eabcsm8058359edu.83.2022.03.28.23.07.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Mar 2022 23:07:18 -0700 (PDT)
Message-ID: <02741f84-ee8f-2f4c-e2eb-5f74183f60f8@kernel.org>
Date:   Tue, 29 Mar 2022 08:07:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH v3] char: tty3270: fix a missing check on list iterator
Content-Language: en-US
To:     Xiaomeng Tong <xiam0nd.tong@gmail.com>
Cc:     agordeev@linux.ibm.com, borntraeger@linux.ibm.com,
        dsterba@suse.com, elder@linaro.org, gor@linux.ibm.com,
        gregkh@linuxfoundation.org, hca@linux.ibm.com, jcmvbkbc@gmail.com,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        stable@vger.kernel.org, svens@linux.ibm.com
References: <47a6e396-3d51-79f5-a544-8942470fa2fd@kernel.org>
 <20220328102732.28910-1-xiam0nd.tong@gmail.com>
From:   Jiri Slaby <jirislaby@kernel.org>
In-Reply-To: <20220328102732.28910-1-xiam0nd.tong@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 28. 03. 22, 12:27, Xiaomeng Tong wrote:
> On Mon, 28 Mar 2022 12:09:59 +0200, Jiri Slaby wrote:
>> On 28. 03. 22, 11:35, Xiaomeng Tong wrote:
>>> The bug is here:
>>> 	if (s->len != flen) {
>>>
>>> The list iterator 's' will point to a bogus position containing
>>> HEAD if the list is empty or no element is found.
>>
>> Could you also explain how that can happen?
>>
> 
> When list_for_each_entry_* do not early exits (if the list is empty
> or no break/goto/return hit inside the loop), it will set pos ('s' here)
> with a bogus pointer that point to a invalid struct computed based
> on &HEAD using container_of.
> 
> #define list_for_each_entry(pos, head, member)                          \
>          for (pos = list_first_entry(head, typeof(*pos), member);        \
>               !list_entry_is_head(pos, head, member);                    \
>               pos = list_next_entry(pos, member))

No, I didn't mean what happens on that site on the code level. I think 
everyone understands that. Instead, I meant: what circumstances lead to 
this _situation_ in reality?

thanks,
-- 
js
suse labs
