Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F7405710CE
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 05:26:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229644AbiGLD0r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 23:26:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbiGLD0q (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 23:26:46 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A576AD105;
        Mon, 11 Jul 2022 20:26:45 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id p9so6470462pjd.3;
        Mon, 11 Jul 2022 20:26:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KvkC/gZz+2AV2TMT+syl3iyrj/8sxmsFKdYQoStSCVY=;
        b=nlS16xW4UTzlRvXr/WSoHgiYhiP02bGBeHhncAFX7I4d8NLtHl3EtZtZpCQwlzDCAG
         HhGn6JfzZaHBJTFS6RLF23SMhdWknYJW7bQrc4YZU8/jQBDGNDq/f6UWR72arywWVrvP
         DRd2IqKhL6YVnY/tL+io4NAUgBAsqdXqJ+VmBO+YLbNWaIUWm10kNySk4EVXfwShPzx4
         2YE/L3I1+8a5c33/1g+msYJBRtH8I/In+psCrK5rXUzIRge2q7m7ljmGRkKZZGIr6CqH
         00ZJ5ksuzFiFH/GBKk2THrsAJkUhjxnXKe4rydT1bKEwz76ReBZTjKRJW+xHmyB3xEmV
         q5BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KvkC/gZz+2AV2TMT+syl3iyrj/8sxmsFKdYQoStSCVY=;
        b=vFnUhOokjz9niqHOIzQyzOvPXDIXCLteoHzcAObbBPkc47okD2B9iXGoOCsc7/3fIB
         8nGNvAOw0DRQmHMscc+aoZrK2UsRx5HvrXFIJ5djLdXWof22G5amtwFQ8fs35YvUPl2Y
         delUPUm1n/uO2PmIqsVZGAixRXpXY47B1ZirpBW8mP61B8fu5wTuGg9cIDgP8QcC5DYB
         pvN6hylERrJfSYf/1DzlSUrQRC6a8D9vwo+ahhw2Pz51UQcEywr7sHj9GBbHsOlvruWF
         WZ2DvmGNHTI1o6l1YGuKknRUJEsEJJqS+dUDGJfkz6JB3694wTa9+4XrqUnaCRXHLgHE
         TbFA==
X-Gm-Message-State: AJIora8V9vogJNJxCd+70s7AttZlJWtZ9GXyga6JJDnLaK43ZEeh9EK2
        4zl35LCaZ/YsOHeM3LM7QTA=
X-Google-Smtp-Source: AGRyM1skxb43beJcqVjxyNxFNJ3riG4Ad/T8YSvCB8I7zZHEuKPAJwIVcW7MhX0U7jq/DIhgD/ILtA==
X-Received: by 2002:a17:902:d4c5:b0:16c:44b7:c8fd with SMTP id o5-20020a170902d4c500b0016c44b7c8fdmr9723374plg.36.1657596405134;
        Mon, 11 Jul 2022 20:26:45 -0700 (PDT)
Received: from debian.me (subs32-116-206-28-33.three.co.id. [116.206.28.33])
        by smtp.gmail.com with ESMTPSA id d124-20020a623682000000b00528d4f647f2sm5697495pfa.91.2022.07.11.20.26.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jul 2022 20:26:44 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id B6AFF103AC2; Tue, 12 Jul 2022 10:26:39 +0700 (WIB)
Date:   Tue, 12 Jul 2022 10:26:38 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.15 000/230] 5.15.54-rc1 review
Message-ID: <Yszp7pzYU4v21j1K@debian.me>
References: <20220711090604.055883544@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220711090604.055883544@linuxfoundation.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 11, 2022 at 11:04:16AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.54 release.
> There are 230 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0).

On powerpc build (ps3_defconfig, GCC 12.1.0), I found errors on gettimeofday
vdso:

  VDSOSYM include/generated/vdso32-offsets.h
  LDS     arch/powerpc/kernel/vdso64/vdso64.lds
  AS      arch/powerpc/kernel/vdso64/sigtramp.o
  AS      arch/powerpc/kernel/vdso64/gettimeofday.o
  AS      arch/powerpc/kernel/vdso64/datapage.o
arch/powerpc/kernel/vdso64/gettimeofday.S: Assembler messages:
arch/powerpc/kernel/vdso64/gettimeofday.S:25: Error: unrecognized opcode: `cvdso_call'
arch/powerpc/kernel/vdso64/gettimeofday.S:36: Error: unrecognized opcode: `cvdso_call'
arch/powerpc/kernel/vdso64/gettimeofday.S:47: Error: unrecognized opcode: `cvdso_call'
arch/powerpc/kernel/vdso64/gettimeofday.S:57: Error: unrecognized opcode: `cvdso_call_time'
make[1]: *** [scripts/Makefile.build:390: arch/powerpc/kernel/vdso64/gettimeofday.o] Error 1

Thanks.

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>
Reported-by: Bagas Sanjaya <bagasdotme@gmail.com>

-- 
An old man doll... just what I always wanted! - Clara
