Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CE0368B49B
	for <lists+stable@lfdr.de>; Mon,  6 Feb 2023 04:49:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229519AbjBFDtB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Feb 2023 22:49:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbjBFDtA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Feb 2023 22:49:00 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 220422D5E;
        Sun,  5 Feb 2023 19:48:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675655338; x=1707191338;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ngtmxOlbizvZRuFyxs527cat4GQADPpDHMm1guXz+sM=;
  b=YXx3iObFybJwNBOrpPRvfwRJQ7luTnCXrAmRI0bv79iNbriGTpTYuxzC
   oBdIcsPRc1XqjS147X3tH0JSMGBdG805VjsXIwntIuO6DgaeaedtKXsNx
   zBwRMdF3PmLLDn2pornjxcmpVG1IQoY2TdXRRvrQ5oyaPgJuhGGhzIM3y
   8ouyL0L/cRel1FBavRQffKchSwry9mOoQhPNCxAUaCafH9Ijs3vRcDLyI
   3KFAGyc0iY6u2bLgl1xEwMH5owoRcqPxCFRIzaoHAgwcygfVCGQ61s1+R
   KpLXCM7RdcbFOUJBnJuMBxozSSs+k9evv1wMXoz3lMGWDzv9m1at6PCyR
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10612"; a="391521327"
X-IronPort-AV: E=Sophos;i="5.97,276,1669104000"; 
   d="scan'208";a="391521327"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2023 19:48:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10612"; a="643880270"
X-IronPort-AV: E=Sophos;i="5.97,276,1669104000"; 
   d="scan'208";a="643880270"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga006.jf.intel.com with ESMTP; 05 Feb 2023 19:48:55 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Sun, 5 Feb 2023 19:48:55 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Sun, 5 Feb 2023 19:48:54 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Sun, 5 Feb 2023 19:48:54 -0800
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.44) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Sun, 5 Feb 2023 19:48:54 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qzm3T2RWZ5MPF1u5aqIyVMe98yxC6pxBMP6hn5bQzMqDzltVWlP9sRq2w/cF05UIdbFP10R8oHBPujMt/WHBzL9HdV5sGPTjjKL8Js8IHUaiYeupR9V6J4KlUPfnfzgbbClSCOlsWGKwcLyx4SnczbAEQFODNSENI5bycGZKupwt2uOG+KjM9PcL7BX2DMhrYT9Q70JjNXIxb7B0SIHr4HdaWltNIfuXiZwvKSDH7SMrWpGu/8BN6LEl6Vevc/mkXKN04DIL316/TUJs3ubKrO6XbdZN/o25C5tPlr2+8btYzp+fN0tqL8kJl3ADF62NpcsDNvaGgkJp9O397vu/vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ngtmxOlbizvZRuFyxs527cat4GQADPpDHMm1guXz+sM=;
 b=EzTclYZfG9CRiuOakdYTGyTgsU+dTbSc0p7ny5qtge2KKYPP3VyzMOI+x2fshMNJohecVjluawJV+Iq7HDujfZH1amhRvw4kolYRvnTZrTttBGELkyDfgCfkzLXUeF9CkuArxNgCat63BXm8n20I/QlTx3/2b0etyrOJuKC7X+uPP21tu7pjfLtUpxEeq7r/n6ivLOFk9OL1Jtjc2SlK9d97W32/mgrlYHVXAh9Q8QBMq4KXok1y2K6evWus9My0WwmAfzyWcyX/5TYfSiY/Je6pH26JPSEZc9IhewqtkfEl83CKyhU0xkPq7G0RQ+hJGtRmAE6m0w35qidirbiDMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by MN0PR11MB6158.namprd11.prod.outlook.com (2603:10b6:208:3ca::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Mon, 6 Feb
 2023 03:48:53 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d%8]) with mapi id 15.20.6064.034; Mon, 6 Feb 2023
 03:48:52 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Baolu Lu <baolu.lu@linux.intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        Joerg Roedel <joro@8bytes.org>
CC:     David Woodhouse <dwmw2@infradead.org>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Kumar, Sanjay K" <sanjay.k.kumar@intel.com>,
        "Robin Murphy" <robin.murphy@arm.com>
Subject: RE: [PATCH] iommu/vt-d: Avoid superfluous IOTLB tracking in lazy mode
Thread-Topic: [PATCH] iommu/vt-d: Avoid superfluous IOTLB tracking in lazy
 mode
Thread-Index: AQHZOCNd6z7weBkJP0K7ycd3Ms6uFq6+VIgAgAL1GUA=
Date:   Mon, 6 Feb 2023 03:48:52 +0000
Message-ID: <BN9PR11MB52764498929E4978B3A8740D8CDA9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230203230417.1287325-1-jacob.jun.pan@linux.intel.com>
 <ef65f1cf-d04c-8c35-7144-d30504bf7a1c@linux.intel.com>
In-Reply-To: <ef65f1cf-d04c-8c35-7144-d30504bf7a1c@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|MN0PR11MB6158:EE_
x-ms-office365-filtering-correlation-id: 33acb7a3-b4ad-4818-1fb5-08db07f51063
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /GVI3KCWR2FKB3Wdx0LRGTIdGYv8PE3Yu+iODhpM0pZd0kkqZqgE4MY48nQalCZKupk0fonxkZAkKVVbr45x/4zbJvoaMHaMPHLtrFywS868OwWYr8TNGS+XBmKfgzWJSwMmIBZR/9Aa7S0CXi/ugUI+LoPgPaaSUdsUcUwlCXXjfL0v5jeyvUJLLpege7QNJ+EPZN07XVF1oFwB2e0RWDPlfu5YXjrvcKTnQoGmMbChb2YGr817Lh2Ad9cmKL5ovJBgkOzexGOJ1DPwq+gpoQkS722jXcgc4GV1LNrgQ2J5qlKYgYcfa/duphFjDUevXhO835pcHJn1DodbkuAN+pwa1Biq5Hbjn5tPeGzTCxZkXKhixgQ21e9yK4AjwAN5SJdcpNVPN2H2W8IGBJYDCIxwyCL9Ie6R7TkoruS6MEkq4gGIhEqpWWlySne0cxGR+6NdqO5MCrX53JF3zjPRH1pKabCPDHJEPOf2gHDE+YLeLS/N8RXOrnA4EYHlvWGD8DYd5RJTwDhl7JdPxnqiCXlfJNS1OXp2ngFwVZvDpUo7UDyxQflfbkg/7vwPz739YGtVf9fgipJGGK9zb9PiWzRPelPDrR2B3HT4o0JXjhl6N4w0+5GJWExGQaN4D9MGrfmHPSq/ZOnkq1oQUNL+2z1IKRr+0nhzS9BXX1CFXDXf7Oz040484DSFn+L2TseW4bHARvwaOP2zQzvxFYWmjQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(346002)(376002)(136003)(39860400002)(366004)(451199018)(38070700005)(83380400001)(82960400001)(38100700002)(122000001)(55016003)(66476007)(66556008)(64756008)(8936002)(41300700001)(66446008)(76116006)(66946007)(8676002)(4326008)(2906002)(5660300002)(52536014)(6506007)(53546011)(186003)(9686003)(26005)(71200400001)(54906003)(110136005)(316002)(478600001)(7696005)(86362001)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UUFKQnJxdVlUcUJUdU5HemxWbHMrS0pvY1Rmc1llckg2elNENmtXRXpnK1Bh?=
 =?utf-8?B?YTBNWkJPUG9iT0hXL2pvVXRwVzZJdDZOZ09Gcmd5TEVYdDgwdmRFd1JsT0JO?=
 =?utf-8?B?MTRHVjhldnJncmZuLzIvY2E0Qm95TkxjQ1FTQkJSS2pPM2VLVEd4SXorZVR2?=
 =?utf-8?B?ZTRZL2pMT0krT3c2TjhobnUvL002VUxYZ1phY2JJNjVqdk5vMWlNTENHcDFx?=
 =?utf-8?B?T2hLRlV0eUtZVzY0ZGU2aGxTUEVNdjcyOTFHV3MxSkVuVTU5bDFPSXBBRE01?=
 =?utf-8?B?cktrYlN6SlExTFZUSGZiSWx5cmVnaFlTTXJOekQ4OUZ6ZTJwUkZOUlRUUGxY?=
 =?utf-8?B?U3A0c0EyeHFtc3BWTE9rTzIzd1hhY2FNa3lvMFE2SVc0bmdxNUkwaVgzWk05?=
 =?utf-8?B?N25JeDNFOFhXa0ZWSmVSWUc5T3NCNklJZmJxU1VsR2hIVGxYVEZGT2grQjg1?=
 =?utf-8?B?QlJKSVEvSlpxMFBIdVZZcVNzQ0pMV09BUW85ZVVzZU1lL1BML3Z1MTFnU3Rl?=
 =?utf-8?B?a3dab2ZHcjlaT29iS251VFkzMXdvV24rS1o5T3RmY0I5dmJGeEZNWVliUCt6?=
 =?utf-8?B?cE1sMktzaEU5dkpNUUhCMnZ0dmpBeXl0MGROeUpFUWE4d0NYSnZMOEwxUnBO?=
 =?utf-8?B?VDMybGxIOW5jR0NzSHRvQ2RwaStlMENzVWc5SVBBaUFQbFo2dzFLUXpCVlR0?=
 =?utf-8?B?eWJXVXZodThLbHh3dWd2UVRQdGhwbFVhWVhrZjZ1UkxuS0pNQVVSODdkYXZJ?=
 =?utf-8?B?bjdENWZ6SnJTenY4SmUzdDYyc2txTVVGa0JpTDJqdmZOU1MrbUJYb1lqa0xZ?=
 =?utf-8?B?VjdGemlKR3RNQXZQdk56ZWd1QklvYXl5SFNZTGhPTnZlSEpkalNtdkdNaXFa?=
 =?utf-8?B?NUFoL0svdjNKYk9CbnBpMzA1d2VRb1ZkU2F1Sll0eUtXWGtYd0FHL0Ixa1ox?=
 =?utf-8?B?alRaUDFFaDA3MnphMG9QWmN3b00yVG8rb0UvMHhSKzZheGJva0RjRzZJejB3?=
 =?utf-8?B?WmY2dUZHNllQSURUWmMvWHJsc2ZCclBwRnJYaGhwQ0EvZXZNTEh1SUtwRFFT?=
 =?utf-8?B?dWVEemk1QWI0OFhYMW1KNndNL2hHMGtFbkN3VzFCM2hhR3I0amlIWDBXejh5?=
 =?utf-8?B?bVR3UjZSeWEvSlRSbXUzd2U3SVlrWFVKUFFIRDRYMjZBeVgveHpneE5ibzEr?=
 =?utf-8?B?djdram5DWUFnRFdKd3gyWU1tR0FTU0FERlMxWVVCSUZnZHo1eGVvdFpza3pB?=
 =?utf-8?B?aXhydVIxTWpMaXlsQkN3dm9LSVBjN2YwSDluTkZXU1hQQ3lMOGE2RXFab2ps?=
 =?utf-8?B?cHhWaFgxMGtWQnVxWlg2QmFxZXFIRGphbklPTzh5UC9QYTB0alkyeEppNy9X?=
 =?utf-8?B?c3hLcDlTYXRvclRtYXE2aTZGL1VvUXlDZ3ZVdVhnMlFOS2twU3ZjUzUrQ2RZ?=
 =?utf-8?B?TDB4d0Zid1EvNTBGOVExQTV0MG9JUWQwWkZxVU90N1hMV1NRamxyYlRPZllH?=
 =?utf-8?B?ZmpFejdndnhEQTZJZWZXaGkxYTlwaENvRHBTWHE3TE1rV1hHZVBBVWFDRmhG?=
 =?utf-8?B?b1MzUGJUbTI4ZkloOTJsMW1ReVVVcUlEU01yVU5CcEowN2oxY3FPY1RFZ1k4?=
 =?utf-8?B?N0JxQmVONzVVelZ4Tnl5b29UNnUyeVNRWDhiWXdkMmZRZUE4aktwL1J6ZUsx?=
 =?utf-8?B?cmpESnRQdHNzcGIzc0VSTDVBRFJjWHp2dS9OcEh2QzliUEhKcXA2M0hjdS9n?=
 =?utf-8?B?ekR3SVRtN2c2dXJRZlJSSVRrMEpxT3Jucm1LS2RCZUV1WXIrSHI2NXgwbEU0?=
 =?utf-8?B?SUVDNEo5SWVpVGdIME5UZC9GUGo4QzdMZWxTZVVNQTJJenZmTHFJbUtkL3hP?=
 =?utf-8?B?YXJrL1QxeGd2NU55SEJPczJaU3UrYXBQb3E1TWt1bW1GbzZ5aDlTQ2xxT3hC?=
 =?utf-8?B?S0NMQkkxSVduVlV2MXlaVndKSmpLdFR0SlR5MGRqTXlweTBvY0lUc3VnaVAw?=
 =?utf-8?B?Vy9WWEhlUTVZZDBnRXQ0L3NqbkVyMDNXZm5lc3NocXVoTFgzVUo3RnRIYmE2?=
 =?utf-8?B?MU9oTS90UzBjNHYyb2RYVGJHNlF3VllDUTBZTElEWnlGNnhQODIrOGpPL1lO?=
 =?utf-8?Q?YzAug7gvK7LfqXzyhSWtjs8Ca?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33acb7a3-b4ad-4818-1fb5-08db07f51063
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Feb 2023 03:48:52.6214
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LH+eTjjzp21MFhhgb/RPWc7fA8wM6RR27Cve95tNidlkc2TaKXovy+FMJXglRmvJq6wQFGK7yzv0jJS0bBRN8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6158
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

PiBGcm9tOiBCYW9sdSBMdSA8YmFvbHUubHVAbGludXguaW50ZWwuY29tPg0KPiBTZW50OiBTYXR1
cmRheSwgRmVicnVhcnkgNCwgMjAyMyAyOjMyIFBNDQo+IA0KPiBPbiAyMDIzLzIvNCA3OjA0LCBK
YWNvYiBQYW4gd3JvdGU6DQo+ID4gSW50ZWwgSU9NTVUgZHJpdmVyIGltcGxlbWVudHMgSU9UTEIg
Zmx1c2ggcXVldWUgd2l0aCBkb21haW4gc2VsZWN0aXZlDQo+ID4gb3IgUEFTSUQgc2VsZWN0aXZl
IGludmFsaWRhdGlvbnMuIEluIHRoaXMgY2FzZSB0aGVyZSdzIG5vIG5lZWQgdG8gdHJhY2sNCj4g
PiBJT1ZBIHBhZ2UgcmFuZ2UgYW5kIHN5bmMgSU9UTEJzLCB3aGljaCBtYXkgY2F1c2Ugc2lnbmlm
aWNhbnQNCj4gcGVyZm9ybWFuY2UNCj4gPiBoaXQuDQo+IA0KPiBbQWRkIGNjIFJvYmluXQ0KPiAN
Cj4gSWYgSSB1bmRlcnN0YW5kIHRoaXMgcGF0Y2ggY29ycmVjdGx5LCB0aGlzIG1pZ2h0IGJlIGNh
dXNlZCBieSBiZWxvdw0KPiBoZWxwZXI6DQo+IA0KPiAvKioNCj4gICAqIGlvbW11X2lvdGxiX2dh
dGhlcl9hZGRfcGFnZSAtIEdhdGhlciBmb3IgcGFnZS1iYXNlZCBUTEIgaW52YWxpZGF0aW9uDQo+
ICAgKiBAZG9tYWluOiBJT01NVSBkb21haW4gdG8gYmUgaW52YWxpZGF0ZWQNCj4gICAqIEBnYXRo
ZXI6IFRMQiBnYXRoZXIgZGF0YQ0KPiAgICogQGlvdmE6IHN0YXJ0IG9mIHBhZ2UgdG8gaW52YWxp
ZGF0ZQ0KPiAgICogQHNpemU6IHNpemUgb2YgcGFnZSB0byBpbnZhbGlkYXRlDQo+ICAgKg0KPiAg
ICogSGVscGVyIGZvciBJT01NVSBkcml2ZXJzIHRvIGJ1aWxkIGludmFsaWRhdGlvbiBjb21tYW5k
cyBiYXNlZCBvbg0KPiBpbmRpdmlkdWFsDQo+ICAgKiBwYWdlcywgb3Igd2l0aCBwYWdlIHNpemUv
dGFibGUgbGV2ZWwgaGludHMgd2hpY2ggY2Fubm90IGJlIGdhdGhlcmVkDQo+IGlmIHRoZXkNCj4g
ICAqIGRpZmZlci4NCj4gICAqLw0KPiBzdGF0aWMgaW5saW5lIHZvaWQgaW9tbXVfaW90bGJfZ2F0
aGVyX2FkZF9wYWdlKHN0cnVjdCBpb21tdV9kb21haW4NCj4gKmRvbWFpbiwNCj4gICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgc3RydWN0DQo+IGlvbW11X2lv
dGxiX2dhdGhlciAqZ2F0aGVyLA0KPiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICB1bnNpZ25lZCBsb25nIGlvdmEsDQo+IHNpemVfdCBzaXplKQ0KPiB7DQo+
ICAgICAgICAgIC8qDQo+ICAgICAgICAgICAqIElmIHRoZSBuZXcgcGFnZSBpcyBkaXNqb2ludCBm
cm9tIHRoZSBjdXJyZW50IHJhbmdlIG9yIGlzDQo+IG1hcHBlZCBhdA0KPiAgICAgICAgICAgKiBh
IGRpZmZlcmVudCBncmFudWxhcml0eSwgdGhlbiBzeW5jIHRoZSBUTEIgc28gdGhhdCB0aGUgZ2F0
aGVyDQo+ICAgICAgICAgICAqIHN0cnVjdHVyZSBjYW4gYmUgcmV3cml0dGVuLg0KPiAgICAgICAg
ICAgKi8NCj4gICAgICAgICAgaWYgKChnYXRoZXItPnBnc2l6ZSAmJiBnYXRoZXItPnBnc2l6ZSAh
PSBzaXplKSB8fA0KPiAgICAgICAgICAgICAgaW9tbXVfaW90bGJfZ2F0aGVyX2lzX2Rpc2pvaW50
KGdhdGhlciwgaW92YSwgc2l6ZSkpDQo+ICAgICAgICAgICAgICAgICAgaW9tbXVfaW90bGJfc3lu
Yyhkb21haW4sIGdhdGhlcik7DQo+IA0KPiAgICAgICAgICBnYXRoZXItPnBnc2l6ZSA9IHNpemU7
DQo+ICAgICAgICAgIGlvbW11X2lvdGxiX2dhdGhlcl9hZGRfcmFuZ2UoZ2F0aGVyLCBpb3ZhLCBz
aXplKTsNCj4gfQ0KPiANCj4gQXMgdGhlIGNvbW1lbnRzIGZvciBpb21tdV9pb3RsYl9nYXRoZXJf
aXNfZGlzam9pbnQoKSBzYXlzLA0KPiANCj4gIi4uLkZvciBtYW55IElPTU1VcywgZmx1c2hpbmcg
dGhlIElPTU1VIGluIHRoaXMgY2FzZSBpcyBiZXR0ZXINCj4gICB0aGFuIG1lcmdpbmcgdGhlIHR3
bywgd2hpY2ggbWlnaHQgbGVhZCB0byB1bm5lY2Vzc2FyeSBpbnZhbGlkYXRpb25zLg0KPiAgIC4u
LiINCj4gDQo+IFNvLCBwZXJoYXBzIHRoZSByaWdodCBmaXggZm9yIHRoaXMgcGVyZm9ybWFuY2Ug
aXNzdWUgaXMgdG8gYWRkDQo+IA0KPiAJaWYgKCFnYXRoZXItPnF1ZXVlZCkNCj4gDQo+IGluIGlv
bW11X2lvdGxiX2dhdGhlcl9hZGRfcGFnZSgpIG9yIGlvbW11X2lvdGxiX2dhdGhlcl9pc19kaXNq
b2ludCgpPw0KPiBJdCBzaG91bGQgYmVuZWZpdCBvdGhlciBhcmNoJ3MgYXMgd2VsbC4NCj4gDQoN
ClRoZXJlIGFyZSBvbmx5IHR3byBjYWxsZXJzIG9mIHRoaXMgaGVscGVyOiBpbnRlbCBhbmQgYXJt
LXNtbXUtdjMuDQoNCkxvb2tzIG90aGVyIGRyaXZlcnMganVzdCBpbXBsZW1lbnRzIGRpcmVjdCBm
bHVzaCB2aWEgaW9fcGd0YWJsZV90bGJfYWRkX3BhZ2UoKS4NCg0KYW5kIHRoZWlyIHVubWFwIGNh
bGxiYWNrIHR5cGljYWxseSBkb2VzOg0KDQppZiAoIWlvbW11X2lvdGxiX2dhdGhlcl9xdWV1ZWQo
Z2F0aGVyKSkNCglpb19wZ3RhYmxlX3RsYl9hZGRfcGFnZSgpOw0KDQpmcm9tIHRoaXMgYW5nbGUg
aXQncyBzYW1lIHBvbGljeSBhcyBKYWNvYidzIGRvZXMsIGkuZS4gaWYgaXQncyBhbHJlYWR5DQpx
dWV1ZWQgdGhlbiBubyBuZWVkIHRvIGZ1cnRoZXIgY2FsbCBvcHRpbWl6YXRpb24gZm9yIGRpcmVj
dCBmbHVzaC4NCg==
