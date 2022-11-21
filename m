Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E5476318FD
	for <lists+stable@lfdr.de>; Mon, 21 Nov 2022 04:39:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229526AbiKUDj5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 20 Nov 2022 22:39:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiKUDj4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 20 Nov 2022 22:39:56 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F96F4AF0D
        for <stable@vger.kernel.org>; Sun, 20 Nov 2022 19:39:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669001995; x=1700537995;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=XTXgJB4iGi78YesyKtFZYGd86jj9Ij2+mOHgxJ6+Psg=;
  b=KTzgoRUbBB7/oezGrqtjfwJ/jQ6U4QzaVPjeej1zGwg3XDyST3PKsLHw
   TPyPL0WVwVUN/rXEVmCXFBGDq+2Z8yStcyVFspmQU2RuQiTwLDPxp4MeX
   UyuOf+4GrBfznzKDtx0M9W5o32SBfQ80+QxeHnqCB9qfBElOxL3zX9K+E
   PweTm+QqJeU8/Dq5IOVgDwZS6b4qJLQBAYn5mNI6137M9LDoKAkKxRwGX
   2Se6IcJtKYnAKfgjWJlD3FTw1PqYKgc7kgGfthVQUOdtLan5wN5spCtOq
   MDcVamG+JscaAQZnbpSyzC/EwartpAJuhvcUvxKuvDOflNTA+cqMoky30
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10537"; a="301009234"
X-IronPort-AV: E=Sophos;i="5.96,180,1665471600"; 
   d="scan'208";a="301009234"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2022 19:39:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10537"; a="815567397"
X-IronPort-AV: E=Sophos;i="5.96,180,1665471600"; 
   d="scan'208";a="815567397"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga005.jf.intel.com with ESMTP; 20 Nov 2022 19:39:45 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 20 Nov 2022 19:39:44 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 20 Nov 2022 19:39:44 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Sun, 20 Nov 2022 19:39:44 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.177)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Sun, 20 Nov 2022 19:39:44 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PKOU842ziXugHA5Cm95z9qFVe042xWRjeIDafEdL1Mr4XRw1Gmydh3KrJzt5+2ecxtmD81bpiZ162cq2NbqBjCv8xB3TABjxu0czaQViTGqN/YlBIPJxjIqDW9iR2Bul+YMSPehUmX4KzCv+xc4oML/3YbcCI/dgumv44hBJWwM82SHNcrGzrADRW++jP70/eBkKKsixldFoQ1hE9s12nanJY1Lp7VoiCK74qW3yKCznCtdpoawaHooPQ1Prgo4vxAQ7BNYETul0hltGnQvLPdjMbLTR+a0w44RfoAoSsXeYIFUdTNxdgFNKjOteEZtKJJ3iEEfv23chKwzvnZqQJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XTXgJB4iGi78YesyKtFZYGd86jj9Ij2+mOHgxJ6+Psg=;
 b=IqnvTCC5HbwPxcUMmcJbDEkTWFHl6BxRTI9b+UaB9FCW9YRIVWIF87NRhxqIkZUa0EWaK8SQ0vb8cOjpix4DArO7pIYrUx2X+f2QJiopgdUjr93dYldf8eX1dnTjTRhjOs8Wd73WHf8ziwUqRQNUjeM2G8E17524hVBYC/zryuBReDdxmgXAaVSNVBfndhJtCgLy2vzyNyNElE9SWD+7dPHGHmKzYDwKw+CgLiyq+TAnPwh0UPj+VsI4xckPWNM7lkSxsC5mnnplPLdPl1pKxmuz2Rbtt/QPfLieWnwe6CTvHW9QSId7UfvAqhQAu9lZECuNe1NYCVhtczRAd1bC8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB3177.namprd11.prod.outlook.com (2603:10b6:5:c::28) by
 SJ0PR11MB5055.namprd11.prod.outlook.com (2603:10b6:a03:2d9::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.9; Mon, 21 Nov
 2022 03:39:42 +0000
Received: from DM6PR11MB3177.namprd11.prod.outlook.com
 ([fe80::83e5:2c2f:3b78:aa88]) by DM6PR11MB3177.namprd11.prod.outlook.com
 ([fe80::83e5:2c2f:3b78:aa88%7]) with mapi id 15.20.5834.009; Mon, 21 Nov 2022
 03:39:42 +0000
From:   "Murthy, Arun R" <arun.r.murthy@intel.com>
To:     Ville Syrjala <ville.syrjala@linux.intel.com>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [Intel-gfx] [PATCH] drm/i915: Remove non-existent pipes from
 bigjoiner pipe mask
Thread-Topic: [Intel-gfx] [PATCH] drm/i915: Remove non-existent pipes from
 bigjoiner pipe mask
Thread-Index: AQHY+37sG9DS4CPMM0CGBH14HZLcxq5Ivpfw
Date:   Mon, 21 Nov 2022 03:39:42 +0000
Message-ID: <DM6PR11MB3177EDD8CC9C092976B047A9BA0A9@DM6PR11MB3177.namprd11.prod.outlook.com>
References: <20221118185201.10469-1-ville.syrjala@linux.intel.com>
In-Reply-To: <20221118185201.10469-1-ville.syrjala@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB3177:EE_|SJ0PR11MB5055:EE_
x-ms-office365-filtering-correlation-id: 4fd9216b-96a5-4452-c99a-08dacb7206c4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7xj49q8dADahv23sNwcDNBUqbGfUAuTaCOc7fsESwQktr0joM8ntGQOkawaw+J3yjtTmWGtbTWicWcOiKuy9yvbgOY34+x6nIWfW1sjpu0W5vo681Dm4RtxBZbt5bp6+xTROotIQxuBGhHvCI1i9eyvv/1KluJknyAec/hpsvy6enwT3QhcyMIVYqzBxSkJ+FeH0brT2T3V9vwRu1pg0YPhFcGlCYTakhkAXlC0Wst+wTB+YO5lai5i5qZdU3XTm9OoA9x5L4MutY4x5sppM0TiNbQ9+txShRxXvOscm107WJPf+O29fvn89i5DNgyw8v5yn+k3fqoiXwasi7PWhcpAQadciGGAEAnQRTok9ei2dNFONUdk+2IKGdsuC9vVBlEvcA67OSiZxW8eIg8KURwGuD5pqUXB6Mtx998lYHQNTw/J8dKcc1kcZPUPaqMw1yyrppFt26Ar4FFgoc2mJc1Eg3pzgdFR1+jV1y0UCd2NaN4azc9v+eZMlRypeE0HUNB/XZoP+qFPjksxwaNcb21A1BNpxQFJWPYdWNzS0ln2IAnhaNTwJoLwBZDWjxtda1g1Kaf/oNoPHQ0cbD9Nevp5eun/yGylbHs2MT+Z+3uwH6bPvcI6S+n0GVf1LfEs/kPGG8xQmrE9qK6A7o1z+w9S2baZ2GxvgXSHU5QbNGVooyjqZkQLfLISKHA4E6CQyDhE0Tb8EDyVxb7eq9WgnOQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3177.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(366004)(39860400002)(376002)(346002)(396003)(451199015)(55236004)(478600001)(71200400001)(26005)(110136005)(53546011)(66476007)(66946007)(83380400001)(64756008)(9686003)(4326008)(76116006)(8676002)(2906002)(41300700001)(5660300002)(52536014)(186003)(66446008)(66556008)(8936002)(33656002)(7696005)(38070700005)(316002)(6506007)(38100700002)(122000001)(86362001)(55016003)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UnJWenZ6S3hnREN6MDFmT0V0OWc3RVE0QU1kSW05bWtHcWhDYS9yUjQyM3ky?=
 =?utf-8?B?N0lXK1BIbTg3cHQrRVJLd3hxSzA3dHFYVzJPWnRZS3RQeHl4RzNwa1JFeWhx?=
 =?utf-8?B?cjM2SGFWL2UyYndiSTF4RmY0MEIzZzRuWUNrRjN4OURQdmdYZXJOU0Z5WHFN?=
 =?utf-8?B?UnpOV3k1ZDNMR21jL2FoelQwMXVBZG44SisvZTN6UTlhbnJET2Y0dDhIcHR6?=
 =?utf-8?B?ejR0b0ZrRnJXU3Mrc3hybCtkMmY3UU92ckxzT1J0Snp4dzh0aWRzVHRodWJy?=
 =?utf-8?B?OEE0SHdISUxGV2JobFppS2RDTURURC9KV0ZKOW41c0lGa1BWR3NaV1FIVVRn?=
 =?utf-8?B?emZQbUdEZ3M1NEhDNkdmWFh2endXL05DemI5Q05NL0xFU0xtMU5DdDlNVUJO?=
 =?utf-8?B?RVVHaGpPb24xYi9NY015NXNuMFdZTXIzQmlMaVdLSVlzbG5Zc2tUQWJ5eGhH?=
 =?utf-8?B?dGEyOWljZmlCWEN3TDZ1aHcvakpaY0wyQlBRakRLN1QvYTBCUWovTmc3MmF0?=
 =?utf-8?B?M3dIL3lmNTEyb3pxM3IzMklkY3NPUEVieW4yemVDVkxLTWhRVmRvOUVmUDNu?=
 =?utf-8?B?aUFmNTQvNE16bHFmOFRBNUNTeTBCakcrVGhaS0w0VEswbWxsdU1HWGxHR2Q4?=
 =?utf-8?B?YUN3cGo0d3Q1cXpYZGJvVXYyUlRubFZWb3N0VUlhb3dCY29FeDkwaFd3T001?=
 =?utf-8?B?Ync3bm9idEIvWmVucldpKzdsRzVWcmpOWlQzWUpzeG5GTm5KYlZwc3BrcmFw?=
 =?utf-8?B?RFpyLzBLdFFlaStqRGRMWnVwd1BRNklPbFByQktxV0hSOTE4UEVoMHI5Ymlh?=
 =?utf-8?B?RUtBcmc1Qk9LbjNZbVRGLzIyYWhERVdZY21CR2tMUHJuY204VWpjbnZnck5y?=
 =?utf-8?B?TndpV3hEUFY0UmtOeGJJNFErWWxFWFBNZFpWbkcwY0g1RUpEamorT3NRS1Ev?=
 =?utf-8?B?ZHE5NjRsM2RCZnNGL2w0bGdzT1RwOEZjeHdFRC85WEJPZEJGenkrejN4aW8x?=
 =?utf-8?B?NWtydmNIcFZPZDNMV1lYZlc2L0o5d2lvNE1NOTdCbFdXTDFMdTJKejJjbGhw?=
 =?utf-8?B?eGVoTmtCeVdraDY5WVFBbGg1MHczRFgwODBXN2NmYlRzOFIvTDY3WmZmWGds?=
 =?utf-8?B?eFNoT042RUV0VlVOVlFEMGpHVjJkT2pBWUNlZnUvQ05UWXEyVkdCdkZOaGFS?=
 =?utf-8?B?aWVENytqWnpWTlJLM3lXUVpwak03eGltbVJ2SU9PZGgvdnVRZlQvMUdKS3pp?=
 =?utf-8?B?TGdOaTNEV0hxMVJ5YWlxcSt2RlhYbE9YQ2FSSFV4cjZrWU5EVXFhYlFwQmU4?=
 =?utf-8?B?OEJyNktmZGN5dFJoNzcrYWg2eG1KaFdCS3dWME9wVXBnOVB5M1Q1L0d2S08x?=
 =?utf-8?B?RTFBak84MEZiQmlFbVhKc1BpY0R2SXk2UEt1eWlmN3MrV2lnRE93SzMrM1Ar?=
 =?utf-8?B?ZUFnZ0ZyU04yZGlDRWgzc3VybTd5eGhJamtnRmxlL29FaHR6Z1ZsYzRZd3lE?=
 =?utf-8?B?VEkwUUg4L1c4SDRCOGQ5c1R4YU1ZL2hTU3RPaHJuc1djd1R3Z1NncldGVThw?=
 =?utf-8?B?MVZqOVhEMnBQN1pxY3d2Z0FuY0pjcDBYUHJUUHh4bmlyVC9ZVE5sRFpJV3Qz?=
 =?utf-8?B?dVFzaitoMlZscW1pNU0zZ3ZLNWxNQ1lDSXUwSnBGQVJmZXIzOC85cTA3enBu?=
 =?utf-8?B?VDFFY3E0R1ZRdXdreHB4UDNBb2pCYnVtYzZZbVdPYStMUURWU1ovOGtJcGxX?=
 =?utf-8?B?QkVXeURRbi9TVEoydWdyc3hPWkxzamZuaVVFd3RSWjgrbEVucDdzb0I3d2RV?=
 =?utf-8?B?MTlqakhuRHBYaDNmYTNUZWJOOTZSRC9YTzgxekc5Qjk3elV5eXJzSGRETkxP?=
 =?utf-8?B?VkRnb25OemFUQjlOdm1KUmxpYkhaQkkxZWF4dGlHZlNUaDhndTZ4WWoyUGky?=
 =?utf-8?B?WElvTTBCeDZpT1NTcDI5YmlzR1QxU09ZUW4raXV0Y3YxanordElsVTBDbHVE?=
 =?utf-8?B?RHNRTFU1OXpkbTNCTXpOd0MwNk5HYVNRZGtGaTZMZ2ZFUGNPU0dXQ2EzTXl5?=
 =?utf-8?B?bXBBT2hzaVFQSkJ3dC9XcG5raUR3L1Z3YnlPYTlRSEd1VUthczlMaXZaZ0pz?=
 =?utf-8?Q?xhD+Zt7KrngXbsNEmS0meQw/T?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3177.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4fd9216b-96a5-4452-c99a-08dacb7206c4
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Nov 2022 03:39:42.6148
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UTg+C/FSQ9kWsIqvE9uw9aj1QMAHz5i1OmcQdczkSNt1J/D6ZR2YqHKHA0FMGQ52sgDrgw1ohpKMZ865ciDRng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5055
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

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBJbnRlbC1nZnggPGludGVsLWdm
eC1ib3VuY2VzQGxpc3RzLmZyZWVkZXNrdG9wLm9yZz4gT24gQmVoYWxmIE9mIFZpbGxlDQo+IFN5
cmphbGENCj4gU2VudDogU2F0dXJkYXksIE5vdmVtYmVyIDE5LCAyMDIyIDEyOjIyIEFNDQo+IFRv
OiBpbnRlbC1nZnhAbGlzdHMuZnJlZWRlc2t0b3Aub3JnDQo+IENjOiBzdGFibGVAdmdlci5rZXJu
ZWwub3JnDQo+IFN1YmplY3Q6IFtJbnRlbC1nZnhdIFtQQVRDSF0gZHJtL2k5MTU6IFJlbW92ZSBu
b24tZXhpc3RlbnQgcGlwZXMgZnJvbQ0KPiBiaWdqb2luZXIgcGlwZSBtYXNrDQo+IA0KPiBGcm9t
OiBWaWxsZSBTeXJqw6Rsw6QgPHZpbGxlLnN5cmphbGFAbGludXguaW50ZWwuY29tPg0KPiANCj4g
Ymlnam9pbmVyX3BpcGVzKCkgZG9lc24ndCBjb25zaWRlciB0aGF0Og0KPiAtIFJLTCBvbmx5IGhh
cyB0aHJlZSBwaXBlcw0KPiAtIHNvbWUgcGlwZXMgbWF5IGJlIGZ1c2VkIG9mZg0KPiANCj4gVGhp
cyBtZWFucyB0aGF0IGludGVsX2F0b21pY19jaGVja19iaWdqb2luZXIoKSB3b24ndCByZWplY3Qg
YWxsIGNvbmZpZ3VyYXRpb25zDQo+IHRoYXQgd291bGQgbmVlZCBhIG5vbi1leGlzdGVudCBwaXBl
Lg0KPiBJbnN0ZWFkIHdlIGp1c3Qga2VlcCBvbiByb2xsaW5nIHdpdG91dCBhY3R1YWxseSBoYXZp
bmcgcmVzZXJ2ZWQgdGhlIHNsYXZlIHBpcGUNCj4gd2UgbmVlZC4NCj4gDQo+IEl0J3MgcG9zc2li
bGUgdGhhdCB3ZSBkb24ndCBvdXRyaWdodCBleHBsb2RlIGFueXdoZXJlIGR1ZSB0byB0aGlzIHNp
bmNlIGVnLg0KPiBmb3JfZWFjaF9pbnRlbF9jcnRjX2luX3BpcGVfbWFzaygpIHdpbGwgb25seSB3
YWxrIHRoZSBjcnRjcyB3ZSd2ZSByZWdpc3RlcmVkDQo+IGV2ZW4gdGhvdWdoIHRoZSBwYXNzZWQg
aW4gcGlwZV9tYXNrIGFza3MgZm9yIG1vcmUgb2YgdGhlbS4gQnV0IGNsZWFybHkgdGhlDQo+IHRo
aW5nIHdvbid0IGRvIHdoYXQgaXMgZXhwZWN0ZWQgb2YgaXQgd2hlbiB0aGUgcmVxdWlyZWQgcGlw
ZXMgYXJlIG5vdA0KPiBwcmVzZW50Lg0KPiANCj4gRml4IHRoZSBwcm9ibGVtIGJ5IGNvbnN1bHRp
bmcgdGhlIGRldmljZSBpbmZvIHBpcGVfbWFzayBhbHJlYWR5IGluDQo+IGJpZ2pvaW5lcl9waXBl
cygpLg0KPiANCj4gQ2M6IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcNCj4gU2lnbmVkLW9mZi1ieTog
VmlsbGUgU3lyasOkbMOkIDx2aWxsZS5zeXJqYWxhQGxpbnV4LmludGVsLmNvbT4NCj4gLS0tDQpS
ZXZpZXdlZC1ieTogQXJ1biBSIE11cnRoeSA8YXJ1bi5yLm11cnRoeUBpbnRlbC5jb20+DQoNClRo
YW5rcyBhbmQgUmVnYXJkcywNCkFydW4gUiBNdXJ0aHkNCi0tLS0tLS0tLS0tLS0tLS0tLS0tDQo+
ICBkcml2ZXJzL2dwdS9kcm0vaTkxNS9kaXNwbGF5L2ludGVsX2Rpc3BsYXkuYyB8IDEwICsrKysr
KystLS0NCj4gIDEgZmlsZSBjaGFuZ2VkLCA3IGluc2VydGlvbnMoKyksIDMgZGVsZXRpb25zKC0p
DQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9ncHUvZHJtL2k5MTUvZGlzcGxheS9pbnRlbF9k
aXNwbGF5LmMNCj4gYi9kcml2ZXJzL2dwdS9kcm0vaTkxNS9kaXNwbGF5L2ludGVsX2Rpc3BsYXku
Yw0KPiBpbmRleCBiM2UyMzcwOGQxOTQuLjZjMjY4NmVjYjYyYSAxMDA2NDQNCj4gLS0tIGEvZHJp
dmVycy9ncHUvZHJtL2k5MTUvZGlzcGxheS9pbnRlbF9kaXNwbGF5LmMNCj4gKysrIGIvZHJpdmVy
cy9ncHUvZHJtL2k5MTUvZGlzcGxheS9pbnRlbF9kaXNwbGF5LmMNCj4gQEAgLTM3MzMsMTIgKzM3
MzMsMTYgQEAgc3RhdGljIGJvb2wgaWxrX2dldF9waXBlX2NvbmZpZyhzdHJ1Y3QgaW50ZWxfY3J0
Yw0KPiAqY3J0YywNCj4gDQo+ICBzdGF0aWMgdTggYmlnam9pbmVyX3BpcGVzKHN0cnVjdCBkcm1f
aTkxNV9wcml2YXRlICppOTE1KSAgew0KPiArCXU4IHBpcGVzOw0KPiArDQo+ICAJaWYgKERJU1BM
QVlfVkVSKGk5MTUpID49IDEyKQ0KPiAtCQlyZXR1cm4gQklUKFBJUEVfQSkgfCBCSVQoUElQRV9C
KSB8IEJJVChQSVBFX0MpIHwgQklUKFBJUEVfRCk7DQo+ICsJCXBpcGVzID0gQklUKFBJUEVfQSkg
fCBCSVQoUElQRV9CKSB8IEJJVChQSVBFX0MpIHwgQklUKFBJUEVfRCk7DQo+ICAJZWxzZSBpZiAo
RElTUExBWV9WRVIoaTkxNSkgPj0gMTEpDQo+IC0JCXJldHVybiBCSVQoUElQRV9CKSB8IEJJVChQ
SVBFX0MpOw0KPiArCQlwaXBlcyA9IEJJVChQSVBFX0IpIHwgQklUKFBJUEVfQyk7DQo+ICAJZWxz
ZQ0KPiAtCQlyZXR1cm4gMDsNCj4gKwkJcGlwZXMgPSAwOw0KPiArDQo+ICsJcmV0dXJuIHBpcGVz
ICYgUlVOVElNRV9JTkZPKGk5MTUpLT5waXBlX21hc2s7DQo+ICB9DQo+IA0KPiAgc3RhdGljIGJv
b2wgdHJhbnNjb2Rlcl9kZGlfZnVuY19pc19lbmFibGVkKHN0cnVjdCBkcm1faTkxNV9wcml2YXRl
DQo+ICpkZXZfcHJpdiwNCj4gLS0NCj4gMi4zNy40DQoNCg==
