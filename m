Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2628A5368E8
	for <lists+stable@lfdr.de>; Sat, 28 May 2022 00:43:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233814AbiE0WjD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 18:39:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354831AbiE0WjC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 18:39:02 -0400
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0916266C96;
        Fri, 27 May 2022 15:39:02 -0700 (PDT)
Received: by mail-oi1-x22e.google.com with SMTP id v9so7310207oie.5;
        Fri, 27 May 2022 15:39:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rgEdTzrASx73cavu9tA3+ezPShCom911DOrm93JkM74=;
        b=FqBh9OTT3EtqDNdObzhvmMc/DG3m0RWRp366T3mAl+eaAal+t0kf8eQynDs8jc7lRl
         FPqXCXbf3XUz9/ISG25++iBFLc/A+LY6M9eyyhM7AiYyuZp3vJm2G2qAkWBBq5w6BxqY
         Z0IB6z/gEJj747+MZZzFtcUXnpzyt5orDLhHcG6LFYFnhYiUqGuzZZonDRMSDr3VU+Iz
         dwSFkf1DRUwvxXqwStUvvgmK5Qh9g/K3QmzN5h+NhJ/MasyQG7e7CsWfGgU9gaxA49w7
         h4XuMD0Twik/s6l/Y85FdLrDPQsVOrRuhzP/ICnTw47Ydze11eFmYAetZikarrZOyLpb
         GpJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=rgEdTzrASx73cavu9tA3+ezPShCom911DOrm93JkM74=;
        b=Y5yPWMtB258Hbi96RELaXA0qPLlyadcegm57lN6FOHahc6MrjZd444iSqadEbjJrFS
         U3fYEJECL/ybmoWJizZ1Xi4gI9iEuUfyHZ8yjJm6FFtdvcHNJXUwJvQsvAHJw5X+SNjw
         0uqKs2bDOrd6z1cpdIRSsP97cSE/5Lg0xtUdORdVd2rYRDcoOWx0s6NLUm6D6SMOhgKf
         SiYG4gj0m83b/WCUTaNb+dRumYOuq6zVpbBCeg9Cg6BNu5poO8F1wFDRkdNCUTm63DGt
         AFNqczUwiHOJq/UCsGqeBO4VUzLUqMqv7M6gOpLxw2ROP2ilF2m12ITjWwOYCCZJM1Cc
         bvbA==
X-Gm-Message-State: AOAM5322CfRQpJVVFnvGgCW2U0Oork1qhaUrxVjf4JAhvbrpTpGSNWuA
        fsZp9cwYYu3M/6FpUQPB7ak=
X-Google-Smtp-Source: ABdhPJyfB4vkxCru/HZWqZ0kgzxOYs7EWRFinmaGaElQrCZ/C1XZi7616KvVXfTrVTjGRK2jFmg1eg==
X-Received: by 2002:a05:6808:1202:b0:322:dc37:2c3b with SMTP id a2-20020a056808120200b00322dc372c3bmr5378869oil.298.1653691141422;
        Fri, 27 May 2022 15:39:01 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id bc44-20020a05682016ac00b0035eb4e5a6dasm2540638oob.48.2022.05.27.15.39.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 May 2022 15:39:00 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 27 May 2022 15:38:59 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.10 000/163] 5.10.119-rc1 review
Message-ID: <20220527223859.GB3166370@roeck-us.net>
References: <20220527084828.156494029@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220527084828.156494029@linuxfoundation.org>
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

On Fri, May 27, 2022 at 10:48:00AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.119 release.
> There are 163 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 29 May 2022 08:46:26 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 161 pass: 161 fail: 0
Qemu test results:
	total: 477 pass: 477 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
