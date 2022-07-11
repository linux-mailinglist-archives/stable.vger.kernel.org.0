Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 739EB56802A
	for <lists+stable@lfdr.de>; Wed,  6 Jul 2022 09:42:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229793AbiGFHmD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Jul 2022 03:42:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbiGFHmC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Jul 2022 03:42:02 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7913D22BD8;
        Wed,  6 Jul 2022 00:42:01 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id e16so876203pfm.11;
        Wed, 06 Jul 2022 00:42:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wZWzia1BOb6TNiQJJmXMx4HPRZk7qpEIvs9xFkYbjpE=;
        b=mzXX7mqjKz9jnzU6PBYyAatdf5SeiWE1maOv6D6fo6gsJoutZO67sKdiPJOGrmj8MI
         +WJ3pDT4iPgrJpBKN7gt+YY6/D34WNBx3cLUPzHewgOqdTALgInWtXJw33sfnzxb7WJB
         2zrC3r2wNwXzGRocjamPtNVNsX+7UZYbdwj4dg2Eia0AnyHi90h0r4O/Fg5vrw27qERF
         Xp1cdEgdl9RvjQXJEU8jivJRK1BcOC19eKL6ZoVEOHo9rnV1Pv/7E7jMBVsBysKRRMC+
         /TpWcGU+RWFmDgqJZhBHY3rCIPOMm1R8WR9whhkjfUwZtvgAm/aWn7Wz7aIE1QAIy9tl
         jYiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wZWzia1BOb6TNiQJJmXMx4HPRZk7qpEIvs9xFkYbjpE=;
        b=2PDX09BnKRZtBcbzpX9Xl0br+gYWhdRngvIctyEbUmk33+MjEq1t2yLlRE1iHvz2Al
         NUADYUIMblyvoPBAJaG8wsP1+XPS4iFKos5EZIBGll2hs3x6v5ZcqcU4ZR7BqfUBEzP8
         XD8QuYZ8TzwtFJ/TN6VF2naAGBfLtgROUEHpGGurIZvjNjVlEHaJEyyrEPVIxlRIn+Kk
         toni8ZWiNKtpHpY8uvV7/eRoAFq2bH0YzNi9BZpkpkHLVdsDOQ4cSo+VcJdHIt1/aCj4
         6lQvlxdaXj5XXLLmwdb99nn/AgByF+Er/N9uE7Iv3Vi9R1lz5SPF20e6r2C4tKTh2a93
         7lTw==
X-Gm-Message-State: AJIora8fJw6f8jCfIszNEmVhBkCErzYqkTLo+L5V3DcnQckcXDCoNB2h
        WR8z8b2iAS2CLrvfbU+P8xI=
X-Google-Smtp-Source: AGRyM1vpYBUWzYN8O5V0ICY9LcXoILUyTMduBx12vLMDTz84Pgm9aNBVmIAtFrkS3kjqdD58XWT7gw==
X-Received: by 2002:a63:8641:0:b0:40d:d04d:1b22 with SMTP id x62-20020a638641000000b0040dd04d1b22mr34179653pgd.418.1657093321006;
        Wed, 06 Jul 2022 00:42:01 -0700 (PDT)
Received: from debian.me (subs02-180-214-232-23.three.co.id. [180.214.232.23])
        by smtp.gmail.com with ESMTPSA id n5-20020a170902d2c500b0015e9f45c1f4sm25039015plc.186.2022.07.06.00.41.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jul 2022 00:42:00 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id CF94710399B; Wed,  6 Jul 2022 14:41:54 +0700 (WIB)
Date:   Wed, 6 Jul 2022 14:41:54 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.18 000/181] 5.18.8-rc1 review
Message-ID: <YsU8whN69oBsWeHD@debian.me>
References: <20220627111944.553492442@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220627111944.553492442@linuxfoundation.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 27, 2022 at 01:19:33PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.18.8 release.
> There are 181 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0)
and powerpc (ps3_defconfig, GCC 12.1.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

-- 
An old man doll... just what I always wanted! - Clara
