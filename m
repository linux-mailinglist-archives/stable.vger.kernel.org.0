Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74B5B67F17D
	for <lists+stable@lfdr.de>; Fri, 27 Jan 2023 23:54:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231960AbjA0WyB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Jan 2023 17:54:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231886AbjA0Wx6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Jan 2023 17:53:58 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CB1379F25;
        Fri, 27 Jan 2023 14:53:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674860030; x=1706396030;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=97KxcFRCgqw8RInU+Hc7E2LzEgfrhKEJ2tC8UCDnPxA=;
  b=eio5uv/CcHKYgG422l4tiQ27gLRHpz/HPsm6ADjyUuU13tag+c/GnD9V
   EkyjsHcKfetiq1yzlSybveslBeSwV9OmWY7xmIb3MNrb5SzcGRq9XRnSe
   NTFtVwN7V3KtS7mz9NZ09aHHU+X87CZETbC1WWxbw9V0TOa8bDroqIVkE
   oRx7l67AzQNEWMXDpE4oOcQsZTXn9etPMxrqAy4P+lYBES7Xj7Pz2SPbY
   jO7TX0NphsrW1lD+2Gz7hwkANOSAX29e4pJt8kSwA1h+39aqS5UKWrvUf
   gtmGO2r649yF7NMYmDtoydjYagYcdphcRAS04+4mS6HRg3OshUI/8HMkC
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10603"; a="306864339"
X-IronPort-AV: E=Sophos;i="5.97,252,1669104000"; 
   d="scan'208";a="306864339"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2023 14:53:49 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10603"; a="908821760"
X-IronPort-AV: E=Sophos;i="5.97,252,1669104000"; 
   d="scan'208";a="908821760"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga006.fm.intel.com with ESMTP; 27 Jan 2023 14:53:49 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 27 Jan 2023 14:53:48 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 27 Jan 2023 14:53:48 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 27 Jan 2023 14:53:48 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.104)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 27 Jan 2023 14:53:48 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mIkafeaEjAKD6IPdxGC6HEK0UjOPQXy6xmY6b8G+/Pfjgch2n7g4MeudY3e9VpHr3veZeVGXAyDcyhsd40+rfaMoA19CJ8JVA/lDPcBy2amKdWfMKHs1nPsEeKjFXo7V4599hE1maaOEUiGudwQNQZUoXvh6aMKndleXMYhCVm7aBTYRtlzrj5+qM+CO2oo2vNJ+TZ4ET6gbLjys5txEHjw5yGqKUnV7GCQITB11apEVcjw0NO2mRRRnFcS9a+dJwdPMs5N2oDTj+Nw3s/A2lDd940tvnaEHQ3EqbqVuPf2RNsLV0PtBAKhl1KDht+269520RGM+ogLjHcnPCm86ZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7k5kC209hBZ/xz1oDMTk3N7xXk263tl1y30mpW17i/k=;
 b=jPmKk3Q8dZ0zDfP+ZVA+k+IBVvJUyC4k9j5hAXXnYc0+eHQDKJcb/xMWEegITaOj6MwhxTe7ZLtdNxCzg/Lc/GJRQswH8VVl68UBcqAjMPsz6rxx8y2PprabFfDgqJERNh/25H7kdhWYVZs97X7BhlMdC518PYE6R9tHfy2zG1mnWwWbBrSwNvXOgwALL9AhRO0OegXD2SLrkoSrhJ8suiH2rHUHYsUp2Lc8HgQs701ZcCLcbjkCbkBzkLAbmi68KRtHZaHIm08Ziz91UtZ1Tf8fZ8obSnMbxVD7cNQDOTzw1pQ8Wy8koQj81qfKoNb9Pg6vi/UP3V00/+J+YqReVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB6733.namprd11.prod.outlook.com (2603:10b6:806:25c::17)
 by MW3PR11MB4764.namprd11.prod.outlook.com (2603:10b6:303:5a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.23; Fri, 27 Jan
 2023 22:53:46 +0000
Received: from SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::6851:3db2:1166:dda6]) by SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::6851:3db2:1166:dda6%7]) with mapi id 15.20.6002.027; Fri, 27 Jan 2023
 22:53:46 +0000
Date:   Fri, 27 Jan 2023 14:53:43 -0800
From:   Ira Weiny <ira.weiny@intel.com>
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Fabio M. De Francesco" <fmdefrancesco@gmail.com>,
        Ira Weiny <ira.weiny@intel.com>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
CC:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        <stable@vger.kernel.org>
Subject: Re: [PATCH] highmem: Round down the address passed to
 kunmap_flush_on_unmap()
Message-ID: <63d455f796cb0_7f63c294b3@iweiny-mobl.notmuch>
References: <20230126200727.1680362-1-willy@infradead.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230126200727.1680362-1-willy@infradead.org>
X-ClientProxiedBy: BYAPR08CA0065.namprd08.prod.outlook.com
 (2603:10b6:a03:117::42) To SA1PR11MB6733.namprd11.prod.outlook.com
 (2603:10b6:806:25c::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB6733:EE_|MW3PR11MB4764:EE_
X-MS-Office365-Filtering-Correlation-Id: c98058f9-384b-4acc-9010-08db00b958a8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qmra880KPqKfAoNMwBETiuAtqvGuazhdpGkaOPmLNh7IU4AdtjxkapsWpBfcw1vptV6s7GCHsSzSlCWx2JeOJQsc8ljTvWoyXyiDxzVNf3TfIFX1CVVxtCIg2UkLtM3YBp6HfSQn5xq6JmRJUZLWlraVJheCw6cMB7b7Dyb/R+oJbIWF9ZfmZGRwry3W2hkaH0osGG3x+9Jc9z6FXqMRIfuINI//eF23IkaTWIyNX6kK2PcZWailOKuDj/n7Hd6nO6GN9wpG1LZBzvFOB6IsA6MFVkDmkHzpmhL1BqWWzAtF7XphtMXzfNO7ZTVYS//IY+4+PhGPXjAqfL7imWixdZoLL3NiDzz4nffjFinbycUUhO/v34gQezBB9/bqS/GGj44AxLwgn6GAfGPxmAs1qqDr9FfkrtMA7l5tY7Iz4jYxIfx1ubWw0dTXivA3jBmpeClFjhyU1Weic+rPIembxxZ9vIcJGfhDNcB8YNM7YkWnYyfEZra5c8MiFlnsUgdTbCeLjGh0qPw3MIinzH8V1EkU7My3y+NKJUoQTEOuxPW6mCyLwPevtYlvbz3fskmxj9hHOhi+3BPM31hGjhSuQdobkUJduVJljHiCCaVeXUa+Eg9gglT/+4A0vaQx00P9nthYzkDz6/MGdRfSHPmSdQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6733.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(396003)(136003)(366004)(39860400002)(376002)(451199018)(316002)(8936002)(6506007)(6666004)(478600001)(6486002)(38100700002)(82960400001)(86362001)(9686003)(186003)(26005)(44832011)(6512007)(110136005)(2906002)(83380400001)(8676002)(4326008)(5660300002)(41300700001)(66556008)(66946007)(66476007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2mXMNR8WGKa4SQuKZkVDKydWhFB1DihbshxfLgcj9GEXWND6d0gGM4FCBi4x?=
 =?us-ascii?Q?FSSfINsjECNckaYEPB6UoBiFbwcMiq+FTUapgvNNaHFYGJBY+vqOtmdUQOY2?=
 =?us-ascii?Q?uEA63BvwGVAnw3oFxM69iplAP66VTiDngdPyPaswkYRk/F4YIP4LHU+hc8Z2?=
 =?us-ascii?Q?wgEeGgT1a8DbbrIaD50dkCa/QLX+00RmICs+N6a/kBLeumEUfvS8AliBHrbv?=
 =?us-ascii?Q?xzr2UFGKKr/pUFmxXxb+ssGg0Q5ygNV4MZ+l0odraTVZQ4UxR6lk8QHqd8vo?=
 =?us-ascii?Q?LijmRe1yes0l4XvwsJXLLKXUNY1wyI0feoJZgRda0jBjbbmA684a2w1ClB02?=
 =?us-ascii?Q?QoS7pYvPfksRJcObusNcUgOUkLV9DGoDm/xLaw3AxmTPYS7M4iCWeyWPN2Dz?=
 =?us-ascii?Q?9zI0ao6ENyL4PuA6cC4c+agZK0Ywoq/Gxy5kc8mXnkmNaymdRkNJdHxSKLPi?=
 =?us-ascii?Q?qVCBO33m4egH/MTJsrRW/pLnnwkNHVAWAiRuZ33YB/g5iz0fOEO2fVKylE8u?=
 =?us-ascii?Q?OZ9VfSWNnSGoDnL6KVnBD5ROMv0ik18DqSlaLFRvGSFw4VkhGDB4GfqIo1t0?=
 =?us-ascii?Q?xeXqq/CI8L0SGec1fSFVcsUuHEkBWkHJODJk7P0o8NxrkOovbBx213PtAcGo?=
 =?us-ascii?Q?G1XolhVR9jNFWNC2TKQUa7aNItxR+2LNjqiNA5lAz568GAdzG3oAsbXesQ9/?=
 =?us-ascii?Q?gWI7IzLYZ+CscPk5874vHECntiPZ9lA05kgJbS222+mzYbb7NFKNGb4Ofq0N?=
 =?us-ascii?Q?9rPQ0CA14WW+bAdBobGiIn+dbiarChc5N/VxI2Grn/Heq8l/eGu60L1crPyt?=
 =?us-ascii?Q?+XeyIIAZ3HFj29zq/oRtHvdmggOM6v7OxLOuvP79Ekw8fCqJmRdStMthMxMf?=
 =?us-ascii?Q?/3E25Z0mEORtNZMkrKDD8Pv80ZO+iwRXKHkPbQKZvqBR8P5zMu4ddVYSyM5r?=
 =?us-ascii?Q?S6uGNtkd9e2NjGDHJKBJnNz9goIR8RDhxl3O/L9rrq+lNim5g45D0XElFN5G?=
 =?us-ascii?Q?I4gG5xH/18+leYES8tI9owjInPw+FdqSnI3PseuqXm91qRcAktNA8Zy1NrXJ?=
 =?us-ascii?Q?tiyi9+PQjClBcaMGOa0AT58oW/u+o5P/5B7BMRb2Vqw77vs+bmT3rxH9UjAH?=
 =?us-ascii?Q?OHqEY1E1k33vmGNaRIokX+De13kOULUo0g8shyBItOR0WGqBaaxK2p6OK9qy?=
 =?us-ascii?Q?g1JpE59OdIrgn2UGiww49lm28Bl+PyTdYlyiv5TGYMduNEOFeWg5TuZFSptX?=
 =?us-ascii?Q?/rBuzV/06M7IbJUKfOgw2MJAnxmxruda5aYaqlnxM07rcuHejo8nnFoR+34n?=
 =?us-ascii?Q?o8fIlwLl6spG6tvz/SdMq7c124UL8aIiDjDmYEvbFjIaGm6GVShkcTwWUPDl?=
 =?us-ascii?Q?PwY20hv1eHw21K0etC/QXhWjWmqcu3nmzkr5Fp1QaeJoaL1kBtTkejgh1x3z?=
 =?us-ascii?Q?pVZOAaELLk1DkE5eRJtd1UAFJcVKcx6jPFMX3iCqtuQA0LIOevj3GzWCadl8?=
 =?us-ascii?Q?mU7AXg8kZqPwdgEOKDvMmplquoOewien0ho5IIHFfEfdMKyqNwnG1WJ/rrX9?=
 =?us-ascii?Q?rsWxO1TDpw1Z1a9e56h4ORfJHhGJAy0XPDZ8u62i?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c98058f9-384b-4acc-9010-08db00b958a8
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6733.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2023 22:53:46.1948
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mAoVoiODn1K+Hs5FLPguvqnrjnWYZiKYSQGmIecn7/QOHxcW8Vzs93K3JhuuhVSo8EdBwm+YjLE3u9NG/AJk2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4764
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Matthew Wilcox (Oracle) wrote:
> We already round down the address in kunmap_local_indexed() which is
> the other implementation of __kunmap_local().  The only implementation
> of kunmap_flush_on_unmap() is PA-RISC which is expecting a page-aligned
> address.  This may be causing PA-RISC to be flushing the wrong addresses
> currently.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

Reviewed-by: Ira Weiny <ira.weiny@intel.com>

> Fixes: 298fa1ad5571 ("highmem: Provide generic variant of kmap_atomic*")
> Cc: stable@vger.kernel.org
> ---
>  include/linux/highmem-internal.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/highmem-internal.h b/include/linux/highmem-internal.h
> index 034b1106d022..e098f38422af 100644
> --- a/include/linux/highmem-internal.h
> +++ b/include/linux/highmem-internal.h
> @@ -200,7 +200,7 @@ static inline void *kmap_local_pfn(unsigned long pfn)
>  static inline void __kunmap_local(const void *addr)
>  {
>  #ifdef ARCH_HAS_FLUSH_ON_KUNMAP
> -	kunmap_flush_on_unmap(addr);
> +	kunmap_flush_on_unmap(PTR_ALIGN_DOWN(addr, PAGE_SIZE));
>  #endif
>  }
>  
> @@ -227,7 +227,7 @@ static inline void *kmap_atomic_pfn(unsigned long pfn)
>  static inline void __kunmap_atomic(const void *addr)
>  {
>  #ifdef ARCH_HAS_FLUSH_ON_KUNMAP
> -	kunmap_flush_on_unmap(addr);
> +	kunmap_flush_on_unmap(PTR_ALIGN_DOWN(addr, PAGE_SIZE));
>  #endif
>  	pagefault_enable();
>  	if (IS_ENABLED(CONFIG_PREEMPT_RT))
> -- 
> 2.35.1
> 


