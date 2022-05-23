Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2626853194F
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:54:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240840AbiEWSDK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 14:03:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243701AbiEWSCB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 14:02:01 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E84B0E15DC;
        Mon, 23 May 2022 10:46:54 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id r6-20020a1c2b06000000b00396fee5ebc9so4931wmr.1;
        Mon, 23 May 2022 10:46:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=nqWcOyn3PXt1X1nKWcFnT+4sHBA6gWKtV/kf9MDUA7o=;
        b=HKXHJBcOg7lQks5kDSUQtrxQgMC2fx2+weg16YS+NWI7HKddWW0051D0XlVWZnw8Ll
         lRLtj7tDbxyt2ldKgMsNG3KWXnFwA5cstztvfbAiBcEcyHoBxxcSUkk9Hk6rAnSSaxJM
         Gd/iyk53+92Hfy3JYsVu3CZZVB1HHFmUQnzRzdCZDqUldjmA6tqEnio8pFS0X4WDLhc+
         LnwgXz2C9a2jexaB1mLszAXMtzJOCq3DNPceHjyrRZQbpis929atLctr1PbZ4aeGqEZ7
         VJkQw9nGU6Vj7T5skqJFJ8sqK5/vmlxfGpcVAZ2IJcqoUfR4Uif1rFolA1ZEWYI/G/eB
         Ghfw==
X-Gm-Message-State: AOAM530ZUEiqDZtggv00Jth2NpR4H991Hc88Qn/Xob6TEMkqwx2TySqe
        tF8kxdeCx96uNMo9Aqd6uEBznnJFEf0=
X-Google-Smtp-Source: ABdhPJyEdWzCn0L2yyxPQcLUSRH/1H0nuvgdYiTusbHGyusRpWesuhpMBx3CwF3sI0evb0YKQ8o3zg==
X-Received: by 2002:a05:600c:4fd3:b0:394:7fa6:2584 with SMTP id o19-20020a05600c4fd300b003947fa62584mr96129wmq.177.1653327674307;
        Mon, 23 May 2022 10:41:14 -0700 (PDT)
Received: from [192.168.1.126] ([94.205.35.240])
        by smtp.gmail.com with ESMTPSA id x1-20020a1c7c01000000b00397122e63b6sm9334328wmc.29.2022.05.23.10.41.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 May 2022 10:41:13 -0700 (PDT)
Message-ID: <22589460-930c-b307-acf0-2a49f5f5261f@linux.com>
Date:   Mon, 23 May 2022 21:41:09 +0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH v5.10] staging: rtl8723bs: prevent ->Ssid overflow in
 rtw_wx_set_scan()
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Larry.Finger@lwfinger.net, phil@philpotter.co.uk,
        dan.carpenter@oracle.com, straube.linux@gmail.com,
        linux-staging@lists.linux.dev, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, stable <stable@vger.kernel.org>
References: <YoZk3YLEDYKGG5xe@kroah.com>
 <20220520035730.5533-1-efremov@linux.com> <YounkTGwmcQns3vy@kroah.com>
From:   Denis Efremov <efremov@linux.com>
In-Reply-To: <YounkTGwmcQns3vy@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 5/23/22 19:26, Greg KH wrote:
> On Fri, May 20, 2022 at 07:57:30AM +0400, Denis Efremov (Oracle) wrote:
>> This code has a check to prevent read overflow but it needs another
>> check to prevent writing beyond the end of the ->Ssid[] array.
>>
>> Fixes: 554c0a3abf21 ("staging: Add rtl8723bs sdio wifi driver")
>> Cc: stable <stable@vger.kernel.org>
>> Signed-off-by: Denis Efremov (Oracle) <efremov@linux.com>
>> ---
>>  drivers/staging/rtl8723bs/os_dep/ioctl_linux.c | 6 ++++--
>>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> And only 5.10 needs this?  What about all other kernel branches?
> 

From 5.10, 5.4, 4.19, to 4.14.

There is a small spaces conflict in 5.4-4.14 kernels because of
c77761d660a6 staging: rtl8723bs: Fix spacing issues

I sent another patch to handle it.

Thanks,
Denis
