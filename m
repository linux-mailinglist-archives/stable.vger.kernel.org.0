Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03E5758394E
	for <lists+stable@lfdr.de>; Thu, 28 Jul 2022 09:13:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231431AbiG1HNx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jul 2022 03:13:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230482AbiG1HNw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Jul 2022 03:13:52 -0400
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 822185E311;
        Thu, 28 Jul 2022 00:13:51 -0700 (PDT)
X-UUID: f5b4335d66944ec7881168631f0d3798-20220728
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.8,REQID:15cfd353-6f83-40a3-8faa-57d4626a5268,OB:0,LO
        B:0,IP:0,URL:5,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,RULE:Release_Ham,ACTI
        ON:release,TS:5
X-CID-META: VersionHash:0f94e32,CLOUDID:5cc18ed0-841b-4e95-ad42-8f86e18f54fc,C
        OID:IGNORED,Recheck:0,SF:nil,TC:nil,Content:0,EDM:-3,IP:nil,URL:1,File:nil
        ,QS:nil,BEC:nil,COL:0
X-UUID: f5b4335d66944ec7881168631f0d3798-20220728
Received: from mtkmbs11n1.mediatek.inc [(172.21.101.185)] by mailgw01.mediatek.com
        (envelope-from <peter.wang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 1828418788; Thu, 28 Jul 2022 15:13:43 +0800
Received: from mtkmbs11n1.mediatek.inc (172.21.101.186) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.792.3;
 Thu, 28 Jul 2022 15:13:43 +0800
Received: from [172.21.84.99] (172.21.84.99) by mtkmbs11n1.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.2.792.15 via Frontend
 Transport; Thu, 28 Jul 2022 15:13:42 +0800
Subject: Re: [PATCH v4] ufs: core: fix lockdep warning of clk_scaling_lock
To:     Bart Van Assche <bvanassche@acm.org>, <stanley.chu@mediatek.com>,
        <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>
CC:     <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
        <chun-hung.wu@mediatek.com>, <alice.chao@mediatek.com>,
        <cc.chou@mediatek.com>, <chaotian.jing@mediatek.com>,
        <jiajie.hao@mediatek.com>, <powen.kao@mediatek.com>,
        <qilin.tan@mediatek.com>, <lin.gui@mediatek.com>,
        <stable@vger.kernel.org>
References: <20220727032110.31168-1-peter.wang@mediatek.com>
 <5fab3d4f-914e-63f8-a3e8-7dd92ecdb04a@acm.org>
From:   Peter Wang <peter.wang@mediatek.com>
Message-ID: <47d1efed-69a7-cabf-e586-48b09a9afd78@mediatek.com>
Date:   Thu, 28 Jul 2022 15:13:37 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <5fab3d4f-914e-63f8-a3e8-7dd92ecdb04a@acm.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 7/28/22 2:12 AM, Bart Van Assche wrote:
> On 7/26/22 20:21, peter.wang@mediatek.com wrote:
>> -    /* Enable Write Booster if we have scaled up else disable it */
>> -    downgrade_write(&hba->clk_scaling_lock);
>> -    is_writelock = false;
>> -    ufshcd_wb_toggle(hba, scale_up);
>> +    /* Disable clk_scaling until ufshcd_wb_toggle finish */
>> +    hba->clk_scaling.is_allowed = false;
>> +    wb_toggle = true;
>>     out_unprepare:
>> -    ufshcd_clock_scaling_unprepare(hba, is_writelock);
>> +    ufshcd_clock_scaling_unprepare(hba);
>> +
>> +    /* Enable Write Booster if we have scaled up else disable it */
>> +    if (wb_toggle) {
>> +        ufshcd_wb_toggle(hba, scale_up);
>> +        ufshcd_clk_scaling_allow(hba, true);
>> +    }
>
> I'm concerned that briefly disabling clock scaling may cause the clock 
> to remain at a high frequency even if it shouldn't. Has the following 
> approach been considered? Instead of moving the 
> ufshcd_clk_scaling_allow() call, convert dev_cmd.lock into a 
> semaphore, lock it near the start of ufshcd_devfreq_scale() and unlock 
> it near the end of the same function.
>
> Thanks,
>
> Bart.


Hi Bart,

Clock scaling up/down have a polling_ms, so it shouldn't have this 
condition that scale up block scale down.
Convert dev_cmd.lock into a semaphore is more risky, and dev_cmd.lock 
should hold when send dev command only.
I think it is not suitable to hold this dev_cmd.lock in 
ufshcd_devfreq_scale.

Maybe we can have another choice, let vendor decide ufshcd_wb_toggle 
with clock scaling or not?

Thanks.
Peter



