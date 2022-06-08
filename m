Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B199A54402E
	for <lists+stable@lfdr.de>; Thu,  9 Jun 2022 01:55:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232971AbiFHXxN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jun 2022 19:53:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232169AbiFHXxL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jun 2022 19:53:11 -0400
Received: from mail-oa1-x2a.google.com (mail-oa1-x2a.google.com [IPv6:2001:4860:4864:20::2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 562D938DD21;
        Wed,  8 Jun 2022 16:55:01 -0700 (PDT)
Received: by mail-oa1-x2a.google.com with SMTP id 586e51a60fabf-fe32122311so535445fac.7;
        Wed, 08 Jun 2022 16:55:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6QtDEs/USq+Y/f7sIRDGrvmt67FhKFhQNPsyp0e+D6c=;
        b=jckZCmz51tBvhGJvd0GI9irXZs1la0E+ajssqtInkWYBCFdz7m8L/MCnlHZ+DheN/1
         a2g+5dNCl1/Jj3pgGo66+54miRFoelhsIM4q4LrV1KavnAn1sjTpdOJ1aWWUA6WPltIm
         mB6X0wvmcAHzPa2Djc89gSUdE2JpjLATjyYRnNXzPvMsiNeMfYvKihKtW63ktv7OE/tH
         c7KMNPurTtwzX6BjGXWUwMhlcqViZSvjGHmVCsiVH9QAk1o7uj1hrJbMBX6cT+TQweGv
         LR+CPNkT/ySqnVBXja7fHzT1upIq7qlK3Kezz9p2eu8/XcjAnTO3RiLRN8rpmmRBEToy
         l1ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=6QtDEs/USq+Y/f7sIRDGrvmt67FhKFhQNPsyp0e+D6c=;
        b=Owh6SIELCvhJ+7uuH+TXjJmB+xCD5ONfYbXaBDgB5xWXgRr4WSefkYgMYR+C/bmF7x
         LWNK8blyaBNu+LyWKqY+YfYOy7IXh+SraAPYSIibIU2WzCb9doSY7vTjAJT6of6OrsSU
         gBnvx2tNR5ty+q4xIGvYRSjRduliCRS2fZCVlQkeG646Iw+0REPlIafLbWP5zxYrfM5J
         K6JlMiOvEwTaRi2/29W791Im5uN1OTYxkxQV9s9c9nn77MBRwKHrV8qLnPFYAK5cCm2i
         pQGqwlTCUHbboz++u4MyM0SW0oLnrHdRq7Ld2Tp8/18UVnYODtwCZFU8ASb9YBPnzQGC
         vnRA==
X-Gm-Message-State: AOAM533GKQX7rZDfE1rACNmTeAstkONXti4hqb525WXzKXIkXrgi+mk1
        PM1OeF6a0sHhXbLt8xMh2FQ=
X-Google-Smtp-Source: ABdhPJw+0zDjvY2KOvSq828ucnkh03UizbkOcCWI7mn662jJ56DlXVhzgAsHTFA1Kxq7WDNOStIG9g==
X-Received: by 2002:a05:6870:80d3:b0:f5:d6c9:38dc with SMTP id r19-20020a05687080d300b000f5d6c938dcmr262875oab.213.1654732500691;
        Wed, 08 Jun 2022 16:55:00 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id d3-20020a9d2903000000b0060bd52bf77csm8425523otb.21.2022.06.08.16.54.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jun 2022 16:55:00 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 8 Jun 2022 16:54:59 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.18 000/879] 5.18.3-rc1 review
Message-ID: <20220608235459.GD3924366@roeck-us.net>
References: <20220607165002.659942637@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 07, 2022 at 06:51:58PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.18.3 release.
> There are 879 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 09 Jun 2022 16:48:02 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 154 pass: 154 fail: 0
Qemu test results:
	total: 489 pass: 489 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
