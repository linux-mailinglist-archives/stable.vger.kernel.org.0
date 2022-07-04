Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF084564FCD
	for <lists+stable@lfdr.de>; Mon,  4 Jul 2022 10:35:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233219AbiGDIfD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jul 2022 04:35:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231497AbiGDIfD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jul 2022 04:35:03 -0400
X-Greylist: delayed 302 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 04 Jul 2022 01:34:58 PDT
Received: from mailgw.kylinos.cn (unknown [124.126.103.232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 701255FB2
        for <stable@vger.kernel.org>; Mon,  4 Jul 2022 01:34:58 -0700 (PDT)
X-UUID: 74b87baa42e44d56be5f141cc86d2f9e-20220704
X-Spam-Fingerprint: 0
X-GW-Reason: 13103
X-Policy-Incident: 5pS25Lu25Lq66LaF6L+HNeS6uumcgOimgeWuoeaguA==
X-Content-Feature: ica/max.line-size 76
        audit/email.address 4
        dict/adv 1
        dict/prolog 1
        dict/software 1
X-CPASD-INFO: 27fc3a115e8b4dc3a8cf517d60e2ddcf@e4egg2CTX2FhhXqug6eubYFpk5ZlXVe
        zeGqFYpKUj4aVgnxsTWBnX1OEgnBQYl5dZFZ3dG9RYmBgYlB_i4Jyj1RgXmCCVHSTgHRxhpNhkQ==
X-CLOUD-ID: 27fc3a115e8b4dc3a8cf517d60e2ddcf
X-CPASD-SUMMARY: SIP:-1,APTIP:-2.0,KEY:0.0,FROMBLOCK:1,OB:0.0,URL:-5,TVAL:155.
        0,ESV:0.0,ECOM:-5.0,ML:0.0,FD:0.0,CUTS:325.0,IP:-2.0,MAL:-5.0,PHF:-5.0,PHC:-5
        .0,SPF:4.0,EDMS:-5,IPLABEL:4352.0,FROMTO:0,AD:0,FFOB:0.0,CFOB:0.0,SPC:0,SIG:-
        5,AUF:0,DUF:550,ACD:7,DCD:7,SL:0,EISP:0,AG:0,CFC:0.888,CFSR:0.023,UAT:0,RAF:2
        ,IMG:-5.0,DFA:0,DTA:0,IBL:-2.0,ADI:-5,SBL:0,REDM:0,REIP:0,ESB:0,ATTNUM:0,EAF:
        0,CID:-5.0,VERSION:2.3.17
X-CPASD-ID: 74b87baa42e44d56be5f141cc86d2f9e-20220704
X-CPASD-BLOCK: 1000
X-CPASD-STAGE: 1
X-UUID: 74b87baa42e44d56be5f141cc86d2f9e-20220704
X-User: liuyun01@kylinos.cn
Received: from [172.16.31.199] [(111.48.58.12)] by mailgw
        (envelope-from <liuyun01@kylinos.cn>)
        (Generic MTA)
        with ESMTP id 232610925; Mon, 04 Jul 2022 09:22:32 +0800
Message-ID: <bf21d317-8d4b-e237-86b7-be577b5bc652@kylinos.cn>
Date:   Mon, 4 Jul 2022 09:19:56 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH] firmware: arm_scpi: Ensure scpi_info is not assigned if
 the probe fails
Content-Language: en-US
To:     Sudeep Holla <sudeep.holla@arm.com>,
        linux-arm-kernel@lists.infradead.org
Cc:     luriwen@kylinos.cn, 15815827059@163.com, cristian.marussi@arm.com,
        huhai <huhai@kylinos.cn>, stable@vger.kernel.org
References: <20220701160310.148344-1-sudeep.holla@arm.com>
From:   Jackie Liu <liuyun01@kylinos.cn>
In-Reply-To: <20220701160310.148344-1-sudeep.holla@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.1 required=5.0 tests=BAYES_00,KHOP_HELO_FCRDNS,
        MAY_BE_FORGED,NICE_REPLY_A,RDNS_DYNAMIC,SPF_HELO_NONE,
        T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sudeep.

Thanks for your patch, It's look good to me.

Reviewed-by: Jackie Liu <liuyun01@kylinos.cn>

在 2022/7/2 00:03, Sudeep Holla 写道:
> When scpi probe fails, at any point, we need to ensure that the scpi_info
> is not set and will remain NULL until the probe succeeds. If it is not
> taken care, then it could result in kernel panic with a NULL pointer
> dereference.

I think the null pointer reference is not correct. It should be UAF. The
logic is as follows:

scpi_info = devm_zalloc

After that if fails, the address will be released, but scpi_info is not
NULL. Normal, there will be no problem, because scpi_info is alloc by
kzalloc, so even if scpi_info is not NULL, but scpi_info->scpi_ops is
NULL, It still work normally.

But if another process or thread alloc a new data, if they are same 
address, and then it is assigned a value, so wild pointer 
scpi_info->scpi_ops is not NULL now, Then, Panic.

Thanks.

--
Jackie Liu.
> 
> Reported-by: huhai <huhai@kylinos.cn>
> Cc: stable@vger.kernel.org # 4.19+
> Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
> ---
>   drivers/firmware/arm_scpi.c | 57 +++++++++++++++++++++----------------
>   1 file changed, 32 insertions(+), 25 deletions(-)
> 
> diff --git a/drivers/firmware/arm_scpi.c b/drivers/firmware/arm_scpi.c
> index ddf0b9ff9e15..085a71a00171 100644
> --- a/drivers/firmware/arm_scpi.c
> +++ b/drivers/firmware/arm_scpi.c
> @@ -913,13 +913,14 @@ static int scpi_probe(struct platform_device *pdev)
>   	struct resource res;
>   	struct device *dev = &pdev->dev;
>   	struct device_node *np = dev->of_node;
> +	struct scpi_drvinfo *scpi_drvinfo;
>   
> -	scpi_info = devm_kzalloc(dev, sizeof(*scpi_info), GFP_KERNEL);
> -	if (!scpi_info)
> +	scpi_drvinfo = devm_kzalloc(dev, sizeof(*scpi_drvinfo), GFP_KERNEL);
> +	if (!scpi_drvinfo)
>   		return -ENOMEM;
>   
>   	if (of_match_device(legacy_scpi_of_match, &pdev->dev))
> -		scpi_info->is_legacy = true;
> +		scpi_drvinfo->is_legacy = true;
>   
>   	count = of_count_phandle_with_args(np, "mboxes", "#mbox-cells");
>   	if (count < 0) {
> @@ -927,19 +928,19 @@ static int scpi_probe(struct platform_device *pdev)
>   		return -ENODEV;
>   	}
>   
> -	scpi_info->channels = devm_kcalloc(dev, count, sizeof(struct scpi_chan),
> -					   GFP_KERNEL);
> -	if (!scpi_info->channels)
> +	scpi_drvinfo->channels =
> +		devm_kcalloc(dev, count, sizeof(struct scpi_chan), GFP_KERNEL);
> +	if (!scpi_drvinfo->channels)
>   		return -ENOMEM;
>   
> -	ret = devm_add_action(dev, scpi_free_channels, scpi_info);
> +	ret = devm_add_action(dev, scpi_free_channels, scpi_drvinfo);
>   	if (ret)
>   		return ret;
>   
> -	for (; scpi_info->num_chans < count; scpi_info->num_chans++) {
> +	for (; scpi_drvinfo->num_chans < count; scpi_drvinfo->num_chans++) {
>   		resource_size_t size;
> -		int idx = scpi_info->num_chans;
> -		struct scpi_chan *pchan = scpi_info->channels + idx;
> +		int idx = scpi_drvinfo->num_chans;
> +		struct scpi_chan *pchan = scpi_drvinfo->channels + idx;
>   		struct mbox_client *cl = &pchan->cl;
>   		struct device_node *shmem = of_parse_phandle(np, "shmem", idx);
>   
> @@ -986,45 +987,51 @@ static int scpi_probe(struct platform_device *pdev)
>   		return ret;
>   	}
>   
> -	scpi_info->commands = scpi_std_commands;
> +	scpi_drvinfo->commands = scpi_std_commands;
>   
> -	platform_set_drvdata(pdev, scpi_info);
> +	platform_set_drvdata(pdev, scpi_drvinfo);
>   
> -	if (scpi_info->is_legacy) {
> +	if (scpi_drvinfo->is_legacy) {
>   		/* Replace with legacy variants */
>   		scpi_ops.clk_set_val = legacy_scpi_clk_set_val;
> -		scpi_info->commands = scpi_legacy_commands;
> +		scpi_drvinfo->commands = scpi_legacy_commands;
>   
>   		/* Fill priority bitmap */
>   		for (idx = 0; idx < ARRAY_SIZE(legacy_hpriority_cmds); idx++)
>   			set_bit(legacy_hpriority_cmds[idx],
> -				scpi_info->cmd_priority);
> +				scpi_drvinfo->cmd_priority);
>   	}
>   
> -	ret = scpi_init_versions(scpi_info);
> +	ret = scpi_init_versions(scpi_drvinfo);
>   	if (ret) {
>   		dev_err(dev, "incorrect or no SCP firmware found\n");
>   		return ret;
>   	}
>   
> -	if (scpi_info->is_legacy && !scpi_info->protocol_version &&
> -	    !scpi_info->firmware_version)
> +	if (scpi_drvinfo->is_legacy && !scpi_drvinfo->protocol_version &&
> +	    !scpi_drvinfo->firmware_version)
>   		dev_info(dev, "SCP Protocol legacy pre-1.0 firmware\n");
>   	else
>   		dev_info(dev, "SCP Protocol %lu.%lu Firmware %lu.%lu.%lu version\n",
>   			 FIELD_GET(PROTO_REV_MAJOR_MASK,
> -				   scpi_info->protocol_version),
> +				   scpi_drvinfo->protocol_version),
>   			 FIELD_GET(PROTO_REV_MINOR_MASK,
> -				   scpi_info->protocol_version),
> +				   scpi_drvinfo->protocol_version),
>   			 FIELD_GET(FW_REV_MAJOR_MASK,
> -				   scpi_info->firmware_version),
> +				   scpi_drvinfo->firmware_version),
>   			 FIELD_GET(FW_REV_MINOR_MASK,
> -				   scpi_info->firmware_version),
> +				   scpi_drvinfo->firmware_version),
>   			 FIELD_GET(FW_REV_PATCH_MASK,
> -				   scpi_info->firmware_version));
> -	scpi_info->scpi_ops = &scpi_ops;
> +				   scpi_drvinfo->firmware_version));
> +
> +	scpi_drvinfo->scpi_ops = &scpi_ops;
> +
> +	ret = devm_of_platform_populate(dev);
>   
> -	return devm_of_platform_populate(dev);
> +	if (!ret)
> +		scpi_info = scpi_drvinfo;
> +
> +	return ret;
>   }
>   
>   static const struct of_device_id scpi_of_match[] = {
