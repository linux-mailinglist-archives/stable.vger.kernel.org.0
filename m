Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 981866D0C94
	for <lists+stable@lfdr.de>; Thu, 30 Mar 2023 19:20:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231321AbjC3RUZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Mar 2023 13:20:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229798AbjC3RUY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Mar 2023 13:20:24 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4172A7D93
        for <stable@vger.kernel.org>; Thu, 30 Mar 2023 10:20:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680196823; x=1711732823;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=yyMjVusA52PBIki+WCXa0GmNpD7uws77VOXT1hFa3SQ=;
  b=BHI+LTOdYYTyTBtuleeCy6eQgiuFP1wVaNlSVDlnZZlhP/Ql0T5/UM6/
   VfL6E0na7tbj8XFdfdxcjSxHpOgJt5lAM/X5bSELECN117FEtDUiCMadV
   rOgg40qr4uw5LBy7SViD7cSGgfJwRBTFus3yekkpbr2b1kB8aG+LBAUxM
   DNHj//Cumc6jzkT/aZFPM0xRGG37+Q6n4hXHqmyrzqfsOn7N6oXFtj3v3
   8aRCQwsUAOGpwgGJEHs17ZIHULkVRPRrdUdtJBVB62hbjNU0BbYOjM8dd
   K3eTxmY1qwjBVFc1+slHxw9YomOB8ZBZWfjai8YT4T6xgeTxi2d+anONd
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10665"; a="342876414"
X-IronPort-AV: E=Sophos;i="5.98,305,1673942400"; 
   d="scan'208";a="342876414"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2023 10:19:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10665"; a="634998293"
X-IronPort-AV: E=Sophos;i="5.98,305,1673942400"; 
   d="scan'208";a="634998293"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga003.jf.intel.com with ESMTP; 30 Mar 2023 10:19:53 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 30 Mar 2023 10:19:52 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 30 Mar 2023 10:19:51 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 30 Mar 2023 10:19:51 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.100)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 30 Mar 2023 10:19:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AZHaPOwFCnx3qMFgTbLvd5UeniSFeH13dxC4n/IZlTGwKEgvOxzHnTHyGkfFuX3qM7h/JyCzJhHuVP/8por6naIefOSOdOyZ6jC32JAIlNAstpx5sL5QWGHPDnHvU3JtF340N0dnL99Sjfj3dn544BTNIfCJQ6Zyt4qVdIfxa3kCzbdaA8qSqVLcDvWuOuzfMlxFcvnFrBZzq1r6oNEGlav+8Yow4JA101l4f6mdqke1wYrPbfJw8F+OEyAvZ5kVelxHpV7a6aatfAznd08DixESDfc8p1ySwWWzmX3s5m6owaH8bs+qC55y96aEJh0U8eDNKH8jN6y11BA5erTknA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JEMxgHTdIYiLwuTYCrJujolhISO+/tTYYLmMDv4GeSs=;
 b=CdTqWLUJS1U1+A5XzQ0eeo6/sfs6jEFBJgqJAGfbi2qCRhmD5pzLnWlZPloB+QV5X3N/hX9ZudjKfj8xRjoZGM3mn7VgBta2paDQWc61+P/gRTyk0aOy37Aq+gAZgBSzh9mVW/e3+4crEqnkJbG8/eu5tRIDI6ceuyDBAkIXM327ecwwU7ezHODpl2LaMPd7jPWW802qdM4L8mOx80+t1cG09l4WpkRFEJ+ZzPbtSbA7EceUwYUIAys+K2EYSz3ADw+k1zr9neFVVJRfa5/9luiHHyk2UF/RcwCahne9ry5EN02U2jyisUzJ/OfNuw5teBK92mDPHMttKz6pu6Fjwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MN6PR11MB8146.namprd11.prod.outlook.com (2603:10b6:208:470::9)
 by CO1PR11MB4785.namprd11.prod.outlook.com (2603:10b6:303:6f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.21; Thu, 30 Mar
 2023 17:19:47 +0000
Received: from MN6PR11MB8146.namprd11.prod.outlook.com
 ([fe80::a6ec:a0c7:4dde:aa7f]) by MN6PR11MB8146.namprd11.prod.outlook.com
 ([fe80::a6ec:a0c7:4dde:aa7f%6]) with mapi id 15.20.6254.022; Thu, 30 Mar 2023
 17:19:47 +0000
Message-ID: <e2aab6c0-4cdf-f122-aa10-648191d06cc6@intel.com>
Date:   Thu, 30 Mar 2023 20:19:46 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.8.0
Subject: Re: [Intel-gfx] [PATCH] drm/i915: disable sampler indirect state in
 bindless heap
To:     Matt Atwood <matthew.s.atwood@intel.com>,
        "Kalvala, Haridhar" <haridhar.kalvala@intel.com>,
        <intel-gfx@lists.freedesktop.org>
CC:     <stable@vger.kernel.org>
References: <20230309152611.1788656-1-lionel.g.landwerlin@intel.com>
 <5a4a00f4-9641-0c8b-c0f8-2fc47dd91cff@intel.com>
 <ZCNvAOM7AuvpsRsL@msatwood-mobl>
Content-Language: en-US
From:   Lionel Landwerlin <lionel.g.landwerlin@intel.com>
In-Reply-To: <ZCNvAOM7AuvpsRsL@msatwood-mobl>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR0P281CA0011.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:15::16) To MN6PR11MB8146.namprd11.prod.outlook.com
 (2603:10b6:208:470::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN6PR11MB8146:EE_|CO1PR11MB4785:EE_
X-MS-Office365-Filtering-Correlation-Id: 6a39a2e8-b5a6-453a-dc2d-08db3142f628
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: USKNMc9UAM0iiOiVqTV4utw5Z0C7971K5Sf2GYLuRAVTmSe6d2IKqACOeqR7dNRGv4qHel9hwJWLF4yxfFmc2rS6BSPHTRu9L5c0ys7tB8PgoeFXbCwCcXes5AnyTHUPSo6XnyDFYYU+LezxyY+aT7PnUAc43JfRikdkAmb856cQlEP81Fi/p5f2cvIyGzVisaPrejkJ9dc4Wq0vZbM37QdUzfb2sWqfEepfNjqqbWn6NnS8tm96tpjszd2zKZVXmP6jjgTi0T2wXuMbrc6CuGmakUrvDxoevkaG7X0Fl6CINlaqF7ZQ7x2Q8inF6kPGZpUAgCppLCNHY3HOeHtKEi8Kd2+JYMqOIsk3OX/dPnz5Ox77WzFp+UEH0yJtam2ZCsyRiPV5gsypoU+Ovlf1M12x0J1tuYHxJRaef/G+Y/k6r3wrPvUscbBBbBqzY7/Dg9xnMCyxXRUfgOZ4ZWiHUstNQ8212KY0t/8OZ02RR11HqOFYzSrnRb1oPHqXpTkaiOlhVL7HzGo8KrojLOkxLbnWxM/4NOBqKC+WEHSUJHPTibvAgnThmHtPvgojuDz8WT+lwvH6JLLgtoblBEAM8Sb75AY8lAJ8xjWDzJZ2tAnLa+HXBbmjn4Fxa/ifwSjsqy8wGHoPDGHohahzEhVZfw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN6PR11MB8146.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(346002)(39860400002)(366004)(376002)(396003)(451199021)(2616005)(83380400001)(6486002)(186003)(6506007)(110136005)(316002)(2906002)(478600001)(53546011)(26005)(6512007)(86362001)(4326008)(38100700002)(36756003)(8936002)(5660300002)(66476007)(66946007)(41300700001)(8676002)(31696002)(66556008)(82960400001)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OVM4djRwRmZxc2d6aENxcElWWFU1QWowNFAvcG1SUmhOSEM5ZXVRa0ZkR2JV?=
 =?utf-8?B?dDVMaFhEZVRnbmFCWnZvYklUdklueFZIOXpqRmFia202RHRsenJYRjBHby9l?=
 =?utf-8?B?ZEVBODhuSEpzV1U3bGhOcnk4UHNxQkV4TzByeVFLSTQ4dmZRMFNEM1FhK1c3?=
 =?utf-8?B?UDJUNHdudmIvYi9lVkt3NFpXQXQ4RTFFOC8rdnJQVHh1eHM3dWNWQUdiOERX?=
 =?utf-8?B?UVpKUGZXMUtMQTJPU1JEODltMDFad3dFVC9kWEJoUHpubmJaUS9UaU50UTdL?=
 =?utf-8?B?bW44ZGswWStFZWtRamY1YlB3anN0OHF2WHpOZkVuVC9UVTByZ1ZFRTlFdUVx?=
 =?utf-8?B?Sjd6aTl0NURsbm5MRm1vbTNWMEZPM0c0QU9oQk9pSWRRMjRlZW5qZ1JPZ3p1?=
 =?utf-8?B?RHFVdGpkNmpyajFYRVNEbTdJQ0lLanJybzVpYm1hTENsaHdhc0lWbnZHWE8v?=
 =?utf-8?B?cC9hWFZKbnNPcm01cXZMODQzNEt6ZUVIY2ZWNnJVM3hrblloL0p4RlBYNGw0?=
 =?utf-8?B?bnZ6Ky9hVnVER2ZNc21PQWJiMjBtNlZuNnV3OVJUOW9wbFE3YWQrd09TSGw3?=
 =?utf-8?B?djdFM2VFY2dMMkRZbStTN285TGt1ZjNGOUFMYlpCb3g1eGxwY2pGSzdNVW1N?=
 =?utf-8?B?akMrQUJrTWJOU0JYajBSUG5sbDVPVjR2VWdJOUdFdS9DMklFRVdmSzlrWXlX?=
 =?utf-8?B?bGdYazJCdTlYUDZJOW83ZkJheFYwVEE4ejNzR2VDTC80UUhta2pLZVpwb3Vw?=
 =?utf-8?B?ZmRCeVpCWnVXMktkc0xFRmVyNHpiVUo3SlJUV0VuNlpnMlFBenRhcVkwUENl?=
 =?utf-8?B?aWZkeEVhcEU2VzNqL2cwNTlKUW5wNEhhb3cybnZrU1J3dEp2VzA0RTJ2VHoy?=
 =?utf-8?B?ZlhwMUo5ZGlWdE9rTnBGWFhBTCt2ZGFndUpEWWZDRk9DKzFiSG9kOFZJQ0xH?=
 =?utf-8?B?Mi9LTXhQWXY4QjRkdmFLNUVjQWZ2UUNrTzNaM1FESHdTcmVZY2xMKzhURnQ5?=
 =?utf-8?B?MWNrN1hoUlpDS2Nrb3hHSVQvQ3RlZlVMZkN0QVFaWTdJTGlTQ3VBTlNlMHFO?=
 =?utf-8?B?b0JGTDZpUkNKREVjOWVmNVlMN3hWVlZ2THRGZlFNbGcvaEpWUVpkeCsxWWNR?=
 =?utf-8?B?c3VPQkRVeXVZcG5aVnY4ZUdqT0k3bUYrb3c2azREcWJtRXJGNUdxUW9WaGRH?=
 =?utf-8?B?UFZUL2JKMUpKQnMrbHlJQ1ljSDlwZStmSVlpWHVxZTBjRUsvK2ljZmV5QzBq?=
 =?utf-8?B?U0E0WXRCcVFLQlgydEI0TXg1eFZUK3krRjNKbGVtSG9Udlh0UjVNOG9GbHZQ?=
 =?utf-8?B?RVFlMDB1OWQ0SXMxa1R3SnNaS1NWdFUybW9JZGlFMi9QWTNXbnVkRFRyckk2?=
 =?utf-8?B?bStNeVZWNGFXYWtwaWhJVk5TNkFtVzNialFnQUUvNEZNYjlHM0ZHSlFzbGdJ?=
 =?utf-8?B?NkREMXdRdSs4c3I1dkxBWTExRWcrL25tVnZmaGlkTTFySysyU25laTJ3WU9T?=
 =?utf-8?B?L21DblBiVnJzTytPVlpPVzJvcGNDLy85M1FlVEJReU95Y0J5MmxQbUhjb0Ry?=
 =?utf-8?B?K0FMY2xCRFBOelVqTVlzT3JKRWhzYzZwbGM0N2pCUGV0Zm5BNXNWcnBVSDRN?=
 =?utf-8?B?eGRnakJtWTh3MnU3M3JaSG90dnBjK0NsTEd6QkpJMndaNGFydkhWeGxSNlJX?=
 =?utf-8?B?ZWJBeTF4Mmx3NXYzOVJkQ2FZdTB6SXQzWmU5YlNua2VNdnNEV0c4TkhLZThG?=
 =?utf-8?B?elVLV0E4WUZtTGVTNEVJaGQ3dGZTai9oSncvWE5sRnoyWGdPWGdIOWhRdEwr?=
 =?utf-8?B?bDZ3b3owSFFXK1RvSDRJVGo2d3JPQWhQaTkzYmlFa3JxVzIvTS85cWlzdmpl?=
 =?utf-8?B?V3RnWW9PZGovVnczYVFFd0RvNVhjOStJd0RTcXQ0empIMzl3c3oyWjBzaUc0?=
 =?utf-8?B?a21qWkR4bDBtdVNoWjNHWlhVT01GUGVUNmYzNmYyVTJSVkVlRzZ1M1V5eCtk?=
 =?utf-8?B?RDZZT1A5MUpLSnVoY3A1ZUhWRFhncmNqNjhsQWVTRm5Ld1M1Mit1dE8rSS81?=
 =?utf-8?B?S0tFZW50WXdJR3ZFTGtSSTZBRUlLZDZhOWpzdjZnR2ZmRFc4RWZFRGdYZ0lr?=
 =?utf-8?B?VmNyVGsrNDg5a1lvc2lVVHBWNWJCNEluaXRQS21BbEcvMi9ORkNMdUlINlk4?=
 =?utf-8?B?bGc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a39a2e8-b5a6-453a-dc2d-08db3142f628
X-MS-Exchange-CrossTenant-AuthSource: MN6PR11MB8146.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2023 17:19:47.2902
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wxG7pB8Ocbxure8Ila9VhyhtvWHHHczxFWex7V8aXQUbfJOBw0FtYTnqNnT3Tn45uXSyd896af0rxD8Gz0UEF+I0hu67NIcZKl1pSLXlm6s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4785
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 29/03/2023 01:49, Matt Atwood wrote:
> On Tue, Mar 28, 2023 at 04:14:33PM +0530, Kalvala, Haridhar wrote:
>> On 3/9/2023 8:56 PM, Lionel Landwerlin wrote:
>>> By default the indirect state sampler data (border colors) are stored
>>> in the same heap as the SAMPLER_STATE structure. For userspace drivers
>>> that can be 2 different heaps (dynamic state heap & bindless sampler
>>> state heap). This means that border colors have to copied in 2
>>> different places so that the same SAMPLER_STATE structure find the
>>> right data.
>>>
>>> This change is forcing the indirect state sampler data to only be in
>>> the dynamic state pool (more convinient for userspace drivers, they
>>> only have to have one copy of the border colors). This is reproducing
>>> the behavior of the Windows drivers.
>>>
> Bspec:46052


Sorry, missed your answer.


Should I just add the Bspec number to the commit message ?


Thanks,


-Lionel


>>> Signed-off-by: Lionel Landwerlin <lionel.g.landwerlin@intel.com>
>>> Cc: stable@vger.kernel.org
>>> ---
>>>    drivers/gpu/drm/i915/gt/intel_gt_regs.h     |  1 +
>>>    drivers/gpu/drm/i915/gt/intel_workarounds.c | 17 +++++++++++++++++
>>>    2 files changed, 18 insertions(+)
>>>
>>> diff --git a/drivers/gpu/drm/i915/gt/intel_gt_regs.h b/drivers/gpu/drm/i915/gt/intel_gt_regs.h
>>> index 08d76aa06974c..1aaa471d08c56 100644
>>> --- a/drivers/gpu/drm/i915/gt/intel_gt_regs.h
>>> +++ b/drivers/gpu/drm/i915/gt/intel_gt_regs.h
>>> @@ -1141,6 +1141,7 @@
>>>    #define   ENABLE_SMALLPL			REG_BIT(15)
>>>    #define   SC_DISABLE_POWER_OPTIMIZATION_EBB	REG_BIT(9)
>>>    #define   GEN11_SAMPLER_ENABLE_HEADLESS_MSG	REG_BIT(5)
>>> +#define   GEN11_INDIRECT_STATE_BASE_ADDR_OVERRIDE	REG_BIT(0)
>>>    #define GEN9_HALF_SLICE_CHICKEN7		MCR_REG(0xe194)
>>>    #define   DG2_DISABLE_ROUND_ENABLE_ALLOW_FOR_SSLA	REG_BIT(15)
>>> diff --git a/drivers/gpu/drm/i915/gt/intel_workarounds.c b/drivers/gpu/drm/i915/gt/intel_workarounds.c
>>> index 32aa1647721ae..734b64e714647 100644
>>> --- a/drivers/gpu/drm/i915/gt/intel_workarounds.c
>>> +++ b/drivers/gpu/drm/i915/gt/intel_workarounds.c
>>> @@ -2542,6 +2542,23 @@ rcs_engine_wa_init(struct intel_engine_cs *engine, struct i915_wa_list *wal)
>>>    				 ENABLE_SMALLPL);
>>>    	}
>>> +	if (GRAPHICS_VER(i915) >= 11) {
>> Hi Lionel,
>>
>> Not sure should this implementation be part of "rcs_engine_wa_init" or
>> "general_render_compute_wa_init".
>>
>>> +		/* This is not a Wa (although referred to as
>>> +		 * WaSetInidrectStateOverride in places), this allows
>>> +		 * applications that reference sampler states through
>>> +		 * the BindlessSamplerStateBaseAddress to have their
>>> +		 * border color relative to DynamicStateBaseAddress
>>> +		 * rather than BindlessSamplerStateBaseAddress.
>>> +		 *
>>> +		 * Otherwise SAMPLER_STATE border colors have to be
>>> +		 * copied in multiple heaps (DynamicStateBaseAddress &
>>> +		 * BindlessSamplerStateBaseAddress)
>>> +		 */
>>> +		wa_mcr_masked_en(wal,
>>> +				 GEN10_SAMPLER_MODE,
>>   since we checking the condition for GEN11 or above, can this register be
>> defined as GEN11_SAMPLER_MODE
> We use the name of the first time the register was introduced, gen 10 is
> fine here.
>>> +				 GEN11_INDIRECT_STATE_BASE_ADDR_OVERRIDE);
>>> +	}
>>> +
>>>    	if (GRAPHICS_VER(i915) == 11) {
>>>    		/* This is not an Wa. Enable for better image quality */
>>>    		wa_masked_en(wal,
>> -- 
>> Regards,
>> Haridhar Kalvala
>>
> Regards,
> MattA


