Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 928304C2F07
	for <lists+stable@lfdr.de>; Thu, 24 Feb 2022 16:10:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232879AbiBXPKk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Feb 2022 10:10:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231327AbiBXPKk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Feb 2022 10:10:40 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 444BD1E3764;
        Thu, 24 Feb 2022 07:10:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1645715408; x=1677251408;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=xkrAEAx1YKpwvvh2EnCWQXumUqwt7PlcAeQAJoahyvw=;
  b=GyETHluLMkjP/TkhKqdS0CmwSZ2Eu0sO/tQsWSLS1eE6sx96+FG5jVkT
   zcf6NtsqSyhpubEyxBeIy7dXVsEOIl/v5r54f+au2L0t/xiAba4mW7uQ0
   9Z38Ly6qzcICqNb9CQ0cMd4yUIuzXwCCCeEUHHDnkPf6aTF95KdbR8BTm
   0Oha4H/Q/EY1z3nIpDucVtfEoWsuChb+vk8RCMWhdjLmiC76lE2IurayD
   +Pr6xRJTuYmIHJlKSXNp+AU9Vy9rq6hUVc8OEwT0Ob6PnuirxVP5139kh
   +lASqBc+QRb1CIWlOSjt3dy8++STgusVz5fuD9ANzhOIx7388EgYvmqpQ
   A==;
X-IronPort-AV: E=Sophos;i="5.90,134,1643698800"; 
   d="scan'208";a="147156304"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 24 Feb 2022 08:10:07 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Thu, 24 Feb 2022 08:10:06 -0700
Received: from [10.12.73.51] (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Thu, 24 Feb 2022 08:10:04 -0700
Message-ID: <f3f28a3d-b7ec-e91e-1e8d-9d34da76a2a1@microchip.com>
Date:   Thu, 24 Feb 2022 16:10:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v2] ARM: dts: at91: sama5d2: Fix PMERRLOC resource size
Content-Language: en-US
To:     Tudor Ambarus <tudor.ambarus@microchip.com>, <ada@thorsis.com>
CC:     <alexandre.belloni@bootlin.com>, <ludovic.desroches@microchip.com>,
        <robh+dt@kernel.org>, <bbrezillon@kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>
References: <20220111132301.906712-1-tudor.ambarus@microchip.com>
From:   Nicolas Ferre <nicolas.ferre@microchip.com>
Organization: microchip
In-Reply-To: <20220111132301.906712-1-tudor.ambarus@microchip.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,
        T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/01/2022 at 14:23, Tudor Ambarus wrote:
> PMERRLOC resource size was set to 0x100, which resulted in HSMC_ERRLOCx
> register being truncated to offset x = 21, causing error correction to
> fail if more than 22 bit errors and if 24 or 32 bit error correction
> was supported.
> 
> Fixes: d9c41bf30cf8 ("ARM: dts: at91: Declare EBI/NAND controllers")
> Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
> Cc: <stable@vger.kernel.org> # 4.13.x

Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>

Even if it's a fix, as we have this bug for a long time and that we are 
already at rc5 of the stabilization phase, I take it in at91-dt branch 
for 5.18 and not in another "fixes" batch.

Best regards,
   Nicolas

> ---
> v2:
> - update commit description
> - Cc stable@vger.kernel.org
> 
>   arch/arm/boot/dts/sama5d2.dtsi | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm/boot/dts/sama5d2.dtsi b/arch/arm/boot/dts/sama5d2.dtsi
> index 09c741e8ecb8..c700c3b19e4c 100644
> --- a/arch/arm/boot/dts/sama5d2.dtsi
> +++ b/arch/arm/boot/dts/sama5d2.dtsi
> @@ -415,7 +415,7 @@ hsmc: hsmc@f8014000 {
>   				pmecc: ecc-engine@f8014070 {
>   					compatible = "atmel,sama5d2-pmecc";
>   					reg = <0xf8014070 0x490>,
> -					      <0xf8014500 0x100>;
> +					      <0xf8014500 0x200>;
>   				};
>   			};
>   


-- 
Nicolas Ferre
