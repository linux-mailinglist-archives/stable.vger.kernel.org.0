Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62A97656D08
	for <lists+stable@lfdr.de>; Tue, 27 Dec 2022 17:40:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229488AbiL0QkQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Dec 2022 11:40:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231829AbiL0Qj7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Dec 2022 11:39:59 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E1F4BE34;
        Tue, 27 Dec 2022 08:39:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672159198; x=1703695198;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=gkw3O8jesC5TsVSKMM5gz5vKQyD6fhU0XJSdgQtPB0k=;
  b=f0wj/tWye98j3hCk+KdBQf3osAFZ2ltfD6KJwagOTDs0TsuVOVsYNBGs
   +CoiNfcb98X9JxhZcbxX99gLjm8q+BAfROXBEKXyAj6bI+3tbNu5TdGO9
   IdtVUaODIu/LbK9zVP8qkBAfShKJD6cK/Q928Qgs2KUK9L2ajND994Y6a
   BjFwD3n60abPqN+BSTVZOF71F43mi/PFm/YHh5SYdsf2qa0CpoHau54hr
   MpT5FGdnwSPr8LFrf5vO5hMEkHrpvJvZMLcM3uclaTeNBAd337CnKqDU9
   zuNmS+yy+nXqWkPM0AD64KEmU/6MqPl3ll5swS62Ughx3mRCDkr/w+9ZH
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10573"; a="301086726"
X-IronPort-AV: E=Sophos;i="5.96,278,1665471600"; 
   d="scan'208";a="301086726"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Dec 2022 08:39:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10573"; a="603085137"
X-IronPort-AV: E=Sophos;i="5.96,278,1665471600"; 
   d="scan'208";a="603085137"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga003.jf.intel.com with ESMTP; 27 Dec 2022 08:39:33 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 27 Dec 2022 08:39:32 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 27 Dec 2022 08:39:32 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 27 Dec 2022 08:39:32 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.177)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 27 Dec 2022 08:39:31 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AaPtgguw8vOntGlYPHLj0QF/hOHscDvWoUAOFiFM8fdsCMW43XxoOiL5sMQWAP5Tg6ROtyZwyQ9YU/t0Y8I67lxamqJY/oW6JhDr2U+U+f1824tPqmcXpfHWjGETlXsvZmVdZdVMWCxy0yFnQBkHT1C/KTWYCUfGQyfRknA1jZlSUCzwI8kp8W9LpUgvvp7u9V8CtYvzDK8glIxJcf/VfTgqy9pmNL9w+U3Zxxw8rr1gBiXLqm7CSY+pHE2dClhNqRNS4/H58ebWipg1xC0xiRYSgmQMttt44ppoIgyykG0lig99eZsIEiACWF6TvOmBAfQeEs9Wj1YrEOY4YWXbCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1pZj2xiqMPys5qKmpXF03ZdkZHjjAvsuFVyrOpRk8N8=;
 b=W7QlGoWGiqs2yioQlb1y7bAmUTZ9KJh/NJDKKojgo8NF0iifDSu4k+UMZuH8q2GiYdynjguRqLoQ55rMAskr8+al3KEKT8f9ZrLXZr4+qYmHZ3iu+f6NGQUms7pvVw7hsh/XGwi6A4jk0C9d4TcWYKjPgbZ1Sukh41vqLOZP/IpWlK2bqr6UE6Ud/Jjkad+4w/lMaPSAA3zohTLaPQjH+AN61ZnazexlKoOPU4MdmFvHzGzSq8aUWV1Av7IF1SS9ahexR2NKFxAEFywRkrVmXgR/KxTWFUtrd6ub2QHSibQUZYGOahsTesrwRGIvkje0l2THM6nsLdNz0FvB94Zl2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MN0PR11MB6059.namprd11.prod.outlook.com (2603:10b6:208:377::9)
 by PH8PR11MB6612.namprd11.prod.outlook.com (2603:10b6:510:1cf::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.16; Tue, 27 Dec
 2022 16:39:30 +0000
Received: from MN0PR11MB6059.namprd11.prod.outlook.com
 ([fe80::499c:efe3:4397:808]) by MN0PR11MB6059.namprd11.prod.outlook.com
 ([fe80::499c:efe3:4397:808%9]) with mapi id 15.20.5944.013; Tue, 27 Dec 2022
 16:39:30 +0000
Date:   Tue, 27 Dec 2022 11:39:25 -0500
From:   Rodrigo Vivi <rodrigo.vivi@intel.com>
To:     Alexey Lukyanchuk <skif@skif-web.ru>
CC:     <tvrtko.ursulin@linux.intel.com>,
        <dri-devel@lists.freedesktop.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        <intel-gfx@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>, Daniel Vetter <daniel@ffwll.ch>,
        David Airlie <airlied@gmail.com>
Subject: Re: [Intel-gfx] [PATCH v2] drm/i915: dell wyse 3040 shutdown fix
Message-ID: <Y6sfvUJmrb73AeJh@intel.com>
References: <20221225184413.146916-1-skif@skif-web.ru>
 <20221225185507.149677-1-skif@skif-web.ru>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20221225185507.149677-1-skif@skif-web.ru>
X-ClientProxiedBy: BYAPR11CA0080.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::21) To MN0PR11MB6059.namprd11.prod.outlook.com
 (2603:10b6:208:377::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR11MB6059:EE_|PH8PR11MB6612:EE_
X-MS-Office365-Filtering-Correlation-Id: 62c16092-45f8-4aa6-8729-08dae828ed0d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NDWq4agM8kr6az/TJJrNtmaK4xJI7YkDk58VlElQcXpxm6NMBAHXpOng2col+3leB4aDyC7DZ7icaFusS3+H/gS7Jkuzo/6p6AXe2RHL5iLehx+7qHrFdwGUpJYNMeImEl8LxoIDrOeVWPu3/T/Yojv2bC+OXZeqfzXTRj8bkIKct5iwlkqJCcu+jRcpZLQVV7r5xax8+o2Kr94U3svyIvXfbpohebd317c2zWRYqXjcESlflMppMM7B6ZxcXfcOw0qurXUbMnsWKaWejH/PxH+P729PVdWOZQSPi1Tp0tptJgTrAtZj3Ztl1a9cC7ke7t+xL9o2Os5boW8yPumc67jKR8D0sFg+8wnDRnrGIrRF89wyb1DBsXNLmowxDkzScUcp9ipgevfyi4gO1/aQsE+C6ga534LO/fMNjWFpCWB6moYxm9x6VULPlnMYJkYvPaMuSJM2um0C2ff0qVXB5uurXijEaPZ/QzQUb1sQ3cvQkIhqwiXpQgA2lImAIWfd5X601fp5y2LnEAenwO76giORooSMGUWWXo6dYd095F65KsbZOMA5Y8KoNX0tOLhz5yIAkZrxgLVXR/vO8hndRRiTpi4IdpdpXcg33Kt6mmegVJTJ9mGfaXeY3xxPZFtxs9uCh1ovZBbt3iC1gAUPzpdolbwcOknyazDo+13hW5Q=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB6059.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(376002)(396003)(366004)(39860400002)(346002)(451199015)(36756003)(66556008)(66476007)(6916009)(41300700001)(54906003)(66946007)(86362001)(4326008)(8676002)(83380400001)(82960400001)(38100700002)(6506007)(6666004)(478600001)(6486002)(966005)(2906002)(8936002)(316002)(26005)(44832011)(186003)(6512007)(5660300002)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JpFNE+2mfHanfJnFlQ0u0phaKGzKVvgFh2smnyyHztxmQHcI0nNB1DHv7pQh?=
 =?us-ascii?Q?mXKMg7eUo+C6fNlMBfpOR4EsaQ6ddc12rbK7PeDthCiQY0kFjmmJ/+AjqwSP?=
 =?us-ascii?Q?XbiFaFQpyj0y26OW/f8/3gVMxhhGmAutiI++muPNJWPBDHxgxoyuLhrJusro?=
 =?us-ascii?Q?hXNo92rXMfM4EiEw3ZAScXaqb+zAXVPHFGBWwrftKX+b9rBDFuwgNVrNVTER?=
 =?us-ascii?Q?8H0tSkVf0eQtoxkNvjJ3z6bJNdanhiJPgH1CvvZMhDMGZdHdgngwZg5nCiyZ?=
 =?us-ascii?Q?N0SMBoopDi7Da8GZHm+Lc3JmQmMAF6G87WwOjzzlnIVysbY1TbxMtMFuVdq5?=
 =?us-ascii?Q?2IwH4CNEyI79toCjXqHh+IAj+CuqonIxgHXfGNEI+mJQrIo4X+Gl+7A1cYO5?=
 =?us-ascii?Q?zaeqSu9dWqVTTCdemea2enpXkFH89e/iZPgD7+khTr39+qlunTR4DAFmxJgb?=
 =?us-ascii?Q?8zWQ/ZuBUIiD+v7r9rZBZU2o9Cx4DNPqeFBlL2j1m+/YrgC7ocanchoclndH?=
 =?us-ascii?Q?6V8+ooRizY2xA9fTzRF4Tt18vKrSXCX/Eh2ueZIpRvKkieG19bdbzkkTuxrN?=
 =?us-ascii?Q?cIHCmL746Q2+3ZOCnQpn1+regeneeWr4/6Po8zJTeXOqWO2wPRG+JpymQv6s?=
 =?us-ascii?Q?TVOe0HulSSFGtQEwPsXHgISKealB+tRWWq3HQ6mSNF1oPiFx4b58p88JIPeN?=
 =?us-ascii?Q?fpU2dmNV81mwCRLxzlmGUmF9PtIX8VvGeSd8Iu9BaHISgoexRQV4aCZz4UMD?=
 =?us-ascii?Q?99SJzVhULamRCuMYJmNJSy16AtyP7oos/5v9FzzLNWPOb7OJ1zmnxUOCAFrn?=
 =?us-ascii?Q?zdoxFCAXEd0ZY6nH2YFuKwLyvQ9Se8/idv7d/nZMmRShXe/Ok0LAqNLwXeSa?=
 =?us-ascii?Q?LaIdTnaA4BbMY0skEF0HunzIFdPpFWYpq6G6tt4sJECQBzMIiP9AvxOd3Ky8?=
 =?us-ascii?Q?cLgKDyBh1esu7d3MCGm/KTlHmUO7OcJyAmtQv/AOKRAdtdljC/mx9TL1RwnZ?=
 =?us-ascii?Q?LlTKQJkVcJ6SntPBmX2VX5aoaTwWvSv5NucnaQIjQQOh+Nc2GtJdJJe50k4R?=
 =?us-ascii?Q?gEBAX/GbXf413+gTncqQwdvCYAM5MffmOpzK4H2FXYcaS34RyUsRhZ0UsGF3?=
 =?us-ascii?Q?H29WZzjXIy9n+V57s7MXVagXLZwQnlz7WwE0iMe7G8gKhEMGgJnAo5Ey6hcu?=
 =?us-ascii?Q?+CFTaWvVHzEajkOXVrDzA2uttrEAVEv+kxncMGGuzxTAN5RxmH6LplIuyWH0?=
 =?us-ascii?Q?4OEXpteYG+QugpJM84Yg57oyiio3/vlrO4QtkxnXGJK1dri+YZccUK5qY0Ho?=
 =?us-ascii?Q?ESGWNXC6L1jXtCT6ParzBtd+r9r7jUxO/PwvXCNMs6EMonRDFXkfDAxsyOcI?=
 =?us-ascii?Q?QFFpYVPz5CQOTz2fGdS80JDpEuA0KC0Uz8EXZNi7feiXS4HfdwVqdzppGAVV?=
 =?us-ascii?Q?poHnY+TECxoBCDktCCt171Na0qs6etAmX/O/WyMnl56nk1+ccfmeHjXM26Ua?=
 =?us-ascii?Q?/7Q6KXYdBhFsg4Gdr5Uiq3t+JXL65OFqBoJhm46Dg6xYS8cvnozAt/55+EPL?=
 =?us-ascii?Q?jEisPJn1gvI2P6MWnnC3BZSyNpwXSLUiqU3+f1/Z?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 62c16092-45f8-4aa6-8729-08dae828ed0d
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB6059.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Dec 2022 16:39:30.2112
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: glK13ZMn9fwU97BSZUctwRSDFIao1qM702FMgT97HbFTovheh0c9fr3ZSmZSrOv7x62MC37nbTM/eSIfNooYng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6612
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Dec 25, 2022 at 09:55:08PM +0300, Alexey Lukyanchuk wrote:
> dell wyse 3040 doesn't peform poweroff properly, but instead remains in 
> turned power on state.

okay, the motivation is explained in the commit msg..

> Additional mutex_lock and 
> intel_crtc_wait_for_next_vblank 
> feature 6.2 kernel resolve this trouble.

but this why is not very clear... seems that by magic it was found,
without explaining what race we are really protecting here.

but even worse is:
what about those many random vblank waits in the code? what's the
reasoning?

> 
> cc: stable@vger.kernel.org
> original commit Link: https://patchwork.freedesktop.org/patch/508926/
> fixes: fe0f1e3bfdfeb53e18f1206aea4f40b9bd1f291c
> Signed-off-by: Alexey Lukyanchuk <skif@skif-web.ru>
> ---
> I got some troubles with this device (dell wyse 3040) since kernel 5.11
> started to use i915_driver_shutdown function. I found solution here:
> 
> https://lore.kernel.org/dri-devel/Y1wd6ZJ8LdJpCfZL@intel.com/#r
> 
> ---
>  drivers/gpu/drm/i915/display/intel_audio.c | 37 +++++++++++++++-------
>  1 file changed, 25 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/display/intel_audio.c b/drivers/gpu/drm/i915/display/intel_audio.c
> index aacbc6da8..44344ecdf 100644
> --- a/drivers/gpu/drm/i915/display/intel_audio.c
> +++ b/drivers/gpu/drm/i915/display/intel_audio.c
> @@ -336,6 +336,7 @@ static void g4x_audio_codec_disable(struct intel_encoder *encoder,
>  				    const struct drm_connector_state *old_conn_state)
>  {
>  	struct drm_i915_private *dev_priv = to_i915(encoder->base.dev);
> +	struct intel_crtc *crtc = to_intel_crtc(old_crtc_state->uapi.crtc);
>  	u32 eldv, tmp;
>  
>  	tmp = intel_de_read(dev_priv, G4X_AUD_VID_DID);
> @@ -348,6 +349,9 @@ static void g4x_audio_codec_disable(struct intel_encoder *encoder,
>  	tmp = intel_de_read(dev_priv, G4X_AUD_CNTL_ST);
>  	tmp &= ~eldv;
>  	intel_de_write(dev_priv, G4X_AUD_CNTL_ST, tmp);
> +
> +	intel_crtc_wait_for_next_vblank(crtc);
> +	intel_crtc_wait_for_next_vblank(crtc);
>  }
>  
>  static void g4x_audio_codec_enable(struct intel_encoder *encoder,
> @@ -355,12 +359,15 @@ static void g4x_audio_codec_enable(struct intel_encoder *encoder,
>  				   const struct drm_connector_state *conn_state)
>  {
>  	struct drm_i915_private *dev_priv = to_i915(encoder->base.dev);
> +	struct intel_crtc *crtc = to_intel_crtc(crtc_state->uapi.crtc);
>  	struct drm_connector *connector = conn_state->connector;
>  	const u8 *eld = connector->eld;
>  	u32 eldv;
>  	u32 tmp;
>  	int len, i;
>  
> +	intel_crtc_wait_for_next_vblank(crtc);
> +
>  	tmp = intel_de_read(dev_priv, G4X_AUD_VID_DID);
>  	if (tmp == INTEL_AUDIO_DEVBLC || tmp == INTEL_AUDIO_DEVCL)
>  		eldv = G4X_ELDV_DEVCL_DEVBLC;
> @@ -493,6 +500,7 @@ static void hsw_audio_codec_disable(struct intel_encoder *encoder,
>  				    const struct drm_connector_state *old_conn_state)
>  {
>  	struct drm_i915_private *dev_priv = to_i915(encoder->base.dev);
> +	struct intel_crtc *crtc = to_intel_crtc(old_crtc_state->uapi.crtc);
>  	enum transcoder cpu_transcoder = old_crtc_state->cpu_transcoder;
>  	u32 tmp;
>  
> @@ -508,6 +516,10 @@ static void hsw_audio_codec_disable(struct intel_encoder *encoder,
>  		tmp |= AUD_CONFIG_N_VALUE_INDEX;
>  	intel_de_write(dev_priv, HSW_AUD_CFG(cpu_transcoder), tmp);
>  
> +
> +	intel_crtc_wait_for_next_vblank(crtc);
> +	intel_crtc_wait_for_next_vblank(crtc);
> +
>  	/* Invalidate ELD */
>  	tmp = intel_de_read(dev_priv, HSW_AUD_PIN_ELD_CP_VLD);
>  	tmp &= ~AUDIO_ELD_VALID(cpu_transcoder);
> @@ -633,6 +645,7 @@ static void hsw_audio_codec_enable(struct intel_encoder *encoder,
>  				   const struct drm_connector_state *conn_state)
>  {
>  	struct drm_i915_private *dev_priv = to_i915(encoder->base.dev);
> +	struct intel_crtc *crtc = to_intel_crtc(crtc_state->uapi.crtc);
>  	struct drm_connector *connector = conn_state->connector;
>  	enum transcoder cpu_transcoder = crtc_state->cpu_transcoder;
>  	const u8 *eld = connector->eld;
> @@ -651,12 +664,7 @@ static void hsw_audio_codec_enable(struct intel_encoder *encoder,
>  	tmp &= ~AUDIO_ELD_VALID(cpu_transcoder);
>  	intel_de_write(dev_priv, HSW_AUD_PIN_ELD_CP_VLD, tmp);
>  
> -	/*
> -	 * FIXME: We're supposed to wait for vblank here, but we have vblanks
> -	 * disabled during the mode set. The proper fix would be to push the
> -	 * rest of the setup into a vblank work item, queued here, but the
> -	 * infrastructure is not there yet.
> -	 */
> +	intel_crtc_wait_for_next_vblank(crtc);
>  
>  	/* Reset ELD write address */
>  	tmp = intel_de_read(dev_priv, HSW_AUD_DIP_ELD_CTRL(cpu_transcoder));
> @@ -705,6 +713,8 @@ static void ilk_audio_codec_disable(struct intel_encoder *encoder,
>  		aud_cntrl_st2 = CPT_AUD_CNTRL_ST2;
>  	}
>  
> +	mutex_lock(&dev_priv->display.audio.mutex);
> +
>  	/* Disable timestamps */
>  	tmp = intel_de_read(dev_priv, aud_config);
>  	tmp &= ~AUD_CONFIG_N_VALUE_INDEX;
> @@ -721,6 +731,10 @@ static void ilk_audio_codec_disable(struct intel_encoder *encoder,
>  	tmp = intel_de_read(dev_priv, aud_cntrl_st2);
>  	tmp &= ~eldv;
>  	intel_de_write(dev_priv, aud_cntrl_st2, tmp);
> +	mutex_unlock(&dev_priv->display.audio.mutex);
> +
> +	intel_crtc_wait_for_next_vblank(crtc);
> +	intel_crtc_wait_for_next_vblank(crtc);
>  }
>  
>  static void ilk_audio_codec_enable(struct intel_encoder *encoder,
> @@ -740,12 +754,7 @@ static void ilk_audio_codec_enable(struct intel_encoder *encoder,
>  	if (drm_WARN_ON(&dev_priv->drm, port == PORT_A))
>  		return;
>  
> -	/*
> -	 * FIXME: We're supposed to wait for vblank here, but we have vblanks
> -	 * disabled during the mode set. The proper fix would be to push the
> -	 * rest of the setup into a vblank work item, queued here, but the
> -	 * infrastructure is not there yet.
> -	 */
> +	intel_crtc_wait_for_next_vblank(crtc);
>  
>  	if (HAS_PCH_IBX(dev_priv)) {
>  		hdmiw_hdmiedid = IBX_HDMIW_HDMIEDID(pipe);
> @@ -767,6 +776,8 @@ static void ilk_audio_codec_enable(struct intel_encoder *encoder,
>  
>  	eldv = IBX_ELD_VALID(port);
>  
> +	mutex_lock(&dev_priv->display.audio.mutex);
> +
>  	/* Invalidate ELD */
>  	tmp = intel_de_read(dev_priv, aud_cntrl_st2);
>  	tmp &= ~eldv;
> @@ -798,6 +809,8 @@ static void ilk_audio_codec_enable(struct intel_encoder *encoder,
>  	else
>  		tmp |= audio_config_hdmi_pixel_clock(crtc_state);
>  	intel_de_write(dev_priv, aud_config, tmp);
> +
> +	mutex_unlock(&dev_priv->display.audio.mutex);
>  }
>  
>  /**
> -- 
> 2.25.1
> 
