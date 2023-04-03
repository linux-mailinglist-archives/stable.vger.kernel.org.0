Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C75D6D5410
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 23:59:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231794AbjDCV7x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 17:59:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233195AbjDCV7w (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 17:59:52 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B7B4213D
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:59:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680559191; x=1712095191;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=JXI+H84oZX7s8GpAi3p/LNNnNGjR8U/wm5lm3kV7wwg=;
  b=R2cH88wFwAKrxDgCSMgj8Q3pNJDAWrAD8HvJNlBfNWQAJrCpTORvMlnh
   TqA3ctE71DM2jVf1srRsdZcVVjKDDBjOpAyN4vsXmwraQVpkio0Kr1Nge
   3aJ6wut16oK71K7PRxR2wzo//oIR55Ztf0AOS1RygQb4Em344x/uaPuQt
   vsw3MoLzqIYiPuM7Fzfgh9mHtIIOrTARmv1F0QmrsiK0uj4G/wPIIwrQu
   Mj5wA8iJmR7SJu1mIneO4BtnFFxIq+b4dGqK6T+XkAp1a1rCuWJF94tq2
   X8JXkAOGaSVRmiljwvys5Lx0wd4GlksUqrzmGv/iaC5aC6m+t7woNkKQf
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10669"; a="330601863"
X-IronPort-AV: E=Sophos;i="5.98,315,1673942400"; 
   d="scan'208";a="330601863"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2023 14:59:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10669"; a="1015872333"
X-IronPort-AV: E=Sophos;i="5.98,315,1673942400"; 
   d="scan'208";a="1015872333"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga005.fm.intel.com with ESMTP; 03 Apr 2023 14:59:50 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 3 Apr 2023 14:59:50 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 3 Apr 2023 14:59:49 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Mon, 3 Apr 2023 14:59:49 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.45) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Mon, 3 Apr 2023 14:59:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ok9XswxxYyxGAENERIRAA2t5zeZeevKxi7hdEGtY0IYKfHOoKD8gHxxGxhqtIe8gOTopvQFpN4izRpGuYPkZPUFU1m86khlM0elJrCwunf3Ul8qwrScoNQYZnGF1zOcBwLkzH+a1tqAfet+36FA4UdYukPAf+9RVEnCBsY0v4Ppz7D2gT+cvsmFEljs1Ekc1FCSBzlPfwboqFBgAXmCtLX6d6FitqDczVhIwAEwATlPbnuRErFgcx78uAo7X1wVQ9y3CRW2XpO2gSbuK0WjLEcR5ZTq6NGXKLoWQqrPY1XPBQ8MnOQD4a+V9xCGsNJk61nSbnXgw/DYOjetlmNrLPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z9K6yuflqSGPEDwS3W8srDOKSRKHILflV3oS3d4ZiU4=;
 b=Og/hrgUb5vt0rWTzilYANuTDoBzcxc9NqP3aCLabRSD4M2uP/Ls1faR9nNQRQbdgekTrMZOoOy1rvYTsARMCqu3aNRP9DCOixJ/JJT7Ox72vs7+6anY7Im3K9fdXh4tqIoSOJbx+pz20Q9OIqSYYwKSdeMrAZkQn98uXgF2pEqFH8BNCSysxV7j4/aVGUmc0ecQUVHUc/KB16/+4lZTDe4RU2OETY/hpS0Q2jGxhmWjOe3RE7jxCAqCZfNGrZZtyk8TFUe9cD3ALfRh9B8YDICeBlfga/4Xf+7m2DZyVI4RY+9/ymG69xyrXiF6KXIG4KO/R7FVCS9bwp2dVTsm4Fg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MN6PR11MB8146.namprd11.prod.outlook.com (2603:10b6:208:470::9)
 by SN7PR11MB6680.namprd11.prod.outlook.com (2603:10b6:806:268::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.30; Mon, 3 Apr
 2023 21:59:48 +0000
Received: from MN6PR11MB8146.namprd11.prod.outlook.com
 ([fe80::a6ec:a0c7:4dde:aa7f]) by MN6PR11MB8146.namprd11.prod.outlook.com
 ([fe80::a6ec:a0c7:4dde:aa7f%8]) with mapi id 15.20.6254.033; Mon, 3 Apr 2023
 21:59:47 +0000
Message-ID: <6d41b5f8-75be-b910-de59-3a02bceda6ef@intel.com>
Date:   Tue, 4 Apr 2023 00:59:47 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.9.0
Subject: Re: [Intel-gfx] [PATCH] drm/i915: disable sampler indirect state in
 bindless heap
To:     "Kalvala, Haridhar" <haridhar.kalvala@intel.com>,
        Matt Atwood <matthew.s.atwood@intel.com>,
        <intel-gfx@lists.freedesktop.org>
CC:     <stable@vger.kernel.org>
References: <20230309152611.1788656-1-lionel.g.landwerlin@intel.com>
 <5a4a00f4-9641-0c8b-c0f8-2fc47dd91cff@intel.com>
 <ZCNvAOM7AuvpsRsL@msatwood-mobl>
 <e2aab6c0-4cdf-f122-aa10-648191d06cc6@intel.com>
 <c2ea8625-7f46-e05e-4b71-6d5bf9d22deb@intel.com>
 <c4b977c6-4df2-a1f0-ab34-52c7d0e0193d@intel.com>
Content-Language: en-US
From:   Lionel Landwerlin <lionel.g.landwerlin@intel.com>
In-Reply-To: <c4b977c6-4df2-a1f0-ab34-52c7d0e0193d@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR3P281CA0143.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:95::6) To MN6PR11MB8146.namprd11.prod.outlook.com
 (2603:10b6:208:470::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN6PR11MB8146:EE_|SN7PR11MB6680:EE_
X-MS-Office365-Filtering-Correlation-Id: 7dd12012-d6fb-49a7-d6c6-08db348ebd6c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JeWv4KOAYgj1gTknM9A1F7rR5DiohKMZQ0gkbu4B5A17nfXGUM8/uBY8pd45xBnzk32c7LixoG1C2GLkKAhc22AqCUAIZdOTumK0FzbPsm3iWc4oqV+JtG7fwXJHSJt1baHW+hmzdLmDSLmUaLn51msGkKEQvxBwh67UP2Ew3WcfpnzAQ2sRFBMyiljGicpkTKo0uVfZSgRep4FJqKgh+dc57I8hpVpWpYeCrvdgHBz6Kd6bm8KW3A6/OunKL4ivoZASOxZEyHgSN2fhToXP1Rtpjx1yXemg2DH9aWyr2/hLI1FQxn28lo4NDynbBVMXRbE9tK0+3/ukPrdN9PXjFQt1e7mQEx27u5MRYO1AUTVJdmydH6voc2DE89uXOSwiJe3APe59fFoY6Ne0oxx3huJIo1D4NwRzF6bMF4sdk3620DmTyeEDWRadMRjupsT4SHqubXr8Y0rgMsd2NcePedT422ML3aW7t3X010697KW1TqTnlXXWM9dywG5PxTT4K4ORQOlK9w6uv+dpxIArGEYsM5uI4c4U1gSIf5hqmrlqXp71YKNF9nhVsM/+Nd2UrKzsKatMoae0fDNp8UWjscvil3F5Rv4g8U6G3Fk4MYynkSpTKNj/AMWKcX270ANAl6itSMH+oBG6QMmY4t3Utw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN6PR11MB8146.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(346002)(39860400002)(376002)(136003)(366004)(451199021)(82960400001)(110136005)(66556008)(41300700001)(316002)(66476007)(31686004)(4326008)(66946007)(8676002)(5660300002)(8936002)(38100700002)(31696002)(478600001)(86362001)(2906002)(6486002)(186003)(6512007)(26005)(53546011)(6506007)(83380400001)(36756003)(2616005)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RzZRTlJpc210b1FCaGdWVHM1Ky85WDRDVDgwOU5TZGZwc3N2Vm91ZG9rNXFG?=
 =?utf-8?B?VEhUKzRzYzVQc1lBNC9lNVcwZVJjZmpGM05PdXJVcERrVDROSFpweGxPb0Fa?=
 =?utf-8?B?akNvYW9GYUpnTGFuSXpucEo2dVZQMFM3dVRlQjFsTjJsVVN4Y2hFejBMblcx?=
 =?utf-8?B?T0o4QzFibGdPMXo3QWZLdmRxaG9LaFcvb1grWWVtZ2hNNmNod2hJeGpXS3Jx?=
 =?utf-8?B?Q0ZwTm1aTjhMWjlkbWE4Vi92TDlsazU5SmJzY2NBUm1aVG1aaHlOcEpvUS9r?=
 =?utf-8?B?SzI5ZjR1bXNmekNqSXZXditmVStLSmFVcFQ2SzR1T3J2c0cyQ2t3MmQ5Tmlo?=
 =?utf-8?B?VTFCQTNxeU9QOTI5UW1yTit6U0ZzU1hJbnVuOVVhaXlpVm5udWlrN2c2clZz?=
 =?utf-8?B?N1BSUzdwenVRRWtjL3A3NFFlZFpTbVh6d2xNaGxYb0FCNGJ1UjNRZkl5ODUv?=
 =?utf-8?B?Zjd4N3FSV21NbG1kME54OVpNQmFpT3FaQXYzeTJ3OWZ2QU0weDZuVDl0ZVBN?=
 =?utf-8?B?bk4zSE0zY3VpQitQaFBWUkpWeGpIeHR0OVNvcHNuM05uRk9lN3FlOHlFZEx5?=
 =?utf-8?B?S1VQVHhzbzFnT004YlJFY2pJb1E5M1BhcjR2WVhWUU5rSHd0ME91Ky91UXJ3?=
 =?utf-8?B?SU9IUE9jeS9rd1JkZVVOSFZIQ2RCMUFFZlYyNDJqZEVrdTJGbUl6TXpEaHJO?=
 =?utf-8?B?QW5OTjg2NnNSQXRBZFRIQ1Y4M1dUeHBuQklmbGNYN014Q2FQVVg3Ti9ISThG?=
 =?utf-8?B?eTVBcW9ZRUFvTGcwN3BxQ0Q4UDg1MCs4NnNUNWlsSmV5YWc3S3ZVeXpJUFZ3?=
 =?utf-8?B?a1hUVFlJTjR6SVQvVWgvVjdSdzJBU25jeXVYTFBLTjJ4VmxNS2RoQ3E1ODdM?=
 =?utf-8?B?QUNTdUNnb2hSNWd4OFVUK1NXdlBnMEtFYVNsem9ReUF5UktkajR4UEF4ZlFP?=
 =?utf-8?B?Tno5dVp6OVAxK0Nwc2x1azEwSGNRa281bEwxaDV3ZU1VQTdxWDZDV0xwTWY3?=
 =?utf-8?B?aG1wVmN0Tmh2eU1xKzZQclhWUWQ2WHNEQk9FS3NocTFXN1MvVFY1c2RtUEY2?=
 =?utf-8?B?dXgraEpPSXhGdjBJREZLSnBvUXpZQUxvdzhIR25kOGxVYldxSnZHaFdzODNU?=
 =?utf-8?B?Ui8yWDRYci9Td1E0UlN4S24veTJxRHEvOW5rMHVsYU0zZFRCL2RIMktOQ1VL?=
 =?utf-8?B?eUlSeVpuaHVHVktmRmd2YWhueGs1Q3Ywb21rbzluSVFPNi80RFpyRmEyMlNB?=
 =?utf-8?B?RXlOWmY1dC84UUxhaS9lblpVbFlXc3JqYlZZL3VReW5WWU93bml5Q3o0clpL?=
 =?utf-8?B?S0xIcGZWQ2k3aWxsaGlseEo1aVVBYU1FWW1GQUlvckJCcWFueFRhM2E2Y3E5?=
 =?utf-8?B?WGpsdzV2RXBuQ2lwZjF4S2orWFhOUm4wdU1JQnFTb0s3ekM3ZFlVMm9CTUZy?=
 =?utf-8?B?WlFFSklOTWNIa2cwN1QxZkNUQmNTMmFXYnFVZ2ZBZzZiaVczOVdwL3hudkg3?=
 =?utf-8?B?WVRmU1dOY1lTSU5NSC8vMVErMXhqVkp2RVFHaGVPTkxJODlGa3ZGNFNYVDNO?=
 =?utf-8?B?b1lhVHZCWEc5OGZvTi9pUWl1UjJUVHF5MC9EYzh4SDZjVmI1cDFQdUlrUGky?=
 =?utf-8?B?MmxCcDNxdnNOeG9Pb0I1UGhLdlgrZXQyc2M3bldoQ1JXdktCR2ppNlYzcEw0?=
 =?utf-8?B?amdhZFovL2pmak5oRHcrT3NxTTBFcFRWUGNwZElwOTBMWkYyeXk2NnhReGt6?=
 =?utf-8?B?d3NCS2lTM0hHa0lUaXo1Rk05SDdwRlF2eGRHdmptM2twY1B5eTVSVFpPSGcr?=
 =?utf-8?B?d3dISmEvUVhQd1Q4QXh1MGdzdW5HY1NkY1JDTkZLbmVUdE4weGd1bzFoQ2U0?=
 =?utf-8?B?UGxadmZjWFdYMzViOTFqSG0rVnJTTVJtbjdHTmNYMUZCcW9zTUNIYWtBWElW?=
 =?utf-8?B?YTBpTituRmE1b0FhT3lvZUhEN0RxSkc1Yjk2ZVY0Y2U4dFd3TE0vYjJWT3dV?=
 =?utf-8?B?WXlmNTBxVEhkUVppbmxzMWlFemFOek1ZdmE1QlI1d3hoVEFXZ2J4SXhLREFS?=
 =?utf-8?B?V0FvSHB4TXE0Ti9jSDhiOEhFdWNCQ2lBSzVXWU91MHlUTXVnL29LczViWVFi?=
 =?utf-8?B?M2J3TUorL2FvdUF4aTRZWlNoWmoyMkFkRDJRZXZUOFZpajlxS2hZRmdmUEJD?=
 =?utf-8?B?Nnc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7dd12012-d6fb-49a7-d6c6-08db348ebd6c
X-MS-Exchange-CrossTenant-AuthSource: MN6PR11MB8146.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2023 21:59:47.3657
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9RylkO8GlUX5a2/ArRQ/T34KA4+OS72eRRiK43tFLIA6SyY4G6VmH3TfrUiIWieUpDN3RlqWXRjQf3C0Zk3z2BH2rGwbfDKsR1u/jAEYddE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6680
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

On 03/04/2023 21:22, Kalvala, Haridhar wrote:
>
> On 3/31/2023 12:35 PM, Kalvala, Haridhar wrote:
>>
>> On 3/30/2023 10:49 PM, Lionel Landwerlin wrote:
>>> On 29/03/2023 01:49, Matt Atwood wrote:
>>>> On Tue, Mar 28, 2023 at 04:14:33PM +0530, Kalvala, Haridhar wrote:
>>>>> On 3/9/2023 8:56 PM, Lionel Landwerlin wrote:
>>>>>> By default the indirect state sampler data (border colors) are 
>>>>>> stored
>>>>>> in the same heap as the SAMPLER_STATE structure. For userspace 
>>>>>> drivers
>>>>>> that can be 2 different heaps (dynamic state heap & bindless sampler
>>>>>> state heap). This means that border colors have to copied in 2
>>>>>> different places so that the same SAMPLER_STATE structure find the
>>>>>> right data.
>>>>>>
>>>>>> This change is forcing the indirect state sampler data to only be in
>>>>>> the dynamic state pool (more convinient for userspace drivers, they
>>>>>> only have to have one copy of the border colors). This is 
>>>>>> reproducing
>>>>>> the behavior of the Windows drivers.
>>>>>>
>>>> Bspec:46052
>>>
>>>
>>> Sorry, missed your answer.
>>>
>>>
>>> Should I just add the Bspec number to the commit message ?
>>>
>>>
>>> Thanks,
>>>
>>>
>>> -Lionel
>>>
>>>
>>>>>> Signed-off-by: Lionel Landwerlin <lionel.g.landwerlin@intel.com>
>>>>>> Cc: stable@vger.kernel.org
>>>>>> ---
>>>>>>    drivers/gpu/drm/i915/gt/intel_gt_regs.h     |  1 +
>>>>>>    drivers/gpu/drm/i915/gt/intel_workarounds.c | 17 
>>>>>> +++++++++++++++++
>>>>>>    2 files changed, 18 insertions(+)
>>>>>>
>>>>>> diff --git a/drivers/gpu/drm/i915/gt/intel_gt_regs.h 
>>>>>> b/drivers/gpu/drm/i915/gt/intel_gt_regs.h
>>>>>> index 08d76aa06974c..1aaa471d08c56 100644
>>>>>> --- a/drivers/gpu/drm/i915/gt/intel_gt_regs.h
>>>>>> +++ b/drivers/gpu/drm/i915/gt/intel_gt_regs.h
>>>>>> @@ -1141,6 +1141,7 @@
>>>>>>    #define   ENABLE_SMALLPL            REG_BIT(15)
>>>>>>    #define   SC_DISABLE_POWER_OPTIMIZATION_EBB REG_BIT(9)
>>>>>>    #define   GEN11_SAMPLER_ENABLE_HEADLESS_MSG REG_BIT(5)
>>>>>> +#define   GEN11_INDIRECT_STATE_BASE_ADDR_OVERRIDE REG_BIT(0)
>>>>>>    #define GEN9_HALF_SLICE_CHICKEN7 MCR_REG(0xe194)
>>>>>>    #define   DG2_DISABLE_ROUND_ENABLE_ALLOW_FOR_SSLA REG_BIT(15)
>>>>>> diff --git a/drivers/gpu/drm/i915/gt/intel_workarounds.c 
>>>>>> b/drivers/gpu/drm/i915/gt/intel_workarounds.c
>>>>>> index 32aa1647721ae..734b64e714647 100644
>>>>>> --- a/drivers/gpu/drm/i915/gt/intel_workarounds.c
>>>>>> +++ b/drivers/gpu/drm/i915/gt/intel_workarounds.c
>>>>>> @@ -2542,6 +2542,23 @@ rcs_engine_wa_init(struct intel_engine_cs 
>>>>>> *engine, struct i915_wa_list *wal)
>>>>>>                     ENABLE_SMALLPL);
>>>>>>        }
>>>>>> +    if (GRAPHICS_VER(i915) >= 11) {
>>>>> Hi Lionel,
>>>>>
>>>>> Not sure should this implementation be part of 
>>>>> "rcs_engine_wa_init" or
>>>>> "general_render_compute_wa_init" ?
>
>
> I checked with Matt Ropper as well, looks like this implementation 
> should be part of "general_render_compute_wa_init".


I did send a v3 of the patch last Thursday to address this.

Let me know if that's good.


Thanks,


-Lionel


>
>>
>>>>>> +        /* This is not a Wa (although referred to as
>>>>>> +         * WaSetInidrectStateOverride in places), this allows
>>>>>> +         * applications that reference sampler states through
>>>>>> +         * the BindlessSamplerStateBaseAddress to have their
>>>>>> +         * border color relative to DynamicStateBaseAddress
>>>>>> +         * rather than BindlessSamplerStateBaseAddress.
>>>>>> +         *
>>>>>> +         * Otherwise SAMPLER_STATE border colors have to be
>>>>>> +         * copied in multiple heaps (DynamicStateBaseAddress &
>>>>>> +         * BindlessSamplerStateBaseAddress)
>>>>>> +         */
>>>>>> +        wa_mcr_masked_en(wal,
>>>>>> +                 GEN10_SAMPLER_MODE,
>>>>>   since we checking the condition for GEN11 or above, can this 
>>>>> register be
>>>>> defined as GEN11_SAMPLER_MODE
>>>> We use the name of the first time the register was introduced, gen 
>>>> 10 is
>>>> fine here.
>> ok
>>>>>> + GEN11_INDIRECT_STATE_BASE_ADDR_OVERRIDE);
>>>>>> +    }
>>>>>> +
>>>>>>        if (GRAPHICS_VER(i915) == 11) {
>>>>>>            /* This is not an Wa. Enable for better image quality */
>>>>>>            wa_masked_en(wal,
>>>>> -- 
>>>>> Regards,
>>>>> Haridhar Kalvala
>>>>>
>>>> Regards,
>>>> MattA
>>>
>>>

