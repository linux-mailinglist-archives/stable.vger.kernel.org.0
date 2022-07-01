Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23EB6562D4D
	for <lists+stable@lfdr.de>; Fri,  1 Jul 2022 10:00:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235910AbiGAH7S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Jul 2022 03:59:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235894AbiGAH7R (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Jul 2022 03:59:17 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C5726EE9B;
        Fri,  1 Jul 2022 00:59:16 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id 145so1690382pga.12;
        Fri, 01 Jul 2022 00:59:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=THJIBfXYg5B3OZN3p2D9YyRWw8bW1i+J7hwZlSfOlzo=;
        b=hXbRUeJPAh5K9P6xisu6/l9LMOaT8xu7iFSywtqNX4gqu8SKtW22JVtezLRHP5CinM
         rIHSzrI5OrQQAaLyGLIx1KmW82HMVXfokjR+04qvpgLbgenU0MqnFGQABHytG03FBypP
         XLaw9nfntmDpvFCXc/WzZJX9NsXJioCWpsO/fgqEOYPxCLue4lBaQjKVOlRXam+huLzV
         iIK8yCGJVFhawACZwPp2q7fGX21BIN6kvuLeXljJdtq0174JPGXgFlMWflAoCE/nBsBH
         NKmrajqQp/Zuba2ZhhD7a+oh1KebrrDUJ+ddSikuXnOdQCM/z6ens2VXsuSnrYqMEgJQ
         ZaNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=THJIBfXYg5B3OZN3p2D9YyRWw8bW1i+J7hwZlSfOlzo=;
        b=aLJ+j+zNSMe7QteMyWrvAT2mv0mbJRa7lq3ZnpyEy4dlnvIlfPK/CbFgT1u+/Wmmk5
         yGq8ajKCRlY/mgT9XWj+pQJZHh7aBUeixhU7vvquABl6tmPgrL7I/M4EbTmlSCYzlVP3
         9LkQV02gzYPMDmq4OpMaaUVuZaCEiYmjX4fmeqtjNlNZRp6UNwpH/PPOyL1sVTpsbHJf
         MQ5qS5YUh51hC7wDh98fhkZhmeLFsA1+au5socz2rZd+KuNx8eKSGdsO2xa2m/xSe5a2
         AecOZABR1NdBiEUftFKgcHut/uaR5CW+ts2uNb5NzdyNVwG7fjlqiw9jiLg5zQrsV04P
         P11w==
X-Gm-Message-State: AJIora8Dssg6oGtKgvRlb05MOkJ6bP+wemnhBYYWHrU0Mkq9m3lf8kjG
        u39cXGrfcdwrjC83CKYLOqo=
X-Google-Smtp-Source: AGRyM1vNzy53cX1HcpFxgi1nAluWwGUAZPZeEv2mpSMWyBucTTcmqL+W728FPUsMdvRyqJ8kbmaH4A==
X-Received: by 2002:a05:6a00:1d26:b0:528:3a25:ea3c with SMTP id a38-20020a056a001d2600b005283a25ea3cmr150383pfx.67.1656662356130;
        Fri, 01 Jul 2022 00:59:16 -0700 (PDT)
Received: from debian.me (subs03-180-214-233-75.three.co.id. [180.214.233.75])
        by smtp.gmail.com with ESMTPSA id bx23-20020a056a00429700b005251f4596f0sm14760274pfb.107.2022.07.01.00.59.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Jul 2022 00:59:15 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id 693411038C1; Fri,  1 Jul 2022 14:59:11 +0700 (WIB)
Date:   Fri, 1 Jul 2022 14:59:10 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com, Paulo Alcantara <pc@cjr.nz>,
        Enzo Matsumiya <ematsumiya@suse.de>,
        Steve French <stfrench@microsoft.com>
Subject: Re: [PATCH 5.18 0/6] 5.18.9-rc1 review
Message-ID: <Yr6pTvc0Zka7qVfc@debian.me>
References: <20220630133230.239507521@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220630133230.239507521@linuxfoundation.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 30, 2022 at 03:47:26PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.18.9 release.
> There are 6 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 12.1.0)
and powerpc (ps3_defconfig, GCC 12.1.0).

I get a warning on cifs:

  CC [M]  fs/cifs/connect.o
  CC      drivers/tty/tty_baudrate.o
  CC      drivers/tty/tty_jobctrl.o
fs/cifs/connect.c: In function 'is_path_remote':
fs/cifs/connect.c:3426:14: warning: unused variable 'nodfs' [-Wunused-variable]
 3426 |         bool nodfs = cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_DFS;
      |              ^~~~~

The culprit is commit 2340f1adf9fbb3 ("cifs: don't call
cifs_dfs_query_info_nonascii_quirk() if nodfs was set") (upstream commit
421ef3d56513b2).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

-- 
An old man doll... just what I always wanted! - Clara
