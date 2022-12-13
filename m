Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57F1964B05F
	for <lists+stable@lfdr.de>; Tue, 13 Dec 2022 08:24:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233998AbiLMHY5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Dec 2022 02:24:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232336AbiLMHYy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Dec 2022 02:24:54 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3640D193E0
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 23:24:53 -0800 (PST)
Received: from canpemm500007.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4NWVNY53MxzJqRx;
        Tue, 13 Dec 2022 15:23:57 +0800 (CST)
Received: from [10.174.179.215] (10.174.179.215) by
 canpemm500007.china.huawei.com (7.192.104.62) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Tue, 13 Dec 2022 15:24:50 +0800
Subject: Re: [PATCH 5.10 072/106] net: broadcom: Add PTP_1588_CLOCK_OPTIONAL
 dependency for BCMGENET under ARCH_BCM2835
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <stable@vger.kernel.org>
CC:     <patches@lists.linux.dev>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
References: <20221212130924.863767275@linuxfoundation.org>
 <20221212130928.024498741@linuxfoundation.org>
From:   YueHaibing <yuehaibing@huawei.com>
Message-ID: <b478e4a3-aa37-771d-eac9-dc30a9d3a508@huawei.com>
Date:   Tue, 13 Dec 2022 15:24:50 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20221212130928.024498741@linuxfoundation.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [10.174.179.215]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 canpemm500007.china.huawei.com (7.192.104.62)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2022/12/12 21:10, Greg Kroah-Hartman wrote:

> From: YueHaibing <yuehaibing@huawei.com>
>
> [ Upstream commit 421f8663b3a775c32f724f793264097c60028f2e ]
>
> commit 8d820bc9d12b ("net: broadcom: Fix BCMGENET Kconfig") fixes the build
> that contain 99addbe31f55 ("net: broadcom: Select BROADCOM_PHY for BCMGENET")
> and enable BCMGENET=y but PTP_1588_CLOCK_OPTIONAL=m, which otherwise
> leads to a link failure. However this may trigger a runtime failure.
>
> Fix the original issue by propagating the PTP_1588_CLOCK_OPTIONAL dependency
> of BROADCOM_PHY down to BCMGENET.
>
> Fixes: 8d820bc9d12b ("net: broadcom: Fix BCMGENET Kconfig")
> Fixes: 99addbe31f55 ("net: broadcom: Select BROADCOM_PHY for BCMGENET")
> Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
> Suggested-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> Link: https://lore.kernel.org/r/20221125115003.30308-1-yuehaibing@huawei.com
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/net/ethernet/broadcom/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/net/ethernet/broadcom/Kconfig b/drivers/net/ethernet/broadcom/Kconfig
> index 7b79528d6eed..06aaeaadf2e9 100644
> --- a/drivers/net/ethernet/broadcom/Kconfig
> +++ b/drivers/net/ethernet/broadcom/Kconfig
> @@ -63,6 +63,7 @@ config BCM63XX_ENET
>  config BCMGENET
>  	tristate "Broadcom GENET internal MAC support"
>  	depends on HAS_IOMEM
> +	depends on PTP_1588_CLOCK_OPTIONAL || !ARCH_BCM2835

This commit is not needed by 5.10,  see

commit 7be134eb691f6a54b267dbc321530ce0221a76b1
Author: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date:   Fri Nov 25 15:51:06 2022 +0100

    Revert "net: broadcom: Fix BCMGENET Kconfig"

    This reverts commit fbb4e8e6dc7b38b3007354700f03c8ad2d9a2118 which is
    commit 8d820bc9d12b8beebca836cceaf2bbe68216c2f8 upstream.

    It causes runtime failures as reported by Naresh and Arnd writes:

            Greg, please just revert fbb4e8e6dc7b ("net: broadcom: Fix BCMGENET Kconfig")
            in stable/linux-5.10.y: it depends on e5f31552674e ("ethernet: fix
            PTP_1588_CLOCK dependencies"), which we probably don't want backported
            from 5.15 to 5.10.

>  	select MII
>  	select PHYLIB
>  	select FIXED_PHY
