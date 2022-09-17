Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E77425BB4F2
	for <lists+stable@lfdr.de>; Sat, 17 Sep 2022 02:21:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229621AbiIQAVC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Sep 2022 20:21:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229757AbiIQAU4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Sep 2022 20:20:56 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20BA156B8E
        for <stable@vger.kernel.org>; Fri, 16 Sep 2022 17:20:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663374051;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MEb8Ji/9KFiKVcDLJzMC0DUftq+9xtbvWBEmYmwdpAU=;
        b=fLLADRkaeNf2kwDsx1eHHHJNrF0SA95OKdzSpyvbekvY1D9HjvYW3W5vlhdFmwl0oTnmQV
        +BlgI9XxyNurPYQmCBB3+XvPUVNJeE7cCkeLRHkiLlf3Ch7fMuTsCFLD24LwSId72CYYAG
        rytIVOxHxSE2vxItqvDyyB9xiTqWJeo=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-588-fPx5uiBqPDy-et5X867oXA-1; Fri, 16 Sep 2022 20:20:50 -0400
X-MC-Unique: fPx5uiBqPDy-et5X867oXA-1
Received: by mail-qv1-f72.google.com with SMTP id mx9-20020a0562142e0900b004a1ddfe8ee3so15751904qvb.2
        for <stable@vger.kernel.org>; Fri, 16 Sep 2022 17:20:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-language:content-transfer-encoding:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date;
        bh=MEb8Ji/9KFiKVcDLJzMC0DUftq+9xtbvWBEmYmwdpAU=;
        b=bk1985a9Cva9L3adMxRzxbq7ucfLYZAlRaRXZ/X31c196uzM0hh9dFXSqqSXgUZIJ6
         qGVZV8dnga4OnIHECs8mOBmw6ESFfhpCbigUP55FoiysGEYtwg2TtYL2WgZxb7WJtgib
         x0lM3R1C2C2dq6B5H6KTIEYg2r+UkgBR3ffV4StpUFUnQzVUnUuKzbXrXxp25eoTdoXc
         TrPAHC20TzytPcR++/uri74TKglkLNS0w9TPvQlACzl0rIxXCSrZTgRbN8+zQWMIdR9B
         2RKonxG9gJEUv5GJ0X2w+FiEPTq5W/3EvyysCIWGOdCXyt8N4ISb8Nx+DOCJ5ZLrFlLz
         Ar6Q==
X-Gm-Message-State: ACrzQf3kUVccM1mggq3A8uTecylew8XiPGe5spWO3gf2uWemPXnjj8dv
        fSvArKDrZ2NivUPyZLkH9xZXjKF52H/MaY1Zx4AHE/EeeAfFtTdzafQHQ5DQ5oWA+7f6hvcNhbB
        3q48cWN6vg6zzXsHF/wwM2k5QTJcTVrIiCaFyBXv+c47fVL0M4QOKMbrJIW5r/Bk=
X-Received: by 2002:a05:622a:30f:b0:344:b51a:cc64 with SMTP id q15-20020a05622a030f00b00344b51acc64mr6536444qtw.336.1663374049914;
        Fri, 16 Sep 2022 17:20:49 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5Duh4jt7m6TsImezWnknJ3dovH5bbkCwsX9dad263+d6wHNjA43YrFXBJ08iGCKsSJTj2BAA==
X-Received: by 2002:a05:622a:30f:b0:344:b51a:cc64 with SMTP id q15-20020a05622a030f00b00344b51acc64mr6536418qtw.336.1663374049653;
        Fri, 16 Sep 2022 17:20:49 -0700 (PDT)
Received: from localhost.localdomain (024-205-208-113.res.spectrum.com. [24.205.208.113])
        by smtp.gmail.com with ESMTPSA id w8-20020a05620a444800b006ce30a5f892sm5077319qkp.102.2022.09.16.17.20.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Sep 2022 17:20:46 -0700 (PDT)
Subject: Re: [PATCH v1 1/1] fpga: m10bmc-sec: Fix possible memory leak of
 flash_buf
To:     Russ Weight <russell.h.weight@intel.com>, mdf@kernel.org,
        hao.wu@intel.com, yilun.xu@intel.com, linux-fpga@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     lgoncalv@redhat.com, marpagan@redhat.com,
        matthew.gerlach@linux.intel.com,
        basheer.ahmed.muddebihal@intel.com, tianfei.zhang@intel.com,
        kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        stable@vger.kernel.org
References: <20220916235205.106873-1-russell.h.weight@intel.com>
From:   Tom Rix <trix@redhat.com>
Message-ID: <f1e92634-8f96-6a3b-52e9-e83fa879ca39@redhat.com>
Date:   Fri, 16 Sep 2022 17:20:43 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220916235205.106873-1-russell.h.weight@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 9/16/22 4:52 PM, Russ Weight wrote:
> There is an error check following the allocation of flash_buf that returns
> without freeing flash_buf. It makes more sense to do the error check
> before the allocation and the reordering eliminates the memory leak.
>
> Reported-by: kernel test robot <lkp@intel.com>
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Fixes: 154afa5c31cd ("fpga: m10bmc-sec: expose max10 flash update count")
> Signed-off-by: Russ Weight <russell.h.weight@intel.com>
Reviewed-by: Tom Rix <trix@redhat.com>
> Cc: <stable@vger.kernel.org>
> ---
>   drivers/fpga/intel-m10-bmc-sec-update.c | 8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/fpga/intel-m10-bmc-sec-update.c b/drivers/fpga/intel-m10-bmc-sec-update.c
> index 526c8cdd1474..79d48852825e 100644
> --- a/drivers/fpga/intel-m10-bmc-sec-update.c
> +++ b/drivers/fpga/intel-m10-bmc-sec-update.c
> @@ -148,10 +148,6 @@ static ssize_t flash_count_show(struct device *dev,
>   	stride = regmap_get_reg_stride(sec->m10bmc->regmap);
>   	num_bits = FLASH_COUNT_SIZE * 8;
>   
> -	flash_buf = kmalloc(FLASH_COUNT_SIZE, GFP_KERNEL);
> -	if (!flash_buf)
> -		return -ENOMEM;
> -
>   	if (FLASH_COUNT_SIZE % stride) {
>   		dev_err(sec->dev,
>   			"FLASH_COUNT_SIZE (0x%x) not aligned to stride (0x%x)\n",
> @@ -160,6 +156,10 @@ static ssize_t flash_count_show(struct device *dev,
>   		return -EINVAL;
>   	}
>   
> +	flash_buf = kmalloc(FLASH_COUNT_SIZE, GFP_KERNEL);
> +	if (!flash_buf)
> +		return -ENOMEM;
> +
>   	ret = regmap_bulk_read(sec->m10bmc->regmap, STAGING_FLASH_COUNT,
>   			       flash_buf, FLASH_COUNT_SIZE / stride);
>   	if (ret) {

