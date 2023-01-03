Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EC5565C023
	for <lists+stable@lfdr.de>; Tue,  3 Jan 2023 13:47:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237168AbjACMq4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Jan 2023 07:46:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237591AbjACMqw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Jan 2023 07:46:52 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BF4F315;
        Tue,  3 Jan 2023 04:46:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672750011; x=1704286011;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=OyiHpBTUtrOpOIgkUu7AOYJ0CP3WyJZf4PgSGpgXers=;
  b=gIRL2oK29Xbn8qjHejwdEtVmPz8HQxZV+yAW4pd/Sz94Cu8BD8fUriU+
   xf1BRagIU1FiccIE/FRNIcTne4NItlH4a+YrYZ3yYWJf/FLAdtJJWxdSK
   wbm53PqYyUZMqVFiWCZxsX8tUY8cVsP1mr/FDyXa7a8hBYW7lUAkv6bT+
   Z0JqCC9d7KDAYffS+ptSkBYIlJd0LqUCdyfVBnGrFssqjW/wJS+LcojgL
   6NBlna1R+VXQeNpYAhvYfClri7rzXuxVIw+H/ZoJo9A/Qn1ZVuo6WP2fo
   B8O7CM8dqoSgeP0K2neHqOV6yAyLVzsGA+bF61wBn1fYHHKLMsh+6QlIA
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10578"; a="302024586"
X-IronPort-AV: E=Sophos;i="5.96,297,1665471600"; 
   d="scan'208";a="302024586"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jan 2023 04:46:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10578"; a="656750728"
X-IronPort-AV: E=Sophos;i="5.96,297,1665471600"; 
   d="scan'208";a="656750728"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga007.fm.intel.com with ESMTP; 03 Jan 2023 04:46:50 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 3 Jan 2023 04:46:49 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 3 Jan 2023 04:46:48 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 3 Jan 2023 04:46:48 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 3 Jan 2023 04:46:48 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mZTArZG7F0ikAGIKXkKjDZ9R3OGIEu1KiF1zlB8+9VZYZkqE20YfSpZk6ncnZzfOoSktdzYyl0nxWUa7t7w+3iFWAWLXgpnL5NhTGTDJ93pFI6m9CugW7d6Cii9eCudc4m8BGAz/RFU1NJj/V4yk0kXXFWMrjrFEHArLKFXV4sC048mmnPg26nWVt/opRW40cInvQ6iXcFBZU5ttwsXHZ6tcNszBSKNXOcRpuf7Xeg4bPiB6kOvj6qTM8L7CGyGE8wVFvpbdOkFMmAC/m1db6WuZfCpj4EbexzhZuw8IZOyiOEnsH28F1LGzMir1YSzbtUPUssAScvjU4hQlh+yZ1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=knoQLVbSeHm6uloE2nCNtrQ1u8gBzDUjGPGsG9rQZuc=;
 b=obb7fGhX8b+GSnOx0O6Rnwdt08u3dLBzGlPvVaNd7wnahN6ooBfUuYzBlIUv7tcTLpwz1hmGuCqgMh9bedrJWrc0jTjyAGb1FChf/7uQxE2GoLDYBCFEZZPl7rCMHYD1zEJ/TtGMSPRtJBL/tzOIIbfxKBtK5nmRndTOSdtGxnFFF2paDBfmYG3xhtBISGgPrWhBtXvoEuo6MZeKbit5HPpckqP0YxYAw6OBjNUs8weNP+FXz9XcSlQEKh9hdZEGkLpj2IHAh9asrqrV0O+Tv5ibpW3wgJ7mpmD6Zc6uOXGtn87fSWmkKElGOcJLit944SYWxxOJs3LNkQ657EBKqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MN0PR11MB6059.namprd11.prod.outlook.com (2603:10b6:208:377::9)
 by PH7PR11MB7595.namprd11.prod.outlook.com (2603:10b6:510:27a::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Tue, 3 Jan
 2023 12:46:46 +0000
Received: from MN0PR11MB6059.namprd11.prod.outlook.com
 ([fe80::499c:efe3:4397:808]) by MN0PR11MB6059.namprd11.prod.outlook.com
 ([fe80::499c:efe3:4397:808%8]) with mapi id 15.20.5944.019; Tue, 3 Jan 2023
 12:46:46 +0000
Date:   Tue, 3 Jan 2023 07:46:40 -0500
From:   Rodrigo Vivi <rodrigo.vivi@intel.com>
To:     Alexey Lukyachuk <skif@skif-web.ru>
CC:     <tvrtko.ursulin@linux.intel.com>,
        <dri-devel@lists.freedesktop.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        <intel-gfx@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>, Daniel Vetter <daniel@ffwll.ch>,
        David Airlie <airlied@gmail.com>
Subject: Re: [Intel-gfx] [PATCH v2] drm/i915: dell wyse 3040 shutdown fix
Message-ID: <Y7QjsNBYKumzEvBS@intel.com>
References: <20221225184413.146916-1-skif@skif-web.ru>
 <20221225185507.149677-1-skif@skif-web.ru>
 <Y6sfvUJmrb73AeJh@intel.com>
 <20221227204003.6b0abe65@alexey-Swift-SF314-42>
 <20230102165649.2b8e69e3@alexey-Swift-SF314-42>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20230102165649.2b8e69e3@alexey-Swift-SF314-42>
X-ClientProxiedBy: SJ0PR13CA0194.namprd13.prod.outlook.com
 (2603:10b6:a03:2c3::19) To MN0PR11MB6059.namprd11.prod.outlook.com
 (2603:10b6:208:377::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR11MB6059:EE_|PH7PR11MB7595:EE_
X-MS-Office365-Filtering-Correlation-Id: 98b29977-7f6a-4cd2-c1c4-08daed889283
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gkxEAkVpbbvO9zTa7fUbNV5s5N24kGLtj1qWcR3Hf41Pi6CA8i7DMjMrgTDX+Df4UuQ2vrOUymV72/4deFzLi7cdFceautsaC+iAU5Co0IKrUDawfviL0H7HF1YxDPlCWf+66WjAHi8zDU8xQSkKV1b89MoG7bwMBzDe+7f33spTZNjThcA4TzorBch7ZoJhJjpUqR+gYMXjIpmO+UQsnxEJ6gTPfThHCwF1s1nD3izqM5adoelgiuWAuhEv8urbzq0siXqfP+PILXkQuC+/jXWthzPwHgKt7KPlEpix9cpVUciobutsrG4Xj0xEEhnlVcNlHfLWO8P2HummD+acf+X5rhLcJUM07ql3A1YcH8rMIjz9JRIWSewsm3u2jn+eJdcInWF2CHM0qLdzjynX2S0ZY6PZ4lbSyF1Mz9meMV4j8fMtunCJX75J82VEasEoxcI7p4+wDZKjGpChyMiI4hlwSL8LLnJVoxBulsDHPa1n8Ffkc435aYoX5uoy7ytk/YHwcsDc4pT4rUdI+nEI37k+pTnMak+Dp05pinzng/3Hr4LdgY5lhOKhKqb3CKUND9YyfnuM3x7ohwUGgDFqfuOj3Qq6L05NvSWC33lqHBt5qxAR0G0xLmXM+Fz6EbSpry61eXtRzdI6sH4W2m0RfByIskjVfFknrDHhrINrXoqVdugdNms+0fVHoYzBVl1UcPHOeRbB+7mA5mcnnGK6YHroXePVwJLqJsro05ocbjcWzsFj80YN9aTVx1pH54RYr2ZrzbZ78CxmDegF5hluEA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB6059.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(376002)(346002)(136003)(39860400002)(366004)(451199015)(45080400002)(6666004)(6512007)(6916009)(54906003)(316002)(186003)(26005)(66556008)(966005)(4326008)(2616005)(66476007)(66946007)(6486002)(6506007)(478600001)(8676002)(66574015)(8936002)(41300700001)(5660300002)(83380400001)(44832011)(30864003)(2906002)(38100700002)(36756003)(82960400001)(86362001)(22166006);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?GTCpApWon0IrfN8jpfR/GctHG0gEam90JWYVG4vYvBaYd/O95nAyABSXGw?=
 =?iso-8859-1?Q?Y27u7mkz9Smr5B+PfwUsF4Jx6U5llpyZvPTXcLEz10akYfK2sSHnfLK3ng?=
 =?iso-8859-1?Q?tgj5gUR4MjFzcSAVF4Gq+0S98THZKzhi4ZMrMJAOvAhtCMA59Mb0rWtuZT?=
 =?iso-8859-1?Q?9KRMfE3syFtrdySltieu7M5mkG0lpW30K+OVo3Z7M0502KT9eyBIM2ezD2?=
 =?iso-8859-1?Q?KOHF/PFmIZhoylYZ8QH/nyhMxbkwtHUFacyW85BqybOFGbbnYGAy7rSlaA?=
 =?iso-8859-1?Q?xiieKzfpMvnt8g5DLi7mcLW8+jIU/D+3urwsPX0kLN1bGJk+q3O/V/Kfwh?=
 =?iso-8859-1?Q?wXcaeRM9z2iT535r78hrkoI/l+qW95vKxEWzo1dalMuG/qnzXHHr7U9VxN?=
 =?iso-8859-1?Q?lZDW/mBFZoWDDdG0o15iNpOpGWqGvPU9wGyv09hWUjGOHuKQoaBNXo+KYm?=
 =?iso-8859-1?Q?dFk1T+tFPZCtxQDnJN6Qe5y/lev4WO6mFYehM2TYycbtglFRFEzN/M3uuz?=
 =?iso-8859-1?Q?BMvP11JbYsoZiFZEe0YSgX7krU3wzjS81MU7FIDVYAiTrOXfQ7FGgpHhIG?=
 =?iso-8859-1?Q?9sHQjAk3jmQfSsCaG5aMGrzBUIWXcUWtVCsnh8C8FaVWWaYsvLoTQMlHq7?=
 =?iso-8859-1?Q?E7jBCaIVCwdCaEZHbuqnWBAQrTYz8gfP5460/7KHQJOWOcmAVPDKJ0Gy5D?=
 =?iso-8859-1?Q?UBRvatnoeTRvoErNkhqbTvN5K1Paepm2RB/ivtNJnwTYfYXgOKbubRqVKq?=
 =?iso-8859-1?Q?AZ8v8ZVnSTp+zcI26gek3Gnp5/e9hgRftNOjFb4S3Zeu9KUCa0cxnABqxy?=
 =?iso-8859-1?Q?A0UsWJEzJhxV8emtOAp9tO0crO6tJEw9x1ZEdijweCwY+U1+B69rA8fxAi?=
 =?iso-8859-1?Q?tu9/tUKnxwm9W5tuNMibvmGcikHUENBoJpSyjZM8mqo+8gVbW8kbKU7HZX?=
 =?iso-8859-1?Q?58zNpKJiStEqYtifXsdjzcz9ksDngqDANb2FcCar33BlZTsGGj8MGqtOJc?=
 =?iso-8859-1?Q?bg8JYZMjPn6gEjOqRxWaRWQeH0jzJd6yUtBLpGIfSjUW3H5YcObUVyKMui?=
 =?iso-8859-1?Q?4tx3C+ck9PKUQnW1ERYZmg+gSD3le0JfqT2S0cySBjsRlnaA2qHvf18tvh?=
 =?iso-8859-1?Q?vXSx0JH1GZ3U3rTsEBie2LZdudcn4rgUu2QF7MTek7wG65h486Y/C0p1Za?=
 =?iso-8859-1?Q?5MS2fqRV/IOeAwHYpUy5K6R9w+ca0TWCix/2881qA/G41krSE9XG/xPa+B?=
 =?iso-8859-1?Q?PCW4MCZK1pbn9qjDB0mnl84ZymFF4i5V/KS0pyVAbBoIBa9sZ07Rb/U1iq?=
 =?iso-8859-1?Q?wFgLJAKICtL58VrVs7l+MzWcYcjVqdQHcQXj/yW3KDRARr9GeFX6hoyCSB?=
 =?iso-8859-1?Q?L19qklu/F5+7kVrPAYEdhK/+6mLe8PjP+jIiKGZb+Sm3y7VZ/pll1xrBlH?=
 =?iso-8859-1?Q?goVAuHbBK4lNRc4rQFwZZavpOMmWNjovQ9VhiU6gxTXzIsYA6mrOWFl0UM?=
 =?iso-8859-1?Q?bmqpXUmeaxqSrJ6z4qTbmlSjqXATSKcBpiinj+GtdvrXrwDg+n1Kxh1x55?=
 =?iso-8859-1?Q?NOm5zOVzmotdTxLyJuuxGTHQul9LHsMVDioebmkAicBlvHsJSdLxogslF+?=
 =?iso-8859-1?Q?Y+rke0vgKavJdd96DsPswE6XGPeh8DPIz5?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 98b29977-7f6a-4cd2-c1c4-08daed889283
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB6059.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jan 2023 12:46:45.9253
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fEREy1QteEM3egjh8sB2eklf2BInig0XJFE3Kg0F+XB4dVnqLS99FOkNC77T2QFnawQA1RNUq0e7hU4+GfjVpA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7595
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 02, 2023 at 04:56:49PM +0300, Alexey Lukyachuk wrote:
> On Tue, 27 Dec 2022 20:40:03 +0300
> Alexey Lukyachuk <skif@skif-web.ru> wrote:
>=20
> > On Tue, 27 Dec 2022 11:39:25 -0500
> > Rodrigo Vivi <rodrigo.vivi@intel.com> wrote:
> >=20
> > > On Sun, Dec 25, 2022 at 09:55:08PM +0300, Alexey Lukyanchuk wrote:
> > > > dell wyse 3040 doesn't peform poweroff properly, but instead remain=
s in=20
> > > > turned power on state.
> > >=20
> > > okay, the motivation is explained in the commit msg..
> > >=20
> > > > Additional mutex_lock and=20
> > > > intel_crtc_wait_for_next_vblank=20
> > > > feature 6.2 kernel resolve this trouble.
> > >=20
> > > but this why is not very clear... seems that by magic it was found,
> > > without explaining what race we are really protecting here.
> > >=20
> > > but even worse is:
> > > what about those many random vblank waits in the code? what's the
> > > reasoning?
> > >=20
> > > >=20
> > > > cc: stable@vger.kernel.org
> > > > original commit Link: https://patchwork.freedesktop.org/patch/50892=
6/
> > > > fixes: fe0f1e3bfdfeb53e18f1206aea4f40b9bd1f291c
> > > > Signed-off-by: Alexey Lukyanchuk <skif@skif-web.ru>
> > > > ---
> > > > I got some troubles with this device (dell wyse 3040) since kernel =
5.11
> > > > started to use i915_driver_shutdown function. I found solution here=
:
> > > >=20
> > > > https://lore.kernel.org/dri-devel/Y1wd6ZJ8LdJpCfZL@intel.com/#r
> > > >=20
> > > > ---
> > > >  drivers/gpu/drm/i915/display/intel_audio.c | 37 +++++++++++++++---=
----
> > > >  1 file changed, 25 insertions(+), 12 deletions(-)
> > > >=20
> > > > diff --git a/drivers/gpu/drm/i915/display/intel_audio.c b/drivers/g=
pu/drm/i915/display/intel_audio.c
> > > > index aacbc6da8..44344ecdf 100644
> > > > --- a/drivers/gpu/drm/i915/display/intel_audio.c
> > > > +++ b/drivers/gpu/drm/i915/display/intel_audio.c
> > > > @@ -336,6 +336,7 @@ static void g4x_audio_codec_disable(struct inte=
l_encoder *encoder,
> > > >  				    const struct drm_connector_state *old_conn_state)
> > > >  {
> > > >  	struct drm_i915_private *dev_priv =3D to_i915(encoder->base.dev);
> > > > +	struct intel_crtc *crtc =3D to_intel_crtc(old_crtc_state->uapi.cr=
tc);
> > > >  	u32 eldv, tmp;
> > > > =20
> > > >  	tmp =3D intel_de_read(dev_priv, G4X_AUD_VID_DID);
> > > > @@ -348,6 +349,9 @@ static void g4x_audio_codec_disable(struct inte=
l_encoder *encoder,
> > > >  	tmp =3D intel_de_read(dev_priv, G4X_AUD_CNTL_ST);
> > > >  	tmp &=3D ~eldv;
> > > >  	intel_de_write(dev_priv, G4X_AUD_CNTL_ST, tmp);
> > > > +
> > > > +	intel_crtc_wait_for_next_vblank(crtc);
> > > > +	intel_crtc_wait_for_next_vblank(crtc);
> > > >  }
> > > > =20
> > > >  static void g4x_audio_codec_enable(struct intel_encoder *encoder,
> > > > @@ -355,12 +359,15 @@ static void g4x_audio_codec_enable(struct int=
el_encoder *encoder,
> > > >  				   const struct drm_connector_state *conn_state)
> > > >  {
> > > >  	struct drm_i915_private *dev_priv =3D to_i915(encoder->base.dev);
> > > > +	struct intel_crtc *crtc =3D to_intel_crtc(crtc_state->uapi.crtc);
> > > >  	struct drm_connector *connector =3D conn_state->connector;
> > > >  	const u8 *eld =3D connector->eld;
> > > >  	u32 eldv;
> > > >  	u32 tmp;
> > > >  	int len, i;
> > > > =20
> > > > +	intel_crtc_wait_for_next_vblank(crtc);
> > > > +
> > > >  	tmp =3D intel_de_read(dev_priv, G4X_AUD_VID_DID);
> > > >  	if (tmp =3D=3D INTEL_AUDIO_DEVBLC || tmp =3D=3D INTEL_AUDIO_DEVCL=
)
> > > >  		eldv =3D G4X_ELDV_DEVCL_DEVBLC;
> > > > @@ -493,6 +500,7 @@ static void hsw_audio_codec_disable(struct inte=
l_encoder *encoder,
> > > >  				    const struct drm_connector_state *old_conn_state)
> > > >  {
> > > >  	struct drm_i915_private *dev_priv =3D to_i915(encoder->base.dev);
> > > > +	struct intel_crtc *crtc =3D to_intel_crtc(old_crtc_state->uapi.cr=
tc);
> > > >  	enum transcoder cpu_transcoder =3D old_crtc_state->cpu_transcoder=
;
> > > >  	u32 tmp;
> > > > =20
> > > > @@ -508,6 +516,10 @@ static void hsw_audio_codec_disable(struct int=
el_encoder *encoder,
> > > >  		tmp |=3D AUD_CONFIG_N_VALUE_INDEX;
> > > >  	intel_de_write(dev_priv, HSW_AUD_CFG(cpu_transcoder), tmp);
> > > > =20
> > > > +
> > > > +	intel_crtc_wait_for_next_vblank(crtc);
> > > > +	intel_crtc_wait_for_next_vblank(crtc);
> > > > +
> > > >  	/* Invalidate ELD */
> > > >  	tmp =3D intel_de_read(dev_priv, HSW_AUD_PIN_ELD_CP_VLD);
> > > >  	tmp &=3D ~AUDIO_ELD_VALID(cpu_transcoder);
> > > > @@ -633,6 +645,7 @@ static void hsw_audio_codec_enable(struct intel=
_encoder *encoder,
> > > >  				   const struct drm_connector_state *conn_state)
> > > >  {
> > > >  	struct drm_i915_private *dev_priv =3D to_i915(encoder->base.dev);
> > > > +	struct intel_crtc *crtc =3D to_intel_crtc(crtc_state->uapi.crtc);
> > > >  	struct drm_connector *connector =3D conn_state->connector;
> > > >  	enum transcoder cpu_transcoder =3D crtc_state->cpu_transcoder;
> > > >  	const u8 *eld =3D connector->eld;
> > > > @@ -651,12 +664,7 @@ static void hsw_audio_codec_enable(struct inte=
l_encoder *encoder,
> > > >  	tmp &=3D ~AUDIO_ELD_VALID(cpu_transcoder);
> > > >  	intel_de_write(dev_priv, HSW_AUD_PIN_ELD_CP_VLD, tmp);
> > > > =20
> > > > -	/*
> > > > -	 * FIXME: We're supposed to wait for vblank here, but we have vbl=
anks
> > > > -	 * disabled during the mode set. The proper fix would be to push =
the
> > > > -	 * rest of the setup into a vblank work item, queued here, but th=
e
> > > > -	 * infrastructure is not there yet.
> > > > -	 */
> > > > +	intel_crtc_wait_for_next_vblank(crtc);
> > > > =20
> > > >  	/* Reset ELD write address */
> > > >  	tmp =3D intel_de_read(dev_priv, HSW_AUD_DIP_ELD_CTRL(cpu_transcod=
er));
> > > > @@ -705,6 +713,8 @@ static void ilk_audio_codec_disable(struct inte=
l_encoder *encoder,
> > > >  		aud_cntrl_st2 =3D CPT_AUD_CNTRL_ST2;
> > > >  	}
> > > > =20
> > > > +	mutex_lock(&dev_priv->display.audio.mutex);
> > > > +
> > > >  	/* Disable timestamps */
> > > >  	tmp =3D intel_de_read(dev_priv, aud_config);
> > > >  	tmp &=3D ~AUD_CONFIG_N_VALUE_INDEX;
> > > > @@ -721,6 +731,10 @@ static void ilk_audio_codec_disable(struct int=
el_encoder *encoder,
> > > >  	tmp =3D intel_de_read(dev_priv, aud_cntrl_st2);
> > > >  	tmp &=3D ~eldv;
> > > >  	intel_de_write(dev_priv, aud_cntrl_st2, tmp);
> > > > +	mutex_unlock(&dev_priv->display.audio.mutex);
> > > > +
> > > > +	intel_crtc_wait_for_next_vblank(crtc);
> > > > +	intel_crtc_wait_for_next_vblank(crtc);
> > > >  }
> > > > =20
> > > >  static void ilk_audio_codec_enable(struct intel_encoder *encoder,
> > > > @@ -740,12 +754,7 @@ static void ilk_audio_codec_enable(struct inte=
l_encoder *encoder,
> > > >  	if (drm_WARN_ON(&dev_priv->drm, port =3D=3D PORT_A))
> > > >  		return;
> > > > =20
> > > > -	/*
> > > > -	 * FIXME: We're supposed to wait for vblank here, but we have vbl=
anks
> > > > -	 * disabled during the mode set. The proper fix would be to push =
the
> > > > -	 * rest of the setup into a vblank work item, queued here, but th=
e
> > > > -	 * infrastructure is not there yet.
> > > > -	 */
> > > > +	intel_crtc_wait_for_next_vblank(crtc);
> > > > =20
> > > >  	if (HAS_PCH_IBX(dev_priv)) {
> > > >  		hdmiw_hdmiedid =3D IBX_HDMIW_HDMIEDID(pipe);
> > > > @@ -767,6 +776,8 @@ static void ilk_audio_codec_enable(struct intel=
_encoder *encoder,
> > > > =20
> > > >  	eldv =3D IBX_ELD_VALID(port);
> > > > =20
> > > > +	mutex_lock(&dev_priv->display.audio.mutex);
> > > > +
> > > >  	/* Invalidate ELD */
> > > >  	tmp =3D intel_de_read(dev_priv, aud_cntrl_st2);
> > > >  	tmp &=3D ~eldv;
> > > > @@ -798,6 +809,8 @@ static void ilk_audio_codec_enable(struct intel=
_encoder *encoder,
> > > >  	else
> > > >  		tmp |=3D audio_config_hdmi_pixel_clock(crtc_state);
> > > >  	intel_de_write(dev_priv, aud_config, tmp);
> > > > +
> > > > +	mutex_unlock(&dev_priv->display.audio.mutex);
> > > >  }
> > > > =20
> > > >  /**
> > > > --=20
> > > > 2.25.1
> > > >=20
> >=20
> >=20
> > I would like to say, that this solution was found in drm-tip repository=
:
> > link: git://anongit.freedesktop.org/drm-tip
> > I will quotate original commit message from Ville Syrj=E4l=E4=20
> > <ville.syrjala@linux.intel.com>: "The spec tells us to do a bunch of=20
> > vblank waits in the audio enable/disable sequences. Make it so."
> > So it's just a backport of accepted patch.
> > Which i wanna to propagate to stable versions
>=20
>=20
> Yes, I have checked 6.2-rc2 and everything work fine. I want to backport
> this commit to 6.0 and 6.1 because my company going to use these versions=
.
> Maybe it will be useful for 5.15, companies and vendors are passionate ab=
out
> LTS kernel ( I am edge to make special version of this patch for 5.15
> because hank 3 will be failed with it.).
> I am fully supportive with you that trouble is in timings/ locking change=
s.
> Early in detecting process I made some sleeps and it's help but not relia=
ble.
> Regarding to your question about fdo gitlab, I went to do it. And in proc=
ess
>  ("Before filing the bug, please try to reproduce your issue with the lat=
est
>  kernel. Use the latest drm-tip branch") I found that trouble is resolves=
.
> Using bisect and tests, I got needed commit.

okay, so the only commit we need is this:
https://patchwork.freedesktop.org/patch/508926/
?

and nothing else?

If we want this to be included in older released active kernel versions we
need to follow this process:

https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

We cannot create a new patch like the origin of this thread.

>=20
> Also I add log (by netconsole) from 5.15 kernel
>=20
> [   60.031680] ------------[ cut here ]------------
> [   60.031709] i915 0000:00:02.0: drm_WARN_ON(!intel_irqs_enabled(dev_pri=
v))
> [   60.031766] WARNING: CPU: 1 PID: 1964 at drivers/gpu/drm/i915/i915_irq=
.c:527 i915_enable_pipestat+0x1b9/0x230 [i915]
> [   60.032016] Modules linked in: snd_soc_sst_cht_bsw_rt5672 snd_hdmi_lpe=
_audio mei_hdcp intel_rapl_msr intel_powerclamp coretemp kvm_intel kvm puni=
t_atom_debug crct10dif_pclmul ghash_clmulni_intel joydev input_leds aesni_i=
ntel crypto_simd cryptd snd_sof_acpi_intel_byt intel_cstate snd_sof_intel_i=
pc snd_sof_acpi snd_sof_intel_atom dell_wmi snd_sof_xtensa_dsp snd_sof dell=
_smbios ledtrig_audio dcdbas snd_intel_sst_acpi nls_iso8859_1 snd_soc_acpi_=
intel_match sparse_keymap snd_soc_acpi i915 efi_pstore snd_intel_sst_core w=
mi_bmof dell_wmi_descriptor snd_soc_sst_atom_hifi2_platform snd_soc_rt5670 =
snd_intel_dspcfg intel_chtdc_ti_pwrbtn snd_soc_rl6231 snd_intel_sdw_acpi tt=
m drm_kms_helper snd_soc_core cec snd_compress ac97_bus rc_core processor_t=
hermal_device_pci_legacy snd_pcm_dmaengine i2c_algo_bit processor_thermal_d=
evice fb_sys_fops processor_thermal_rfim snd_pcm snd_seq_midi syscopyarea p=
rocessor_thermal_mbox sysfillrect processor_thermal_rapl intel_rapl_common =
mei_txe intel_soc_dts_iosf
> [   60.032231]  snd_seq_midi_event mei intel_xhci_usb_role_switch sysimgb=
lt snd_rawmidi snd_seq snd_seq_device snd_timer snd soundcore 8250_dw int34=
06_thermal mac_hid int3403_thermal int340x_thermal_zone int3400_thermal acp=
i_pad intel_int0002_vgpio acpi_thermal_rel sch_fq_codel ipmi_devintf ipmi_m=
sghandler msr parport_pc ppdev lp parport drm ip_tables x_tables autofs4 ov=
erlay hid_logitech_hidpp hid_logitech_dj hid_generic usbhid hid netconsole =
mmc_block crc32_pclmul r8169 realtek lpc_ich sdhci_pci xhci_pci cqhci xhci_=
pci_renesas dw_dmac wmi sdhci_acpi video dw_dmac_core intel_soc_pmic_chtdc_=
ti sdhci
> [   60.032427] CPU: 1 PID: 1964 Comm: plymouthd Not tainted 5.15.0-57-gen=
eric #63~20.04.1-Ubuntu
> [   60.032440] Hardware name: Dell Inc. Wyse 3040 Thin Client/0G56C0, BIO=
S 1.2.4 01/18/2018
> [   60.032450] RIP: 0010:i915_enable_pipestat+0x1b9/0x230 [i915]
> [   60.032669] Code: 89 55 cc 44 89 5d d0 44 89 4d d4 e8 c1 15 ae d8 48 8=
b 55 c0 48 c7 c1 a8 72 b5 c0 48 c7 c7 54 b5 b8 c0 48 89 c6 e8 0e 21 f5 d8 <=
0f> 0b 44 8b 55 cc 44 8b 5d d0 44 8b 4d d4 e9 9d fe ff ff 4c 89 f6
> [   60.032682] RSP: 0018:ffffaaa50070b878 EFLAGS: 00010086
> [   60.032694] RAX: 0000000000000000 RBX: ffff980ec8080000 RCX: ffffffff9=
ab7a748
> [   60.032703] RDX: 00000000ffffdfff RSI: ffffaaa50070b6b8 RDI: 000000000=
0000001
> [   60.032713] RBP: ffffaaa50070b8c0 R08: 0000000000000003 R09: 000000000=
0000001
> [   60.032721] R10: ffffffff9b21f3b6 R11: 000000009b21f38a R12: 000000000=
0000004
> [   60.032730] R13: 0000000000000000 R14: 0000000000000000 R15: ffff980ec=
8080000
> [   60.032740] FS:  00007f0967eec740(0000) GS:ffff980f34280000(0000) knlG=
S:0000000000000000
> [   60.032752] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   60.032762] CR2: 00007f7f5f21eaa4 CR3: 000000000a34a000 CR4: 000000000=
01006e0
> [   60.032772] Call Trace:
> [   60.032781]  <TASK>
> [   60.032793]  ? drm_crtc_vblank_helper_get_vblank_timestamp_internal+0x=
e0/0x370 [drm]
> [   60.032899]  i965_enable_vblank+0x3d/0x60 [i915]
> [   60.033139]  drm_vblank_enable+0xfd/0x1a0 [drm]
> [   60.033240]  drm_vblank_get+0xaf/0x100 [drm]
> [   60.033335]  drm_crtc_vblank_get+0x17/0x20 [drm]
> [   60.033426]  intel_pipe_update_start+0x128/0x2f0 [i915]
> [   60.033689]  ? wait_woken+0x60/0x60
> [   60.033710]  intel_update_crtc+0xd2/0x420 [i915]
> [   60.033969]  intel_commit_modeset_enables+0x74/0xa0 [i915]
> [   60.034228]  intel_atomic_commit_tail+0x587/0x14e0 [i915]
> [   60.034488]  intel_atomic_commit+0x3a6/0x410 [i915]
> [   60.034746]  drm_atomic_commit+0x4a/0x60 [drm]
> [   60.034849]  drm_atomic_helper_set_config+0x80/0xc0 [drm_kms_helper]
> [   60.034921]  drm_mode_setcrtc+0x1ff/0x7d0 [drm]
> [   60.035011]  ? drm_mode_getcrtc+0x1e0/0x1e0 [drm]
> [   60.035098]  drm_ioctl_kernel+0xb2/0x100 [drm]
> [   60.035182]  drm_ioctl+0x275/0x4a0 [drm]
> [   60.035265]  ? drm_mode_getcrtc+0x1e0/0x1e0 [drm]
> [   60.035354]  __x64_sys_ioctl+0x95/0xd0
> [   60.035372]  do_syscall_64+0x5c/0xc0
> [   60.035388]  ? exit_to_user_mode_prepare+0x3d/0x1c0
> [   60.035404]  ? syscall_exit_to_user_mode+0x27/0x50
> [   60.035418]  ? do_syscall_64+0x69/0xc0
> [   60.035431]  ? syscall_exit_to_user_mode+0x27/0x50
> [   60.035445]  ? do_syscall_64+0x69/0xc0
> [   60.035459]  ? syscall_exit_to_user_mode+0x27/0x50
> [   60.035474]  ? do_syscall_64+0x69/0xc0
> [   60.035487]  ? do_syscall_64+0x69/0xc0
> [   60.035501]  ? do_syscall_64+0x69/0xc0
> [   60.035514]  entry_SYSCALL_64_after_hwframe+0x61/0xcb
> [   60.035528] RIP: 0033:0x7f09681aa3ab
> [   60.035542] Code: 0f 1e fa 48 8b 05 e5 7a 0d 00 64 c7 00 26 00 00 00 4=
8 c7 c0 ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa b8 10 00 00 00 0f 05 <=
48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d b5 7a 0d 00 f7 d8 64 89 01 48
> [   60.035554] RSP: 002b:00007fff40931638 EFLAGS: 00000246 ORIG_RAX: 0000=
000000000010
> [   60.035567] RAX: ffffffffffffffda RBX: 00007fff40931670 RCX: 00007f096=
81aa3ab
> [   60.035576] RDX: 00007fff40931670 RSI: 00000000c06864a2 RDI: 000000000=
0000009
> [   60.035584] RBP: 00000000c06864a2 R08: 0000000000000000 R09: 00005560d=
d410090
> [   60.035592] R10: 0000000000000000 R11: 0000000000000246 R12: 000000000=
000007f
> [   60.035601] R13: 0000000000000009 R14: 00005560dd40ffe0 R15: 00005560d=
d410020
> [   60.035613]  </TASK>
> [   60.035622] ---[ end trace a700e85625cc752d ]---
