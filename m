Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 587CF486856
	for <lists+stable@lfdr.de>; Thu,  6 Jan 2022 18:22:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241662AbiAFRWU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Jan 2022 12:22:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241633AbiAFRWT (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Jan 2022 12:22:19 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D62DC061245
        for <stable@vger.kernel.org>; Thu,  6 Jan 2022 09:22:19 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id k66-20020a1ca145000000b00345fa984108so1574787wme.2
        for <stable@vger.kernel.org>; Thu, 06 Jan 2022 09:22:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=OESxuxOPQ9N0Y5m/wvnZiwker1H5kNKlxxV6vdBK7b8=;
        b=EAjQaRanzOIH/yxM8yb5H8X1SX8vm+zuKMYxwwAgwZx1hyFk+3f0PWM7KvaaeW21AA
         gYaYH2IXqh2BwtKSeVldKPY5EwA4Gjnk2zylL6hj0pwfpg1ajoFx3m4jiA9uvRldFbf6
         avqK3xdqvJNxTyLnn0cIleSW82WNtYOHz0bI0tb1DH0UU+aswltDkw5vUvbVzpgZjnzI
         TXVl/+iP19p4Wo+Nu9MaWxiYf81SUMtg/IMPTNRYQliTBUIiGVr9oVsk/eop0/BLjAb+
         36zG+7Q14T83jh06R31C6CjTOb2h1CyNdu435q1YgkBKVICE1sBMOkk8G5Sbtl1C+pFW
         66/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=OESxuxOPQ9N0Y5m/wvnZiwker1H5kNKlxxV6vdBK7b8=;
        b=7RAhToomCtepY0wQWTKgsHWroHpqJ4y/jx3L+/HXHohF4CYn7PiaJpMxignbU21b5n
         vUiWuF5u69fa+aDgx3dDIOwcr8AwEGNMpLWz6cMt9eznUN13akeiZ1XE/p04eE6uxRO7
         t8Jhy4dNGSgH34wod1EBwcRtaUUtTnL0r0wC6y88hDQlAI5S5AALneSezkDXCuxnDE7v
         4Z8v4jNujsmgSRlC05PaiB7JfJOzP//q5dYxqQ40ARATsef31KYbiQ0yI6TuYwYP4fpP
         pIDbgb1L6Ri6ilBDs5WhFq52gWFTHbUCNJsrnW+0KPxmW/ZQErLK2i1rJhxci+O1ZTs1
         PiNw==
X-Gm-Message-State: AOAM530OZpWXFbPVF7iIIfbMQPk59ra/9v6NUXbHzbSnYJV0pYjYjJ56
        aZhqTBcbzTNi9MYWJ05Na2k3GQ==
X-Google-Smtp-Source: ABdhPJwgw6xq9LNRrVTKmxbfYVyJW7X5FNtSTuOXv28V60cAAk4ifsk4fqTC/QbiKG8pdvGNzTzUKw==
X-Received: by 2002:a1c:f20e:: with SMTP id s14mr7693939wmc.186.1641489738072;
        Thu, 06 Jan 2022 09:22:18 -0800 (PST)
Received: from [192.168.0.162] (188-141-3-169.dynamic.upc.ie. [188.141.3.169])
        by smtp.gmail.com with ESMTPSA id m10sm2261730wms.25.2022.01.06.09.22.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Jan 2022 09:22:17 -0800 (PST)
Message-ID: <edcd752d-37a5-2004-3508-01efcfa571ba@linaro.org>
Date:   Thu, 6 Jan 2022 17:24:27 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.1
Subject: Re: [PATCH v2 1/2] mtd: rawnand: qcom: Fix clock sequencing in
 qcom_nandc_probe()
Content-Language: en-US
To:     Manivannan Sadhasivam <mani@kernel.org>
Cc:     linux-arm-msm@vger.kernel.org, linux-mtd@lists.infradead.org,
        miquel.raynal@bootlin.com, architt@codeaurora.org,
        bbrezillon@kernel.org, absahu@codeaurora.org, baruch@tkos.co.il,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <20220103030316.58301-1-bryan.odonoghue@linaro.org>
 <20220103030316.58301-2-bryan.odonoghue@linaro.org>
 <20220103055152.GA3581@thinkpad>
From:   Bryan O'Donoghue <bryan.odonoghue@linaro.org>
In-Reply-To: <20220103055152.GA3581@thinkpad>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 03/01/2022 05:51, Manivannan Sadhasivam wrote:
> On Mon, Jan 03, 2022 at 03:03:15AM +0000, Bryan O'Donoghue wrote:
>> Interacting with a NAND chip on an IPQ6018 I found that the qcomsmem NAND
>> partition parser was returning -EPROBE_DEFER waiting for the main smem
>> driver to load.
>>
>> This caused the board to reset. Playing about with the probe() function
>> shows that the problem lies in the core clock being switched off before the
>> nandc_unalloc() routine has completed.
>>
>> If we look at how qcom_nandc_remove() tears down allocated resources we see
>> the expected order is
>>
>> qcom_nandc_unalloc(nandc);
>>
>> clk_disable_unprepare(nandc->aon_clk);
>> clk_disable_unprepare(nandc->core_clk);
>>
>> dma_unmap_resource(&pdev->dev, nandc->base_dma, resource_size(res),
>> 		   DMA_BIDIRECTIONAL, 0);
>>
>> Tweaking probe() to both bring up and tear-down in that order removes the
>> reset if we end up deferring elsewhere.
>>
>> Fixes: c76b78d8ec05 ("mtd: nand: Qualcomm NAND controller driver")
>> Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
> 
> Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
> 
> Can you please CC stable list for backporting?
> 
> Thanks,
> Mani
> 

NP.

+ cc stable

FWIW I believe Greg's scripts will pick up on Fixes: tags automatically
