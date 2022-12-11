Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 991B164932B
	for <lists+stable@lfdr.de>; Sun, 11 Dec 2022 09:31:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229777AbiLKIb4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Dec 2022 03:31:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiLKIby (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Dec 2022 03:31:54 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 610B71147A
        for <stable@vger.kernel.org>; Sun, 11 Dec 2022 00:31:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670747513; x=1702283513;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=wAnrxiMGX+3sG0S/t025YKvmVPn9o9SDaGC25xggqs8=;
  b=HwTcIND6TOizo7LyHrUtp3CnxBdj7PvAs5YiArvO/1FKGukmDlu2SzuZ
   IeBaGmtMwAP4UxS6wc/uWlLUDsIdIWmKamHmbk/6dwz6XunlHTxWqwZ6v
   usHNv5BHGF7BmC8la3jcyq9NmIn+dh+yNjhLje0Tz8xbysJ44DeJfIRFZ
   rYxs37xujJiSrNGM9cMydoPb/hfvmHksDQzhF9uVYSbRMXa1R9m6CQczB
   31PrurLqRzz/hYTeBSunMrXes97kHZlW37CM/HNnYESJ8FIRaFmAb6cSl
   yKmMcvHyHqmnyKq48skKQdTz4zClJj3i1RatLPINharJA4MMwSL3jJxBw
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10557"; a="379892646"
X-IronPort-AV: E=Sophos;i="5.96,235,1665471600"; 
   d="scan'208";a="379892646"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Dec 2022 00:31:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10557"; a="976709793"
X-IronPort-AV: E=Sophos;i="5.96,236,1665471600"; 
   d="scan'208";a="976709793"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga005.fm.intel.com with ESMTP; 11 Dec 2022 00:31:52 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Sun, 11 Dec 2022 00:31:51 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Sun, 11 Dec 2022 00:31:51 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Sun, 11 Dec 2022 00:31:51 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.175)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Sun, 11 Dec 2022 00:31:51 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JCpnHDu0Mwcqaq+wKSARH8Xn3UmTXWuvDrYuk2uNyFsjO7qUw1jri1wyhTho/6wKaUQA3S9RJeqdEMuzdPleJpfoHnWzhfIIaHrOu5K+D3WruevvlkXb5iTa/hEtBmgidrVEknGPhhqfw0GDy1u59+KKJE3F/r9JyqZkrZoVF7u01VajlKBhR9edd/gUY1oy5jnezGYuIwnmCOjD+GkJ4zWBd5OhfceLYRhfWCosWGnx7tDDKDnvbb38N2swoQqDP1azTueHCflfZn+xwuqUiFkDcFnUzmeuDkZM9k3OryRBv8AhjDCHgyGBZ+q7gk6d96MMbbTImVmmW5yF4P3cUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wAnrxiMGX+3sG0S/t025YKvmVPn9o9SDaGC25xggqs8=;
 b=fXBfrCIbdzHnF8dxS+Byxs88ZeZfh8VjSD2DKBKsQGIko/7D8+I9orRXuXaTYl7ouSU4XPGR5pOmufdQDzwlOV0w6ifhmg6blqQPbJkyaMr+g1HdgK0mxH0xRbS3xZl0XiIzn9doK3ddlYNSimzS1s3HMsQ9pHf0zv7i4DSFPII1VnbBa3xehwfTld8gJb5agnGKg1MLWVFUAvtde22BcWL6VXmqs0IKwhoiu5LzkHxVosufj0OErfDfpqyu1pRI5XqeEfR4HW7hC5YZl91D/uAbyaNzKh+L8pabEAin7x7AgiM/RnmW9qzKh6nJOTpbUiMZ1OG9vEVXRhVDm5mpMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW5PR11MB5857.namprd11.prod.outlook.com (2603:10b6:303:19d::17)
 by PH7PR11MB6979.namprd11.prod.outlook.com (2603:10b6:510:207::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Sun, 11 Dec
 2022 08:31:47 +0000
Received: from MW5PR11MB5857.namprd11.prod.outlook.com
 ([fe80::c2b4:f5ba:6fdd:7ea1]) by MW5PR11MB5857.namprd11.prod.outlook.com
 ([fe80::c2b4:f5ba:6fdd:7ea1%9]) with mapi id 15.20.5880.014; Sun, 11 Dec 2022
 08:31:47 +0000
From:   "Chen, Kane" <kane.chen@intel.com>
To:     Sasha Levin <sashal@kernel.org>,
        =?utf-8?B?TWF0ZXVzeiBKb8WEY3p5aw==?= <mat.jonczyk@o2.pl>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: RE: [PATCH v1] rtc: cmos: avoid UIP when writing/reading alarm time
Thread-Topic: [PATCH v1] rtc: cmos: avoid UIP when writing/reading alarm time
Thread-Index: AQHZDB9eT2K0cr4nhk+B3VxFMDO3aa5oNggAgAAZ0SA=
Date:   Sun, 11 Dec 2022 08:31:47 +0000
Message-ID: <MW5PR11MB58572FD62FFE1422B5968ECBE01E9@MW5PR11MB5857.namprd11.prod.outlook.com>
References: <20221207035722.15749-1-kane.chen@intel.com>
 <Y5Ag6YhxcPPbs4Jr@sashalap>
 <MW5PR11MB5857D26C66FA084280709384E01A9@MW5PR11MB5857.namprd11.prod.outlook.com>
 <70ee669e-9d35-4ff0-13b4-c72e2448a1f7@o2.pl> <Y5KDSGfpzk8AyQ4y@sashalap>
 <4f74e731-0dce-2234-f834-c46b54ec9a43@o2.pl> <Y5V0HpqcueAth01g@sashalap>
In-Reply-To: <Y5V0HpqcueAth01g@sashalap>
Accept-Language: en-US, zh-TW
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW5PR11MB5857:EE_|PH7PR11MB6979:EE_
x-ms-office365-filtering-correlation-id: fdd846a5-8d72-4f70-40ed-08dadb5224b1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5u1y0NtE1dVAyR21P2rvD9rk+O//TgEJfFogczEoHG0POWm4MvvXl+FswoNKQ7jvWIxm66Pkj8dwbBpr95/kdU0xSDfU8Ic3JM1+d6CCHykRa3k4M5Sl0RNZHNwShr5KDS2ChR04zE1CKdCKrquqWAHhCuvZBVrtD0FxbgfI8BTfWG9pRwGwIyWL02EKy6O4J4hVqAtyZap1i3bXe6jT2ATZLsM52uXJTPNQ+qp5DP389L+qLWC9c/onxEnMXGRHucK0aU4LBNX5VcaykT468Yb6EgavIt0ZarYT40yGyBZdmJbmYwHWQKS7vr4T1BKJ7c6bjQ/gnVFZi9NTr1k+cH6Rv/5z1ti3NPIsPJC8GYvRQ1B9F4KQh71rUAXbLnXe0yzTKTcnGC6lOinoIvtCCeUKiKwg91rqngLl0/8Io3qX0GMz5VcgOcssl0LA38edpQipgqDqVHoNeCfJmPjmQq/l3h8Fl+5j9Q3bmzmB70D3uA+IpqngYryYIcs4Omf+qFk1osdZcPEfKwfIDr6nlexiaiPyLI/F6EEjps2EEkGNhek9S+E+ytbcaL2d+//mtu8IgzTl0u8QBJzDZGJg5doBNhCFkLl1kP/uUXCKOCrUgXOcdWlbGWlNTFru9sFYyPuEKO33US0OprAhZXIe5BMgkvXjW6hpt4i1MMCGkkWmV87LLQs+QrdFoGsA92ZFtXQbJFb+a9rnQYFyR0RPvw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW5PR11MB5857.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(39860400002)(136003)(376002)(346002)(396003)(451199015)(82960400001)(2906002)(38100700002)(55016003)(122000001)(26005)(41300700001)(53546011)(7696005)(6506007)(86362001)(9686003)(316002)(52536014)(8936002)(54906003)(110136005)(76116006)(38070700005)(5660300002)(66946007)(66556008)(66476007)(66446008)(64756008)(4326008)(8676002)(478600001)(71200400001)(186003)(66574015)(83380400001)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TXlhRG54ek14UzMrTGx4NmhCaXpXOFFWUlhPcmZmODNaY2p1cnJrM052VlV0?=
 =?utf-8?B?Q0w5YWR4VVc4WHlqUGVCbVg5RWV4VlpldEhsUW1haFVRWlIwMDc5ZW9WbmF3?=
 =?utf-8?B?ZWpTQkt4Y3p2NERYK0RJWjc4VEd1OGYwTGd4blo2VnNnWTM5ZkdjSWkzUkc2?=
 =?utf-8?B?YWdNNUxGZW4xSHAwenc2d2djekliV3U0MG9panNHbFBlTXJZV0oyQkFRalpr?=
 =?utf-8?B?SG03amwvNCszcHo5d1NZWVM2cXJzY2I3YWlIUmhsVCtaejRlajNyZFVxVmZz?=
 =?utf-8?B?WG5yWGVYTlRPV3BlZVVhU0tBL1FhYll1U2d2S2I0elBQOGRUSmE1bHI2OU9x?=
 =?utf-8?B?Nmg4T0RWOEdRSjVLanlnY1p2UThLM2VCdm9xbDR3WXI4eGptS2EwRC9RUERk?=
 =?utf-8?B?STJUZEtIbjc3aHhRTjFxNUpEa2lCVjlOQzQwK2o4ZlJsQlFIbCtablc5Y3cw?=
 =?utf-8?B?aEdWbTlFVmszTDFiWFNrRTNXeG1SQUZ3WXYwSHVBOUNuR0xIMGNqOGtieGpZ?=
 =?utf-8?B?WTJBdDV1T0gzaXY5TE1jUWsrcFp2UGpCRys4Wk5vYmxFK1doOTNqTE84ODQw?=
 =?utf-8?B?NFZ3RlJnRXBCRTFFZ290cGdPSkpsd3VxNlo5M2tUTFJ4UWlZZHp6WW5NVlQw?=
 =?utf-8?B?MVdacmRXeEQwd2tIdXZnQ0RGWmRkbVl6cWIxYWMwWUJyN1BIUlFFZnppQWVL?=
 =?utf-8?B?WVRHZnZ2MWlZZW5iTUNqcSt4cWdGQmMraE5jSWhJQzFuQXI1c3lqQld2ZEdp?=
 =?utf-8?B?UEwvWDRIS2xIdHRhZGh1end6VzZJSjR1c2QrRGhUMDBsL1YxSlI5S1MweW50?=
 =?utf-8?B?Mm1HODhYdjNiYkVoWjZ1Qm53TzkvS1JKVVBJS3dITkozdmRBdGNDOVZJd1ow?=
 =?utf-8?B?blZOYm1za01qcnRHU1J5OU9nZVhSdGFyam9TeXQ2R0NGUnp5NjdpSHBFd0hH?=
 =?utf-8?B?b01qWXlNazRwWURJaDBBNEVNRFc2c1l1MjZOL2VTODJhYk9oTFlLbFdKZ3lL?=
 =?utf-8?B?aUN5eHNzT0xNdnBRZlM1WEFJMHRjdlNUQWJja1BCOG9JVG40azBXdzlnZDBj?=
 =?utf-8?B?TDh6eXFVS2ZaZWtPOW1ZMFJrQlRGTkhNT3k4b2Q3MTBnajh1TzhUV3Zmem8r?=
 =?utf-8?B?aW5SVkRYT2lRRFJQRjlQeUFlTmRmN1d2Vm93YjgxR04zcVN3b1pTUmlNY0Mx?=
 =?utf-8?B?NGwwOWdLQlNobW1sak42dmNhVlk5MzFMeWFlODJuRUJvQnlzM1lBZ0F1UHJV?=
 =?utf-8?B?aGVTeUtCMXZsNkJPT1FVVkZGNFlpRVFVTFVmek5ZVmx3RmpPdmtDTVlRVS9t?=
 =?utf-8?B?TzA1cE12K2pPZ3VBTmVKNVI5KzJXZ1VxWW11MUpSRGozVHU2Rm0vWTEreUwx?=
 =?utf-8?B?YTVpNWVZSGlMbWJrem1QbTArRmdkOVhvNEhDWTVPaEpjVGdIaG5oTXJnSWJm?=
 =?utf-8?B?emIwZHZnSFQrM0lZRGlXM1hzTUpIcnVWZGI1cEIycUJjRTZQSFJHY3hsZXc3?=
 =?utf-8?B?VDlZNVJlbU1hNHZTaDNwQ3lVTEROQlMzN0JKNFkxODh5dUxlL2lFZEJyb1dz?=
 =?utf-8?B?dE5COVNCUXhTMUlybk5ZTTJPdzd3dEQxMld6SXNqWlUxSDBBVTZFVTg3c2dy?=
 =?utf-8?B?MFp1MExzb2JubUpUMjJPUUMvclVqT0lUMmh1enowdENTT2tDZFZaYVhuM0dx?=
 =?utf-8?B?NUkrVjJBNUg0VFdRN0hlemN2ejFvcFVXRHJmajJqTTQwaWNMNDdLZU1idlNO?=
 =?utf-8?B?aTNCSGFUT3pKdDVDVnpaNmJ6akxlN0NHZ3ZId2FSeUpFempWZmhmRGFnVkla?=
 =?utf-8?B?bHZLaFo1VE4wdlNkUUJma2FqbjhWRlNJRzR4V3E1d0lhcENjNXBRZXlCRXhW?=
 =?utf-8?B?MXhBRjBYdFVUaXlaY1YwQ2ZmcWNtM1JERnVPbEZJUlFuVFkybENLalFMWi9B?=
 =?utf-8?B?dGkzdGI0am9PRHBva0NqSlA1V0dLRk0zZStNektRWUJUMGJkUGJUMmJDODVy?=
 =?utf-8?B?S3Q5MjRja2pqNys1c1VHNlhMSmZNaGVWazVSYVRKNjJiRTdyQlVsQUpwZXlm?=
 =?utf-8?B?Z2MyaW42LzZQSERQNDdJd0tyb3pjKzBSeWtYbzdZWGZUYllhaFBGVHdqNE4r?=
 =?utf-8?Q?CaJdTUv0FJdwZxO85ZaSVZUf2?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW5PR11MB5857.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fdd846a5-8d72-4f70-40ed-08dadb5224b1
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Dec 2022 08:31:47.5275
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kZBrpIT/H/mRb9iEnjp/mSXWc+qvy6ztEDpzGLylTls7SDn/hmAWAVL/Erw8gfq4pRErKliNCa+ISpxEppSTMg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6979
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogU2FzaGEgTGV2aW4gPHNh
c2hhbEBrZXJuZWwub3JnPg0KPiBTZW50OiBTdW5kYXksIERlY2VtYmVyIDExLCAyMDIyIDI6MTAg
UE0NCj4gVG86IE1hdGV1c3ogSm/FhGN6eWsgPG1hdC5qb25jenlrQG8yLnBsPg0KPiBDYzogQ2hl
biwgS2FuZSA8a2FuZS5jaGVuQGludGVsLmNvbT47IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmc7IEFs
ZXhhbmRyZQ0KPiBCZWxsb25pIDxhbGV4YW5kcmUuYmVsbG9uaUBib290bGluLmNvbT4NCj4gU3Vi
amVjdDogUmU6IFtQQVRDSCB2MV0gcnRjOiBjbW9zOiBhdm9pZCBVSVAgd2hlbiB3cml0aW5nL3Jl
YWRpbmcgYWxhcm0gdGltZQ0KPiANCj4gT24gRnJpLCBEZWMgMDksIDIwMjIgYXQgMTE6NDA6NTZQ
TSArMDEwMCwgTWF0ZXVzeiBKb8WEY3p5ayB3cm90ZToNCj4gPlcgZG5pdSA5LjEyLjIwMjIgb8Kg
MDE6MzcsIFNhc2hhIExldmluIHBpc3plOg0KPiA+PiBPbiBUaHUsIERlYyAwOCwgMjAyMiBhdCAx
MDo0NzoxN1BNICswMTAwLCBNYXRldXN6IEpvxYRjenlrIHdyb3RlOg0KPiA+Pj4gVyBkbml1IDcu
MTIuMjAyMiBvwqAwNzo1MSwgQ2hlbiwgS2FuZSBwaXN6ZToNCj4gPj4+Pj4gLS0tLS1PcmlnaW5h
bCBNZXNzYWdlLS0tLS0NCj4gPj4+Pj4gRnJvbTogU2FzaGEgTGV2aW4gPHNhc2hhbEBrZXJuZWwu
b3JnPg0KPiA+Pj4+PiBTZW50OiBXZWRuZXNkYXksIERlY2VtYmVyIDcsIDIwMjIgMToxMyBQTQ0K
PiA+Pj4+PiBUbzogQ2hlbiwgS2FuZSA8a2FuZS5jaGVuQGludGVsLmNvbT4NCj4gPj4+Pj4gQ2M6
IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcNCj4gPj4+Pj4gU3ViamVjdDogUmU6IFtQQVRDSCB2MV0g
cnRjOiBjbW9zOiBhdm9pZCBVSVAgd2hlbiB3cml0aW5nL3JlYWRpbmcNCj4gPj4+Pj4gYWxhcm0g
dGltZQ0KPiA+Pj4+Pg0KPiA+Pj4+PiBPbiBXZWQsIERlYyAwNywgMjAyMiBhdCAxMTo1NzoyMkFN
ICswODAwLCBLYW5lIENoZW4gd3JvdGU6DQo+ID4+Pj4+PiBXaGlsZSBydW5uaW5ncyBzMGl4IGN5
Y2xpbmcgdGVzdCBiYXNlZCBvbiBydGMgYWxhcm0gd2FrZXVwIG9uDQo+ID4+Pj4+PiBBREwtUCBk
ZXZpY2VzLCBXZSBmb3VuZCB0aGUgZGF0YSBmcm9tIENNT1NfUkVBRCBpcyBub3QgcmVhc29uYWJs
ZQ0KPiA+Pj4+Pj4gYW5kIGNhdXNlcw0KPiA+Pj4+PiBSVEMgd2FrZSB1cCBmYWlsLg0KPiA+Pj4+
Pj4gV2l0aCB0aGUgYmVsb3cgY2hhbmdlcywgd2UgZG9uJ3Qgc2VlIHVucmVhc29uYWJsZSBkYXRh
IGZyb20gY21vcw0KPiA+Pj4+Pj4gYW5kDQo+ID4+Pj4+IGlzc3VlIGlzIGdvbmUuDQo+ID4+Pj4+
DQo+ID4+Pj4+IFRoYW5rcyBmb3IgdGhlIGFuYWx5c2lzLCBJIGNhbiBxdWV1ZSBtb3N0IG9mIHRo
ZXNlIHVwLiBUaGVyZSBhcmUNCj4gPj4+Pj4gdHdvIHdoaWNoIHdvbid0IGdvIGluOg0KPiA+Pj4+
Pg0KPiA+Pj4+Pj4gY2QxNzQyMDogcnRjOiBjbW9zOiBhdm9pZCBVSVAgd2hlbiB3cml0aW5nIGFs
YXJtIHRpbWUNCj4gPj4+Pj4+IGNkZWRjNDU6IHJ0YzogY21vczogYXZvaWQgVUlQIHdoZW4gcmVh
ZGluZyBhbGFybSB0aW1lDQo+ID4+Pj4+PiBlYzU4OTVjOiBydGM6IG1jMTQ2ODE4LWxpYjogZXh0
cmFjdCBtYzE0NjgxOF9hdm9pZF9VSVANCj4gPj4+Pj4+IGVhNmZhNDk6IHJ0YzogbWMxNDY4MTgt
bGliOiBmaXggUlRDIHByZXNlbmNlIGNoZWNrDQo+ID4+Pj4+PiAxM2JlMmVmOiBydGM6IGNtb3M6
IERpc2FibGUgaXJxIGFyb3VuZCBkaXJlY3QgaW52b2NhdGlvbiBvZg0KPiA+Pj4+Pj4gY21vc19p
bnRlcnJ1cHQoKQ0KPiA+Pj4+Pj4gMGRkOGQ2YzogcnRjOiBDaGVjayByZXR1cm4gdmFsdWUgZnJv
bSBtYzE0NjgxOF9nZXRfdGltZSgpDQo+ID4+Pj4+PiBlMWFiYTM3OiBydGM6IGNtb3M6IHJlbW92
ZSBzdGFsZSBSRVZJU0lUIGNvbW1lbnRzDQo+ID4+Pj4+PiA2OTUwZDA0OiBydGM6IGNtb3M6IFJl
cGxhY2Ugc3Bpbl9sb2NrX2lycXNhdmUgd2l0aCBzcGluX2xvY2sgaW4NCj4gPj4+Pj4+IGhhcmQg
SVJRDQo+ID4+Pj4+IFRoaXMgb25lIGZpeGVzIGEgY29tbWl0IHdoaWNoIGlzbid0IGluIHRoZSA1
LjEwIHRyZWUuDQo+ID4+Pj4+DQo+ID4+Pj4+PiBkMzU3ODZiOiBydGM6IG1jMTQ2ODE4LWxpYjog
Y2hhbmdlIHJldHVybiB2YWx1ZXMgb2YNCj4gPj4+Pj4+IG1jMTQ2ODE4X2dldF90aW1lKCkNCj4g
Pj4+Pj4+IGViYjIyYTA6IHJ0YzogbWMxNDY4MTg6IERvbnQgdGVzdCBmb3IgYml0IDAtNSBpbiBS
ZWdpc3RlciBEDQo+ID4+Pj4+PiAyMTFlNWRiOiBydGM6IG1jMTQ2ODE4OiBEZXRlY3QgYW5kIGhh
bmRsZSBicm9rZW4gUlRDcw0KPiA+Pj4+Pj4gZGNmMjU3ZTogcnRjOiBtYzE0NjgxODogUmVkdWNl
IHNwaW5sb2NrIHNlY3Rpb24gaW4NCj4gPj4+Pj4+IG1jMTQ2ODE4X3NldF90aW1lKCkNCj4gPj4+
Pj4gVGhpcyBvbmUgbG9va3MgbGlrZSBhbiBvcHRpbWl6YXRpb24uDQo+ID4+Pj4+DQo+ID4+Pj4+
IC0tDQo+ID4+Pj4gSSdtIHNvcnJ5LA0KPiA+Pj4+IEkgdGhvdWdodCBkY2YyNTdlIGFuZMKgIDY5
NTBkMDQsIDEzYmUyZWbCoCBhcmUgYWxzbyByZXF1aXJlZCB0byBhdm9pZA0KPiA+Pj4+IGNoZXJy
eS1waWNrIGNvbmZsaWN0IEFmdGVyIGNoZWNraW5nIGFnYWluLCBkY2YyNTdlLCA2OTUwZDA0LCAx
M2JlMmVmIGFyZQ0KPiBub3QgbmVlZGVkLg0KPiA+Pj4+DQo+ID4+Pj4gSGVyZSBpcyB0aGUgbGlz
dCBJIHdvdWxkIGxpa2UgdG8gcGljaw0KPiA+Pj4+IGNkMTc0MjA6IHJ0YzogY21vczogYXZvaWQg
VUlQIHdoZW4gd3JpdGluZyBhbGFybSB0aW1lDQo+ID4+Pj4gY2RlZGM0NTogcnRjOiBjbW9zOiBh
dm9pZCBVSVAgd2hlbiByZWFkaW5nIGFsYXJtIHRpbWUNCj4gPj4+PiBlYzU4OTVjOiBydGM6IG1j
MTQ2ODE4LWxpYjogZXh0cmFjdCBtYzE0NjgxOF9hdm9pZF9VSVANCj4gPj4+PiBlYTZmYTQ5OiBy
dGM6IG1jMTQ2ODE4LWxpYjogZml4IFJUQyBwcmVzZW5jZSBjaGVjaw0KPiA+Pj4+IDBkZDhkNmM6
IHJ0YzogQ2hlY2sgcmV0dXJuIHZhbHVlIGZyb20gbWMxNDY4MThfZ2V0X3RpbWUoKQ0KPiA+Pj4+
IGUxYWJhMzc6IHJ0YzogY21vczogcmVtb3ZlIHN0YWxlIFJFVklTSVQgY29tbWVudHMNCj4gPj4+
PiBkMzU3ODZiOiBydGM6IG1jMTQ2ODE4LWxpYjogY2hhbmdlIHJldHVybiB2YWx1ZXMgb2YNCj4g
Pj4+PiBtYzE0NjgxOF9nZXRfdGltZSgpDQo+ID4+Pj4gZWJiMjJhMDogcnRjOiBtYzE0NjgxODog
RG9udCB0ZXN0IGZvciBiaXQgMC01IGluIFJlZ2lzdGVyIEQNCj4gPj4+PiAyMTFlNWRiOiBydGM6
IG1jMTQ2ODE4OiBEZXRlY3QgYW5kIGhhbmRsZSBicm9rZW4gUlRDcw0KPiA+Pj4+IDA1YTAzMDI6
IHJ0YzogbWMxNDY4MTg6IFByZXZlbnQgcmVhZGluZyBnYXJiYWdlDQo+ID4+Pj4NCj4gPj4+PiBU
aGFua3MgYSBsb3QNCj4gPj4+Pg0KPiA+Pj4+PiBUaGFua3MsDQo+ID4+Pj4+IFNhc2hhDQo+ID4+
Pj4+DQo+ID4+PiBIZWxsbywNCj4gPj4+DQo+ID4+PiBJIHRoaW5rIHRoYXQgeW91IHNob3VsZCBh
bHNvIHBpY2sgdGhlc2UgcGF0Y2hlcyB3aGljaCBmaXggaXNzdWVzIGluDQo+ID4+PiB0aGUgc2Vy
aWVzIHRoYXQgaXMgcHJlcGFyZWQgZm9yIDUuNDoNCj4gPj4+DQo+ID4+PiAxKSBjb21taXQgNzM3
Mjk3MWMxYmU1ICgicnRjOiBtYzE0NjgxOC1saWI6IGZpeCBzaWduZWRuZXNzIGJ1ZyBpbg0KPiA+
Pj4gbWMxNDY4MThfZ2V0X3RpbWUoKSIpDQo+ID4+Pg0KPiA+Pj4gd2hpY2ggZml4ZXMgZDM1Nzg2
YjogcnRjOiBtYzE0NjgxOC1saWI6IGNoYW5nZSByZXR1cm4gdmFsdWVzIG9mDQo+ID4+PiBtYzE0
NjgxOF9nZXRfdGltZSgpDQo+ID4+Pg0KPiA+Pj4gMikgY29tbWl0IDEzYmUyZWZjMzkwYSAoInJ0
YzogY21vczogRGlzYWJsZSBpcnEgYXJvdW5kIGRpcmVjdA0KPiA+Pj4gaW52b2NhdGlvbiBvZiBj
bW9zX2ludGVycnVwdCgpIikNCj4gPj4+DQo+ID4+PiB3aGljaCBmaXhlcyA2OTUwZDA0OiBydGM6
IGNtb3M6IFJlcGxhY2Ugc3Bpbl9sb2NrX2lycXNhdmUgd2l0aA0KPiA+Pj4gc3Bpbl9sb2NrIGlu
IGhhcmQgSVJRIGFuZCBpcyBub3QgcHJlcGFyZWQgZm9yIDUuNCBzdGFibGUgZXZlbiB0aG91Z2gg
aXQgd2FzDQo+IG1lbnRpb25lZCBhYm92ZS4NCj4gPj4+DQo+ID4+PiAzKSBjb21taXQgODExZjU1
NTkyNzBmICgicnRjOiBtYzE0NjgxOC1saWI6IGZpeCBsb2NraW5nIGluDQo+ID4+PiBtYzE0Njgx
OF9zZXRfdGltZSIpDQo+ID4+Pg0KPiA+Pj4gd2hpY2ggZml4ZXMgZGNmMjU3ZTogcnRjOiBtYzE0
NjgxODogUmVkdWNlIHNwaW5sb2NrIHNlY3Rpb24gaW4NCj4gPj4+IG1jMTQ2ODE4X3NldF90aW1l
KCkNCj4gPj4NCj4gPj4gQWNrLCB3aWxsIGRvLCB0aGFua3MuDQo+ID4NCj4gPkhlbGxvLA0KPiA+
DQo+ID5Ib3dldmVyLCBJIHdvdWxkIGxpa2UgdG8gYXNrOiBpcyBpdCByZWFsbHkgbmVjZXNzYXJ5
IHRvIGluY2x1ZGUgYWxsIG9mDQo+ID50aGVzZSBwYXRjaGVzIGluIHN0YWJsZT8gSSB0aGluayB0
aGF0IGl0IGlzIHZlcnkgbGlrZWx5IHRoYXQgb25seSB0aGVzZQ0KPiA+cGF0Y2hlcyBhcmUgc3Vm
ZmljaWVudCB0byBmaXggdGhlIG9yaWdpbmFsIHByb2JsZW0gcmVwb3J0ZWQgYnkgS2FuZSBDaGVu
Og0KPiA+DQo+ID5jZDE3NDIwOiBydGM6IGNtb3M6IGF2b2lkIFVJUCB3aGVuIHdyaXRpbmcgYWxh
cm0gdGltZQ0KPiA+Y2RlZGM0NTogcnRjOiBjbW9zOiBhdm9pZCBVSVAgd2hlbiByZWFkaW5nIGFs
YXJtIHRpbWUNCj4gPmVjNTg5NWM6IHJ0YzogbWMxNDY4MTgtbGliOiBleHRyYWN0IG1jMTQ2ODE4
X2F2b2lkX1VJUA0KPiANCg0KIjA1YTAzMDI6IHJ0YzogbWMxNDY4MTg6IFByZXZlbnQgcmVhZGlu
ZyBnYXJiYWdlIiB0aGlzIGhlbHBzIHRoZSBpc3N1ZSBhcyB3ZWxsIEkgdGhpbmsuDQoNCkkgZGlk
bid0IHRlc3QgdGhlc2UgMyBwYXRjaGVzIGFsb25lIGJlY2F1c2UgaXQgd2lsbCBjcmVhdGUgY29u
ZmxpY3RzIHdoZW4gSSBwaWNrIGVjNTg5NWMuDQpJJ20gd29ycmllZCBJIG1hZGUgdGhpbmdzIHdy
b25nIGFuZCB0aG91Z2h0IHRob3NlIGRlcGVuZGVuY2llcyBhcmUgbGFuZGVkIGZvciBhIGxvbmcg
dGltZQ0KU28gZGVjaWRlZCB0byBwaWNrIHJlbGF0ZWQgZGVwZW5kZW5jaWVzIGV2ZW50dWFsbHku
DQoNClBscyBsZXQgbWUga25vdyBpZiB5b3UgaGF2ZSBjb25jZXJuIDopDQoNCg0KPiBJIHdvdWxk
IGFncmVlIHRoYXQgdGhpcyBjb3VsZCBiZSBlbm91Z2ggdG8gZml4IHRoZSBpc3N1ZSB0aGF0IHdh
cyBkZXNjcmliZWQsIGJ1dC4uLg0KPiANCj4gPlRoZXNlIHBhdGNoZXMgc2hvdWxkIGJlIG1vc3Qg
cmVsZXZhbnQgd2hlbiB1c2luZyB0aGUgUlRDIGFsYXJtIGFuZCBhcmUNCj4gPnNlbGYtY29udGFp
bmVkLiBTbyBJIHdvdWxkIGxpa2UgdG8gYXNrIEthbmUgQ2hlbiB0byByZWNoZWNrIHdpdGggdGhl
c2UNCj4gPnBhdGNoZXMgb25seS4gT3RoZXIgcGF0Y2hlcyBjaGFuZ2UgdGhlIENNT1MgUlRDIHJl
YWRpbmcgcm91dGluZXMNCj4gPnNpZ25pZmljYW50bHkgYW5kIGhhdmUgYSBoaWdoZXIgcmlzayBv
ZiBpbnRyb2R1Y2luZyByZWdyZXNzaW9ucyAoYnV0IEkNCj4gPmFtIG5vdCBhd2FyZSBvZiBhbnkg
b3V0c3RhbmRpbmcgcHJvYmxlbXMpLg0KPiANCj4gVGhlIHJlc3Qgb2YgdGhlIHBhdGNoZXMgZG8g
bG9vayBsaWtlIGZpeGVzIHRoYXQgc2hvdWxkIGhhdmUgYmVlbiBhZGRlZCB0byBzdGFibGUNCj4g
KG9yIGFyZSBkZXBlbmRlbmNpZXMgb2Ygc3VjaCBmaXhlcykgb24gdGhlaXIgb3duLiBHaXZlbiB0
aG9zZSBwYXRjaGVzIGFyZSBwcmV0dHkNCj4gb2xkLCBhbnkgcmVhc29uIHRvIG5vdCBqdXN0IGlu
Y2x1ZGUgdGhlbT8NCj4gDQo+IFRoZSBwcm9jZXNzIHdvcmtzIGJldHRlciBpZiB3ZSBhZGRyZXNz
IGlzc3VlcyBiZWZvcmUgbWFraW5nIHVzZXJzIGNvbWUgYW5kDQo+IGNvbXBsYWluIG9uIHRoZSBt
YWlsaW5nIGxpc3QgOikNCj4gDQo+IC0tDQo+IFRoYW5rcywNCj4gU2FzaGENCg==
