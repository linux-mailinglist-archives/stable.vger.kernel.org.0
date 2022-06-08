Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 414F254401E
	for <lists+stable@lfdr.de>; Thu,  9 Jun 2022 01:51:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234736AbiFHXte (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jun 2022 19:49:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234857AbiFHXtd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jun 2022 19:49:33 -0400
Received: from mail-oa1-x30.google.com (mail-oa1-x30.google.com [IPv6:2001:4860:4864:20::30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E422C193215;
        Wed,  8 Jun 2022 16:51:18 -0700 (PDT)
Received: by mail-oa1-x30.google.com with SMTP id 586e51a60fabf-fb1ae0cd9cso18597508fac.13;
        Wed, 08 Jun 2022 16:51:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XwbUaMsnIi/+j1MLmxCKHyQWHlYynFW0BKmo0OTuX5s=;
        b=FwAUZlS4hzg3c8KZDnvwzymSR84adolOfPMP5NUW36/iovh41wd4megpJaelA5ttr7
         jfkOeVlJVUQPvajgU2jj6ZmXeRj9BqyJT2LowyM0u0Htf+hlFtKxbxBG3UEhQrlz73gI
         FUMvD6/RXLgxlh5CyTrN4rwCxF94lZ0xHBGty08wvVdssIXY+tpkKPGXNpO3zkWI4A/S
         Uxnti0UXCcMBKZmIvmY10ft9j93C9rxlFx7nD0A1UN2kvck30nR0QmuV9THgR8fEIM69
         Fk90++QENNUl8N3ArzE8zILSKbWPJ3PsggT6GGl67HCIPzETdU8cGPfEOO/VW2oA0KI6
         vMjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=XwbUaMsnIi/+j1MLmxCKHyQWHlYynFW0BKmo0OTuX5s=;
        b=hkbHB96gTtP+YlhNfBfryeDMNJXXhqJ6LRtsF5LVPdBh6Xlti98f+1yN7pQZnwtL10
         21/yLLJczBX+t95Ojt8DI8eAkr/fitO1JD5giimhG3HMK9K3nf3EBbhVkxoK26L7XeY7
         Ps2g3N9RBqhbV3iMnKGY2PzHt3gswCvrLF9LAvDjJ1eH2+LK3iGxlXbPgh3mGqmEu+he
         UwXI9AATM4rPbBl68D8LcZsuq/ohzMe8hIn//vPQJDDokaP00M13yzoJXgi93Cperq60
         RWtNzv2sgCLWI51tl+cf+JcdpFulI2s+KTIq0G+nlodejXzKYcZ+lXhRw4ofNJVTFRQY
         lBxQ==
X-Gm-Message-State: AOAM532eJusRvii5fgnMfBnSgKhMmrKfw8tZY/3IungAILCAa3GCNQyM
        +YKLIQ33RLxPQMoBnoBfE3gCZ66FJH8=
X-Google-Smtp-Source: ABdhPJwSv7zh2nLZ6r2dPg6XrrMV33BuQqv8X7F1dEtwJ/ERcv+RB/Af6nomiQVXijOd6ohq7q2TWQ==
X-Received: by 2002:a05:6870:32d5:b0:fb:7406:90a8 with SMTP id r21-20020a05687032d500b000fb740690a8mr274266oac.67.1654732277730;
        Wed, 08 Jun 2022 16:51:17 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id d2-20020a9d72c2000000b006060322124csm11658453otk.28.2022.06.08.16.51.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jun 2022 16:51:17 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 8 Jun 2022 16:51:16 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.15 000/667] 5.15.46-rc1 review
Message-ID: <20220608235116.GB3924366@roeck-us.net>
References: <20220607164934.766888869@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
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

On Tue, Jun 07, 2022 at 06:54:25PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.46 release.
> There are 667 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 09 Jun 2022 16:48:02 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 488 pass: 488 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
