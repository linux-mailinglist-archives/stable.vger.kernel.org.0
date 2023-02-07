Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A46AE68D282
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 10:18:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231402AbjBGJSo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 04:18:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231560AbjBGJSc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 04:18:32 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AD7438672;
        Tue,  7 Feb 2023 01:18:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675761498; x=1707297498;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=20NY+RcJCVYM1jV2aZkfU/WSt0jQ7R3gBvD0TYMBH0M=;
  b=UDn7rr5BSnds6wkufen8LO6wYfd1E51bY9w6Ov5oRDXTIgfsthWDtkBA
   S3VSN0kel/F+N1wbR/3x0IzSL5crystwnBeGmtCCAFjyWX9sPw5tAqRzA
   txHFXg09l+jIE1OxPJ1lZyEvN+xmqkVKolewA1jHWGCzfhhpMfWEi/n8e
   TbRwUNDJn1rzhwZSgXWvfo3xME3wOFvVisQAuXPWCKsJPlpHH65MmCiPW
   IUbaWzZcFF4/pxVNOYUFnKN7TaZxY8lanR3K6FwVXyZPSD02rz2BNdpcV
   JrnfN4You+P2ntcDck82K8EZ/4j5MlhQQ4GDiS0fCkr1CNxOBYh/8QWNf
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10613"; a="327145987"
X-IronPort-AV: E=Sophos;i="5.97,278,1669104000"; 
   d="scan'208";a="327145987"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2023 01:18:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10613"; a="912263901"
X-IronPort-AV: E=Sophos;i="5.97,278,1669104000"; 
   d="scan'208";a="912263901"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga006.fm.intel.com with ESMTP; 07 Feb 2023 01:18:17 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 7 Feb 2023 01:18:17 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 7 Feb 2023 01:18:17 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 7 Feb 2023 01:18:17 -0800
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.177)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 7 Feb 2023 01:18:16 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LzgBnfcqmH311dARdKDtn4sxTGYQxtsyNR5N0FNuQGu1E9v7ZigWcNgL5sBDOoS0KxGR02oViXKR5ZbW1T3gS7gp4Qczw4elr/Dd5HO1RovDovHVhWMfWg5XsB2653kwZ90dv8GRjPJ2rQ6s59o74RDz6YYS7c7JdN8c/ZXpA1LPZmQ2g/JyX/IuVpSZjI4mOCZZSfeJEUHUkLsnhYS2LkfpFE4DboAmk+nZa7ZPhrJDvTSh+6dBc+6iOkeEJlCQ/SkgCpv5to0E5YuVHTp5PEjKTkqMcqtxtw/G4ShNcqzpEpPKEFUvsr+zWjHlazfGh0R+T4cmpRaHBHEx1h31iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=20NY+RcJCVYM1jV2aZkfU/WSt0jQ7R3gBvD0TYMBH0M=;
 b=Y0RIPQkNX7sG5uoEZOZDwGoWtFAlkRFjknQivq8gS9QQ5sgCJPQjD0pd6jG7hpKIc/DVJbxgrtG910XN46NUbDTwrt4Bb/mAi1Ju44GuX81OYBMwrrv3kaDve5LqTideNf08QRIlliXVskohdHcVjKxhLZSClzGFLJXi3JRgjCCivJpPvEmPeQAYk1a00bBOWpjTWFtL/cnt8mgikr0hTIfdlIyrdOgK9IRW4rSt4pWG1K5TCKC9XdtS3HMbEUxtJ1zmUwig4M1nuQZtLZbIQT+GCunqSTdJiD8Xgq4K/vUKPfagGls5YFVS6vhVcrmnJl6wleoWYIM3J58+ba41Fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SN7PR11MB6874.namprd11.prod.outlook.com (2603:10b6:806:2a5::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Tue, 7 Feb
 2023 09:18:15 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d%8]) with mapi id 15.20.6064.034; Tue, 7 Feb 2023
 09:18:14 +0000
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
Thread-Index: AQHZOCNd6z7weBkJP0K7ycd3Ms6uFq6+VIgAgAL1GUCAAcWqgIAAKncA
Date:   Tue, 7 Feb 2023 09:18:14 +0000
Message-ID: <BN9PR11MB527646D3824A1E219435F3EF8CDB9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230203230417.1287325-1-jacob.jun.pan@linux.intel.com>
 <ef65f1cf-d04c-8c35-7144-d30504bf7a1c@linux.intel.com>
 <BN9PR11MB52764498929E4978B3A8740D8CDA9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <b190ddb3-eb1d-cd72-ce03-1127af228bf0@linux.intel.com>
In-Reply-To: <b190ddb3-eb1d-cd72-ce03-1127af228bf0@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SN7PR11MB6874:EE_
x-ms-office365-filtering-correlation-id: 44821935-ecdc-425c-9fe0-08db08ec3e00
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EN2/siAnyiVJK94jRIFY9VOWRO4xN1nfj+oOPK6x3vDV6EN2xfUEyg/+dG9woREMgJWQbwaNOFzON0w7zI0PIWr33EkC/ejA3cvCiFJ6Ptl16l/qMcAFvVhwXqo09af5RNO2BA69CshK244yfIqsFOnr0o9/10zJ878XkS9D9wuHW8no9wg0L/W5c+nSjMKuLtzSPrmhfdCn1FIrGCPnK8PK4oViPhr05GITn37YaIJWkKVhsIH96ZywGyuGASj7wCksdT2omgeevMho9ZxJV/JucY34CYMFd76jjws4MEh23qmv3u9UMawTumTMQJXS4rq3enZjWyA138PmOA0Vnxdi5zu8aTzoARslZtjyEqHsk1Wc8GYjcoLQK1swm7pISFenKxEMIlgFu5PJNWtXefKvColLA1/5D6TVy9QUGes4gUZD3+TQGLNItRDgPmzt9Zkevv482XQU7lVc5KQA4EYTqaa8HmOYIuB+PPlOGIun4jMFrBU2LIUZxPobT+aN1RhHb6oliGr441mHFmRz8ghW2TwUcqMuA3TKbnx57uHTqxe43QNOI/3AWgg014Qpr1GNczJZySHEXKr/sReqpKO7A34KSzuB6D7Ydg0318xb7ov3Y4ejtxIxv0yVmk66szcSNNSUQI5wYwrbX7KAPiJskoZQNA6b8gbNWN1VS6JbqXTem2Iy5tE9+mFkMPX13Q+ueNGxHSybH3E2YiPpNg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(366004)(39860400002)(376002)(136003)(346002)(451199018)(38100700002)(82960400001)(122000001)(38070700005)(6506007)(33656002)(186003)(26005)(53546011)(9686003)(86362001)(76116006)(66946007)(64756008)(4326008)(83380400001)(66556008)(8676002)(316002)(66476007)(52536014)(110136005)(478600001)(54906003)(7696005)(66446008)(5660300002)(2906002)(41300700001)(8936002)(55016003)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Q0t4cDJCTU1lR1k0Z1pvNDhRUUV3c1ZUaXVzbDVUK0tNOTBTMkdvWXRxVjhB?=
 =?utf-8?B?K0QzazlzNXdDWnBHeHF2LzJRSHZaZVJpRUZ1Nk1FZzFNRko5OWI3MXJpZWQw?=
 =?utf-8?B?cmQ0RjZ3ck92Syt0YzB4R053RFoxT2pUUmNLV05oSTNlUjZlWHBBdTl6TnBa?=
 =?utf-8?B?VXIyTGxzN1lzWStYY3ZRQjEzd2EwQmVVSGJrRXdmUlI4S0syTndkcElFOWVK?=
 =?utf-8?B?a3RGUHNMNC9Ob1A3TmdRUlBuVmxMUTJuaVpoZWpZMWd4Lzh3WUJRN3JXb2VJ?=
 =?utf-8?B?QkJiU1g1NWhVS3gybnlkL0poa0UvclZtZmhkdWpKS2tNb0R0UmtpK214WC94?=
 =?utf-8?B?TlNSc0tXUDJxN1RUKzVvUmJpVnJFUjNCL1QwRDRVbDZBMzFVeGdFNFlkYkxZ?=
 =?utf-8?B?OXRRSmVIMFBWMzdrV2tFaHhpaFcyS0d4STRzL1VEdTFDTTgrWjZUQlBwbS8x?=
 =?utf-8?B?R2h1RUdCY3N6RUpxaHplekM3bnIvT3k3RkpqSytLUWtaU2tFL2g2bVEvRGFG?=
 =?utf-8?B?MHVJcG1hU2ljYkNQSEt4Q0JuQnBGMkRVK0RtZE1XRnhINlBIbUFLUW4wNXVP?=
 =?utf-8?B?WDF2NUNDVldlREEzMFdOUmhXU2s5VlBHMXVPRVlnVEU5ajJJRkg1eVI4Vm4z?=
 =?utf-8?B?ZXpja0kvR2E0d2Q3cjJEeFpUUmFhaVh0YTY5Z0huWmJqNE5teUE1RVZ2b1J3?=
 =?utf-8?B?dVIwNjBVY2xzRkRTcmpSb2FZeWREUW4yYmd5Ryt6OTZvaDVJR09YR2svRVZK?=
 =?utf-8?B?cUtiV1FMNis0NXVRTTNWVGVtdUdaejJiQ1RWb1RjTnh6aXhld09zQlp6STI1?=
 =?utf-8?B?ZlAxbjhCQ0Z4MjF6QmdUMTlGK3VycmNVQ1dERC9EdGErVTgrdWFDK1RCemdG?=
 =?utf-8?B?cTZLdmZ4K2Y3VWZxR1FBRE5KUWVJVWVkbkkzS3RhN2hhQVRQNEdmTTM5RlAy?=
 =?utf-8?B?blBHMEdXMzRVU0ZNbjUrNS9DcGJoWHlnNTJuTEVCWTFzTTJaVmRrWnNqZis3?=
 =?utf-8?B?TVkrL3RpYU5DaitDY1NLUTNDNTlzNXJnVjlrSUk2Skp2YWZ5V1dxeFdBZFlr?=
 =?utf-8?B?dTUvemtoSFdtUlVjRTVJdG5WckhNK2d0bXJDaUhjY2NqenVGUUx0ZHd4V1B1?=
 =?utf-8?B?OVpONDZzUW1oWVJRbm5aSUhxckp2NmZQZjU4b0pLdytCWURUSEtPV0VTL053?=
 =?utf-8?B?bHRjUFYrNDMzZUpaNlBvQjJOZElMYlN6WmFET1R2dFlKUFV0R3BHME9OMnJ4?=
 =?utf-8?B?U0lCaWFZMVZPcnZZVGlxbkJDYitvcC9KeHE2a1ZLaUZDRkFTSUZWcnlEWE1h?=
 =?utf-8?B?SGgyWlI1QWFDYVpGYXFDYVMxcTJtTzdvd293aHYraTFDUWJobnlqMFNtbGJu?=
 =?utf-8?B?bnh2QVI1bEVmUXUxcFZpZDRtNml4RE8zSUIyRG9zalF2WEcvSVlrMUJQY1Jw?=
 =?utf-8?B?NzdKSkZwaStFdnprNUlOZjRVTGs0b1JINGhlVmVXZTBiUWJPK3hJTDlpOGNo?=
 =?utf-8?B?ckdUTWhWK2M5YlgyMGMxc1pHb3NLaGNSMWxBVTczTzdXOEs4ZXdDeUYxK3U1?=
 =?utf-8?B?UjBwcUYzYUZEa0JGeUk3TzBML2hqbmltWlZWMFFkNTd0UUR6SFlxc3BvcG5v?=
 =?utf-8?B?a0x6R0FUWE9hajlqcCtzRkFPbzFTYkpRb1R2THo0NnpZMllDeHUrVG8zTXBI?=
 =?utf-8?B?WU9FMUMwaWpZN0tjMU1WUDVmRW9lWUxjQ2M5cjFQblJESjJyNjN0T2lGc25j?=
 =?utf-8?B?WW14bEZBTUZlOGdYUmw5M2wzRXE5Zlk1U3k3Z3Y3QWVRVXRhOVFUbnc3Q3ZB?=
 =?utf-8?B?cXJZQmZtK0pPQXBDYmxpT29JYkdPSUQvQXkwNGZzL0RZVEJnVjdZZzBxQUM4?=
 =?utf-8?B?eVE4MkFxb3NCSjlQcExraDVVUVhJbktnRUlLb1VLWkhwbjZtQno1Q0FFbWFn?=
 =?utf-8?B?b3BPcEo0WW93ZGI1TWl4d0wxOERDdHVSeitFL20zeDZWd3VObEtlS0lBazJL?=
 =?utf-8?B?MG9JRnRHR0orTFMzU0JHcW9KUmJ5MmtJcW5VR2UreVowcms1MnVqZXBNVks0?=
 =?utf-8?B?RzNwVDNtckpnUno1Tm1CRy8xZ0RTTG1YMCt3V1BPNXhua1hWcmxxblBqcHNo?=
 =?utf-8?Q?BWUnBKHEzRka+YsnqDr+N4UIq?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 44821935-ecdc-425c-9fe0-08db08ec3e00
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Feb 2023 09:18:14.8432
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: boY+oz9YQrLJiyK/TuRcAWWBsscEGTEw5CoMWhgkm1uiTZST+wnn+MvkyE3spjP35B2WtpodPmImPulcfxYptw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6874
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

PiBGcm9tOiBCYW9sdSBMdSA8YmFvbHUubHVAbGludXguaW50ZWwuY29tPg0KPiBTZW50OiBUdWVz
ZGF5LCBGZWJydWFyeSA3LCAyMDIzIDI6NDYgUE0NCj4gDQo+IE9uIDIwMjMvMi82IDExOjQ4LCBU
aWFuLCBLZXZpbiB3cm90ZToNCj4gPj4gRnJvbTogQmFvbHUgTHUgPGJhb2x1Lmx1QGxpbnV4Lmlu
dGVsLmNvbT4NCj4gPj4gU2VudDogU2F0dXJkYXksIEZlYnJ1YXJ5IDQsIDIwMjMgMjozMiBQTQ0K
PiA+Pg0KPiA+PiBPbiAyMDIzLzIvNCA3OjA0LCBKYWNvYiBQYW4gd3JvdGU6DQo+ID4+PiBJbnRl
bCBJT01NVSBkcml2ZXIgaW1wbGVtZW50cyBJT1RMQiBmbHVzaCBxdWV1ZSB3aXRoIGRvbWFpbiBz
ZWxlY3RpdmUNCj4gPj4+IG9yIFBBU0lEIHNlbGVjdGl2ZSBpbnZhbGlkYXRpb25zLiBJbiB0aGlz
IGNhc2UgdGhlcmUncyBubyBuZWVkIHRvIHRyYWNrDQo+ID4+PiBJT1ZBIHBhZ2UgcmFuZ2UgYW5k
IHN5bmMgSU9UTEJzLCB3aGljaCBtYXkgY2F1c2Ugc2lnbmlmaWNhbnQNCj4gPj4gcGVyZm9ybWFu
Y2UNCj4gPj4+IGhpdC4NCj4gPj4NCj4gPj4gW0FkZCBjYyBSb2Jpbl0NCj4gPj4NCj4gPj4gSWYg
SSB1bmRlcnN0YW5kIHRoaXMgcGF0Y2ggY29ycmVjdGx5LCB0aGlzIG1pZ2h0IGJlIGNhdXNlZCBi
eSBiZWxvdw0KPiA+PiBoZWxwZXI6DQo+ID4+DQo+ID4+IC8qKg0KPiA+PiAgICAqIGlvbW11X2lv
dGxiX2dhdGhlcl9hZGRfcGFnZSAtIEdhdGhlciBmb3IgcGFnZS1iYXNlZCBUTEINCj4gaW52YWxp
ZGF0aW9uDQo+ID4+ICAgICogQGRvbWFpbjogSU9NTVUgZG9tYWluIHRvIGJlIGludmFsaWRhdGVk
DQo+ID4+ICAgICogQGdhdGhlcjogVExCIGdhdGhlciBkYXRhDQo+ID4+ICAgICogQGlvdmE6IHN0
YXJ0IG9mIHBhZ2UgdG8gaW52YWxpZGF0ZQ0KPiA+PiAgICAqIEBzaXplOiBzaXplIG9mIHBhZ2Ug
dG8gaW52YWxpZGF0ZQ0KPiA+PiAgICAqDQo+ID4+ICAgICogSGVscGVyIGZvciBJT01NVSBkcml2
ZXJzIHRvIGJ1aWxkIGludmFsaWRhdGlvbiBjb21tYW5kcyBiYXNlZCBvbg0KPiA+PiBpbmRpdmlk
dWFsDQo+ID4+ICAgICogcGFnZXMsIG9yIHdpdGggcGFnZSBzaXplL3RhYmxlIGxldmVsIGhpbnRz
IHdoaWNoIGNhbm5vdCBiZSBnYXRoZXJlZA0KPiA+PiBpZiB0aGV5DQo+ID4+ICAgICogZGlmZmVy
Lg0KPiA+PiAgICAqLw0KPiA+PiBzdGF0aWMgaW5saW5lIHZvaWQgaW9tbXVfaW90bGJfZ2F0aGVy
X2FkZF9wYWdlKHN0cnVjdCBpb21tdV9kb21haW4NCj4gPj4gKmRvbWFpbiwNCj4gPj4gICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHN0cnVjdA0KPiA+PiBp
b21tdV9pb3RsYl9nYXRoZXIgKmdhdGhlciwNCj4gPj4gICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgIHVuc2lnbmVkIGxvbmcgaW92YSwNCj4gPj4gc2l6ZV90
IHNpemUpDQo+ID4+IHsNCj4gPj4gICAgICAgICAgIC8qDQo+ID4+ICAgICAgICAgICAgKiBJZiB0
aGUgbmV3IHBhZ2UgaXMgZGlzam9pbnQgZnJvbSB0aGUgY3VycmVudCByYW5nZSBvciBpcw0KPiA+
PiBtYXBwZWQgYXQNCj4gPj4gICAgICAgICAgICAqIGEgZGlmZmVyZW50IGdyYW51bGFyaXR5LCB0
aGVuIHN5bmMgdGhlIFRMQiBzbyB0aGF0IHRoZSBnYXRoZXINCj4gPj4gICAgICAgICAgICAqIHN0
cnVjdHVyZSBjYW4gYmUgcmV3cml0dGVuLg0KPiA+PiAgICAgICAgICAgICovDQo+ID4+ICAgICAg
ICAgICBpZiAoKGdhdGhlci0+cGdzaXplICYmIGdhdGhlci0+cGdzaXplICE9IHNpemUpIHx8DQo+
ID4+ICAgICAgICAgICAgICAgaW9tbXVfaW90bGJfZ2F0aGVyX2lzX2Rpc2pvaW50KGdhdGhlciwg
aW92YSwgc2l6ZSkpDQo+ID4+ICAgICAgICAgICAgICAgICAgIGlvbW11X2lvdGxiX3N5bmMoZG9t
YWluLCBnYXRoZXIpOw0KPiA+Pg0KPiA+PiAgICAgICAgICAgZ2F0aGVyLT5wZ3NpemUgPSBzaXpl
Ow0KPiA+PiAgICAgICAgICAgaW9tbXVfaW90bGJfZ2F0aGVyX2FkZF9yYW5nZShnYXRoZXIsIGlv
dmEsIHNpemUpOw0KPiA+PiB9DQo+ID4+DQo+ID4+IEFzIHRoZSBjb21tZW50cyBmb3IgaW9tbXVf
aW90bGJfZ2F0aGVyX2lzX2Rpc2pvaW50KCkgc2F5cywNCj4gPj4NCj4gPj4gIi4uLkZvciBtYW55
IElPTU1VcywgZmx1c2hpbmcgdGhlIElPTU1VIGluIHRoaXMgY2FzZSBpcyBiZXR0ZXINCj4gPj4g
ICAgdGhhbiBtZXJnaW5nIHRoZSB0d28sIHdoaWNoIG1pZ2h0IGxlYWQgdG8gdW5uZWNlc3Nhcnkg
aW52YWxpZGF0aW9ucy4NCj4gPj4gICAgLi4uIg0KPiA+Pg0KPiA+PiBTbywgcGVyaGFwcyB0aGUg
cmlnaHQgZml4IGZvciB0aGlzIHBlcmZvcm1hbmNlIGlzc3VlIGlzIHRvIGFkZA0KPiA+Pg0KPiA+
PiAJaWYgKCFnYXRoZXItPnF1ZXVlZCkNCj4gPj4NCj4gPj4gaW4gaW9tbXVfaW90bGJfZ2F0aGVy
X2FkZF9wYWdlKCkgb3IgaW9tbXVfaW90bGJfZ2F0aGVyX2lzX2Rpc2pvaW50KCk/DQo+ID4+IEl0
IHNob3VsZCBiZW5lZml0IG90aGVyIGFyY2gncyBhcyB3ZWxsLg0KPiA+Pg0KPiA+DQo+ID4gVGhl
cmUgYXJlIG9ubHkgdHdvIGNhbGxlcnMgb2YgdGhpcyBoZWxwZXI6IGludGVsIGFuZCBhcm0tc21t
dS12My4NCj4gPg0KPiA+IExvb2tzIG90aGVyIGRyaXZlcnMganVzdCBpbXBsZW1lbnRzIGRpcmVj
dCBmbHVzaCB2aWENCj4gaW9fcGd0YWJsZV90bGJfYWRkX3BhZ2UoKS4NCj4gPg0KPiA+IGFuZCB0
aGVpciB1bm1hcCBjYWxsYmFjayB0eXBpY2FsbHkgZG9lczoNCj4gPg0KPiA+IGlmICghaW9tbXVf
aW90bGJfZ2F0aGVyX3F1ZXVlZChnYXRoZXIpKQ0KPiA+IAlpb19wZ3RhYmxlX3RsYl9hZGRfcGFn
ZSgpOw0KPiA+DQo+ID4gZnJvbSB0aGlzIGFuZ2xlIGl0J3Mgc2FtZSBwb2xpY3kgYXMgSmFjb2In
cyBkb2VzLCBpLmUuIGlmIGl0J3MgYWxyZWFkeQ0KPiA+IHF1ZXVlZCB0aGVuIG5vIG5lZWQgdG8g
ZnVydGhlciBjYWxsIG9wdGltaXphdGlvbiBmb3IgZGlyZWN0IGZsdXNoLg0KPiANCj4gUGVyaGFw
cyB3ZSBjYW4gdXNlIGlvbW11X2lvdGxiX2dhdGhlcl9xdWV1ZWQoKSB0byByZXBsYWNlIGRpcmVj
dA0KPiBnYXRoZXItPnF1ZXVlZCBjaGVjayBpbiB0aGlzIHBhdGNoIGFzIHdlbGw/DQo+IA0KDQp5
ZXMNCg==
