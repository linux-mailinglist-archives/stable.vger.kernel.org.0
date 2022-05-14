Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70EC752724C
	for <lists+stable@lfdr.de>; Sat, 14 May 2022 16:58:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230264AbiENO56 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 May 2022 10:57:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233687AbiENO40 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 May 2022 10:56:26 -0400
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3897138BB;
        Sat, 14 May 2022 07:56:24 -0700 (PDT)
Received: by mail-oi1-x233.google.com with SMTP id w130so13610664oig.0;
        Sat, 14 May 2022 07:56:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+3A4yXgx4VxRVlfwFpRbvFoFyjL/IsSn0gGFGaa1jS4=;
        b=Jor4Ow+ybCHukBXLA39tTq7Smsk1N2H14w9U0c8LetNYZ0j6i/Jq8wxQNuB/6fNOz5
         z9s76oHqS120VAYoD4FAJiI9b3EYQc5qFoL+8qhluttbw8MxG6zaBWgbDr3ZxdvEjfzy
         EXZJDtX9hwY+XXeepZUcWiMLKPp9K+ytGUEOf3DCvqPrRYYAFdYd1Xnh+hY5Ciw5nCyI
         5geIz+SvPpMGz0fZn9t7PI5JDd4FXKfw07BIfCHLCw5fO7o3KjMurW0+G+DuRwng/wre
         k5gZXz0fyYGyi0I3Gqrw4MlqZdDLqolJArMUBqyauibYovZ5kPmD6OPaN7mMrdAP6ult
         scXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=+3A4yXgx4VxRVlfwFpRbvFoFyjL/IsSn0gGFGaa1jS4=;
        b=IPXiAnZcxiHbRa0pbPgFBIYCshoR3ZQhmYra+J9nYdmUHnSDr3tzYXMkR+NnN6WeGw
         OgQurwqNxAl9Ob7l/znGQ+fRw+5CrE8zQcbeU5P/mfSKE1R2Np7/391Xb7ET/IzoBciq
         b3OnxNubAwU+qgNed+al+Zt6E2JKzvyHP6oVs/TIjYa9OPt69sBFd+JLKORNYdfSTjy8
         zQ08D+8/M1u2KSx/TD5sfelVaSR49oSntEnO5YvDx2dh4TXbp/uuAcPoA9hWb17jAvlP
         mMWtJZFtHAh2FGSBgJkp1U/OATEVaWjyhzH7gvvVlolUkdDI3fNWRBTApgzF4VUmxw5f
         truA==
X-Gm-Message-State: AOAM530yNfMIXU8H/k/Lxdiw/T0Xymlx0fdUENX+JQ4eZFaH0AZLmY6j
        hF9vu61gHPPF784NsTu+x2Y=
X-Google-Smtp-Source: ABdhPJwHV9vVboGnDHWlT1sxrLvXhT+Qugfm8O133mKeFxOSHMWLZ82oieGvBBgEuYnjYj+QahgwNA==
X-Received: by 2002:a05:6808:2121:b0:326:7593:45b6 with SMTP id r33-20020a056808212100b00326759345b6mr10055305oiw.181.1652540183568;
        Sat, 14 May 2022 07:56:23 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id k19-20020a056870571300b000f169cbbb32sm1635993oap.43.2022.05.14.07.56.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 May 2022 07:56:23 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Sat, 14 May 2022 07:56:21 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.4 00/18] 5.4.194-rc1 review
Message-ID: <20220514145621.GD1322724@roeck-us.net>
References: <20220513142229.153291230@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220513142229.153291230@linuxfoundation.org>
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

On Fri, May 13, 2022 at 04:23:26PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.194 release.
> There are 18 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 15 May 2022 14:22:19 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 449 pass: 449 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
