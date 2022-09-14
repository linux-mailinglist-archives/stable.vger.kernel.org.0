Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EE395B8677
	for <lists+stable@lfdr.de>; Wed, 14 Sep 2022 12:36:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229929AbiINKgl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Sep 2022 06:36:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229915AbiINKgj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Sep 2022 06:36:39 -0400
X-Greylist: delayed 1223 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 14 Sep 2022 03:36:38 PDT
Received: from gateway23.websitewelcome.com (gateway23.websitewelcome.com [192.185.48.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD94953D01
        for <stable@vger.kernel.org>; Wed, 14 Sep 2022 03:36:38 -0700 (PDT)
Received: from cm14.websitewelcome.com (cm14.websitewelcome.com [100.42.49.7])
        by gateway23.websitewelcome.com (Postfix) with ESMTP id 7E7DC2FAE
        for <stable@vger.kernel.org>; Wed, 14 Sep 2022 05:16:15 -0500 (CDT)
Received: from 162-215-252-169.unifiedlayer.com ([208.91.199.152])
        by cmsmtp with SMTP
        id YPRGovMB2CE4UYPRHon5D5; Wed, 14 Sep 2022 05:16:15 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=roeck-us.net; s=default; h=In-Reply-To:Content-Type:MIME-Version:References
        :Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding
        :Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Ul6eVI37l13eLM15PAoxmkjLJvaiHfKifA3ANt/jytc=; b=yi8CDq3WzuP0JN3sC/xEQbLdhf
        W5drxDnVRsCGWSopxdVjfxkA2Dti42jmLxePmHXxmCrD73DaISl+FQgyXxiLYWyv8yp5BQPYn9v9/
        Qwm1ecs/5ASLAxN+NiH8YRa4D9M0hFFrdJ+H8mumshC1HZ+WI87JBFKwhqHt3zQNc5oEZ+Vk3Zk8+
        ah674OXIai/OIA3dHusaUF/8MwswerqdADbzDsp3RGTHHqoypUp/6RHpQGG02crd7Lpr+nZFFUxv8
        W70XgJw/XKANujc/tMGn8UcQs2EueRM02x5T6uv4EM2Xs3w/a1WBT7QNm1LppsJG+MYjtvwLxfCCi
        I66aRkuQ==;
Received: from 108-223-40-66.lightspeed.sntcca.sbcglobal.net ([108.223.40.66]:39700 helo=localhost)
        by bh-25.webhostbox.net with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <linux@roeck-us.net>)
        id 1oYPRG-003xUn-8u;
        Wed, 14 Sep 2022 10:16:14 +0000
Date:   Wed, 14 Sep 2022 03:16:08 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Brian Norris <briannorris@chromium.org>
Cc:     Ulf Hansson <ulf.hansson@linaro.org>, stable@vger.kernel.org,
        Arindam Nath <arindam.nath@amd.com>,
        Chris Ball <cjb@laptop.org>,
        Philip Rakity <prakity@marvell.com>,
        Zhangfei Gao <zhangfei.gao@marvell.com>,
        linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org
Subject: Re: [PATCH] mmd: core: Terminate infinite loop in SD-UHS voltage
 switch
Message-ID: <20220914101608.GA1325043@roeck-us.net>
References: <20220914014010.2076169-1-briannorris@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220914014010.2076169-1-briannorris@chromium.org>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-BWhitelist: no
X-Source-IP: 108.223.40.66
X-Source-L: No
X-Exim-ID: 1oYPRG-003xUn-8u
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 108-223-40-66.lightspeed.sntcca.sbcglobal.net (localhost) [108.223.40.66]:39700
X-Source-Auth: guenter@roeck-us.net
X-Email-Count: 16
X-Source-Cap: cm9lY2s7YWN0aXZzdG07YmgtMjUud2ViaG9zdGJveC5uZXQ=
X-Local-Domain: yes
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 13, 2022 at 06:40:10PM -0700, Brian Norris wrote:
> This loop intends to retry a max of 10 times, with some implicit
> termination based on the SD_{R,}OCR_S18A bit. Unfortunately, the
> termination condition depends on the value reported by the SD card
> (*rocr), which may or may not correctly reflect what we asked it to do.
> 
> Needless to say, it's not wise to rely on the card doing what we expect;
> we should at least terminate the loop regardless. So, check both the
> input and output values, so we ensure we will terminate regardless of
> the SD card behavior.
> 
> Note that SDIO learned a similar retry loop in commit 0797e5f1453b
> ("mmc: core: Fixup signal voltage switch"), but that used the 'ocr'
> result, and so the current pre-terminating condition looks like:
> 
>     rocr & ocr & R4_18V_PRESENT
> 
> (i.e., it doesn't have the same bug.)
> 
> This addresses a number of crash reports seen on ChromeOS that look
> like the following:
> 
>     ... // lots of repeated: ...
>     <4>[13142.846061] mmc1: Skipping voltage switch
>     <4>[13143.406087] mmc1: Skipping voltage switch
>     <4>[13143.964724] mmc1: Skipping voltage switch
>     <4>[13144.526089] mmc1: Skipping voltage switch
>     <4>[13145.086088] mmc1: Skipping voltage switch
>     <4>[13145.645941] mmc1: Skipping voltage switch
>     <3>[13146.153969] INFO: task halt:30352 blocked for more than 122 seconds.
>     ...
> 
> Fixes: f2119df6b764 mmc: sd: add support for signal voltage switch procedure
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Brian Norris <briannorris@chromium.org>

Reviewed-by: Guenter Roeck <linux@roeck-us.net>

> ---
> 
>  drivers/mmc/core/sd.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/mmc/core/sd.c b/drivers/mmc/core/sd.c
> index 06aa62ce0ed1..3662bf5320ce 100644
> --- a/drivers/mmc/core/sd.c
> +++ b/drivers/mmc/core/sd.c
> @@ -870,7 +870,8 @@ int mmc_sd_get_cid(struct mmc_host *host, u32 ocr, u32 *cid, u32 *rocr)
>  	 * the CCS bit is set as well. We deliberately deviate from the spec in
>  	 * regards to this, which allows UHS-I to be supported for SDSC cards.
>  	 */
> -	if (!mmc_host_is_spi(host) && rocr && (*rocr & SD_ROCR_S18A)) {
> +	if (!mmc_host_is_spi(host) && (ocr & SD_OCR_S18R) &&
> +	    rocr && (*rocr & SD_ROCR_S18A)) {
>  		err = mmc_set_uhs_voltage(host, pocr);
>  		if (err == -EAGAIN) {
>  			retries--;
> -- 
> 2.37.2.789.g6183377224-goog
> 
