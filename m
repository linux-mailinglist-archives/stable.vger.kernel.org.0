Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD96A6C665F
	for <lists+stable@lfdr.de>; Thu, 23 Mar 2023 12:18:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231350AbjCWLSM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Mar 2023 07:18:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231639AbjCWLSL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Mar 2023 07:18:11 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECC0F40D5
        for <stable@vger.kernel.org>; Thu, 23 Mar 2023 04:18:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679570289; x=1711106289;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=LJ48Gxk4dtdlaJgj2OODk1X8Zuh6ZALhYQgUs8QCuE0=;
  b=M8gABku32t9MFugp5qhGr3VJXo5kifTiDGgiFfGWGo9nZSkq0Xc/FBjz
   XVnSjTxL5ZQG0jntyGn0WOL3w6aWynfDGiu+74lNNQ3rMQuXcfiwhuzpY
   pvhUyytn6+6DgxV9cRelL72VZvsVFmperZCK65XeDG8k6arG34DsizCR9
   QYWyqtdpcbjRObHK0UIiD/7RPzymx4g996sPf5jkn/R2lB01MR+DKU43Z
   L4V6GSFQTb8u5/qcGVAkeHsHy3cHdk49fKsFt1Ygu6H03lzEESODvxx4M
   RPiypSMA5xWilDD3cWldcxFsqlwFwyWY3PkWx8gsDC5SOLTxeDhfH2nxL
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10657"; a="340998149"
X-IronPort-AV: E=Sophos;i="5.98,283,1673942400"; 
   d="scan'208";a="340998149"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2023 04:18:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10657"; a="1011754408"
X-IronPort-AV: E=Sophos;i="5.98,283,1673942400"; 
   d="scan'208";a="1011754408"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga005.fm.intel.com with ESMTP; 23 Mar 2023 04:18:08 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 23 Mar 2023 04:18:08 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 23 Mar 2023 04:18:08 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 23 Mar 2023 04:18:08 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.43) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 23 Mar 2023 04:18:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kF1/WkztVJrOOjODVbEg0QSPz+qMP+m9X4n6pvr1xFGRTsaKwRNyoB82fW+F7JM5DUkSdlGJyaUhItc1+0jkWIBmwjfzUQJEPjuxP58Xsiwx70Ot1L4F/1MdImSXNIWkLi89AJlDEBFi9M5XW5vKwYWGiesrqsSTKfRBhmK6pxbArH7hIYvILs4Bt9NrE6ot83BvsZ98aEoskskDjQxoBZjxV+bxMRcoRnpmSnt82LZLJVioXdHGJCGhtzQPj55JFxeAypwS/53KQwFoY1umSRJyfYYJ08GUsVh7T45eDSklomoouX20mvEVijq1e1iJoMww45UDM7248glNQIPsjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M1AbTIDv5sKcX8eNjfu84g9SbPyaCQBNPvWvBigOsiY=;
 b=RvTCk3XB0pbXBSBtYCoYS659ZVQAvjtE6EGyKcnBhzFlN4paYD6L3S1ajli6b13m2THNY3Lvu6VCLLG+lefahokCMC8o+G33fTp8Qkl45pareKCmDz5gSzLPi10IyI1M0N7ov4cd6k2PhBcWfrc8V7aK83jw4KyTGKJMKnrcS1+V+hGqZJDhB1ayitbcK9BnUwmwg6jO3isFGz0k6WHTYhlOeJOQQPCGZuPKNYCba1TOqoS0SjWEraCntdeOjdWSyyeoHerf8y3DQopbXgmJKR16UB4GF1Ga0sJVTBtpIl1b0tacJOJTmMA2LQPuUKGao20wDFXNHep1pWCnkonL0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL0PR11MB2961.namprd11.prod.outlook.com (2603:10b6:208:76::23)
 by SA3PR11MB7610.namprd11.prod.outlook.com (2603:10b6:806:31d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.38; Thu, 23 Mar
 2023 11:18:06 +0000
Received: from BL0PR11MB2961.namprd11.prod.outlook.com
 ([fe80::cc58:aa84:72be:b4fa]) by BL0PR11MB2961.namprd11.prod.outlook.com
 ([fe80::cc58:aa84:72be:b4fa%7]) with mapi id 15.20.6178.038; Thu, 23 Mar 2023
 11:18:06 +0000
Message-ID: <203f0d58-a8ac-4cf3-275b-6360725d18be@intel.com>
Date:   Thu, 23 Mar 2023 12:17:30 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH] drm/i915/gem: Flush lmem contents after construction
Content-Language: en-US
To:     <intel-gfx@lists.freedesktop.org>
CC:     <dri-devel@lists.freedesktop.org>,
        Chris Wilson <chris.p.wilson@linux.intel.com>,
        Matthew Auld <matthew.auld@intel.com>,
        Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>,
        Andi Shyti <andi.shyti@linux.intel.com>,
        Matthew Brost <matthew.brost@intel.com>,
        "John Harrison" <John.C.Harrison@Intel.com>,
        <stable@vger.kernel.org>
References: <20230316165918.13074-1-nirmoy.das@intel.com>
From:   "Das, Nirmoy" <nirmoy.das@intel.com>
In-Reply-To: <20230316165918.13074-1-nirmoy.das@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0105.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9c::17) To BL0PR11MB2961.namprd11.prod.outlook.com
 (2603:10b6:208:76::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL0PR11MB2961:EE_|SA3PR11MB7610:EE_
X-MS-Office365-Filtering-Correlation-Id: b595b278-2d8c-4e49-7c31-08db2b904634
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HSY2SCZK5UhFwHjCvqSV01cgbursdqtsCBG/Po39Pi5w8FgJm0ikyUR4g9OKRU9oXggisk0FTfwgFG/RR432uAFg6u5cO+C9icExIhQt8Z3dNYpeLidpmoxrzBUrMQC3sVS0nT3uBDDaLflDuG+EIfe4uPsY8keO+cTT3CzhSbsutC2mCWk5NLHbj3scLbO4GKEW5VHUCCTdN5CpeuDqlDQxQdu2H9NsnInHE0QixPWFVUnqhqTmEilpwl0VghjynUsUJjmEBZjnlfcS/uep5aKjGuTxi76t4W69JIeDdtuu1Qzs1abwM9Ju5V486uVLQ1oCMY3Q3RR3fdy2cTpU0tux8EDTQfoGaS3s7Wh9iZz1byvxozxrERBuettHjkLO0EgWaxm21r8V861DEtZL1ydUaiipo+tlRvk0vqRHZwQSjzK7Q/fNiOwvWfuAgAQ+OgiYgk9YMM8xntPehjnUFSx2z2N7KxMEATe8VzTkoWAnR1n0wsEJmHX/UrM8Ska7Q5YCM5fHbordF5hW2/4irVAUKCA/aOytMuYwrTkbhygjw1JM2hbR/7DSBaknVpKcp3FfaxwAbelZGd58Wue7I6I1XzdnbvTTRln351ubEy3iCPUCdLLPDgK6X5i8Grf4IJ7x/yuMk/qN2WHUiSAnOx+3qAXWujDbgy/FQWdAViYrGVZVhmpEuFEf88J7kogZH1S7lGd4jkunhenGsmRL0c+zgUxiybKAsy6vxOcovYg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR11MB2961.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(39860400002)(396003)(366004)(136003)(346002)(451199018)(6916009)(4326008)(8676002)(66946007)(66556008)(66476007)(316002)(54906003)(5660300002)(82960400001)(41300700001)(8936002)(53546011)(26005)(6512007)(6506007)(6666004)(186003)(2616005)(83380400001)(478600001)(6486002)(86362001)(31696002)(36756003)(38100700002)(2906002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dnh0RktWNWh1bEFtUHg0dUhJK2pPZTFWcUlUenVPOWdocnpuemdhUWlyZUtS?=
 =?utf-8?B?OWdlMFlYeUNpR09LYldMcDVuZjhkcFRlM3owQzBFSUdSR3U2MnRna2V1RWE5?=
 =?utf-8?B?N1RrMTFReEp3RnhOOHNwU1A4UGtxL2x1SUlsdDl4TG9BUnVHeXhXSjkrTlRO?=
 =?utf-8?B?eDh3SzVnTmlBZm1jeEFra3hMblFUOHdRd3V6NWE4VVhVVTFZd1pKQllYV2NP?=
 =?utf-8?B?RWNUTEZ1NXpwMVVhQkoyS1VhTHpsMmQ5cmpsRUpnZWhaT2JJcUkrVVQweTFK?=
 =?utf-8?B?UFMvMFJ0LzhhcWdxOEY4NjFMcVg2emlWbDY0Q2hoU1hyVnBCQnV5ODhZV0xL?=
 =?utf-8?B?YXJPMTJueTYwckhzL1lSNnBUV3FXVnBLU2ZKR2xUbjFvT05OdmpPaTk0Ymgw?=
 =?utf-8?B?MnpRcHdXUjA4UUZHTTU5RHhlVEoxUEJ3cWFjd0gveG9lZHlaY1F6bC9ObEpZ?=
 =?utf-8?B?Z0ZwTjI1Y0w2ZHYzYXQzWUo5TSs5YVpnWGFrUGIydUViWjBUbHcrTTZPTWo1?=
 =?utf-8?B?dVc2NFN4TmpKczlITGRKMUh0L3ZnY0NvV3plN1R2ZHYrTkR3b2J6NmN2SDkz?=
 =?utf-8?B?R0Zsd2RrVUw3Q055eGxieTdVb3lHSWJUYjBXWFlXa2YzZmtrcEUvMmVDWnJu?=
 =?utf-8?B?Tm5pR3JHVm1ZNzkwTFpjTDB1K241WUZBZGtjM2tMNjN4NEdTd2Z4R3VHMkZo?=
 =?utf-8?B?REpSQngxZFgxOGlSQkxENFpuK29KYnJZSVNyYWNSSUZHZmpWS3BMM2U0aUIw?=
 =?utf-8?B?Wlc1UUZUQTROQUtEZUVHWm9PMUxqM1o3RFZIQ016Rk1kbHBwMThRZzdsOGRI?=
 =?utf-8?B?bk1LMG5DbTlnanNjVzVoSFlHNFhhcjU2TlFJU1NCR1ZlaGU4Y1NvSlFETmNl?=
 =?utf-8?B?SVZOQWhLVFdGWU5uTVE2R2VkUFZPbUt6MlBCdVZLNW1sRldDdEx3VFZEeWRY?=
 =?utf-8?B?V2grQ05jeElXcjJNbTUzMkcvTkxiTENrUG9CTVppRUZsaHRJeHpCNm84OGQv?=
 =?utf-8?B?Zi9WbXZPSkxDUWovNng0dXlOUWhqUTlBVXdqMnIrd0NvOSt0YlhRUktqVXRo?=
 =?utf-8?B?dDRyTmNKRWxsRjJ2VXJwMTBOMUhwM3Y4VUVvQ2JOR2tuTGVDZ20vUVE0RGND?=
 =?utf-8?B?U2tqVTlLblZGREdpUFZjbXc4djVBRTJ1dmpadlRwN2FuMlZGbjBVaEN4Y2Ry?=
 =?utf-8?B?N0dsdVdLM0MzVjlnekp1b2VBVy9uZjdRcGpEaEl0WmpiSkRidzZlcStFWlJR?=
 =?utf-8?B?K2JucmxMVHdFOXVGN2c4dGl3L29hWUVjMlNyczR2THM1bEpRV2J6R2M1SXNW?=
 =?utf-8?B?SUVEdlVoZjZocGh4WVRTUE5RTTR6cWhnVzRLandGSzJVcHp3SlQ5WEtrRTNa?=
 =?utf-8?B?bkpuR0puMEJ2d2oyVU13N2lKWlhXcTdZWE4vNmpLR1RsT1pnQWNJQnN1ZWlE?=
 =?utf-8?B?TnZnTVovOHNYT2dYRTNSaWVDQk1FYnA2OVRuQWVkcWFDZVNRRGNPWFF0M21o?=
 =?utf-8?B?aGhXYkJVL1E1RjdPK1dTQ1l1cjkzYnVaTnc2QU5scnVOWUN4RjhFWFJaMDZ2?=
 =?utf-8?B?R1o2T0lQRlRKaXF0dXVtSUNnTEtlSldVbUhuUUpDKzRWWUdJK1lhYVoyU0Ns?=
 =?utf-8?B?T3RDY2Q3S3JkZ1lxNjIzaGxUaEJ6TW9BSmp2UXpWQ2FtU2MrNEhxQlJ0aGM0?=
 =?utf-8?B?SWJYUWZEKzVWcllzQkYzcnd6N1B3Z0lBa3dPc1RRL2FDOThEQnJoVkRPSXIz?=
 =?utf-8?B?eGNhZS80M2wzSkVRY3Z4RHlWTzdjYnJTVVA5bDFCMEtscGduQXQ3Z3BHN1pS?=
 =?utf-8?B?SVcya291K1ZPR1ViT0ovRi9DNXVvUVJCOGd6RTVER21WVTV1Y0xETUpzUkx0?=
 =?utf-8?B?cEQ0OVJLQjhnWFFJcTEyYUluNUZlNGNxRm1mRk9OUVNkMlpCM0g5WXVBeWNx?=
 =?utf-8?B?eVByTHNMMDRaOVY2djlRTWNWeVU1UjhQTVJteDUrVTRSb1JyalpaNW5aNEJk?=
 =?utf-8?B?M3JlRm1BWEZSbHM0TDBFTk0ydUFiSzlCcXpaNE80YTRmZTBYbXBWT2FQL1F5?=
 =?utf-8?B?em1aV2tyRDVRTDhSQnpCc2p4YkFib2F1ZVl3N2Jnd3FwblJuR0Y0SWxTWGFt?=
 =?utf-8?Q?Kpd+83pu6JfFxcggOxcmFrlkV?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b595b278-2d8c-4e49-7c31-08db2b904634
X-MS-Exchange-CrossTenant-AuthSource: BL0PR11MB2961.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2023 11:18:05.9155
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F41ca020wLigF6Z3KWNGPNeQX2GzPi1VIR63g2FoUdktCawXYLxsX0fPiTe0Gar1jE7m0w3IRdLxZ9wqV5H8OA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB7610
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


On 3/16/2023 5:59 PM, Nirmoy Das wrote:
> From: Chris Wilson <chris.p.wilson@linux.intel.com>
>
> i915_gem_object_create_lmem_from_data() lacks the flush of the data
> written to lmem to ensure the object is marked as dirty and the writes
> flushed to the backing store. Once created, we can immediately release
> the obj->mm.mapping caching of the vmap.
>
> Fixes: 7acbbc7cf485 ("drm/i915/guc: put all guc objects in lmem when available")
> Cc: Matthew Auld <matthew.auld@intel.com>
> Cc: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
> Cc: Andi Shyti <andi.shyti@linux.intel.com>
> Cc: Matthew Brost <matthew.brost@intel.com>
> Cc: John Harrison <John.C.Harrison@Intel.com>
> Signed-off-by: Chris Wilson <chris.p.wilson@linux.intel.com>
> Cc: <stable@vger.kernel.org> # v5.16+
> Signed-off-by: Nirmoy Das <nirmoy.das@intel.com>

Reviewed-by: Nirmoy Das <nirmoy.das@intel.com>


> ---
>   drivers/gpu/drm/i915/gem/i915_gem_lmem.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/gpu/drm/i915/gem/i915_gem_lmem.c b/drivers/gpu/drm/i915/gem/i915_gem_lmem.c
> index 8949fb0a944f..3198b64ad7db 100644
> --- a/drivers/gpu/drm/i915/gem/i915_gem_lmem.c
> +++ b/drivers/gpu/drm/i915/gem/i915_gem_lmem.c
> @@ -127,7 +127,8 @@ i915_gem_object_create_lmem_from_data(struct drm_i915_private *i915,
>   
>   	memcpy(map, data, size);
>   
> -	i915_gem_object_unpin_map(obj);
> +	i915_gem_object_flush_map(obj);
> +	__i915_gem_object_release_map(obj);
>   
>   	return obj;
>   }
