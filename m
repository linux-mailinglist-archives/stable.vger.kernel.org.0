Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFA976D0FE9
	for <lists+stable@lfdr.de>; Thu, 30 Mar 2023 22:21:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229755AbjC3UVh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Mar 2023 16:21:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229764AbjC3UVg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Mar 2023 16:21:36 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF41840D3
        for <stable@vger.kernel.org>; Thu, 30 Mar 2023 13:21:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680207695; x=1711743695;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=o4rGkzzjRL4JKtXiNz9KIRbR1dswCnFT6Kgpzb88G8o=;
  b=Btn15rrHHbbWlC0VA6KrvwQQd27rQVbONBSsnazOc2n6Il+Oj9+HHKeP
   WviBVKZm69zWOzlF8chXpIVmqiV8mXPx/F8jKCB00l0YspGLgGESyAXXY
   4qJOuVcKCo7EEo7IOuHPmgEzJ19TmD8enq/YoiNzCPQta63Rlrh42Zq3D
   1zTa75JdGBDVTeBK9/0pz00LUsxk6Ngs5dcOrGCR8BxT38UVFVCwwBkcK
   zFoCgvZzzybA2a/LeF4Fkri2cWgVBu8GoVd1xR2yeBLhla2Yc6dIK0dO3
   xlWmEQAEKiP5Ubyqonjh+qgn9zHFqd3bmwPVvkRdNJft8hqXTYJwyfdRn
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10665"; a="403975425"
X-IronPort-AV: E=Sophos;i="5.98,305,1673942400"; 
   d="scan'208";a="403975425"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2023 13:21:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10665"; a="808772519"
X-IronPort-AV: E=Sophos;i="5.98,305,1673942400"; 
   d="scan'208";a="808772519"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga004.jf.intel.com with ESMTP; 30 Mar 2023 13:21:35 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 30 Mar 2023 13:21:34 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 30 Mar 2023 13:21:34 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 30 Mar 2023 13:21:34 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.175)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 30 Mar 2023 13:21:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AzgfVEZ+helnLW7id32snsTqJL2P4by9lt2+PUF3AQ5pXo+GaS9s7LG3J6Usd84uJw1SGE9VAPPeiLtMAjiwdgCXoeG1KZpPWE57CHOOFGgvLOhtMs/7avIoc3I9b6i9yjLJYtbv36lbRRid16keVdvNCXc9iAtebsuZHDt+o43SRrGCSgwqf7cLU0mKCYy7pVjXRtTs31CB91liL9noSYYaTUcGj5vsrmzOv5uB12cDmCZFi3H22RzEnz9kYFCq7Cmw9elclwk+HwuiIjDqYJLN0kwhrKC54ZatnPqC+9kRtmCW+W9W7bmmP+pEpgUXV0gMszpuQOwkW8QL5gGAzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v2L3q9YMf6sucD/fiZHoAMlyGd4msElbdGTmKCan3o4=;
 b=HZGDLLFPjsAknMvGdtqyBVOcWYs/08YNp8gl+93BMMy25rweZC66ih7ERw0tEY50AMG6YrYiD27cEBMobv/alNO0sxxrfTZMhGGzV5jEUB8NqzLGUiUgGyLLrfjUuHAdCM/kLHEldYKBy3M+HfRYV4So+2pHxT44fBNxMLVdeqYKVsdKlCVuTZ2ZiuOPJT4za7SMU7ajMQHQXeMgqXQACkuAxhXThkr3+zirOlV+erI+RaAQJ2mPH0opUszA040+s4vvMgJOMfvncbwwXvvJs4KsnonmJL61B65CS0zn/GBlk9UzdzPyQcbNkuVuzI6v/gxLsgUlrWReGWyfJgUPzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM4PR11MB6360.namprd11.prod.outlook.com (2603:10b6:8:bd::12) by
 CY8PR11MB7194.namprd11.prod.outlook.com (2603:10b6:930:92::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6222.33; Thu, 30 Mar 2023 20:21:32 +0000
Received: from DM4PR11MB6360.namprd11.prod.outlook.com
 ([fe80::a77e:fdd7:ee30:aea0]) by DM4PR11MB6360.namprd11.prod.outlook.com
 ([fe80::a77e:fdd7:ee30:aea0%4]) with mapi id 15.20.6222.032; Thu, 30 Mar 2023
 20:21:32 +0000
From:   "Shankar, Uma" <uma.shankar@intel.com>
To:     "Borah, Chaitanya Kumar" <chaitanya.kumar.borah@intel.com>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] drm/i915/color: Fix typo for Plane CSC indexes
Thread-Topic: [PATCH] drm/i915/color: Fix typo for Plane CSC indexes
Thread-Index: AQHZYxifklyIShsBPEO9x6h1q0svM68Tw8Xw
Date:   Thu, 30 Mar 2023 20:21:32 +0000
Message-ID: <DM4PR11MB6360E30EB49BB7C77C146B14F48E9@DM4PR11MB6360.namprd11.prod.outlook.com>
References: <20230330150104.2923519-1-chaitanya.kumar.borah@intel.com>
In-Reply-To: <20230330150104.2923519-1-chaitanya.kumar.borah@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM4PR11MB6360:EE_|CY8PR11MB7194:EE_
x-ms-office365-filtering-correlation-id: 8797dc9a-adfc-453c-c49e-08db315c5a64
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vRwnyRuU/FT/u+hEf9tRBpTVBHLfWCZHTBkr32Pvsv3cXSK3C5S5SN3yAFca238fLEN4aCIepY+aZ4EDhySeWvWeAsbOpsK/ZQEByV/vyU+JqGUfMsDESlvrhysFUJGmyzT83HCtEndUVxZ1Ag7jRRHtXNHLR5Q/MXvwiyoVmEzT5F6rdH1wsoON8nCx2FowJ3P7cNNNnYuQESpYmqPKrjdk2p4Al3Hh5uv4fK5wAYU5u6w4vYNntfvoEUe4v7JYfGnFOoCH0JlUKoGa7JT3FOHVmDAuMyeqtYBPaCcWp/zERVP12dwUB79fNR/S7OqjtVWOdg5rWoP7ah8muhuFFJ9u42/aa5s6QYOsZber54JmYIF6LiCdVQPNLhwCbaVmSbjR30oSHhl4LKJRAYpYBKtB5SI05XC30Bb1H6ztNQgnDlatgkkapeTJSAiU0UKA4K+LIeHzUoZK97eGzXLuQ29fuvuLqnUQPCd/dsHxy8VCQhZhdzw6r6sbYMmi0ysTH4K5pvM7Wu/8AeGfYcf4E3FloOXeYnlCw0DZCtYsA7yF3kki9w24vuAGUbHKxv2X6oRut+YKb/NMIL2j9swyh2NHVsXkFxptrLUdHtjphYuZ9805B56PaaF/3wCHBjR+
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6360.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(396003)(346002)(366004)(376002)(136003)(451199021)(52536014)(8936002)(41300700001)(76116006)(6506007)(5660300002)(82960400001)(122000001)(38100700002)(86362001)(55016003)(66476007)(38070700005)(110136005)(66446008)(8676002)(4326008)(26005)(66556008)(7696005)(66946007)(316002)(478600001)(71200400001)(83380400001)(33656002)(53546011)(186003)(9686003)(64756008)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?mov3JdGFMSGt7mCdAKo1Gr685JBMQzBnsZnx//1xC9cnFhhAfJjtEkbY97Bl?=
 =?us-ascii?Q?ZRa9CPLMaWcg6qDhBNZRfFciPWMMizSDrqlFjwfGp1PSlGZTaLHgrobyNptc?=
 =?us-ascii?Q?1of50enbb4BbAtElLkBnqDGy0+8kxE+LMHFUG6XStfLRvyTL5loVSzqNMPiS?=
 =?us-ascii?Q?cj/56CCo+HmaEWc9BFNuWJQ0020sapLcXe0TmtJ8GxtbIBf//p3xKhPgmG2z?=
 =?us-ascii?Q?lWnOrPfjf1SYlVQ34g8cBvBAYwnWHkRLlq+svvjwobMkibCePFzDelubtCHE?=
 =?us-ascii?Q?o/K0K/3YNGgApNM7nZaTsOtEYXQkfQpZhrqXFUBzjZBb3psfQLPhLLuxouML?=
 =?us-ascii?Q?8kMkbiQ+tB7o8CFiQgo5QaeO7AHRZ2TnWS/8v7LDtAdtmPhyLXy6AdiOukBB?=
 =?us-ascii?Q?hQM6bniCKV2z42BfJWfUNLXgqXzLRFGzF14yLid4gd1BZ1h6C4yGnKHxCOOP?=
 =?us-ascii?Q?ge98olkWVyFpeosNhskev/Qneh6C5NJAHp2Ahx7xuC1V0fk/t3/c/Ao8+Jx1?=
 =?us-ascii?Q?+7U+Gp924d+kNuN1t12Z2+6UskMoCQVschvoAbMMugHZ1O9nElV36xlqiPs7?=
 =?us-ascii?Q?J32SJ5EPnRQ5ujnSVJxcaSURhG9HINh0nWqk+0VzgidRTWUJDnE92QULI4/A?=
 =?us-ascii?Q?tJ08jqOyO0RL7Xxy5UCurplemQd/D/6be+xeZYCnQFjT0LcwOXbc35B7cyRC?=
 =?us-ascii?Q?TMC2OwoCfYBjjTiYpa81NEv4R8aDzoPOkYtgv5uC/Ghwgjw1D2W0OjXkZ/2t?=
 =?us-ascii?Q?4OdLwHU6QAJVis6QhFGnzIElpp6oYXOeu1Dh7mUfp+N7OAEGSw0eaKu5niEA?=
 =?us-ascii?Q?jQO/XHiLUG/pj9EjzQyAoyCOT3EfDMsb4cpmHKKqTFAxfb/SwK1NccD1hBIy?=
 =?us-ascii?Q?Z5rHneagrXsLprQ+CS3imJfDfQT3xMLOhPxMQFsPItIAcQ9Qy1gTLmdhjtcP?=
 =?us-ascii?Q?PYxDBt3gdAB7pT+51ITpnoLRgEN7s4xtowSpDUhyQ3XHrDIjyZt9EhIqa/a1?=
 =?us-ascii?Q?rUOCvftRpDtM8BnQmFapz1Tpkebhxg4iWxexXyqMRUWSgFL7tWFl6qn4c5f+?=
 =?us-ascii?Q?E1HFI24AqBE5kqR+HFgqcbvoqmVwfQU1EgNRH/DYupHTscvdNdqKpVx3dlGV?=
 =?us-ascii?Q?gT7EES5R50THzPDRcUYajSRYlmcyHvp/5hIoujxooRNErj1oW4DFp45Tm6AT?=
 =?us-ascii?Q?IZvfOA1MqmdX90l8T73rbccTDES9X54FLgVBca6pr8rEKWNX7L5cF+nK5T7Z?=
 =?us-ascii?Q?y5py7Up8mmaiSVsxQ3XzdrO9VJrbOYkI1KIb7kNtEnI/3iltg3Mt5uuOixIc?=
 =?us-ascii?Q?FgOwkYDYmRDG9sSVh4Unuv4y+tkMyPSJ7cPKSAZeY5rN3jfanD0oggULcQjn?=
 =?us-ascii?Q?fQ/UHRK4hd7Pq0zUn+gzssn8R41IEumB7cmd9d1oRMp1sb3cwnq2uR2pK0EM?=
 =?us-ascii?Q?fOYldAcuGp1m84qyWT9rg6WN1Em/PvDbplnrVZypl+ExlCjyC1584NDfhOOL?=
 =?us-ascii?Q?uYULuJq92y2L5JhO7ULuGDFKxR3bTcfxwJRx5H2vcaI4Ox6jT/YyM56wXnN+?=
 =?us-ascii?Q?MWbU0EsMTgtdpZku4+I+fcqjwDBvDl1/lFUrE/UR?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6360.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8797dc9a-adfc-453c-c49e-08db315c5a64
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Mar 2023 20:21:32.5996
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OGPdA5YHNW2HMAryvDwWhMnGddgNXAxA5HfIjBuaWLJoAWcacDSwlpQ/W/R/ujhmbVzjyei4GADz+uU9mrvhuA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7194
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> -----Original Message-----
> From: Borah, Chaitanya Kumar <chaitanya.kumar.borah@intel.com>
> Sent: Thursday, March 30, 2023 8:31 PM
> To: intel-gfx@lists.freedesktop.org
> Cc: Shankar, Uma <uma.shankar@intel.com>; Borah, Chaitanya Kumar
> <chaitanya.kumar.borah@intel.com>; stable@vger.kernel.org
> Subject: [PATCH] drm/i915/color: Fix typo for Plane CSC indexes
>=20
> Replace _PLANE_INPUT_CSC_RY_GY_2_* with _PLANE_CSC_RY_GY_2_* for
> Plane CSC
>=20
> Fixes: 6eba56f64d5d ("drm/i915/pxp: black pixels on pxp disabled")

Looks Good, thanks for catching it.
Reviewed-by: Uma Shankar <uma.shankar@intel.com>

> Cc: <stable@vger.kernel.org>
>=20
> Signed-off-by: Chaitanya Kumar Borah <chaitanya.kumar.borah@intel.com>
> ---
>  drivers/gpu/drm/i915/i915_reg.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/gpu/drm/i915/i915_reg.h b/drivers/gpu/drm/i915/i915_=
reg.h
> index 8e4aca888b7a..85885b01e6ac 100644
> --- a/drivers/gpu/drm/i915/i915_reg.h
> +++ b/drivers/gpu/drm/i915/i915_reg.h
> @@ -7496,8 +7496,8 @@ enum skl_power_gate {
>=20
>  #define _PLANE_CSC_RY_GY_1(pipe)	_PIPE(pipe, _PLANE_CSC_RY_GY_1_A, \
>  					      _PLANE_CSC_RY_GY_1_B)
> -#define _PLANE_CSC_RY_GY_2(pipe)	_PIPE(pipe,
> _PLANE_INPUT_CSC_RY_GY_2_A, \
> -					      _PLANE_INPUT_CSC_RY_GY_2_B)
> +#define _PLANE_CSC_RY_GY_2(pipe)	_PIPE(pipe, _PLANE_CSC_RY_GY_2_A, \
> +					      _PLANE_CSC_RY_GY_2_B)
>  #define PLANE_CSC_COEFF(pipe, plane, index)	_MMIO_PLANE(plane, \
>=20
> _PLANE_CSC_RY_GY_1(pipe) +  (index) * 4, \
>=20
> _PLANE_CSC_RY_GY_2(pipe) + (index) * 4)
> --
> 2.25.1

