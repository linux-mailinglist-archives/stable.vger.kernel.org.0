Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D56869B48A
	for <lists+stable@lfdr.de>; Fri, 17 Feb 2023 22:20:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229788AbjBQVT7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Feb 2023 16:19:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjBQVT6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Feb 2023 16:19:58 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB4C65FC42;
        Fri, 17 Feb 2023 13:19:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676668796; x=1708204796;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=hiblaMG1TkczEwx8XwQv/lBBsbXB4MC49G30TeaEm4M=;
  b=Vsl3QJGw3zUnoZAdWyHQO4XLKqaESMAN6cNzf2Jpa9Cp7QdX8YqRL926
   Zn0wr/42g9Wp/FsdjzoBlwl8hEUqEj7m38UmHsRj+5g0D/xBkdz0S7BE1
   RAxPL13Bgl/kuGUl90dyVCfjXGJvsdVngwuiWWiUjhbWF9dNdbhe3ARpq
   EScKY4q7vLcyDPIFEVQns3obpwncx8bmXHo7ZdV+mcCkVDtUDHQXwz5Vi
   KTsaih28kiU8k02GyeYXt3vCUx13/oTgZ+xuSEWhUZl0FcxF73/T44BJe
   X4c52zIY05GuVxRvB1gJTQcCXkq6JxREpSaPR49LNCEdyOy8UYElntIrT
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10624"; a="394573388"
X-IronPort-AV: E=Sophos;i="5.97,306,1669104000"; 
   d="scan'208";a="394573388"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2023 13:19:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10624"; a="844707264"
X-IronPort-AV: E=Sophos;i="5.97,306,1669104000"; 
   d="scan'208";a="844707264"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga005.jf.intel.com with ESMTP; 17 Feb 2023 13:19:55 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 17 Feb 2023 13:19:55 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 17 Feb 2023 13:19:54 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 17 Feb 2023 13:19:54 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.106)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 17 Feb 2023 13:19:52 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BWDVYXqAzlglDjtZkV3PvyXn7Wb+UUtKGMrtUfoJNu0wL78+g+TS5EHF3Q7s6l2fa1W3MjSqZIQzlXsJbAJrsBNDTS7O5q1nLynJwhf+ghpQyN1I9jDgxeYJbVJ94VEGEQQ6uHvxRI7ixNQ6KRFes1G5B6EzDJ68L9pJa42DBIhU6tQmBwg8jWYyCFuzsV+q/1Q54fEDccOtic5KAcuDw9HhPOrZEJ7zVrzwtVI8RPNvsVcoynkypIVaiA6Vp5yMkT/9U0ObWIqp20dLg2a6xG3PbnsgUQgcMIcjL92PcSU3uFOi7A/OTfRsWnyTDtr+X5YyNZLDcc/9f+qGI+tezQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hiblaMG1TkczEwx8XwQv/lBBsbXB4MC49G30TeaEm4M=;
 b=YOPHTL2hRkBENLZMenubhl5K159WxBSAEnAvMsbOeoo76wHMIpHqBsHY7byKroQq3wwBlu2O91t7pTRLZd4uaBzDnot5jsA1gTuZ3l5ErsxJqDZUAkSaBW0+3TEe1TtMz5m/VPrDvvernSsj0WhLh6Doq8CFaBVbZQEmgaiH2/axeUCtcuRwIZ1x+PJrvpDeagiObP/hVq/wvvslWTfbc+YSc1jUemeBmHUCVT/TvRIvtJJG3xs+T1vX9b1fI79FQ6uQ4I7mhHPqi8+MUojaYyjTvcAZuMdRyV/OEfvEVAnF6aloByHFugSzmo/lJ6yD+D81zd1cA+msYqALjuGeqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN2PR11MB3999.namprd11.prod.outlook.com (2603:10b6:208:154::32)
 by CO1PR11MB4769.namprd11.prod.outlook.com (2603:10b6:303:95::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.17; Fri, 17 Feb
 2023 21:19:50 +0000
Received: from MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::35af:d7a8:8484:627]) by MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::35af:d7a8:8484:627%5]) with mapi id 15.20.6111.013; Fri, 17 Feb 2023
 21:19:50 +0000
From:   "Verma, Vishal L" <vishal.l.verma@intel.com>
To:     "Williams, Dan J" <dan.j.williams@intel.com>,
        "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>
CC:     "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "osalvador@suse.de" <osalvador@suse.de>,
        "david@redhat.com" <david@redhat.com>,
        "pasha.tatashin@soleen.com" <pasha.tatashin@soleen.com>
Subject: Re: [PATCH] dax/kmem: Fix leak of memory-hotplug resources
Thread-Topic: [PATCH] dax/kmem: Fix leak of memory-hotplug resources
Thread-Index: AQHZQeG9e4R04ALPTUuOIeWTAty11a7Tp10A
Date:   Fri, 17 Feb 2023 21:19:50 +0000
Message-ID: <73eb66b014bb319cfaac6d7e60332d8bbaeec189.camel@intel.com>
References: <167653656244.3147810.5705900882794040229.stgit@dwillia2-xfh.jf.intel.com>
In-Reply-To: <167653656244.3147810.5705900882794040229.stgit@dwillia2-xfh.jf.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.3 (3.46.3-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR11MB3999:EE_|CO1PR11MB4769:EE_
x-ms-office365-filtering-correlation-id: c5d4ca98-73de-4b1d-1d11-08db112cb43d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 297KrYg1GQ4iRDt7dR0SXp8JOVBJ0qtxXCi/X43xOeQmL3Q+BLz6V3bck3gL1FVbgOnw4kqJqxYH22RZWlLUgWKciMn5XhO6uvk0OUUs6mvpczb0Rh8LMTYhcL2n4QUzcY5Cl4T4z0xCgwLrFWVDPvxDjKjCHTV9CVdeco0tkEyUKUaHbCj9zcKJh5d8wTO+yIkLxH4ugvQqVevi3w4h6GAsWCVC51H6Bv4TB00MMJNSNUG5jVbHryMAvjzItZMxTCxq9gLVMQtQyPiD8rdVtMZMstAR7uDlFggNuk6Q0tOd3tXvpXYDcTc1GOQ93RUrEdGxrCy3UgqR7RUL3Ry4njdacnUWF6AK695C0rCyvglPqNwVZ69W5X7hfw40wF8/0wELvxgm1AZxxo1PYlOvQoRE7cVRETcU5a4FEztCB7D3MgJF/NxtXDzLyK9UnLhDb6uo/NZjsdEvosA1QRTir/YmUWZNAKrX7iuSk8/U0VJDV/jE/PDXh/H3HsoRc7VgmYWg6y8oJ+72am2SawKZaDGJARuN2OnD6+lA8BQ+hP/4P+biadh0auPeHDiRU40kXE68zfYzMhCmO1m2IB4TEppar/ZKoV+pRxKCsgr8nBSpijWRsYNx66ivlApsXWn7lb3o4/opTeZurqin6sVz/zerk6J98fiPpGG43L3t1z+RqPhDn/JxMcfj9aXrB2Vzjr9fdfHj8Kokgr0269DeIw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3999.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(136003)(376002)(39860400002)(396003)(366004)(451199018)(86362001)(38070700005)(82960400001)(38100700002)(122000001)(4326008)(36756003)(41300700001)(64756008)(2906002)(8936002)(76116006)(91956017)(66556008)(66476007)(8676002)(66446008)(66946007)(186003)(2616005)(26005)(6512007)(83380400001)(110136005)(71200400001)(54906003)(316002)(6486002)(478600001)(5660300002)(6506007)(66899018);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cEpCMVdKSVU2NC9abFltZlptYVFTa0NOSXc5eGRQQ2l4L3BTSHhoSE1YS01w?=
 =?utf-8?B?ZXc2QlI4Ulh1QW9HUWxLSG81dFhQdEphd3Zsd2FhemN6M05BT1RKdVBWN0li?=
 =?utf-8?B?RjM2T1F2YkdyOXFCc0tRdVpGUE1BWjQyN2UxdDMxTFpIMERNcDEzTWdFaXNS?=
 =?utf-8?B?OCttbnpoN2NuQ0NabnlGVkIrZUM1NUROQ01iQ1VpNmh4Nk5aWGs5dzVmMk9X?=
 =?utf-8?B?TDNkN1dLajJEblBoeEMxemN5Qk92S0ZwQllOeStOZXgzLzgvZnhsQnREZFMx?=
 =?utf-8?B?K1JpUEIzTkdYWk5CUi9IV1dPeERYdGFwRkxEZzR6N2NWWjZreFJSMVhNVUx1?=
 =?utf-8?B?QjdjOXNFK3FoR0N6UTR1UURzTDV6U2QzQzJzczNrbmlVcW1XWlQ2NG9zVGdq?=
 =?utf-8?B?cmgvQnJEUk80RUEzNVZhcGN2Zzg1M3hWM0dJci85TXBXUk0zd3MzY3IzaDdK?=
 =?utf-8?B?Sk5KQ0d1M3ZabjdOczZYc0ZmZUpDb1UwbHlUR2VwaFZCSUFnTFNjZG1nZVRw?=
 =?utf-8?B?K2JOQmJ3NmhtR3NIZjN5VmZPSVRLWHlPTnZqU2pGQXBwSW9TN2g0THdaenpV?=
 =?utf-8?B?OE9DTHBjbHJvQkx6bWV3VDc3OTdOSExiZVBQV0h5cGFOeFJ2V0huemQreUJW?=
 =?utf-8?B?OXlBY0xkSXRSWmpTNUppK1RpcDJqVVZ0Nk13UktVY1k4QzlQaEl2bmtWbkFZ?=
 =?utf-8?B?K2ZIaWdIbDhoWEtuaEFSbWxLbXhNYWhHSU9aZFRRalJjZDhsMkxCODA0bzRn?=
 =?utf-8?B?dEpzYUp0VWVVWUF6b3FMM3N1Rjg1dExqbUlWQmlyVlAwOEhZUE8wMzhLR2Rt?=
 =?utf-8?B?VVhWV1lnYUpUd0RwMFNRWVRTTG1URWcwalBJTTJrTjc3aDBqUlc1Q2FEKy9j?=
 =?utf-8?B?RTd5M1FLRTFpZWd3a2w0Rk84ZktFZ0VIWVRGckc0T3dtNFJlYUZLUkdBMU5Z?=
 =?utf-8?B?ZU1NcUF6TUs4ejMxZTRQRVpWZml5RTRTUlA4VFV3bFp1ZUVtcVBKOWRrSlVi?=
 =?utf-8?B?SGRxeHUrOWxPS2FIeWExdWNsYk81MjFmMlQ2TGZHQWR0dnlValFuOWYrL1Jk?=
 =?utf-8?B?dTBJOWg0K2pjb1hpRUlObVRTV1llbFJoRFNKdGtMZzgraEhIcGdyL09zWDFj?=
 =?utf-8?B?aGxjcmxFWVJIbS9HeHcvZXNaRGg3MnRsUFdmTFpEUmJTQ1cwaHRkSnc2L21Q?=
 =?utf-8?B?dnBwTDhFUnd4OC83SnFTMnZjTkh1RXNESDJDZkxYOXNidmlBUDVFRVA0aDJ6?=
 =?utf-8?B?UmlqKy9Ody9MMDhFdnptNVFMY3Y2UU5uZlRpV21RWGxJaVlCQzdYekpPNGl5?=
 =?utf-8?B?Zmo4VFVEemp1MVlUZ3VEL3Q2TW1zczZONU84Ym9qMGRqYWk0dlVuRFFaZGdn?=
 =?utf-8?B?YTEzTlVQMTNTNWJlZldweERyMUQrcm1PMktoT1FIUkFaWWtUL0dIb0dUQ083?=
 =?utf-8?B?OWN0QkVkbmNaMXdZdGs4N09DUVIzaEMzNHNsQTJpQzdmK0ZRa3psNnpwTWt3?=
 =?utf-8?B?Z1BVdldlUzRxZHRRWnY2S2FESWhNWENteTVpRWc3eTdlaFl2bklHeC9kRHMz?=
 =?utf-8?B?eVgwbEVoU0JsQk5VNFRBbE80Y3ljci9DemNxZW9NQWpvWnhvblNyZlZBNG5H?=
 =?utf-8?B?cVRQd2RiWUZPQUVUS2luQ1N2VmhLV01mRWFHOUFyWGJhamN2UldiMm9CWjE2?=
 =?utf-8?B?NlRCYVVScUxMV3pxdE1UTDFscklZS2ZRc3ExM0NSdURCSWtsT2xlYVVQRzND?=
 =?utf-8?B?UlZOSzBYOVVPK0JSL0N6QkNORUtNZ3p3ZzdjaXVScmE3MVRxWm42U0NqRDFa?=
 =?utf-8?B?UjNid3pIWHpNK3RkV2Z1eGE3dyt0b3RMZ3c3Y2ZvanNLMjdFbHZEN2JDRk0y?=
 =?utf-8?B?ZzF3VWRrYVBuRU16TFEvaXhtU20yQ1ZDNGZOSEZLOXdERUxpY3FkUVBDNkhw?=
 =?utf-8?B?VXA5akNnaGg5VmhEM2k1UWZ0cWo4MG5DK1d2Z3Z3TXJZSWp3MUluNWI1ZFdH?=
 =?utf-8?B?YzdONUhTbFp4MUwxNUJkWENBUFFlMnBsZVF3c0lzV3V0Y0x4L0Z6UFpZYkVF?=
 =?utf-8?B?VTRXTGVKczJYcTNXT0dRcGg5eDNEM0NoaHRWK3B2UlZlSUFJUmxVT3ZOb0I5?=
 =?utf-8?B?b3V4ZTdVcHp2b0tQa3hmbVlRSXdSVlFZc0J1NmRWWGw5V3JsU3ZyRUoxcHFD?=
 =?utf-8?B?VXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9740F7D76D6131448B2FA23EDE0BF225@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3999.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5d4ca98-73de-4b1d-1d11-08db112cb43d
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Feb 2023 21:19:50.2725
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4SFLVntGghYgVxYwtYOkJN4s3QCGkZV904m+hAbPzaRpkJ69Zaugg8JG8ScNVjmwDCIGDtdrcVtjhaBeb8PbO8t/u+m0Hnsr2FI0bzQ2zfM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4769
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gVGh1LCAyMDIzLTAyLTE2IGF0IDAwOjM2IC0wODAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6Cj4g
V2hpbGUgZXhwZXJpbWVudGluZyB3aXRoIENYTCByZWdpb24gcmVtb3ZhbCB0aGUgZm9sbG93aW5n
IGNvcnJ1cHRpb24gb2YKPiAvcHJvYy9pb21lbSBhcHBlYXJlZC4KPiAKPiBCZWZvcmU6Cj4gZjAx
MDAwMDAwMC1mMDRmZmZmZmZmIDogQ1hMIFdpbmRvdyAwCj4gwqAgZjAxMDAwMDAwMC1mMDJmZmZm
ZmZmIDogcmVnaW9uNAo+IMKgwqDCoCBmMDEwMDAwMDAwLWYwMmZmZmZmZmYgOiBkYXg0LjAKPiDC
oMKgwqDCoMKgIGYwMTAwMDAwMDAtZjAyZmZmZmZmZiA6IFN5c3RlbSBSQU0gKGttZW0pCj4gCj4g
QWZ0ZXIgKG1vZHByb2JlIC1yIGN4bF90ZXN0KToKPiBmMDEwMDAwMDAwLWYwMmZmZmZmZmYgOiAq
KnJlZGFjdGVkIGJpbmFyeSBnYXJiYWdlKioKPiDCoCBmMDEwMDAwMDAwLWYwMmZmZmZmZmYgOiBT
eXN0ZW0gUkFNIChrbWVtKQo+IAo+IC4uLmFuZCB0ZXN0aW5nIGZ1cnRoZXIgdGhlIHNhbWUgaXMg
dmlzaWJsZSB3aXRoIHBlcnNpc3RlbnQgbWVtb3J5Cj4gYXNzaWduZWQgdG8ga21lbToKPiAKPiBC
ZWZvcmU6Cj4gNDgwMDAwMDAwLTI0M2ZmZmZmZmYgOiBQZXJzaXN0ZW50IE1lbW9yeQo+IMKgIDQ4
MDAwMDAwMC01N2UxZmZmZmYgOiBuYW1lc3BhY2UzLjAKPiDCoCA1ODAwMDAwMDAtMjQzZmZmZmZm
ZiA6IGRheDMuMAo+IMKgwqDCoCA1ODAwMDAwMDAtMjQzZmZmZmZmZiA6IFN5c3RlbSBSQU0gKGtt
ZW0pCj4gCj4gQWZ0ZXIgKG5kY3RsIGRpc2FibGUtcmVnaW9uIGFsbCk6Cj4gNDgwMDAwMDAwLTI0
M2ZmZmZmZmYgOiBQZXJzaXN0ZW50IE1lbW9yeQo+IMKgIDU4MDAwMDAwMC0yNDNmZmZmZmZmIDog
KioqcmVkYWN0ZWQgYmluYXJ5IGdhcmJhZ2UqKioKPiDCoMKgwqAgNTgwMDAwMDAwLTI0M2ZmZmZm
ZmYgOiBTeXN0ZW0gUkFNIChrbWVtKQo+IAo+IFRoZSBjb3JydXB0ZWQgZGF0YSBpcyBmcm9tIGEg
dXNlLWFmdGVyLWZyZWUgb2YgdGhlICJkYXg0LjAiIGFuZCAiZGF4My4wIgo+IHJlc291cmNlcywg
YW5kIGl0IGFsc28gc2hvd3MgdGhhdCB0aGUgIlN5c3RlbSBSQU0gKGttZW0pIiByZXNvdXJjZSBp
cwo+IG5vdCBiZWluZyByZW1vdmVkLiBUaGUgYnVnIGRvZXMgbm90IGFwcGVhciBhZnRlciAibW9k
cHJvYmUgLXIga21lbSIsIGl0Cj4gcmVxdWlyZXMgdGhlIHBhcmVudCBvZiAiZGF4NC4wIiBhbmQg
ImRheDMuMCIgdG8gYmUgcmVtb3ZlZCB3aGljaAo+IHJlLXBhcmVudHMgdGhlIGxlYWtlZCAiU3lz
dGVtIFJBTSAoa21lbSkiIGluc3RhbmNlcy4gVGhvc2UgaW4gdHVybgo+IHJlZmVyZW5jZSB0aGUg
ZnJlZWQgcmVzb3VyY2UgYXMgYSBwYXJlbnQuCj4gCj4gRmlyc3QgdXAgZm9yIHRoZSBmaXggaXMg
cmVsZWFzZV9tZW1fcmVnaW9uX2FkanVzdGFibGUoKSBuZWVkcyB0bwo+IHJlbGlhYmx5IGRlbGV0
ZSB0aGUgcmVzb3VyY2UgaW5zZXJ0ZWQgYnkgYWRkX21lbW9yeV9kcml2ZXJfbWFuYWdlZCgpLgo+
IFRoYXQgaXMgdGh3YXJ0ZWQgYnkgYSBjaGVjayBmb3IgSU9SRVNPVVJDRV9TWVNSQU0gdGhhdCBw
cmVkYXRlcyB0aGUKPiBkYXgva21lbSBkcml2ZXIsIGZyb20gY29tbWl0Ogo+IAo+IDY1Yzc4Nzg0
MTM1ZiAoImtlcm5lbCwgcmVzb3VyY2U6IGNoZWNrIGZvciBJT1JFU09VUkNFX1NZU1JBTSBpbiBy
ZWxlYXNlX21lbV9yZWdpb25fYWRqdXN0YWJsZSIpCj4gCj4gVGhhdCBhcHBlYXJzIHRvIGJlIHdv
cmtpbmcgYXJvdW5kIHRoZSBiZWhhdmlvciBvZiBITU0ncwo+ICJNRU1PUllfREVWSUNFX1BVQkxJ
QyIgZmFjaWxpdHkgdGhhdCBoYXMgc2luY2UgYmVlbiBkZWxldGVkLiBXaXRoIHRoYXQKPiBjaGVj
ayByZW1vdmVkIHRoZSAiU3lzdGVtIFJBTSAoa21lbSkiIHJlc291cmNlIGdldHMgcmVtb3ZlZCwg
YnV0Cj4gY29ycnVwdGlvbiBzdGlsbCBvY2N1cnMgb2NjYXNpb25hbGx5IGJlY2F1c2UgdGhlICJk
YXgiIHJlc291cmNlIGlzIG5vdAo+IHJlbGlhYmx5IHJlbW92ZWQuCj4gCj4gVGhlIGRheCByYW5n
ZSBpbmZvcm1hdGlvbiBpcyBmcmVlZCBiZWZvcmUgdGhlIGRldmljZSBpcyB1bnJlZ2lzdGVyZWQs
IHNvCj4gdGhlIGRyaXZlciBjYW4gbm90IHJlbGlhYmx5IHJlY2FsbCAoYW5vdGhlciB1c2UgYWZ0
ZXIgZnJlZSkgd2hhdCBpdCBpcwo+IG1lYW50IHRvIHJlbGVhc2UuIExhc3RseSBpZiB0aGF0IHVz
ZSBhZnRlciBmcmVlIGdvdCBsdWNreSwgdGhlIGRyaXZlcgo+IHdhcyBjb3ZlcmluZyB1cCB0aGUg
bGVhayBvZiAiU3lzdGVtIFJBTSAoa21lbSkiIGR1ZSB0byBpdHMgdXNlIG9mCj4gcmVsZWFzZV9y
ZXNvdXJjZSgpIHdoaWNoIGRldGFjaGVzLCBidXQgZG9lcyBub3QgZnJlZSwgY2hpbGQgcmVzb3Vy
Y2VzLgo+IFRoZSBzd2l0Y2ggdG8gcmVtb3ZlX3Jlc291cmNlKCkgZm9yY2VzIHJlbW92ZV9tZW1v
cnkoKSB0byBiZSByZXNwb25zaWJsZQo+IGZvciB0aGUgZGVsZXRpb24gb2YgdGhlIHJlc291cmNl
IGFkZGVkIGJ5IGFkZF9tZW1vcnlfZHJpdmVyX21hbmFnZWQoKS4KPiAKPiBGaXhlczogYzJmMzAx
MWVlNjk3ICgiZGV2aWNlLWRheDogYWRkIGFuIGFsbG9jYXRpb24gaW50ZXJmYWNlIGZvciBkZXZp
Y2UtZGF4IGluc3RhbmNlcyIpCj4gQ2M6IDxzdGFibGVAdmdlci5rZXJuZWwub3JnPgo+IENjOiBP
c2NhciBTYWx2YWRvciA8b3NhbHZhZG9yQHN1c2UuZGU+Cj4gQ2M6IERhdmlkIEhpbGRlbmJyYW5k
IDxkYXZpZEByZWRoYXQuY29tPgo+IENjOiBQYXZlbCBUYXRhc2hpbiA8cGFzaGEudGF0YXNoaW5A
c29sZWVuLmNvbT4KPiBTaWduZWQtb2ZmLWJ5OiBEYW4gV2lsbGlhbXMgPGRhbi5qLndpbGxpYW1z
QGludGVsLmNvbT4KClJldmlld2VkLWJ5OiBWaXNoYWwgVmVybWEgPHZpc2hhbC5sLnZlcm1hQGlu
dGVsLmNvbT4KCj4gLS0tCj4gwqBkcml2ZXJzL2RheC9idXMuY8KgIHzCoMKgwqAgMiArLQo+IMKg
ZHJpdmVycy9kYXgva21lbS5jIHzCoMKgwqAgNCArKy0tCj4gwqBrZXJuZWwvcmVzb3VyY2UuY8Kg
IHzCoMKgIDE0IC0tLS0tLS0tLS0tLS0tCj4gwqAzIGZpbGVzIGNoYW5nZWQsIDMgaW5zZXJ0aW9u
cygrKSwgMTcgZGVsZXRpb25zKC0pCj4gCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvZGF4L2J1cy5j
IGIvZHJpdmVycy9kYXgvYnVzLmMKPiBpbmRleCAwMTJkNTc2MDA0ZTkuLjY3YTY0ZjRjNDcyZCAx
MDA2NDQKPiAtLS0gYS9kcml2ZXJzL2RheC9idXMuYwo+ICsrKyBiL2RyaXZlcnMvZGF4L2J1cy5j
Cj4gQEAgLTQ0MSw4ICs0NDEsOCBAQCBzdGF0aWMgdm9pZCB1bnJlZ2lzdGVyX2Rldl9kYXgodm9p
ZCAqZGV2KQo+IMKgwqDCoMKgwqDCoMKgwqBkZXZfZGJnKGRldiwgIiVzXG4iLCBfX2Z1bmNfXyk7
Cj4gwqAKPiDCoMKgwqDCoMKgwqDCoMKga2lsbF9kZXZfZGF4KGRldl9kYXgpOwo+IC3CoMKgwqDC
oMKgwqDCoGZyZWVfZGV2X2RheF9yYW5nZXMoZGV2X2RheCk7Cj4gwqDCoMKgwqDCoMKgwqDCoGRl
dmljZV9kZWwoZGV2KTsKPiArwqDCoMKgwqDCoMKgwqBmcmVlX2Rldl9kYXhfcmFuZ2VzKGRldl9k
YXgpOwo+IMKgwqDCoMKgwqDCoMKgwqBwdXRfZGV2aWNlKGRldik7Cj4gwqB9Cj4gwqAKPiBkaWZm
IC0tZ2l0IGEvZHJpdmVycy9kYXgva21lbS5jIGIvZHJpdmVycy9kYXgva21lbS5jCj4gaW5kZXgg
OTE4ZDAxZDNmYmFhLi43YjM2ZGI2ZjFjYmQgMTAwNjQ0Cj4gLS0tIGEvZHJpdmVycy9kYXgva21l
bS5jCj4gKysrIGIvZHJpdmVycy9kYXgva21lbS5jCj4gQEAgLTE0Niw3ICsxNDYsNyBAQCBzdGF0
aWMgaW50IGRldl9kYXhfa21lbV9wcm9iZShzdHJ1Y3QgZGV2X2RheCAqZGV2X2RheCkKPiDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGlmIChyYykgewo+IMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGRldl93YXJuKGRldiwgIm1hcHBpbmclZDog
JSNsbHgtJSNsbHggbWVtb3J5IGFkZCBmYWlsZWRcbiIsCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqBpLCByYW5nZS5zdGFydCwgcmFuZ2UuZW5kKTsKPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJlbGVhc2VfcmVzb3VyY2UocmVzKTsKPiArwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJlbW92ZV9yZXNvdXJjZShyZXMp
Owo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGtmcmVl
KHJlcyk7Cj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
ZGF0YS0+cmVzW2ldID0gTlVMTDsKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqBpZiAobWFwcGVkKQo+IEBAIC0xOTUsNyArMTk1LDcgQEAgc3RhdGljIHZv
aWQgZGV2X2RheF9rbWVtX3JlbW92ZShzdHJ1Y3QgZGV2X2RheCAqZGV2X2RheCkKPiDCoAo+IMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcmMgPSByZW1vdmVfbWVtb3J5KHJhbmdlLnN0
YXJ0LCByYW5nZV9sZW4oJnJhbmdlKSk7Cj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqBpZiAocmMgPT0gMCkgewo+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgcmVsZWFzZV9yZXNvdXJjZShkYXRhLT5yZXNbaV0pOwo+ICvCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcmVtb3ZlX3Jlc291cmNlKGRhdGEtPnJl
c1tpXSk7Cj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
a2ZyZWUoZGF0YS0+cmVzW2ldKTsKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqBkYXRhLT5yZXNbaV0gPSBOVUxMOwo+IMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHN1Y2Nlc3MrKzsKPiBkaWZmIC0tZ2l0IGEva2Vy
bmVsL3Jlc291cmNlLmMgYi9rZXJuZWwvcmVzb3VyY2UuYwo+IGluZGV4IGRkYmJhY2I5ZmI1MC4u
YjE3NjNiMmZkN2VmIDEwMDY0NAo+IC0tLSBhL2tlcm5lbC9yZXNvdXJjZS5jCj4gKysrIGIva2Vy
bmVsL3Jlc291cmNlLmMKPiBAQCAtMTM0MywyMCArMTM0Myw2IEBAIHZvaWQgcmVsZWFzZV9tZW1f
cmVnaW9uX2FkanVzdGFibGUocmVzb3VyY2Vfc2l6ZV90IHN0YXJ0LCByZXNvdXJjZV9zaXplX3Qg
c2l6ZSkKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBj
b250aW51ZTsKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoH0KPiDCoAo+IC3CoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAvKgo+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqAgKiBBbGwgbWVtb3J5IHJlZ2lvbnMgYWRkZWQgZnJvbSBtZW1vcnktaG90cGx1ZyBwYXRo
IGhhdmUgdGhlCj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAqIGZsYWcgSU9SRVNP
VVJDRV9TWVNURU1fUkFNLiBJZiB0aGUgcmVzb3VyY2UgZG9lcyBub3QgaGF2ZQo+IC3CoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgKiB0aGlzIGZsYWcsIHdlIGtub3cgdGhhdCB3ZSBhcmUg
ZGVhbGluZyB3aXRoIGEgcmVzb3VyY2UgY29taW5nCj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoCAqIGZyb20gSE1NL2Rldm0uIEhNTS9kZXZtIHVzZSBhbm90aGVyIG1lY2hhbmlzbSB0
byBhZGQvcmVsZWFzZQo+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgKiBhIHJlc291
cmNlLiBUaGlzIGdvZXMgdmlhIGRldm1fcmVxdWVzdF9tZW1fcmVnaW9uIGFuZAo+IC3CoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgKiBkZXZtX3JlbGVhc2VfbWVtX3JlZ2lvbi4KPiAtwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgICogSE1NL2Rldm0gdGFrZSBjYXJlIHRvIHJlbGVh
c2UgdGhlaXIgcmVzb3VyY2VzIHdoZW4gdGhleSB3YW50LAo+IC3CoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqAgKiBzbyBpZiB3ZSBhcmUgZGVhbGluZyB3aXRoIHRoZW0sIGxldCB1cyBqdXN0
IGJhY2sgb2ZmIGhlcmUuCj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAqLwo+IC3C
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBpZiAoIShyZXMtPmZsYWdzICYgSU9SRVNPVVJD
RV9TWVNSQU0pKSB7Cj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqBicmVhazsKPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgfQo+IC0KPiDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGlmICghKHJlcy0+ZmxhZ3MgJiBJT1JFU09VUkNF
X01FTSkpCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
YnJlYWs7Cj4gwqAKPiAKCg==
