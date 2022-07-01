Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B9305627EA
	for <lists+stable@lfdr.de>; Fri,  1 Jul 2022 02:59:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231552AbiGAA4k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 20:56:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231503AbiGAA4j (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 20:56:39 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE46557258;
        Thu, 30 Jun 2022 17:56:36 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id b12-20020a17090a6acc00b001ec2b181c98so4875573pjm.4;
        Thu, 30 Jun 2022 17:56:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=LO1nwwYxpMTEQqa7x40y9nSAjFXmxONSMH4ilJzdxqs=;
        b=hvlAxDNlLo82e4yDmDQ/xjsa/+uCJgatMjh9FIiwPDFfEXjEtLTcHIfC+AA8fwEa5c
         mzSoCtCVp5Io213e+O2r6dKLrpCy88/t+I+23BS89DCiCkWTJG+E2TwxIsKOGU0ULZOp
         qlr5jw6v/KhVWA5TyxeOgt8Wo70Ra3u7YkwOWZ6ltfj7S/cdhH7ywFPdZ2augGgMEwgN
         sgR5SWl8diijVerw5cWWLOfuZggWPONUJHy5LFqbB2mwWXMq6RFQv4txE8SR2kvg0H79
         T9AaEBGQXtJjQ293NwF9VLqRh5sa6jk03RNW6tbILdLvHlFIijXNx14z7FP3da+KhIGD
         ZA5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=LO1nwwYxpMTEQqa7x40y9nSAjFXmxONSMH4ilJzdxqs=;
        b=U9272RBKsaN1SVT825x7y7UiUHppBn70GW56kZer/JZwyygftmn5AOCfrzVHwH96eO
         wxKiUkKiAnydg0CcCqW+5uRMNYUvv2sf0zzODpYy40Ga1iNAM7M75IPL96RH578uUtKC
         B7tqIvOMWKqbTYMgRJl3su/H0kIzn2SUHrBAOz+jhNHH+Xt/GkACOq8xcdPSwNifyMVT
         tJQYPcmqf30c+FyWEviMKcc7AC2EqcSd66Se6LP444aOcU2u+cjqSX08HAGkROdp4O/V
         79jBi0EFIUvQTY5b2V3QkDvwklK/jHJfV8VR4mAbnlc/vgEvlG+iLo5sbINx6wilW4Tk
         bmMw==
X-Gm-Message-State: AJIora+W4vHG/B0DKK1BLPgn1JbL1r4ZLIfvnvItpFM+KuI6itHX6cCV
        ozDtGRlpQFkOntXu34p6bUM=
X-Google-Smtp-Source: AGRyM1tI+vVIzo+Adnvj9nRccMGBZjjro1YwXOvpWumGZ/ipGdsWfZdg6t+aI8sX1EnZt8cHTlV/kw==
X-Received: by 2002:a17:903:120f:b0:15f:99f:9597 with SMTP id l15-20020a170903120f00b0015f099f9597mr18330513plh.45.1656636996418;
        Thu, 30 Jun 2022 17:56:36 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id l124-20020a622582000000b00518285976cdsm14304446pfl.9.2022.06.30.17.56.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jun 2022 17:56:35 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 30 Jun 2022 17:56:33 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 4.14 00/35] 4.14.286-rc1 review
Message-ID: <20220701005633.GB3104033@roeck-us.net>
References: <20220630133232.433955678@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220630133232.433955678@linuxfoundation.org>
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

On Thu, Jun 30, 2022 at 03:46:11PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.286 release.
> There are 35 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 02 Jul 2022 13:32:22 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 170 pass: 170 fail: 0
Qemu test results:
	total: 424 pass: 424 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
