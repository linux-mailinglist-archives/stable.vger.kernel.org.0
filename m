Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F377F5528B5
	for <lists+stable@lfdr.de>; Tue, 21 Jun 2022 02:48:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237461AbiFUAry (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 20:47:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244761AbiFUArx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 20:47:53 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 038E7CCC;
        Mon, 20 Jun 2022 17:47:53 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id f65so11646287pgc.7;
        Mon, 20 Jun 2022 17:47:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=O53mHHJWd6UV+P16Qtz3XA3RgnBQel2/JoeNnwuv+wU=;
        b=pe46MhYVxWnHKW7wKCvzo7uKTDQZBXbtDZt3S5RAvKVt81CiMcQ/Klk0WBtVX1yNeI
         9WXmop7cLQgb+cL0G4HtcP4+ipevA1jDuMOZxC+k+GNKG8Gj9jxnNdgv44Lyo5thkzki
         Zmj/md2AkIUOly2jIpwzcaREjHEK1X+PMS7+v1BSpy6PC0BhI5dYwPjSfHP8wBlps8jT
         mlaXJpRipCWZPIxeVXer+gzNcu8Tk9Pw3CzQV9gzn1L+Gh26KMoVYy6zHWJwlKMf/HRf
         9vroUEUFh3CTUSX/pIYhKHAi28njDr7a5JpOM+XuKuv/1Wd9rxyEgsQa6ERttXwl2Yeu
         s1ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=O53mHHJWd6UV+P16Qtz3XA3RgnBQel2/JoeNnwuv+wU=;
        b=p/w9yPsn/sl2gTH6+JjSAKEKt3MS2jpwMnAAKT/SoFKFeqd6sLzUl+FCeOJgRYPZU5
         eE/AKdY4WKcKuF6+GH7aZJ1o4a6YLTF3BNdW9yN36Q/qn5FzJCOno/qHNB714sZFqjxm
         Rjc8S+UG3cnHd6QaR609jYP1D2LflxlnHgxonzxIeykxtVoqpyVO6K7M2F6SY3zM0+2P
         jyYBMpGhqgH3YLCAfudd/qKIQVF6afhPx6yTG09oJElNKyiGdTVicfvIg6ZhINjedC3/
         TTvuH5IkgAOnrTp05ANxhjraMkEzFBo97YZnhSxsVJ/oFFwvbetbGwgSK3C8C2uQEIbI
         OgkA==
X-Gm-Message-State: AJIora+YElTpWwjVmEoASmkLFhJj/38a9KWXte56vn3K/ryhuhHBJwFW
        pCgZ01BNGG49ShCu9q1+FCk=
X-Google-Smtp-Source: AGRyM1ts25I394P4+MA8quk1K4ApymCUOBBIwg/5CLYxIprRxPr1tklV7r2SFRmYznDZ3+3jCel6+A==
X-Received: by 2002:a05:6a00:1a91:b0:51c:2ef4:fa1c with SMTP id e17-20020a056a001a9100b0051c2ef4fa1cmr27329809pfv.75.1655772472559;
        Mon, 20 Jun 2022 17:47:52 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id c10-20020aa7952a000000b0050dc762819esm4607010pfp.120.2022.06.20.17.47.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jun 2022 17:47:52 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 20 Jun 2022 17:47:51 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.18 000/141] 5.18.6-rc1 review
Message-ID: <20220621004751.GD2242037@roeck-us.net>
References: <20220620124729.509745706@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220620124729.509745706@linuxfoundation.org>
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

On Mon, Jun 20, 2022 at 02:48:58PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.18.6 release.
> There are 141 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Jun 2022 12:47:02 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 154 pass: 154 fail: 0
Qemu test results:
	total: 489 pass: 489 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
