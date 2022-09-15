Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3053D5BA047
	for <lists+stable@lfdr.de>; Thu, 15 Sep 2022 19:13:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229545AbiIORN4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Sep 2022 13:13:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbiIORNz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Sep 2022 13:13:55 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE82F98371
        for <stable@vger.kernel.org>; Thu, 15 Sep 2022 10:13:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1663262034; x=1694798034;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Lgo7oNHJc9e4LTVWR4dGO+3HO3XIddZDIxeinnrpey4=;
  b=g6qdausv65273AgZj3H3ItUScC5jDLxMIpsDpIeqeD5I87VBNvzpDzYm
   3dMFoylKIFjqUCcf7XKIXbccCbJM7qS5fY2VNrzXdPb6S4xSCcupLZ7t0
   fy27Ptuv6Ff0ru9/o+uZhy8XVUD6MDY0YeE2wrNweZwxbQkR9++w5wHEm
   wXg82YytijCJi7rbJWMQWYdRVbf9Oh+hQzFrpffUz5augb2bfVfm6a3WP
   b5NU09ixHJr7OIrVpAekKWcelpFF27Fe8lc/U6eByPzdgb86uvRgUOfrY
   Bjhwsi+h6TuhKn0qQySZhKdKgUQfTrs+XKdJZ3qi60RCteRHWFbM+0voi
   w==;
X-IronPort-AV: E=Sophos;i="5.93,318,1654585200"; 
   d="scan'208";a="177355895"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 15 Sep 2022 10:13:53 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Thu, 15 Sep 2022 10:13:54 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12 via Frontend Transport; Thu, 15 Sep 2022 10:13:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aueMBf+dfVT4XB9Zp8jecCK40bYNlVygVDRnenOu2KdtN9ZkXLq196nJu9NujeLVG1l/Cv7wiy24/d/yyW+YFnpUzx/E4XTeusLktmCQiM3d60fRt7R8vppxZ5pSG7HOzRVY/NjkvWg2iV8ZT+QtyNfPKiYMP+Dqvn14amDsCDoffDhjoW7ml0CKGXezhFutEB45J1kLw8cdWjZP74KC0hPwQnJISwwHgSpcQ2NyIDTbPURNo+I9lEzpjpYaLJFlMM+KRDBHaqRfruScIL6h98K42y5vtB+3M6aqyYuw3ZD5nhZcA1ilcIz2531tOJOjFB+OVu1elrx/8CtpSgsCtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Lgo7oNHJc9e4LTVWR4dGO+3HO3XIddZDIxeinnrpey4=;
 b=Ca/0RQxY1OnlRHibG5bxwY+c/FOv6b14/U66UeSVKCcdC2NXZJIm9PqfaJUXk6shrZo5ZMQrNTWMmB4UL3A6c3b542JshETOV93gSohvcO7dfF8amhNPCk8wFp8TIxOKIlnRE9HEDRu/hgkD2EMxFZbjet52OM4jAwfhdd6oY0zt9GLWCb9ybZN5qSuR5RMRMTA1/PbJNiCSE1OiieW2KZdJBFbDYSaV+SmDt8ZO519a9NgPeMlrLsKsl4ZN3EiA7YefGfCG4URpi/xslpVeKt29ZqKrDOttkWzVGXKCMTlbNi1X3tgWtWIzNsORVSAsGcSxudblmnFaU9zhvsG/Pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lgo7oNHJc9e4LTVWR4dGO+3HO3XIddZDIxeinnrpey4=;
 b=Ub1fLefL6BZNcXdT1nhai9zaV7MBAH3+T5YMNHui77riPLHwjXJSBT2nhLODUZ4X68hnqCkGfY7mmF+VZfqeXx2GP5Hd0NfKR74KsDh4UX0ebqOAN6cvcgjo5NiZtYj9MD1exNDXYtCO5UHG8qHKaYWxLLOhCivkBkHHYm3KnlE=
Received: from CO1PR11MB5154.namprd11.prod.outlook.com (2603:10b6:303:99::15)
 by BL1PR11MB5286.namprd11.prod.outlook.com (2603:10b6:208:312::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.15; Thu, 15 Sep
 2022 17:13:49 +0000
Received: from CO1PR11MB5154.namprd11.prod.outlook.com
 ([fe80::545a:72f5:1940:e009]) by CO1PR11MB5154.namprd11.prod.outlook.com
 ([fe80::545a:72f5:1940:e009%3]) with mapi id 15.20.5632.015; Thu, 15 Sep 2022
 17:13:49 +0000
From:   <Conor.Dooley@microchip.com>
To:     <palmer@rivosinc.com>, <linux-riscv@lists.infradead.org>
CC:     <stable@vger.kernel.org>, <lkp@intel.com>,
        <Conor.Dooley@microchip.com>
Subject: Re: [PATCH] RISC-V: Avoid coupling the T-Head CMOs and Zicbom
Thread-Topic: [PATCH] RISC-V: Avoid coupling the T-Head CMOs and Zicbom
Thread-Index: AQHYySX04J3T8cLKWE+kVDCBPlpova3gur0A
Date:   Thu, 15 Sep 2022 17:13:49 +0000
Message-ID: <4d943291-f78f-31ed-0d67-7073e1f762e2@microchip.com>
References: <20220915170900.22685-1-palmer@rivosinc.com>
In-Reply-To: <20220915170900.22685-1-palmer@rivosinc.com>
Accept-Language: en-IE, en-US
Content-Language: en-IE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO1PR11MB5154:EE_|BL1PR11MB5286:EE_
x-ms-office365-filtering-correlation-id: 62ae44ad-a70d-48d4-6fe3-08da973da7d0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Lcw/rWun3B0FV5MEhtvoNbWdN26sUbqSSAX9hDzB2yUOWl9Pjqek3UO6kGCOQORV5A8Gflcj4N2BwWVmeZNpFQJyBLf/3LJXsMg6wjDfxy8Tq/yLdEzzOdBXXvYb8bCCVjzH8SIvBbyHsJpcj33cWzXkgQCGoATqFciFyOfOLM0VaxA8pK2D3o9lJQCSsUlr4oBF+ZUeLxo6Fp0xRyUjERQ8erjKokTkRT/DcyK2ivXV1W3K7mfqhjHHuPfeNj7YUG98G6w3hes49UJVKSy6xi5w/F0R486mGzl/Bhjhd0ysXN6K+jajEtNeV76tGySPnsTqNmTTMPy/I+SHnY5phyxrFfs9X74Yg3Pj33hgfbJc+CTjbM+wU2yN1Mw9LnhNrq8f+auM6/YxxymgRN3A7w6ggiW2MC1PdzQsWbZf2z4r+XAVGikfvCS/GQGWlnsVTdX9ZfHwnyI5Q1xoJWncP5bykNoNCIjlibORNPYVZFPWc1z8FFXfiBfjdFFLNipXeoroobbnNwldDy60N2/4ESFW7hrzw42FHTEtxoYmAnhc2JuEpQnfBLYcvmYLxmGoCEyEFzBeDPDStZDivDACpK7VtWLostmzrVEMcM2PG73zNHtBC4FgsIqhqvShS4xc6JOR2Gkbtp9YGVsSRXtF60IkBAQOKoMT8E/q38yefSnncrHVZzvDLUGq4Q8yiKCKwNHiHKC/SYt+wjxTEPMaHGFDvX+sle/CkP+PvnyDdZ9MePSB6adukrz2SVS+QvODlDW4af75SQHJYD0l8o9K/ZKjeZJ258O6Zi6CRUCZwYSNFtZKwOYjoVkQr2qc6GK/qMZ+YoQHRjRxzkvpMayZGg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5154.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(346002)(136003)(39860400002)(376002)(366004)(451199015)(91956017)(76116006)(66946007)(66476007)(66446008)(64756008)(66556008)(31686004)(4326008)(54906003)(6506007)(316002)(8936002)(110136005)(31696002)(86362001)(5660300002)(8676002)(41300700001)(38100700002)(71200400001)(38070700005)(2906002)(122000001)(6512007)(36756003)(478600001)(6486002)(53546011)(186003)(83380400001)(2616005)(107886003)(26005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dDZxemRCYTAvUHB1NVZidTJvVWplZWVyUWcxZUNDSGpRWHh1MVo5RUZOOTlV?=
 =?utf-8?B?YU5tWUQvRVJ4SEtGbEFjZlREcnlBL2NuRlk1b0YyUHdBcTN6R3doeW9EREJV?=
 =?utf-8?B?T3BwZ1A5TlVDSjVNTjNQWmZXVEZKQkdYN3hYTGRoTEpLVThWVndMalZvT0tE?=
 =?utf-8?B?MzFnRnJJU1VnZXhjb3FTa0t3bS9pVGdKdHcwSjZGVk03NDlEcTJUb2w1SSs4?=
 =?utf-8?B?K3JHeXQzUnA5TDcwU0k1dGt1VGhXTnhKcjRBWUZGVnBVL3RPOURWZU8vZnYz?=
 =?utf-8?B?d1lzY3YvRE90dEZOYTVKU0ZORFRtVzFsR1pETmVuSDgwZkMxaHA3NUJ3dkNH?=
 =?utf-8?B?RjlQM1RvQmtjTTJkR204QUkxOE9xR0NPVUJaTSt4TEduWk92dDZzM0JqeTZz?=
 =?utf-8?B?TXdQUUMyYmdERFNqcHJlL29wazZpVUExdFUvNURhVnlhYkV4dTN2VkZTOXJ6?=
 =?utf-8?B?TElYMWJua2doU3V1VDVYNUFTbnR2L1ZOVDY5MmdHQ09IbzI2eFovTlBXeWFO?=
 =?utf-8?B?aVBnVFNFSEJVb05ab0diU3RuTE9uNzUvVzgwY2ZoSFFDd0Zid0hzbFpHRC8r?=
 =?utf-8?B?TUM3THQvTkdmL0YxcS9aR29PbDhTWG5KdW9TeHF3TThPOHhzNExNcEZzT0U2?=
 =?utf-8?B?aWIxcVBLRHpYeWpiYVZFR1RrVmJRQTZUdkxvTCtsSkphN2k4aHBDQ2tjUWNP?=
 =?utf-8?B?bXhncDhYSjV0K1RaN0VWVUVVS0M4RWJ0QVdrZUVFWHFlMExiQW5tbGtRbUpC?=
 =?utf-8?B?VnZaUWRaMy82S05DUTBVZ0FtUGRIeEhZZHdZajl3cVQ5Vys3NmpSc0ZZR1Ri?=
 =?utf-8?B?NG1pNkl0OEdWOGJobnM5WWlDNUN1WXlRR20yNzViTk82WVVCMnVqOFVnSUJH?=
 =?utf-8?B?RUpYbWlMRWN4Nk05NEd0dTFzakFodlZxSkozek9zMExuQlJCUGIzdEZTb2hU?=
 =?utf-8?B?ZkJkMnFiNTh2VWx3Ui9TWDRkL0ZHdXE3RzVRbjdFbWw3R2tpUFphdnFVeCt3?=
 =?utf-8?B?Ulh6cjAzc3dhdk54VEtXdmZ5UnhSSC9LWkkrQ2JWdE9sSStRbGdsN1VvcGJW?=
 =?utf-8?B?MEs3VjZHNmE5eWhzTmljNUV0cHZRcWprbURNcDZpeDloR0QyRVVudFFkNFZs?=
 =?utf-8?B?dTJxM1RiNC9GVk1rS3NFaDBhSTRFV3QwVEdhTzErT3BPOVRwaU5SaHltc3pa?=
 =?utf-8?B?ZzNHWFB0bGovZk9tc1J1NXpuZFpob21pQTdvWjNXMFFaU3VnK0tSaUF0dldR?=
 =?utf-8?B?Wm9hK3drM0Z3NHpKRjAxcVlnb0toRFBVWld1VFNoWnJkWE56ZmRSTk1JQU9o?=
 =?utf-8?B?S1NwNUdxY01oSWtZeHFQU2NEOWZLc3FMUE9JZDhwNU5Od0JiODlQaXRhTGRB?=
 =?utf-8?B?dGFwWW01OTVyUkVKZUg0dUFzV0t4RnNGSGl0dHY4eEVNUmhWRG1VbGY4RTE1?=
 =?utf-8?B?Y3JMTzdTMGtia0tTcGl3bW5aUVk4bUtUS2F0Z3UvZjdOSWM4UitOd1NRdjMv?=
 =?utf-8?B?a3EwTHNpQXByRlVyOStqSkdVY2kwTHprTWNWaGt6NXRvbllXRDNZMUdxbkt4?=
 =?utf-8?B?YzVDVlZNTm5ENEdES29GYXVvdmg0SHBVeUpaWVVmc1N4TEJ6NTVzbzgrQm1w?=
 =?utf-8?B?OVBFbEZxd1RkcHlvZlJRKy9FL0JZQWZDME5laWN0emI4YTBDRFlIbmF3ampm?=
 =?utf-8?B?SklTVDV2bG85WDc3V01BTmRIL1NNNDRkNkJaT3NDUTRPKzl1N2ZVVEpUcWpI?=
 =?utf-8?B?eFRITkpNS2srd3g5NlJoVXJwL2lHZXdhc3Q1UG5pK2x2Y1FOZkE3ZlR6TW92?=
 =?utf-8?B?SEFQWjFWK2c5bXdrUXI2clFZSk5pQmRuQUNKa1VESkU2bmFycFJDQWRrK2la?=
 =?utf-8?B?bTNRZFJ2TW9Jam1PMXMzMnlNNE5TMmNmT0JFV3NraFlTTjBqUnRYekxpeWlk?=
 =?utf-8?B?cVdjVkZOc2tFL1pPMSt3MHluWGhzZDUxNjdDVEw3N3R0NXppVnFZRVh4Z0sy?=
 =?utf-8?B?dTIwY3FUcTAzMlFISWNGMU1Ha3BHUityV2lJWkhIZTdBL1ZDWmRJV0ZIUFVP?=
 =?utf-8?B?dURKU2xCRWEvWXQ4OTFWVHdNaGNYUmN4RkdnbUs0Q2l2VTRBUWh0QzFIMFh1?=
 =?utf-8?B?dWJhVnZmaFFFOUJnNzVBRzlHNTZpbSs1Q0RCaUlZYSt5UGxoSzdCMnJYcU5E?=
 =?utf-8?B?Tnc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <78F9AB1B71A4EC41A7678A50FD8F1EC4@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5154.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62ae44ad-a70d-48d4-6fe3-08da973da7d0
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Sep 2022 17:13:49.0444
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OZv577JelyRGCN2F7vcW7qKzEvcGK9tzSMgb0vdnX4OFviGuveOonQZj7Gf2Rw2sHJD9i/KBch4k3NOfiyurMfMBfWyV/dlGXnFJJO9neLg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5286
X-Spam-Status: No, score=-6.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gMTUvMDkvMjAyMiAxODowOSwgUGFsbWVyIERhYmJlbHQgd3JvdGU6DQo+IFdlIGNvdWxkIG1h
a2UgdGhlIFQtSGVhZCBDTU9zIGRlcGVuZCBvbiBhIG5ldy1lbm91Z2ggYXNzZW1ibGVyIHRvIGhh
dmUNCj4gWmljYm9tLCBidXQgaXQncyBub3Qgc3RyaWN0bHkgbmVjZXNzYXJ5IGJlY2F1c2UgdGhl
IFQtSGVhZCBDTU9zDQo+IGNpcmN1bXZlbnQgdGhlIGFzc2VtYmxlci4NCj4gDQo+IEZpeGVzOiA4
ZjdlMDAxZTAzMjUgKCJSSVNDLVY6IENsZWFuIHVwIHRoZSBaaWNib20gYmxvY2sgc2l6ZSBwcm9i
aW5nIikNCj4gQ2M6IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcNCj4gUmVwb3J0ZWQtYnk6IGtlcm5l
bCB0ZXN0IHJvYm90IDxsa3BAaW50ZWwuY29tPg0KPiBSZXBvcnRlZC1ieTogQ29ub3IgRG9vbGV5
IDxjb25vci5kb29sZXlAbWljcm9jaGlwLmNvbT4NCg0KSSBidWlsZC10ZXN0ZWQgdGhpcyBsYXN0
IG5pZ2h0IHdoZW4gSSBhY2NpZGVudGFsbHkgZm91bmQgaXQgc286DQpSZXZpZXdlZC1ieTogQ29u
b3IgRG9vbGV5IDxjb25vci5kb29sZXlAbWljcm9jaGlwLmNvbT4NCg0KPiBTaWduZWQtb2ZmLWJ5
OiBQYWxtZXIgRGFiYmVsdCA8cGFsbWVyQHJpdm9zaW5jLmNvbT4NCj4gLS0tDQo+ICBhcmNoL3Jp
c2N2L2luY2x1ZGUvYXNtL2NhY2hlZmx1c2guaCB8IDYgKysrKystDQo+ICAxIGZpbGUgY2hhbmdl
ZCwgNSBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvYXJj
aC9yaXNjdi9pbmNsdWRlL2FzbS9jYWNoZWZsdXNoLmggYi9hcmNoL3Jpc2N2L2luY2x1ZGUvYXNt
L2NhY2hlZmx1c2guaA0KPiBpbmRleCBhODljMDA1YjRiYmYuLjI3M2VjZTZiNjIyZiAxMDA2NDQN
Cj4gLS0tIGEvYXJjaC9yaXNjdi9pbmNsdWRlL2FzbS9jYWNoZWZsdXNoLmgNCj4gKysrIGIvYXJj
aC9yaXNjdi9pbmNsdWRlL2FzbS9jYWNoZWZsdXNoLmgNCj4gQEAgLTQyLDggKzQyLDEyIEBAIHZv
aWQgZmx1c2hfaWNhY2hlX21tKHN0cnVjdCBtbV9zdHJ1Y3QgKm1tLCBib29sIGxvY2FsKTsNCj4g
IA0KPiAgI2VuZGlmIC8qIENPTkZJR19TTVAgKi8NCj4gIA0KPiAtI2lmZGVmIENPTkZJR19SSVND
Vl9JU0FfWklDQk9NDQo+ICsvKg0KPiArICogVGhlIFQtSGVhZCBDTU8gZXJyYXRhIGludGVybmFs
bHkgcHJvYmUgdGhlIENCT00gYmxvY2sgc2l6ZSwgYnV0IG90aGVyd2lzZQ0KPiArICogZG9uJ3Qg
ZGVwZW5kIG9uIFppY2JvbS4NCj4gKyAqLw0KPiAgZXh0ZXJuIHVuc2lnbmVkIGludCByaXNjdl9j
Ym9tX2Jsb2NrX3NpemU7DQo+ICsjaWZkZWYgQ09ORklHX1JJU0NWX0lTQV9aSUNCT00NCj4gIHZv
aWQgcmlzY3ZfaW5pdF9jYm9tX2Jsb2Nrc2l6ZSh2b2lkKTsNCj4gICNlbHNlDQo+ICBzdGF0aWMg
aW5saW5lIHZvaWQgcmlzY3ZfaW5pdF9jYm9tX2Jsb2Nrc2l6ZSh2b2lkKSB7IH0NCg==
