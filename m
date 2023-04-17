Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 748E56E557D
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 01:56:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230012AbjDQX4h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Apr 2023 19:56:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbjDQX4f (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Apr 2023 19:56:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9125A358C;
        Mon, 17 Apr 2023 16:56:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2284262B2E;
        Mon, 17 Apr 2023 23:56:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ED88C433D2;
        Mon, 17 Apr 2023 23:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681775793;
        bh=PGgTtILCYnLtdEs+1dge80PZEeOVNXxB1Mp2goVVWBU=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=U/iWFNH+L08ZbmtVqtvGe3vwYUVDrmI+tTXOJr/M9nBRnClsCRrhcBQtu1pD7Nn9D
         0xjHrND9YWAVXp983k6ublL//L60Aib3NsfXWPDalH1AeyS2wTSeOPKZSyziCG87HP
         g7ekDdlntegrEj3qTUb2WGLA2Wpb+Kmnj+83knvyGinUKzy1YXmDmU3HvZPUEI13U1
         R/g/CgTmloJt0PGKcSmrAgZeKh480w2YxwYcXPIaBzimLzwgeGtiesCaneGtejzRMz
         v3OYBI8SC4y9J/QX6ZFQ0PPbRUCft2BueTrwCUH4ymKPAYvbp01Z7EGzUbSEIiA7VF
         UrnqD1lKXRRXQ==
Message-ID: <473b7647-58ee-9a4c-b910-f22f778a058e@kernel.org>
Date:   Tue, 18 Apr 2023 08:56:29 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v4 09/11] PCI: rockchip: Use u32 variable to access 32-bit
 registers
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
        Caleb Connolly <kc@postmarketos.org>,
        Johan Jonker <jbx6244@gmail.com>,
        Brian Norris <briannorris@chromium.org>,
        Corentin Labbe <clabbe@baylibre.com>,
        Arnaud Ferraris <arnaud.ferraris@collabora.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Judy Hsiao <judyhsiao@chromium.org>,
        Hugh Cole-Baker <sigmaris@gmail.com>,
        linux-pci@vger.kernel.org, linux-rockchip@lists.infradead.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <20230417092631.347976-1-rick.wertenbroek@gmail.com>
 <20230417092631.347976-10-rick.wertenbroek@gmail.com>
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20230417092631.347976-10-rick.wertenbroek@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/17/23 18:26, Rick Wertenbroek wrote:
> Previously u16 variables were used to access 32-bit registers, this
> resulted in not all of the data being read from the registers. Also
> the left shift of more than 16-bits would result in moving data out
> of the variable. Use u32 variables to access 32-bit registers
> 
> Fixes: cf590b078391 ("PCI: rockchip: Add EP driver for Rockchip PCIe controller")
> Cc: stable@vger.kernel.org
> Signed-off-by: Rick Wertenbroek <rick.wertenbroek@gmail.com>
> Tested-by: Damien Le Moal <dlemoal@kernel.org>

Looks good.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>


