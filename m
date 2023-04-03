Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D89746D502F
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 20:23:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232677AbjDCSXM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 14:23:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231538AbjDCSXL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 14:23:11 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5D802704
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 11:23:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680546183; x=1712082183;
  h=message-id:date:subject:from:to:cc:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=dHa11TIDPcCky1965VOO0Fy5DV3Z+KJKVqhABs/Yx/4=;
  b=BVtlgp2kkyAytMmE4NOe2g6h6K28btybdPKfCRJ1mecmz/9SJPew63D4
   xpi3VbHhR8O0T3miiTebGfUiFxZrOWEgTbmJPKhn8stN838zaDfHmMf2d
   WFBqbqggsUiF7c+Zw4T1/iv95I8l8FtSCjIRjgs5kk40Li9d2DMlnFMky
   qBnGBzLBJgi4zqCzNiqLwhXz//YX3u2CnJj+uvfka2DiKBttY/ijF+9+j
   7YDYz5GVQPeHXLrPsJxo0pWTGVE3MUYEijAOTSZicc0l17WuXMsUSmOpt
   jF8UH1WpTqr23fPQgidhIy0+mJxuk274I64m3SwJXi8sVWGB3gVAovcBY
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10669"; a="343677170"
X-IronPort-AV: E=Sophos;i="5.98,315,1673942400"; 
   d="scan'208";a="343677170"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2023 11:23:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10669"; a="809929970"
X-IronPort-AV: E=Sophos;i="5.98,315,1673942400"; 
   d="scan'208";a="809929970"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga004.jf.intel.com with ESMTP; 03 Apr 2023 11:23:02 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 3 Apr 2023 11:23:02 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 3 Apr 2023 11:23:02 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Mon, 3 Apr 2023 11:23:02 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.47) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Mon, 3 Apr 2023 11:23:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P+bsu3Fy8IsY8udc3oSHjqxVHQw8RBfwYzimsx1BwVqXNMDzRDssKoU6sL7KGdeKymGGEoydi/44L04+XkLJCr8cILt2R5fuGDHaeTmccHary/Sfdir+pQgUC5iZpwIfa62eQPPYFGVGb+cdKNcA4Oh9P5Htn3kOByEz8/E8+U16hwSb7sNYPqRLzxO9ElOFMxzr+FeiQKGVh127CC0CmV5J7XdHznFus2JOXhY6TKZvLh7MEf49np0iZedaCe9u/cIZi8uBBuhkOBaHN6+R7wx2pJM1VQJDAa/7Ia2eTrssGCwNjZR7q7I1zxIDuvXxMjL4xxeEPGHtY8mznzfLtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/o+BUtrnKOTk9nqFDnuec5qYl+xEyP5N3a+sfQoqnfg=;
 b=nnn/Uj3zIx9kcosgV4o71p15ptl9bXKDg5dj+zx+lpKz/+VAxoN/0JuBUe0QueDilzbd60a2RhCXvkqRCa+wrugxwmDfL7T7Vb2iSMjf6lJVXNidVOr+WqB9KmxpLjijdLzvcWW++tfVnO61Qx07MKi/uxzWEyIBcFQtqqJFKg6zWS3BQzgM8iFE25IlTuGizngeY1oVpAX//JL2hK23H33nBqKVtQYWGEqODDbJN6K8K+87eJUE7gc6Trp568oSqtYAfLHik9ZsiWA4cW5SG/GZ0Hpo4RwRTdzIgns9RYr+wpanLbcZS6y47FbJ/hJcA/ukIpiea1Kprg52RDh9dA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB2907.namprd11.prod.outlook.com (2603:10b6:5:64::33) by
 SA1PR11MB6662.namprd11.prod.outlook.com (2603:10b6:806:256::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.29; Mon, 3 Apr
 2023 18:22:59 +0000
Received: from DM6PR11MB2907.namprd11.prod.outlook.com
 ([fe80::22a6:927d:6b03:69ee]) by DM6PR11MB2907.namprd11.prod.outlook.com
 ([fe80::22a6:927d:6b03:69ee%7]) with mapi id 15.20.6254.033; Mon, 3 Apr 2023
 18:22:59 +0000
Message-ID: <c4b977c6-4df2-a1f0-ab34-52c7d0e0193d@intel.com>
Date:   Mon, 3 Apr 2023 23:52:49 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [Intel-gfx] [PATCH] drm/i915: disable sampler indirect state in
 bindless heap
Content-Language: en-US
From:   "Kalvala, Haridhar" <haridhar.kalvala@intel.com>
To:     Lionel Landwerlin <lionel.g.landwerlin@intel.com>,
        Matt Atwood <matthew.s.atwood@intel.com>,
        <intel-gfx@lists.freedesktop.org>
CC:     <stable@vger.kernel.org>
References: <20230309152611.1788656-1-lionel.g.landwerlin@intel.com>
 <5a4a00f4-9641-0c8b-c0f8-2fc47dd91cff@intel.com>
 <ZCNvAOM7AuvpsRsL@msatwood-mobl>
 <e2aab6c0-4cdf-f122-aa10-648191d06cc6@intel.com>
 <c2ea8625-7f46-e05e-4b71-6d5bf9d22deb@intel.com>
In-Reply-To: <c2ea8625-7f46-e05e-4b71-6d5bf9d22deb@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PN3PR01CA0117.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:96::21) To DM6PR11MB2907.namprd11.prod.outlook.com
 (2603:10b6:5:64::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB2907:EE_|SA1PR11MB6662:EE_
X-MS-Office365-Filtering-Correlation-Id: 98800082-e6d0-4694-383b-08db347073f8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mqaIbixBevL53TlI57oY0z84usk0BvNEXcN2CxwOrjvxakdDSVNjpeMdXh9moNtu1saLTuhFA82mEXp4sfWM45vmiZ0b5el6YGTULcoBeC8/9d5TQC/1z0B2t4PmBaP1HqhowJIH+LGMs7UzSb4SnTiOz/0dTh+AZvbLkCwRCCPH9SuJqEWX587rdN1NYZCV/vqgduaF4ZRG5on6sP0mhmSBZShHoX+u7BfjU5twbr6Y4PrYzccCnXJKau8/6yjbD9lhSF1Okb5EqpVavPPdYhEUcMZ9ecNcm3IlWA0/jZcGTwstsd/tRUr0/fJgDdf7g7sAWGyFEYxraReanpPRI0tQQXGV6lnIOS/R0DVAYnh/mv51jcFUkfK8/ZG7s6yZjhp8FW3/LTqIEsngC+mVTSt8fbTXSb1TNTZdf+WuPUg/LVRLreNUtcbTZu1uARevxbm3M1iZWg3jsKKeCG7IOX7KFTg4UYx+4dhC4Tp87x5E3rJaLxb0fLsFKiPiZlfzbzfabUSsXSAEG+eiCQqe3QZENwGSmfN6KN0MfAqXaXlfygJp2UaVcVyttt7yhKuojcqABEbhS8DPHiXHD5eBuBv1eTA75DAzcmSLzXrOJLtToc6dKZgLLyPdLO4SIS5zg7pB1dSc3+U19I/UHPtWmg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2907.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(346002)(39860400002)(366004)(396003)(136003)(451199021)(36756003)(4326008)(6486002)(8676002)(66946007)(110136005)(316002)(66476007)(66556008)(478600001)(41300700001)(8936002)(2906002)(82960400001)(5660300002)(86362001)(31696002)(38100700002)(2616005)(6506007)(53546011)(6512007)(186003)(6666004)(83380400001)(31686004)(26005)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c3ZoQ0FNU1V0ZXc1dmg5UnFJYXhGNVhLSkNKdFdiNS9MNDBCT1M0dy9YQTJM?=
 =?utf-8?B?SEdPY3pSSWx5a0VRbzZvTGpSeE83Wjg4Z0RpVkErMW4vZEJzK3RpQ2tJZm1J?=
 =?utf-8?B?ZUVVVmUyUWRCQm5qVVRDcjlPMit0dVRvZ2t6MjQ5anpZWmtLdGVKUFQ1NTBY?=
 =?utf-8?B?bGNsbDdMb291ZjVOSEhqZGJ2aTNtMGhIeUFSSGFNSExpZVlBRmIvTklzbFp5?=
 =?utf-8?B?WW9YWWpQSS9QWUsxSGc1a2lJeUZHdDllRVIxV3ZocmlJZDM1QTlFSFR6aWEx?=
 =?utf-8?B?OTdxWVdYVGVqVUcyd0cxMmV1eW1qNy9rRFVDSTRwTlNNVzNnT2c2Q2UzUDRR?=
 =?utf-8?B?em54Z3AzQTdtNTNsaFBtUEczRUdDTHU2UHE1TEIyN3VGN0h3Ymc4Ti9qWTdS?=
 =?utf-8?B?bHpWZmRQWjVyMkxiNERWRHoyZno0Z1MrNkpXY2FHQ0tabGVvallUTkNWUWNV?=
 =?utf-8?B?WkhvamdpOTA2Ykp2RUdPWkw0d21kM1RhalZhdkZwd3pDSHQwV2JhbGgrQmRu?=
 =?utf-8?B?MngvRGJpeHlQWGtqUWhzcllDYVZjeHA1bWJEZHVDbmRvbitwZklhZUFwdlh4?=
 =?utf-8?B?UzBYMFFSdk5wMXp3SkkvOFBtQXNKbGNWRzJHanJ1ZU9Dby9TOU8xTzZDWVNP?=
 =?utf-8?B?d1pHQzhMN1NXNkNFcGhPbHkrK0tJNWgvYTVISElCTDc2bStscEpHdVVkQTk2?=
 =?utf-8?B?NWxoR2duYm1hS0FWaFd0WVNqODBkY1lYa2JjZ0FySmdjOGFndDhmWXo4MmNW?=
 =?utf-8?B?QlBkRkxNMlZ2OWh3VUc5T0x1T01IbU1pU29GbFdoUTMydDJLaG5oalhHSC9j?=
 =?utf-8?B?YTRRWUVrclB0b3F2WUJUMzdaVkdtcDBzbEtXWk1QTXZldUVMUWZDRTZMOEN1?=
 =?utf-8?B?NDJhd3Q2MkhTekVsR1Z2bkxUUFkvdGltdksvYlkxdWNOTEFMN0ZuUEowcGI5?=
 =?utf-8?B?dHpiSjkzUjM3aittR2tUdUF0VDlleCtYYVE3aVNiWE1nMGpsTkIyMkthZnJE?=
 =?utf-8?B?ZUI3WWVUS045UmtYNUV1MVJZSm8rVEExZWsyaGFheUErZjNRRG4wSFpxVjQy?=
 =?utf-8?B?ZlBIaXYwV0FJclZ0bmxvOE03Zk9sbWs5eUN0VTJ6ZXZwcTZsMVBMYXNUWGcw?=
 =?utf-8?B?bSt4b3hJLzFLMEdlTExNY2tHZ0hydjlCd0VOeWZOdk8xSEtJN2prZE85U056?=
 =?utf-8?B?SmtKQkxlVnIzVmxnS3pLRmhTUVhzYkhLVGhxWDNmdFJXa3p6VkdSdVoxblAv?=
 =?utf-8?B?NjgxRTlXMWlSUW94QzE2RVY0Ym4vYUxKMk1lVzVMYzd1MGFMTURQVmJqcXgw?=
 =?utf-8?B?VEhMYVNrWGx5UXVrckpsMnB0NEFHV25rUlExWlFsZnF2bU9GcHRzYmxkRi9Y?=
 =?utf-8?B?eHczWVBuVmxmNTlpVHdjamtnZkxNWFJnUkJlTDdocnVvMndTMVhWTVFSRExQ?=
 =?utf-8?B?TWFSMHdPaVRrNUR1WDBoY2t0YXZVS3V4dnliRnY4UFo5bXFFdHhrN3ZIUEIy?=
 =?utf-8?B?ZEtHUnJleFNhSS9SU3M3ZjZiclZSVjBMd3VzelF3S1ZCRFJCNFNzSkpKSkZ1?=
 =?utf-8?B?WlI1RUZzYjdxMzZHK3FxVkh5NWh5TlZ6TmJCZExqK2ZBeGVtNzFEbzRMVUdh?=
 =?utf-8?B?NURhN1J0SmNoWjE3Mlp2VHhjc3VIK2sxZmZrdXQ3OUY5SDZSMlhjTkNXbElL?=
 =?utf-8?B?Z0xOdXFLZXRVOFpHUjFDdjh1WmJQRHpDaGMrNm9XdkptTGtlQWtYajFnaExX?=
 =?utf-8?B?SlhtSWNTS0NSR1ZaVFhoZjg5dWRRL0wvOXN0Yk85K3NydGNTVnBxZlhNR2FS?=
 =?utf-8?B?U1pyY1hRc0VSK3NrYlRaczdzR25DSlhXN3MvSExRNmd0V1B2YXhJdElEbUIz?=
 =?utf-8?B?Vm4vMlpqVVlWMjA5eGdGYlhwVzJ2clZ4b2FSRlFRSGZwRnJIZ1pmZkhLRS80?=
 =?utf-8?B?TVFoOHc1QVR0ZW02MnJyR211S3d5bGo0K1l2SWN3cDJLeldiZUdZZDMvWFNH?=
 =?utf-8?B?eForS0U3V0NQTG9DSXY1UGI4UWtQc2NFL2N1K280dVhrYlFHcHpVMFM0TExY?=
 =?utf-8?B?Q2F6OWRWamZLZkRXNS9VMFgwVUpXckdaZ29HNE5FS2pxUjBuY3JpWXlrK0NH?=
 =?utf-8?B?SmFlNkFYMjM5bnhwRDk3OUpCSU12MTJRL2NPZzAxbDdUa1lUZEZzYk9wYXBY?=
 =?utf-8?B?QVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 98800082-e6d0-4694-383b-08db347073f8
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2907.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2023 18:22:59.4519
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ml9KpaGdzyV7Q5ufHqTrzst0FPRGd/1J8svrxwfLhbdKLnYgclwEKLX5htsyZAd7InAirOX2Rma7+/7HDSBCBnb9wJQOOyfvFjejiooNhGQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6662
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-3.8 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 3/31/2023 12:35 PM, Kalvala, Haridhar wrote:
>
> On 3/30/2023 10:49 PM, Lionel Landwerlin wrote:
>> On 29/03/2023 01:49, Matt Atwood wrote:
>>> On Tue, Mar 28, 2023 at 04:14:33PM +0530, Kalvala, Haridhar wrote:
>>>> On 3/9/2023 8:56 PM, Lionel Landwerlin wrote:
>>>>> By default the indirect state sampler data (border colors) are stored
>>>>> in the same heap as the SAMPLER_STATE structure. For userspace 
>>>>> drivers
>>>>> that can be 2 different heaps (dynamic state heap & bindless sampler
>>>>> state heap). This means that border colors have to copied in 2
>>>>> different places so that the same SAMPLER_STATE structure find the
>>>>> right data.
>>>>>
>>>>> This change is forcing the indirect state sampler data to only be in
>>>>> the dynamic state pool (more convinient for userspace drivers, they
>>>>> only have to have one copy of the border colors). This is reproducing
>>>>> the behavior of the Windows drivers.
>>>>>
>>> Bspec:46052
>>
>>
>> Sorry, missed your answer.
>>
>>
>> Should I just add the Bspec number to the commit message ?
>>
>>
>> Thanks,
>>
>>
>> -Lionel
>>
>>
>>>>> Signed-off-by: Lionel Landwerlin <lionel.g.landwerlin@intel.com>
>>>>> Cc: stable@vger.kernel.org
>>>>> ---
>>>>>    drivers/gpu/drm/i915/gt/intel_gt_regs.h     |  1 +
>>>>>    drivers/gpu/drm/i915/gt/intel_workarounds.c | 17 +++++++++++++++++
>>>>>    2 files changed, 18 insertions(+)
>>>>>
>>>>> diff --git a/drivers/gpu/drm/i915/gt/intel_gt_regs.h 
>>>>> b/drivers/gpu/drm/i915/gt/intel_gt_regs.h
>>>>> index 08d76aa06974c..1aaa471d08c56 100644
>>>>> --- a/drivers/gpu/drm/i915/gt/intel_gt_regs.h
>>>>> +++ b/drivers/gpu/drm/i915/gt/intel_gt_regs.h
>>>>> @@ -1141,6 +1141,7 @@
>>>>>    #define   ENABLE_SMALLPL            REG_BIT(15)
>>>>>    #define   SC_DISABLE_POWER_OPTIMIZATION_EBB REG_BIT(9)
>>>>>    #define   GEN11_SAMPLER_ENABLE_HEADLESS_MSG REG_BIT(5)
>>>>> +#define   GEN11_INDIRECT_STATE_BASE_ADDR_OVERRIDE REG_BIT(0)
>>>>>    #define GEN9_HALF_SLICE_CHICKEN7        MCR_REG(0xe194)
>>>>>    #define   DG2_DISABLE_ROUND_ENABLE_ALLOW_FOR_SSLA REG_BIT(15)
>>>>> diff --git a/drivers/gpu/drm/i915/gt/intel_workarounds.c 
>>>>> b/drivers/gpu/drm/i915/gt/intel_workarounds.c
>>>>> index 32aa1647721ae..734b64e714647 100644
>>>>> --- a/drivers/gpu/drm/i915/gt/intel_workarounds.c
>>>>> +++ b/drivers/gpu/drm/i915/gt/intel_workarounds.c
>>>>> @@ -2542,6 +2542,23 @@ rcs_engine_wa_init(struct intel_engine_cs 
>>>>> *engine, struct i915_wa_list *wal)
>>>>>                     ENABLE_SMALLPL);
>>>>>        }
>>>>> +    if (GRAPHICS_VER(i915) >= 11) {
>>>> Hi Lionel,
>>>>
>>>> Not sure should this implementation be part of "rcs_engine_wa_init" or
>>>> "general_render_compute_wa_init" ?


I checked with Matt Ropper as well, looks like this implementation 
should be part of "general_render_compute_wa_init".

>
>>>>> +        /* This is not a Wa (although referred to as
>>>>> +         * WaSetInidrectStateOverride in places), this allows
>>>>> +         * applications that reference sampler states through
>>>>> +         * the BindlessSamplerStateBaseAddress to have their
>>>>> +         * border color relative to DynamicStateBaseAddress
>>>>> +         * rather than BindlessSamplerStateBaseAddress.
>>>>> +         *
>>>>> +         * Otherwise SAMPLER_STATE border colors have to be
>>>>> +         * copied in multiple heaps (DynamicStateBaseAddress &
>>>>> +         * BindlessSamplerStateBaseAddress)
>>>>> +         */
>>>>> +        wa_mcr_masked_en(wal,
>>>>> +                 GEN10_SAMPLER_MODE,
>>>>   since we checking the condition for GEN11 or above, can this 
>>>> register be
>>>> defined as GEN11_SAMPLER_MODE
>>> We use the name of the first time the register was introduced, gen 
>>> 10 is
>>> fine here.
> ok
>>>>> + GEN11_INDIRECT_STATE_BASE_ADDR_OVERRIDE);
>>>>> +    }
>>>>> +
>>>>>        if (GRAPHICS_VER(i915) == 11) {
>>>>>            /* This is not an Wa. Enable for better image quality */
>>>>>            wa_masked_en(wal,
>>>> -- 
>>>> Regards,
>>>> Haridhar Kalvala
>>>>
>>> Regards,
>>> MattA
>>
>>
-- 
Regards,
Haridhar Kalvala

