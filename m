Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF0C6667A93
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 17:17:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232284AbjALQRD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 11:17:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232625AbjALQQI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 11:16:08 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C50D113E92
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 08:13:38 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id cf18so39603499ejb.5
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 08:13:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MzF22PPdIreEIa7ztIOqQnw7vLi6LeZv6ab1mRLDnWc=;
        b=bqsVUJSaXBPpY6v20ecbgsIOho5U3Sj/Z1S91znjlXB1Jsg3nPX3qyf4IobkkjDEXO
         P3HynJbeQkXvir18R3ruJ1/i/jnoXhflHApX/P0aTIL1MP5rKG3XqvZub3m5JfIrSFpq
         mCCHtChSke2M5qtptELzlXxmT13PrRj/8Usjp7CTlVfOvjYTkWsgnPX86dQ3sfkMsiY9
         ONaMNdDkWdZCPbKHtfoj9X261ciUJJ4UagcJlKqy+8P8LaHhUISKztP5uTCepq8+ecgM
         bQliMYX/oE7v95JMxSpySHocLg44juUa4n71Nq0/1aXQuMTLJRZmD3NE1ZGrtUKbXzzx
         q28w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MzF22PPdIreEIa7ztIOqQnw7vLi6LeZv6ab1mRLDnWc=;
        b=3EyaOdALc1OOFpw06l4ONTkXjnaNRy7stKPOVt9b0iulVVqLLG6LmuW3Z+OKIUW6S4
         qS2UkHSOTf6dbk3JvWOot4gq8MJ9yYm3BtuBvHgVE09X89Vazmt3B/NDxq+0PNRboznv
         8LO5ipXjYrqG/Xrq9n9JGhDPqLhV3jFHQJtrKOf/Gta1rn9XxcN4Sa/xrm+Qlc7mi1e8
         oxdYxDyMpywdEKzN2Cn8UBfBIWvhzYVjeaqcHs1hwrnd5+gwDBe6P8FVHXcI5lkHMzPy
         ydxIAS+UtkDyg5Gj+sN/DfkIXbkxk2Jk5f2R4fYjpki1Dp++JlKpCKmCe++qrA8CtY5F
         FiEQ==
X-Gm-Message-State: AFqh2kqXOy5LIofTXmcqbDzDrHoZrRjbRXHZelED4pI0BsS1ndczCRdL
        9mUQUBjjyNBzzCd9A1/ml09YmJYz6bG2+af5
X-Google-Smtp-Source: AMrXdXtYZCHpdQvKQqzV4lS/OMAsuYmj6f65+gzDCKvJSN6Zw32OfQ0O0wyHcgs6+c5Yaj9jqIQAcA==
X-Received: by 2002:a17:907:7f04:b0:7c1:36:9002 with SMTP id qf4-20020a1709077f0400b007c100369002mr83786838ejc.67.1673540017416;
        Thu, 12 Jan 2023 08:13:37 -0800 (PST)
Received: from [192.168.1.109] ([178.197.216.144])
        by smtp.gmail.com with ESMTPSA id 22-20020a170906311600b0082535e2da13sm7551792ejx.6.2023.01.12.08.13.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Jan 2023 08:13:36 -0800 (PST)
Message-ID: <894ffc14-41dc-9abc-4b13-a1f74212ae44@linaro.org>
Date:   Thu, 12 Jan 2023 17:13:34 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v2] Bluetooth: hci_qca: Fix driver shutdown on closed
 serdev
Content-Language: en-US
To:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Zijun Hu <zijuhu@codeaurora.org>,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20221229102829.403917-1-krzysztof.kozlowski@linaro.org>
 <397c61e8-d928-4e07-9616-afb315d356dd@linaro.org>
 <CABBYNZJYTfVfBMBvfxx6D9a4T5gbqZZcb7BP5LBa28fOEKuoFw@mail.gmail.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <CABBYNZJYTfVfBMBvfxx6D9a4T5gbqZZcb7BP5LBa28fOEKuoFw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/01/2023 17:07, Luiz Augusto von Dentz wrote:
>>> Fixes: 7e7bbddd029b ("Bluetooth: hci_qca: Fix qca6390 enable failure after warm reboot")
>>> Cc: <stable@vger.kernel.org>
>>> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
>>>
>>> ---
>>
>> Any comments on this? Patchwork tools complain on longer line, but
>> without it checkpatch would complain as well, so I assume you do not
>> expect to fix it?
> 
> I did apply it already:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.git/commit/?id=a18fca670e14f0c09c2ed332cf2c6d77a4ae05f9
> 
> Not sure why the bot hasn't responded to you.


Ah, thank you then. I looked at Patchwork and it was still in state "New".

Best regards,
Krzysztof

