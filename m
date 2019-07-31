Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DE387CEAD
	for <lists+stable@lfdr.de>; Wed, 31 Jul 2019 22:34:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729369AbfGaUee (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Jul 2019 16:34:34 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:40902 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726268AbfGaUee (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 31 Jul 2019 16:34:34 -0400
Received: by mail-wm1-f67.google.com with SMTP id v19so61030654wmj.5
        for <stable@vger.kernel.org>; Wed, 31 Jul 2019 13:34:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=sNjn75QqEsg85wGan3nB4LA0i3WJ6eGSKVuqcQX+srY=;
        b=NI0Kuy1l3GxVI/wWvwre4CnktG43y+lpoUivejNC1UTcJJFyhpktxgJiHjuqzVRz38
         NaBeEsN86YYoWWi6me6vBk+HhqGXrAfOb0Hs2K07lfqBgTyBv0eRTSm4YzrHVIFjfXXy
         AY9wr3Kt6aSU2F/JBGXz+/rM0aMF58gliPvtMw+DUm57Za/r/MBBEvZ73TC9MiXCLR2h
         wtji1O7RIykL9ibsi4GNY0TFEZAJJZ17hWlY2XU0vFFNXpJX7ASIn0DTFnTsGNlCSePE
         CvY69OYaTepjbN63YBDsWmds7X9bTA7zT9qXVJhduW7si6CxczBi6jZXc7YEd9+jJYQo
         i29Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sNjn75QqEsg85wGan3nB4LA0i3WJ6eGSKVuqcQX+srY=;
        b=uW+w8pDq82La+4dfGkfC4dmlwxtrUiXwoZLSyBaW1TZkVLEgk5uJsqJ0DqER/jgtsz
         tWkExyeXRBPgNC19skT+gCBfDMVVzhJYjYNh9c+fdAmpwOTt9otIJvtuxa/2Jvo0MSnH
         /LyyaYR0raUu2Nn2QoIGoU1MSrYIx8W1LSeJlly+bZfEtIFViGCqpBsbIv1q5hqmyvvO
         rBhM1Tgnd3kp51BC0E9DxcDHujGCZe4Ay3Dmjf4pCmJXSrmwSMFNb6DnKimOJ9HvDuoL
         N4ujO/aIDZRitAzLYS37jiWmdcy4uUY+eyZQiWnCX/d1+kL9jA8sC1PfMW8GMOUM1YDC
         2PoA==
X-Gm-Message-State: APjAAAW16NcwzbEnpj3kfJi+WWrYP40G6lg4HV1M180QjRDEIrf72aSx
        v+0R0S6v2BaoM7bDX1ONXBnSd5tdfH719A==
X-Google-Smtp-Source: APXvYqzoTj+hTMMfEeacvovM1n9w5WYnocIavsCYJzrS/je3sotLJvIsEqHodnDDiXBzwATG3Rl8Hg==
X-Received: by 2002:a05:600c:c4:: with SMTP id u4mr12423223wmm.96.1564605272896;
        Wed, 31 Jul 2019 13:34:32 -0700 (PDT)
Received: from [192.168.1.6] (19.red-176-86-136.dynamicip.rima-tde.net. [176.86.136.19])
        by smtp.gmail.com with ESMTPSA id c30sm132033252wrb.15.2019.07.31.13.34.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 31 Jul 2019 13:34:32 -0700 (PDT)
Subject: Re: [PATCH 4.19 024/113] tty: serial: msm_serial: avoid system lockup
 condition
To:     Pavel Machek <pavel@denx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
References: <20190729190655.455345569@linuxfoundation.org>
 <20190729190701.631193260@linuxfoundation.org> <20190731190533.GA4630@amd>
From:   Jorge Ramirez <jorge.ramirez-ortiz@linaro.org>
Message-ID: <ca8ee0ab-dac5-28db-cac2-20e188473da6@linaro.org>
Date:   Wed, 31 Jul 2019 22:34:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20190731190533.GA4630@amd>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/31/19 21:05, Pavel Machek wrote:
> Hi!

hi Pavel,

> 
>> [ Upstream commit ba3684f99f1b25d2a30b6956d02d339d7acb9799 ]
>>
>> The function msm_wait_for_xmitr can be taken with interrupts
>> disabled. In order to avoid a potential system lockup - demonstrated
>> under stress testing conditions on SoC QCS404/5 - make sure we wait
>> for a bounded amount of time.
>>
>> Tested on SoC QCS404.
> 
> How long did it take to timeout?
> 
> Because... this is supposed to loop for 0.5 second with interrupts
> disabled, but 500000*udelay(1) is probably going to wait for more than
> that.
> 
> Is 500msec reasonable with interrupts disabled?

considering the original unbounded definition, it is hard to determine
what would be a good amount of time to wait (msm_serial can be used for
BT comms and I am not sure how critical that link might be for different
clients..and I didnt want to create a regression hence the half a second
delay).

yeah, I don't think disabling interrupts for half a second is a good
idea on most systems hence why I chose it that big.

> 
> Should it use something like 5000*udelay(100), instead, as that has
> chance to result in closer-to-500msec wait?

the half a second timeout didnt mean to be accurate but a worst case
scenario...I am not sure accuracy matters.

> 
>> +++ b/drivers/tty/serial/msm_serial.c
>> @@ -383,10 +383,14 @@ static void msm_request_rx_dma(struct msm_port *msm_port, resource_size_t base)
>>  
>>  static inline void msm_wait_for_xmitr(struct uart_port *port)
>>  {
>> +	unsigned int timeout = 500000;
>> +
>>  	while (!(msm_read(port, UART_SR) & UART_SR_TX_EMPTY)) {
>>  		if (msm_read(port, UART_ISR) & UART_ISR_TX_READY)
>>  			break;
>>  		udelay(1);
>> +		if (!timeout--)
>> +			break;
>>  	}
>>  	msm_write(port, UART_CR_CMD_RESET_TX_READY, UART_CR);
>>  }
> 
> Plus, should it do some kind of dev_err() to let users know that
> something went very wrong with their serial?

I did consider this but then I thought that 1/2 second without
interrupts on the core should not go unnoticed. But I might be wrong.

> 
> Thanks,
> 								Pavel
> 

