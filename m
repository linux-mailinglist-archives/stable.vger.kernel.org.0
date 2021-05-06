Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C39837546F
	for <lists+stable@lfdr.de>; Thu,  6 May 2021 15:08:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232836AbhEFNJN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 May 2021 09:09:13 -0400
Received: from mail-eopbgr80118.outbound.protection.outlook.com ([40.107.8.118]:38600
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233656AbhEFNJM (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 6 May 2021 09:09:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ThBG0owWKOm8jK+GVtx0VulL5m7X2l5zNaJhyYHWWyl1/iul+EyWMVyf5Xm6U67AGGPX4cKVYZE2asGZiYe/UTYDl8+arDhJSb/olYBBqX9tHeadqMJBFxDnMHYSnjVUrUF86vumt03DOwz5cVZYsmKrc/esn1iS4miC9zSrLw/1ytjvIpKdpXA/obyDHLAcYPsOJ/a5rGDbNsb2fO5Ec0SgMmZrkV6jHOTwIweJt/1DWz0PzYbq9L92S9v4bBJTHryoeCCCciXLOuEBCF7tVHJcyAcuabRpHAETxssgQ3BHNg4sjQxMEGUKLivyAbLw+w6PF5Bwf0MwEF65r9g1Jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ha+FvTQzemivpxbEMtQJM0oDnUc5lh1fzlM1acB+vQ8=;
 b=C71tsdG7HvLlBs55vtlnWMqzC2RErXWNc6ZR+fHkHRDF01BF0qMJImuSIn01yKwM0q3y5vMUwJcaSsxwbc5OiA5vkQt4rGk03+oh9Q1NgwbUKX70Agf07xfj2Wo93y5bDwAVBBw+ObZwAjGsiA+HZoBn/L73P2J62rtFk2GsOuxxJ6EXAX7B9q54U/WHA4KwSb3codc4xsvKKH1DvaNPcwyFeg2k8F6ElsvKcze3yc1Yw0ElnInTSR+mMhci5DBWSRXLsxp9j68UU3w/tB4Nt72/SI99irw/exV2Zt2hzghHn7AiGvUBvgngI6odyRUiuGG0a7F9erH252qeFjXjkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=axentia.se; dmarc=pass action=none header.from=axentia.se;
 dkim=pass header.d=axentia.se; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=axentia.se;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ha+FvTQzemivpxbEMtQJM0oDnUc5lh1fzlM1acB+vQ8=;
 b=QEjHqaP7JNFDxIMptsOYuKPt6g1cU46zHc7BnEtf7XWN1HX0dv/PNcrjUNIK/XV1o4rdNtFoheWm2ShOXpHi0rrCAvKIn1HjoWGM750MvX8Ftx+eaEG9RV8RQbckLg3hHlToZw63JIsdQ+BhdMngafZGKtpZEdzyuYv7xyRJhCs=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=axentia.se;
Received: from DB8PR02MB5482.eurprd02.prod.outlook.com (2603:10a6:10:eb::29)
 by DBAPR02MB5992.eurprd02.prod.outlook.com (2603:10a6:10:187::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25; Thu, 6 May
 2021 13:08:11 +0000
Received: from DB8PR02MB5482.eurprd02.prod.outlook.com
 ([fe80::d47d:ca8c:4fe6:3908]) by DB8PR02MB5482.eurprd02.prod.outlook.com
 ([fe80::d47d:ca8c:4fe6:3908%3]) with mapi id 15.20.4108.027; Thu, 6 May 2021
 13:08:11 +0000
Subject: Re: [PATCH 27/69] cdrom: gdrom: deallocate struct gdrom_unit fields
 in remove_gdrom
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org,
        Atul Gopinathan <atulgopinathan@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, stable <stable@vger.kernel.org>
References: <20210503115736.2104747-1-gregkh@linuxfoundation.org>
 <20210503115736.2104747-28-gregkh@linuxfoundation.org>
 <223d5bda-bf02-a4a8-ab1d-de25e32b8d47@axentia.se>
 <YJPDzqAAnP0jDRDF@kroah.com>
From:   Peter Rosin <peda@axentia.se>
Organization: Axentia Technologies AB
Message-ID: <dd716d04-b9fa-986a-50dd-5c385ea745b2@axentia.se>
Date:   Thu, 6 May 2021 15:08:08 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
In-Reply-To: <YJPDzqAAnP0jDRDF@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: sv-SE
Content-Transfer-Encoding: 7bit
X-Originating-IP: [85.229.94.233]
X-ClientProxiedBy: HE1PR09CA0078.eurprd09.prod.outlook.com
 (2603:10a6:7:3d::22) To DB8PR02MB5482.eurprd02.prod.outlook.com
 (2603:10a6:10:eb::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.13.3] (85.229.94.233) by HE1PR09CA0078.eurprd09.prod.outlook.com (2603:10a6:7:3d::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend Transport; Thu, 6 May 2021 13:08:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4eefb16e-39e4-4964-f828-08d910900047
X-MS-TrafficTypeDiagnostic: DBAPR02MB5992:
X-Microsoft-Antispam-PRVS: <DBAPR02MB59924427F4E2B0E357FA046DBC589@DBAPR02MB5992.eurprd02.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: a+KUp0R7T6xEcxE8cChIvGcbfKezEqye+yW5DIwh1bOoquU2UBVQaLcj5z06lBoGcWp473vufNwbxPh8xkqn4a1dN742G2j7diM/FamhzPRPHr6bjonZN7KKFE4lTttsw40vNUWTiRmgG/WmEmX9tPBL294Bl2x6flguyO3PShLalcFKnaaa5GJUHEv363vYVKuGFvCAY4CcGxy51gPzn49nTaxvAo1Dedtaw8Hen5fhJgfMkWfBzLSbi8X2JPEzSMC89hwTJRLVGmxCAMp1Pi/bZ86HsWGeWvw385PE60etuXVTYQ3lINVMXyBRIaK8QJBWnn7F9ZUZMH8osCI5iGi1lFM73FwmokKv9EC8ymqWCz75w0cJ5NyR5P8RZXbhvFAcjnj5obtBL/oxJVs5XqZKnh3zEPkixOZrg0iCfDvboLeRZXBxA1zBppCmvI+FRlsXFhvomvlDoMoR+mSEB53MSPI65P47YTXMWEmVxSMm74uodZVyB3/gGNbmIu+0BiK2r5nWDetDwBLA/MvJbSe/vfzjIgjrJv+Qxoza+Nu5++xMxZBGphYSQb5DJ7QZ0KIwAb5pIjNNvMR+SyM2d1iwLKindpJ01U40pCWGW5pRyQnW5N3zERnXkcs8FC0sVLXIrjM86+YxAs527xLUOSzdEo0TKwd9nd1P7RVEP6CsdvwSc1KuKaJIMdBtJhH5
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR02MB5482.eurprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(136003)(39830400003)(396003)(366004)(2906002)(54906003)(316002)(16526019)(186003)(86362001)(16576012)(5660300002)(956004)(2616005)(53546011)(66946007)(66476007)(36756003)(6486002)(66556008)(31696002)(8936002)(36916002)(26005)(6916009)(8676002)(478600001)(83380400001)(6666004)(38100700002)(31686004)(4326008)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Ly9UTkRpM2NQM1RpRUw1R09PeGQzQk1aR09tN0I2YXI5cDR1QkVxNExlUEdy?=
 =?utf-8?B?V2RVVWtSS3RDaGFXNmpLMjRVVHl0UjZrVUVUcTJ0WG4velczUXlZUjNjbjAx?=
 =?utf-8?B?TzdPRkhFcE9lc0lNUlJPZkUvYXFFLzR2VjkxYmZXSXBpWEc3VzI4eDJyTXBI?=
 =?utf-8?B?ckJPdjdsaFJYMzVwdk9OT05Db1dpNVM0U01yMFpBZ2crREl6STFVYWFCSS9X?=
 =?utf-8?B?TTczZVorbmtqQlJ1ekZRM0tLVFRJVnNRN1FDUDg5OEhPUitIdE1RUWoyMEtr?=
 =?utf-8?B?LytzSEFzdzJRalN6NEZiMmRLSVh3ZGRJMVlvS2dRRm9BTGlJeWFmQkZOenBV?=
 =?utf-8?B?UmlqUGw5cnpFOTI5Nmw1NkMvZ2lQSkN4dmdRckpodUx4U2lDQ0ZWc21qKzVL?=
 =?utf-8?B?UHYxMGF3bXUvV2twTldqb2ZCM2lxOHRaNnR3REdGaDdsNC9UanFjdG5JTzFt?=
 =?utf-8?B?NTRRTU81UXJkc1g1bXoyZEhFdlBiWDg5MXBNekZBWDkyRnR1VU5iRjhyWjEv?=
 =?utf-8?B?bG8yWUxVdUg4MzVqak4yRW1ISlhxOGhwd21ZS3RSUkVMNFcxYWprZWlpaExi?=
 =?utf-8?B?elRMWHZkZnozd0NKUHpaSEVqYW9KQnljOGdOTDJHUDhjOTVkK0d0dVkxYm4z?=
 =?utf-8?B?VUpuYjhJeDFRaytEb001SE5GYTVya3F1MWcrdXFsSDFDdTVFbVdvT01nT0pv?=
 =?utf-8?B?Z3ZLektOVmlZWlJmdUxpTldQdHhRT0VJY2FyMUpuQWFpVm5sQlVmZGM0ZDJz?=
 =?utf-8?B?WWU0dStZWlBzNTRrdVlmb2g4UldPZEIwM2Y0WWZRMlJSWHQvMFBlb0xUakN2?=
 =?utf-8?B?T1RxalZaVE13aXB0WlRlMnVDTW41QWozQ2xtZVpOdFFnR2RtbzdiU3QrWkRM?=
 =?utf-8?B?WnlWRmVxWFJlUDc2WHpjSlhEZVNjMFZmajZFSHdGRzJFUmQvNHk3OXdHOVkw?=
 =?utf-8?B?dXRhZ3RIaFNMSWs4djUvN2dIc2hkdUg3ZnlKbENNc2Z6b1N6QWlqdlFjczJj?=
 =?utf-8?B?Q2l6MHhXc0Z1MTZoQ012aHlWVThXSm9KNmhmOW9OdjRyTHUyemNRSUVBL0NN?=
 =?utf-8?B?VGlOTXEwU2t3MVVhN1o4QTN6djl3R09ER1ZLOWF2Qm1oV0c3VTZqdW52dXha?=
 =?utf-8?B?Nkc5QUdBenRXYmk4Ly9RMjRxZk1USTh2NkxHd2pUT3d0bkROendEZ1lUWDNK?=
 =?utf-8?B?Nit0blpFckk0cnFzTFFyemlUamVxS1dSZW5EeGNQWXRPNlBUeUR2WWNmOWd6?=
 =?utf-8?B?a2t6K05VN2h3aGZ4aGdNeHdKSDd6S3hCeStMWXdJcmZ2b1VNdjhLdll0SVlH?=
 =?utf-8?B?K1NKOENmZTZNV2tRMUZ4ZDBIWXA0OHJVR3ExSFB3K1pPWllNMjhkamdJaDZQ?=
 =?utf-8?B?bzVOTlkvVU85bmxwWDd0QlpXM1JQbU02YlBPUFZwcytEVGt1ZEN1WkowSlIy?=
 =?utf-8?B?Rm53ZkY0ZUxyOTkxQVZjQ3piUVhmbXFranRxZllEeWl2TjR6bTQrOUxaTStB?=
 =?utf-8?B?MlhISC9DSlhBNjNQc2o2WHJRTENwRGYxcng2WkZxeDhndmcweUUrSHlQbnRm?=
 =?utf-8?B?aUFjSUE2eVBBb3hzaVErZ1dGYXo1aWxIcC9XU01XRWQrcTZmN2l6TFphWDhD?=
 =?utf-8?B?VDAwZWZoL2VRWjdhQitsVDAvak9DeU5sazJmLys5d1VYMkFDMG1FaFNMZlpQ?=
 =?utf-8?B?YmJLdHdxYXpjUEdiMGFqUUZtMXdqYW85UTc0Z2xDbEUycmVhQ3Q0YUNxbXBj?=
 =?utf-8?Q?UL/2ggAo4tcyPEPz7QNwObONlerUp2KGrRmobu0?=
X-OriginatorOrg: axentia.se
X-MS-Exchange-CrossTenant-Network-Message-Id: 4eefb16e-39e4-4964-f828-08d910900047
X-MS-Exchange-CrossTenant-AuthSource: DB8PR02MB5482.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2021 13:08:11.7236
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4ee68585-03e1-4785-942a-df9c1871a234
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 54aMTMU/gXR9mEgVNsdQAzC64StXx8gJW4DvrhOH7iyj8DPGOphsHT78whk5192F
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR02MB5992
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi!

On 2021-05-06 12:24, Greg Kroah-Hartman wrote:
> On Mon, May 03, 2021 at 04:13:18PM +0200, Peter Rosin wrote:
>> Hi!
>>
>> On 2021-05-03 13:56, Greg Kroah-Hartman wrote:
>>> From: Atul Gopinathan <atulgopinathan@gmail.com>
>>>
>>> The fields, "toc" and "cd_info", of "struct gdrom_unit gd" are allocated
>>> in "probe_gdrom()". Prevent a memory leak by making sure "gd.cd_info" is
>>> deallocated in the "remove_gdrom()" function.
>>>
>>> Also prevent double free of the field "gd.toc" by moving it from the
>>> module's exit function to "remove_gdrom()". This is because, in
>>> "probe_gdrom()", the function makes sure to deallocate "gd.toc" in case
>>> of any errors, so the exit function invoked later would again free
>>> "gd.toc".
>>>
>>> The patch also maintains consistency by deallocating the above mentioned
>>> fields in "remove_gdrom()" along with another memory allocated field
>>> "gd.disk".
>>>
>>> Suggested-by: Jens Axboe <axboe@kernel.dk>
>>> Cc: Peter Rosin <peda@axentia.se>
>>> Cc: stable <stable@vger.kernel.org>
>>> Signed-off-by: Atul Gopinathan <atulgopinathan@gmail.com>
>>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>> ---
>>>  drivers/cdrom/gdrom.c | 3 ++-
>>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/cdrom/gdrom.c b/drivers/cdrom/gdrom.c
>>> index 7f681320c7d3..6c4f6139f853 100644
>>> --- a/drivers/cdrom/gdrom.c
>>> +++ b/drivers/cdrom/gdrom.c
>>> @@ -830,6 +830,8 @@ static int remove_gdrom(struct platform_device *devptr)
>>>  	if (gdrom_major)
>>>  		unregister_blkdev(gdrom_major, GDROM_DEV_NAME);
>>>  	unregister_cdrom(gd.cd_info);
>>> +	kfree(gd.cd_info);
>>> +	kfree(gd.toc);
>>>  
>>>  	return 0;
>>>  }
>>> @@ -861,7 +863,6 @@ static void __exit exit_gdrom(void)
>>>  {
>>>  	platform_device_unregister(pd);
>>>  	platform_driver_unregister(&gdrom_driver);
>>> -	kfree(gd.toc);
>>>  }
>>>  
>>>  module_init(init_gdrom);
>>>
>>
>> I worry about the gd.toc = NULL; statement in init_gdrom(). It sets off
>> all kinds of warnings with me. It looks completely bogus, but the fact
>> that it's there at all makes me go hmmmm.
> 
> Yeah, that's bogus.
> 
>> probe_gdrom_setupcd() will arrange for gdrom_ops to be used, including
>> .get_last_session pointing to gdrom_get_last_session() 
>>
>> gdrom_get_last_session() will use gd.toc, if it is non-NULL.
>>
>> The above will all be registered externally to the driver with the call
>> to register_cdrom() in probe_gdrom(), before a possible stale gd.toc is
>> overwritten with a new one at the end of probe_gdrom().
> 
> But can that really happen given that it hasn't ever happened before in
> a real system?  :)
> 
>> Side note, .get_last_session is an interesting name in this context, but
>> I have no idea if it might be called in the "bad" window (but relying on
>> that to not be the case would be ... subtle).
>>
>> So, by simply freeing gd.toc in remove_gdrom() without also setting
>> it to NULL, it looks like a potential use after free of gd.toc is
>> introduced, replacing a potential leak. Not good.
> 
> So should we set it to NULL after freeing it?  Is that really going to
> help here given that the probe failed?  Nothing can use it after
> remove_gdrom() is called because unregiser_* is called already.
> 
> I don't see the race here, sorry.
> 
>> The same is not true for gd.cd_info as far as I can tell, but it's a bit
>> subtle. gdrom_probe() calls gdrom_execute_diagnostics() before the stale
>> gd.cd_info is overwritten, and gdrom_execute_diagnostic() passes the
>> stale pointer to gdrom_hardreset(), which luckily doesn't use it. But
>> this is - as hinted - a bit too subtle for me. I would prefer to have
>> remove_gdrom() also clear out the gd.cd_info pointer.
> 
> Ok, but again, how can that be used after remove_gdrom() is called?
> 
>> In addition to adding these clears of gd.toc and gd.cd_info to
>> remove_gdrom(), they also need to be cleared in case probe fails.
>>
>> Or instead, maybe add a big fat
>> 	memset(&gd, 0, sizeof(gd));
>> at the top of probe?
> 
> Really, that's what is happening today as there is only 1 device here,
> and the whole structure was zeroed out already.  So that would be a
> no-op.
> 
>> Or maybe the struct gdrom_unit should simply be kzalloc:ed? But that
>> triggers some . to -> churn...
> 
> Yes, ideally that would be the correct change, but given that you can
> only have 1 device in the system at a time of this type, it's not going
> to make much difference at all here.
> 
>> Anyway, the patch as proposed gets a NACK from me.
> 
> Why?  It fixes the obvious memory leak, right?  Worst case you are
> saying we should also set to NULL these pointers, but I can not see how
> they are accessed as we have already torn everything down.

I'm thinking this:

1. init_gdrom() is called. gd.toc is NULL and is bogusly re-set to NULL.
2. probe_gdrom() is called and succeeds. gd.toc is allocted.
3. device is used, etc etc, whatever
4. remove_gdrom() is called. gd.toc is freed (but not set to NULL).
5. probe_gdrom() is called again. Boom.

In 5, gd.toc is not NULL, and is pointing to whatever. It is
potentially used by probe_gdrom() before it is (re-)allocated.

I suppose the above can only happen if the module is compiled in.

Without this patch, we are "safe" because gd.toc still points to the old
thing which is leaked once a new gd.toc is allocated by the second probe.

Cheers,
Peter
