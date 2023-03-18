Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 450656BF7AB
	for <lists+stable@lfdr.de>; Sat, 18 Mar 2023 05:08:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229488AbjCREIF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Mar 2023 00:08:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjCREID (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 Mar 2023 00:08:03 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70483206B5
        for <stable@vger.kernel.org>; Fri, 17 Mar 2023 21:08:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679112481; x=1710648481;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=YVH/YJZrvcXOT2l5KnVge0mCdJ8hKui5pBLiuO+9//w=;
  b=k7SMw5Q1w0gnhARSYa6eK962xX4LB1D63pi/rLISLG2OxVW/iKevLaWP
   BMAHYuZyrmVCihZIeR1NJIS5pFRaCDSfrd8PaZs1QXGrJ7jD8+GUDMWuR
   qEDpiKVyR2x+VrAGLW787+ZMoyjQ5KDDdU12+yZgPnlfwVP+7uroRH5FK
   VSSenvQGKGMtX9m6pa4BKDa7epAldi+qiEHUUKDbkHjK8Ibp2BH6K9Ltv
   aH5gqnDGqbxrj/XI5stZ/fYApi0pznXuiAvwTw1uGvEfKoOFlVTZEiG9U
   zINuCgBrz3H27O0RnytrlL5SuRaprJVeh/ooruGg6FSigmvLDJyBXQpDM
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10652"; a="340762077"
X-IronPort-AV: E=Sophos;i="5.98,270,1673942400"; 
   d="scan'208";a="340762077"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2023 21:08:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10652"; a="1009893598"
X-IronPort-AV: E=Sophos;i="5.98,270,1673942400"; 
   d="scan'208";a="1009893598"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga005.fm.intel.com with ESMTP; 17 Mar 2023 21:08:00 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 17 Mar 2023 21:07:59 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 17 Mar 2023 21:07:59 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Fri, 17 Mar 2023 21:07:59 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.102)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Fri, 17 Mar 2023 21:07:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AC+gK/8xPu/MI3L8L8dx2nsM0SiB1WxvMzGmAM4cdf7Z16WGu7IaGZO0NXI2ns+/GO3i1KJSCYfJHXg/93itmehTIket0esK9jgG3jVZSK4pXAJGbgLkocpt0pJE3HOCbHDEFQjcb26dnTwPWuzKMaXS88Rxf6FZPoRP4g0/TwhmnTZlZ5WIKd5S9glr8o3zAoaa9Y8U0rZGoz/elsfgJzUsumN9VaAVW0YpQT773THSYgDtt0iM/f3duZWI76wExVl6eOxl9a8Crj6n0k726aBhFvxBBL4PCwyeo2gr757n0A7hAhq+xn0yVLQGcCNOJFzLlhExVxNMCp7UanKpHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=++kXpLD6G0v95vcvVuSow2QJ+XWehr1m/RDUnjGv5VU=;
 b=IFgXP+W2Zw/7bhKYzUkhIekWsGkq/M9swuKXlk2I66wfIJUauWbqa1KnOZ+HhogzNRBlZ2pQz1jRKUjm8LoJMK0xlSHnH1zD7CQj0I1UVgehZupKtKqIBm5WSfe1hoKMAEl+Dn56JKLzACKO+15V+cT8VcV4ZUTT+LGYi36vMpfHLMb9rwDm61JM5lAnwEfRfEJ5BDLvYZKtpqF/CyqeBvYiPFpKrOEaU0ITIhAKGGBBp79R1Z5zUNTanJgsE67w8luOIKenmRoUT2JJR82TsA0R9h84I0danwIY+qQzVVNmMQVA2zjUI0A+28hMnUKkRWrbMdwdrw8vSYKPLdNBHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BY5PR11MB3911.namprd11.prod.outlook.com (2603:10b6:a03:18d::29)
 by IA1PR11MB7342.namprd11.prod.outlook.com (2603:10b6:208:425::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.36; Sat, 18 Mar
 2023 04:07:55 +0000
Received: from BY5PR11MB3911.namprd11.prod.outlook.com
 ([fe80::5399:6c34:d8f5:9fab]) by BY5PR11MB3911.namprd11.prod.outlook.com
 ([fe80::5399:6c34:d8f5:9fab%6]) with mapi id 15.20.6178.024; Sat, 18 Mar 2023
 04:07:55 +0000
Message-ID: <17301b8c-19e0-4364-3e4c-c1c3d8cc45aa@intel.com>
Date:   Fri, 17 Mar 2023 21:07:50 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.9.0
Subject: Re: [PATCH 5.4.y] drm/i915: Don't use BAR mappings for ring buffers
 with LLC
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     <stable@vger.kernel.org>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        <intel-gfx@lists.freedesktop.org>,
        =?UTF-8?Q?Jouni_H=c3=b6gander?= <jouni.hogander@intel.com>,
        "Daniele Ceraolo Spurio" <daniele.ceraolospurio@intel.com>,
        Jani Nikula <jani.nikula@intel.com>
References: <167820543971229@kroah.com>
 <20230314022211.1393031-1-John.C.Harrison@Intel.com>
 <ZBF48kVhFmXIsR+K@kroah.com> <a5cf5572-4160-3efb-4f80-aaf53aa06efe@intel.com>
 <ZBIHJD5FkxiammjB@kroah.com> <5ed286b7-c2df-9e63-d85a-be9994f93eec@intel.com>
 <ZBRkAZwItdidH32z@kroah.com>
Content-Language: en-GB
From:   John Harrison <john.c.harrison@intel.com>
In-Reply-To: <ZBRkAZwItdidH32z@kroah.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR03CA0163.namprd03.prod.outlook.com
 (2603:10b6:a03:338::18) To BY5PR11MB3911.namprd11.prod.outlook.com
 (2603:10b6:a03:18d::29)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR11MB3911:EE_|IA1PR11MB7342:EE_
X-MS-Office365-Filtering-Correlation-Id: e13e6bf3-be2b-48db-a669-08db27665938
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YRjrtSFYzt+KogCyv75oOhk6ScQWuwbKcppEe4qaWgXwJ66pdJJGeS49ktBctnX5nF0OEvQBSc55E/jN034lpmcrMl4c27nZBim2jElsOQlv9T6Iv06ESangfd6kHSgQmuih5s8RiTfg5lq15Vn7ufcaEXNOJvRpU153o3pDnuJEXXdGQkJVkKgb4/Q6zQ1or72ltb+DYRsA/ZHfdSBl0ajExD8F3S9WSJ5AlfSsQEZMu6bMz05b3USu0bCQQ5tDbB6hBsrnXJbQEuOKTla8/E6IwYXhaMMoiyegC7ibU81oUyHdUi2sIzTJxFObq61kaTNJoCD6pLRC9OLn78xZbEd4kABmwZGY4qVtro5c+/BUtLZ4D6CAMjPTdd/4zpQCLz7EpVJKyjQb+D0rq+UL+Kr8cKhshmI43GyAUiAtgvqsgLubwI/mFExFPL1j4y0eCrO/6TpkzNzh9cHdF8fCuNji6CZAdVxKCdmp+BnfN37rNRq8Xlpg8gcUkno0cNqY732Q+NFTS6RX58t3aGJrBncd1EpAiBpao5CvkmUmdTAb5B6CoBKuZKux6+iPCvv6bMArM8Zf/Gys+Dw6+7s1cWoAf7vs7hVw7tKtHCd2kKg4IaK/SMdC8wem8g26Ce2LpJ+baIomo23NL7qo04nN+SMAhBbmpg1p7UH1QEe+62DaKmI7kuks0GVWV1H8GMCn
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB3911.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(376002)(39860400002)(366004)(396003)(346002)(451199018)(31686004)(316002)(54906003)(8676002)(66946007)(66556008)(66476007)(478600001)(6916009)(4326008)(41300700001)(5660300002)(8936002)(36756003)(31696002)(86362001)(6512007)(6506007)(26005)(6486002)(966005)(186003)(53546011)(6666004)(82960400001)(66574015)(2616005)(2906002)(83380400001)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Z3liVHVNcHpLd1V4Z2ZxM1pQMW5jUFpDWFdxV3F5YWo2QWJKb1o1V0VMNzZU?=
 =?utf-8?B?eUZPY1Nud2lFaCtmL0ZmTFlkWWJVQXRRMEQyRU9iM2VwaDZpbTNaTm56RXkw?=
 =?utf-8?B?RkhOR3BtU2s0L3RrLzFqK3p2MW80Tklrazh3RGI4enpsK25xMEtyZ0sxcHZZ?=
 =?utf-8?B?UHlVaEIxbjV5cWdDVTFjZFZLbWkvRXpmc2g3ODhzUHNjYWtRWU1SdnQrWFBq?=
 =?utf-8?B?N0dPUmtVLzhiaWNONVl5UXkxdDQxa24zaUdCaWo1a2dEQ2JkenFYNWRPS2VI?=
 =?utf-8?B?dlpYNjkvV21DWU5uYStNaWl5aWpndUpBbHlBd05mZWVSODNNZnhIOWNpeGk3?=
 =?utf-8?B?NnlKMUhnaEpQQkFIZThpQ3VqQzhVQmhJQjVZM01SdjFYdkQrQVM1b0V1dkdr?=
 =?utf-8?B?Z09KL2NLd09ydnBQam1uOTNLMVZrVzdmam9lb3FtVUUva2Z6bVdDNDRLVVFi?=
 =?utf-8?B?ZStvcUVhZTBqeGh4R3JMY1NPNHl5a1RMOVI0c3k1QS9YeFk4NmU2dERPbW0y?=
 =?utf-8?B?SVhGK2hmY1FvUW5JWFhlQnlCZWVHZTV2bkt3NXlhd0xCdmFLZEtMMGJ4cEMy?=
 =?utf-8?B?MGM4dmhVckR0MjhtdDJPUUFVcDVHaGN5b0RXY2NPU1BKd3FHT3R0SzBOVm1L?=
 =?utf-8?B?Z1A4akhTWlArZkJtU3c2ZVNBWUNaWGU1Mm5vMlhPQk9TZC9aa1UzMkdVK3Z0?=
 =?utf-8?B?alVaejhySVk0Y2k0Nzgyb2NBVWh4STBHamFyMGs3WitTQzErbXVTNEhYYXd2?=
 =?utf-8?B?bHJucm1zbE5QakMvMDk5VGJyeTBXb1M0Rml4YWttSjVsRi80MkpwMTBFVCtK?=
 =?utf-8?B?VlhjVEVra2N4R3RJWmF5L1RGc2Y1QmROTTFLQ09nY3FMNllSVUlzT25xM1ds?=
 =?utf-8?B?TlV3MWtKSS91bWFCUVdLWnlqbUJqVWNDamI2Y3RDdjNiMW5HcFFUbnJQUXdn?=
 =?utf-8?B?bU5YOUd3NVcwVWFNaE1JeDVNdmh2cGJqLzNuelJLRjFEU2phQ1cyU3l3d0VO?=
 =?utf-8?B?dGh5emxGZDdMWUFXdHlqdC9rcHpiU2Rnc0JGU3pJYzhWVldobUt1LzZVNWdO?=
 =?utf-8?B?Mi9pUVB2R0VmUUhib3MyTGtlNGRVbGlvNXBHYW11SDNPSEdvTzJOMVhCR3Ja?=
 =?utf-8?B?Z3R4bng0M3hYT3A4b3dwellrbW5UNk9mbnNKWCtRYjQrbW5PNGZ0VzZHdnhX?=
 =?utf-8?B?dDRwWk1rcXNMTkRoaFF2QlpDdUR3ZlJSd09jeUZ5ZStCNlZSc25KbFhEdUpY?=
 =?utf-8?B?YWdJTFAxdXA2dFBxek1zd1R1REZQY1NxNjBXenZSeE9TdmFXWlRwTTVvajF2?=
 =?utf-8?B?OVBSanB1QXg4aEFGcFEwNmpYLzFDK2VvZ3FmSWhsanErOCtNQnFsZW0rTnFX?=
 =?utf-8?B?ekI5K1JMZmNjclAxbGRDNW52ZjdJODY1OFJvOTh1eHM4dzF6MkR3YURFaXZ3?=
 =?utf-8?B?QndnU3AzN1k3NkUyRUk2MlloNnE4OFlGSlJYNktpVFdkcXkxY0JHa3Vza2Ez?=
 =?utf-8?B?aXJBTGt6K01pTkRCY21yZDluR1RKR09UWVFnSURWZWVnRHB1TEd3ZmlVSXlY?=
 =?utf-8?B?MjUrSTdoWG55emI4bWNSbmtBWGErRG5IZGJJc0JPbVN1Ky95ZnRuSzRqbklw?=
 =?utf-8?B?ckkzdFlvaXFyMUZMVFN3clBlaEpFSnBDeVZ6OGQyRS9abXJVeVRBeVdseHFj?=
 =?utf-8?B?NHg2ZVpmbnBRRXJ0RnNDeUxsZlg1c0s0VFlxdzQ3dzY1ZUdYcUJaZEcxYnRh?=
 =?utf-8?B?NFFwdHFjQS9yQUZ1WU9DeFVIcElvem15QW93VE5PZytZWTl1QUJramtoWFJY?=
 =?utf-8?B?Wlp6TE9zRXJ5RHdaZ0gxVFhabzA4dWd4UjA2bFVTUFpHR3NaNzhQRFlyUHNV?=
 =?utf-8?B?YnZWQVd5L3NmeGpRcG5Sa0JTRWExb1pSZU54ZnIrbnUzcFJyWHAya3JvZGdm?=
 =?utf-8?B?eit3Y0tERERCVE02TjJzdE4wSmliSFlIMlBzd0FpOE5PVEZzMWhmN3NaazNw?=
 =?utf-8?B?ZGJ4U2l2dHorbVJSNmVNbU9HbmNZSlh0a3IvNTNabGFpVVlCSHhJVnJJSEJ0?=
 =?utf-8?B?K0tULzVpYVl6UlZLYVFnUWJnWmR5ZUxEd2Iyd004enN2YVVrK1kyQzlEOHNW?=
 =?utf-8?B?eHhUYTEvOGgwV0t4ZEJJci9COUtqL1BoeW01cE5EM012blhEYUUzTW9kRFBH?=
 =?utf-8?B?TXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e13e6bf3-be2b-48db-a669-08db27665938
X-MS-Exchange-CrossTenant-AuthSource: BY5PR11MB3911.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2023 04:07:54.2589
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /EZ5T+WCb11l3Dw83bwTWHKS/4gT6C2g0EOOPbE44eEBbAUZMW6wUG9pctxvuLdLXJqEe6SVQcrPZjKyOEkJOpLhTWWV1KJfLD1gPo2tCJA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7342
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/17/2023 05:58, Greg KH wrote:
> On Thu, Mar 16, 2023 at 01:58:35PM -0700, John Harrison wrote:
>> On 3/15/2023 10:57, Greg KH wrote:
>>> On Wed, Mar 15, 2023 at 10:07:53AM -0700, John Harrison wrote:
>>>> On 3/15/2023 00:51, Greg KH wrote:
>>>>> On Mon, Mar 13, 2023 at 07:22:11PM -0700, John.C.Harrison@Intel.com wrote:
>>>>>> From: John Harrison <John.C.Harrison@Intel.com>
>>>>>>
>>>>>> Direction from hardware is that ring buffers should never be mapped
>>>>>> via the BAR on systems with LLC. There are too many caching pitfalls
>>>>>> due to the way BAR accesses are routed. So it is safest to just not
>>>>>> use it.
>>>>>>
>>>>>> Signed-off-by: John Harrison <John.C.Harrison@Intel.com>
>>>>>> Fixes: 9d80841ea4c9 ("drm/i915: Allow ringbuffers to be bound anywhere")
>>>>>> Cc: Chris Wilson <chris@chris-wilson.co.uk>
>>>>>> Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
>>>>>> Cc: Jani Nikula <jani.nikula@linux.intel.com>
>>>>>> Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
>>>>>> Cc: Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
>>>>>> Cc: intel-gfx@lists.freedesktop.org
>>>>>> Cc: <stable@vger.kernel.org> # v4.9+
>>>>>> Tested-by: Jouni Högander <jouni.hogander@intel.com>
>>>>>> Reviewed-by: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
>>>>>> Link: https://patchwork.freedesktop.org/patch/msgid/20230216011101.1909009-3-John.C.Harrison@Intel.com
>>>>>> (cherry picked from commit 65c08339db1ada87afd6cfe7db8e60bb4851d919)
>>>>>> Signed-off-by: Jani Nikula <jani.nikula@intel.com>
>>>>>> (cherry picked from commit 85636167e3206c3fbd52254fc432991cc4e90194)
>>>>>> Signed-off-by: John Harrison <John.C.Harrison@Intel.com>
>>>>>> ---
>>>>>>     drivers/gpu/drm/i915/gt/intel_ringbuffer.c | 4 ++--
>>>>>>     1 file changed, 2 insertions(+), 2 deletions(-)
>>>>> Also queued up for 5.10.y, you forgot that one :)
>>>> I'm still working through the backlog of them.
>>>>
>>>> Note that these patches must all be applied as a pair. The 'don't use
>>>> stolen' can be applied in isolation but won't totally fix the problem.
>>>> However, applying 'don't use BAR mappings' without applying the stolen patch
>>>> first will results in problems such as the failure to boot that was recently
>>>> reported and resulted in a revert in one of the trees.
>>> I do not understand, you only submitted 1 patch here, what is the
>>> "pair"?
>> The original patch series was two patches -
>> https://patchwork.freedesktop.org/series/114080/. One to not use stolen
>> memory and the other to not use BAR mappings. If the anti-BAR patch is
>> applied without the anti-stolen patch then the i915 driver will attempt to
>> access stolen memory directly which will fail. So both patches must be
>> applied and in the correct order to fix the problem of cache aliasing when
>> using BAR accesses on LLC systems.
>>
>> As above, I am working my way through the bunch of 'FAILED patch' emails.
>> The what-to-do instructions in those emails explicitly say to send the patch
>> individually in reply to the 'FAILED' message rather than as part of any
>> original series.
> So what commits exactly in Linus's tree should be in these stable
> branches?  Sorry, I still do not understand if we are missing one or if
> we need to revert something.
>
> confused,
>
> greg k-h
As far as I can tell, I have replied to all the "FAILED: patch" emails 
now. There should be a versions of these two patches available for all 
trees (being 4.14, 4.19, 5.4, 5.10 and 5.15):
     690e0ec8e63d drm/i915: Don't use stolen memory for ring buffers 
with LLC
     85636167e320 drm/i915: Don't use BAR mappings for ring buffers with LLC

They should be applied in the order of 'stolen memory' first and 'BAR 
mappings' second.

Thanks,
John.

