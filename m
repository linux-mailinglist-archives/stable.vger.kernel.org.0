Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D0F668CB4F
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 01:41:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229517AbjBGAl0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Feb 2023 19:41:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbjBGAlZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Feb 2023 19:41:25 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BC7C24100;
        Mon,  6 Feb 2023 16:41:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675730484; x=1707266484;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=jaeME6ttix+E4q8PyW1dRtFiEK7OjvLhV+Jwn7ouBfk=;
  b=RhOTTBkAjA1mQng4PqTN9sN8I6pX2OsCw6ZQzYROFFdWurZCc8x2Mg/T
   9GfVwEPT8qm6YTPin2s3OxUg31juli7VgeldFlzTJliPDNDcFLVpRscPS
   0Pq5fyvEc6mMX8CrQ+ACMkSmsseXmdAT7Wx7fk6bSoUNdsi8E6x/nwN5T
   xe/j+6uE3i0Mb8d38NGLg3NM/8Qx3Gf2TKv9DbbEThgTINcxaD5tdxsr5
   ej8BjBi7XHG68utg6FOZnl9nINy6ZpTlIoxqlUSMhtrwYYnyKjMjDvteb
   MeIxPA8MCFZywvy+5uR9CwWHJV62sgmcS+8OvEjnDJ6UEtGpJp0K6t9cZ
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10613"; a="356725212"
X-IronPort-AV: E=Sophos;i="5.97,276,1669104000"; 
   d="scan'208";a="356725212"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2023 16:41:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10613"; a="912126454"
X-IronPort-AV: E=Sophos;i="5.97,276,1669104000"; 
   d="scan'208";a="912126454"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga006.fm.intel.com with ESMTP; 06 Feb 2023 16:41:23 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 6 Feb 2023 16:41:23 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 6 Feb 2023 16:41:23 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 6 Feb 2023 16:41:22 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.47) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 6 Feb 2023 16:41:22 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i9w7p5Hr2INSO6mBNhaXxpMBExHEK8QQSC+7U84ysITZvTMsElnQZRQO6FD/bz/708msPJjAwhSz57AxVxIurvfR9e3Cr57vos/JTn5/hsZpTtUug83u/lnKn63ynCNZPzi2kKSZu2LUVskFDTtZfoGT5LGiyJ2QiD8uyCPyd35X3HeFc+m+SdkPZ2Qly33v7FWXkjpNM4l1rX26BTeD/PJiiSYkHydmz/Sv/V7sJnGnnapAaCc/90xVgTF3ADn+70KHOmoKjC+xlUhWvEfWKh6LW4M/Q952UB/7rDxIrAzGDQKZW1KptXnF2uGNhk+UZ3uzpYGe/DR3agCQUIMdBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pI2hRgYUUMYiONAMVV/lbOiKibrvtJ7taiuUvQSXbiU=;
 b=XJkKvbUQ7ENzxXxbt9HGY56EYiDOp9/TvriP1sXe679/y4fLx6TPQGPX7CAtWDX5Oj7cMrzakjAz3HA1SSagFmis/7MTgzrIHn+/36kCQDLe84IPMuo/60aBQpZuX4p0Kcf7MRXfpTOM4uwS7cyc6ZnQP3f4/7Jb+zxFXfv+KwGcyNuE5PqFvhfG/c+R/ZurgKDplM3+IRraxmIkHyl0gENWuh1qL+/FgJ/sMCqqyE85kuB502BNm+53PnMy7QTpZDGsu91Uga5XQQTTUo+viglsKy6pJ9wt1rBHZ6epJQENMW1CMfZK0VrlRc/8U3uWhJ/AVb1id/j3/eeaS9IVkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BL1PR11MB6002.namprd11.prod.outlook.com (2603:10b6:208:386::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Tue, 7 Feb
 2023 00:41:16 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d%8]) with mapi id 15.20.6064.034; Tue, 7 Feb 2023
 00:41:16 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Baolu Lu <baolu.lu@linux.intel.com>
CC:     LKML <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        Joerg Roedel <joro@8bytes.org>,
        David Woodhouse <dwmw2@infradead.org>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Ghorai, Sukumar" <sukumar.ghorai@intel.com>
Subject: RE: [PATCH] iommu/vt-d: Fix PASID directory pointer coherency
Thread-Topic: [PATCH] iommu/vt-d: Fix PASID directory pointer coherency
Thread-Index: AQHZOBtmLBuHwLKazUOSk0ZXb6TPPK6+JViAgAQKcoCAAHjjQA==
Date:   Tue, 7 Feb 2023 00:41:16 +0000
Message-ID: <BN9PR11MB52762264B58BA63D81F50F3E8CDB9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230203220714.1283383-1-jacob.jun.pan@linux.intel.com>
        <de4d0617-ceef-efca-69f1-a095ce91588e@linux.intel.com>
 <20230206092527.670f7ef7@jacob-builder>
In-Reply-To: <20230206092527.670f7ef7@jacob-builder>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|BL1PR11MB6002:EE_
x-ms-office365-filtering-correlation-id: b221a450-b9e5-442a-9718-08db08a40565
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0S/FRBw+f/yluE7/Bl/OHchyydaBXaCFtVxCUaKQna66Wz//ZHZ2DL6OO5kFOc4k2eA2BNQ13paynu5NFn6jEYOjONq9qcUY7OrkJk2rFaREKi+Mqcn3HDbxCT7x0i1mCgCGla47/s/2Ow89wF3ExUlu3kC201mvxH0xq1POuvUV07YiGSO3ey81CNeRAy8VLWL1E3SBk2f914ff55ejcsLIMcuFDnErYmibMX1B4uXjcr/vS2m+pvLmm9/OZ07Uy0Rj9X9mUgLTgyDysQ0AW9Fw1sB5mwJeg+XI5r+UuhDbCyKQRY7UcqUKPIVTrjmYh1lMUbvFgqLZY7R4V0GX4ohQ2LM/dRqSn5urRokIn9nKncx4gFrQYF3CuupcZ3nDc9dCA+i4LacI320wMTCW09FqHEhckU6bMPdQ0PK03ucnqcw1fL81z955dszZrBjEDjUkco7++m0E0icrI9fxsw17FXn0GmkLo7dc7iYMfY3y0hPYCoCm+wpsIUYBd5KEQrybl3/bnVU9VQRxPXd5bG2/9nRmELfCVYdg4KjN/OQ7xzfOzJmcvK4OpGRlJJ+ihY8OuCECkdzVbtyx9DiZdSsn7F8zhm7mY9JDubYU+y1noGNPo1/rE8T3RRMgSgM6Q3xmcOfQjQjbmwqAJIdAg7Wi9YO0yRFqnGutzKwn00+PgRDBhV6Mg0BeOmfCqgmKSEjB6tdhm9XBplRpVh03Hg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(376002)(346002)(39860400002)(396003)(366004)(451199018)(33656002)(122000001)(86362001)(38100700002)(38070700005)(55016003)(82960400001)(66446008)(316002)(64756008)(8936002)(41300700001)(8676002)(4326008)(66946007)(5660300002)(52536014)(110136005)(54906003)(66476007)(66556008)(76116006)(2906002)(4744005)(83380400001)(478600001)(186003)(6506007)(71200400001)(9686003)(26005)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?8IDHbo3C9BBTPtQfNCJvJBWy7ZkJPdlkjOh1DqI57ldmC+KJc/r8jHtggjYz?=
 =?us-ascii?Q?4REQExiKM1+NIOzIY11cKIofb/qjx4BCQjHRkYZtmXMHTKNY/a7n7OIEu4KW?=
 =?us-ascii?Q?vxJGVXmJNg4Xv3l+BiNahe1y2dNjcU8edzcKLmXqb/T25nxWPf/KuOnAHWkX?=
 =?us-ascii?Q?Bv5MLmP5RKbBSFliGa5/Lkd9B0LDgl+B6dVUS9mL4IvEpH3+aCp6pidKeySM?=
 =?us-ascii?Q?/GV7IQv10CGbUGrU1bSQ6PUD1pq2D9D8mCwWptylurjlKmqfRtAQuEGzdyTJ?=
 =?us-ascii?Q?dKYIkDHtpx33B6ljQXHe6UWz5mtqwHvITP3/PGcLTJ6CqNW/+SmKbpkDrN+n?=
 =?us-ascii?Q?JLwmm5gkwvJRAsr3bWYBGRzVCbLehqjldcgm9tky71tVWOVHIuwcYcS2hwQh?=
 =?us-ascii?Q?p46tj4ISSZKXZcxN0v1rsO6Heafad5jiqXFrzuYXGQIXMjFX2mHvZ+J9KkEF?=
 =?us-ascii?Q?YTlmNPdi/0BjDSXdZHctcXBNYojzTRgpsl0y3mvlWtus9lYfPFiMlOKb/gDM?=
 =?us-ascii?Q?pRTLqNLP8XhRXCOHAj5XTA4HivRCk1hiBoqKopkAZUkHBhHHxuje+ntDQwCu?=
 =?us-ascii?Q?6Dj2kfVwcWNjDw4j4P2tHz9istvHXYn2CHRd4k5P0TfP8PQ2mEkLNknfJZDG?=
 =?us-ascii?Q?cKL0vrysf8zO3fih6YmZBsJV+ccPzNGImH8hl00LLQ2mQcT6Aq5ymN4nIZU5?=
 =?us-ascii?Q?R+fAyMe1Q4R1e+IZj0Le+qq7FdrAzce5EH3Mf7ILP1WuxlXDzxEn90ZI40sh?=
 =?us-ascii?Q?vagMaDEJUtItuu+7pP75Zfmp0bILRGanZmpTR0K+sRSuAURjY3EHTSzIGojn?=
 =?us-ascii?Q?fbDpMb/kESdl6hrDO1emx11kD4bOvm2oTYBbLOiPU5wXN1tMlrQBMnCuRm42?=
 =?us-ascii?Q?KfVwScp9oDyzEZSZJt4bbDh6T2FSuipbC7B2WFB7t3wsjVpd5UWOgms0BLqn?=
 =?us-ascii?Q?mJO36ynUD7wIO+btExNopSxSUhMV279cAbqOHL/ICuQDhi2bebA1ph7+XomZ?=
 =?us-ascii?Q?n93lcIsTnHjMGuaHMU9c9nEzCYjZa/CRsx9v8ETZW4Ek1TGEGA2MkPzvIxZw?=
 =?us-ascii?Q?kTDKHbbn3hcAB6darwKLV/V1XKoT6wnQDEERby0L54rhvtlzroLonxWInNnJ?=
 =?us-ascii?Q?SssFe8X+KwrRbhb3qCF4JnRD5uabjD26VTXeH4VN6nO600O06WT/OlRyS+dQ?=
 =?us-ascii?Q?YTTpg7BjV7h7lcJ0gFRL25iC6JRSwBizdZt1jLgA1ODNzsNtGnMFrKstWc+C?=
 =?us-ascii?Q?lbeiOnJF+GCxIRxjCj2uFusBLcoLMXHI69x/8u6iLu4jn7c18nDVikDI7ZiA?=
 =?us-ascii?Q?yanGSyLKIThxsHCT5QjaaU0Y+vjVF2bpLaQQv82M0zpOoE/jpB13qGslrvC1?=
 =?us-ascii?Q?/SzG3fGLViI5uoBFcrbSycDcocLg3IXTdu3CAACAfBgmSoo0njHYQ3x79DHN?=
 =?us-ascii?Q?e6EealGNcfBSiyCM8daLNTPoqPlhAi3GtFcY6vhipNI3cqOfT8mqJmLx9ikd?=
 =?us-ascii?Q?JtW5rgzJCRpLsE/O2GQPepCqdJIKQ2ecT62nxbBk1vSPWoZMoEWnBZn1MNjx?=
 =?us-ascii?Q?6q/+wv76BrH4FJ30iM9P/oiQC2TxkDnwtFzizR4C?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b221a450-b9e5-442a-9718-08db08a40565
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Feb 2023 00:41:16.0947
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: syZxDXoR/x6VWQ/Fp44Qirq9GcHlEb64tib5cUgSZxKCEG571bpUDou+By/By4EzBiSnEk3JbzokrMwdxHIUvg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB6002
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> From: Jacob Pan <jacob.jun.pan@linux.intel.com>
> Sent: Tuesday, February 7, 2023 1:25 AM
>=20
> > > @@ -1976,6 +1976,12 @@ static int
> domain_context_mapping_one(struct
> > > dmar_domain *domain, pds =3D context_get_sm_pds(table);
> > >   		context->lo =3D (u64)virt_to_phys(table->table) |
> > >   				context_pdts(pds);
> > > +		/*
> > > +		 * Scalable-mode PASID directory pointer is not
> > > snooped if the
> > > +		 * coherent bit is not set.
> > > +		 */
> > > +		if (!ecap_coherent(iommu->ecap))
> > > +			clflush_cache_range(table->table, sizeof(void
> > > *));
> >
> > This isn't comprehensive. The clflush should be called whenever the
> > pasid directory table is allocated or updated.
> >
> allocate a pasid table does not mean it gets used by iommu hw, not until =
it
> is programmed into context entry.
>=20

this is insufficient.

Even after this point the PASID directory entry could be changed when
a new PASID table is allocated, e.g. in intel_pasid_get_entry().

