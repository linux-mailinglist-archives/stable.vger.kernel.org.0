Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E97A570F4A
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 03:12:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229663AbiGLBMk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 21:12:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230053AbiGLBMj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 21:12:39 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4E6A4B0DB;
        Mon, 11 Jul 2022 18:12:38 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id b9so6178511pfp.10;
        Mon, 11 Jul 2022 18:12:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=BIIr45YpuTIMhbfJtgbxQVbtLUO5Eb++rdtPUysZ2B4=;
        b=Ee7rOaJW26vOPk1rLQZtI75z5qddFAzZFRfoyvXzOSf7NZ+cmE16q+xh24dFtzCyBt
         3YLvX23gscNUQy05BOms31M7Ws1gmSoH/q/6Vq/myP4GNZqISnptzZaSP+xnnv7r+Z9W
         nNIZs40d6JPSfQl/XgkSd2CoYIEKVHNza+o2GwYe1+JlFIOPVkwWbgUwoDpI4QWKrRrr
         ShyiQLhKo84MXLTfqMMcYNMGy9ltidiE/G4xh10xbU9teffbEerwy3tCum1WrGoB8uil
         6HNcv5I+CxWba5mF8gBknL8IiKC+5yAct2yLcSvGn8UtzmgyM9jnJ/RaC0hXmgxJ6HNn
         X4Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=BIIr45YpuTIMhbfJtgbxQVbtLUO5Eb++rdtPUysZ2B4=;
        b=iMPwG+Wz0moRn+/4n6j7NKGz4oJEZmVROmO6xokVEZzQffS2ToDM742zpsgriqoAqI
         WP5+RnF/0QBI/HNSx60rzc5YohWuNi2DHOovuLK5zmDCXplJ/O67swf9CT8JP8VIomG6
         JmEnSF2/HaZzT+YHMV4FgcxldqrJnFriTxBSgb24s4hPunQgRHNPu0JwgcDC6ugyiZcV
         O8VOwC1BpDT9qwyyBkJWyyFzhqvMUXCmCCPQLfB6+DM0Sm4CrozwUT/Qv5NAUAXV2f/b
         ma1ob7s1Q5O3R6TolSw11t820xFwDJTlaz02ntT1U05kq6N8Aoatmi1xT0M/rN9R8oDR
         lxTQ==
X-Gm-Message-State: AJIora/+Wtp8gPpTkio9CpGygUc9QLNiir6CjqZS4WEIYIQ7cPeD9M00
        Kf8oTwwsVbEQ5XygDq5h1Po=
X-Google-Smtp-Source: AGRyM1vlx4VhGSoK5NIEjxr5ApFWlxkfEJT1HIBcy10v1UlnO03NPsX4dy3NO80q9aDrTZ2AqlEP0w==
X-Received: by 2002:a05:6a00:1747:b0:52a:e7a0:fe2e with SMTP id j7-20020a056a00174700b0052ae7a0fe2emr829191pfc.72.1657588358261;
        Mon, 11 Jul 2022 18:12:38 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id l16-20020a170903121000b0015e8d4eb27esm5402229plh.200.2022.07.11.18.12.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jul 2022 18:12:37 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 11 Jul 2022 18:12:36 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.10 00/55] 5.10.130-rc1 review
Message-ID: <20220712011236.GE2305683@roeck-us.net>
References: <20220711090541.764895984@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220711090541.764895984@linuxfoundation.org>
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

On Mon, Jul 11, 2022 at 11:06:48AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.130 release.
> There are 55 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 13 Jul 2022 09:05:28 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 163 pass: 163 fail: 0
Qemu test results:
	total: 477 pass: 477 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
