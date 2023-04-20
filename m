Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37F326E8C82
	for <lists+stable@lfdr.de>; Thu, 20 Apr 2023 10:16:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234184AbjDTIQN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Apr 2023 04:16:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233914AbjDTIQK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Apr 2023 04:16:10 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B11126BC;
        Thu, 20 Apr 2023 01:16:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681978569; x=1713514569;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=jL/Q+ZfVkY0YBlciF3Ow8eYWEHhMSwdVUaL6JIWkuck=;
  b=Xz6xL87c7jCELAyn4rPkjTyyoO4xZVO9HgEhPbAyCCJwht2+n+ci90qu
   fDxOG76AwAOchm2K0brSSxbt+HaCrN7upcQPhJP+JKuEewKHXOhfWOJX1
   KPKs7DUYTngpiw7sYavNRLFcFW3pbk9X9GFLzGEFg++CLt+5rhSPqP0AW
   qbA1U0R1QLOn+97kh8Ws4uIPhxACo/1nT/VdJvvJafWi36W6bR0GP3DlE
   tJHpDCAjam8H/QVrDr182Kds1YeXXzrH5/7C3bFF/2PLRRWQU5lBSl/1+
   1YnClgM/RHwKy8MCcCIDDwlYI37whLtPdcxYhL2iDxoe6eKfp1yP6nWEZ
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10685"; a="431948048"
X-IronPort-AV: E=Sophos;i="5.99,212,1677571200"; 
   d="scan'208";a="431948048"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2023 01:16:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10685"; a="669276682"
X-IronPort-AV: E=Sophos;i="5.99,212,1677571200"; 
   d="scan'208";a="669276682"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga006.jf.intel.com with ESMTP; 20 Apr 2023 01:16:08 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 20 Apr 2023 01:16:08 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 20 Apr 2023 01:16:08 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 20 Apr 2023 01:16:08 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.43) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 20 Apr 2023 01:16:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mKHKzVrBxN0qdhF3ouDBDxDMgPF+6N5Jhe4FCpxJDp2AJ8jgGrGjvoYCFR70XJOfrL1u9Wfc5o0SXvjGhzZBlD98atDPJeeAN8XI29p/CmS7x03/JYMdRBRp8P3B+/ITkUbeXr1mm7HBb43Vc+51CKgjXkZaB22ibeIdEyMCD2nyGS1zOgXF9MNd+3mCyHHoTtk586uIseRop1EHaM2sP9UMAcEzmuuA3enLhdUqsA8GnGRNNTsUYMTjsrhQXp54bUa31y4qA3QPm6p8h6ZB4fm5rHW56ZvB9SK4bofIfDtss7whnboBgTdwTWsueXArS3SQp02Qcp76U1kiCumcXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MwZ0dmGjHa62P4KbtOuunWqat7kADW75mwcE2ZX00Lg=;
 b=IF4dojn4e/lq5EbCGh6NLRFhItW/OUDboSKhJZq1ELLZm454/L9b4JIA4kwNxQ4gslhpw5SxlPTtmo0n7p+RVHW7AjZL/QIR2U+Q3qQejZnOyemhXsWQ/7LNNxhC0u0vsBZcr3zK9qXP0OUjamXo/pVY2L0VnaLHA9jWGzT/1ijPpJePnTyVEOQm7w7mt1qQ41PTeJ0jpJMkOQEoCa80JopGoCaPSpueX5M4WoLLDX7ZZM2CWWXHr8AKpseyTxpKdak1+2wouZvfdWiLYCIvcR3Wr2ckjEl+v0ja0orn4wXG5x0dDi/LbGWBkB2amvDe26kyAYsimOZ+XWK2qVAJfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DM4PR11MB8130.namprd11.prod.outlook.com (2603:10b6:8:181::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Thu, 20 Apr
 2023 08:16:06 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::73e9:b405:2cae:9174]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::73e9:b405:2cae:9174%6]) with mapi id 15.20.6319.022; Thu, 20 Apr 2023
 08:16:06 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jacob Pan <jacob.jun.pan@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>
CC:     Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
        "David Woodhouse" <dwmw2@infradead.org>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Ghorai, Sukumar" <sukumar.ghorai@intel.com>
Subject: RE: [PATCH v3] iommu/vt-d: Fix PASID directory pointer coherency
Thread-Topic: [PATCH v3] iommu/vt-d: Fix PASID directory pointer coherency
Thread-Index: AQHZZ9UC392MOCylEECV+/pkunR29a8z8Ghg
Date:   Thu, 20 Apr 2023 08:16:05 +0000
Message-ID: <BN9PR11MB52762EABB8EF8E685291604A8C639@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230405154447.2436308-1-jacob.jun.pan@linux.intel.com>
In-Reply-To: <20230405154447.2436308-1-jacob.jun.pan@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|DM4PR11MB8130:EE_
x-ms-office365-filtering-correlation-id: 600106ac-5185-4f75-4ab8-08db41777cd0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DI+8Ad+KHnsyfb4dFJv+Ora1CJ5eB+2XeU8y/Q0ro3vCwXygmtdYcmCQzxsrzM/QwJtfz2ntd6WUpjEeWljGZhERStI8Un99thU7O0VkNIaHeKQ19Q1Umypz5KSHgIXOLKMAG2ZkaPhgkztVDTzz2/hV3tH04L760zA2x1N1yvnaYn6cs6/oAkOACCO+LngQuCON3WlMo75PabBakK8zm9j8LyqUft3WGy/QAgjwJl+8VDsgfBRwXelrzx+fDbtcz2HJOLvU/q2m+82jezNLevlqdXnjWIJtvElI28UBn8L4A7U0JNMn/PonLxAHVVJkwh6vwgkEc8mG496r7lVksam1mGBOBqOETwZJJg4zgHntaYzrHdT1ZDmVKZn8GI0VW/WPk4Y1T3edv7s4CjIjI++OLd4lVxXYt3ipZwJsA/zZKFbP16sh5snI87cnNB39vMGU7RsZNNGlKz5ollDRL7z0HyFgkCIuVZPbkQCOpBbpncvrsFzwy5gW0iRX2nlT2Ts8ENI80Eqj6ko9GXE0gMYdF1QOBwCOGZBnk0RtnA/6v7Z8M78x6OwISbfcoi5mx6j1SXKib2oD4eeKW6dUeo2DSGQDgsSkzSbI8LlQdOlmXV7KXd3mZMaV7efHB+hy
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(39860400002)(346002)(396003)(376002)(136003)(451199021)(478600001)(54906003)(110136005)(83380400001)(33656002)(55016003)(6506007)(9686003)(26005)(186003)(82960400001)(38070700005)(86362001)(38100700002)(122000001)(71200400001)(7696005)(316002)(8936002)(8676002)(41300700001)(76116006)(4326008)(66946007)(66446008)(64756008)(66556008)(66476007)(5660300002)(2906002)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?OAgjVgJfFq/dwmTPaiwH3UksvtfLhaaGCq3s2KsB1GP0VmZ66qi3rGidJe6O?=
 =?us-ascii?Q?wVNiABd4cgsnodf9NvmdcXty7KOXIGLKscxk/Vpm6XzfxJR6VYHPyfHCrne0?=
 =?us-ascii?Q?8i0Adyd97JfV0R4JvhIQjzyiDJTN1xGd+autQ2EgZ9MPiUgdMguPAnAQJnb8?=
 =?us-ascii?Q?Atiu9dXAVAkwB9YmKzZIpobPLhSw9cWU+HyoP18AoSv11h9d63OiX8+5lve1?=
 =?us-ascii?Q?b9JwYs3Sq/uF6cF02HS0aKQJflCJ3Gc9mjgMrPja2KKX7ZBxPoXTUl4/ax9f?=
 =?us-ascii?Q?cX0RaYcMBE9SVonFTVT4wauM/+73Y7R7kGlw/fo6GDW8AjqhgJqjSVzXBrVa?=
 =?us-ascii?Q?ZO+ex86QVOc0qDNyOiVilOvG4VCS02/wRTuPcH17q/PE/+Wt/tdFfkBWTKMK?=
 =?us-ascii?Q?wLme5n1WK0KPSP47zfggeR9SpKjIe9e31QHGtyT3d796mKA9tLzoJNceRcQF?=
 =?us-ascii?Q?2TXO1AtV6RvEXBpLIruiW9tGglLNuO6Wz0ROA6SXDAqzv84acOdDh3cyptVa?=
 =?us-ascii?Q?ujxHKsw2x6MOM0RdxlUdNEztX7bGWy1LT3C5/YDjFoPMTG3VFanLMigtiQsD?=
 =?us-ascii?Q?3pAw+iWH7i6Btqjpo/NzOcqsiWHNPXLPscx9lAhj8w9ZcgqF4qOb/YOWZ4NT?=
 =?us-ascii?Q?PfYcpUUGYm0QKLa1DSazOP0qCUaPn6KWYg62nj2Hz8acMoH/OgpyqHV8N6XE?=
 =?us-ascii?Q?HbFe4xug8AnU8cm2bqBHc55buRzD01zaG59+102VKvVIgfJY9AQaX+FtPXEK?=
 =?us-ascii?Q?EzZwd3LiqMs2r/iIGnnQzLcEDRw9vh47FKnSVY04AEk4zSaQOC8Z/2Z4cDmU?=
 =?us-ascii?Q?FYyE0YTYe7ih5gxU0pItF++gDzdcK35c5ST7BziKRwS3liAaW++DmMhF3nJd?=
 =?us-ascii?Q?WlHFAjPno6ashEAlyRJyKqzglAEO4FzCx9sfsM1VnGJLQcJv2CeakqMrf6Eq?=
 =?us-ascii?Q?SHttOAwHAOj8UslbsDZRZbhJ+N6Ip0mC/kksF6xHTpxg4HlyxESZx9B5SaX2?=
 =?us-ascii?Q?vyPMO3sOaUzQwuiFzSVDEXHr9W8R4/Mkm/LG+CKfkFqgrit9RXy5eOoHKHHS?=
 =?us-ascii?Q?6ClWZJ0JTduDwM23ozwkiUAzzjLI7qDM8LbCgbGBt4H3bIDqlPA/boGSfINS?=
 =?us-ascii?Q?nvoOSfhrFTiU6QEe8TjM3hV5ZIPp2/zZM3tiPIolzqUeqmpo8RDc+Gbzkn2Y?=
 =?us-ascii?Q?10sQKYyspMra82jUhw9L77PeAv2Oy0LixVLl2Q3UU/Zam+bcD0rU3X56QmuH?=
 =?us-ascii?Q?Dt9nGecIZeyZKhZ9cBcaDWJ2fL0238e6UJ3ttG4p41/Fi5FluTffoF94z+/R?=
 =?us-ascii?Q?RcU8+HiCOlZgeTRbXnVccOFdrzEZg4B+j19EvJvXmX07MzxS370qem/fZuLF?=
 =?us-ascii?Q?8VrqjKWLwC5/1ZlDniy6nUEzTDf5nfWSv7EFPEvqk4iIHGmHBidhRrwoBOng?=
 =?us-ascii?Q?FdZDEDxVlXhS6OSZ60qcqB9BFAdkA7/3IE+uLIIxSGVK8ATAUM+zNvSvfayG?=
 =?us-ascii?Q?EGc4rxur2wd3hH82NjNqqtJY1ypomGxD9fVOALkzAsTsqATDgZq4ZT2jkDi8?=
 =?us-ascii?Q?8r0y/SvrCCgr7W4shgjFgzqnlRUaZnZthOuoXMfK?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 600106ac-5185-4f75-4ab8-08db41777cd0
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Apr 2023 08:16:05.3401
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SChZS9oeYd8Hv6v0LwpCJngZ5zZe+Vppcn1GEAt6bK/ZfPTQLd+LXK9URENiqnup6W/IioD8OqHC5KM4evwedg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB8130
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> From: Jacob Pan <jacob.jun.pan@linux.intel.com>
> Sent: Wednesday, April 5, 2023 11:45 PM
>=20
> On platforms that do not support IOMMU Extended capability bit 0
> Page-walk Coherency, CPU caches are not snooped when IOMMU is
> accessing
> any translation structures. IOMMU access goes only directly to
> memory. Intel IOMMU code was missing a flush for the PASID table
> directory that resulted in the unrecoverable fault as shown below.
>=20
> This patch adds clflush calls whenever allocating and updating
> a PASID table directory to ensure cache coherency.
>=20
> On the reverse direction, there's no need to clflush the PASID directory
> pointer when we deactivate a context entry in that IOMMU hardware will
> not see the old PASID directory pointer after we clear the context entry.
> PASID directory entries are also never freed once allocated.
>=20
> [    0.555386] DMAR: DRHD: handling fault status reg 3
> [    0.555805] DMAR: [DMA Read NO_PASID] Request device [00:0d.2] fault
> addr 0x1026a4000 [fault reason 0x51] SM: Present bit in Directory Entry i=
s
> clear
> [    0.556348] DMAR: Dump dmar1 table entries for IOVA 0x1026a4000
> [    0.556348] DMAR: scalable mode root entry: hi 0x0000000102448001, low
> 0x0000000101b3e001
> [    0.556348] DMAR: context entry: hi 0x0000000000000000, low
> 0x0000000101b4d401
> [    0.556348] DMAR: pasid dir entry: 0x0000000101b4e001
> [    0.556348] DMAR: pasid table entry[0]: 0x0000000000000109
> [    0.556348] DMAR: pasid table entry[1]: 0x0000000000000001
> [    0.556348] DMAR: pasid table entry[2]: 0x0000000000000000
> [    0.556348] DMAR: pasid table entry[3]: 0x0000000000000000
> [    0.556348] DMAR: pasid table entry[4]: 0x0000000000000000
> [    0.556348] DMAR: pasid table entry[5]: 0x0000000000000000
> [    0.556348] DMAR: pasid table entry[6]: 0x0000000000000000
> [    0.556348] DMAR: pasid table entry[7]: 0x0000000000000000
> [    0.556348] DMAR: PTE not present at level 4
>=20
> Cc: <stable@vger.kernel.org>
> Fixes: 0bbeb01a4faf ("iommu/vt-d: Manage scalalble mode PASID tables")
> Reported-by: Sukumar Ghorai <sukumar.ghorai@intel.com>
> Signed-off-by: Ashok Raj <ashok.raj@intel.com>
> Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
> ---
> v3: Add clflush after PASID directory allocation to prevent malicious
> device attack with unauthorized PASIDs. Also flush all the PASID entries
> after directory updates. (Baolu)
> v2: Add clflush to PASID directory update case (Baolu, Kevin review)
> ---
>  drivers/iommu/intel/iommu.c | 2 ++
>  drivers/iommu/intel/pasid.c | 7 +++++++
>  2 files changed, 9 insertions(+)
>=20
> diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
> index 59df7e42fd53..161342e7149d 100644
> --- a/drivers/iommu/intel/iommu.c
> +++ b/drivers/iommu/intel/iommu.c
> @@ -1976,6 +1976,8 @@ static int domain_context_mapping_one(struct
> dmar_domain *domain,
>  		pds =3D context_get_sm_pds(table);
>  		context->lo =3D (u64)virt_to_phys(table->table) |
>  				context_pdts(pds);
> +		if (!ecap_coherent(iommu->ecap))
> +			clflush_cache_range(table->table, sizeof(u64));

v2 of this patch was already merged w/o this change.

can you elaborate the purpose of v3? Here no flush is required as long
as it's done in other two places below.

>=20
>  		/* Setup the RID_PASID field: */
>  		context_set_sm_rid2pasid(context, PASID_RID2PASID);
> diff --git a/drivers/iommu/intel/pasid.c b/drivers/iommu/intel/pasid.c
> index fb3c7020028d..979f796175b1 100644
> --- a/drivers/iommu/intel/pasid.c
> +++ b/drivers/iommu/intel/pasid.c
> @@ -128,6 +128,9 @@ int intel_pasid_alloc_table(struct device *dev)
>  	pasid_table->max_pasid =3D 1 << (order + PAGE_SHIFT + 3);
>  	info->pasid_table =3D pasid_table;
>=20
> +	if (!ecap_coherent(info->iommu->ecap))
> +		clflush_cache_range(pasid_table->table, size);
> +
>  	return 0;
>  }
>=20
> @@ -215,6 +218,10 @@ static struct pasid_entry
> *intel_pasid_get_entry(struct device *dev, u32 pasid)
>  			free_pgtable_page(entries);
>  			goto retry;
>  		}
> +		if (!ecap_coherent(info->iommu->ecap)) {
> +			clflush_cache_range(entries, VTD_PAGE_SIZE);
> +			clflush_cache_range(&dir[dir_index].val, sizeof(*dir));
> +		}
>  	}
>=20
>  	return &entries[index];
> --
> 2.25.1

