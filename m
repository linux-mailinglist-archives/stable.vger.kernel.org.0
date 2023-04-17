Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 837F26E5578
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 01:56:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229682AbjDQX4A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Apr 2023 19:56:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbjDQX4A (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Apr 2023 19:56:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F274358C;
        Mon, 17 Apr 2023 16:55:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 87F7562B2E;
        Mon, 17 Apr 2023 23:55:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AFDFC433EF;
        Mon, 17 Apr 2023 23:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681775758;
        bh=gJP/8hv3/McZQ0JN4pD74vpZuLlroBUE6hcZNQNm6Rw=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=cTZOpC56rkxIJOJESHXfHcrtDXSvQUl/pkgVjvci/W9Rx49/oYeqUbDo0isHbueM0
         QfB63se6WnhN1aNlZOUrpgh+FMRkR+SpZdUcV7Xu60u6C7q+yukgY0LDL0xGi3tWOD
         YEBvdzJxGvw3QeUN92pK/tPT+mXC66LyN3d0xj47n3xAAOQ0E83m15malYkyvx/fbI
         V2WsWdIejrnadlMcFFAa2rfDTy4AT7B7KvUhUZ5O55q1ZA24run91+2OsxfSGTtdcc
         KLFBnIsw5SJl4VJK9K2YQpyDTVDD+KOUCkJgEaD00nuAsf02lvJdiYJ6wnwW2zrA70
         c+/PnZREzB6hQ==
Message-ID: <85495f58-34f5-70b4-7536-ccab49bfa0ca@kernel.org>
Date:   Tue, 18 Apr 2023 08:55:53 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v4 08/11] PCI: rockchip: Fix window mapping and address
 translation for endpoint
Content-Language: en-US
To:     Rick Wertenbroek <rick.wertenbroek@gmail.com>,
        alberto.dassatti@heig-vd.ch
Cc:     xxm@rock-chips.com, stable@vger.kernel.org,
        Shawn Lin <shawn.lin@rock-chips.com>,
        Lorenzo Pieralisi <lpieralisi@kernel.org>,
        =?UTF-8?Q?Krzysztof_Wilczy=c5=84ski?= <kw@linux.com>,
        Rob Herring <robh@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Corentin Labbe <clabbe@baylibre.com>,
        Brian Norris <briannorris@chromium.org>,
        Johan Jonker <jbx6244@gmail.com>,
        Caleb Connolly <kc@postmarketos.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Hugh Cole-Baker <sigmaris@gmail.com>,
        Judy Hsiao <judyhsiao@chromium.org>,
        Arnaud Ferraris <arnaud.ferraris@collabora.com>,
        linux-pci@vger.kernel.org, linux-rockchip@lists.infradead.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <20230417092631.347976-1-rick.wertenbroek@gmail.com>
 <20230417092631.347976-9-rick.wertenbroek@gmail.com>
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20230417092631.347976-9-rick.wertenbroek@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-9.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/17/23 18:26, Rick Wertenbroek wrote:
> The RK3399 PCI endpoint core has 33 windows for PCIe space, now in the
> driver up to 32 fixed size (1M) windows are used and pages are allocated
> and mapped accordingly. The driver first used a single window and allocated
> space inside which caused translation issues (between CPU space and PCI
> space) because a window can only have a single translation at a given
> time, which if multiple pages are allocated inside will cause conflicts.
> Now each window is a single region of 1M which will always guarantee that
> the translation is not in conflict.
> 
> Set the translation register addresses for physical function. As documented
> in the technical reference manual (TRM) section 17.5.5 "PCIe Address
> Translation" and section 17.6.8 "Address Translation Registers Description"
> 
> Fixes: cf590b078391 ("PCI: rockchip: Add EP driver for Rockchip PCIe controller")
> Cc: stable@vger.kernel.org
> Signed-off-by: Rick Wertenbroek <rick.wertenbroek@gmail.com>
> Tested-by: Damien Le Moal <dlemoal@kernel.org>

[...]

> @@ -600,7 +582,8 @@ static int rockchip_pcie_ep_probe(struct platform_device *pdev)
>  
>  	ep->irq_pci_addr = ROCKCHIP_PCIE_EP_DUMMY_IRQ_ADDR;
>  
> -	rockchip_pcie_write(rockchip, PCIE_CLIENT_CONF_ENABLE, PCIE_CLIENT_CONFIG);
> +	rockchip_pcie_write(rockchip, PCIE_CLIENT_CONF_ENABLE,
> +			    PCIE_CLIENT_CONFIG);

This change belongs to patch 3 of the series, not here.

Other than this, looks good. With that fixed,

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>


