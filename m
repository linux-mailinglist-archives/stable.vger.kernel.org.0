Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B38F6533225
	for <lists+stable@lfdr.de>; Tue, 24 May 2022 22:05:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237609AbiEXUFj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 May 2022 16:05:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231917AbiEXUFi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 May 2022 16:05:38 -0400
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E8365C64F;
        Tue, 24 May 2022 13:05:38 -0700 (PDT)
Received: by mail-oi1-x235.google.com with SMTP id k186so1715008oia.2;
        Tue, 24 May 2022 13:05:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1ZGx9X0iPxoStXGvTqfC3JEXi+Qv/ClEpXvApKGS6Pg=;
        b=JD01djDgIxhHfV+VulEQ/ZeprmZX560ntzjhds13+sXVi4HlBswJrn+JCCZIb0x1Os
         gSQoegv+5z5g5tUUNEfAqKWThWyfF3d5bUZyoyWTRO5EnsATjeMeDp/EtWPiS9UcHLzj
         WVGpQtwflxrv0kG6v0Y0cy54+dA6/49izFr0uQve5J+ox//6MiTyD45IpGJUoZ5IeW3A
         86MKDATOs4bBG628eJMA6IyccpkWyBu9Ns8fcgKo/tfQsDCcdV0bcTwQZ2nHMaoJdYHz
         7rlKpASbojKJU4DBBW6DzZtCG+FO00emTVaaPt+qhsQQzeLTWxljJK3A8jBZl842Sz7B
         NdcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=1ZGx9X0iPxoStXGvTqfC3JEXi+Qv/ClEpXvApKGS6Pg=;
        b=4VmT6/ttxoeG/dJO6ptDmNAppUcmdtnY0if5zcOHLeE4m3SgXPri26l06Vap+8Wn74
         tGp/y9dWi1YQF2eAZPE8InX4tzZO+r4oYcT/0Bfr+sS/29/6w636Wpl+P3jWWDNVfxvV
         r5Y1eJezbiEh+vjQ04ClaJ0MPXENOTJA7tOUoVcqaXC4T87/7aO5w9iiAIHaODC/0MkN
         Crnp52wi1ByuRFs0DI8gD9ko3yfZaHIm/xFvpHrYWHGeCKHntcbm0HlClF4DBpn+Zctt
         JzUGvRSxEvdFNeezWQ4RluJQORmKGUuN0WzuP+dpGUU6+cWW3tXs/AgvwImjHnMm0D58
         VD9A==
X-Gm-Message-State: AOAM530yTN3sdve9oKtBzys50GdKaYMx0mpRZht9QtGp85uJIjCdJt3t
        rb720gHqUX4OOCcM8EolSSg=
X-Google-Smtp-Source: ABdhPJwoa15RsXogMbUPDTFPpbgwdpm4ob21ybZ3nEOk5K/yQW/2y+W2sxQH4cr1BUp5v/nk/NAeOA==
X-Received: by 2002:a05:6808:130b:b0:326:d1ff:b56f with SMTP id y11-20020a056808130b00b00326d1ffb56fmr3311741oiv.222.1653422737532;
        Tue, 24 May 2022 13:05:37 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id o9-20020a4ad149000000b0035eb4e5a6b2sm5729217oor.8.2022.05.24.13.05.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 May 2022 13:05:36 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 24 May 2022 13:05:34 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.17 000/158] 5.17.10-rc1 review
Message-ID: <20220524200534.GG3987156@roeck-us.net>
References: <20220523165830.581652127@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220523165830.581652127@linuxfoundation.org>
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

On Mon, May 23, 2022 at 07:02:37PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.17.10 release.
> There are 158 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 25 May 2022 16:56:55 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 489 pass: 489 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
