Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BC736DD302
	for <lists+stable@lfdr.de>; Tue, 11 Apr 2023 08:39:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230297AbjDKGjN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Apr 2023 02:39:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230307AbjDKGjK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Apr 2023 02:39:10 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B33F110CE
        for <stable@vger.kernel.org>; Mon, 10 Apr 2023 23:39:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681195148; x=1712731148;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=CY97PdfyW0w08DQUBbET3b63Bqc54gzh2j2pe/z+JRE=;
  b=BzogBSUcJjpQcC2guaHk8i6F+cH+D2jEhLOvub9JBtKmCgJ8BiKN5v7G
   rB4PjF+JmcVMjSx5M1HEZUsaDBdnjuwNv5bBihB/f+FQioB96Lto8bfnF
   cgy5ZIl3SovJy0stxTfMJM43IA5yTnNCqJDv2CHp8MyIa3GjdI71hOBS5
   l7mBi3YgynEB2u7/wV4aMdRzljByKT2lZ4n6MZDyw3T1wwhwjrZJ40BxN
   RpVoHIfG8OvqhawHJGsZfrGKMVBwe7rA4vQzH14fgbRjoHn9783UTQ6dS
   d6VLVyaCq3bZFC2g7H5rFXC/X0oBBIII3RNnPQfGEHjc1tjtNtqxSc3Yn
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10676"; a="342303377"
X-IronPort-AV: E=Sophos;i="5.98,336,1673942400"; 
   d="scan'208";a="342303377"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2023 23:39:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10676"; a="638703506"
X-IronPort-AV: E=Sophos;i="5.98,336,1673942400"; 
   d="scan'208";a="638703506"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga003.jf.intel.com with ESMTP; 10 Apr 2023 23:39:07 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 10 Apr 2023 23:39:07 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 10 Apr 2023 23:39:06 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 10 Apr 2023 23:39:06 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.174)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Mon, 10 Apr 2023 23:39:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oLBbMeQMrRXnkpVg4KTw9Cy9Kl6zj1eLJiTq8e6hDnGAW3YV5fv5abKqKASouoQtJYGs4EJBDIv24n8b8O234umEimz3VBOYX50cq9gJvafuoDoTVhpLW+qZXxjVWIp9loYvH+qJdP8/L89OiwuZ0d3liraWLl5Fd3Ha20c1hHHcfdJgr1XmnbhQWUNTTBgT48bkXYDfcZ6Q47QJXWAgaRdS86+/YpMD7bxlBIiWB01je6HL0QpByzFTKXM5Jk94Gt20Kf6nT43J6vIZm23TG7iwiRB54csgU7+Wdle3oiRdBcbez6RspeJq3XETtN+QCASFddkKXBHdMFgXLONPGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ayXwhJzv9Evyc2sZvDKbIB/CzdLb9kfBLv57TfJkVWs=;
 b=d5DlStx3DiKycYyVMhXUckHw+jNDLe+iEPU5iFTkRrNB6mky4nk4rbz6PsM+QaoAPTKHNvGunmC6KeYqYca4mIyeGVf4hnbGKjecUh4tntYSvUNVkL26HyhI4Kr6p9VusLWjw9FJFZC9khbsMsnucV6FpviUdeqsv7X2pbrFhoJvuLntPzCUJbU++QF9D25lAmUL7g/fvj0/2k+5ABKSm2rnFJGgtqVPLsXBpP2e+vZT3XdJjmLJ8X+qwH6JcnZF/CFjqL9O4H6MpqGk80FAAU5sqE40RPNEdMFp2lS2HLI62q53JhaCDNXGe57pJsINr69UcJUKf7dS8i6ZgbrPjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL0PR11MB2961.namprd11.prod.outlook.com (2603:10b6:208:76::23)
 by BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.36; Tue, 11 Apr
 2023 06:39:05 +0000
Received: from BL0PR11MB2961.namprd11.prod.outlook.com
 ([fe80::6c34:bbe1:bd34:aa2d]) by BL0PR11MB2961.namprd11.prod.outlook.com
 ([fe80::6c34:bbe1:bd34:aa2d%5]) with mapi id 15.20.6277.038; Tue, 11 Apr 2023
 06:39:05 +0000
Message-ID: <1bee29d0-a5cc-9ff3-d164-f162259558e2@intel.com>
Date:   Tue, 11 Apr 2023 08:39:00 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH v4 5/5] drm/i915/gt: Make sure that errors are propagated
 through request chains
Content-Language: en-US
To:     Andi Shyti <andi.shyti@linux.intel.com>,
        <intel-gfx@lists.freedesktop.org>,
        <dri-devel@lists.freedesktop.org>, <stable@vger.kernel.org>
CC:     Matthew Auld <matthew.auld@intel.com>,
        Maciej Patelczyk <maciej.patelczyk@intel.com>,
        Chris Wilson <chris.p.wilson@linux.intel.com>,
        Gwan-gyeong Mun <gwan-gyeong.mun@intel.com>,
        Andi Shyti <andi.shyti@kernel.org>
References: <20230308094106.203686-1-andi.shyti@linux.intel.com>
 <20230308094106.203686-6-andi.shyti@linux.intel.com>
From:   "Das, Nirmoy" <nirmoy.das@intel.com>
In-Reply-To: <20230308094106.203686-6-andi.shyti@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR2P281CA0035.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:14::22) To BL0PR11MB2961.namprd11.prod.outlook.com
 (2603:10b6:208:76::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL0PR11MB2961:EE_|BN9PR11MB5276:EE_
X-MS-Office365-Filtering-Correlation-Id: f99d98bb-daaf-4d94-11eb-08db3a57719f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: U+MW50xNA8NSlI7mO2QdNv/AMJzoUv1KbIQ/MDk+HJ7sHJFE74357vniMxb8alvvuqXjjGHLBKqcxyvwxl0U4ge/1BtZKDbzh3UKWFzJAv+n3oijkQIEwL2DAXrlWKkU0ZM5vFVnuobNv2J6o1kuneeTlfz0eSwts+qWFO3JLqjZQzFk/1z1dAb4hdjOrO2FBCv6dbKR7E3RMOYqHKAWg8Ui2u25+QymVztJen3c7NTVPOHPYXnpnQ2UeONS5fTRwer9C+LDe0mi6kZFYWjRjkO7leJ0dHBBVPGQfd8qsY791lLhDuK3AkLF1K8lfdDyjuXPcHXjyX177s6c7bIJu1bwsxWT4uESGL6oD72tNuXFA2ILCFGO2YAwnyVtMnVXEcgVV4vFPzTUZ+bX7/NdeRNpe1E43EU1YvlND0GvClyNSoFEDP6pTkZLRnWtWfQcAyfANokxoSQIXxhxc7Ej5zvcKyYjAvihz0mBKwLdFe86pUzXMEVac8DzgqidAyn0kRqt2BpCyIyOKes1CibPkf04x8u/7hhW15jxzozqvYW5FbbK9FDsU+lTq8ma6vA4CD8SAMTaK2Mt1o+LCKqo/SLOk1dGCtqnkrorZdJTfQin/yz2oFHzblgnoww3hg9eBL8SV0L1RWaFILIJbAsBww==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR11MB2961.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(39860400002)(376002)(346002)(136003)(396003)(451199021)(478600001)(6506007)(316002)(54906003)(53546011)(26005)(6512007)(186003)(6666004)(6486002)(2906002)(66556008)(66946007)(4326008)(41300700001)(5660300002)(66476007)(8676002)(8936002)(38100700002)(31696002)(36756003)(83380400001)(82960400001)(2616005)(86362001)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?clQwbkFleG1LdjFCSkdTUlpzSnp5ZjlleE5qVVJqSzF1ZmpDdUhJZ255YlVJ?=
 =?utf-8?B?MVlwRkF1bkZ3RUxQT0xCUWFnTjlNNjdWZmZhWGsxbm83UDhnMjN6U3ljbHI1?=
 =?utf-8?B?MkkrTjBYNTdBaGNrSXg1cDZ6TzZyN3dZSTgrbS9TcVAxSUtuRkpBMXNMcmp4?=
 =?utf-8?B?bndFSlk1aUhtcC9MVHRXK295OUpBcDl0dEl1WWFRVlhOTGF4WlpBRWlkOWRF?=
 =?utf-8?B?SzFxWFNTc3dhdFpzNGIvOVFIUWRaanNHTzJ2ZXdlK3F6bVJPM0dXcmRkNE01?=
 =?utf-8?B?Y1NERWRYS29LQ3BYZm5yeW8zT0Z4REhBSERzQjhGQUNGN0xjaVJhTHdmMU5v?=
 =?utf-8?B?eE43bEVsNWxwcmFWcllvVFpDdWFiWDNCRkl0OUZSUFV0cFVjNVZ1TFBsMzNr?=
 =?utf-8?B?SXhETzdva0UzaS9zQUtRMk9rWWg4ODh5N3h5aGZQZEF5Rk9JQmJtNUsxelF2?=
 =?utf-8?B?WTJMY0NGaDBpVzZTVE9QR3JyNFlPZG52T0Z6cnAvdXNhdDVxVWpWYUdaeUpn?=
 =?utf-8?B?aHZRbld0OTdkZGRFWVBTTFJHVU1vWVBET3hIS1BDbTFyd0lOQzRDeDBpcy9O?=
 =?utf-8?B?RXhFc2RycHhkemlhZlFmQi9Jc2ZrWEZuSW5ucEt3NHRJUUxBeW90Z25oTkVD?=
 =?utf-8?B?YVVMbDJZNUNQS244WXVhaXdBNENGTmRzNzNtNmxyY3ZTbEp0Q21iQWwwMG5W?=
 =?utf-8?B?N0lOUk1xVXg5STZSYTdQUEpMSkI1eVZOZ2sxQ1NzcFpJTWIzTnY4MGFlOThq?=
 =?utf-8?B?M0F6NWZUQ3JOSXpPVWtxdTczUDhWbWxHS01YeEEwTk8xNFdXSmtkZ0lQeVFU?=
 =?utf-8?B?VWlEZHd4YjNrNWhVWE1UbzljK2Q5b1V5UERyUnBEQjlIUmFtNHRPcUwxTzkv?=
 =?utf-8?B?VlR3SXdudDg1UE1CRklpRko4ZFZhQ3VNWDNEcmVwWXQ4bjlGY0k0N0orT1JS?=
 =?utf-8?B?WTB3N1M4bmlhZERyd1VNK1VBeUUxekNTUXRSU3pLdml0TTdDNGtSZEJZdUhu?=
 =?utf-8?B?VlE4ZjRPajJCdzRnMGZBOE5RWTVwamhsdjd1MVg4SFd3c08xL1U4eHpJeGVH?=
 =?utf-8?B?eFdOYnQvNStJaExRN1U2Q1hpSFFMZEZkemVlcGZLL1Z2M0U1K3JreVVDay8v?=
 =?utf-8?B?VDJ2bGdqdGFra0MzNGI3L3JOcTY0V2MrRFNGcHZhUVRPdVg2MEJINUtJT3pt?=
 =?utf-8?B?WFVVSnRwUHJqL0thcUhUVWRBN0VPRW5PTTFvRXdHdnM5blNydEpNejdOWkVt?=
 =?utf-8?B?MFJ3MnNhTStEa1dUVUVyQTB6QzViMUV4WEpwc0V1UU03c1ZZOVhNSHVvOTRK?=
 =?utf-8?B?a0gybVRYSURFRU9jVndGbmhxR2llZWFQQTA2MVByWENxSDVUTUJrazZwT3NM?=
 =?utf-8?B?a25lTDJackJieC82bmNFWk1hVDd4WDVrRXNNbFJKRjZJbXJBa2x5aFdQU2hV?=
 =?utf-8?B?R2VkaVFuTGcyTld3WHZCcmNBdHhpL3lHM1RUWVBiTXZzV09EUHJzYTRDaEdu?=
 =?utf-8?B?SWpjdUM4ME9SY25mZHNraWo5TlViTkFFNE1TNURhUnd1U1JMZWx0OFFRb1M1?=
 =?utf-8?B?V1hkNEgxR05XbG9TMEtMOWZnZmFIYmRUbm9OU2xVOFhSWnZMaDZia3E2NFBE?=
 =?utf-8?B?VkJUeHNTYUtSbGljY3hXZ0Y1K1JqYmlId3pyUUdUdUhmeGZNK2E0NDRiZXF2?=
 =?utf-8?B?SUVFT24ybi9lNi93QmYyenVjOUVCeUpmT285WmJiYml0ZVlVbkpGNUJtSTQy?=
 =?utf-8?B?bUhRejJ1ZERlZFk4QUM4YzNEM2hrQUsvd0MvVUpUdU1FQ2VUajB2QVpNOVgy?=
 =?utf-8?B?TE5WTm43WjZ0RjJFcUlFMUtHdU82SnpDSUlWSlRNelZaTS9mWXMxSEN6cWwv?=
 =?utf-8?B?QlN0bmFxbjVPSDd3Zkc4cFFqL0ZRMHprSGVuTmRxUnRyekQ1R0o1TENqcFpp?=
 =?utf-8?B?NUJnYldXSytXU0xJOFl0aDZ2V25ZRkdlYzRFSE9xUExPNlhrU2hrK1EzNXJE?=
 =?utf-8?B?TmtXSUg5ZmtkL0RHKzZuOXl4bmgrZUlVSVFMOFp1OUhhYUE2K1BSVFpaWkNE?=
 =?utf-8?B?OWVSb0NxclFnLzY2cmE4UmF3UHBNbzBtU0NXeFA4UExETEZ0bm9BZ0lWRFlw?=
 =?utf-8?Q?tzp4ng+/KseMucsc/6ZyslFOU?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f99d98bb-daaf-4d94-11eb-08db3a57719f
X-MS-Exchange-CrossTenant-AuthSource: BL0PR11MB2961.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2023 06:39:04.9399
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KpGIcRbBPfLfP+vqqwB/RQRye+ZiJGq7CTDESrovOS7y6B4uUb467og3fx9CbgzfXsVBy9cOzsyE0TIzkbsXEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5276
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.7 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 3/8/2023 10:41 AM, Andi Shyti wrote:
> Currently, when we perform operations such as clearing or copying
> large blocks of memory, we generate multiple requests that are
> executed in a chain.
>
> However, if one of these requests fails, we may not realize it
> unless it happens to be the last request in the chain. This is
> because errors are not properly propagated.
>
> For this we need to keep propagating the chain of fence
> notification in order to always reach the final fence associated
> to the final request.
>
> To address this issue, we need to ensure that the chain of fence
> notifications is always propagated so that we can reach the final
> fence associated with the last request. By doing so, we will be
> able to detect any memory operation  failures and determine
> whether the memory is still invalid.
>
> On copy and clear migration signal fences upon completion.
>
> On copy and clear migration, signal fences upon request
> completion to ensure that we have a reliable perpetuation of the
> operation outcome.
>
> Fixes: cf586021642d80 ("drm/i915/gt: Pipelined page migration")
> Reported-by: Matthew Auld <matthew.auld@intel.com>
> Suggested-by: Chris Wilson <chris@chris-wilson.co.uk>
> Signed-off-by: Andi Shyti <andi.shyti@linux.intel.com>
> Cc: stable@vger.kernel.org
> Reviewed-by: Matthew Auld <matthew.auld@intel.com>
With  Matt's comment regarding missing lock in 
intel_context_migrate_clear addressed, this is:

Acked-by: Nirmoy Das <nirmoy.das@intel.com>

> ---
>   drivers/gpu/drm/i915/gt/intel_migrate.c | 41 ++++++++++++++++++-------
>   1 file changed, 30 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/gpu/drm/i915/gt/intel_migrate.c b/drivers/gpu/drm/i915/gt/intel_migrate.c
> index 3f638f1987968..0031e7b1b4704 100644
> --- a/drivers/gpu/drm/i915/gt/intel_migrate.c
> +++ b/drivers/gpu/drm/i915/gt/intel_migrate.c
> @@ -742,13 +742,19 @@ intel_context_migrate_copy(struct intel_context *ce,
>   			dst_offset = 2 * CHUNK_SZ;
>   	}
>   
> +	/*
> +	 * While building the chain of requests, we need to ensure
> +	 * that no one can sneak into the timeline unnoticed.
> +	 */
> +	mutex_lock(&ce->timeline->mutex);
> +
>   	do {
>   		int len;
>   
> -		rq = i915_request_create(ce);
> +		rq = i915_request_create_locked(ce);
>   		if (IS_ERR(rq)) {
>   			err = PTR_ERR(rq);
> -			goto out_ce;
> +			break;
>   		}
>   
>   		if (deps) {
> @@ -878,10 +884,14 @@ intel_context_migrate_copy(struct intel_context *ce,
>   
>   		/* Arbitration is re-enabled between requests. */
>   out_rq:
> -		if (*out)
> +		i915_sw_fence_await(&rq->submit);
> +		i915_request_get(rq);
> +		i915_request_add_locked(rq);
> +		if (*out) {
> +			i915_sw_fence_complete(&(*out)->submit);
>   			i915_request_put(*out);
> -		*out = i915_request_get(rq);
> -		i915_request_add(rq);
> +		}
> +		*out = rq;
>   
>   		if (err)
>   			break;
> @@ -905,7 +915,10 @@ intel_context_migrate_copy(struct intel_context *ce,
>   		cond_resched();
>   	} while (1);
>   
> -out_ce:
> +	mutex_unlock(&ce->timeline->mutex);
> +
> +	if (*out)
> +		i915_sw_fence_complete(&(*out)->submit);
>   	return err;
>   }
>   
> @@ -1005,7 +1018,7 @@ intel_context_migrate_clear(struct intel_context *ce,
>   		rq = i915_request_create(ce);
>   		if (IS_ERR(rq)) {
>   			err = PTR_ERR(rq);
> -			goto out_ce;
> +			break;
>   		}
>   
>   		if (deps) {
> @@ -1056,17 +1069,23 @@ intel_context_migrate_clear(struct intel_context *ce,
>   
>   		/* Arbitration is re-enabled between requests. */
>   out_rq:
> -		if (*out)
> -			i915_request_put(*out);
> -		*out = i915_request_get(rq);
> +		i915_sw_fence_await(&rq->submit);
> +		i915_request_get(rq);
>   		i915_request_add(rq);
> +		if (*out) {
> +			i915_sw_fence_complete(&(*out)->submit);
> +			i915_request_put(*out);
> +		}
> +		*out = rq;
> +
>   		if (err || !it.sg || !sg_dma_len(it.sg))
>   			break;
>   
>   		cond_resched();
>   	} while (1);
>   
> -out_ce:
> +	if (*out)
> +		i915_sw_fence_complete(&(*out)->submit);
>   	return err;
>   }
>   
