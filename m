Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8BE0581DEB
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 05:08:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234108AbiG0DIy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jul 2022 23:08:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229773AbiG0DIx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Jul 2022 23:08:53 -0400
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 175D212D28;
        Tue, 26 Jul 2022 20:08:51 -0700 (PDT)
X-UUID: fb8b84ccf1274bd38912ad024fd5de22-20220727
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.8,REQID:7522235a-6c69-42da-be8b-357b1520eb8f,OB:0,LO
        B:0,IP:0,URL:5,TC:0,Content:0,EDM:0,RT:0,SF:45,FILE:0,RULE:Release_Ham,ACT
        ION:release,TS:50
X-CID-INFO: VERSION:1.1.8,REQID:7522235a-6c69-42da-be8b-357b1520eb8f,OB:0,LOB:
        0,IP:0,URL:5,TC:0,Content:0,EDM:0,RT:0,SF:45,FILE:0,RULE:Release_Ham,ACTIO
        N:release,TS:50
X-CID-META: VersionHash:0f94e32,CLOUDID:8fe398b3-06d2-48ef-b2dd-540836705165,C
        OID:d1b4bca2fcb9,Recheck:0,SF:28|17|19|48,TC:nil,Content:0,EDM:-3,IP:nil,U
        RL:1,File:nil,QS:nil,BEC:nil,COL:0
X-UUID: fb8b84ccf1274bd38912ad024fd5de22-20220727
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw01.mediatek.com
        (envelope-from <peter.wang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 1495311444; Wed, 27 Jul 2022 11:08:47 +0800
Received: from mtkmbs11n1.mediatek.inc (172.21.101.186) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.792.15; Wed, 27 Jul 2022 11:08:45 +0800
Received: from [172.21.84.99] (172.21.84.99) by mtkmbs11n1.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.2.792.15 via Frontend
 Transport; Wed, 27 Jul 2022 11:08:45 +0800
Subject: Re: [PATCH v3] ufs: core: fix lockdep warning of clk_scaling_lock
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     <stanley.chu@mediatek.com>, <linux-scsi@vger.kernel.org>,
        <martin.petersen@oracle.com>, <avri.altman@wdc.com>,
        <alim.akhtar@samsung.com>, <jejb@linux.ibm.com>,
        <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
        <chun-hung.wu@mediatek.com>, <alice.chao@mediatek.com>,
        <cc.chou@mediatek.com>, <chaotian.jing@mediatek.com>,
        <jiajie.hao@mediatek.com>, <powen.kao@mediatek.com>,
        <qilin.tan@mediatek.com>, <lin.gui@mediatek.com>,
        <stable@vger.kernel.org>
References: <20220726091433.22755-1-peter.wang@mediatek.com>
 <YuACtFnW6QJ7QFyq@kroah.com>
From:   Peter Wang <peter.wang@mediatek.com>
Message-ID: <5e9a5d32-504d-54ad-fbe7-01ac054ec2c2@mediatek.com>
Date:   Wed, 27 Jul 2022 11:08:45 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <YuACtFnW6QJ7QFyq@kroah.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 7/26/22 11:05 PM, Greg KH wrote:
> On Tue, Jul 26, 2022 at 05:14:33PM +0800, peter.wang@mediatek.com wrote:
>> From: Peter Wang <peter.wang@mediatek.com>
>>
>> There have a lockdep warning like below in current flow.
>> kworker/u16:0:  Possible unsafe locking scenario:
>>
>> kworker/u16:0:        CPU0                    CPU1
>> kworker/u16:0:        ----                    ----
>> kworker/u16:0:   lock(&hba->clk_scaling_lock);
>> kworker/u16:0:                                lock(&hba->dev_cmd.lock);
>> kworker/u16:0:                                lock(&hba->clk_scaling_lock);
>> kworker/u16:0:   lock(&hba->dev_cmd.lock);
>> kworker/u16:0:
>>
>> Before this patch clk_scaling_lock was held in reader mode during the ufshcd_wb_toggle() call.
>> With this patch applied clk_scaling_lock is not held while ufshcd_wb_toggle() is called.
>>
>> This is safe because ufshcd_wb_toggle will held clk_scaling_lock in reader mode "again" in flow
>> ufshcd_wb_toggle -> __ufshcd_wb_toggle -> ufshcd_query_flag_retry -> ufshcd_query_flag ->
>> ufshcd_exec_dev_cmd -> down_read(&hba->clk_scaling_lock);
>> The protect should enough and make sure clock is not change while send command.
>>
>> ufshcd_wb_toggle can protected by hba->clk_scaling.is_allowed to make sure
>> ufshcd_devfreq_scale function not run concurrently.
>>
>> Fixes: 0e9d4ca43ba8 ("scsi: ufs: Protect some contexts from unexpected clock scaling")
>> Signed-off-by: Peter Wang <peter.wang@mediatek.com>
>> ---
>>   drivers/ufs/core/ufshcd.c | 27 ++++++++++++++++-----------
>>   1 file changed, 16 insertions(+), 11 deletions(-)
>>
>> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
>> index c7b337480e3e..aa57126fdb49 100644
>> --- a/drivers/ufs/core/ufshcd.c
>> +++ b/drivers/ufs/core/ufshcd.c
>> @@ -272,6 +272,7 @@ static void ufshcd_wb_toggle_flush_during_h8(struct ufs_hba *hba, bool set);
>>   static inline void ufshcd_wb_toggle_flush(struct ufs_hba *hba, bool enable);
>>   static void ufshcd_hba_vreg_set_lpm(struct ufs_hba *hba);
>>   static void ufshcd_hba_vreg_set_hpm(struct ufs_hba *hba);
>> +static void ufshcd_clk_scaling_allow(struct ufs_hba *hba, bool allow);
>>   
>>   static inline void ufshcd_enable_irq(struct ufs_hba *hba)
>>   {
>> @@ -1249,12 +1250,10 @@ static int ufshcd_clock_scaling_prepare(struct ufs_hba *hba)
>>   	return ret;
>>   }
>>   
>> -static void ufshcd_clock_scaling_unprepare(struct ufs_hba *hba, bool writelock)
>> +static void ufshcd_clock_scaling_unprepare(struct ufs_hba *hba)
>>   {
>> -	if (writelock)
>> -		up_write(&hba->clk_scaling_lock);
>> -	else
>> -		up_read(&hba->clk_scaling_lock);
>> +	up_write(&hba->clk_scaling_lock);
>> +
>>   	ufshcd_scsi_unblock_requests(hba);
>>   	ufshcd_release(hba);
>>   }
>> @@ -1271,7 +1270,7 @@ static void ufshcd_clock_scaling_unprepare(struct ufs_hba *hba, bool writelock)
>>   static int ufshcd_devfreq_scale(struct ufs_hba *hba, bool scale_up)
>>   {
>>   	int ret = 0;
>> -	bool is_writelock = true;
>> +	bool wb_toggle = false;
>>   
>>   	ret = ufshcd_clock_scaling_prepare(hba);
>>   	if (ret)
>> @@ -1300,13 +1299,19 @@ static int ufshcd_devfreq_scale(struct ufs_hba *hba, bool scale_up)
>>   		}
>>   	}
>>   
>> -	/* Enable Write Booster if we have scaled up else disable it */
>> -	downgrade_write(&hba->clk_scaling_lock);
>> -	is_writelock = false;
>> -	ufshcd_wb_toggle(hba, scale_up);
>> +	/* Disable clk_scaling until ufshcd_wb_toggle finish */
>> +	hba->clk_scaling.is_allowed = false;
>> +	wb_toggle = true;
>>   
>>   out_unprepare:
>> -	ufshcd_clock_scaling_unprepare(hba, is_writelock);
>> +	ufshcd_clock_scaling_unprepare(hba);
>> +
>> +	/* Enable Write Booster if we have scaled up else disable it */
>> +	if (wb_toggle) {
>> +		ufshcd_wb_toggle(hba, scale_up);
>> +		ufshcd_clk_scaling_allow(hba, true);
>> +	}
>> +
>>   	return ret;
>>   }
>>   
>> -- 
>> 2.18.0
>>
> <formletter>
>
> This is not the correct way to submit patches for inclusion in the
> stable kernel tree.  Please read:
>      https://urldefense.com/v3/__https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html__;!!CTRNKA9wMg0ARbw!24V8xNPFu0-WdpS3FH6jpUbnVGjhGphz8M0EYnzuRQWgnNx5qPBSLSwEtdHFyz63fw$
> for how to do this properly.

Hi Greg,


Thank you for remind.

Will use correct way next version


Thanks

Peter



>
> </formletter>
