Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61F196E9453
	for <lists+stable@lfdr.de>; Thu, 20 Apr 2023 14:31:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229529AbjDTMbD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Apr 2023 08:31:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229963AbjDTMbA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Apr 2023 08:31:00 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B9707282
        for <stable@vger.kernel.org>; Thu, 20 Apr 2023 05:30:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681993835; x=1713529835;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=qNqiYsvyAprjyro9EZiOSPtBO5zRsOXWXvr5kRO/UEo=;
  b=g7ll08DOk+2lPuak5tpe4/U25xK6vmoLUQR805oRZfatSwYD4gf4U8yC
   Y8nWImGwb++Zu308vmoFtyP579OhzQIxMd9g78skvETe5K+UUAkCedAtB
   KRjd4jLtUIAYCBs9LSUsvS1xdInUAfcpWhgL6lloqvWRTBDdS7w6o9M96
   f7Jzwjrt9Zwx6RhT7q+hwD1I/vlU88AIafGp8iWTMiewkZkZLHglNpkiw
   ycACxGBbUBxOxKiTfl4eA95FKrc5em/AYwbp3w7etxN1avgrgqjNpUxIX
   QBVqzEC4LioAHYOzfg4hMqF98qUmX2dh34heQbQmydSSgWnLWJ8XOWo2I
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10685"; a="431999203"
X-IronPort-AV: E=Sophos;i="5.99,212,1677571200"; 
   d="scan'208";a="431999203"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2023 05:30:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10685"; a="938049249"
X-IronPort-AV: E=Sophos;i="5.99,212,1677571200"; 
   d="scan'208";a="938049249"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga006.fm.intel.com with ESMTP; 20 Apr 2023 05:30:20 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 20 Apr 2023 05:30:20 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 20 Apr 2023 05:30:19 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 20 Apr 2023 05:30:19 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 20 Apr 2023 05:30:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V8dxcR1kIIY729tgRMD3R1mup53kVNBr294uOWrt/NkyAnA6lcg/wsjCvQgwI1TXEhDKajDyQTzfbQH/iPNvGAC6CEyT32ZMHEdVs5IRtCRGO8XYjvNEElQ/PGsuNp5vfH3t/dvS6q4c0SZ86JoURF4LFxK6yP+ewmvHxs4HiwNXNMHNiodmgl8L6hs4b6D64aojF27dFULwthX58fCOXjXNpfeB+aGjRJ0aKPv+eLU4t0IFHwh1hKFUx5scyTCe1F59yu7miaNn++L+g+JgKdpqlyHtl42ZszC/1QJkiKIGDpypQ7F3JoxHJf2wm1jGltX+ct5hVR6Yyidq9shy6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aHjN2Lsan8TieYR76F6XAl/5oVlyd2hMZIx2Z+SFPyQ=;
 b=M7jYvidQoQLtgqcsHVBtJGUy3hNfDh9VYzmICxjDDrudu73HP2ZPymdVg/BslZ2BD8R2c6ZoQ0neirzgGQB2ISciqUmzGXFREEzlDgkAD3djgb4P813zRz7Pwas3cDhsDVtLqoyS1m73nXhTkXKJOyfnh0ASgMju/yyfSY5debvjGjIoeynn6QkNpmaragYSSaKL0KsqU5Gk1+Ewd6jVvQOqt/OHJtjai/7wmhFhojzA1qbu6WzBRvPFaQWVGYzeZItqrTT3/e/A4c1Xg1P7UGlIguUT6VaSKSEUW+O/jb0dpp2q1kW/hAWKllx23BMlgm2bjS4Fkbyos4I3KUGR/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB5341.namprd11.prod.outlook.com (2603:10b6:5:390::22)
 by PH7PR11MB6554.namprd11.prod.outlook.com (2603:10b6:510:1a8::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Thu, 20 Apr
 2023 12:30:18 +0000
Received: from DM4PR11MB5341.namprd11.prod.outlook.com
 ([fe80::d1b9:3221:bc0d:1a9b]) by DM4PR11MB5341.namprd11.prod.outlook.com
 ([fe80::d1b9:3221:bc0d:1a9b%8]) with mapi id 15.20.6319.022; Thu, 20 Apr 2023
 12:30:18 +0000
Message-ID: <c2617e8c-c2d5-0b86-b400-570d3f808454@intel.com>
Date:   Thu, 20 Apr 2023 18:00:08 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [Intel-gfx] [PATCH 1/2] drm/dsc: fix
 drm_edp_dsc_sink_output_bpp() DPCD high byte usage
To:     Jani Nikula <jani.nikula@intel.com>,
        <dri-devel@lists.freedesktop.org>
CC:     <intel-gfx@lists.freedesktop.org>, <stable@vger.kernel.org>
References: <20230406134615.1422509-1-jani.nikula@intel.com>
Content-Language: en-US
From:   "Nautiyal, Ankit K" <ankit.k.nautiyal@intel.com>
In-Reply-To: <20230406134615.1422509-1-jani.nikula@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0022.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:97::23) To DM4PR11MB5341.namprd11.prod.outlook.com
 (2603:10b6:5:390::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB5341:EE_|PH7PR11MB6554:EE_
X-MS-Office365-Filtering-Correlation-Id: 54a2f78c-d21d-4d80-ac06-08db419afffc
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KuR7bOe2alLfhhSfqo4PmG3Qyk4WgTXrxPm3lXjJZ2lm8HJGMrP30mg3RheGKKqS2t/2nKQpbELMVtaJ0va8tV1urUQNpvulRB+vx4dYhrDdxi2cX2XiXxNfXs+GdQPK0+92+7wDIFkGerU5/OW8zwzID4zgcSDKBPwo/i/fD5p71OWKs5PR++o2rpdvXwhmurolpVN7HeBrCFgVAXkOwdCRBgZo17DB81RN0hUCLpiF7juhCQTYk6GeHw3GvTemJEsarwc9E7cJ0kP52qUA1zM1iIi7Te5FUMbOmDtL5r6F8rwMY1gc62GgfepRqL4TRcv8PuA6C+8PiDKZOOiFmiXykFal/6iQEb0Q3KzOcarGE5V3C6S6wJUnkjQa/XK86rWDvjUO/+4Zp6pHnLv9/H4lhnRazm52YCvtmvrW4VGNNNcMwpGcK+8AqteoSh+cV+MpiHlYwerzu16uoYE7yTIuLCtb/uKs8Rmtj4UOIVdm1phIVNkyOAqu9KP/l7TTpoLnjp+Fvf1v0W4yAKqgQJNYIptqp0ZDsEmstSBsXDyQnFelLX2653Pezl73odDQZXRNZj4VzxhpjdmRqU+TEiiSeszzB5dZxub0s7wwtraGKgdN3rt2FLlrIszral/5AD8vO5gRqR+cFarzGfL37A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5341.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(346002)(376002)(366004)(136003)(39860400002)(451199021)(66476007)(66946007)(66556008)(478600001)(5660300002)(8936002)(8676002)(316002)(82960400001)(41300700001)(38100700002)(4326008)(186003)(53546011)(55236004)(83380400001)(2616005)(6486002)(6666004)(6512007)(6506007)(26005)(31696002)(86362001)(36756003)(2906002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RXo0WVJqZnY1UklrOGpqQlUrR3JoSFRnb2tUV1ZSOEI0RTNnbU5pV1B5RDVN?=
 =?utf-8?B?dkhaSVJJam5hd0JDdnVqK3RleStqQmF5SFRURjFCQjhVYndBTHZKTldCdnhP?=
 =?utf-8?B?ZDhlK3BLWHhCM1NiOXlVbktxSmZ6ZEoyYS8yNDFLeFpVcm5URVJHQ0pRRzNW?=
 =?utf-8?B?OXR5WGErK0d5M2dxQ01nWGFGc284aE05NkZXUitzUnduajc5L2lNcW1LaVE4?=
 =?utf-8?B?VGFrcWZJUDVlby96R2tSWFpQNTVYMWFNSGpqWFQrNW1NclpySGhBUHNoOXU5?=
 =?utf-8?B?Z20vaXVsYmJrb0tDMEdpRUNITXp6VVh1eGpEV1F5cjl0ZFFxRzV2QVl2MUI1?=
 =?utf-8?B?OGtrOVpWbGxiTExKb29XREZxUitwd0xra2psMkxUN00yQjlwdUlFYThUVDAx?=
 =?utf-8?B?WTJ0RnA2TWZqcXF3b0Njem82VndRdzYxWmFvUEE0SHhtSjZHZmxLTUF3SkpF?=
 =?utf-8?B?d2pHNElhekw5Sms1d1Vhb0ZsK000TjMxOE1KSmFSSmxVQmxVNmlZdGMvb0Nh?=
 =?utf-8?B?VXFRNUNEYUxzMEJDV08yVnJzc2wxRWJGeVpLQjJWUzFYUm52blRidjRWdjE4?=
 =?utf-8?B?RVU0QkowcUl6V2JDMEEvcHliUjB2czZ2Ym82UysxSSs4bjZySVNkdWJYcU96?=
 =?utf-8?B?ZFhZcWtHYmVRaFhWU2ZmZjlzQVU1MmdyVElOTGVsSjBpZWRtbW5mWVdaeWtK?=
 =?utf-8?B?YnFVTlU5c3krcjdBNVJMblcwVW85enZLbVVuQVJhLzFtYk5TTjV3VzhRdEdk?=
 =?utf-8?B?OXpva0ZjaHNoc3hVREt0cFU4TUMweTZtTWhXbUZjZjZjK2tidENTY2FYV2xV?=
 =?utf-8?B?dk8xa21WdXg1V2d4YXdya3VXUzh2dEpMSkFpOVYvWU4wYnpRTlBTNWRsY1li?=
 =?utf-8?B?SCtPb2VMc1pXMFlXZThGVlI2OVlRZW9DeDJvRUQxd09ra3ZVcWpGV2hPMWpD?=
 =?utf-8?B?dDBGUG5NdXFBZEtka0pQVTRsM0pkZ0ZuU0FrVjN4c1dtVFpVdkQ0NVhFaVBs?=
 =?utf-8?B?QzZ4ZEJvUUtFc29EUml2VENOcjJ5S3U5SFI3M1JCb1BEa3U4L1A1TXVuZTUv?=
 =?utf-8?B?N1FQa01UNGJ2aFRpZGszL2JwZkdQRktBU3l1RnY2SzdEL2JKSDFlS0pQUGtW?=
 =?utf-8?B?ejJGMmVKOERlbGZxNjRrcENNb2lYdmtvVWp5ZGJFWE1zVmtseS9RZFlUL1hR?=
 =?utf-8?B?UnNKNDArNWhKbmF5NElYdldGZmROL1lLMkZWcmZPeGVLOHFraERabWdiZkJZ?=
 =?utf-8?B?OWlMWVV4NlJ0aGUwNXdGZ1RxMWM2N2IxaU5nVmtvSWNHYVhMbDJKU3E5eXZi?=
 =?utf-8?B?NEU3WE9hWTkzaGZyKzJ4Z2VrdDZWUzdZeGdHdHdxdWJPZmRrMjJVSVdjTk1O?=
 =?utf-8?B?M05CK3FKck9EWjJuWjUvRmVWbVlBekV4YmNQaEJreW92UXhkbU5ob28vS2ps?=
 =?utf-8?B?NkF3MzRwWHJmTHUrWExlNEw3QjdnelRqd0xiTkJTUENUb0h3NzlNeEtRZE1z?=
 =?utf-8?B?UGsxSUtkWjhKdXd6MHhOU1Vudnd3dHd6emFoMFBLKzVLODN1VGRqQjdud1lB?=
 =?utf-8?B?NjNlZTRMMGJ4ODZrQWJlVlBmY1ZmRWlqMFF2UWhvMnp1VjFvOHQ0a2czQnJl?=
 =?utf-8?B?allRNTU5YzExeWlOQzVmVE5XMHMwT2lZbzFqcnJUN1FiamhZNTdLVmZQd2ty?=
 =?utf-8?B?SWltMHBJTXdITHp0M0RFVForT2pGRGp0VDBPaSsxS3ZUcVpqRHVPUXIyTUow?=
 =?utf-8?B?Nkd4WEVDZHRGK0RvZjYyUm1kQTNOaVMyWnVCeEJVc1ZDd3dQWFhYSjJhWGRm?=
 =?utf-8?B?Wkk5TUtJU3NDYTNKc3EwL3J5U05abW9JZ29hSHVMRXNxOTZEWDkwK0NYamdw?=
 =?utf-8?B?SUxERTZIckRKWnZUNTFYUXNpdzVkYXcyajAyWEdDSDdJMVdKUFpHQTRoWDNr?=
 =?utf-8?B?OWlUM0hSWWM0ZEJFUkp2ZmM4Wi8zc1YvNjhKYVcyVVpZdmVZdGxIYjFiRGhS?=
 =?utf-8?B?dDF4aDhwaFdyQXVGa2J5eW8yWGxMd2h0YzAyaE02QkhJQjNTQUlCV2FRbmk2?=
 =?utf-8?B?dUR0UWpjam8xcUhOSkpJeGFtaDJZV1F0V3NRYjJvNE5IS056YkhxMWFpOHA0?=
 =?utf-8?B?Vm1PSVUya2crVjJtK0FQV1BUTHNoeWhETmF4dDJJSlg5Q1lsSks3WHR2SXF2?=
 =?utf-8?B?a3c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 54a2f78c-d21d-4d80-ac06-08db419afffc
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5341.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2023 12:30:18.3079
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mZ8Fciv2cRfhyoPc3d0kdBsBpRYsnCn3RVa7Codvtvd/3VOu4qFyEIHcpBciNanARioSBC519z1YbH67UjudWXpFFH02ElTnYrUKeHIq41Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6554
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-6.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

LGTM.

Reviewed-by: Ankit Nautiyal <ankit.k.nautiyal@intel.com>

On 4/6/2023 7:16 PM, Jani Nikula wrote:
> The operator precedence between << and & is wrong, leading to the high
> byte being completely ignored. For example, with the 6.4 format, 32
> becomes 0 and 24 becomes 8. Fix it, and remove the slightly confusing
> and unnecessary DP_DSC_MAX_BITS_PER_PIXEL_HI_SHIFT macro while at it.
>
> Fixes: 0575650077ea ("drm/dp: DRM DP helper/macros to get DP sink DSC parameters")
> Cc: Stanislav Lisovskiy <stanislav.lisovskiy@intel.com>
> Cc: Manasi Navare <navaremanasi@google.com>
> Cc: Anusha Srivatsa <anusha.srivatsa@intel.com>
> Cc: <stable@vger.kernel.org> # v5.0+
> Signed-off-by: Jani Nikula <jani.nikula@intel.com>
> ---
>   include/drm/display/drm_dp.h        | 1 -
>   include/drm/display/drm_dp_helper.h | 5 ++---
>   2 files changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/include/drm/display/drm_dp.h b/include/drm/display/drm_dp.h
> index 358db4a9f167..89d5a700b04d 100644
> --- a/include/drm/display/drm_dp.h
> +++ b/include/drm/display/drm_dp.h
> @@ -286,7 +286,6 @@
>   
>   #define DP_DSC_MAX_BITS_PER_PIXEL_HI        0x068   /* eDP 1.4 */
>   # define DP_DSC_MAX_BITS_PER_PIXEL_HI_MASK  (0x3 << 0)
> -# define DP_DSC_MAX_BITS_PER_PIXEL_HI_SHIFT 8
>   # define DP_DSC_MAX_BPP_DELTA_VERSION_MASK  0x06
>   # define DP_DSC_MAX_BPP_DELTA_AVAILABILITY  0x08
>   
> diff --git a/include/drm/display/drm_dp_helper.h b/include/drm/display/drm_dp_helper.h
> index 533d3ee7fe05..86f24a759268 100644
> --- a/include/drm/display/drm_dp_helper.h
> +++ b/include/drm/display/drm_dp_helper.h
> @@ -181,9 +181,8 @@ static inline u16
>   drm_edp_dsc_sink_output_bpp(const u8 dsc_dpcd[DP_DSC_RECEIVER_CAP_SIZE])
>   {
>   	return dsc_dpcd[DP_DSC_MAX_BITS_PER_PIXEL_LOW - DP_DSC_SUPPORT] |
> -		(dsc_dpcd[DP_DSC_MAX_BITS_PER_PIXEL_HI - DP_DSC_SUPPORT] &
> -		 DP_DSC_MAX_BITS_PER_PIXEL_HI_MASK <<
> -		 DP_DSC_MAX_BITS_PER_PIXEL_HI_SHIFT);
> +		((dsc_dpcd[DP_DSC_MAX_BITS_PER_PIXEL_HI - DP_DSC_SUPPORT] &
> +		  DP_DSC_MAX_BITS_PER_PIXEL_HI_MASK) << 8);
>   }
>   
>   static inline u32
