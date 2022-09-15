Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 193EE5B92BC
	for <lists+stable@lfdr.de>; Thu, 15 Sep 2022 04:48:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229603AbiIOCsX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Sep 2022 22:48:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbiIOCsW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Sep 2022 22:48:22 -0400
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 217DD8C03B;
        Wed, 14 Sep 2022 19:48:21 -0700 (PDT)
Received: by mail-pl1-f182.google.com with SMTP id v1so16996283plo.9;
        Wed, 14 Sep 2022 19:48:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=iT4cNzTqaeWtOVogFt+yHUwJZZ1CJKXyTGfZWcy5x20=;
        b=zXE4ulDF/0DTGV03eHzYsxa8xnflIEo3AIFVAa8I94nNmkJp/ijssvd/ZtQnpSZyg7
         xqEPIOyFp7iZLSU9ZfniLWuTCIJpWvYjHYslolE6tZzWigqa624O45r2Qf8N9H6MA7dk
         2yHwFYiI7Ot59qGLmWsXL9ccC+2q0dooqLDT7ekOEBY+F9fA5KZ6Q1ZScTwvhWUqeVmP
         CfUYtB3n7pasZiEFSw5eXyomVVzyrO8JIeJXfbJQQj7t0oShVaOE+5DqIkcd84g3X1ei
         UK0tD4yagPw/+PvTAbPksdv2mkcV7yf3f62Iesx9oU+Y4aEZhGpO2DyHGqST035JC7qQ
         W7GQ==
X-Gm-Message-State: ACrzQf3AzxiFXMhl+T8FkConXzWCsHNPhdvdt/h3ru2Yf+lZpd5GyBGW
        qRjuTv6JnV2lXN3yC52imZ7if2bCTxo=
X-Google-Smtp-Source: AMsMyM4gngiPyMz2ZPiGEJ3aOuJoiPcAxSmx+pJYNvBI6fIM0Ii9K8bs69+CMbcVtf278yc5nwFljQ==
X-Received: by 2002:a17:90b:4d07:b0:1ef:521c:f051 with SMTP id mw7-20020a17090b4d0700b001ef521cf051mr8210222pjb.164.1663210100258;
        Wed, 14 Sep 2022 19:48:20 -0700 (PDT)
Received: from [192.168.3.219] ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id y10-20020a62640a000000b0053e6bda08e0sm10937487pfb.219.2022.09.14.19.48.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Sep 2022 19:48:19 -0700 (PDT)
Message-ID: <350ec615-ffe8-2e0e-149d-4bf45932a585@acm.org>
Date:   Wed, 14 Sep 2022 19:48:17 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [REGRESSION] introduced in 5.10.140 causes drives to drop from
 LSI SAS controller (Bisected to 6d17a112e9a63ff6a5edffd1676b99e0ffbcd269)
Content-Language: en-US
To:     Jason Wittlin-Cohen <jwittlincohen@gmail.com>,
        regressions@lists.linux.dev
Cc:     stable@vger.kernel.org, linux-scsi@vger.kernel.org,
        alim.akhtar@samsung.com, Kiwoong Kim <kwmad.kim@samsung.com>
References: <CADy0EvLGJmZe-x9wzWSB6+tDKNuLHd8Km3J5MiWWYQRR2ctS3A@mail.gmail.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <CADy0EvLGJmZe-x9wzWSB6+tDKNuLHd8Km3J5MiWWYQRR2ctS3A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/14/22 19:21, Jason Wittlin-Cohen wrote:
> 8d5c106fe216bf16080d7070c37adf56a9227e60 is the first bad commit
> commit 8d5c106fe216bf16080d7070c37adf56a9227e60
> Author: Kiwoong Kim <kwmad.kim@samsung.com <mailto:kwmad.kim@samsung.com>>
> Date: Tue Aug 2 10:42:31 2022 +0900
> 
> scsi: ufs: core: Enable link lost interrupt
> 
> commit 6d17a112e9a63ff6a5edffd1676b99e0ffbcd269 upstream.
> 
> Link lost is treated as fatal error with commit c99b9b230149 ("scsi: ufs:
> Treat link loss as fatal error"), but the event isn't registered as
> interrupt source. Enable it.

Hi Jason,

Something must have gone wrong during the bisection process. Commit
8d5c106fe216 ("scsi: ufs: core: Enable link lost interrupt") only 
affects the UFS driver and hence cannot change the behavior of a SAS 
controller. How about repeating the bisection process?

Thanks,

Bart.

