Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C33722F287E
	for <lists+stable@lfdr.de>; Tue, 12 Jan 2021 07:49:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730595AbhALGtE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jan 2021 01:49:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729891AbhALGtE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jan 2021 01:49:04 -0500
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC2EEC061575;
        Mon, 11 Jan 2021 22:48:23 -0800 (PST)
Received: by mail-lj1-x22f.google.com with SMTP id m13so1611710ljo.11;
        Mon, 11 Jan 2021 22:48:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=y6E8pJAG2xNBc207S+ylj91Gue5AgH8ypGOMKjlMFkg=;
        b=TfqXdSK2nUn8Ilb5i0ApAX3yamw5Gh+PXZ9+051NRsoZ3rZXgAcLS5mZ9hPUP+6cQK
         Qnc38xo6NCOor8W1s4FhxxRwz+gmZm2X6IE9AXSh5zwVbGPnDff7MWfeOZ6Iizji0T0N
         GOjfav5/i3pMne9g0b/77IM/DFGzX+TINJvzAisnAOOwQ60xHpKJN6SqcZ1Dy20A7Jto
         SbweUE40q1aO9ItN0JtpxAqnodAVeRTxjvV0NGRneVtN7LTXNm7xFD1OQodTt9QbGp7Q
         aVLC2CZvoH/tf5tdcI6lE1JB8Kuyxy4c4TLciAHRVtTGFn+9pPprdW4Lw6e2sgcIdiEa
         JyPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=y6E8pJAG2xNBc207S+ylj91Gue5AgH8ypGOMKjlMFkg=;
        b=NHTqkTxAEK8CnJPhUF/vJyWDEs/WwsZCudSjAWVY5oV/5sNBs/nW5Lo0UtTxOymW/h
         rWTZAZAokM0G1z9GP0QMvevNxv5Uwv2JLg1xrkHm7aDlc+imo3pXM2DnXlLHLAMJeyHR
         61QirU/NFlYdrBGPjpzZ/fWCOLC77HKQXZsReqewzQdAe3PkvmYYW3GZX9f6+wh1DFEN
         h2YVmv8P0toHHGyLvw0cVzvoqvN0UPpasPnfo6G/AIyeKTe9Tzi1Ue8wgaWOKmX8BxeH
         4TebwEjTVNDeH0uzEwhaOOZa/OoLQExlJXplNT+i/TS0ZjnkvEtxGXCl+Za7O/wOkiEi
         ngVQ==
X-Gm-Message-State: AOAM53313TgnYP0d9kaS8adgRztXTUrjwQtFbqbNbaMgFC0scOIbA0+f
        z8hxdNOtDuXCVIYNaB6WICRP+Z/9GbU=
X-Google-Smtp-Source: ABdhPJyQQ3QGu8coMULH0iUFbesygnM5VHn9NN8VGXF8Mqd2Lf05odYHvGCEaLFhQ7covX6IIgM2xA==
X-Received: by 2002:a2e:8250:: with SMTP id j16mr1455053ljh.354.1610434102294;
        Mon, 11 Jan 2021 22:48:22 -0800 (PST)
Received: from [192.168.2.145] (109-252-192-57.dynamic.spd-mgts.ru. [109.252.192.57])
        by smtp.googlemail.com with ESMTPSA id s8sm273037lfi.21.2021.01.11.22.48.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Jan 2021 22:48:21 -0800 (PST)
Subject: Re: [PATCH v2] i2c: tegra: Wait for config load atomically while in
 ISR
From:   Dmitry Osipenko <digetx@gmail.com>
To:     Mikko Perttunen <mperttunen@nvidia.com>, ldewangan@nvidia.com,
        thierry.reding@gmail.com, jonathanh@nvidia.com, wsa@kernel.org
Cc:     linux-i2c@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20210111160832.3669873-1-mperttunen@nvidia.com>
 <a3b6944a-7c1e-54bf-664d-0ee6a6de4deb@gmail.com>
Message-ID: <cb37f001-da0d-fcef-dea8-258caf5687fe@gmail.com>
Date:   Tue, 12 Jan 2021 09:48:20 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.2
MIME-Version: 1.0
In-Reply-To: <a3b6944a-7c1e-54bf-664d-0ee6a6de4deb@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

11.01.2021 22:31, Dmitry Osipenko пишет:
> 11.01.2021 19:08, Mikko Perttunen пишет:
>> Upon a communication error, the interrupt handler can call
>> tegra_i2c_disable_packet_mode. This causes a sleeping poll to happen
>> unless the current transaction was marked atomic. Fix this by
>> making the poll happen atomically if we are in an IRQ.
>>
>> This matches the behavior prior to the patch mentioned
>> in the Fixes tag.
>>
>> Fixes: ede2299f7101 ("i2c: tegra: Support atomic transfers")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
>> ---
>> v2:
>> * Use in_irq() instead of passing a flag from the ISR.
>>   Thanks to Dmitry for the suggestion.
>> * Update commit message.
>> ---
>>  drivers/i2c/busses/i2c-tegra.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/i2c/busses/i2c-tegra.c b/drivers/i2c/busses/i2c-tegra.c
>> index 6f08c0c3238d..0727383f4940 100644
>> --- a/drivers/i2c/busses/i2c-tegra.c
>> +++ b/drivers/i2c/busses/i2c-tegra.c
>> @@ -533,7 +533,7 @@ static int tegra_i2c_poll_register(struct tegra_i2c_dev *i2c_dev,
>>  	void __iomem *addr = i2c_dev->base + tegra_i2c_reg_addr(i2c_dev, reg);
>>  	u32 val;
>>  
>> -	if (!i2c_dev->atomic_mode)
>> +	if (!i2c_dev->atomic_mode && !in_irq())
>>  		return readl_relaxed_poll_timeout(addr, val, !(val & mask),
>>  						  delay_us, timeout_us);
>>  
>>
> 
> Reviewed-by: Dmitry Osipenko <digetx@gmail.com>
> 

Perhaps a follow up change could be to use a threaded interrupt context,
I'll type a patch for that.
