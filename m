Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B055D62249B
	for <lists+stable@lfdr.de>; Wed,  9 Nov 2022 08:28:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229573AbiKIH2L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Nov 2022 02:28:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbiKIH2K (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Nov 2022 02:28:10 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FAB812623
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 23:28:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667978889; x=1699514889;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Jcen3maY97pMf54SOOZ1tXqQZ7ir4UIo+n0/quGJcgE=;
  b=EH1Aa3AmAF6iVvf+vcuEdCwL3VKadSVbxmbXgYq9wi0MdaoNqYW3GQs1
   7woApSG3h5q6yqULQqagwcsKQ4whn/c/PohGZHgyIxmhP8lZFGyMbjobQ
   hlGxTzbAAttY9QOel0EzJT0Rm3vqFKMkIhR0+bZzfhcaihvEASkvQtu5T
   4qiq1DBIGziutDBQPD/3kVCmMHZpqAEgDDXoysIrDLWRjEG2Tq+FRLgXY
   6FM2KcmKMu7v3CP6KjJSxBsVTG13SDvRVuDZ2btOkIk1Pg635diuUZTs0
   50AaFSQfrW/i7JR/hFN/vpI66gLM9aZ7JTLbTKATRsi4yNj3bYHNSoyNC
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10525"; a="290628720"
X-IronPort-AV: E=Sophos;i="5.96,149,1665471600"; 
   d="scan'208";a="290628720"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2022 23:28:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10525"; a="779240723"
X-IronPort-AV: E=Sophos;i="5.96,149,1665471600"; 
   d="scan'208";a="779240723"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga001.fm.intel.com with ESMTP; 08 Nov 2022 23:28:08 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 8 Nov 2022 23:28:08 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 8 Nov 2022 23:28:07 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Tue, 8 Nov 2022 23:28:07 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.174)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Tue, 8 Nov 2022 23:28:07 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aaHB79lG3MJ/0mfznYOxgMQwS/nHwvEJeDXy7WjBYxLxV7HxcmEiNkxjH5ucYRoDhEns6ZMLN+crQZgTqCSEpIRQRRiSD86SrAeS61N9yeljYnmgNoFIWmZxqTF1xrm4z0OXc3zCiClSFfcIjtbCMaVwDveq2DU+vQ0JjOkawUGor3mKe7LqszlDzG4xGaKJF8yyqhD/x3qHsvfIDoK0yQxQ5UW/DGaplJzZZdrWiyu+ViR3PNbfh87EsnPFqZZil32oU4Lkub8vnO1BlUEeUtTMj1yPybrXsYDK91rdH2RruKd7davoUaj6R0Yn42txN6Hyt9nPnNtiGkk+9+kFGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7PPC25amgqUCeYEynQD9MCQIvumAJW0Pk0TpXK2yXV8=;
 b=bJx4HjW8zs1px3+AeQKDn3tui5oPCY3ZMWihnecxcHAvhR8yrnCqwAxsw3uhtm578P/2vPko0nkf+CKG3WwloNsRRgd0l3tzlryzTSAYrGR8Bt9IGMRuFUx/gVapz2d07CMhBU2cMYZXX+4xk+Dz9ExcOHmr6HApgdD8mvfagiK8OiMlRVD9L9mjjcYz6mkhqaVwE0Jgj6h4xz0rd0NxQgDPIzf8TsI3jXGovHQk+3yuGaFlnwGPc62lR5vZQR3iPv+mkGlAQ9Smaxi8rLsSJR85vJ+xBMuQ6zvew7v5DjIR5mpOVUmZpTlkKvmsoZnpOYICbQ4O1VSoBQDpC1J5SA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SN7PR11MB7043.namprd11.prod.outlook.com (2603:10b6:806:29a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.27; Wed, 9 Nov
 2022 07:28:06 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::737e:211a:bb53:4cd7]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::737e:211a:bb53:4cd7%4]) with mapi id 15.20.5791.027; Wed, 9 Nov 2022
 07:28:05 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Liu, Yi L" <yi.l.liu@intel.com>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "patches@lists.linux.dev" <patches@lists.linux.dev>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: RE: [PATCH 6.0 003/197] drm/i915/gvt: Add missing
 vfio_unregister_group_dev() call
Thread-Topic: [PATCH 6.0 003/197] drm/i915/gvt: Add missing
 vfio_unregister_group_dev() call
Thread-Index: AQHY83t10N8rFT6kE0KEIjQRmRfPU641NA2AgAD+SnA=
Date:   Wed, 9 Nov 2022 07:28:05 +0000
Message-ID: <BN9PR11MB52769C3DD45EC143EF4C1BB08C3E9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20221108133354.787209461@linuxfoundation.org>
        <20221108133354.938359604@linuxfoundation.org>
 <20221108091651.716e3124.alex.williamson@redhat.com>
In-Reply-To: <20221108091651.716e3124.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SN7PR11MB7043:EE_
x-ms-office365-filtering-correlation-id: 18d8c6ef-3b60-4a0e-6a49-08dac223f196
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lXL7aepgi3eddTxlbjdo1KTMSbBDcxZP6KBUH0R4FGopcc2mZRqnKOrtX6Iq9YwkVt69krzVEl0LmVi3fElOLSDU3xBbkNo/jWWG2ri4CUDkW4+6pEgDX4yC0tcxWThrkedTKUI5iRp3b/7Yi27SxtDXnmneloNdCXk6tY3lOSIF0piHCCooZbFwA/cTnXJd1S0qTE9oCroPgOkZObaSsoH7D6Mu3K417EJB0Wii0L7eG/ZsJWfh+ZaXolGpFKAG8yn6cLOK4zGQMrw5UPS8l+o0uyn/QtXNHj1ZA5KPqlX6tnEpAQVJCOYHXEy4mmCkqx4KqCvCDA7lGnaABNeFaYmhKTR0xGq5hJoYyvLyncXxXYU9y01f9Fj2Okw6pq07+w8lm7CH5z5el3Q9DXyPqgpxosb7jxGGFd/sXQGIT1CMclU/Bf7RYUiw5BuOt/Ry8Us4N9mGm4a6LkEUB93aHD/ZbvIXaVD/TFNbaKvwuFpnrpeqNw7TnNFSrT7BZr0/W22Qiwd9hBsp4S+DeCv130Y/PhSVDG5RetjezEM59/A2RjWZgJUdMmxO9y2GpIouLAbvxQW/xvQjwEg669/8vNXS1tQeLbNEG3nOtlQyT7TcA0UVmHUeaZetxW2zA2FSR89qZYqgOgWBQwMgtloPmQ0sgcIPvXlugbPGOEEzxyk6wlX0Uj/5odS9lncRni6WaULEAcnhXG6GJB0/FvOuJ4WE7M1427KaL+JeroZ4XOwIL5bpCA+IZus1sFDn2tpSqE+y+xPdQJUDBwY65QpbtF8CdlkJuVK2VY/p8kSk2fk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(346002)(366004)(396003)(136003)(376002)(451199015)(966005)(71200400001)(478600001)(6636002)(38070700005)(54906003)(110136005)(6506007)(7696005)(316002)(55016003)(4326008)(8676002)(33656002)(66446008)(64756008)(66476007)(82960400001)(66946007)(66556008)(76116006)(26005)(122000001)(38100700002)(9686003)(86362001)(52536014)(8936002)(5660300002)(186003)(83380400001)(41300700001)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?95Z8jn4MCort5vZCtUH9UmQeoZiXfOX08ImrHwOcRZMh5conxb54dS2QhBlL?=
 =?us-ascii?Q?L80bibnGy+GEZ8DpjLDUcl4eUmUS7kILBAYWLUAzoEik4HDzTldaCWt+cQTE?=
 =?us-ascii?Q?+kTxKF/jLqXsDxDqFtRuPjQu31whRjMOfmqvQvIxvv+fwJAwhqB3qDDYW9Cr?=
 =?us-ascii?Q?P1nbD2Uc29QOpGExX9CCmSt9dh3yuErk1U1EquRs/VetmW3dR+NVtOWc3EYp?=
 =?us-ascii?Q?9tkE/lvdaBw2u6leJkA7Pyz7Jfq+ZUG+QxIiVGAd4xL+S8as+Gwj2hKoV3TG?=
 =?us-ascii?Q?tUPTw2Z+TrAhUhV50LkSHr4DTL77uJ3uDrQL7bMu7CcTUHEcJlNbkNwmvUya?=
 =?us-ascii?Q?DUDCYnQwnKRl1+B2NF/DxK16ry/ANlfB5oRDAh9aK+j3EM4iOlFFSBVyZiCk?=
 =?us-ascii?Q?wS0Bx60lHVrCfSyZj1AoqgZDuAt/9iSP7Xxb08qvbNqmOo0NIawKkMHOFZ6j?=
 =?us-ascii?Q?xepu4yTkdE094pdjHNjUOYZl+vMdXoOD+GvUWiX+K2BZoBV2flZQcyfBgTuv?=
 =?us-ascii?Q?7oegI59t6K3SKqqeTRNZRUjV26d1ZdSN9EJWhLWJmLw/FJOV7+EMLWXRCnYD?=
 =?us-ascii?Q?PtilDFz2Idy+kKPTgj7MWWF9RkhJuhe6X8PKoPciNkCV+aL2JQar3sPITWTa?=
 =?us-ascii?Q?6UdFBVSs+S20kvGzIayuN6ZuMlbPaq0S/fZq1m9sG4qTjdZ+wCpdJUejx2iG?=
 =?us-ascii?Q?J0vd7xc+zJVNKZvSP8YE5dWfPYo31vUZydUjze6sRJ5nop9DCHSMyCpGFtqN?=
 =?us-ascii?Q?zI0fXikNoJkylbkMJibI49VOMYJauHkqWFnPCgNE+/4T9unV6xU5WPwXxHwy?=
 =?us-ascii?Q?E7pwlh59fXrlHQdhK7RKUwHYxS9Vn5prVnnkLsX0FKLYla01ItsXK9K1M2M3?=
 =?us-ascii?Q?HS5TlOEV1uMdQpRzipmRCIN23xKr6HO1/B8CyqpBdvqYcTehtNAB6i9/bu6o?=
 =?us-ascii?Q?ObJRLza8CCxNjqVfGKYS4fzYbZU/lWHYf3K9yJp3fBe5oJQoMEgJuxtAajb3?=
 =?us-ascii?Q?UYwRYxab/TAY4grCUe3V2vRpEGL21rJzT0ZrzSKr8L0t6MJYQwv6AzwzmrOb?=
 =?us-ascii?Q?c/rVdAHidWiV0Cj0NXDqO/OzrUvSqtABTRhq08l7lKUxZtPeNobc+LSnV0Gn?=
 =?us-ascii?Q?4Q3NIdHcgq23+Xty3lAhKjHgMYogblbsWMc7J0kee0gapepF2yz8r7a4fxa+?=
 =?us-ascii?Q?2DtmKmoV3GaZRJLNH9clD0/xR48nXY+tTPcuSqtFznJSZAA6soeZa1h7ZHuX?=
 =?us-ascii?Q?diiNWqtjPHypr08HzwfpIqcFN9T0lyvZFXBaJsusJFSxDpxhhv6jk7bJd5cF?=
 =?us-ascii?Q?VKDiTjv7R4N0xO8xmdW5y9gBJNVAFFPi5SdzfkF3UuUZalFMrE0NGRvvnbIn?=
 =?us-ascii?Q?d5+n6ua4R+df0ggq/KkJnNnUeSN01SwswVa/6eGtcbcLBH3eI3ONCuIeYyvv?=
 =?us-ascii?Q?xT43dsrhgHCzYCXyJCmWzo6tSgY/eM52nnPkGz1w4kitUGZYBu5pLrA6gJ4Y?=
 =?us-ascii?Q?vKkDfQ6J//W0vEPNDRKCi++5EjcIzrhhpqHZkH2KbJG5iZ+NnyzFhhnztf9V?=
 =?us-ascii?Q?vNp5p7ANtCRMOPyktz38KkMFEeX77OB3ZsU8P83r?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18d8c6ef-3b60-4a0e-6a49-08dac223f196
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Nov 2022 07:28:05.8843
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KSE12BwzNEPFoo5CbigS8BCP4jPvFljokq0278yZeTuDYWesUl60qRBUnouqHqm7uLhSrVqRXWt3MCLn9McWrg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7043
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Wednesday, November 9, 2022 12:17 AM
>=20
> On Tue,  8 Nov 2022 14:37:21 +0100
> Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>=20
> > From: Jason Gunthorpe <jgg@nvidia.com>
> >
> > [ Upstream commit f423fa1bc9fe1978e6b9f54927411b62cb43eb04 ]
> >
> > When converting to directly create the vfio_device the mdev driver has =
to
> > put a vfio_register_emulated_iommu_dev() in the probe() and a pairing
> > vfio_unregister_group_dev() in the remove.
> >
> > This was missed for gvt, add it.
> >
> > Cc: stable@vger.kernel.org
> > Fixes: 978cf586ac35 ("drm/i915/gvt: convert to use
> vfio_register_emulated_iommu_dev")
> > Reported-by: Alex Williamson <alex.williamson@redhat.com>
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > Link: https://lore.kernel.org/r/0-v1-013609965fe8+9d-
> vfio_gvt_unregister_jgg@nvidia.com
> > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> >  drivers/gpu/drm/i915/gvt/kvmgt.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c
> b/drivers/gpu/drm/i915/gvt/kvmgt.c
> > index e3cd58946477..dacd57732dbe 100644
> > --- a/drivers/gpu/drm/i915/gvt/kvmgt.c
> > +++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
> > @@ -1595,6 +1595,7 @@ static void intel_vgpu_remove(struct
> mdev_device *mdev)
> >
> >  	if (WARN_ON_ONCE(vgpu->attached))
> >  		return;
> > +	vfio_unregister_group_dev(&vgpu->vfio_device);
> >  	intel_gvt_destroy_vgpu(vgpu);
> >  }
> >
>=20
> Nak, the v6.0 backport for this also needs to call
> vfio_uninit_group_dev().  kvmgt had missed both calls, but at the time
> of f423fa1bc9fe this latter missing call had already been replaced by
> vfio_put_device() in a5ddd2a99a7a, where cb9ff3f3b84c had implemented a
> device release function with this call.  The correct backport should be:
>=20
> diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c
> b/drivers/gpu/drm/i915/gvt/kvmgt.c
> index e3cd58946477..2404d856f764 100644
> --- a/drivers/gpu/drm/i915/gvt/kvmgt.c
> +++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
> @@ -1595,6 +1595,8 @@ static void intel_vgpu_remove(struct mdev_device
> *mdev)
>=20
>  	if (WARN_ON_ONCE(vgpu->attached))
>  		return;
> +	vfio_unregister_group_dev(&vgpu->vfio_device);
> +	vfio_uninit_group_dev(&vgpu->vfio_device);
>  	intel_gvt_destroy_vgpu(vgpu);
>  }
>=20
> Kevin, Yi, please confirm.  Thanks,
>=20

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
