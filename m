Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DF816E87D7
	for <lists+stable@lfdr.de>; Thu, 20 Apr 2023 04:10:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232970AbjDTCKC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Apr 2023 22:10:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232918AbjDTCKB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Apr 2023 22:10:01 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D02C1BF0;
        Wed, 19 Apr 2023 19:10:00 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id d2e1a72fcca58-63b620188aeso670097b3a.0;
        Wed, 19 Apr 2023 19:10:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681956600; x=1684548600;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7N3NiubH465WFPzvYooVXc0UYExLXGtNobdceCXUn0k=;
        b=AjdYQ+RTF9u1qH53PZsGkQ4Ep1quwho6MHFVPCw8XgFoIRHCIZ1WBToqnXqX0/8viy
         HAluk/4Xz3Hz6t3nnb0J96tiivTlXZhpFFaefnRDaKVMWlMPKmMUI/gPQUwfs7JN3sxe
         cZkRnR67WOk4URG+PlMlBwZZjiZnh1Cru18een0PPwn5qJcO1a8SvEeuoapLBWEOhgs5
         cMJYRplPmW8ae65I4g9SwBADciLbEUTh+/gasIXjxornstSFe9Vwka4WGQpj/77zyB+H
         RJWvIqqhDPZz76qzPUvHPbH3E3+HnRe/3pRYblA851OoGacUw2vKgzdXo6b7qF+PWaVQ
         5zgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681956600; x=1684548600;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7N3NiubH465WFPzvYooVXc0UYExLXGtNobdceCXUn0k=;
        b=UqLrOqhysqiMqQVemfpRRIiGj04sVDh6w9xdvV/0na8tXy/4P8mX/X14CEAj7Lhb/k
         hw9MklaINIIFnDGyngxnimj4EGDsNuMnjlDtYZVyMQ13XRVgv+GtjgFumOFwwXCGihAQ
         K/oN4C+x4xTk6hDAfX16RFXXMXq8TBDvCTcWDpKwGEvap9YttVTuxHU8EsooxbO9ClJE
         /q8UgsMvaGru3dHcBiFxN7Tg/p1wM6gE0PTQ2tYCeGBtgKXfBUMfZJfTK+8z0gfNH9vK
         ZpXuLV7n3gALubIFXhLWgXTzoVcpS1dj9vhvlWktDWZ9tu98UWwqaXAHb/Q19OR9x7s3
         ozaw==
X-Gm-Message-State: AAQBX9dnSVu3f0m5UkUgX+brLf1m5nLpJwjnFF5384seE5ZUld97WRse
        EIh8Pq/s32fZgE/jkNKbYKM=
X-Google-Smtp-Source: AKy350a27WD/adECtBQMhU+UNj8Bgq4EHslnQOQXpJUm+iBwqs5+x0/545P7KJFOatHM2RTL1UK2lQ==
X-Received: by 2002:a05:6a20:3d90:b0:ee:2f91:206b with SMTP id s16-20020a056a203d9000b000ee2f91206bmr125517pzi.1.1681956599969;
        Wed, 19 Apr 2023 19:09:59 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id i3-20020a63d443000000b0051b5d0fe708sm57719pgj.43.2023.04.19.19.09.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 19:09:59 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 19 Apr 2023 19:09:58 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/129] 6.1.25-rc3 review
Message-ID: <dc11a2f4-ec6d-4b49-9d11-fcf7f306c85d@roeck-us.net>
References: <20230419132048.193275637@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230419132048.193275637@linuxfoundation.org>
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

On Wed, Apr 19, 2023 at 03:21:54PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.25 release.
> There are 129 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 21 Apr 2023 13:20:20 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 519 pass: 519 fail: 0

Guenter
