Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C86666A053A
	for <lists+stable@lfdr.de>; Thu, 23 Feb 2023 10:51:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234124AbjBWJvN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 04:51:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233354AbjBWJvN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 04:51:13 -0500
Received: from lelv0143.ext.ti.com (lelv0143.ext.ti.com [198.47.23.248])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5668C4E5D7
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 01:51:12 -0800 (PST)
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 31N9p4hq076879;
        Thu, 23 Feb 2023 03:51:04 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1677145864;
        bh=SrnpYfmIC3XWSIwVBE3XtpKushpLdViBNjzy/MLD8eo=;
        h=Date:Subject:To:CC:References:From:In-Reply-To;
        b=sxyVSwm3iSwcsss38eKNlbrctVbt3n83iGq2q31qem3p63qeRahgblb46KhS47qYE
         D4JP2cjDQhKXg42Upg92bSSJYNgpc/093NHuY7MgafzQbWu+yMPWJ1CW3OEdmmMrwy
         V5Fov+pegff89RaxXL5g6s7RGIwJYAz7clIdHVbs=
Received: from DLEE113.ent.ti.com (dlee113.ent.ti.com [157.170.170.24])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 31N9p42c027936
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 23 Feb 2023 03:51:04 -0600
Received: from DLEE111.ent.ti.com (157.170.170.22) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Thu, 23
 Feb 2023 03:51:04 -0600
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE111.ent.ti.com
 (157.170.170.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Thu, 23 Feb 2023 03:51:04 -0600
Received: from [10.24.69.26] (ileaxei01-snat2.itg.ti.com [10.180.69.6])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 31N9p2Po119467;
        Thu, 23 Feb 2023 03:51:02 -0600
Message-ID: <2627513b-3ad4-6ce0-9a8d-aa73528b1a7c@ti.com>
Date:   Thu, 23 Feb 2023 15:21:01 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH] spi: spi-sn-f-ospi: fix duplicate flag while assigning to
 mode_bits
Content-Language: en-US
To:     Mark Brown <broonie@kernel.org>
CC:     Vignesh Raghavendra <vigneshr@ti.com>,
        Pratyush Yadav <ptyadav@amazon.de>,
        David Binderman <dcb314@hotmail.com>, <stable@vger.kernel.org>
References: <20230223094811.923122-1-d-gole@ti.com>
From:   Dhruva Gole <d-gole@ti.com>
In-Reply-To: <20230223094811.923122-1-d-gole@ti.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Forgot to add the correct lists in CC, please ignore this email, I am 
re-sending.

On 23/02/23 15:18, Dhruva Gole wrote:
> Replace the SPI_TX_OCTAL flag that appeared two time with SPI_RX_OCTAL
> in the chain of '|' operators while assigning to mode_bits
> 
> Fixes: 1b74dd64c861 ("spi: Add Socionext F_OSPI SPI flash controller driver")
> 
> Reported-by: David Binderman <dcb314@hotmail.com>
> Link: https://lore.kernel.org/all/DB6P189MB0568F3BE9384315F5C8C1A3E9CA49@DB6P189MB0568.EURP189.PROD.OUTLOOK.COM/
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Dhruva Gole <d-gole@ti.com>
> ---
[...]

Sorry for the spam.

-- 
Thanks and Regards,
Dhruva Gole
