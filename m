Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 162C55B2731
	for <lists+stable@lfdr.de>; Thu,  8 Sep 2022 21:54:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229512AbiIHTyR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Sep 2022 15:54:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbiIHTyQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Sep 2022 15:54:16 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7944F8D3F3;
        Thu,  8 Sep 2022 12:54:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662666855; x=1694202855;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ovIj3foyQNZEcuomfI6jTkUzLmltpV1ELcDL3DJrx24=;
  b=EA/Sp9sqjBknzVkAe5xvDaAuj7YHJ17iO3P69jzS+LMcGv61zmvD0w4y
   3Xoc9WR7bbB7QKZKTI9PzPYN9v4xQIvcTl9xAC9buGnrWHBXqX7JapUdS
   RL8dWiKNQZ5g9Zi08HNHQIhftIRJf8XCtnsb9EGxQaZrm8zPzCqwQDa4J
   HDFaxYz1j/T142cgvGYlXQ6MOpnxU1wzG/HSTqPiDTt23g8FECkHXESf9
   E8X1LQN7KNWBnGTqPQhlG7SSkrbWXLAKXYldbLCvdrngHsmS0OV39+Mr+
   nYRQsO9OMHHJJUrhYbXP8C1MoS1uS3xjiu+/3jN4HNKAme4P3XMcG4cCh
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10464"; a="297307992"
X-IronPort-AV: E=Sophos;i="5.93,300,1654585200"; 
   d="scan'208";a="297307992"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2022 12:54:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,300,1654585200"; 
   d="scan'208";a="757340103"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga001.fm.intel.com with ESMTP; 08 Sep 2022 12:54:15 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 8 Sep 2022 12:54:14 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 8 Sep 2022 12:54:14 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 8 Sep 2022 12:54:14 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.170)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 8 Sep 2022 12:54:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JLSXaK3Zq4025esLRLqrNaYsATYdw0HMJyCQUeUZC/UkcBKf/IWgQhwKbXXJyIa4FV56d3eyP/jSt5Ck7bGXUQlOamtBwwxoCzXgQ9ZC9xV4/xiIEskb7ZPS8T/iXeQT2exd3KOKQT4AO0u5i8mLy/l6+/mny/ADhSJUwqSRwknPgRW0JFAj37/IJNVeXjoTGMX/F3+Hcqu65iofIcWS3rz5QbSl+KCKhSPFg4HrMWIvKJcvIWx1yaowPH1tEVL3sLw/B5MHh/LEheRWrm9gyFToMfHRrSNLMj0P6djEtX+y97RTZfgf0zmC27pzaMUGjMGY5/oawtWQY54dXSfL7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NS9E8r3FdjXhV/k2hdYS6lsyeREv5wkFBptxM/T+lDg=;
 b=ct8fA8RR9Z5w5V3d/zt3VpLeub5WrYZaq23qKqacLVHNR+FDIe2Ha3UA3ALZZt4ihAo+vEe9wThdNP3kIeEaeyo6CzpoumhmoX5pA7jOFyo0G+dWU5M6vTqMKYKqP0Srllpk5eA/m3rFYg4basdpJONb+JcqhsDDZPFu+rmRMFH4TwfnPU1DVm09ge2pqO6TujPhiHCXS9cgq1gfSK3WPfJ6UFjfeZ0NP/i08fgGwVXZ2ep1ZxjU7JSDG8zCsurLm0kl6sZJdlC+VujMMcAtmx8SJPTk9BLpj8hMeM7lsgOqklebGTCwAeCtx6kRNvtzE96Uor87syfXwvNfVSofpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY4PR11MB1862.namprd11.prod.outlook.com (2603:10b6:903:124::18)
 by DM6PR11MB2716.namprd11.prod.outlook.com (2603:10b6:5:c7::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.17; Thu, 8 Sep
 2022 19:53:58 +0000
Received: from CY4PR11MB1862.namprd11.prod.outlook.com
 ([fe80::a824:112:52f7:5743]) by CY4PR11MB1862.namprd11.prod.outlook.com
 ([fe80::a824:112:52f7:5743%12]) with mapi id 15.20.5588.014; Thu, 8 Sep 2022
 19:53:58 +0000
Message-ID: <c39e5088-b26e-b518-d7ec-3748f6bb76f7@intel.com>
Date:   Thu, 8 Sep 2022 12:53:55 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.2.1
Subject: Re: [PATCH v3 1/2] x86/sgx: Do not fail on incomplete sanitization on
 premature stop of ksgxd
Content-Language: en-US
To:     Jarkko Sakkinen <jarkko@kernel.org>, <linux-sgx@vger.kernel.org>
CC:     Haitao Huang <haitao.huang@linux.intel.com>,
        Vijay Dhanraj <vijay.dhanraj@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "Kai Huang" <kai.huang@intel.com>, <stable@vger.kernel.org>,
        Paul Menzel <pmenzel@molgen.mpg.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>
References: <20220906000221.34286-1-jarkko@kernel.org>
 <20220906000221.34286-2-jarkko@kernel.org>
From:   Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20220906000221.34286-2-jarkko@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR07CA0082.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::23) To CY4PR11MB1862.namprd11.prod.outlook.com
 (2603:10b6:903:124::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 941a3509-143a-4e64-05af-08da91d3de6c
X-MS-TrafficTypeDiagnostic: DM6PR11MB2716:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gObBpzeK1mtrLvdd7TBdQbR7gRE/azpiikN5DYFMX/Q6ch3IGDKFo5RmX/zPUYCyWp4nagf/nmy1uw6A4YMHi7HaP8Uu6VoaCDzq0DaKMqpaYpC3Kah8TKrQkXfXB2HBuELt2790rcOeCq1XCK5RW2DyS2FaLTASdoI6MesglXnYcHigpaneB67pffLR5Ggi00vf/N2D4pWu8fJGtgsd/vG9w7isieWUc7A5B7P83546F6Kc8r5C56eAM45C7bExC8RV6uzpV8+3n+YTCvs2rXmcKAJ9hRaoDf7wmm35ILWk6QYql3dnRRjmZlwX1GFxCYIyi/aZq6JkmepEK/ylFYboAFgbvwjeElJJ3CmaO5QdjBt15nl7uduKkrhS5VkRREMTgdqV8QxUIaPl9a15ytBEyZ8fjErOkIlOzswytpC6otJSZBe0ci+7a2dRk8ptmwH4QPJPHYwmQOOL2726cBq6j+3hvZ1aWLM97ftKfvNQYP7WfSpXIbpoH9K/Lep/AVcjWLYqxKokvMMDmvjvyI3fmMujQEaZGQVV0RW1uXmfwpWkxdODUD43PGGzFWBEeMLJMsldp5DqGC24x2MaHwPuf+7HUBtHbXY1d1keRmOFNNDwY6YcZiTjRbSlTBbPebx6OQQ7iifaJaoLcWJiJtg/T1EY4rJwZKsxR5gqlV86+l8u50t2Ft/quNruCVxesvMDx2OlbTNSicExim2i8mcRYCpc1nPGwl1Vsgwm8HrJBaIo8ECjOWS9za8EiBqvGxwzVgfXRtoFI0WUTHhf/9nPp3jg+G4rZ57Hikn0hTOOVJSvwc6OyJUM4SpfhreBg+4ba6yBGWyMV1ITs9XMqJQugo8fbYS85AuhAz9nCQg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR11MB1862.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(376002)(39860400002)(136003)(346002)(366004)(36756003)(6486002)(2906002)(31686004)(31696002)(66556008)(41300700001)(8936002)(7416002)(8676002)(5660300002)(86362001)(4326008)(66946007)(44832011)(54906003)(316002)(82960400001)(966005)(38100700002)(66476007)(186003)(6512007)(478600001)(2616005)(26005)(83380400001)(6666004)(6506007)(53546011)(17423001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UUhtVGdmOUVsNWp2azBiOVk0eVFaNFhkZzZDUkkwTGIrcmNRUUE4bW54VHdr?=
 =?utf-8?B?OWV3NklReDRwd3owaWcrMzFQQjhFZDFhY2oxSHlKek1ESGFxYmJha2RGQTEz?=
 =?utf-8?B?M2o2SFVIWER2WE83T1NVN2dTeXFGcmJrN1ZhYkRjQ3pQVEJnY001VGZBMXFM?=
 =?utf-8?B?L0JFbDB6MmdzdzVxU3VuTWliTjlDYnlmWkxiU1kxb2p6NGNWTjQwdXdDUzBN?=
 =?utf-8?B?blRLSVlBcEtvRjZHUnJqV2FrK0ZZcmEzMXRlanpYQklIc3JsZEFZbzJuSVp3?=
 =?utf-8?B?Zm5VVmg4cTNVS0MvOWMyYjFLN2dpRWd6ajJRekpFbC92R0JFUFU2bnJqRFlI?=
 =?utf-8?B?dmtFdWZXMDRyTXV6eW83R1hENUJ6SHVDY3RtVWlKeFJzTTN2bnV2b0NJRWtj?=
 =?utf-8?B?bHptUThnWGFXbmdMV2pTSUg2blpNOFZlY0Z1VU5OeFMzV3pUNFNBbXZidVM0?=
 =?utf-8?B?WCtxR0VKaFhGck5yeTZBUzJpTEg0YkJQNG5PbWtkV3NwMGdMYitXdFAxeGRp?=
 =?utf-8?B?Z1UxWWZPZ3JUeU1hQ1BScC84amw2NWNXTkFzdjlWTVpucFg1UnZ6V0wvbXI0?=
 =?utf-8?B?eU5UbFVZYW1sa2pGL2NWMkYrQnBCVC9CSUIxaVdCNXNReWhOSjBocEUycnJm?=
 =?utf-8?B?V0l6Q2lUNFdUZVpvbEhuR2ppMjFFUmpoMXZDbE4rVCtNY25uc3l4RWxKcmVR?=
 =?utf-8?B?a2J6OFhWWTkwSlhFLytYSW4xdGw3YU9lMU0zOExqdGxoUjhqUVpkUWdvME02?=
 =?utf-8?B?dU1BdE9NV0gydlB1d1VhSmdSTXJIT01GeFpoK0RHSmE1cXFmanJJR0dnL21h?=
 =?utf-8?B?TlNVa2hBcU9VQkFjY0RWMlhYaU9ZVkF4a0FqS2dZQ3hRMXhOY0dpeXlESU5m?=
 =?utf-8?B?WWdzNGRsSmt0UnYvSThFajFZbkxlYktrYmlWVmhvbVJRczY5cHFwcGJzRTdN?=
 =?utf-8?B?QnJPN0I5QklOUzdQcEpkYS9KK241MUtiWlRzWmZYSHNaWTM5blAzU0Q4RHNI?=
 =?utf-8?B?TVVsb0RVWEhISUU1VjlEWXpzQ1JCMGNSVEtCZnNIVmpBNFZBeGxXalZPMmtP?=
 =?utf-8?B?UVk5WFZpNGZyQ0NMOXEyRnUyczZvZENnRmxydkl5WkNTMlFMMFlMREZ1RG5H?=
 =?utf-8?B?bnFKSmxxbmJTTGRxYVFVeno2TWo0NUJVa01LTGlkWXN5RkdjZjVmRnJyeENi?=
 =?utf-8?B?WEdZMVJ0K3czeVN6d1JkdGs3d1Jnem5pWTdIb002UkdYNDVxWlVLT2hkUGxY?=
 =?utf-8?B?QktoUFBIMzAyR3BpRjZJYzBnMDBpbkFlbmtCYmpZSGkzL05WbjFIU04yd3lB?=
 =?utf-8?B?SnE1Zk10QkZxVGkzelRJQzlFR3lURXBjdXB4MzJ6VFhIcEdmbitCdWlCSDJI?=
 =?utf-8?B?a1Vib1hraS9QRnJ0N0h0ZCtXSXRScGNjbkhYNHhHbkphOVU0TUdoVHFjdUti?=
 =?utf-8?B?VjhZZXJiQlU3RFBsNWViNmhrUFFFMjhzM2FlTXNsOVNBeHNUVnJ1L05ZUllY?=
 =?utf-8?B?UGpCckl3NGt2dkdnQkw3Rlc1eXVZZ0QwQXB5bm9zRGV2djBnRFBDV3Q3RG5z?=
 =?utf-8?B?NnB3OTVMd3lrZERKY201L1BHTC9tQkdCNStOUjBWOElHWmFwa25LUzU0TDd4?=
 =?utf-8?B?cERBRVpBK0JQYUxKaVljd3lPdWtiNTZxVTdld3VsRHVHb2ZieTRIUzRwVWdj?=
 =?utf-8?B?OHFKS2ZWNmQrSFc0OW56S241cllONU1ZQjMxNFlCbnpSMWJQZXZFTWpwWXFY?=
 =?utf-8?B?a1JXaUlSS0xNK21yRnBRYS95c2ZmVlpReDFXVENZbGQvRGRkMVZaYUhWN1Ix?=
 =?utf-8?B?RlJ4cGwyUXlZeU9rUjBCRVhhV0tYV0x3aWtka0tXWnNzdDUrS2gxRFYydjZx?=
 =?utf-8?B?Zkg4R0h4WVJZU21wakl5QXp2akNpZnNLZnF6NkhFWE0rMjgwa2p4S045MUFs?=
 =?utf-8?B?U0UvM0dQTGhITXB6R3pmL3UxM2RMSGRYNk9PTDR1eGtLQ1F0RGYwQ2hnd2hS?=
 =?utf-8?B?aXRNb29YRjc0NUNmVGFiOEdTR0FQMmZPUXI0N0dzNUVWUHFLb0ljRmV4bkNV?=
 =?utf-8?B?d2dtSW04WmtGTnQ4QVo1cGk5ZkQ5eXplSUNhT054YnZuQytRY0JtNGNHSE5h?=
 =?utf-8?B?eVMrR2NiYy92MEJIYXFyU3ZocHZjZmxHUUxuRFU4eWZRanJZSTRvc1laTmFV?=
 =?utf-8?B?aUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 941a3509-143a-4e64-05af-08da91d3de6c
X-MS-Exchange-CrossTenant-AuthSource: CY4PR11MB1862.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2022 19:53:58.4594
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +5QM0qZ/iMKxC0VBVtBh1RhLNAjsjzdn9nE63RpzTt/BRNMMND15Bxv5F+S6QtYAbzlTyRXFnQFJ5UIusOdSd5AnxDgwZUvg9Ic0CQpQUqA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB2716
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-10.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 9/5/2022 5:02 PM, Jarkko Sakkinen wrote:
> Unsanitized pages trigger WARN_ON() unconditionally, which can panic the
> whole computer, if /proc/sys/kernel/panic_on_warn is set.
> 
> In sgx_init(), if misc_register() fails or misc_register() succeeds but
> neither sgx_drv_init() nor sgx_vepc_init() succeeds, then ksgxd will be
> prematurely stopped. This may leave unsanitized pages, which will result a
> false warning.
> 
> Refine __sgx_sanitize_pages() to return:
> 
> 1. Zero when the sanitization process is complete or ksgxd has been
>    requested to stop.
> 2. The number of unsanitized pages otherwise.
> 
> Link: https://lore.kernel.org/linux-sgx/20220825051827.246698-1-jarkko@kernel.org/T/#u
> Fixes: 51ab30eb2ad4 ("x86/sgx: Replace section->init_laundry_list with sgx_dirty_page_list")
> Cc: stable@vger.kernel.org # v5.13+
> Reported-by: Paul Menzel <pmenzel@molgen.mpg.de>
> Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>

Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>

Reinette
