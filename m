Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9B2E2F1A2C
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 16:53:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387525AbhAKPxC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 10:53:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733284AbhAKPxB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jan 2021 10:53:01 -0500
Received: from mail.kapsi.fi (mail.kapsi.fi [IPv6:2001:67c:1be8::25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 345C6C061786;
        Mon, 11 Jan 2021 07:52:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=kapsi.fi;
         s=20161220; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=NqDVkTYbg8Kl34pjG1mAKbMpd/CjudU1qP8KEuOj/+Y=; b=T1FBeHz3xwT+m9t5JqWfKv+TZf
        YORCE9GpHgX/hYQtv8n1+LlBF5TE0BUgA0k9zO1WAyenVmN2BM8P+/2LUtJs2sXwwavfliXNsKBDZ
        9b1Ya0IrAm61d7L2wx2TY/jd8Ca1l2qqP0KUGubyJnTsrB4QCq5rmgnEIHLic7IG5hU0wjIVAUGWd
        DcnfU9ZF6Cu6ctvvHTW/8qRPAvjThl5dN5oN0EJ4DVk260Q+Kg1ESYCk034x+APiQha9q1GFcn698
        46+3jTp+4wEzsRFJDT7+XzaDYbxq+epZNefRA0uYU8o0y6BCJ3cQLOACEV59wc+3qWL4x4MLhW9QP
        /7rc9TxQ==;
Received: from dsl-hkibng22-54f986-236.dhcp.inet.fi ([84.249.134.236] helo=[192.168.1.10])
        by mail.kapsi.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <cyndis@kapsi.fi>)
        id 1kyzUR-0004Sw-Np; Mon, 11 Jan 2021 17:52:19 +0200
Subject: Re: [PATCH] i2c: tegra: Wait for config load atomically while in ISR
To:     Dmitry Osipenko <digetx@gmail.com>,
        Mikko Perttunen <mperttunen@nvidia.com>, ldewangan@nvidia.com,
        thierry.reding@gmail.com, jonathanh@nvidia.com, wsa@kernel.org
Cc:     linux-i2c@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20210111135547.3613092-1-mperttunen@nvidia.com>
 <b7f69fb9-2960-f994-51d8-afd86af26bba@gmail.com>
From:   Mikko Perttunen <cyndis@kapsi.fi>
Message-ID: <a180bd42-2cd9-87b6-1848-61058f198d63@kapsi.fi>
Date:   Mon, 11 Jan 2021 17:52:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <b7f69fb9-2960-f994-51d8-afd86af26bba@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 84.249.134.236
X-SA-Exim-Mail-From: cyndis@kapsi.fi
X-SA-Exim-Scanned: No (on mail.kapsi.fi); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/11/21 5:14 PM, Dmitry Osipenko wrote:
> 11.01.2021 16:55, Mikko Perttunen пишет:
>> Upon a communication error, the interrupt handler can call
>> tegra_i2c_disable_packet_mode. This causes a sleeping poll to happen
>> unless the current transaction was marked atomic. Since
>> tegra_i2c_disable_packet_mode is only called from the interrupt path,
>> make it use atomic waiting always.
>>
>> Fixes: ede2299f7101 ("i2c: tegra: Support atomic transfers")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
>> ---
>> This fixes constant spew for me while HDMI is connected to a
>> powered off television.
>>
>>   drivers/i2c/busses/i2c-tegra.c | 16 ++++++++--------
>>   1 file changed, 8 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/i2c/busses/i2c-tegra.c b/drivers/i2c/busses/i2c-tegra.c
>> index 6f08c0c3238d..4a7ff1840565 100644
>> --- a/drivers/i2c/busses/i2c-tegra.c
>> +++ b/drivers/i2c/busses/i2c-tegra.c
>> @@ -528,12 +528,12 @@ static void tegra_i2c_vi_init(struct tegra_i2c_dev *i2c_dev)
>>   
>>   static int tegra_i2c_poll_register(struct tegra_i2c_dev *i2c_dev,
>>   				   u32 reg, u32 mask, u32 delay_us,
>> -				   u32 timeout_us)
>> +				   u32 timeout_us, bool force_atomic)
>>   {
>>   	void __iomem *addr = i2c_dev->base + tegra_i2c_reg_addr(i2c_dev, reg);
>>   	u32 val;
>>   
>> -	if (!i2c_dev->atomic_mode)
>> +	if (!i2c_dev->atomic_mode && !force_atomic)
>>   		return readl_relaxed_poll_timeout(addr, val, !(val & mask),
>>   						  delay_us, timeout_us);
>>   
>> @@ -560,7 +560,7 @@ static int tegra_i2c_flush_fifos(struct tegra_i2c_dev *i2c_dev)
>>   	val |= mask;
>>   	i2c_writel(i2c_dev, val, offset);
>>   
>> -	err = tegra_i2c_poll_register(i2c_dev, offset, mask, 1000, 1000000);
>> +	err = tegra_i2c_poll_register(i2c_dev, offset, mask, 1000, 1000000, false);
>>   	if (err) {
>>   		dev_err(i2c_dev->dev, "failed to flush FIFO\n");
>>   		return err;
>> @@ -569,7 +569,7 @@ static int tegra_i2c_flush_fifos(struct tegra_i2c_dev *i2c_dev)
>>   	return 0;
>>   }
>>   
>> -static int tegra_i2c_wait_for_config_load(struct tegra_i2c_dev *i2c_dev)
>> +static int tegra_i2c_wait_for_config_load(struct tegra_i2c_dev *i2c_dev, bool force_atomic)
>>   {
>>   	int err;
>>   
>> @@ -579,7 +579,7 @@ static int tegra_i2c_wait_for_config_load(struct tegra_i2c_dev *i2c_dev)
>>   	i2c_writel(i2c_dev, I2C_MSTR_CONFIG_LOAD, I2C_CONFIG_LOAD);
>>   
>>   	err = tegra_i2c_poll_register(i2c_dev, I2C_CONFIG_LOAD, 0xffffffff,
>> -				      1000, I2C_CONFIG_LOAD_TIMEOUT);
>> +				      1000, I2C_CONFIG_LOAD_TIMEOUT, force_atomic);
>>   	if (err) {
>>   		dev_err(i2c_dev->dev, "failed to load config\n");
>>   		return err;
>> @@ -684,7 +684,7 @@ static int tegra_i2c_init(struct tegra_i2c_dev *i2c_dev)
>>   	if (i2c_dev->multimaster_mode && i2c_dev->hw->has_slcg_override_reg)
>>   		i2c_writel(i2c_dev, I2C_MST_CORE_CLKEN_OVR, I2C_CLKEN_OVERRIDE);
>>   
>> -	err = tegra_i2c_wait_for_config_load(i2c_dev);
>> +	err = tegra_i2c_wait_for_config_load(i2c_dev, false);
>>   	if (err)
>>   		return err;
>>   
>> @@ -707,7 +707,7 @@ static int tegra_i2c_disable_packet_mode(struct tegra_i2c_dev *i2c_dev)
>>   	if (cnfg & I2C_CNFG_PACKET_MODE_EN)
>>   		i2c_writel(i2c_dev, cnfg & ~I2C_CNFG_PACKET_MODE_EN, I2C_CNFG);
>>   
>> -	return tegra_i2c_wait_for_config_load(i2c_dev);
>> +	return tegra_i2c_wait_for_config_load(i2c_dev, true);
>>   }
>>   
>>   static int tegra_i2c_empty_rx_fifo(struct tegra_i2c_dev *i2c_dev)
>> @@ -1090,7 +1090,7 @@ static int tegra_i2c_issue_bus_clear(struct i2c_adapter *adap)
>>   	      I2C_BC_TERMINATE;
>>   	i2c_writel(i2c_dev, val, I2C_BUS_CLEAR_CNFG);
>>   
>> -	err = tegra_i2c_wait_for_config_load(i2c_dev);
>> +	err = tegra_i2c_wait_for_config_load(i2c_dev, false);
>>   	if (err)
>>   		return err;
>>   
>>
> 
> What about a simpler variant:
> 
> diff --git a/drivers/i2c/busses/i2c-tegra.c b/drivers/i2c/busses/i2c-tegra.c
> index 6f08c0c3238d..0727383f4940 100644
> --- a/drivers/i2c/busses/i2c-tegra.c
> +++ b/drivers/i2c/busses/i2c-tegra.c
> @@ -533,7 +533,7 @@ static int tegra_i2c_poll_register(struct
> tegra_i2c_dev *i2c_dev,
>   	void __iomem *addr = i2c_dev->base + tegra_i2c_reg_addr(i2c_dev, reg);
>   	u32 val;
> 
> -	if (!i2c_dev->atomic_mode)
> +	if (!i2c_dev->atomic_mode && !in_irq())
>   		return readl_relaxed_poll_timeout(addr, val, !(val & mask),
>   						  delay_us, timeout_us);
> 

Yep, I'll post a v2 with that.

Mikko
