Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A965050EBDA
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 00:22:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237948AbiDYWZL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Apr 2022 18:25:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343642AbiDYWAf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Apr 2022 18:00:35 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 741503298E
        for <stable@vger.kernel.org>; Mon, 25 Apr 2022 14:57:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=UfxzwpuCC/FYr61itzSJUXDsUHCX+ANGeJSRWtJ/1o4=; b=o0OeaQrvzXGJU78oWumajNaN1p
        sGnnfE4pYcQoNa4Z1f/cyQ0QKFs1D+fw3NXDHTPeLB3RZwPE9sEzUaT9TUYkj03IYqCKzKboFsgTN
        ILPcM7iPc6zjPGYfWNn4QJWN1X9tPKBkRGralsXprqxVj7o413gF0VPtbNzq4D7sJMJGHw8w78s+d
        mQjbMgJrJ5FKRfLDd1eFhq7HAdbL2YazMDfadaC0NvD4TmwdtvGQ7LmaKJ+6Z4Wd17o3DYerwkTkh
        l+SyLkEp5aWI5RVFUlsI3WPJo2G/uvuG/7cTeKM8VSBXsD3B3/jhpESGDvbG3WUQx19Juw/wTpNku
        2+TuPs4A==;
Received: from [2601:1c0:6280:3f0::aa0b]
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nj6hu-0093Rh-Ur; Mon, 25 Apr 2022 21:57:23 +0000
Message-ID: <ca572e57-56ec-c738-b56c-4da2c4898e71@infradead.org>
Date:   Mon, 25 Apr 2022 14:57:18 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH] Revert "net: micrel: fix KS8851_MLL Kconfig"
Content-Language: en-US
To:     Marek Vasut <marex@denx.de>, stable@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
References: <20220425214859.256650-1-marex@denx.de>
From:   Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20220425214859.256650-1-marex@denx.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 4/25/22 14:48, Marek Vasut wrote:
> This reverts commit 1ff5359afa5ec0dd09fe76183dc4fa24b50e4125.
> 
> The upstream commit c3efcedd272a ("net: micrel: fix KS8851_MLL Kconfig")
> depends on e5f31552674e ("ethernet: fix PTP_1588_CLOCK dependencies")
> which is not part of Linux 5.10.y . Revert the aforementioned commit to
> prevent breakage in 5.10.y .
> 
> Signed-off-by: Marek Vasut <marex@denx.de>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: Randy Dunlap <rdunlap@infradead.org>
> Cc: Sasha Levin <sashal@kernel.org>
> Cc: <stable@vger.kernel.org> # 5.10.x

Ack. Thanks.

> ---
>  drivers/net/ethernet/micrel/Kconfig | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/micrel/Kconfig b/drivers/net/ethernet/micrel/Kconfig
> index 9ceb7e1fb169..42bc014136fe 100644
> --- a/drivers/net/ethernet/micrel/Kconfig
> +++ b/drivers/net/ethernet/micrel/Kconfig
> @@ -37,7 +37,6 @@ config KS8851
>  config KS8851_MLL
>  	tristate "Micrel KS8851 MLL"
>  	depends on HAS_IOMEM
> -	depends on PTP_1588_CLOCK_OPTIONAL
>  	select MII
>  	select CRC32
>  	select EEPROM_93CX6

-- 
~Randy
