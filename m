Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21376571A79
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 14:51:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232118AbiGLMvI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 08:51:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233139AbiGLMvI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 08:51:08 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B9DD32446;
        Tue, 12 Jul 2022 05:51:07 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id w185so7398569pfb.4;
        Tue, 12 Jul 2022 05:51:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=djPWkwxBwMJO4Ibjr+f6UV9b8lLacM1A6e3CViudRBU=;
        b=LnVfvehFXfzyc3Eo0tFMGhhfzGyGASo/+MbgePkidRkBdEPB/q3YiMIQBSJ0EMt3P6
         VRMupxqOF1rcC5dd/ZEasbTyHdVGlikhM7CMBPbRMvJxI6RFdUptAOtN9dhQxftYuF2x
         qMzyiz0m8nAhyeab+VVSGSKr1+N2Un3Ey4hsX25+isN6o4nObyIzvze0Q30tVTPu5rSl
         O60CqZ8GJpUbYQmJyJnUI4HyEuVsQWChSuXbMG6ExNarn1ENZLlo04+HwY6GIlSvmqxw
         oi4QeT7mAYtvszpVXHTdZSq+ebXtKLaIJDbahyG0F2sqtzF5wJq9HlfYfgNyLnv59vBb
         +g0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=djPWkwxBwMJO4Ibjr+f6UV9b8lLacM1A6e3CViudRBU=;
        b=32iLOocoxomK0TxUWfSVpv5jmUOA5IHHfWqhVKK0unnozc/239guBw5ksC5wWPplQ7
         iZ8V0DhxSNuDq/yBTVzcuQPJYdZZlLLyBiANW77L92ipGJ1zQV8eKKfGgbLm/Hy8UO2W
         RbxC+wATjDxtqa6y4ClwC/+NMvR6M9YkH54eURJ21ut52WNZaxXnMZhrZOyTV1Owf8Pe
         4YWNLJFHklf1M/MrHg9TAAXmGM5NKWf9xuQbVUorWkfxcA6pSE9N8J7UUjFd195wcOOH
         fzziFffub6x34vIR5sfhSiAGavbBnEuQBWl1yqyugqZwRd2rzdP5zOqM++Y1dCu3TEJn
         rpJw==
X-Gm-Message-State: AJIora/HCcroHp9/IgTsH/MbRrwE4hzYbG2TGO4hyPEtSl8885Poqpq8
        joQv8NRZL4eLcmv+3YVwCv0=
X-Google-Smtp-Source: AGRyM1tzeZkYZURckIBM9fONCrPXSmFqSXjmgRIJo+1o+K5SwrwTwPIKzlIihpX8lyDudI4sVxvW8w==
X-Received: by 2002:a63:8ac4:0:b0:414:df9b:45c6 with SMTP id y187-20020a638ac4000000b00414df9b45c6mr19971686pgd.560.1657630266797;
        Tue, 12 Jul 2022 05:51:06 -0700 (PDT)
Received: from debian.me (subs02-180-214-232-23.three.co.id. [180.214.232.23])
        by smtp.gmail.com with ESMTPSA id u7-20020a63f647000000b003fbb455040dsm6032638pgj.84.2022.07.12.05.51.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 05:51:06 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id E478210043F; Tue, 12 Jul 2022 19:51:00 +0700 (WIB)
Date:   Tue, 12 Jul 2022 19:51:00 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.18 000/112] 5.18.11-rc1 review
Message-ID: <Ys1uNPNdCg6/qfFw@debian.me>
References: <20220711090549.543317027@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220711090549.543317027@linuxfoundation.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 11, 2022 at 11:06:00AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.18.11 release.
> There are 112 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0)
and powerpc (ps3_defconfig, GCC 12.1.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

-- 
An old man doll... just what I always wanted! - Clara
