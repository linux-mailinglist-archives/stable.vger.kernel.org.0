Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56E255627E4
	for <lists+stable@lfdr.de>; Fri,  1 Jul 2022 02:59:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231906AbiGAA5B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 20:57:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231503AbiGAA5A (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 20:57:00 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D360857258;
        Thu, 30 Jun 2022 17:56:59 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id h9-20020a17090a648900b001ecb8596e43so1110054pjj.5;
        Thu, 30 Jun 2022 17:56:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=BJJehsRc35e0jlRF82KDpV8sDoNKGTc9Y35tLQrojRs=;
        b=qOw6kO5Ck1UErRyOlhcUj6Ee4k1H6wO/NitH8Kmvy86GWyA9IoAprcivpJzoy/mSzL
         jCCp9BI1An6WWJbmuCqrc2IRtUKr6NoXWS+5eC3gzUZllP0Y/aFyuPQhI97VuvE2r3TH
         vmCCZQu2uIAmJym7lejM+sPJfl1ppXCN+68QhtGEfwnxcicncb2ZaiCwmThk9VJkRB2K
         O58VmlQX79k3eM5w3ocgrf8qMKAyq+N+ohGGWhKgflcDicus33z4c293fFaeTn/mYo7p
         7TSqkZAugYOINn7Nj0ZxJDllTJY0vupvDX8U9gBQ0a5zomJev4qcspAERqezJpXQrmTt
         bfyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=BJJehsRc35e0jlRF82KDpV8sDoNKGTc9Y35tLQrojRs=;
        b=3kse9iz/uPpVDV/uNr52P/PifrbyI0jCVLph2uCzPX1AGm/b8SyOPHEQgDCFht4etK
         quNk3v5ZdYJVeR3IZZF66uTB48/oFxDIQc5dU8TAgnSNjZYbX9Ars8zM6Sggsr+OiXdh
         k67nLKNS8/3Q3rSecrR+ysf5Rl8usnt3N5z4W/hHhEPoWXOYQ8uvdueJpOCeCt5CSgZY
         JFlaYfJIpvimMoGzSFtL7rFc7bDuV7YgcMvTMFPX9HK2n0ssGSd66/RcfbbX3gIAhto1
         SqQX6jU3fFC9JkyU4ZFjsXKuArT8HAWyGxOuWCIZMsloGtyGtZ+bFpxugP0s5+emIzPz
         vYZA==
X-Gm-Message-State: AJIora99fppfsYs4ZG+ER6spMyecbLwRfuOAgswWeYguFa5hH74jJxDV
        onSdRvQoW0cz78ATURxI6Tw=
X-Google-Smtp-Source: AGRyM1tzl88qqIrvcBSJkZ8sohKyDIYYcOudx20q5x771cCWkk50LGgA3Wlx2S1toT/+E4TqQolspQ==
X-Received: by 2002:a17:90b:240e:b0:1e0:775b:f8fc with SMTP id nr14-20020a17090b240e00b001e0775bf8fcmr3940467pjb.132.1656637019400;
        Thu, 30 Jun 2022 17:56:59 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id z5-20020aa79e45000000b00525b7f3e906sm9037478pfq.27.2022.06.30.17.56.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jun 2022 17:56:58 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 30 Jun 2022 17:56:57 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 4.19 00/49] 4.19.250-rc1 review
Message-ID: <20220701005657.GC3104033@roeck-us.net>
References: <20220630133233.910803744@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220630133233.910803744@linuxfoundation.org>
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

On Thu, Jun 30, 2022 at 03:46:13PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.250 release.
> There are 49 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 02 Jul 2022 13:32:22 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 425 pass: 425 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
