Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72AC3572BDD
	for <lists+stable@lfdr.de>; Wed, 13 Jul 2022 05:25:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230347AbiGMDZP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 23:25:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229877AbiGMDZM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 23:25:12 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2DB9D7B98;
        Tue, 12 Jul 2022 20:25:11 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id f65so62248pgc.12;
        Tue, 12 Jul 2022 20:25:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=I0t9EIGx4q8M/PbcAW3QMWpZX+azC0xMuafD3VsWuUU=;
        b=RjHV3dukCq6tKei3NSPkjSMaoBrFtJ5mcpeKwngQC7ZClo8uDRulUOVG6UzgH/9ZZ3
         6KaNFrge89XGyp+WjWbSA5Tu+PHNzA+wUGctXk0iPLjA5FfYuE3ikJbnYHIKCm96qVPI
         +b3zGnXy3b9WBuvruruDs8bW151J0Svwi6Spi2qEn8spA1JFuXUT5ZQsFL6rXN9dhO02
         uwABpu2FzFqpbERJS9oizKXxSyUfTUEOAgqZbQbAoM51XIvyaFKobx+pR3y3JVnaHKie
         pQ0e85W7yFupTHGuJqFKZeQmXq9gW3nKCELVqyUHKKWvg1RUsuAHKUPs7ZIDr606hqDI
         8sRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=I0t9EIGx4q8M/PbcAW3QMWpZX+azC0xMuafD3VsWuUU=;
        b=kFO1+FXO5LBgQPxSgEHI4rR5c042pfyuEujHc4AWX5HJMYc8H4Ze+A+vZHqcj+l1uY
         yqInxqtxPGd2Ze77cAOkN/aRtiGA10wIxCLCES1YJU5/jKIGC0HvQxzDB9WvlmPay79X
         U5NBB8uMMmzZJRatvj2tr1Ghn6h8GFRlb58zHjhTxXCEHw0zzX4BJfpHywRZfDvRBwwJ
         8EbUHA7XxXrGDFUVqU8AHbo5Nj/kcVFy5YgshfsdjhZCoXRg7GV3k02wzZHdDa5wvKF1
         MkGhAyoaQeo42KO16hPwdQt5toamMCoMt0pzw8wZbPEf47CxCObF1qRI2ULJw7BTPkX2
         RSpA==
X-Gm-Message-State: AJIora8iIBg9lh2Cv0Lxne766glycPNZyxpPeG8P/+rbpNQQY5EMpCeF
        TEvXOo56hUEaZp3FZx7i6pg=
X-Google-Smtp-Source: AGRyM1t1mC9mqnRUjXLI//9KhWVY0LQB0m8/6PY5Y+9l8cDyj69xFATdZrZWxHG6y6yHhp5AFpwhLQ==
X-Received: by 2002:a63:e5c:0:b0:416:8db:4f5f with SMTP id 28-20020a630e5c000000b0041608db4f5fmr1207948pgo.620.1657682711337;
        Tue, 12 Jul 2022 20:25:11 -0700 (PDT)
Received: from debian.me (subs02-180-214-232-20.three.co.id. [180.214.232.20])
        by smtp.gmail.com with ESMTPSA id y10-20020a170902d64a00b0016c48c52ce4sm5000335plh.204.2022.07.12.20.25.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 20:25:11 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id D0297103868; Wed, 13 Jul 2022 10:25:07 +0700 (WIB)
Date:   Wed, 13 Jul 2022 10:25:07 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.15 00/78] 5.15.55-rc1 review
Message-ID: <Ys47E/SctQnOd7Fx@debian.me>
References: <20220712183238.844813653@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220712183238.844813653@linuxfoundation.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 12, 2022 at 08:38:30PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.55 release.
> There are 78 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0)
and powerpc (ps3_defconfig, GCC 12.1.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

-- 
An old man doll... just what I always wanted! - Clara
