Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 231615AB7A0
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 19:39:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236180AbiIBRi7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 13:38:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232815AbiIBRi6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 13:38:58 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F3ADDEA47;
        Fri,  2 Sep 2022 10:38:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662140337; x=1693676337;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=AoC0/ylSIdwW6lbGGZ/h8jr/bR2h0ZQZGyHXRcY5HGc=;
  b=POejyryhZVrOQIFak2gCWvlj+VID5k+EyQS9GV65pX2BvFOCb/GfSN5m
   0mTF2tN/cGsLQRH/aNa4bm0LiZKb7f9naRhWNZJZikveN0U1/DBK0WGHt
   DKIixS6nRCQyIYIlX4oXTLFsDUKlNzRpFiQRCMhlYoebD6bzz8HA9AaXg
   UKACepNaysXC/GllvshqjF6UgRZzBTsawrSGLeKV6ts1Wc8YYqnkohdng
   qOmMVFz8bfQtUfMLhdbj4s/ZfF+vznROzd/t2JSHLQ1NEo46YPAk8yE5b
   GLULdlIV4gwKqsc9rkApYrfh27F14cPS1koJBfAX260i4rk5RLqYceq0X
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10458"; a="357748535"
X-IronPort-AV: E=Sophos;i="5.93,283,1654585200"; 
   d="scan'208";a="357748535"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2022 10:38:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,283,1654585200"; 
   d="scan'208";a="646185562"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga001.jf.intel.com with ESMTP; 02 Sep 2022 10:38:56 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 2 Sep 2022 10:38:56 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 2 Sep 2022 10:38:55 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Fri, 2 Sep 2022 10:38:55 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.106)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Fri, 2 Sep 2022 10:38:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=diKT+dbgnM3HXBRF3hDhICuNLVa0KgFCq1K3ER0TKGj0uRxL3YKjfC9zehApNDMVW04BkprPbV9pqGtgQMTK9hjsRpxpmHkM+KhYp9a6ql3EiZnyeaoAMgII4pYepnH6+QJHDJzrMwhvs4+oeIW1+Yhz5gRlBa43Yfy+vfjAQXv9Zzsc7TFZtAcZlc8gQLKQhzYwpOmx3EpmDTHc5IuH1NyexqxN1Js1bGBxznG+yfgHWLSyw6EnUsnU+cvh9vK1/CNmNTOb8/QvWA3m8U9mgdrXTlnp01dtjrIQ7fO7vc7UMZxZbBoX4AIOACUjUN1/nxGpyg31MEdR2AtuG0EMOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qcbBUoqtvAmKL94VASbPvJBSW5txUJUQljHcL2ESLBA=;
 b=TyHSx2PHdDyvdw2v48+p8QQ6y49jQK9EsgomYQ1rvi574bGUN1GRK1exMXAnq1xZBc1IgfS1RWxXcpasIdQdJemvh64yYn3zLnxVdlvRU8OApwpD//O4wDzDVDNqMWftegttRozu1C63tze4ajGfwgtcv4z5mQAFRJn8n1BXDmadKSkSlrKlNYMOAM5lFeyMqKKrEC+IbOQWl2M2h6SC3ESqI0vTUYc0dSU4+302lYbCOUVO3+63ZOjfIkLUDmnblGlpR3xv3mRxjupkSzyoqbokf+hzDmfMT7KhsgDwbqEiTdIiO5woTPeW6ezlVQgut1eLpBV12uBJKyhv6dqd0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY4PR11MB1862.namprd11.prod.outlook.com (2603:10b6:903:124::18)
 by CY5PR11MB6185.namprd11.prod.outlook.com (2603:10b6:930:27::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.19; Fri, 2 Sep
 2022 17:38:54 +0000
Received: from CY4PR11MB1862.namprd11.prod.outlook.com
 ([fe80::a824:112:52f7:5743]) by CY4PR11MB1862.namprd11.prod.outlook.com
 ([fe80::a824:112:52f7:5743%12]) with mapi id 15.20.5588.014; Fri, 2 Sep 2022
 17:38:54 +0000
Message-ID: <8d66f94f-9981-1456-9040-066e35c7ba1f@intel.com>
Date:   Fri, 2 Sep 2022 10:38:34 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.2.0
Subject: Re: [PATCH v2 2/6] x86/sgx: Do not consider unsanitized pages an
 error
Content-Language: en-US
To:     Jarkko Sakkinen <jarkko@kernel.org>
CC:     <linux-sgx@vger.kernel.org>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Vijay Dhanraj <vijay.dhanraj@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Paul Menzel <pmenzel@molgen.mpg.de>, <stable@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>
References: <20220831173829.126661-1-jarkko@kernel.org>
 <20220831173829.126661-3-jarkko@kernel.org>
 <24906e57-461f-6c94-9e78-0d8507df01bb@intel.com>
 <YxEp8Ji+ukLBoNE+@kernel.org>
 <84b8eb06-7b77-675f-5bc8-292fe27dd2f5@intel.com>
 <YxFGykqMb+TD4L4l@kernel.org> <YxIEm4uHVvUY/rv6@kernel.org>
 <YxInD1m7rEnQ/yxW@kernel.org>
 <b418161b-2613-4bb9-9269-b4995de65794@intel.com>
 <YxIvr33xgjCbW6qu@kernel.org>
From:   Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <YxIvr33xgjCbW6qu@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0186.namprd13.prod.outlook.com
 (2603:10b6:a03:2c3::11) To CY4PR11MB1862.namprd11.prod.outlook.com
 (2603:10b6:903:124::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 98d3c89e-3f46-4bfa-6ecc-08da8d0a015a
X-MS-TrafficTypeDiagnostic: CY5PR11MB6185:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DXyRfGzebdsoJ8kgNg3suFEFPmA+6KZa0WIv2We1LGqALnz2GcdCj645A/AYmMpoc8PAAgfWR6RBo5lRdHHCdnhaoHOlBI8V+lOb9Q2zri0LogYEYIff+tOJlZ5hqqF+8VgmZZr0KZV7TFTxfSkKG11KzIzORniMayHFXKhqMy3TlTIykaQVLvXwQPV1pEYmOoGqcuHB71tesBGv0Qqworh+PtUV8EjhoBXuBBrFshqQfZon67SzN9OENOVWygIe/dAnGMCuwfxGGX4BCKEAy/H+5DMu7S8xC1eoR43C+qISuDboPwEMSaprkbWRHtIibDtA/mgdL9QBpA/V1CkrMXjood0qDCz/qQoByoFDC0iurRSOYDQgbCcdlbJWTM5wRw82vi9stfxpg9fFu9sbmvvpOmJlfOJJbPXTASWULLWhiZtnIhVIlz9g32WX9XgRv8w6UPcSzsCZo70d+dm1ryKof+Rv8zxXAIMxIOodQL1DHjuV5iFg53zWa31s3SOjKY+5pZePHA1F3LrAHj2ljWcIT97BM2bz4VzfMW10VC2tQnCkjeCihU3yRVNNjRv+dQOFnQ+F0pYI/BjfHwAc6BFimde6kzc32a7kOviYa1+YHFxmBnlUZxrAUjPZH4m1SOICFep10WM2pjBSIWOaErCZi7jKi4zmpiCPTOqifRnL+COwNI4LHLR0sDC0SKJ1+z3CUP/6tYRI1SRO7AnP0eWCdQeL9oUiJ2KgbPHJRElYyGdjaQ4nbNYyPX0vN+wEcniI7jvHeJp3vYt4BOeb3F0fH2UEcx9Qr8XF12V4eoQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR11MB1862.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(396003)(136003)(366004)(346002)(39860400002)(54906003)(6916009)(7416002)(31686004)(316002)(41300700001)(8936002)(5660300002)(6512007)(186003)(44832011)(6506007)(2616005)(26005)(53546011)(6666004)(2906002)(31696002)(86362001)(6486002)(66946007)(38100700002)(4326008)(478600001)(82960400001)(36756003)(83380400001)(66556008)(66476007)(8676002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bjVaaHZORFRaeGtURE1wYUN2MkJRSkRweHE3ZjduekhGNU9rVTVaL3BXNmtD?=
 =?utf-8?B?R2VCUzhhMVNqMmtkYmxPc0NGOEpvMkh4eEd2MVJZSVZyN2lOR3l2eDIyRXB3?=
 =?utf-8?B?aHowcEU1NHY2WVJzZzg2RklJbDU1OGJMd25zWWVaOFlWS1AyNkVrS0V3ZlZG?=
 =?utf-8?B?amlGcjB3SUpiQ241ZmoxV2NFM3B1S3ZwNVQ0eGgxSjNhRENVK1B5T2Z0N2x4?=
 =?utf-8?B?dEVDRTNPUHlmM29iY2RkeGhIbzNXdUdZMW0zR282RjNjc3o2OFd4czNja1JE?=
 =?utf-8?B?NDlzL0NmbTBHdFV0M2Uvd3Rvbm5SbUtrNWZVa1Uza0dRa2g0RjFSVEI1cmYw?=
 =?utf-8?B?TDlBeU1ENnhqTmRaaSt0TnJYQ1A4YnlsTzhFYXVJMGZLUGVCMnpIQ1BTMDNS?=
 =?utf-8?B?NmdxWk5nQ0hsSFRLOTVQcmRxUUxXS3p0WTJYZGxybmRJYUFxOHI5OERWUmRB?=
 =?utf-8?B?OC9XOE13M2ZpSmtmdDFiK3Y5dW5yS1B4a3N2b1FwRFlmTU0rb201VXZBUnA4?=
 =?utf-8?B?a1h2OXZhSkJ1eDhRd0MrMkx1b3czQTU4WmpNeEpQMCt3WktLSVROYXJ6dXEv?=
 =?utf-8?B?eUVCaWhhY1lJakp4cnNHd0E5SDJhcjJUZjZQSzlaMzF1TU1KdnNnRnpNVGFC?=
 =?utf-8?B?ck1Mcm8zY3laOXkvL2hwM2d6WHZXd25POUpHQkZuZ25EVWVpSUZOTldWSVd1?=
 =?utf-8?B?TUFqOWNTSUdoM3dXVFFWL3ZxOG9XKzdEdnE1ZXJsNHNzakw4YU9ha25Ca0ZN?=
 =?utf-8?B?cHM5azlTSUE5bUtud3ZlL21ad2FkSmEydkFiMjdKZllvczU3K2JaaFN2NDln?=
 =?utf-8?B?UXRXeFhtZHZQMlcvVFk4eUszZHhad2pUd2o3eXFLT1pveUhaTHk1L2ZtQTBt?=
 =?utf-8?B?OFlUWHFlckNqSHlBREg4RUc4cStvUXpyaUZRdXc5bWNRa3N3R3dCck52VlB6?=
 =?utf-8?B?OUs2L1cwMUptcEFmVExoc2MrSWhjeUV3WmtCQmsrYktHRmJXeVBWQmtmc3Zm?=
 =?utf-8?B?cWdpdTdqdEdrZ0FPNzBnVitud0pGMk1YUzhGMFBkL3p4Z1dNZVA3eFU2Uy8z?=
 =?utf-8?B?Tk9DT0dlLzYwVmQ2bjZDWlpoSXRac3NXci9rSzZ0a2xOVUxxc2hXaUd0SmlG?=
 =?utf-8?B?R2V6dkhzMStlSUsya2VTOTRrT3NzUkd0bGJCOXRzRS94RkVBNUFlYThhMkxo?=
 =?utf-8?B?a1ZYVjVDeEVjdGZaR1ZIWllMeFk4SFErV21XeFJYUkRyRE15eEVBQnRZQWx0?=
 =?utf-8?B?OTZJSjIrZ1RnWk9VK0l2S0poYlZrWVhlbXJyMGFMTlJLak10NEpZVTdBTGxE?=
 =?utf-8?B?UkNac2Fsc25DWWkvWVlVdWhvRHZRcG91M21YUmlianlFc1JscGdSakFpcTJY?=
 =?utf-8?B?OFg2Yk95M09JWi9zSW9JbDhmOWZGSU85K0h5L1RHdUN2K0xhL3N4aGJhcWxz?=
 =?utf-8?B?ZVE1eUhVZHhUY2lNZUc0U3JhRkVZcyt5SnJtL1dHcDhNVDRxK0p5TWF6Qktv?=
 =?utf-8?B?aW9nOFl2emFqNHpMTDk2bm1pZWtFSDNoL3dQbm1BTEwrM0xaTThUcno2cURL?=
 =?utf-8?B?Tk5CZVN3ZU14TUlmOGl0czRRNzJFaE85K1B5VXJ3VEMzQzVXRlRJZitOeWxS?=
 =?utf-8?B?Y2lvSmxmSXB4QU05dHc4aktyY1BKaFp4MUs1SnI3UlRXRGI3QURaYjdZTzhF?=
 =?utf-8?B?b21na3BKWm91RzNZbC80bEh0SGNQZG5XMTJqZ0VnUTN3a3U1dVZwTzhreDJU?=
 =?utf-8?B?SmFhY01WaFlBLzNjb01Fa0F3cDVjVVJzeHNoOTByNDd4MEhLWkU2T0IxbUVF?=
 =?utf-8?B?bXZvLzFPY05uejBsaVNPZFlRN2RPZkdZQlhIdENZakZ6K3ZaUTlUMWxzbnFT?=
 =?utf-8?B?bkUrcU9tVjM2MDE2L3FvSWpTYUpBZW9pS3QyNnNZaDdaTWo3VStRdkswMGZX?=
 =?utf-8?B?UVBGby9tNmdiWUgyTTBRbEg5N1RSZCtodnhia3g3anZBVHRnT3NLU2w5YzBG?=
 =?utf-8?B?czQwM1J4NzZPNnJTc0gwZ0FOTlNDeXVBSFQxcUFJNXVlb1dPT3VSL2twVHd2?=
 =?utf-8?B?RGp5a2hpblovVFQ4c0lhLzNsRVBybFBQb0RlWTU0UjVLZmJDV2xMMkFXWktx?=
 =?utf-8?B?WHo3MnNPU0NnTE1RZFpEekc0RHRpang4SVpuUnljTlkzZXhwS2k4VWEyUzFQ?=
 =?utf-8?B?MWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 98d3c89e-3f46-4bfa-6ecc-08da8d0a015a
X-MS-Exchange-CrossTenant-AuthSource: CY4PR11MB1862.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2022 17:38:53.9645
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dpsDYl9GCducMw3RJ752zbYigp12Lh2HI45UbkZEAgj9FaP/D2S4gx9lbIhWz8TL0QC+H/+r3QSH/nMYUCkWD8TSPrv3df9gjfFtNmcf9ik=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6185
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Jarkko,

On 9/2/2022 9:30 AM, Jarkko Sakkinen wrote:
> On Fri, Sep 02, 2022 at 09:08:23AM -0700, Reinette Chatre wrote:
>> Hi Jarkko,
>>
>> On 9/2/2022 8:53 AM, Jarkko Sakkinen wrote:
>>> On Fri, Sep 02, 2022 at 04:26:51PM +0300, Jarkko Sakkinen wrote:
>>>> +	if (ret)
>>>> +		pr_err("%ld unsanitized pages\n", left_dirty);
>>>
>>> Yeah, I know, should be 'left_dirty'. I just quickly drafted
>>> the patch for the email.
>>>
>>
>> No problem - you did mention that it was an informal patch.
>>
>> (btw ... also watch out for the long local parameter returned
>> as an unsigned long and the signed vs unsigned printing
>> format string.) I also continue to recommend that you trim
> 
> Point taken.
> 
>> that backtrace ... this patch is heading to x86 area where
>> this is required.
> 
> Should I just cut the whole stack trace, and leave the
> part before it?

The trace is printed because of a WARN_ON() in the code.
I do not think there is anything very helpful in that trace.
I think the only helpful parts are the WARN itself that includes
the line number and then information on which kernel it was
encountered on.

How about something like (please note the FIXME within):

"
Paul reported the following WARN while running kernel vFIXME:
  WARNING: CPU: 6 PID: 83 at arch/x86/kernel/cpu/sgx/main.c:401 ksgxd+0x1b7/0x1d0

This is the WARN_ON() within ksgxd() that is triggered when
sgx_dirty_page_list (the list containing unsanitized pages) is non-empty.

In sgx_init(), if misc_register() fails or misc_register() succeeds but
neither sgx_drv_init() nor sgx_vepc_init() succeeds, then ksgxd will be
prematurely stopped. This may leave some unsanitized pages, which does
not matter, because SGX will be disabled for the whole power cycle.

Ultimately this can crash the kernel, if the following is set:

	/proc/sys/kernel/panic_on_warn

In premature stop, print nothing, as the number is by practical means a
random number. Otherwise, it is an indicator of a bug in the driver, and
therefore print the number of unsanitized pages with pr_err().
"

Reinette
