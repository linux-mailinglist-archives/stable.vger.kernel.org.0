Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0FC064FEA6
	for <lists+stable@lfdr.de>; Sun, 18 Dec 2022 12:26:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230394AbiLRL0O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Dec 2022 06:26:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230195AbiLRL0O (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Dec 2022 06:26:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44AE9559E;
        Sun, 18 Dec 2022 03:26:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D640860C83;
        Sun, 18 Dec 2022 11:26:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 263FCC433D2;
        Sun, 18 Dec 2022 11:26:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671362772;
        bh=S2W7s2hO1dctHAJf1a1lbMWsT9yzlq7GO6zic55D1js=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EUng88W8gWI7PODPOVYzCxxBEuFSZe9+ius1uJc0nqxig5j05cELMV/5hvf0Yj22U
         yf2JmSjq1gEl2bFtyFYSpBZCfXP37vsWViEOryCaqZxI2MZfZ74k8qqcMTC09MScl/
         khAx12xjxaFQrLAvwdDcc8kiV85/4TP1fDHSdo/JDItmPG71+iwqA8zg/Bj+kvcyYw
         neLqkoicNL8U5nAXJum78bKMGda5Z99H/y/zuzo/XVW3DGj36cGrK3UCpObGjFNbcv
         cjl8kaMMuB8g5KJlzKoOykiEWjHGwRgB9RNO+OHcCN9rCyRO/09Sgbnr6SI7nUbnn9
         Z18QGbaA+D5MQ==
Date:   Sun, 18 Dec 2022 06:26:10 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jianmin Lv <lvjianmin@loongson.cn>,
        Huacai Chen <chenhuacai@loongson.cn>, bhelgaas@google.com,
        rafael@kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 6.0 11/16] ACPI / PCI: fix LPIC IRQ model default
 PCI IRQ polarity
Message-ID: <Y5740vP0CfJ2u+0n@sashalap>
References: <20221217152821.98618-1-sashal@kernel.org>
 <20221217152821.98618-11-sashal@kernel.org>
 <86pmchq4y9.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <86pmchq4y9.wl-maz@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Dec 17, 2022 at 06:07:42PM +0000, Marc Zyngier wrote:
>On Sat, 17 Dec 2022 15:28:14 +0000,
>Sasha Levin <sashal@kernel.org> wrote:
>>
>> From: Jianmin Lv <lvjianmin@loongson.cn>
>>
>> [ Upstream commit d0c50cc4b957b2cf6e43cec4998d212b5abe9220 ]
>>
>> On LoongArch based systems, the PCI devices (e.g. SATA controllers and
>> PCI-to-PCI bridge controllers) in Loongson chipsets output high-level
>> interrupt signal to the interrupt controller they are connected (see
>> Loongson 7A1000 Bridge User Manual v2.00, sec 5.3, "For the bridge chip,
>> AC97 DMA interrupts are edge triggered, gpio interrupts can be configured
>> to be level triggered or edge triggered as needed, and the rest of the
>> interrupts are level triggered and active high."), while the IRQs are
>> active low from the perspective of PCI (see Conventional PCI spec r3.0,
>> sec 2.2.6, "Interrupts on PCI are optional and defined as level sensitive,
>> asserted low."), which means that the interrupt output of PCI devices plugged
>> into PCI-to-PCI bridges of Loongson chipset will be also converted to high-level.
>> So high level triggered type is required to be passed to acpi_register_gsi()
>> when creating mappings for PCI devices.
>>
>> Signed-off-by: Jianmin Lv <lvjianmin@loongson.cn>
>> Reviewed-by: Huacai Chen <chenhuacai@loongson.cn>
>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>> Link: https://lore.kernel.org/r/20221022075955.11726-2-lvjianmin@loongson.cn
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>> ---
>>  drivers/acpi/pci_irq.c | 6 ++++--
>>  1 file changed, 4 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/acpi/pci_irq.c b/drivers/acpi/pci_irq.c
>> index 08e15774fb9f..ff30ceca2203 100644
>> --- a/drivers/acpi/pci_irq.c
>> +++ b/drivers/acpi/pci_irq.c
>> @@ -387,13 +387,15 @@ int acpi_pci_irq_enable(struct pci_dev *dev)
>>  	u8 pin;
>>  	int triggering = ACPI_LEVEL_SENSITIVE;
>>  	/*
>> -	 * On ARM systems with the GIC interrupt model, level interrupts
>> +	 * On ARM systems with the GIC interrupt model, or LoongArch
>> +	 * systems with the LPIC interrupt model, level interrupts
>>  	 * are always polarity high by specification; PCI legacy
>>  	 * IRQs lines are inverted before reaching the interrupt
>>  	 * controller and must therefore be considered active high
>>  	 * as default.
>>  	 */
>> -	int polarity = acpi_irq_model == ACPI_IRQ_MODEL_GIC ?
>> +	int polarity = acpi_irq_model == ACPI_IRQ_MODEL_GIC ||
>> +		       acpi_irq_model == ACPI_IRQ_MODEL_LPIC ?
>>  				      ACPI_ACTIVE_HIGH : ACPI_ACTIVE_LOW;
>>  	char *link = NULL;
>>  	char link_desc[16];
>
>This is pointless on its own too, as it requires plenty of other
>changes, none of which are stable candidates. Please drop this as well
>as the v6.1 backport.

Ack, will do. Thanks!

-- 
Thanks,
Sasha
