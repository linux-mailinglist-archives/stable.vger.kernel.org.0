Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAB0A568070
	for <lists+stable@lfdr.de>; Wed,  6 Jul 2022 09:48:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230027AbiGFHrE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Jul 2022 03:47:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbiGFHrE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Jul 2022 03:47:04 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAAA922BE1;
        Wed,  6 Jul 2022 00:47:01 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id 128so13627926pfv.12;
        Wed, 06 Jul 2022 00:47:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=n2THw/2ch+7BfHEoDU2EE1L3hnFG9rBbIWEZ3J6rMMM=;
        b=ljhAEM8a/4ak2si07DvB8Jb3UHMoDso/Rm0fhiZlhQJmuB5oDu0VGrMs2k8HhN8tPq
         H471uaUd9s+hdzRHWyGzrMBiOL8ZSLJaQu9mu+AtPWFasvuryVgdc6yk2Nyf5sG4EzHF
         ZfGZRDA1nMulstdi70uDIa2xjvG/tdwCncmTYIx/42Hq60VA2cMbIiG4RV7/4c/UO+VO
         jc48DbXlFDgEpQ94j1jyZRTVEuIIXVUUj8yKnL5eO7p1LoQmcx6XjStYI2tvkBCWgL88
         ViyWcQi4PPN0L2Q7FZXY+3HKLeRATvtbFy2sTkDtku23cmIuDszcPBcWTfe6UvCwY5xY
         DhEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=n2THw/2ch+7BfHEoDU2EE1L3hnFG9rBbIWEZ3J6rMMM=;
        b=F0jGK4pqwnsd0oRRk2sOTnTxsz+ob/UoDmhR/uE5cjXsGh8mttp0T6Lq6kcu1NBSON
         1V6Dmj8SgYCw4hjHE36rRDzLWE7rGIAfaA2/fhIM4BO4Q4k1m8kUfS/IjYWixG76Z6zZ
         KogytgFece6s2IpV3daQKchRNO1Iwz6B3nloyJSY51oMUkBJxetnWAjbGQJ/7EDew199
         WGa4U4hxaqiAeimQ/Y/eTofjfUXOuFpb4+RaKlpHYpA9ECg73/+XUALijMVgX5Pb0lvA
         IS2Y+gpJ+uPXOG9ysOmsyZ4ZEBNI4RJ5r5iRe0pgEPtCUnvsoUWT2u5lvRM93DjCKjtY
         jCRg==
X-Gm-Message-State: AJIora8BQcvWWHoI+B2hgDjgJieU5qmTf0O47ysTZKnK12vHEmZQolg8
        ikecKvAN1wR9XsWL30/bFXw=
X-Google-Smtp-Source: AGRyM1sPt73d/PnYTpHPFp0GNH1m7ee1PvmynEuFMLTTMTxGHp6XOdPcWpYbaOGIAmLgzM2rWtY+Ig==
X-Received: by 2002:a63:5346:0:b0:412:9544:1ff2 with SMTP id t6-20020a635346000000b0041295441ff2mr1826529pgl.504.1657093621344;
        Wed, 06 Jul 2022 00:47:01 -0700 (PDT)
Received: from debian.me (subs02-180-214-232-23.three.co.id. [180.214.232.23])
        by smtp.gmail.com with ESMTPSA id l8-20020a17090a384800b001ecd954f3b6sm14132863pjf.7.2022.07.06.00.47.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jul 2022 00:47:00 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id 6263B1039C1; Wed,  6 Jul 2022 14:46:57 +0700 (WIB)
Date:   Wed, 6 Jul 2022 14:46:57 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.15 00/98] 5.15.53-rc1 review
Message-ID: <YsU98eRZWPPg5PBt@debian.me>
References: <20220705115617.568350164@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220705115617.568350164@linuxfoundation.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 05, 2022 at 01:57:18PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.53 release.
> There are 98 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0)
and powerpc (ps3_defconfig, GCC 12.1.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

-- 
An old man doll... just what I always wanted! - Clara
