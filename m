Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3606657B0F3
	for <lists+stable@lfdr.de>; Wed, 20 Jul 2022 08:19:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239565AbiGTGTL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Jul 2022 02:19:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239560AbiGTGTJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Jul 2022 02:19:09 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2333A5F9AA;
        Tue, 19 Jul 2022 23:19:09 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id q16so12414089pgq.6;
        Tue, 19 Jul 2022 23:19:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=bLhaTItgj55d4PqNpNGprQS/bphwIRWh5jEzsoz2lFk=;
        b=XEPYhEHx39PrlaKMnVulArpmlyT5M6ZUCWgLs4J3GNUJQcPG4h/YsioaH/7thzHO30
         GCyAFnhRgVw5IXu4HEkaJNNVQCfrZpOeH3VOJDkKsMqmy/SqadxYZcpYB/A6xnICxhvC
         GMvaKMkCmRyJkxGjscFmzyHArUYl4i9FgFOYzSwYWshblhaLYTXRhAkvruHxXyM0FS3o
         esRmzlLNrPo1iKOOAlvOOBVKBP6LryRHQRsKUi4ewaWh1S0k60klZFcNFpUx/ft9tBTq
         EgKTQaBDIVQHUcVGCPmu0h6IjMqClrD9W0M5tRAFYB9u/kWpaTJKPIZt6T/gGAc5gUAQ
         s0zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=bLhaTItgj55d4PqNpNGprQS/bphwIRWh5jEzsoz2lFk=;
        b=tEzBLn47o/jvjbaXxRUzQAU95kaxq5s3WRW0wya1c05jMujDKyEmeZkhUj2Oh9XmAZ
         fUpWV6WifCEPzHXDJzvWMwMzRHPv8v4s9TLl95WAGhcekHRCDLZ3VyvQOHFJtXq9L80Z
         q8SPqv1Y4VfeVrGGFqpjlnAaTVIuu0VV++rRIFovVfrOl/B8Ksx7yUHnieFIP8/fAKeR
         6+bTqOP8SoyY0BCCYvV+ESn7yxb1qVXWD85iW0+gAs73fC5LHarF2nlyX5G4w6gNF6Dh
         JgkRDtuzpkxOymAbUiAmttGkZEHdAiarSqPVdnm7VpAIMD3qYkMcvfgkZnvrWwGHMhQi
         w7JQ==
X-Gm-Message-State: AJIora8Z8dzCjWEFrDxU5SU6eh+cISp+Lvix49qcst7Bdt6TkLl20myy
        RRVaK2i5t3plDkTKRwsDFUI=
X-Google-Smtp-Source: AGRyM1s0K0JckMBdh+9JalnJiCrt0obWMxPgCeg9ZH9P/Xs9xK6ZjzOK9uinU/veBtjiT17pX3MEGA==
X-Received: by 2002:a05:6a00:234f:b0:525:1f7c:f2bf with SMTP id j15-20020a056a00234f00b005251f7cf2bfmr37711998pfj.14.1658297948661;
        Tue, 19 Jul 2022 23:19:08 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id nm6-20020a17090b19c600b001f20d9a547asm670928pjb.22.2022.07.19.23.19.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 23:19:07 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 19 Jul 2022 23:19:06 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.10 000/112] 5.10.132-rc1 review
Message-ID: <20220720061906.GE4107175@roeck-us.net>
References: <20220719114626.156073229@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220719114626.156073229@linuxfoundation.org>
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 19, 2022 at 01:52:53PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.132 release.
> There are 112 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 21 Jul 2022 11:43:40 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 163 pass: 163 fail: 0
Qemu test results:
	total: 477 pass: 477 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
