Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34ED8510A06
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 22:13:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243044AbiDZUQm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 16:16:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354749AbiDZUQc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 16:16:32 -0400
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D60E3186BF6;
        Tue, 26 Apr 2022 13:13:20 -0700 (PDT)
Received: by mail-ot1-x32f.google.com with SMTP id l9-20020a056830268900b006054381dd35so13837845otu.4;
        Tue, 26 Apr 2022 13:13:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gilA20turI7rRz9XtlJVLN0DtonmByVLEDNDaKGjRl0=;
        b=U/tTb9QG+E96Ff1MoQ/pQ3fYInJpTBKvvJ5xE113hMgMbMGCW+6Di6V1Jnfr8TL7W5
         RrPcRzP0T52x8UQaAROiTfGOzuynSTya4h0BfXQ5MSEv5CaGJ+TrP2t16nbLBDkEPIKf
         kyKIS3pCBd+r8KwI1GO2aamg3R2Iy4/f+L4RwnfzB4QUPQ6X/xDabblwLK+scpHutv9B
         2bxpl8WQzbYo6zz0ntyQYB/5lWCN2kzBBDaD/7ShysP83cT7ZpEMgpQ8cF+IibaZ6tTr
         ZtA5O7CKAtvgBxm7FLU8a+T1Evk7M/psFVgVR68QB5Fx/IChywh79Ah8xIC8kjP34qhT
         l7gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=gilA20turI7rRz9XtlJVLN0DtonmByVLEDNDaKGjRl0=;
        b=U2Ee931WeZueo915xg734AvFshRZfGjMRx1ASIB5yKTGaqii0oo8LpYx6OA+HK7OSD
         hcmdo58Cy68E75wcsY5pa7exkapp+zwUlcR0WjeGE7khT+eq+aDu3WEdrTCobZ5l32TR
         U/KjX3ytJr8/+LFqsQI2oX/UZQxPgq97qL6iUDR/sxHTdLab/VZiX6UJuwf+797KpkFG
         EsLtQkLcxVObrLMxXlbS8kscSPT+SgW01soy/+duKdTsLWAX5WatbvtsA0d4O25OocsU
         BM9agL2OVbGlS7n93oDDtxyWyQwOrX/ImBrvjgfocx+REYifQL0ex98yAN8DGrU8CRzh
         4KhA==
X-Gm-Message-State: AOAM5336EccUknH84pvok49F1fWRe32Fq/OsZRZaUAkogIe/AfWbeajx
        je5rNeibrLbLiAK9oFnRImA=
X-Google-Smtp-Source: ABdhPJz/0eIjddkNiosIgDO4YmIlVnADKopoq76cVZeBQi77GKwGrfnoZ+FrVDbakS7id0fP3YcK9A==
X-Received: by 2002:a9d:3609:0:b0:605:d53b:1d50 with SMTP id w9-20020a9d3609000000b00605d53b1d50mr1087506otb.253.1651004000234;
        Tue, 26 Apr 2022 13:13:20 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id y20-20020a056830071400b0060578d19d8esm5245482ots.19.2022.04.26.13.13.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Apr 2022 13:13:19 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 26 Apr 2022 13:13:18 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.15 000/124] 5.15.36-rc1 review
Message-ID: <20220426201318.GF4093517@roeck-us.net>
References: <20220426081747.286685339@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220426081747.286685339@linuxfoundation.org>
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 26, 2022 at 10:20:01AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.36 release.
> There are 124 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 28 Apr 2022 08:17:22 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 156 pass: 156 fail: 0
Qemu test results:
	total: 488 pass: 488 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
