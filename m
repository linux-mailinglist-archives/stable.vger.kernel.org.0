Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62E34552A9A
	for <lists+stable@lfdr.de>; Tue, 21 Jun 2022 07:48:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344919AbiFUFs0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jun 2022 01:48:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345349AbiFUFsY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jun 2022 01:48:24 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 918E6220DB;
        Mon, 20 Jun 2022 22:48:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655790502; x=1687326502;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=YfRR3GWKXFNIP9vvivorCWPebRYgZgsO4OLM9D36zIw=;
  b=FvK2013DT9aKsIH2749eD2h0SdnMGSMvQMVzW0w1/4BiIjcr3ZPFEFb2
   LatHilKJ9jY/1WnJLKrR6ZWewZa4PJmyNK5H5rJtOxSWp6xQBe0YD7lLe
   9kn6OWl2QwBDeGT3WpUPsxAzsGxFSIQYFjYf/q9LSnSWaxf5UxbMU+dDq
   k+U2y+ZsYAPzw+Rig2kLCrleNrsBEzsG/ex0OIPtZ44sFmA9Ah3AIZVA9
   Ot6FohCEzAJ3b9LH0aZyxlkGYu62HH0OeHgngXF6u4uKCFHHYDuR3yXI1
   0eD4GZZ1E6DtMw6TLr9Qi0VNzOjslkNHr3+n9+nqMKn7hju9QnaTFdK2/
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10384"; a="280764018"
X-IronPort-AV: E=Sophos;i="5.92,209,1650956400"; 
   d="scan'208";a="280764018"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2022 22:48:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,209,1650956400"; 
   d="scan'208";a="764335421"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by orsmga005.jf.intel.com with ESMTP; 20 Jun 2022 22:48:21 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 20 Jun 2022 22:48:20 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 20 Jun 2022 22:48:20 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Mon, 20 Jun 2022 22:48:20 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.175)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Mon, 20 Jun 2022 22:48:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HwUgZI4DENZJWsOrZkGgxdEwPv13ZseOyPJ0Z+JEXEdIFR00gXXfQ+I2aq1o2g64UKmdUZ81HBBvFuyhfJ7oVIUI6TetFcuZCllYtPYbnKzEDtsTMdP+Pu7Oc5MjtUFpOyQBWptWo6yaY8dPvzXa53Sm/BzpjN0lNlF+FTpmX1tT79hqN5Tyv6hPXm2qxulattklf3PxhGTjeX+OnN3cexeZisulpOhC49A36kww2SUg8+WhJBTkh8DyRNT62++YfWhjUiVu9fqL7ErMgMK5FZuBv2fZciISg9K+NW/9vuaorQZCPZDbNTooKDIBaA4VPsafmDpki/mgIlAJi5mjFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YfRR3GWKXFNIP9vvivorCWPebRYgZgsO4OLM9D36zIw=;
 b=T5ShDMk2CqQV44Ys3Z28gHNbQ8HcHvs7i3PHTDnG7zY5yNtWrGsqGUX2ihl8BE0aYsMP/R1ufddaH1FeB8/ulXqhHYwF5wy15pWbta4S4E/F1wbkGwVHl8lQqN1P8ctVJdVZh1gViVZQPyNu4z/WPqPvlAMCeXdGgiADLuKLVm/7eNmBL9pdedKtjmAVi0ca2HWxaJVlEpcN7+ES2pcBp/QgnMPgD5Jr454gaZ1ew0PV1Tuq8qsgrxiXQcH7q5CFs7D92tXcEo1tyWPiCXVwobKUv72sFvz4FdR/FGqqvV8ZPG+kLJS00rWRL9osIj18nxI0bIrsfKAcemPNsVeLCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DM6PR11MB2729.namprd11.prod.outlook.com (2603:10b6:5:ce::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.13; Tue, 21 Jun
 2022 05:48:18 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::8435:5a99:1e28:b38c]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::8435:5a99:1e28:b38c%2]) with mapi id 15.20.5353.022; Tue, 21 Jun 2022
 05:48:18 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Baolu Lu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Raj, Ashok" <ashok.raj@intel.com>
CC:     "Qiang, Chenyi" <chenyi.qiang@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH 1/1] iommu/vt-d: Fix RID2PASID setup failure
Thread-Topic: [PATCH 1/1] iommu/vt-d: Fix RID2PASID setup failure
Thread-Index: AQHYhH7LXPufoGLZlE+CLUNrmpMHyq1ZKuMwgAANHACAAADskIAADMMAgAAVB6A=
Date:   Tue, 21 Jun 2022 05:48:18 +0000
Message-ID: <BN9PR11MB5276A8B4E2466BE080CA9E9B8CB39@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220620081729.4610-1-baolu.lu@linux.intel.com>
 <BN9PR11MB52764F60972DF52EEF945D408CB39@BN9PR11MB5276.namprd11.prod.outlook.com>
 <5d13cab5-1f0a-51c7-78a3-fb5d3d793ab1@linux.intel.com>
 <BN9PR11MB527671B3B4C1F786E40D67408CB39@BN9PR11MB5276.namprd11.prod.outlook.com>
 <80457871-a760-69ba-70be-5e95344182ea@linux.intel.com>
In-Reply-To: <80457871-a760-69ba-70be-5e95344182ea@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2a5cda8d-d2d9-4f0e-0273-08da5349a4a9
x-ms-traffictypediagnostic: DM6PR11MB2729:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <DM6PR11MB27294DCFFC327507BFFC49D68CB39@DM6PR11MB2729.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jqLVBXXJsp0h5bwx/qmrfIFvZFPvRQXFQUkKHG64jncCWf3J8iZa9h5UWDupSHWxv2UV/0CljS0sfkpcsfzwBti+xCUSp1C7oD+oXsuDY7iXEAnnH4elI56xt6B90a5TkaO9XfWD1i7fnL89H9lRj4JIyQHHu0oB8eiMJuRhqls7Sbf3fs0QsInjZfjei5IXF3lX7+MAoeJgp9hTDAaee9TipeLEPkozl3WkijNxXCZpg/GyWelFlnyeDAmSYI1EqM8JhlCTBM2MXj5y/Eb9tj/OPjiD2Xk7WgXluHxfOjmKW7PIn6ZC4h8b6SFt3rW2UD1FFQJfVZhjfOPGHkTWZ5xMCnQhCtToI/hBb4p1U99WbnioZaBFm+A1fS6PVmLwbOZQEioybW5utnqo0848tQFKiYvk4KuT4tLF9AAoBQCPUlmOcMb7wudjVBY3RJmU2wzClTBGsSQ0pkyhHjAKmA5Gj9nMma5DLlgIlQcGOCfa9KvzYynMuJtG64HL84uGd46sMyFggRBQPSvqT9GV9e6fDCAj/+XzXkHuDBnejgQ+IGLJKmkino2VO9t1jQxWcHSWSfrEv78b9Vw6w2HenlSYTAUud6sKptk/pVAMQVfiqWAY0olO39CzdgYSIbXdbtsxFOczbkh3o64kQc1ysXt5ELp1BZzne5j8YQU5HovYiS+0F+p2PDnfDxVbRYmpvZcu8mAL+LWKiAb4tEmnwg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(376002)(346002)(39860400002)(136003)(396003)(52536014)(76116006)(478600001)(8936002)(66446008)(33656002)(64756008)(71200400001)(5660300002)(66556008)(4326008)(8676002)(316002)(110136005)(54906003)(66476007)(6636002)(66946007)(55016003)(2906002)(82960400001)(26005)(6506007)(86362001)(38100700002)(9686003)(38070700005)(186003)(83380400001)(53546011)(41300700001)(7696005)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VElTakVKUGppbGt1Vkw1MnlEdGk1Qk10eVJZRVM1dGI3dzJVTVpkeVNLWFJa?=
 =?utf-8?B?WE5CTVZEYisyRGtYQ0krT1JDblh2Y24ydEM0b25NNHpWREhvOXhxaFVUYVo5?=
 =?utf-8?B?S080a0p4TStnZzFiSlJLcWpjT2luMmtEeHZSaDBtREo1UllpWVgyTVVQZ0pz?=
 =?utf-8?B?RytmYVJQM0MxYm5EaUpoRG5vRDNiNlBzUHhBRVIxMjYvSmhhRjRPaU9UWlRU?=
 =?utf-8?B?WlpLNll1UGUrNzlWckRCU09jK0kxck1DVE83cGNwcGpPTlluN0h2ZmltTWtp?=
 =?utf-8?B?V2I4MG5HSG4vUXNVbEFFZnQyeUk0bjVHQ1hBekRuY1NIUmZzQ2l0Qk9McGJQ?=
 =?utf-8?B?MHhOUnlIT2QrblYzUVBad3lsUVN6Y2pMT3EzbmYzdHFyVTJNWllRMTN1eDBz?=
 =?utf-8?B?d3ptdkxmck1xbEpnN0RZQzVBNFI0clRjM0ZQSXlFaTkyMEJVL2lKSGZ0NmFJ?=
 =?utf-8?B?VXR1eXY5Q2s1SDMyQThyL015RExYQVg3WUJNdkFTMm9kNTQ3ejk5bEdVcU1V?=
 =?utf-8?B?dUNCbnkvMVJ1aFZjSUh4SzJMNFU4QXkxdjFTdExrNnhWd2hLcWpYdDZOZk00?=
 =?utf-8?B?WmZibzBBcmw2bFYxd25JVW1xUDZWRkxSZ1U1TlNxK3hMdHNKMHlyaGZLMW5G?=
 =?utf-8?B?TnZMYm54UmVya0xLcGlKTy9nN0VpUkh1MHUyTVk5bUcwNGhON2dXVm9NSlNH?=
 =?utf-8?B?N3ptdjZ2UThDQitqMzk5MndtM2JpZkZIbXdHSnVVTkk1eWo1UmFDbG50YUxt?=
 =?utf-8?B?dWRNaHVRUHlCbFA4WXRYbWVsK0FlbHFMcXNUNlBxNmROV1Y0MFFFd0h3V25s?=
 =?utf-8?B?b0p3eUVEZ3phNGRqaElHZzI0Y3JtT005Mi9DdlhSL1Zteld4TkdCUk1DV3Bu?=
 =?utf-8?B?Vlp3cERsMEhZekZDSHRobFVRalZ1dzNpL1JpUWdqN1BucUJ4TEg0RVQzSTNq?=
 =?utf-8?B?QmR3ck5GaWtXNjRPSU1ma2htRFQvTkpuMWV0M21Eb2huamtQOFJ0OCtUVnYx?=
 =?utf-8?B?TE1FNGd1QTBBWjZwRVh3dmRDWUpYbnphWXhmcjBMN3ZxdlVXaXMwM29GKzll?=
 =?utf-8?B?dVR0RWwxYVJPaUMwcEQ3UFk3QkZUam5VRXFnOGl1Zm9xLzZZNmpxZkhzcTVj?=
 =?utf-8?B?dEY3eDJ2bjBDOU91cEE1L3k2ZXhnSXlnRnB5ZFNNWWVDSllXSGRDME9Id2Y0?=
 =?utf-8?B?ckVKcWZGTlZmc3h6UHBqUjZZcy9HMi9TcUxMTFpqUlpTUFhqWTZtM2lFajNh?=
 =?utf-8?B?R09MNzFBNkVPVERFM0Y3Y3h2UGF6NjR3NTh0Vmh6bnZmaEZQTU50b2MvUmp3?=
 =?utf-8?B?YzFOamJxQkRxQkd5WDY4eDRKemw0SjlNVm1ramg4dzVaZFBOY1BhM1k2OS94?=
 =?utf-8?B?c1ZQL0hnN0JSeTl3cGJ5U2NKWXZIK2pmd0dIWDZiZ0pOOU4wTHg0cG5wY0xn?=
 =?utf-8?B?MjZLc3lCSjNjbVQrTkI3bTNkNXE5b0FNNTRmTkFVU1pJcFFBQktnY0pSZHZi?=
 =?utf-8?B?cXZTSFdvbnUvWklpbWE1WWYzSHJlUDdndGpTV0hXL05vc1M1N2JOWlVIRit4?=
 =?utf-8?B?ZEkzT0oxUDBZZ0NSUW92QTJLOHFKNUFua0ltTWVoUUlzNFZKanFNN1B3Ymxt?=
 =?utf-8?B?VjExd0ZsVndiemNNZ1lvZzQwQXBhQ0VZUVVsTTBvZy9kbnFUeEZvTW12VFc4?=
 =?utf-8?B?WmpOMVM2dGFLYTlIZFZpTWVsaUtGeXlMSDJIcjNqdHJOZi85L0tyM1F2aE9N?=
 =?utf-8?B?WXYrTXpRNU0wdnZIRHZGRGVadHR5N3cwVEQrUEpYRDExcDh3b2FrZFo2NDhX?=
 =?utf-8?B?WFNIMjd4M3FMKzhPRDAwN2NiQWRNVitydWlnTHltL1c1c1VMekJxeTlQUHl2?=
 =?utf-8?B?eFIrZ2t5OUtGZG1MVHJJVkpES1BFbXhBek5XSkRoVWc3TzdoOFQzMGYzTFpy?=
 =?utf-8?B?Q0FCOUd2S2NSRGpqaCtNK0NMK09KbnErcWdtQlNEcGJSK1hkcGE3a0VQWSsy?=
 =?utf-8?B?RVphOVAvMEcvWERrWVRGV3k1ay9DeTBRMEwxRnU4Vm41bmtPUk13Z2g4OUF6?=
 =?utf-8?B?Mm44d0xMUjJPUnVlR0c2Z2FpVlJqYmN4TjRpcXFSa0tNUEk4LzJQNU5kT290?=
 =?utf-8?B?RFc3NjVkWGxya3piaHJnUE5YRjcxWEpWbnAySC94OU1ISzlaMElraFVWTVg0?=
 =?utf-8?B?YVdNVVA4TnFVRHpsUDdqSEhnSDhYbjVxR1dDdXNNdVBnRVpJME5JYTJ0N2ti?=
 =?utf-8?B?bFVNOHdFMzNZVkJON1lLYnpjejNaZ2xnd2IveW9qQ1M3TEJ0Z0N5b2JPVDVj?=
 =?utf-8?B?SWJQbHhFZFJWU0FWaVpSRVN3NWRydVRILzExZ1Fqc1Q3dHV4NHJsQT09?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a5cda8d-d2d9-4f0e-0273-08da5349a4a9
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jun 2022 05:48:18.6291
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: moyecT9DoHeTXvuBTQdcTTif3Ymx0JNuUtLZeAFDeOGTX4Ge9yLrR92xd0A4/xSA7zKT7BKLb2f7cHojwfDGmg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB2729
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

PiBGcm9tOiBCYW9sdSBMdSA8YmFvbHUubHVAbGludXguaW50ZWwuY29tPg0KPiBTZW50OiBUdWVz
ZGF5LCBKdW5lIDIxLCAyMDIyIDEyOjI4IFBNDQo+IA0KPiBPbiAyMDIyLzYvMjEgMTE6NDYsIFRp
YW4sIEtldmluIHdyb3RlOg0KPiA+PiBGcm9tOiBCYW9sdSBMdSA8YmFvbHUubHVAbGludXguaW50
ZWwuY29tPg0KPiA+PiBTZW50OiBUdWVzZGF5LCBKdW5lIDIxLCAyMDIyIDExOjM5IEFNDQo+ID4+
DQo+ID4+IE9uIDIwMjIvNi8yMSAxMDo1NCwgVGlhbiwgS2V2aW4gd3JvdGU6DQo+ID4+Pj4gRnJv
bTogTHUgQmFvbHUgPGJhb2x1Lmx1QGxpbnV4LmludGVsLmNvbT4NCj4gPj4+PiBTZW50OiBNb25k
YXksIEp1bmUgMjAsIDIwMjIgNDoxNyBQTQ0KPiA+Pj4+IEBAIC0yNTY0LDcgKzI1NjQsNyBAQCBz
dGF0aWMgaW50IGRvbWFpbl9hZGRfZGV2X2luZm8oc3RydWN0DQo+ID4+Pj4gZG1hcl9kb21haW4g
KmRvbWFpbiwgc3RydWN0IGRldmljZSAqZGV2KQ0KPiA+Pj4+ICAgIAkJCXJldCA9IGludGVsX3Bh
c2lkX3NldHVwX3NlY29uZF9sZXZlbChpb21tdSwNCj4gPj4+PiBkb21haW4sDQo+ID4+Pj4gICAg
CQkJCQlkZXYsIFBBU0lEX1JJRDJQQVNJRCk7DQo+ID4+Pj4gICAgCQlzcGluX3VubG9ja19pcnFy
ZXN0b3JlKCZpb21tdS0+bG9jaywgZmxhZ3MpOw0KPiA+Pj4+IC0JCWlmIChyZXQpIHsNCj4gPj4+
PiArCQlpZiAocmV0ICYmIHJldCAhPSAtRUJVU1kpIHsNCj4gPj4+PiAgICAJCQlkZXZfZXJyKGRl
diwgIlNldHVwIFJJRDJQQVNJRCBmYWlsZWRcbiIpOw0KPiA+Pj4+ICAgIAkJCWRtYXJfcmVtb3Zl
X29uZV9kZXZfaW5mbyhkZXYpOw0KPiA+Pj4+ICAgIAkJCXJldHVybiByZXQ7DQo+ID4+Pj4gLS0N
Cj4gPj4+PiAyLjI1LjENCj4gPj4+DQo+ID4+PiBJdCdzIGNsZWFuZXIgdG8gYXZvaWQgdGhpcyBl
cnJvciBhdCB0aGUgZmlyc3QgcGxhY2UsIGkuZS4gb25seSBkbyB0aGUNCj4gPj4+IHNldHVwIHdo
ZW4gdGhlIGZpcnN0IGRldmljZSBpcyBhdHRhY2hlZCB0byB0aGUgcGFzaWQgdGFibGUuDQo+ID4+
DQo+ID4+IFRoZSBsb2dpYyB0aGF0IGlkZW50aWZpZXMgdGhlIGZpcnN0IGRldmljZSBtaWdodCBp
bnRyb2R1Y2UgYWRkaXRpb25hbA0KPiA+PiB1bm5lY2Vzc2FyeSBjb21wbGV4aXR5LiBEZXZpY2Vz
IHRoYXQgc2hhcmUgYSBwYXNpZCB0YWJsZSBhcmUgcmFyZS4gSQ0KPiA+PiBldmVuIHByZWZlciB0
byBnaXZlIHVwIHNoYXJpbmcgdGFibGVzIHNvIHRoYXQgdGhlIGNvZGUgY2FuIGJlDQo+ID4+IHNp
bXBsZXIuOi0pDQo+ID4+DQo+ID4NCj4gPiBJdCdzIG5vdCB0aGF0IGNvbXBsZXggaWYgeW91IHNp
bXBseSBtb3ZlIGRldmljZV9hdHRhY2hfcGFzaWRfdGFibGUoKQ0KPiA+IG91dCBvZiBpbnRlbF9w
YXNpZF9hbGxvY190YWJsZSgpLiBUaGVuIGRvIHRoZSBzZXR1cCBpZg0KPiA+IGxpc3RfZW1wdHko
JnBhc2lkX3RhYmxlLT5kZXYpIGFuZCB0aGVuIGF0dGFjaCBkZXZpY2UgdG8gdGhlDQo+ID4gcGFz
aWQgdGFibGUgaW4gZG9tYWluX2FkZF9kZXZfaW5mbygpLg0KPiANCj4gVGhlIHBhc2lkIHRhYmxl
IGlzIHBhcnQgb2YgdGhlIGRldmljZSwgaGVuY2UgYSBiZXR0ZXIgcGxhY2UgdG8NCj4gYWxsb2Nh
dGUvZnJlZSB0aGUgcGFzaWQgdGFibGUgaXMgaW4gdGhlIGRldmljZSBwcm9iZS9yZWxlYXNlIHBh
dGhzLg0KPiBUaGluZ3Mgd2lsbCBiZWNvbWUgbW9yZSBjb21wbGljYXRlZCBpZiB3ZSBjaGFuZ2Ug
cmVsYXRpb25zaGlwIGJldHdlZW4NCj4gZGV2aWNlIGFuZCBpdCdzIHBhc2lkIHRhYmxlIHdoZW4g
YXR0YWNoaW5nL2RldGFjaGluZyBhIGRvbWFpbi4gVGhhdCdzDQo+IHRoZSByZWFzb24gd2h5IEkg
dGhvdWdodCBpdCB3YXMgYWRkaXRpb25hbCBjb21wbGV4aXR5Lg0KPiANCg0KSWYgeW91IGRvIHdh
bnQgdG8gZm9sbG93IGN1cnJlbnQgcm91dGUgaXTigJlzIHN0aWxsIGNsZWFuZXIgdG8gY2hlY2sN
CndoZXRoZXIgdGhlIHBhc2lkIGVudHJ5IGhhcyBwb2ludGVkIHRvIHRoZSBkb21haW4gaW4gdGhl
IGluZGl2aWR1YWwNCnNldHVwIGZ1bmN0aW9uIGluc3RlYWQgb2YgYmxpbmRseSByZXR1cm5pbmcg
LUVCVVNZIGFuZCB0aGVuIGlnbm9yaW5nDQppdCBldmVuIGlmIGEgcmVhbCBidXN5IGNvbmRpdGlv
biBvY2N1cnMuIFRoZSBzZXR1cCBmdW5jdGlvbnMgY2FuDQpqdXN0IHJldHVybiB6ZXJvIGZvciB0
aGlzIGJlbmlnbiBhbGlhcyBjYXNlLg0K
