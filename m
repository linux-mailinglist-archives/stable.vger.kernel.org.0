Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 129164C4F20
	for <lists+stable@lfdr.de>; Fri, 25 Feb 2022 20:49:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235446AbiBYTuH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Feb 2022 14:50:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235195AbiBYTuG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Feb 2022 14:50:06 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 343405675C
        for <stable@vger.kernel.org>; Fri, 25 Feb 2022 11:49:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645818573; x=1677354573;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=zZD0NJdeiRUNV7dADsydEaHuf73BfsYC09AOUk8TDy8=;
  b=Gj539GcBdxaMx8Q74a90o0ymOoTEYAQcI/EUgHM62RLow7BWZ0QHPU77
   pbtnAbiLkiH9y6sLzZNVNGRN0rj+TyVN8U9aYztoyh8U7r6mgXf6r0Flm
   qJKkIhEKOn7JA5xcpwDe0kyM3IO4i4+DJChYnTYhnhNIjX/RVh1JQ7Rlk
   R77RX2tqwMdgaUqVPNQHPm15ffoAH9dFunFWqqb45r9UKQdRbcvbHEg8p
   y8ziren5ofTWElzxNEza0OzHSjKcb0JXoqTW6QSCcgVZyb3pFkzYpoEhJ
   Nak1cyYqfmiHJtmCvImUd9pypuGv/pF9l8g3XSvdGOyGU6gPx+us9agIJ
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10268"; a="252764320"
X-IronPort-AV: E=Sophos;i="5.90,137,1643702400"; 
   d="scan'208";a="252764320"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2022 11:49:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,137,1643702400"; 
   d="scan'208";a="549397319"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by orsmga008.jf.intel.com with ESMTP; 25 Feb 2022 11:49:32 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Fri, 25 Feb 2022 11:49:32 -0800
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Fri, 25 Feb 2022 11:49:31 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21 via Frontend Transport; Fri, 25 Feb 2022 11:49:31 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.48) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Fri, 25 Feb 2022 11:49:31 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SAyjr15a5R573MT9ydZE4lx35pK5ukz0GsiFk4k1bIWj54WGUseXbEtypXQvd5J5IfXsz/iT6L7/4shTFUR58WqiVMavYhxldnKnkvNNMnJOlTT2xnOAFBCx+AYzU75lVe3fXNaHchsVxeNe/hDE4mztzqEVVgmxubC6C7rtZtvCCp6HXQTHDDaV4bv61zAieFjenAtBpIMg+nBmChc904Hby+bRbMw41nH0gVoD8vgf4/Z9qhOQ1FS8x+HnfjmhPz5SLUvesWcE2MzF3XgmnN4pHqigYDyhmDUpOW9zOLkCmjZmQ7ef/xI1TzvKfII+Rr7wT8099YC2eGPtBQCabw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WbxZXXfIpvwJ7qsHpRcAd9Frv5TIW5Q9un24dD6L/4E=;
 b=k9n4q+dOBU5uxv0p8/yQTisfnxbu3vlaVTwLy7g6BF30QkX+3ZiRgIuy9dnBVWnKI//LjUbwKycwIgLByTlyBPDTBcbIw+MjuwNZDNI00okE0f6W402rteFZAf/LsYPQvcr5qmoyz0mveT6J1qyhG1p3ZgUR5oVgDM3R28lPeo+bjX9dJAi1Bslb5ipb8EQQQhZJDxYOmc6ndkKemfGS4Iki3xPNHKXOtpgM5ANkqfAdvVCanmcl210p1JESNXf7Ws6n+Xl248E8D4KwldXrYm/vil2rZx6ZVwtYPC9GUjJK/JxQZiJnp7RNFnr9Lg81K80O+9m6QBnSzCaNOBjf8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by MWHPR11MB1486.namprd11.prod.outlook.com (2603:10b6:301:e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22; Fri, 25 Feb
 2022 19:49:28 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::bd9e:6244:4757:615a]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::bd9e:6244:4757:615a%8]) with mapi id 15.20.5017.026; Fri, 25 Feb 2022
 19:49:28 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "Jankowski, Konrad0" <konrad0.jankowski@intel.com>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: FAILED: patch "[PATCH] ice: fix concurrent reset and removal of
 VFs" failed to apply to 5.15-stable tree
Thread-Topic: FAILED: patch "[PATCH] ice: fix concurrent reset and removal of
 VFs" failed to apply to 5.15-stable tree
Thread-Index: AQHYKlvkko27o4rXLE+wJj32ERK9IqykrH7g
Date:   Fri, 25 Feb 2022 19:49:28 +0000
Message-ID: <CO1PR11MB508908A1944769CEE9B3679CD63E9@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <164580268722157@kroah.com>
In-Reply-To: <164580268722157@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2d6e9794-1b31-4134-3422-08d9f897ef4d
x-ms-traffictypediagnostic: MWHPR11MB1486:EE_
x-microsoft-antispam-prvs: <MWHPR11MB1486DD53EE8CC9B860505A4BD63E9@MWHPR11MB1486.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PTiz4XFFNqdgQtYNFVQwBl1Z9UQs5lR3qSszW04dohP84sPXN8xArEoohkf1s0iJXqMMeOa7+Hp56q3IGewhTqPPmZl18Y4ECV0UGPLzc1A7vXBK6tXGS1HrFahqxCS9RjYgXi+9eFnwL1DtqVLiJa+3XGiWSxRO2vXOkJcdhHh3jrC9dgf3WF2SKmTtLHBx+RHrSzT5epItPC67V06gqQZuUoxn/AQAQq4ysBG253DA4m8DuSEjT0ZHHtQz74BxQ1ASgZXFWFRHjp3Wv/V4zFOJkoDKdzmwlHkNJVSTMFydpom72soLq0qghVrkowMP6T9x1KsLRLWKEfJ0mLW1+wWVNx0XtvnBNm1lpN1rAEThrlBDnjpgxQEtMLtbIk2KX0jw7YMqhvNcHaShDhyh5dRKLBBp/EXrVGsJJix8hMgzDeBJKsNv0KMoJ/ktahWmZjdsf+ONebOuMhXRmwRUcI5+wR+t2QFfahDvGm5Flbkktx/SLuF1vySzHJ9I+a4T4pj0/5kobsTxCJ37ZKejLXwyBgFpX7jcFJisg7HwDBcCe5cgMvRo/fuG1j9gZhIEzsZoCuH7eBQUT/fpHl8Xu0HismREe8mNWzZxjo1BRC7GGBN46QrYmEOL+9o6Fa6YGzFLTmJudyFcD6IDY7HabW6JHsTvJt4Yhrk2X8mfibzkO6IkfTwct7SUyuC7ESSJ+/RK1AS9ciJ0CNBPRf50Ow==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(7696005)(6506007)(82960400001)(122000001)(38100700002)(508600001)(53546011)(110136005)(71200400001)(86362001)(33656002)(9686003)(2906002)(83380400001)(6636002)(38070700005)(76116006)(66446008)(55016003)(316002)(66556008)(66946007)(64756008)(66476007)(8676002)(4326008)(52536014)(8936002)(5660300002)(186003)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?r6encP1jb/ICgzHFr4BFO56LRxIURWMYgkRy8/3GsIPlqdtnq6kLf3m3PwxM?=
 =?us-ascii?Q?rxx1Z2Q1yr/H6C8PMuFBHt+1E1uL6shvSyDPgy/8/Cfpk34vMWGQB0EFr4BL?=
 =?us-ascii?Q?aSlhC0LFSxrX2+QBRcW8HPnp/vFX4D5z87vzo5eqvowBY900CDWTj96w2CoE?=
 =?us-ascii?Q?/uHCVMMmTfgJrHxBHIxN3Y1KF+v7wZ4ZiwgOmniQNTXXm8foMLiTwtvOlBCN?=
 =?us-ascii?Q?s1izKaPgW9T9qUK0ockSM9TeKxDbspq0lzsyS7wOww6l29C1tFt1ZLDilvFO?=
 =?us-ascii?Q?9er+ZgRBIEDyo4fsONabdk2T20NQpr7RNUAPgfYWACyI3k9bEDYziaDdbdqF?=
 =?us-ascii?Q?uLWpnR6EKHjVguvXgLkxMh35h2QPLLyyyyqzqUjO4pb0p0MRsiv+p7NdIYVZ?=
 =?us-ascii?Q?epmu7xM52AhkZU1c79dWe6dj+sD1lftkIwf2ypNG8h3UMBeWsV3q+bOVf0ui?=
 =?us-ascii?Q?XLLILFqX42mSPgDS12k16G6U6Acso1N618WmfL2qf5fyNKRut1bcYU1LNd7a?=
 =?us-ascii?Q?HVOBMajlmBniCGvc5VVicPkl1DIZ0dplMJIvi83J25FoUW1KnsxJuBJSR9zG?=
 =?us-ascii?Q?fpRmT9Ldd3HgS4n+gK1LDMz5FxAwxGbPD0XQeOpeptsHsQOr43YZ71qQXz6K?=
 =?us-ascii?Q?/P4mnNSXSjzStY5z75HsTB4/NzTemDJlElhc6Cx9y0bKZe2lOHOqeS9qqhjA?=
 =?us-ascii?Q?ihoQevB1pmSA98bRzMbCG4GlHfGRG4tyJtBaRszKa+j+zXFQeRetBWci9SJl?=
 =?us-ascii?Q?aXCMglM8YWAH9LkcE3Ao4ih5G8IzwHQp+3UakF763zUSl2wUchWTHyxgLyZ3?=
 =?us-ascii?Q?HxqdwI8+CD8NPZ+pP8nNfog2AMMC+0L8OeH/CrpgQcp0UV+uXso3228J/NQa?=
 =?us-ascii?Q?AQo6GRmz2wvclloWXFrrAs1azd/8FfrIpnryh41FocNFy4hZTyfN8I5PuPAm?=
 =?us-ascii?Q?taPpGjm0Q12/e0Q3ow3h/mATS0VVibekLdW6oQVplafvjwcd9ltaCn/JrBYv?=
 =?us-ascii?Q?SC0KPsIjQftQYsXqC7D+yrCj//kmvabbwB8PAPD2b/x+eGtAdyrSy0pH/fV1?=
 =?us-ascii?Q?k9IwS+f2/OHYF5ljnXzRXThHbidTGwwqb9QomNn6nijWjytkMzSGuhk9ZH6p?=
 =?us-ascii?Q?+oyFsM9d18YFYao3dp6YLzU29SicTiEawpnyodIt7KN0Y1h5Sm1uC/ogGh3A?=
 =?us-ascii?Q?yEgbwhOtvbV2/akKn0wMf4fFj9aJD0qji0PSBEjASMi913g0plpmJs7ZmuFf?=
 =?us-ascii?Q?r7EDXBc+WdTF7GsCoh9b+niJoZh11Y9DadhVwpCKhWG/MjaCUX51o+sP8+xk?=
 =?us-ascii?Q?hJlTDaJJyNbcH8y2xrpQs+PWFaOjhX86YrPG32GAFr31Un0eJy95OSGzec+K?=
 =?us-ascii?Q?EICk0Zgan8yyJtI1VUlbu8YghpLmfq+VXm3gNNysVJFxU6mWM9fYzwxbp/GV?=
 =?us-ascii?Q?5o9QRpnZFzMh/l4yUTZaF4vKvPu2o7gK10+HwR9L9nIFCRvks7etQH60PkbR?=
 =?us-ascii?Q?3DGFrr1JmSmPrpH3k1yrdqhhgGPoE8o3xjRWH/TFgO24AIvlhgJBt/Ouah7c?=
 =?us-ascii?Q?6kuJLrwUopyrQOj1a47nGfSHMGk2XFPFz7LEM8EgcDR1L1UzYFvrEP4TlFb2?=
 =?us-ascii?Q?Wat/kMet628XVbbDlU65n0M8IQ/+xQ6JEF8pnwGhzzm+raEipUxgHpBUJ03S?=
 =?us-ascii?Q?RxmCeQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d6e9794-1b31-4134-3422-08d9f897ef4d
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Feb 2022 19:49:28.7106
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: C74qctDpNqcBQge0UWqZknM9nc/xCJgM7vhWyR781+09GhPE7HHOXUns9aa0NKGS1pUkedE0dCt6dbbaSq21i67k34Ai4JLFe1lL3G5jvzY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1486
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> -----Original Message-----
> From: gregkh@linuxfoundation.org <gregkh@linuxfoundation.org>
> Sent: Friday, February 25, 2022 7:25 AM
> To: Keller, Jacob E <jacob.e.keller@intel.com>; Nguyen, Anthony L
> <anthony.l.nguyen@intel.com>; Jankowski, Konrad0
> <konrad0.jankowski@intel.com>
> Cc: stable@vger.kernel.org
> Subject: FAILED: patch "[PATCH] ice: fix concurrent reset and removal of =
VFs"
> failed to apply to 5.15-stable tree
>=20
>=20
> The patch below does not apply to the 5.15-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
>=20
> thanks,
>=20
> greg k-h
>=20

I think this fix is important. It turns out to depend on another important =
fix: e6ba5273d4ed ("ice: Fix race conditions between virtchnl handling and =
VF ndo ops").

I will shortly submit both of these fixes together, after I confirm that it=
 applies cleanly.

Thanks,
Jake

> ------------------ original commit in Linus's tree ------------------
>=20
> From fadead80fe4c033b5e514fcbadd20b55c4494112 Mon Sep 17 00:00:00 2001
> From: Jacob Keller <jacob.e.keller@intel.com>
> Date: Mon, 7 Feb 2022 10:23:29 -0800
> Subject: [PATCH] ice: fix concurrent reset and removal of VFs
>=20
> Commit c503e63200c6 ("ice: Stop processing VF messages during teardown")
> introduced a driver state flag, ICE_VF_DEINIT_IN_PROGRESS, which is
> intended to prevent some issues with concurrently handling messages from
> VFs while tearing down the VFs.
>=20
> This change was motivated by crashes caused while tearing down and
> bringing up VFs in rapid succession.
>=20
> It turns out that the fix actually introduces issues with the VF driver
> caused because the PF no longer responds to any messages sent by the VF
> during its .remove routine. This results in the VF potentially removing
> its DMA memory before the PF has shut down the device queues.
>=20
> Additionally, the fix doesn't actually resolve concurrency issues within
> the ice driver. It is possible for a VF to initiate a reset just prior
> to the ice driver removing VFs. This can result in the remove task
> concurrently operating while the VF is being reset. This results in
> similar memory corruption and panics purportedly fixed by that commit.
>=20
> Fix this concurrency at its root by protecting both the reset and
> removal flows using the existing VF cfg_lock. This ensures that we
> cannot remove the VF while any outstanding critical tasks such as a
> virtchnl message or a reset are occurring.
>=20
> This locking change also fixes the root cause originally fixed by commit
> c503e63200c6 ("ice: Stop processing VF messages during teardown"), so we
> can simply revert it.
>=20
> Note that I kept these two changes together because simply reverting the
> original commit alone would leave the driver vulnerable to worse race
> conditions.
>=20
> Fixes: c503e63200c6 ("ice: Stop processing VF messages during teardown")
> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
> Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
>=20
> diff --git a/drivers/net/ethernet/intel/ice/ice.h
> b/drivers/net/ethernet/intel/ice/ice.h
> index a9fa701aaa95..473b1f6be9de 100644
> --- a/drivers/net/ethernet/intel/ice/ice.h
> +++ b/drivers/net/ethernet/intel/ice/ice.h
> @@ -280,7 +280,6 @@ enum ice_pf_state {
>  	ICE_VFLR_EVENT_PENDING,
>  	ICE_FLTR_OVERFLOW_PROMISC,
>  	ICE_VF_DIS,
> -	ICE_VF_DEINIT_IN_PROGRESS,
>  	ICE_CFG_BUSY,
>  	ICE_SERVICE_SCHED,
>  	ICE_SERVICE_DIS,
> diff --git a/drivers/net/ethernet/intel/ice/ice_main.c
> b/drivers/net/ethernet/intel/ice/ice_main.c
> index 17a9bb461dc3..f3c346e13b7a 100644
> --- a/drivers/net/ethernet/intel/ice/ice_main.c
> +++ b/drivers/net/ethernet/intel/ice/ice_main.c
> @@ -1799,7 +1799,9 @@ static void ice_handle_mdd_event(struct ice_pf *pf)
>  				 * reset, so print the event prior to reset.
>  				 */
>  				ice_print_vf_rx_mdd_event(vf);
> +				mutex_lock(&pf->vf[i].cfg_lock);
>  				ice_reset_vf(&pf->vf[i], false);
> +				mutex_unlock(&pf->vf[i].cfg_lock);
>  			}
>  		}
>  	}
> diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
> b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
> index 39b80124d282..408f78e3eb13 100644
> --- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
> +++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
> @@ -500,8 +500,6 @@ void ice_free_vfs(struct ice_pf *pf)
>  	struct ice_hw *hw =3D &pf->hw;
>  	unsigned int tmp, i;
>=20
> -	set_bit(ICE_VF_DEINIT_IN_PROGRESS, pf->state);
> -
>  	if (!pf->vf)
>  		return;
>=20
> @@ -519,22 +517,26 @@ void ice_free_vfs(struct ice_pf *pf)
>  	else
>  		dev_warn(dev, "VFs are assigned - not disabling SR-IOV\n");
>=20
> -	/* Avoid wait time by stopping all VFs at the same time */
> -	ice_for_each_vf(pf, i)
> -		ice_dis_vf_qs(&pf->vf[i]);
> -
>  	tmp =3D pf->num_alloc_vfs;
>  	pf->num_qps_per_vf =3D 0;
>  	pf->num_alloc_vfs =3D 0;
>  	for (i =3D 0; i < tmp; i++) {
> -		if (test_bit(ICE_VF_STATE_INIT, pf->vf[i].vf_states)) {
> +		struct ice_vf *vf =3D &pf->vf[i];
> +
> +		mutex_lock(&vf->cfg_lock);
> +
> +		ice_dis_vf_qs(vf);
> +
> +		if (test_bit(ICE_VF_STATE_INIT, vf->vf_states)) {
>  			/* disable VF qp mappings and set VF disable state */
> -			ice_dis_vf_mappings(&pf->vf[i]);
> -			set_bit(ICE_VF_STATE_DIS, pf->vf[i].vf_states);
> -			ice_free_vf_res(&pf->vf[i]);
> +			ice_dis_vf_mappings(vf);
> +			set_bit(ICE_VF_STATE_DIS, vf->vf_states);
> +			ice_free_vf_res(vf);
>  		}
>=20
> -		mutex_destroy(&pf->vf[i].cfg_lock);
> +		mutex_unlock(&vf->cfg_lock);
> +
> +		mutex_destroy(&vf->cfg_lock);
>  	}
>=20
>  	if (ice_sriov_free_msix_res(pf))
> @@ -570,7 +572,6 @@ void ice_free_vfs(struct ice_pf *pf)
>  				i);
>=20
>  	clear_bit(ICE_VF_DIS, pf->state);
> -	clear_bit(ICE_VF_DEINIT_IN_PROGRESS, pf->state);
>  	clear_bit(ICE_FLAG_SRIOV_ENA, pf->flags);
>  }
>=20
> @@ -1498,6 +1499,8 @@ bool ice_reset_all_vfs(struct ice_pf *pf, bool is_v=
flr)
>  	ice_for_each_vf(pf, v) {
>  		vf =3D &pf->vf[v];
>=20
> +		mutex_lock(&vf->cfg_lock);
> +
>  		vf->driver_caps =3D 0;
>  		ice_vc_set_default_allowlist(vf);
>=20
> @@ -1512,6 +1515,8 @@ bool ice_reset_all_vfs(struct ice_pf *pf, bool is_v=
flr)
>  		ice_vf_pre_vsi_rebuild(vf);
>  		ice_vf_rebuild_vsi(vf);
>  		ice_vf_post_vsi_rebuild(vf);
> +
> +		mutex_unlock(&vf->cfg_lock);
>  	}
>=20
>  	if (ice_is_eswitch_mode_switchdev(pf))
> @@ -1562,6 +1567,8 @@ bool ice_reset_vf(struct ice_vf *vf, bool is_vflr)
>  	u32 reg;
>  	int i;
>=20
> +	lockdep_assert_held(&vf->cfg_lock);
> +
>  	dev =3D ice_pf_to_dev(pf);
>=20
>  	if (test_bit(ICE_VF_RESETS_DISABLED, pf->state)) {
> @@ -2061,9 +2068,12 @@ void ice_process_vflr_event(struct ice_pf *pf)
>  		bit_idx =3D (hw->func_caps.vf_base_id + vf_id) % 32;
>  		/* read GLGEN_VFLRSTAT register to find out the flr VFs */
>  		reg =3D rd32(hw, GLGEN_VFLRSTAT(reg_idx));
> -		if (reg & BIT(bit_idx))
> +		if (reg & BIT(bit_idx)) {
>  			/* GLGEN_VFLRSTAT bit will be cleared in ice_reset_vf */
> +			mutex_lock(&vf->cfg_lock);
>  			ice_reset_vf(vf, true);
> +			mutex_unlock(&vf->cfg_lock);
> +		}
>  	}
>  }
>=20
> @@ -2140,7 +2150,9 @@ ice_vf_lan_overflow_event(struct ice_pf *pf, struct
> ice_rq_event_info *event)
>  	if (!vf)
>  		return;
>=20
> +	mutex_lock(&vf->cfg_lock);
>  	ice_vc_reset_vf(vf);
> +	mutex_unlock(&vf->cfg_lock);
>  }
>=20
>  /**
> @@ -4625,10 +4637,6 @@ void ice_vc_process_vf_msg(struct ice_pf *pf, stru=
ct
> ice_rq_event_info *event)
>  	struct device *dev;
>  	int err =3D 0;
>=20
> -	/* if de-init is underway, don't process messages from VF */
> -	if (test_bit(ICE_VF_DEINIT_IN_PROGRESS, pf->state))
> -		return;
> -
>  	dev =3D ice_pf_to_dev(pf);
>  	if (ice_validate_vf_id(pf, vf_id)) {
>  		err =3D -EINVAL;

