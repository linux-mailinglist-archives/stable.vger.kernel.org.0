Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA07C55D1D4
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:10:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245108AbiF1G2i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jun 2022 02:28:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244419AbiF1G2i (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Jun 2022 02:28:38 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55367220CC;
        Mon, 27 Jun 2022 23:28:37 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id d14so11612938pjs.3;
        Mon, 27 Jun 2022 23:28:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Lz2Znnf9IZcn1P3quevTdWw+TPb/9BUeJWQUzl0b5mg=;
        b=cYC9ir8BSgJ1BS2BtxWZdhSj2SPwvzGcQIUwoISQIkmawEfzgsL5kJ9u+h7OmdrwDs
         euogU/jXpGRUnzRjWbbo3ram5aGxLMZ2uL1dHteGca+qJAyJWuH29+pEDq1uGOtFpBfN
         +Qv0TmUlg1/F4GZ14jiBFh0qxr4UTP2BTQ/oJSQO8V5fW0Ro0NwD1qtwZ59GZ6vOoEFX
         neXF8fP2dLjjY6MCtbzpSOgrIgB4/T0KCVbykvZ7IbETBkksQKMn1fpEsCp4qKUcxED/
         wtwHSc7rwCPzGdsEXqhmoGmlm4ZTRrYk/jxN32alW9+Jq/g7DMcZ8ykK31gTbbeH5Kx3
         45jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Lz2Znnf9IZcn1P3quevTdWw+TPb/9BUeJWQUzl0b5mg=;
        b=iYrESvGo+/J638J1LG6A/qsTX6UYZTiFKqheS2ajHpXChoL2/ZZHBnG/2aENhzuD1R
         p3iiQdNMqyrrjMVlSpgBLbNHg58Ia4TbUFQvawIz3nVEAbO1Tc5uI5CicqSN49qM13Lu
         ao2d+gTEoz9D9WetUEv4WtLnB/spivVuYvp0xtf+HOYYnC8Xt+ilfb/wV1szTlyay28K
         LTqC4MRR/oIWp38vuwsbAyykpMo8twsHzz4pudyPVjUg+MNXizfVaDw/rWsGvwLJW3AQ
         GHY4bkI49g+lP0iJ0s9D6pDHeNzagfYWN7BFcIg8YgUlQo22MS4DtlKxD6k7fTddWem3
         2L9Q==
X-Gm-Message-State: AJIora9gepiXXQGjfM9gzFLxyXYH6lRV5ZRerDwvcNnnIBjM44bcwp/V
        Fe1AifscwfCvL6T+Nk0xI6w=
X-Google-Smtp-Source: AGRyM1tQ7ZjAKHS7u/KJiF3RMbrdxAOQW+JE/45uuMsy92jJUguc7LWOfsS49jFEmqeTmsmVb0m55w==
X-Received: by 2002:a17:90b:1b11:b0:1ed:37b0:be25 with SMTP id nu17-20020a17090b1b1100b001ed37b0be25mr19729364pjb.99.1656397716848;
        Mon, 27 Jun 2022 23:28:36 -0700 (PDT)
Received: from debian.me (subs28-116-206-12-55.three.co.id. [116.206.12.55])
        by smtp.gmail.com with ESMTPSA id u1-20020a1709026e0100b00163d4c3ffabsm4248212plk.304.2022.06.27.23.28.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jun 2022 23:28:35 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id 11300102CC5; Tue, 28 Jun 2022 13:28:29 +0700 (WIB)
Date:   Tue, 28 Jun 2022 13:28:29 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.18 000/181] 5.18.8-rc1 review
Message-ID: <Yrqfjdvb/+n4Bcfn@debian.me>
References: <20220627111944.553492442@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220627111944.553492442@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 27, 2022 at 01:19:33PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.18.8 release.
> There are 181 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 

Successfully cross-compiled for arm (multi_v7_defconfig, GCC 12.1.0,
armv7 with neon FPU) and arm64 (bcm2711_defconfig, GCC 12.1.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

-- 
An old man doll... just what I always wanted! - Clara
