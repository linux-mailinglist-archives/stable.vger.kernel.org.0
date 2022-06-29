Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DACF955FDD4
	for <lists+stable@lfdr.de>; Wed, 29 Jun 2022 12:54:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233417AbiF2KxH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jun 2022 06:53:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233437AbiF2Kw7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Jun 2022 06:52:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA0C03E5D0;
        Wed, 29 Jun 2022 03:52:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6746E615ED;
        Wed, 29 Jun 2022 10:52:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89FCFC34114;
        Wed, 29 Jun 2022 10:52:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656499976;
        bh=sg27Qejbc/ohUawR6PaI/MniA6EncYUbuLuyuLXhuF8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=H0dLfikeIz5rLcYUFW94uZ4KMkchhrg9MFa4hRi2hyXUpKS3R1iZJWSHB8mCpOEej
         CKzooaLKtgCtXPPdgIHqUGBz1lT3OTOn9eI4+ORnAVYgrTOzwJn5Ll3rcV6y6TUSRG
         Uva/NUDQgocya4TKi+a34O2Hd7DpSymkXQaawe2w=
Date:   Wed, 29 Jun 2022 12:52:52 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Bagas Sanjaya <bagasdotme@gmail.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com, Larry Finger <Larry.Finger@lwfinger.net>,
        Phillip Potter <phil@philpotter.co.uk>,
        linux-staging@lists.linux.dev
Subject: Re: [PATCH 5.15 000/135] 5.15.51-rc1 review
Message-ID: <YrwvBCFAVibGVdav@kroah.com>
References: <20220627111938.151743692@linuxfoundation.org>
 <Yrp3q1gpvfUm8QIP@debian.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yrp3q1gpvfUm8QIP@debian.me>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 28, 2022 at 10:38:19AM +0700, Bagas Sanjaya wrote:
> On Mon, Jun 27, 2022 at 01:20:07PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.15.51 release.
> > There are 135 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> 
> Successfully cross-compiled for arm (multi_v7_defconfig, GCC 12.1.0,
> armv7 with neon FPU) and arm64 (bcm2711_defconfig, GCC 12.1.0).
> 
> But I see a warning on arm64 build:
> 
>   CC [M]  drivers/staging/r8188eu/core/rtw_br_ext.o
>   CC [M]  net/batman-adv/tvlv.o
> In function '__nat25_add_pppoe_tag',
>     inlined from 'nat25_db_handle' at drivers/staging/r8188eu/core/rtw_br_ext.c:520:11:
> drivers/staging/r8188eu/core/rtw_br_ext.c:83:9: warning: 'memcpy' reading between 2052 and 9220 bytes from a region of size 40 [-Wstringop-overread]
>    83 |         memcpy((unsigned char *)ph->tag, tag, data_len);
>       |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> drivers/staging/r8188eu/core/rtw_br_ext.c: In function 'nat25_db_handle':
> drivers/staging/r8188eu/core/rtw_br_ext.c:489:63: note: source object 'tag_buf' of size 40
>   489 |                                                 unsigned char tag_buf[40];
>       |                                                               ^~~~~~~
> 
> Introduced by commit 15865124feed88 ("staging: r8188eu: introduce new core dir
> for RTL8188eu driver").

That is due to gcc-12 stuff.

thanks for testing.

thanks,

greg k-h
