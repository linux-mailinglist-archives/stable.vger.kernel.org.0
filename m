Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E94A35EDA15
	for <lists+stable@lfdr.de>; Wed, 28 Sep 2022 12:30:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230305AbiI1Kah (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Sep 2022 06:30:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233320AbiI1Kad (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Sep 2022 06:30:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFEEEF2F;
        Wed, 28 Sep 2022 03:30:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 78E3EB82024;
        Wed, 28 Sep 2022 10:30:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35245C433D6;
        Wed, 28 Sep 2022 10:30:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664361030;
        bh=UzGll+k8wBj+Ek0YtUWqd2Ht46Qd8HsBBj7woBZT0JU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lriRxLomhxJEbw/wrLv0ke0UK4s3oUWcxVbIfkRMPPJgozbbJHN31fiYiMQ5rEguj
         XykGCfkNkdlAhUSO3gFICVekG/XhZf4BadVDR5M8xyrU6qJO1n0v5cDggL+7aLEiHC
         BknJQFhzMN0/4yqywDr8UpQdZhREMSSEBAczEIlEL6COPWlE4hmBtzi4J4WlCI6Vt1
         k+s7eW/Itvo0LAKpfYQDrdOvfqmzdW054T1bkAB1yY94JDAqbj+FfRqpmeiTUizFKR
         uKHJ/FUVKMlkHgNOOtUZXYPwh7SmJh+PfmXIm7NPLs7Oy8pVMmUIFt8SwKrjKkG3o1
         jG16SjD1WPHag==
Date:   Wed, 28 Sep 2022 11:30:24 +0100
From:   Lee Jones <lee@kernel.org>
To:     cy_huang <u0084500@gmail.com>
Cc:     matthias.bgg@gmail.com, gene_chen@richtek.com,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        ChiYuan Huang <cy_huang@richtek.com>, stable@vger.kernel.org
Subject: Re: [PATCH] mfd: mt6360: add bound check in regmap read/write
 function
Message-ID: <YzQiQIpwpd8rD2qs@google.com>
References: <1663143973-29254-1-git-send-email-u0084500@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1663143973-29254-1-git-send-email-u0084500@gmail.com>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 14 Sep 2022, cy_huang wrote:

> From: ChiYuan Huang <cy_huang@richtek.com>
> 
> Fix the potential risk for null pointer if bank index is over the maximimum.
> 
> Refer to the discussion list for the experiment result on mt6370.
> https://lore.kernel.org/all/20220914013345.GA5802@cyhuang-hp-elitebook-840-g3.rt/
> If not to check the bound, there is the same issue on mt6360.
> 
> Fixes: 3b0850440a06c (mfd: mt6360: Merge different sub-devices I2C read/write)
> Cc: stable@vger.kernel.org
> Signed-off-by: ChiYuan Huang <cy_huang@richtek.com>
> ---
>  drivers/mfd/mt6360-core.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/mfd/mt6360-core.c b/drivers/mfd/mt6360-core.c
> index 6eaa677..d375333 100644
> --- a/drivers/mfd/mt6360-core.c
> +++ b/drivers/mfd/mt6360-core.c
> @@ -410,6 +410,9 @@ static int mt6360_regmap_read(void *context, const void *reg, size_t reg_size,
>  	u8 crc;
>  	int ret;
>  
> +	if (bank >= MT6360_SLAVE_MAX)
> +		return -EINVAL;
> +

It's too late to check bank's value here, we have already used it to
index into an array by this point.  Please fix that.

>  	if (bank == MT6360_SLAVE_PMIC || bank == MT6360_SLAVE_LDO) {
>  		crc_needed = true;
>  		ret = mt6360_xlate_pmicldo_addr(&reg_addr, val_size);
> @@ -460,6 +463,9 @@ static int mt6360_regmap_write(void *context, const void *val, size_t val_size)
>  	int write_size = val_size - MT6360_REGMAP_REG_BYTE_SIZE;
>  	int ret;
>  
> +	if (bank >= MT6360_SLAVE_MAX)
> +		return -EINVAL;
> +
>  	if (bank == MT6360_SLAVE_PMIC || bank == MT6360_SLAVE_LDO) {
>  		crc_needed = true;
>  		ret = mt6360_xlate_pmicldo_addr(&reg_addr, val_size - MT6360_REGMAP_REG_BYTE_SIZE);

-- 
Lee Jones [李琼斯]
