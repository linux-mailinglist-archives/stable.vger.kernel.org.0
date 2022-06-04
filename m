Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC11053D838
	for <lists+stable@lfdr.de>; Sat,  4 Jun 2022 20:56:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239541AbiFDS4S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Jun 2022 14:56:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239636AbiFDS4R (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 Jun 2022 14:56:17 -0400
Received: from mail-oa1-x29.google.com (mail-oa1-x29.google.com [IPv6:2001:4860:4864:20::29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3E9C4F479;
        Sat,  4 Jun 2022 11:56:16 -0700 (PDT)
Received: by mail-oa1-x29.google.com with SMTP id 586e51a60fabf-f2a4c51c45so14512933fac.9;
        Sat, 04 Jun 2022 11:56:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=tQKKWaYghC745Fd57VGOA1a0ja7KMza4/jJx3CoF1d0=;
        b=BJC7H4KD3UbzNlo6tG4U/ZYCOW9odODUWITNn94L7dhEwtjiEupaCm0BH3CuKXyphd
         RZOCRNNqi1O3qMQP35YICa6wVgTMGxlvmz5IqRltStDDcMAKbtr7h1jTW/0f4OyFAdtb
         X0Q49AknPhJTVdYt5i1ix223cxfHCmD0Kwxh92SWmP2jsBNS0TBd0Tbtm1svjM/unYXl
         NBBwcHv34B3pdJuJWHajpZd9Zji/MWB/oHcbF2e9C5lR7DV3wpN1PnmRrBcCGYYURZ2/
         uLkeroRlY5RE6sjvR0Ogk7gHKHTc6PIC4P4GQj+zmCuc+mN41pFDI4lrJzkMoL+qnR6R
         tRZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=tQKKWaYghC745Fd57VGOA1a0ja7KMza4/jJx3CoF1d0=;
        b=kovx16cfr0fLstftqzjIUuiH9SFRu4ETgf3IWPTuarJDw3+AczuxjS+cdoo2Ly7+Kb
         A/gFkLZbRYDPXEKFQ7NvgnQ0HWFnqKibdkUUyigs+aCqz+YSQBvJuSOHxMCSg5YXWFKo
         +5+MJJf/XuPthndw7h9TibjKV757dhV5YoN30M8YdrFSBT8cUdmL1Fvcx15wIDNLekCV
         hrLQ70bGhhiBu+qU9csO8+y2iyLHpC8TifvAYMkFh2oucOiXhqfJJDfe5UzLSk+xJFO/
         UfRegRgqpd4X+tHyDV6nNM9clJt/uiq4onGVXWfzicASuLSos8Hs2dCtwd9HWuTMWl6g
         mpgw==
X-Gm-Message-State: AOAM531bjxLuWkSUyV0T6J7eGOPf162Vm5/Ry5yH5r6cnEr1+mX7cQz6
        XfCel6hjY8dn1b71n6bCeEM=
X-Google-Smtp-Source: ABdhPJwxepMULvFK5HbVAsXyYqg/TulythpTC8mxma9LdVcwuWqOo/M2PvITLrySXXrWa+8y1JFJYA==
X-Received: by 2002:a05:6870:5825:b0:f2:da2a:78fa with SMTP id r37-20020a056870582500b000f2da2a78famr9140684oap.51.1654368976340;
        Sat, 04 Jun 2022 11:56:16 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id e28-20020a544f1c000000b0032c18f04800sm6067596oiy.1.2022.06.04.11.56.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Jun 2022 11:56:15 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Sat, 4 Jun 2022 11:56:14 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.18 00/67] 5.18.2-rc1 review
Message-ID: <20220604185614.GG3955081@roeck-us.net>
References: <20220603173820.731531504@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220603173820.731531504@linuxfoundation.org>
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

On Fri, Jun 03, 2022 at 07:43:01PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.18.2 release.
> There are 67 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 05 Jun 2022 17:38:05 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 152 pass: 152 fail: 0
Qemu test results:
	total: 489 pass: 489 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
