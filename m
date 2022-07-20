Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86CE257B0E9
	for <lists+stable@lfdr.de>; Wed, 20 Jul 2022 08:18:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239401AbiGTGSR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Jul 2022 02:18:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239378AbiGTGSQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Jul 2022 02:18:16 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25FF35B054;
        Tue, 19 Jul 2022 23:18:15 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id s21so16782252pjq.4;
        Tue, 19 Jul 2022 23:18:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KOtZ3LBC2abA2vaR4LmLYTor2m8UosrNT//dZIUJaTE=;
        b=azPVvv/OKPkaKzhKXPpbGAqDO4Q3l4Jd7FTOEPwPOaZPUGBNmc/7EN1BgQ8bLNiNl6
         2gyMlI2g0LGiiemvphUREo2OM5m2fGALKbDyiyJPM97hZjNMME6QCDufgHwquJSHm3MK
         4nYrdkpHMwWPogEsAWV5aRdznNYKNtMFJ5JJ1RPZjlJgx3iEFivsUIes/febcVj4uCF2
         ebtnWwPqm6lqwgCVRHXblvSL4l9tcYxVKzm48WvXKkuV/AVuOcIEMbusziC4c7txle0u
         1e4X/CVfUmRpuX1L8J4jbEcTmbM9ARbXcMaJiOXmtNWOaAoYnj2Pa/wWbtwz7rVaRPnh
         BSLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=KOtZ3LBC2abA2vaR4LmLYTor2m8UosrNT//dZIUJaTE=;
        b=dFfwx0cQRsEZ+8HVwpADegJlxv7WvrkjnTkx8PA4HZ4Rl8Kcn6UpI31ENLvQ0n9vOP
         +VlMKXeVQc9YXeAvWUhmqhYtSwWjK3Sks3D2OETaNxSSK2Bn9DbQ6h/NDooZ0c6IQT7W
         ro2UI9t0RomaI2aFnm5Cag4J7H2xqNNApoCHzBE++8VCIxVAmqE3P5flECCPVPi4Jf9Y
         NIsN8IeDITSkqiqP1dupSxDT+9/OytCZSCpJ48gVHJ2+FpsHpGVqg0gFk5Nf85kBzdMD
         qcYsfqIRlnGqwSR4C25hX0Nfjx1uSUwmJMHhs6rbegZsPEYd8sAA2ESYEzmZfZUegtEF
         Tw2g==
X-Gm-Message-State: AJIora/dinaopz1iXn4mcuemClJwqnM/t7NO5ObUvqGzrkTQVImFSdZB
        SgSwHnZXaHOML7G/d9hinyI=
X-Google-Smtp-Source: AGRyM1tdD5/uDZBsRCV+bpoxjN0uze9vjwBk72xit79GV5hLXV0D6dHD41K4UElczS4v13qv0wyCWA==
X-Received: by 2002:a17:902:6ac5:b0:16d:1664:39c9 with SMTP id i5-20020a1709026ac500b0016d166439c9mr5021931plt.104.1658297894696;
        Tue, 19 Jul 2022 23:18:14 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id c20-20020a17090abf1400b001f04479017fsm671860pjs.29.2022.07.19.23.18.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 23:18:13 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 19 Jul 2022 23:18:12 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 4.19 00/48] 4.19.253-rc1 review
Message-ID: <20220720061812.GC4107175@roeck-us.net>
References: <20220719114518.915546280@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220719114518.915546280@linuxfoundation.org>
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

On Tue, Jul 19, 2022 at 01:53:37PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.253 release.
> There are 48 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 21 Jul 2022 11:43:40 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 425 pass: 425 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
