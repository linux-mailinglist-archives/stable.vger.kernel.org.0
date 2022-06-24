Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30EE7558EF8
	for <lists+stable@lfdr.de>; Fri, 24 Jun 2022 05:14:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229515AbiFXDOL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 23:14:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231276AbiFXDNl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 23:13:41 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 438C56927B;
        Thu, 23 Jun 2022 20:12:28 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id u37so1403569pfg.3;
        Thu, 23 Jun 2022 20:12:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=R01324GTrc8iEldNmp1cyqETuIoGIBSU4ZzLK64YPgs=;
        b=LN4EcgzP+ZUnLP0ayBqFPz31EM4XMCraeVK26cQy44VeQD3rCKA25ZQhxGbQ3D7uiq
         PKVEefjMonHvPy8QDPVdYwbwi8YhPqxzxiohpg6/ZHOm69VP7SJ3OiKnkLDBXCJZo0gd
         2mfzVhYxzLXaRUaAuV3VoYkUwM4xviaWldHFjbVGGwQHlBRhXUeuX0qunETMeH1tyjUK
         x/u+5+j761e/6Sq+xdIpcJK38zoihPQM/Xd8lq1/eHLR7vNQ441zrkFG7D9zJjG7+4S6
         Rvfzp6ypyhZ07HGyeXk4KoOdOhO0nAELT77ERJmjv5AL+l1zhKcSqGZnwopm/btzFLzB
         jDtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=R01324GTrc8iEldNmp1cyqETuIoGIBSU4ZzLK64YPgs=;
        b=SeoDgKHi+xZo3unu9xLPyBQPPndgFLLAyB+ruiNR6Ny6CpHNW/xlFPHx0RKTCCNgqW
         PRKLquCi7pTEKiEtwUFWteG1mzkBXutvRvsO5fxOm6QnjJMfshE6Oxe3Ja83K/oHtVDX
         RrbPcnNCKbUcqtCz3BBI0ZfMznb568xlG2b1pLgHgzg3/aYcnykapZNArbSDg+qvTJ25
         KvHaCEuNcfVhF9gEL7WzwLJM7Rr5ceLdwBdGwOFbD5lizUaN8dITYERqnrxLl0YLEPp8
         jE5fAJKELIglGezA5XBWsZMvRIavCwzPJvFyWy7fwSBZHxQQJNZA0WmvMnq/qtT6RzGA
         LO7A==
X-Gm-Message-State: AJIora+Hh49Ky1RIizSjA+Gd5jho1kyuTfcCJw7vepd+/HbLrKYgJgOt
        df375tZ4GSkuvIOXnbvug4g=
X-Google-Smtp-Source: AGRyM1uihVPoDltPCYqM4wVK5F8aQlIKa1EsGKl8ajhO2eK4Ej49PPJaAt5iFnadJFdILqULegMrIw==
X-Received: by 2002:a63:d244:0:b0:405:34ac:920b with SMTP id t4-20020a63d244000000b0040534ac920bmr9734973pgi.503.1656040348109;
        Thu, 23 Jun 2022 20:12:28 -0700 (PDT)
Received: from debian.me (subs32-116-206-28-14.three.co.id. [116.206.28.14])
        by smtp.gmail.com with ESMTPSA id u6-20020a17090a1f0600b001cd4989fee4sm2673010pja.48.2022.06.23.20.12.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jun 2022 20:12:27 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id 633D71038F9; Fri, 24 Jun 2022 10:12:23 +0700 (WIB)
Date:   Fri, 24 Jun 2022 10:12:23 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.15 0/9] 5.15.50-rc1 review
Message-ID: <YrUrl3g1Cle4HkEM@debian.me>
References: <20220623164322.288837280@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220623164322.288837280@linuxfoundation.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 23, 2022 at 06:44:43PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.50 release.
> There are 9 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Successfully cross-compiled for arm (multi_v7_defconfig, GCC 12.1.0,
armv7 with neon FPU) and arm64 (bcm2711_defconfig, GCC 12.1.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

-- 
An old man doll... just what I always wanted! - Clara
