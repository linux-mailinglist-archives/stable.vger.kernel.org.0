Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C815F53D82D
	for <lists+stable@lfdr.de>; Sat,  4 Jun 2022 20:54:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239638AbiFDSyB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Jun 2022 14:54:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230084AbiFDSyB (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 Jun 2022 14:54:01 -0400
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB8C0443CA;
        Sat,  4 Jun 2022 11:53:59 -0700 (PDT)
Received: by mail-oi1-x236.google.com with SMTP id w16so4627802oie.5;
        Sat, 04 Jun 2022 11:53:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6y4kicItrBlNi/nini8hPZFM/Bdv/7z1VRBptniPfzs=;
        b=Mw108SmO3SxgIxnpl4Xh0L+8C0eeHlwOKYpDZ2i8SAUxOIO/5we1bbWrWdpwm5deCT
         Y48tGDnoBTez08tP9+WEHz7Dl/vm+VjQ9a6zs23P9ZBJyUfWhAyNI90AIQTscS0pbvdB
         9TiisdqpJk3P//l3e7Wnkw8zcwS7SEk+BjK09GJLTM5jeWfcrKqp4BMYZ49wh2B9dxo9
         Dzl6ZsfA2JVpeJt9dA8qYQQQFchPUH/vWgMuceW7eJthIyeiaR6R7VaaM2C/bC2FvVVq
         SLAbfniF1/vy+2v78m5zr/YRgLW+3MUyIE48IcHgOIqqxjkhGvb/CjGLc8kITq+KTNk5
         4+jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=6y4kicItrBlNi/nini8hPZFM/Bdv/7z1VRBptniPfzs=;
        b=BSWu+jfZeB7eE5eLqvvNKh5+7y+Q9DmYxOgtLSJM3upWrjdaHHrOYbKFbdFT8Fc6gn
         qg3/vTp+yK0ZxtnrjTOav8UA8l7SX8XXL0sf3ci36duBaArkF4z5ZFgrvqSM8tJfMyQA
         aeXzTm+RdX3ofM8lKNHySIzmdvJZ3I/ok8ndwIBntzYS+AzlFtAgBUxc0dSc60YNekpP
         buGKCebu8NSCvx8YXQ5mA7rxPf8noqbe2UOBJWB3N79w9J5/JDOt4LHdcXnf9SauSru7
         eci/eqYU4CGKu0oiWdC9TX2qQ8fEixp15YrnMQq801BSDqWVtwHG17/Xv/PSP+wzMnYG
         PeIw==
X-Gm-Message-State: AOAM530WYIH2HCgLmdEHvUdvc1TPJP1fBP5kPD2ot2I7dAHjnZQCtLO4
        euawh2Z7AH2rewxGlpd5JFA=
X-Google-Smtp-Source: ABdhPJwzh5BGomf2enOKo1+FhpeFK3yxf2U2tA6YYXXGaiNXPQcBdD+O9CWf8VMTLvFsxcaA65KzjQ==
X-Received: by 2002:a05:6808:2cd:b0:32b:7fb5:f43c with SMTP id a13-20020a05680802cd00b0032b7fb5f43cmr9546426oid.4.1654368839175;
        Sat, 04 Jun 2022 11:53:59 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id j63-20020aca3c42000000b0032ae369c25esm2189116oia.53.2022.06.04.11.53.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Jun 2022 11:53:58 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Sat, 4 Jun 2022 11:53:57 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 4.14 00/23] 4.14.282-rc1 review
Message-ID: <20220604185357.GB3955081@roeck-us.net>
References: <20220603173814.362515009@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220603173814.362515009@linuxfoundation.org>
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

On Fri, Jun 03, 2022 at 07:39:27PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.282 release.
> There are 23 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 05 Jun 2022 17:38:05 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 169 pass: 169 fail: 0
Qemu test results:
	total: 424 pass: 424 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
