Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A97B6C854A
	for <lists+stable@lfdr.de>; Fri, 24 Mar 2023 19:45:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229997AbjCXSpW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Mar 2023 14:45:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbjCXSpV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Mar 2023 14:45:21 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A21A8F1
        for <stable@vger.kernel.org>; Fri, 24 Mar 2023 11:45:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679683518; x=1711219518;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=wMP1CWieuloSntHx2HalKOO9PYB9+e0OvXSuTOUwpkI=;
  b=nvQT0QukD3ael9duQeJq01vF/gK4iQEmap7hZZo0Hw0jlDouPcswhM7z
   503igIpj3Qr4YLf9JwvEkt22WFXxnhjO+jTuwfdQAdmEMsaKMOqH+32z6
   LcJlCcLaQI1X8IVTHSTO9GZ0gmyL7gqYt1yTdIuxueGukMOfMkTF0X+UG
   R1fy4sgtYnO1alqyW/EGnnt/I9N9bSYr8VwQ9Z5NiQoWJqFHNffbxw7Bi
   75PUq3tnCEHdRoQwOVJnS5Khy7LVJCXMn4C7nsR5pxNuQBOLR6Z9/ynfC
   8pHoUHD4yH4G15GTcaR7OwgoUeL1VsbGh5YLPYIecHo6peYljkeOIYhpl
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10659"; a="319509234"
X-IronPort-AV: E=Sophos;i="5.98,288,1673942400"; 
   d="scan'208";a="319509234"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2023 11:45:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10659"; a="713173136"
X-IronPort-AV: E=Sophos;i="5.98,288,1673942400"; 
   d="scan'208";a="713173136"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga008.jf.intel.com with ESMTP; 24 Mar 2023 11:45:18 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 24 Mar 2023 11:45:18 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 24 Mar 2023 11:45:17 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Fri, 24 Mar 2023 11:45:17 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Fri, 24 Mar 2023 11:45:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fiftzvbKtIV1bJkhbEBMSQJ7wuiSrCVmX73Lcti3+0xdkUMJBk5JjY6FToKssJaxujoolrYMFCTZvE6Krzt9qXFeeipkopG6ag7UkXeMZh1eO8DQSKvPunz195cwUmJgWFdMcKHDTC/CM9f8S/yY/UOx10dyJb6HnAwHD7HVWVKxFNb2dCWevBFek418qcYAu35LxT98/VSaU7mDPm87EQLbtsM4uSDFVjs3a110QQgnEbZQDnPTTkh7Vi+DgGYep8uChjOxN1ZP4KgkoE9HxbE+xw+APkUvpk+2Se84YGTf/2Se1q11H6KNEXxBEXY9ZI0OQv3t9yJsc2JQ4RYv/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rLWfeSX7XAubU252f6wMWhLLiIcOI5AIqyq7D3OObng=;
 b=Jt9lQHu9F2tiF+2ysouk4jQtKB8lkmpR7xuEN2Z37uHwu1QvZLYJm/Adqn1yf7aYnPnLdGxttl04xKlxsPTi5RRMEXX7Mt8b3lA4hat2fjgLxQnnvXyLHpb/JHWsVf4tL0N/12iMSe0S+HWlytobEc1OsnrLl006FVmrSmfThn52TcSa8g8/OlwkEl5XHaN94lJsPZYGCPlBoSazXXKvzk2/weNxQ4+7m3YIPAbiFSccgDikESNDh4oIhdls12RB58Y3sKT7X0HCpzmGu50XTnHWcPM6Qc6mNVe5zLYMUbjqZ/IhL3o/aDybXpdHQjFj4lghXmEHlIc2v8HQEOsAng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BY5PR11MB3911.namprd11.prod.outlook.com (2603:10b6:a03:18d::29)
 by MW4PR11MB6666.namprd11.prod.outlook.com (2603:10b6:303:1eb::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.38; Fri, 24 Mar
 2023 18:45:10 +0000
Received: from BY5PR11MB3911.namprd11.prod.outlook.com
 ([fe80::5399:6c34:d8f5:9fab]) by BY5PR11MB3911.namprd11.prod.outlook.com
 ([fe80::5399:6c34:d8f5:9fab%6]) with mapi id 15.20.6178.038; Fri, 24 Mar 2023
 18:45:10 +0000
Message-ID: <b9a2746f-bace-3a1e-eb82-8e8eecddb6ae@intel.com>
Date:   Fri, 24 Mar 2023 11:45:07 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.9.0
Subject: Re: [Intel-gfx] [PATCH] [i915] avoid infinite retries in GuC/HuC
 loading
Content-Language: en-GB
To:     Alexandre Oliva <oliva@gnu.org>, <intel-gfx@lists.freedesktop.org>
CC:     <stable@vger.kernel.org>
References: <orjzzlhhg8.fsf@lxoliva.fsfla.org>
From:   John Harrison <john.c.harrison@intel.com>
In-Reply-To: <orjzzlhhg8.fsf@lxoliva.fsfla.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR04CA0001.namprd04.prod.outlook.com
 (2603:10b6:a03:40::14) To BY5PR11MB3911.namprd11.prod.outlook.com
 (2603:10b6:a03:18d::29)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR11MB3911:EE_|MW4PR11MB6666:EE_
X-MS-Office365-Filtering-Correlation-Id: da8fc083-5aa9-46c3-97c6-08db2c97e511
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NlhDHwLsURDVxtNva8zpSvsleU346HP3e6lkVW0+hNdyMYkGDJfjsYBHvHd4iXmZI06cOHtEvPz8oooVOJCdR2sJGtg21Jx/G62n7VNPNcguZv2rSsh6gzh2kX36f3XokhQyB7vuRV7IlZaJ0VeVudyjx3ctiQRd0nSezP1lz/9X5emcb/BuqUH31Ol/0TLoVqhnRSpbXJJGbmpJ7JCbtLAeYdhLnAInQeO+LLWSywitSPkEokuPyoQ6LdJL8mblG52wpD9pP1cBJQuyhwDqAnQcJCfrxUSEsf+fKo/ev+E2er/e0AVVxCLR1oOkVB6HE5MMS0g0ZjUcRla7mNltwN/DhT6wc5pd+h5ERQsCVNE5eR92muKJFjL2BG04tTMSb2y7Wx3/pEUdLoRgdhIm8rNaU1LlAkj4nsVjcCHu4qNEqejbUqR53BhrnfYvbctNWGlkzCCQzR0iXd5dl580CTlIbLDaOpA1u7mVwLwy2GMAVcZ5o7vQwEzdwHnaO0/DSPT0sTct88G9hcXBtzgliVAYq4yr7v5MT2VLshSxuU9DaToXW/Td4n2mb7PTvovjS+bCJDShZiKr4nEYyIyv3xDzLMixKKkYm/y7jmNb2mPXb7RHI2pGbXgjUjRo38kqMMO51r0l8U6P/XxJMrJnyw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB3911.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(396003)(376002)(366004)(39860400002)(136003)(451199021)(86362001)(5660300002)(8936002)(4326008)(41300700001)(31686004)(66946007)(66476007)(6512007)(316002)(186003)(66556008)(6666004)(966005)(6506007)(6486002)(53546011)(2616005)(26005)(36756003)(2906002)(82960400001)(83380400001)(8676002)(478600001)(31696002)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cWlXbzhpVWpiZFFmd250cTFtWXFhWUppd1RFdWc0d2VNZ05KMGNTekVqdThG?=
 =?utf-8?B?VXE4UWlDUndKbTZGMmlaYXhpMVFidFVoSUlsQ2NEQ0dQUldIR01wR01YcmJG?=
 =?utf-8?B?VUhFanc0NVNVSVUzZlFPWTA2SUtiZkFueHFDdUVFdWhha0ZVbU5hVmJwZWh4?=
 =?utf-8?B?MEI4eHVxenNkMXdkUlRETDR4SVZIbWxoS2JFRmNHOW9qZFVLQUhRbGd1WFdv?=
 =?utf-8?B?c0I4MElndklBdTJJUk8zQkU2MkhjSjJsZ3pMNUNSR0FseHdmamw1SlljVm83?=
 =?utf-8?B?Q0NuL2dSenBuUDc2Y21yS09FU1F4Qk4yZlhjVU42Z0pGSlVDbE8wUnBGUFZ1?=
 =?utf-8?B?SFZVb2JnVXJaT2FaVGtGenFrTU5lanhFWE56aGxMS05kaHlVQ2lzbVpCaGlU?=
 =?utf-8?B?Zjc2UHJYYTluT2FqWUg1ai9CMVNFZ2IvRlV0QzlKY2paUnYwOFFmSGFXejFt?=
 =?utf-8?B?bXIvbmVxSExkemVrTFJ0Z3o1L0RnZ3E4dGgvT1hod0VMMy9Eb2R5QXBxcDJa?=
 =?utf-8?B?L2kycmZIQ0RiSVZtWGJLaFVtUXNiK2hXNzkyaGR4T3loZU9SVTZwcExLSGtt?=
 =?utf-8?B?VzBZbTJaUEVDaEswWmRPVGJFMG1YdWFxdXBoREtGcVdGb3VMVnpvRUYyZ0VK?=
 =?utf-8?B?djRmOEQ0R0UvMWNxLzQwclZPMUowM0dsUFZnUmNOQk8zRk1Gb2lTZ3JKUitM?=
 =?utf-8?B?UlBQa2FpTlptdnoxOThkbmRXbEZCZ2RlZERtaS9nb1RzS202WmJSRnJIUmRT?=
 =?utf-8?B?ZmRUV0hWZGNueS81SlFFajBiVFNMVWNNNGJSc25ZMGo1YVBXc1RBNXBLT1NP?=
 =?utf-8?B?TGMyOTVWdnE2ZXNWNU5waGt3clJMR1lNTjgvY1BGTmt5UzB4UGxnMVZLVHEv?=
 =?utf-8?B?cWhXRzF0RXZEclMwalRuNWFLdElSRjIxd1JNM2E3RUNoSjl6RHZ2WCtsTUVx?=
 =?utf-8?B?WGNrdlV5dllTNDRHSytVTWpTdkhWZkV6aHoyM0x1YzUvcDg3QWNMYkxGYkt6?=
 =?utf-8?B?c3UySU54S3pva21kVFJ6VXRtMGlEbGpXdTVicm1UYXEzM1lQdWtVaTBud1B1?=
 =?utf-8?B?QmVrcExhdmtEWGdMcXVKZFhlU0hCMCtpd2VORURxSGJUbEVXK3liQ0I1SldV?=
 =?utf-8?B?cG9kRkZRd0VFR3c3S1ZRanVTSjFJNE0zNUpZNDBWWDRSYW5MMVJPaEdaU2V1?=
 =?utf-8?B?a1A3LzF5WmxYdTBzMUtUVWd0Yms0YXlGMHpEK2I3TDNsT3BxdmYwd2d6S3l0?=
 =?utf-8?B?aHFnUFdTazJWclhxRmxyK1ZLblJwTzRkUE9HL0Q2QStVR21jZmpjMmYyejR1?=
 =?utf-8?B?NkpqR0RwUWZieXpXYmFOWjcybENTVHFpUnhrdERsazJETi9HOU52aGlUTVdw?=
 =?utf-8?B?K0d3WUt4eWZWMDNGcmZxdFVpTEl4Ykt0bm1CS2srcjJQSVV0bnl2Nk5Pcmps?=
 =?utf-8?B?Z2NnYUlmazJRRWlUa3VmM0FjL1R1N0RsNXdEQ3d4a003dDdQZTd5NnI2MDF2?=
 =?utf-8?B?ZmVQM0o2aE52RTlHdVRFeE03M3Z4NktYWCtwMUZVZ25DbmZkUncreTFOUjgr?=
 =?utf-8?B?a1N4STJwaWlabFBPMzRaL3pLRksvYWM5MHhMZWdMVE4vSlQ0Tmp0M0c1K1Yv?=
 =?utf-8?B?M2RBRHZzSkRpWm1xaUo0QkRRVmxHdzRjeWJpQmE2VFVVVlY3WGRxVllhSys3?=
 =?utf-8?B?OEVMeklvNTI0Z1hkaTdtWkVoamtqSTlOZ3hiK3RaSEpFYk82dEpiVjU4cDN6?=
 =?utf-8?B?OEJQM1pwWXVpcExsL082NjBxcEZ2NDVqN3podmxGU1ZaOHlGZlVqMXIwdStI?=
 =?utf-8?B?bnNjSjBRMDJBeFpIbENlWlpwVzhIZ0hyUVhhaTFjNWxyYldIcmVHVFE2aDVP?=
 =?utf-8?B?OTdwOGdxbTk2WHJCZGlxakcybmYzWFhzNElGOGEvWmJuUzc5UURTR2E0OS95?=
 =?utf-8?B?cnIwSFdEOE5YWFpJVWFrcWdKQnlpNTI0SWJjb2ViT3ByRTN6dW03UFZGaEl2?=
 =?utf-8?B?OU4xZFVtOTNhbFhKaStnYTBucFM2UUV2Z0tZbENHR284TVh1aWZDbFZXbUVx?=
 =?utf-8?B?VG9wSStjek5ralVjWnhSV0Z2TlFsY1F5c0ZOS0twR2dMUDNzMElETEdSTyts?=
 =?utf-8?B?ejFVSmpKejJMekxkMy8zM1RHUHVaWmJxdjVHOUVGd0dUTUxkU2RoWUVFZ2lq?=
 =?utf-8?B?d2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: da8fc083-5aa9-46c3-97c6-08db2c97e511
X-MS-Exchange-CrossTenant-AuthSource: BY5PR11MB3911.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2023 18:45:09.9595
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /pG6BdpCRSTenPr3wApxWH/N5HxUV06VEijj1ZReheVS/2Zu0bMDjiK+2sdOgXQFJcdnlUWMQ7CXdu2J7rMQt7WGRUjH681kJocVDS40T4I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6666
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/12/2023 12:56, Alexandre Oliva wrote:
> If two or more suitable entries with the same filename are found in
> __uc_fw_auto_select's fw_blobs, and that filename fails to load in the
> first attempt and in the retry, when __uc_fw_auto_select is called for
> the third time, the coincidence of strings will cause it to clear
> file_selected.path at the first hit, so it will return the second hit
> over and over again, indefinitely.
>
> Of course this doesn't occur with the pristine blob lists, but a
> modified version could run into this, e.g., patching in a duplicate
> entry, or (as in our case) disarming blob loading by remapping their
> names to "/*(DEBLOBBED)*/", given a toolchain that unifies identical
> string literals.
Not sure what you mean by disarming?

I think what you are saying is that you made a change similar to this?
     #define __MAKE_UC_FW_PATH_MMP(prefix_, name_, major_, minor_, 
patch_) "i915/invalid_file_name.bin"

So all entries in the table have the exact same filename. And with the 
toolchain unification comment, that means not just a matching string but 
the same string pointer. Thus, the search code is getting confused.

I'm not sure that is really a valid use case that the driver code should 
be expected to support. I'm not even sure what the purpose of your 
testing is? Even without the infinite loop, the driver is not going to 
load because you have removed the firmware files?

However, I think you are saying that the problem would also exist if 
there was some kind of genuine duplication in the table? Can you give an 
example of a genuine use case problem? If the same string is used for 
different platforms, I believe that should be fine. E.g. there are 
already a bunch of different platforms that all use the same TGL 
firmware file. Even with the string unification, that should not be an 
issue because the search is within a platform only. So there can only be 
a problem if a single platform specifies the same filename multiple 
times? Which would be a bug in the table because why? It would be 
redundant entries that have no purpose.

Note that I'm not saying we don't want to take your change. But I would 
like to understand if there is a genuine issue that maybe needs a better 
fix. E.g. should the table verification code be enhanced to just reject 
the table entirely if there are such errors present.

Also, is this string unification thing a part of the current gcc 
toolchain? Or are you saying that is a new feature that is not generally 
available yet? Or maybe only exists in some non-gcc toolchain?

Thanks,
John.


>
> Of course I'm ready to carry a patchlet to avoid this problem
> triggered by our (GNU Linux-libre's) intentional changes, but I
> figured you might be interested in fail-safing it even in accidental
> backporting circumstances.  I realize it's not entirely foolproof: if
> the same string appears in two entries separated by a different one,
> the infinite loop might still occur.  Catching that even more unlikely
> situation seemed too expensive.
>
> Link: https://www.fsfla.org/pipermail/linux-libre/2023-March/003506.html
> Cc: intel-gfx@lists.freedesktop.org
> Cc: stable@vger.kernel.org # 6.[12].x
> Signed-off-by: Alexandre Oliva <lxoliva@fsfla.org>
> ---
>   drivers/gpu/drm/i915/gt/uc/intel_uc_fw.c | 5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/gpu/drm/i915/gt/uc/intel_uc_fw.c b/drivers/gpu/drm/i915/gt/uc/intel_uc_fw.c
> index 9d6f571097e6..2b7564a3ed82 100644
> --- a/drivers/gpu/drm/i915/gt/uc/intel_uc_fw.c
> +++ b/drivers/gpu/drm/i915/gt/uc/intel_uc_fw.c
> @@ -259,7 +259,10 @@ __uc_fw_auto_select(struct drm_i915_private *i915, struct intel_uc_fw *uc_fw)
>   				uc_fw->file_selected.path = NULL;
>   
>   			continue;
> -		}
> +		} else if (uc_fw->file_wanted.path == blob->path)
> +			/* Avoid retrying forever when neighbor
> +			   entries point to the same path.  */
> +			continue;
>   
>   		uc_fw->file_selected.path = blob->path;
>   		uc_fw->file_wanted.path = blob->path;

