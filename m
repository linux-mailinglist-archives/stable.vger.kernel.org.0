Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F2055E8F0E
	for <lists+stable@lfdr.de>; Sat, 24 Sep 2022 19:52:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233632AbiIXRw3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 24 Sep 2022 13:52:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbiIXRw2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 24 Sep 2022 13:52:28 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 810E37285D
        for <stable@vger.kernel.org>; Sat, 24 Sep 2022 10:52:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664041946; x=1695577946;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=wlS4ayZnyHgEiwHOJrfI2yFWy8aB8EJXZxAFnr/YWQc=;
  b=RieVAPCXOr6560ghPIkKv88eHJV24Vgw+BucuBuIm+8Wg8kfoB0Kq/RK
   1Ykh+CmZ3vYDlUSbTE3LSAEq7OO6JLzOkvPe0Kjki4V8v192dPkz59MMC
   bKD5Xnw2B9dCxFfvZNRRQbTluKq44h+/YVHWwLe9Hu5gNW2L68twm3C0Q
   ZPkiUCWX8xokBaHxda/WekbfJuYYev66/L9r9oQDnwnpVWxNfzMX1isFD
   cAaodooDMI1blUvuI/Sy+d+DAFgIoIvrg3yKLkv8TVJVnQsu1ts2/BBtN
   OSHAVqv0kiwzwljjEUAmLg1pmKA9AhmSr55Dmm1fENJ18+SOjv3E2mF68
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10480"; a="281162062"
X-IronPort-AV: E=Sophos;i="5.93,342,1654585200"; 
   d="scan'208";a="281162062"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2022 10:52:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,342,1654585200"; 
   d="scan'208";a="724524757"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga002.fm.intel.com with ESMTP; 24 Sep 2022 10:52:26 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sat, 24 Sep 2022 10:52:25 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sat, 24 Sep 2022 10:52:25 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Sat, 24 Sep 2022 10:52:25 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.172)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Sat, 24 Sep 2022 10:52:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ElZuJ4eZ5YxOjYeOmXTEw23hwP66QHFKXhD5THfS4czizrEFuh3sfV8nUQb6g7z4Ma9T/BbZXYTP6Lrq6wO4Z+I5TgPi67fEWar0g2W1TznmnbGIX+gbdygvMg0SfCMs0a9FoXCvMizw5M7+QHOZZlYTL61X1sLMJour1s8eEdRxv4vcLMtH4aoyvY1+ZU1VkVkQhHgNQxUY7QVPnGbXrXJOAHDmDvOidCmFqGnsmxR8ZJB5rVgllFwi7Ev3Cf7ZTCYYep3ifCwU6tjyRt1dsCevpD6zK4jy1i1ZLb8UUHUh+U/IEy/2zCX9dY3eeKikTwW4dzBiowOuqSi70xNr4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mX/vk+ryCjBNn1ZzgewN0HYO6n2MLETEAqVJLrMpkXg=;
 b=jsTR0mdou/GlVZ3NSDYYVoLZb3oFPGwplsvhAa8Nlwxs1tZywk/xPki6n4nnMIV7kiraw1zhxAT3614FPOaikDD4RFJ+l1WjFSCHTSKd4DqEKlmXa2ivwChDT6UG/J2BadUK6uDxUXOkj2C5u56zsb5ZLjJIMV50iDZge3S8DFsIZkzeavNWMNhzGq6j1mU2MTU3L7DImE66TSMWJ3lOeU6bn5j2w0giAsH4MBfxSHOQ7J/afmHISjlXi3H8vgRMUbDx742c7mnwV0Z0aaOcBvW/lc40obwRvsUq8eGPTdtsrMC9TAWY2U6iEE6PJKr4HWAXalqm6iMuQLVDlP8aDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MW5PR11MB5810.namprd11.prod.outlook.com (2603:10b6:303:192::22)
 by SJ0PR11MB5216.namprd11.prod.outlook.com (2603:10b6:a03:2db::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.23; Sat, 24 Sep
 2022 17:52:22 +0000
Received: from MW5PR11MB5810.namprd11.prod.outlook.com
 ([fe80::6262:c42:ea50:926e]) by MW5PR11MB5810.namprd11.prod.outlook.com
 ([fe80::6262:c42:ea50:926e%5]) with mapi id 15.20.5654.018; Sat, 24 Sep 2022
 17:52:22 +0000
Message-ID: <3a4c3403-b767-102f-d628-0ac94ae9184c@intel.com>
Date:   Sat, 24 Sep 2022 19:52:15 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.3.0
Subject: Re: [Intel-gfx] [PATCH] drm/i915: Allow D3 when we are not actively
 managing a known PCI device.
To:     "Vivi, Rodrigo" <rodrigo.vivi@intel.com>,
        "tvrtko.ursulin@linux.intel.com" <tvrtko.ursulin@linux.intel.com>,
        "Gupta, Anshuman" <anshuman.gupta@intel.com>
CC:     "Nikula, Jani" <jani.nikula@intel.com>,
        "daniel@quora.org" <daniel@quora.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <20220921173914.1606359-1-rodrigo.vivi@intel.com>
 <2f318650-b01a-a526-8b74-bff99d5b2010@linux.intel.com>
 <YywuKoAg35X1Pclh@intel.com> <d2a3a63e-597a-6423-3660-f16717dc85e2@intel.com>
 <CY5PR11MB6211DA61B9089B4D700DE745954E9@CY5PR11MB6211.namprd11.prod.outlook.com>
 <61c4c60f435ff8eb2f94123e84831eeb24492f49.camel@intel.com>
Content-Language: en-US
From:   "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Organization: Intel Technology Poland Sp. z o. o., KRS 101882, ul. Slowackiego
 173, 80-298 Gdansk
In-Reply-To: <61c4c60f435ff8eb2f94123e84831eeb24492f49.camel@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BEXP281CA0011.DEUP281.PROD.OUTLOOK.COM (2603:10a6:b10::21)
 To MW5PR11MB5810.namprd11.prod.outlook.com (2603:10b6:303:192::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW5PR11MB5810:EE_|SJ0PR11MB5216:EE_
X-MS-Office365-Filtering-Correlation-Id: 39f2ab02-942f-460c-dc8c-08da9e5587dd
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2aVeA2TVtPcVhAnBFSf90kOK6eKMwtLaENtvmYVZKcM+B41Yu+lzOLLHGrAdYiZEXRhqCZy+sfHuq8ANBrCm8qKa2h3XHv1fiacztRYoRdVGZHG+uK5Xq/7s3Ik5NZLeMwZSLtbiYBYBdNxekE4lPM+bh4uAxvMHJ9f+F0An2f4zt0fcjm/bbIYycSgrpxYtVf9YDGPiBh8B8Pab6zHujoeaeWkCxLDY8Nog6QUqTX7TD23w9zQcA0R1nf06d1If0+EZDs5EuAwWRvCzFNFumJG7OSUgahMW1HCOr8goeJ26dyxBcscsL5ytHjcWNaoOPh3BMO72B4sQOkVmP1wg66T898UOjQY/MbHaeVEO+Gxi9zKUj4EekZ4PUzqAMLMXmNMSQqbaE5UWPNI6xsBWogZN2xyfWyROVw+j4/IRpABuqY+08ZITBCWOw2cHlIUxFNokuYq3kQFCCdReCGeno1/QZPo+JyuRQHfDo3pIVU1oH7RJhPQAwflBQbkAAjEn6jYpHIoBKm55agUVIc8l109w6pHbCg8WHlEw7dsPe1yf1GEvgXUVdbN/yKx4wWcnqjZf5y+uLN7yBIEEV+7lMdQIjfnTMLKH98vQWZspc6bMNHLhJeJJ+tOUQt9JpuE7kw3WJ5Izw6UHkB4tR9wlh87eWLP8LrHhe78Yaw2In80dL/sUIfcEZpRSHcNmXD3YBxmXeEASgMWi5TtJvCKYoCq36JS/NCuTCGRFOF7RNzm6F+yeYLZPYy52G4IX3RMG1b8wvOvk2ydEtgrmXElZoP7Bne7VTVk8xe1IP8L1W0o=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW5PR11MB5810.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(366004)(376002)(346002)(396003)(136003)(451199015)(38100700002)(82960400001)(6486002)(478600001)(83380400001)(53546011)(2906002)(36756003)(5660300002)(36916002)(110136005)(86362001)(186003)(31696002)(6506007)(66556008)(316002)(66946007)(6666004)(31686004)(66476007)(8936002)(41300700001)(26005)(8676002)(6512007)(4326008)(54906003)(2616005)(6636002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RXZiaW5MeERPYmxwZ2RLcWUvK2FxM3c4WnFRQ3VIdDhiZnZCR3duU3ZQcC80?=
 =?utf-8?B?ZjhVbFYzY3hHS2pVNWE3djFsaEkxQzJjQ1NiSzVuTjc3M2NyM3pHeExOdWhj?=
 =?utf-8?B?ZFNnRndzemNuLzRNSVdyZ3QwK1FPYWx4N0JkelB4eUFPR1FzZGxLZ1VkQjda?=
 =?utf-8?B?MVgvZmdOUUw0eHZpUlNCUExTWi83VEhiTzBRNTRTb05hellhbFJqZXhCWkZq?=
 =?utf-8?B?UkpqekZGYlJDaWgzaUdwK1dIMjZWMUZ6U3NJRVBOOFNHYTBsS3dkSjNOajJS?=
 =?utf-8?B?Ti8wSUs0Y0d3OVJGMk5QU3dCTERJbm1TSk9FNUoreFB0Nkx3OUViN2ZxNUx0?=
 =?utf-8?B?aFRHRmFqeXJBTVlCNHlkRmtXU0o1SFIwQ2wzenhpTXUwQ0VOYXBqMmp2YW1J?=
 =?utf-8?B?UmJWbzFEc0VCd0Zhb3ZFWkNjeERFVitMWTNIR0oxNzRNblBuNWdqQUwvMG8x?=
 =?utf-8?B?S05xdGs2Z0ZaTUFHVG1LM09UbU1CTkFBVzBmNXpiNTU0ODRVUDJ1UTVuUmw4?=
 =?utf-8?B?VTZCdmNBVEJMVHJBZnFxaDhzZHRQbDd6bGV2eFpTQWk5Rll0SWU3eWlVL09U?=
 =?utf-8?B?RGNiZmZhSWpiQlpRSndDMFRlaTh5WG5XNVA5SEdRTS9ObmNkK04xNlRaaEVF?=
 =?utf-8?B?NGxPanBqVFcxSVQ3TmhwRTh6U1RKSFFPL2JWbkxQNU9Zazh5b3JiMmhDRTRW?=
 =?utf-8?B?TmN3Mjg2cmNUdHMrNjM2cWJud21vQzR4MzRSTGxvdktmV3lLd2Q5OTVLeWc5?=
 =?utf-8?B?eGl1bndsNk5yKzhSdGh2aENpQzMyMitFeGFZeFJEeUNqTmN6aThFeFhieitt?=
 =?utf-8?B?TWJFM2xNL3A2UFI2aWFMUUtna1JjYngxMk1XUW1Xd3JwWmpnbmJkMTEvRmk2?=
 =?utf-8?B?SndFY1p4WmdCdkx0Vkg5UXk2V2djZHR5ZmxqcEh6NzhHMzBHS1AzWkpteklX?=
 =?utf-8?B?SVBtWEJzdUhXTGxVeDFqNVFnSUVhZjBZbC9idS9aWTdZay9mcFRvbDNqVzli?=
 =?utf-8?B?VDZHd2VaQW1VbHFJUDJ1NGgybWZIczgzY1ZtVHNmVVJiM2N4aW5yMGxLeGlM?=
 =?utf-8?B?QjYyQnQ4b3pLQ3VQcmpCSFFjdUhxMmt4ZFlPd3J4VkwvWTZITGxIa1JOWDhV?=
 =?utf-8?B?MkNCaU9Mc2RHcHJhZDh5NEc1QUg2a25lL0FKWEh2djVkdi9ObjltMXdWSHUv?=
 =?utf-8?B?Q3FtRVFzbW5SMlpzU2swVFNmeEdMRzF0ZHdWRFpFRjFQUi9NMC92US8yVWl2?=
 =?utf-8?B?aVZZK0NtRFhSNHVxN2hYTUxaUlNMRzczaTdCM09uODlHSmlrdWNKZ0N0amYx?=
 =?utf-8?B?a2FTN1JjUlhjMjZYUjBCWDhoSmdUVThrUFhyZHNKRXZiWk94ekVKd1N0RXVa?=
 =?utf-8?B?RmZQQWR5ZzZ6cVVrVEl2TjFIaGloWXk3UHd5WGhMYUdvNEVUTzBBbTdDQzdP?=
 =?utf-8?B?d0lQNnJucmwwdFY3TVd1d0czZEZ5eS9UZ0hZbHowczVRVzlLYXNmNnQ1MGtE?=
 =?utf-8?B?RzJncTgyMUI4dHJ2dUFXYmQwYWVyaEdGZHpmbVdCVkRJUFBoY292Z0hXVm5o?=
 =?utf-8?B?QTRtUHNiZjVlc2p6aHNDQUpERmpobnJrTHFISEhpNXFWc1VQbFhuNlBEeHY5?=
 =?utf-8?B?ZUhaajB1T2owQ0tSaVRwempqQ2tOcHJoblB6aEhzWTRtRmdzSmhxYTJ3MnEx?=
 =?utf-8?B?RGowV2c4YW5sWGFIa0ZCZGo1SXpseHN0dXNiVmpQUitBMGlscGdnaElxT0hk?=
 =?utf-8?B?eFlsZEFSb1FvSFVlZUQvVlFndUZTam45akM1ZmZwelg5QTg5SE5vSUhpTGpN?=
 =?utf-8?B?bUdFeXJjSEt2cFdlbnd6RXdYV1I2YmNFY3N6a1dNYWhEVC9jWlNrUThHM3g5?=
 =?utf-8?B?NWQ2R09wRXdEaEplZXB3K3h1cnp5eDkraWxJWEZ2cTY1M3JLVlozajBGUkph?=
 =?utf-8?B?aG9ucXVsUll5ZHZQNlh5bHpMQjEwZDJabmcwRSt0ME4va3NGbExJNUFvSDRS?=
 =?utf-8?B?VUNNZUQ2Z3RoSXRKb2E1UlVZajV0Z0NDaFRTeVY5eittaFQzWVFXdm9TVC9K?=
 =?utf-8?B?VXFTS3pnTXRQRjE5WXVvWGMxNGg3OVZLcjI1a3VEa1NzZlFncXdaTlRRZjF3?=
 =?utf-8?B?ck9PRjNwL0p2WHBCR0pOQkRwemZ1aHF1eDNTK1VvemZYMVBDenYwU211WVJ2?=
 =?utf-8?B?UlE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 39f2ab02-942f-460c-dc8c-08da9e5587dd
X-MS-Exchange-CrossTenant-AuthSource: MW5PR11MB5810.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2022 17:52:21.7875
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wZ+0oDNvLqAPWtQ56cPfyW1CwwHyb/UP6uSnoZINJ2yxsqmZwSGujthaXK62jkL8o/z+E/CGNLk+dH2UV4f+1txFfGGQWuqMrwA5qo17L14=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5216
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-6.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/23/2022 8:20 PM, Vivi, Rodrigo wrote:
> Rafael, could you please add your thoughts here?

Sure, sorry for the delay.

I gather the idea is to bind the driver to the device without actually 
doing anything more to it and to put it into D3, so it doesn't draw too 
much power.

Using PM-runtime for that should work, but the driver needs to make sure 
that its PM-runtime callbacks will work then (they may simply return 0 
all the time in that case, but they need to take it into account).


> On Thu, 2022-09-22 at 12:40 +0000, Gupta, Anshuman wrote:
>>
>>> -----Original Message-----
>>> From: Gupta, Anshuman
>>> Sent: Thursday, September 22, 2022 4:40 PM
>>> To: Vivi, Rodrigo <rodrigo.vivi@intel.com>; Tvrtko Ursulin
>>> <tvrtko.ursulin@linux.intel.com>
>>> Cc: Nikula, Jani <jani.nikula@intel.com>; intel-
>>> gfx@lists.freedesktop.org; Daniel
>>> J Blueman <daniel@quora.org>; Wysocki, Rafael J
>>> <rafael.j.wysocki@intel.com>; stable@vger.kernel.org
>>> Subject: Re: [Intel-gfx] [PATCH] drm/i915: Allow D3 when we are not
>>> actively
>>> managing a known PCI device.
>>>
>>>
>>>
>>> On 9/22/2022 3:13 PM, Rodrigo Vivi wrote:
>>>> On Thu, Sep 22, 2022 at 08:56:00AM +0100, Tvrtko Ursulin wrote:
>>>>> On 21/09/2022 18:39, Rodrigo Vivi wrote:
>>>>>> The force_probe protection actively avoids the probe of i915
>>>>>> to
>>>>>> manage a device that is currently under development. It is a
>>>>>> nice
>>>>>> protection for future users when getting a new platform but
>>>>>> using
>>>>>> some older kernel.
>>>>>>
>>>>>> However, when we avoid the probe we don't take back the
>>>>>> registration
>>>>>> of the device. We cannot give up the registration anyway
>>>>>> since we
>>>>>> can have multiple devices present. For instance an integrated
>>>>>> and a
>>>>>> discrete one.
>>>>>>
>>>>>> When this scenario occurs, the user will not be able to
>>>>>> change any
>>>>>> of the runtime pm configuration of the unmanaged device. So,
>>>>>> it will
>>>>>> be blocked in D0 state wasting power. This is specially bad
>>>>>> in the
>>>>>> case where we have a discrete platform attached, but the user
>>>>>> is
>>>>>> able to fully use the integrated one for everything else.
>>>>>>
>>>>>> So, let's put the protected and unmanaged device in D3. So we
>>>>>> can
>>>>>> save some power.
>>>>>>
>>>>>> Reported-by: Daniel J Blueman <daniel@quora.org>
>>>>>> Cc: stable@vger.kernel.org
>>>>>> Cc: Daniel J Blueman <daniel@quora.org>
>>>>>> Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
>>>>>> Cc: Anshuman Gupta <anshuman.gupta@intel.com>
>>>>>> Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
>>>>>> ---
>>>>>>     drivers/gpu/drm/i915/i915_pci.c | 8 ++++++++
>>>>>>     1 file changed, 8 insertions(+)
>>>>>>
>>>>>> diff --git a/drivers/gpu/drm/i915/i915_pci.c
>>>>>> b/drivers/gpu/drm/i915/i915_pci.c index
>>>>>> 77e7df21f539..fc3e7c69af2a
>>>>>> 100644
>>>>>> --- a/drivers/gpu/drm/i915/i915_pci.c
>>>>>> +++ b/drivers/gpu/drm/i915/i915_pci.c
>>>>>> @@ -25,6 +25,7 @@
>>>>>>     #include <drm/drm_color_mgmt.h>
>>>>>>     #include <drm/drm_drv.h>
>>>>>>     #include <drm/i915_pciids.h>
>>>>>> +#include <linux/pm_runtime.h>
>>>>>>     #include "gt/intel_gt_regs.h"
>>>>>>     #include "gt/intel_sa_media.h"
>>>>>> @@ -1304,6 +1305,7 @@ static int i915_pci_probe(struct
>>>>>> pci_dev *pdev,
>>> const struct pci_device_id *ent)
>>>>>>     {
>>>>>>          struct intel_device_info *intel_info =
>>>>>>                  (struct intel_device_info *) ent-
>>>>>>> driver_data;
>>>>>> +       struct device *kdev = &pdev->dev;
>>>>>>          int err;
>>>>>>          if (intel_info->require_force_probe && @@ -1314,6
>>>>>> +1316,12 @@
>>>>>> static int i915_pci_probe(struct pci_dev *pdev, const struct
>>>>>> pci_device_id
>>> *ent)
>>>>>>                           "module parameter or
>>> CONFIG_DRM_I915_FORCE_PROBE=%04x configuration option,\n"
>>>>>>                           "or (recommended) check for kernel
>>>>>> updates.\n",
>>>>>>                           pdev->device, pdev->device, pdev-
>>>>>>> device);
>>>>>> +
>>>>>> +               /* Let's not waste power if we are not
>>>>>> managing the device */
>>>>>> +               pm_runtime_use_autosuspend(kdev);
>>>>>> +               pm_runtime_allow(kdev);
>>>>>> +               pm_runtime_put_autosuspend(kdev);
>>> AFAIK we don't need to enable autosuspend here,
>>> pm_runtime_put_autosuspend() will cause a NULL pointer de-reference
>>> as it will
>>> immediately call the intel_runtime_suspend()(because we haven't
>>> called the
>>> pm_runtime_mark_last_busy) without initializing i915.
> I don't see any null pointer dereference here.
> The problem is exactly that we do the initialization and the we give up
> on the
> device and end up blocking the runtime pm in some state that we cannot
> change.
>
>>> Having said that we only need below, in order to let pci core keep
>>> the pci dev in
>>> D3.
>>>
>>> pm_runtime_put_noidle()
> as for this one here I get:
> [ 9036.357078] i915 0000:03:00.0: Runtime PM usage count underflow!
>
>> Hi Rodrigo ,
>> It seems playing with these runtime hooks, will only enable the
>> "runtime suspend"
>> but actual state in "PMCSR" pci config is D0 despite device is
>> runtime suspended, when there is no driver.
>> Example:
>> root@DUT2135-DG2MRB:/home/gta# cat
>> /sys/bus/pci/devices/0000\:03\:00.0/power/runtime_status
>> suspended
>> root@DUT2135-DG2MRB:/home/gta# setpci -s 03:00.0 0xd4.l
>> 00000008
>> (Bits 00:01 are the power state in PMCSR(offset = 4) config register
>> from PM Cap offset at 0xd0).
> Well, this is indeed awkward.
>
> Rafael, do you know what we could be missing here to ensure we get the
> proper d3?
>
> I noticed that with the linux param vfio-pci.ids=8086:<dg2_id> it does
> get us to the d3.
>
> # setpci -s 03:00.0 0xd4.l
> 0000010b
>
> While with the approach in this patch or the noidle() I also get
> the 00000008
>
> Thanks,
> Rodrigo.
>
>> Thanks,
>> Anshuman Gupta.
>>> Br,
>>> Anshuman Gupta
>>>
>>>
>>>>> This sequence is black magic to me so can't really comment on
>>>>> the specifics.
>>> But in general, what I think I've figured out is, that the PCI core
>>> calls our runtime
>>> resume callback before probe:
>>>>> local_pci_probe:
>>>>> ...
>>>>>           /*
>>>>>            * Unbound PCI devices are always put in D0,
>>>>> regardless of
>>>>>            * runtime PM status.  During probe, the device is set
>>>>> to
>>>>>            * active and the usage count is incremented.  If the
>>>>> driver
>>>>>            * supports runtime PM, it should call
>>>>> pm_runtime_put_noidle(),
>>>>>            * or any other runtime PM helper function
>>>>> decrementing the usage
>>>>>            * count, in its probe routine and
>>>>> pm_runtime_get_noresume() in
>>>>>            * its remove routine.
>>>>>            */
>>>>>           pm_runtime_get_sync(dev);
>>>>>           pci_dev->driver = pci_drv;
>>>>>           rc = pci_drv->probe(pci_dev, ddi->id);
>>>>>           if (!rc)
>>>>>                   return rc;
>>>>>           if (rc < 0) {
>>>>>                   pci_dev->driver = NULL;
>>>>>                   pm_runtime_put_sync(dev);
>>>>>                   return rc;
>>>>>           }
>>>>>
>>>> Yes, in Linux the default is D0 for any unmanaged device. But
>>>> then the
>>>> user can go there in the sysfs and change the power/control to
>>>> 'auto'
>>>> and get the device to D3.
>>>>
>>>>> And if probe fails it calls pm_runtime_put_sync which
>>>>> presumably does not
>>> provide the symmetry we need?
>>>> The main problem I see is that when the probe fail in our case we
>>>> don't unregister and i915 is still listed as controlling that
>>>> device
>>>> as we could see with lspci --nnv.
>>>>
>>>> And any attempt to change the control to 'auto' fails. So we are
>>>> forever stuck in D0.
>>>>
>>>> So, I really believe it is better to bring the device to D3 then
>>>> leaving it there blocked in D0 forever.
>>>>
>>>> Or forcing users to use another parameter to entirely avoid i915
>>>> to
>>>> get this device at first place.
>>>>
>>>>> Anyway since I can't provide meaningful review I'll copy Imre
>>>>> since I think he
>>> worked in the area in the past. Just so more eyes is better.
>>>>> Regards,
>>>>>
>>>>> Tvrtko
>>>>>
>>>>>
>>>>>> +
>>>>>>                  return -ENODEV;
>>>>>>          }


