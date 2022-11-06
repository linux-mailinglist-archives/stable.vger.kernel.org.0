Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AB5B61E522
	for <lists+stable@lfdr.de>; Sun,  6 Nov 2022 18:55:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230419AbiKFRy7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Nov 2022 12:54:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229991AbiKFRy7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Nov 2022 12:54:59 -0500
Received: from relay11.mail.gandi.net (relay11.mail.gandi.net [217.70.178.231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96F6A643F;
        Sun,  6 Nov 2022 09:54:57 -0800 (PST)
Received: (Authenticated sender: alexandre.belloni@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 74AF2100003;
        Sun,  6 Nov 2022 17:54:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1667757295;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Zg7/l4xvuUyfSZ1Lnyt6Mb3nu3U4w2YBOxTgNkugPXk=;
        b=D5sVdGo7REHqDaPlbmq9IOJE4IGSq/6p+Ihyq0bQoVoAF4LSPF9K5DbBCTZJ26R9yDu+s0
        /ewfsA10SVS0t4fYAKXrwP7f4G76Ah6qckJt7Gz65xZBRMYp4jrHOPs0PBTFFpeXoyHadh
        sGyOwdWnedDd8VyEwDcxYqFcSnZIroBbXYNjMxod9I3wBdlO3pmEG4SPXpmVfPtuV31NK5
        z96ZuZlvfe5jtyyKrZIE2P5J7oB9cpGqjwHXtI02sqN6kN/S6YgnOaYlNbAwRvwmiMw9TR
        1CCjduL2q2AE7Oz2Bxrlrz6Y0jdWDNAIP+xhoQGX28eIoePjOCmrlm5XL/cYjg==
Date:   Sun, 6 Nov 2022 18:54:55 +0100
From:   Alexandre Belloni <alexandre.belloni@bootlin.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel test robot <lkp@intel.com>, a.zummo@towertech.it,
        linux-rtc@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 4.9] rtc: cmos: fix build on non-ACPI platforms
Message-ID: <Y2f079jOra55IGgr@mail.local>
References: <20221106170729.1581125-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221106170729.1581125-1-sashal@kernel.org>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello, this doesn't need to be backported unless you also backport
those:
0782b66ed2fb rtc: cmos: Fix wake alarm breakage
4919d3eb2ec0 rtc: cmos: Fix event handler registration ordering issue
6492fed7d8c9 rtc: rtc-cmos: Do not check ACPI_FADT_LOW_POWER_S0


On 06/11/2022 12:07:29-0500, Sasha Levin wrote:
> From: Alexandre Belloni <alexandre.belloni@bootlin.com>
> 
> [ Upstream commit db4e955ae333567dea02822624106c0b96a2f84f ]
> 
> Now that rtc_wake_setup is called outside of cmos_wake_setup, it also need
> to be defined on non-ACPI platforms.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Link: https://lore.kernel.org/r/20221018203512.2532407-1-alexandre.belloni@bootlin.com
> Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/rtc/rtc-cmos.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
> index 1dbd8419df7d..2c3881bdf9bb 100644
> --- a/drivers/rtc/rtc-cmos.c
> +++ b/drivers/rtc/rtc-cmos.c
> @@ -1113,6 +1113,9 @@ static void cmos_check_acpi_rtc_status(struct device *dev,
>  {
>  }
>  
> +static void rtc_wake_setup(struct device *dev)
> +{
> +}
>  #endif
>  
>  #ifdef	CONFIG_PNP
> -- 
> 2.35.1
> 

-- 
Alexandre Belloni, co-owner and COO, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
