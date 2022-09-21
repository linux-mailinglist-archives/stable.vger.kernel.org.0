Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 173E15BF4DD
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 05:36:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231434AbiIUDgr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Sep 2022 23:36:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231436AbiIUDg2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Sep 2022 23:36:28 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 941C72B184
        for <stable@vger.kernel.org>; Tue, 20 Sep 2022 20:35:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663731328; x=1695267328;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=38IJ6nJVqTt5OysxPH/tSFWxKuUIdsSY1PXiX7JEGmo=;
  b=gkZHd2CbzcTBozvpufOq0EPtl45rNuEOzWvg8ThMb0Fcad1HZyv5SYVr
   /YdTYYjtF/v6+8uc0jc/v22MhgagMa8lME0HM55nPDEwZh5uWc3bIP7j1
   7Go2hm1mIrUxXS2lmnO315Mrai1O0ux8/SgZmluY+MpjqA5LUqNtfaEf0
   kih5d5j8T98nHYIMCDKTwka9HT//7P52CeNnpfCXtudcZt5JfEL9jZc+8
   +cLKKdmNT4kkJBOvNDma/9tmg8DcziLkLnco2H6sX9aa5iq2ByGM4nRjk
   GNRnMRw771cqSm6PMu6s3mRomVDyf1quCa6iMzW/ONB/UGyeoWm5tZGXA
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10476"; a="363863382"
X-IronPort-AV: E=Sophos;i="5.93,332,1654585200"; 
   d="scan'208";a="363863382"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Sep 2022 20:35:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,332,1654585200"; 
   d="scan'208";a="649872221"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga008.jf.intel.com with ESMTP; 20 Sep 2022 20:35:28 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 20 Sep 2022 20:35:27 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 20 Sep 2022 20:35:27 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Tue, 20 Sep 2022 20:35:27 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.176)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Tue, 20 Sep 2022 20:35:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VzRdNwCFcvUD8uyG51WbU26VQ0mYMOVDjKJ1s+nIkUv0vVdgj5c+ZD5KG/udxr8jORXP6gDrYh6vn34P4pV4woAWy7d2F0ITcJU8X3l7HoGf0aI0maa583a43JDbQEu1MQrpxi7o+dPne80NUXA33jA/1fy/eWOQdDcrLi/0m5cAfmHcw9xLEPlUJ/JtINMO59VSzToEO0CzPvEAodnaljY8wnKG+Xxw6nwU8zhs6ywi0qIYUETVA6xCU8azTg9mb42OyWULVBCK0CGauWOJV4w/rosTloHci9hyrN2rd0kylqk2Ph+7QM8a6/y/wBsPJAVXvpHLdgAoMVwBfNRTaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TAocLwFrYAY5LuTNxMJO3bWQ+Pe4gtwGh9bLCMvI35M=;
 b=dGpDH4BS0MeXZUXO3llDofkdNlbpb7m4O4lUbUs9zev95E+kOIX1LM7AZ2s6tWHzqhYo/LOyKOKRePxuI7g67ZKHY6fmvsmrkpEpGgfG8SGse2uRwUyqWtbPfsGNHcT5Rs7rj98lw3l0gMp/04he2HPQP/WKQmPuQ25lFM+rkfu1fZjmtaY4y7+QdwTrpqlVXQdeKdzVwJ+x0yGXebyhJHHeLe4kRfBA/gKvFTc6eFWOcDZrcridIDuOZqwHRlHlF1IB7dslxk8CwhwpS9kdC5RM85uskpZBw+SjlJTw7jo6EyvRDSj38KFa5B+RCDtuiG7bk2dasdCMfh+1Sw4W1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB5658.namprd11.prod.outlook.com (2603:10b6:510:e2::23)
 by SA0PR11MB4560.namprd11.prod.outlook.com (2603:10b6:806:93::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.21; Wed, 21 Sep
 2022 03:35:19 +0000
Received: from PH0PR11MB5658.namprd11.prod.outlook.com
 ([fe80::d28e:a9a1:6df7:dea4]) by PH0PR11MB5658.namprd11.prod.outlook.com
 ([fe80::d28e:a9a1:6df7:dea4%9]) with mapi id 15.20.5654.016; Wed, 21 Sep 2022
 03:35:19 +0000
Message-ID: <23d38de5-3aab-3fe7-2b17-cbf1ab8d6cab@intel.com>
Date:   Wed, 21 Sep 2022 11:35:33 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.11.0
Subject: Re: [PATCH 1/2] iommu/vt-d: Check correct capability for sagaw
 determination
Content-Language: en-US
To:     Baolu Lu <baolu.lu@linux.intel.com>
CC:     <kevin.tian@intel.com>, <baolu.lu@intel.com>,
        <raghunathan.srinivasan@intel.com>, <iommu@lists.linux.dev>,
        <joro@8bytes.org>, <will@kernel.org>, <stable@vger.kernel.org>
References: <20220916071212.2223869-1-yi.l.liu@intel.com>
 <20220916071212.2223869-2-yi.l.liu@intel.com>
 <a5f2141a-d819-20de-1e6c-b9e93323998a@linux.intel.com>
From:   Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <a5f2141a-d819-20de-1e6c-b9e93323998a@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2P153CA0025.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c7::12)
 To PH0PR11MB5658.namprd11.prod.outlook.com (2603:10b6:510:e2::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB5658:EE_|SA0PR11MB4560:EE_
X-MS-Office365-Filtering-Correlation-Id: 5989de9b-43ff-4634-d3f6-08da9b824e82
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ayDAyWajPqxqDNWijQMlpl7jr1ijiqTr7ZT6LvcY2DjMrtiZDPmTcUbn4HhKF8n1u1eqoYqqTGL3PPzw7fgYTxKFXGTOMTeraz7n9R8sy3FnUYknxjLUnQ4vaUGbfyyL+BlfhzveGX7M/gQU/V4fyYTqmE5YovHuNSlfafuHb4lhzRiF9AwvwgLbiPg0fkhyfHtruPlsqGcY/mDBQhdkGRjy8AVWAR+IyCV46y5jPxu4QAdqEaxm0oPtmGsdJIy/gzPfBB2HsHuvE3O1b4rHzzmhRRS+neHItQoRe/AJssPwzdsUGM+hI8kQ3qaXeh3nWMzF2AqaNZ5goBcTPuExqdKBMTNM2ecMyMNGV/nNhiQ/b9uAiBkUlGSn7OhYlsYD+pFYNBdMVKFLXPjZgDX3cFzEc6Sl1xTo51zNAfwF89P0q9Yd72OHe+XcQLEQBYQZaQuU70WF8N6xmEJo7OzNME63e+L/OUpspfLb17ideMiGLOm3whGI1d/4JaY89VonWqC8KJkAWHByZ+Q6pZ5BwTvZxm4n4JJKHVc8jRJ+z4N8vYrB48sCmpbrShDBhB2tEhTnbjeZfgUIalj8rNYI4xAGK2ldRX64tnW8dcky7/NBbEJ9dUZTgYbsTiDK9kc8gLqlDeh8mkGoRGHS5dhIIzvOMo4BAqorFlCRHOuNVxvAMG5T1n6P/R3J5A1vQqXjXjdpC17NIvSuPA1wCmQLqASY5PgzSE+Wl05G/rur10lyjqJxz45eeHNdbUxF4xu76wRFP3uVCTZ0pIHjZNLMoKbVh0SE9guuEelCMgP871/ZZRR68fDWtduOLNW+hAocin8+BnpZLSMvSsnQAmXIPFY0WPWysrrUFwg1joex3fwGXVNyQNur4yLvGAd5FT2U
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5658.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(346002)(366004)(39860400002)(376002)(396003)(451199015)(2906002)(6506007)(6512007)(86362001)(4326008)(53546011)(8936002)(38100700002)(6486002)(36756003)(66946007)(66476007)(41300700001)(31696002)(6666004)(966005)(82960400001)(45080400002)(66556008)(6916009)(31686004)(2616005)(8676002)(478600001)(26005)(316002)(186003)(4744005)(5660300002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?M3NHeUFQVTR0ZDdkVVdzWXJxNFJ0OWExSGhJNHpYaHZZQkowRHo0QVpTa0Rh?=
 =?utf-8?B?YzZwN2tlUDhtTGxhZUNPZU5ZTWczSGl6TmlQcEE4YmIyYUIwSkM5MHN0K1dl?=
 =?utf-8?B?ME5CSnZaSWpvaUJwK0REWHRqK1prWUpweXBLUGt4NEVKRnhSTmVWbEEveFR4?=
 =?utf-8?B?VWdnR0FwOEdIR1NGMEc2VUQ1cTl4eGhvSlVFaWZHdlVCOWM2djFRZkZtRENJ?=
 =?utf-8?B?S3hwbW1FTUVLSmRsR2J5dWcrS3RxVXp1bUo4ZVhHTHh0aWdwMjk4WUpEanls?=
 =?utf-8?B?WUMzZkdkMko4c3pkRzNwZzhPN3JGNkRaeURxRWdndDZaS3NXZjFKWU50T3Bl?=
 =?utf-8?B?cU14QkRQNjdFdFp4SndaZ2J3MGloNDg3T2dUa00wVW01MzdUMnl4QUNYZjJO?=
 =?utf-8?B?OHVxSkRZS1NicTZSSGxJMkJPUHJZZWpXUm9CdTFEOVZOakhlaUpSNTNSc3BX?=
 =?utf-8?B?OHhrMCtNVnE3V1IwVGJiWjNNRjh6LzJ1K01PY0dZWGh1bHcvMUtmd3labDBr?=
 =?utf-8?B?U0pMVEl3K3d2bzlOZWI3OE83dk5CMDlzY2xPTFZ2Q04vTWZRUzY2MHJ3SmxC?=
 =?utf-8?B?TjlOUDZRWU50SDRsT3RZRkxTS2sxeUZGeDAySjQ3bHpiVFpjSnFxa0REeWdM?=
 =?utf-8?B?bTJCTkRVTHlRY09TbjEwSjhScHdLSXJiWVhTeVdldzVzdVowaXY4aVVZZ2ts?=
 =?utf-8?B?d0ltcW5aQlVnODhia0JWNVcxMVp2QUlydGVyWml6NnJWMEl3TnFCbDNyQXo0?=
 =?utf-8?B?TGFoWUtuM2xTUWdJRlRBQlFsd0ZBaEhYczJoYUtIRW1oTDRtcFREejd0aUZh?=
 =?utf-8?B?djRKYnlMaTIvK3JqeG43YS95MkFkZ1NpMXFqZlhsQTdBQmdTSnB2ZjJQZUZq?=
 =?utf-8?B?UnAraWUwdWR4Yzl1U0JLcm5lNWJVQ2l6emx1VnBQUFJvWVFwTWdHOGhJaDl4?=
 =?utf-8?B?S1MybHIzVmdKZGNYRVJNeVRKUUlESytGNkJpME5VWnU3RmtvTmJ0MUdrZXhp?=
 =?utf-8?B?N0NMMlJEdUlyd3NoN3NFMWErWmd2TEUrYk9GMVRWc3h6V3o5L0dLVWRnclhw?=
 =?utf-8?B?c3ZKZUlvREx5OEsrRXBUU2VCVDVoRzI4NTZyN0xnRS9yUThBNUx0MDNMajIw?=
 =?utf-8?B?eWRpQjE5MFpycGN3ZnpRaGtlZWpUeFdGaklpWjFObVlTejF4SUJ2ZDJuZTJC?=
 =?utf-8?B?VjZuVkZNL2E1S1lVRlVhZkYzTWo5UStZbFI2TTRDdmQzaHFFWENWd0RkZWc0?=
 =?utf-8?B?N0JnYkZuN0xZTmozTzFYVjhDSDRkak1TUUV2bnkrY1E2RmlydDlITjZhR3B2?=
 =?utf-8?B?eEdsZ3BUSlBIcGRqK29WTm5IeGdVRFViZ1ljWHNiZUpvbmxjc1JWZHlTTXFt?=
 =?utf-8?B?MCtCTXI0WFJJaXhoMlM2MUZ2T1RpWFdVZW5xekJtd0l4amRyUThvUVNCUDhW?=
 =?utf-8?B?a2ZUVFFmc3Fnd09CcHA2VUo3OWwyNGFYMmVjbVpsQy9rOWpzcFFXQ21OZ25D?=
 =?utf-8?B?ajZ4cXJ2SUMzQmNkMFZWTmhmbnV6M1FFdE83WlZRb083MFo5SDZ2bW8wTmVU?=
 =?utf-8?B?dEt6RE5SZ2hKZ3NFemdtWGdBTkhod294Uk9KKy96TVF2ZzhmZk9oT0tTalF6?=
 =?utf-8?B?bmlkZ0tnZHJ0MkhQUTAxWnFCNlY0ZmE2MEVHSzJIMkNyMVUxSkpLeWJTb3BH?=
 =?utf-8?B?RmF4clY5ZlR2RGhDVjlpKzNmRGhUTlUvSDBTU2drak5PSUhwRnNDSlo3NXhP?=
 =?utf-8?B?WFlEQXY4QmpFNllLNEVOczhpODVCQktJWDVSTTVjUDZTaGxDUFpsVmpMVjYv?=
 =?utf-8?B?NjAzeEhHNmVhNHVOdGcxMzlXdGNLN2txOEdnUmdsbm01S01Ua2wrZThWZzJB?=
 =?utf-8?B?NlJsc2tTVnRtUENmVDBwUU1aSWUvQitpUURvSHhtamU1QUt0WjVlL1RIME9O?=
 =?utf-8?B?bnJhdlArM0JINHoxRUpxQXFHR3Q5aWZBZEJ0aDlJeXNoaWJhUnFxc3dmT2Qr?=
 =?utf-8?B?eGxKUWpiOEE2OFlsdnkxNTJ3QzExQlRFQXFkZUdnam9qUE42bmxJOU42UDBY?=
 =?utf-8?B?TWVjanNQellFRWl3Q3dwSU9BTUFBLzk4cWJxYlIxWlhYZmd6aWlPaWRNOXZo?=
 =?utf-8?Q?yuox1HbHNAwJJDIoCu/RwlFes?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5989de9b-43ff-4634-d3f6-08da9b824e82
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5658.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2022 03:35:19.5502
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ivcwv+bCqDW2EUAIgH1tWJLtfIQA0Y8eWAZzbJDJDVatDKoRysuYA6BATXGmH0DP9rw5EyyLLOMfg3Y7//AUPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4560
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-6.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2022/9/21 10:44, Baolu Lu wrote:
> On 9/16/22 3:12 PM, Yi Liu wrote:
>> Check 5-level paging capability for 57 bits address width instead of
>> checking 1GB large page capability.
>>
>> Fixes: 53fc7ad6edf2 ("iommu/vt-d: Correctly calculate sagaw value of IOMMU")
>> Cc:stable@vger.kernel.org
>> Reported-by: Raghunathan Srinivasan<raghunathan.srinivasan@intel.com>
>> Signed-off-by: Yi Liu<yi.l.liu@intel.com>
> 
> Queued for v6.0. Thank you very much!
> 
> https://lore.kernel.org/linux-iommu/20220921024054.3570256-1-baolu.lu@linux.intel.com 
> 

grt. btw. how about below? not sure why it didn't show up in this series. :(

https://lore.kernel.org/linux-iommu/BN9PR11MB5276F062B5C0C08F10EFB49F8C4C9@BN9PR11MB5276.namprd11.prod.outlook.com/

> Best regards,
> baolu

-- 
Regards,
Yi Liu
