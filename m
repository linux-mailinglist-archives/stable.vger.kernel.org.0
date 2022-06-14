Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4949E54B4CE
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 17:35:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243618AbiFNPfh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jun 2022 11:35:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233663AbiFNPfg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jun 2022 11:35:36 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2E2B2A41D;
        Tue, 14 Jun 2022 08:35:35 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id k5-20020a17090a404500b001e8875e6242so9374371pjg.5;
        Tue, 14 Jun 2022 08:35:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xWiIr60xS8/zCuF/FGCVJ3LwokvIOb022kpSjncYrSo=;
        b=pDGoxmHp8W3+yDo9jzJ/8KTDj3iB+bQ67Yk0jIQS+k2LPhxGO2ZYWPmtwRnrsbeZso
         TVytspWEdcZG84oBJMOJ8rNhsQ48w4FlGnsmNOrB7pEE1QSB9jBiR4hhL0w2NKOolT42
         5FIwzFBgcERr/b0MOJmdkGadhBNCeailR6tGAPFGhKCro1wBmatuPqVJQhNOx401fBY4
         PDHoNJOrwQiaRF/nWP5Y903/L+OxDeqYqfWLapIB+ujtsjdc+Zk405sr4ohf4ULBtu0v
         Qbv6uLFK11kF61JpLdkCG24h3JDXaNQXfYo6gCF4UuDGhj+e4eq7vpYl750co8LbQFca
         MWOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=xWiIr60xS8/zCuF/FGCVJ3LwokvIOb022kpSjncYrSo=;
        b=GqqiE0TiG9qD+hleUIKS0YNRevpHtvr4O0BUnrXM6Pc6ahlNRKRmg9R/aEtLGoaBw1
         lYWNa4nySlxTRuQNDR3TO5MAPfuulhVtoeRwA26LPaq8vLn7LTa5hkyhNFYyzCsezar7
         EghdD7sqiW2EXmsmyodJjO4Juig56sKN/DPqd8+OqpAd73k9zAK4o/RbsAxmZpYKFb/z
         /TTybo3gzZVgmGxI0/fZ5t5OkjepfjlF9AWywIMbg8BhGFaoM07IlQefLALh+HpSy1uZ
         ivj/vrScd1vdcltIzFR53v06L0UBLemRf/PkoqE5qTI0zMYV62CGDGPkBzdt9X6Uc3x8
         E2jQ==
X-Gm-Message-State: AJIora9flZfCvgda3hoCGP5yQMUlWt+TuuyT00G3ardQnlkbowm7uTb4
        VOezcDG0eJ7okRZmspVhEuA=
X-Google-Smtp-Source: AGRyM1vw9A+t8Z5jHiAY8aO+QZ8RNCePsVfB7zukD9osQJDM51dh6/ai4HbrSdi6o3J0edLiiqdZMQ==
X-Received: by 2002:a17:902:d48c:b0:167:770b:661 with SMTP id c12-20020a170902d48c00b00167770b0661mr4987541plg.155.1655220935380;
        Tue, 14 Jun 2022 08:35:35 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id f3-20020a17090a8e8300b001e2d4ef6160sm7551268pjo.27.2022.06.14.08.35.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 08:35:34 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 14 Jun 2022 08:35:33 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.10 000/173] 5.10.122-rc2 review
Message-ID: <20220614153533.GA3088490@roeck-us.net>
References: <20220613181850.655683495@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220613181850.655683495@linuxfoundation.org>
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

On Mon, Jun 13, 2022 at 08:19:56PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.122 release.
> There are 173 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Jun 2022 18:18:23 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 163 pass: 163 fail: 0
Qemu test results:
	total: 477 pass: 477 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
