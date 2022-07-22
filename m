Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A4C957E154
	for <lists+stable@lfdr.de>; Fri, 22 Jul 2022 14:14:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232242AbiGVMOh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jul 2022 08:14:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbiGVMOg (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Jul 2022 08:14:36 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADFE31CFD9;
        Fri, 22 Jul 2022 05:14:35 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id c6so4416206pla.6;
        Fri, 22 Jul 2022 05:14:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1TcMtG/0Pi4d2uvmmtxytn3Hxkw0t0arvpnvwaTI1FQ=;
        b=TVe5e6ZC/dOVICF+hNs6Jeck9+bfXPD566YFbs1yPgbiC+TSB9+u56qQJEoAezGPRf
         JrtNIbhS0wOt7lqPVLIsxB/1mR850zwOus+JCzaeH8K05pJ7EIU+V2CMMhyTisN4foqM
         v10HlC0JJMKlQ2d1bP8AqMEfbZsJQp5qh/grK9uSTO+lfEHTNURxMz0GX+u+ZUzQINfZ
         /z3v27Bmx0mbMTNaNjblpxr8LDC6n8vdKbnm/KJGY8zuMPbn9NrkDT1q08itDAmRIZfI
         tw2bjVDxheMsHVK1aAS5323TsUdPSn4X7nwP88zY4+yC3EmqGxljkynpycQ3NWDA0yOA
         ITtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1TcMtG/0Pi4d2uvmmtxytn3Hxkw0t0arvpnvwaTI1FQ=;
        b=MR2fAE0z9F3skmYd5TJfhyVMf8n2gUZYkILS3W3OiaRPh0XUHLLO4bGqGgHCn+NbxO
         WbNOmFUgkHdTncIPYxFcCHRKRF3nFgJcHMLIoyME0JmUyIu7C7BanMHfwUiNRY6F8Esu
         jKJ+ukQzKBAycFCJocwoTJkmTYBTVt5MP459rxQ6gOCvdH8fp9MdUp4ZzvgNoI6zMhko
         mRCpt8PVC8UKn/AnZdDt6n9L0h23OiL0Y9g4cPVjLwCPmI0rF9C+vrkw4tlu2/Lv/glJ
         viUXJoOi/yCF8Aq8ClLxAwuRx+PwxD3IdvmjttYHwzZtxsMIcMZcmmv20e27/BJpjnMn
         54gw==
X-Gm-Message-State: AJIora84cXwKHb9vDMjZ++ZmVxQWxfKx8SqbVHa/saBuazmEIH8s5EZR
        QLXjnQKcYwlGUPy9pIofWe4=
X-Google-Smtp-Source: AGRyM1vGzDgfwKdmSRBb8Rq7gEohZq9ZFvNEGG5SrGtOboM+1Sksy29AK8Il4weHpL4H28H+mb56IA==
X-Received: by 2002:a17:902:cec2:b0:16c:3deb:a062 with SMTP id d2-20020a170902cec200b0016c3deba062mr85897plg.136.1658492075054;
        Fri, 22 Jul 2022 05:14:35 -0700 (PDT)
Received: from debian.me (subs02-180-214-232-16.three.co.id. [180.214.232.16])
        by smtp.gmail.com with ESMTPSA id a125-20020a624d83000000b0052b66304d54sm3782762pfb.74.2022.07.22.05.14.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Jul 2022 05:14:34 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id 65735103B80; Fri, 22 Jul 2022 19:14:30 +0700 (WIB)
Date:   Fri, 22 Jul 2022 19:14:30 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.15 00/89] 5.15.57-rc1 review
Message-ID: <YtqUpmnFeZ1ySHS+@debian.me>
References: <20220722091133.320803732@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220722091133.320803732@linuxfoundation.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 22, 2022 at 11:10:34AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.57 release.
> There are 89 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0)
and powerpc (ps3_defconfig, GCC 12.1.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

-- 
An old man doll... just what I always wanted! - Clara
