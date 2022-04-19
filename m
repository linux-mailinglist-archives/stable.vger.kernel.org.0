Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E20495060AB
	for <lists+stable@lfdr.de>; Tue, 19 Apr 2022 02:08:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237799AbiDSAK0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 20:10:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237756AbiDSAKY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 20:10:24 -0400
Received: from mail-oa1-x31.google.com (mail-oa1-x31.google.com [IPv6:2001:4860:4864:20::31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A9E03882;
        Mon, 18 Apr 2022 17:07:44 -0700 (PDT)
Received: by mail-oa1-x31.google.com with SMTP id 586e51a60fabf-e2442907a1so15843453fac.8;
        Mon, 18 Apr 2022 17:07:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Di0BAlr8LlWx8Ci/Ew3/yaK9KDuVCJ1BCJlDq71lACE=;
        b=n858Z8o0N5et79u0bdVMDmN/wGGIJzft8OyfhoNcrANE6042gdgi+BeNJwHnpk4CAH
         F/bG1WOIlMMKvzsK7BLPPPwSO1F5eL9S1qs2QhSiW2J1bIUl4sA0CS13P9tvLSTpGyUb
         drc2DCzR/BZnZdmNKbxv7DGaJkQ7fqPsZDbWUb+fPO9OX+vKZU4W6NRRo6EH+P2tm69k
         eXNgeJpEHTqAa7Iqc8rP8qLijlDVsOmB1hrfgzX9GDv2kBM8jx5rFeEItwm2/MPEyHPW
         FmXq7PtXfZigUVMXfiQafHO9thRMFoDrFDtHLZ3OSSNhjPi9NXg/+SLVxDnz7mSu3Tfk
         EaOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=Di0BAlr8LlWx8Ci/Ew3/yaK9KDuVCJ1BCJlDq71lACE=;
        b=urBNv2ZSsLyT/ffsvMqFw6ExdAr0dZCAw+PrQ22FchXn1wsxVwyysVYVzmr5A6TzQt
         75xng+OjpUoNIr9HXw/TYqZlHkHg0uLtP4/mFI/rXAQ9kM2LzdDaZy9EJYYQqIsmc+HD
         DNUWKjY+fTYZSbzsGiWpjjl0iOYJBi+UC2gCaGFCi1UPZMLylYPdnS3mNwmllj89vinr
         30ED8t0P0FvNH4ZznFGCA4ZpTrFbjm52+15BzvpDTiOMXCwQFMd6F8zjZqXGtC+m3eAB
         5IHIqWK7lbQhB2WWOUOR+FFcEIrLdi+bhdk7rcD7P4SaM4GoEiJNitQDbomhLA8gkHKI
         n8EQ==
X-Gm-Message-State: AOAM533ikwjvre+kawCBGv/mLF0I5W+PzyfS3kLMvq5alq9usBkS+i35
        PAPuzvFW/dZdTBZAC+K3sAo=
X-Google-Smtp-Source: ABdhPJyIpdPtYeP3zoSc36DgG1ek2d4Cacs/q+LcTG8f3DnzgxQjWIzdnVAF5M5LGqXovlT/8rfBVw==
X-Received: by 2002:a05:6870:2498:b0:e5:9555:2546 with SMTP id s24-20020a056870249800b000e595552546mr5454982oaq.292.1650326863753;
        Mon, 18 Apr 2022 17:07:43 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id e22-20020a056870239600b000e2f0c69849sm4586584oap.11.2022.04.18.17.07.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Apr 2022 17:07:43 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 18 Apr 2022 17:07:42 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.17 000/219] 5.17.4-rc1 review
Message-ID: <20220419000742.GG1369577@roeck-us.net>
References: <20220418121203.462784814@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220418121203.462784814@linuxfoundation.org>
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

On Mon, Apr 18, 2022 at 02:09:29PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.17.4 release.
> There are 219 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 20 Apr 2022 12:11:14 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 489 pass: 489 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
