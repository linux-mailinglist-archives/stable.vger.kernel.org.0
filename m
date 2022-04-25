Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 418F050E37F
	for <lists+stable@lfdr.de>; Mon, 25 Apr 2022 16:42:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242547AbiDYOov (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Apr 2022 10:44:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242532AbiDYOou (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Apr 2022 10:44:50 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94C9322BF4;
        Mon, 25 Apr 2022 07:41:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650897705; x=1682433705;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=RMF+C8GZel/c7js2b0p58T6SU016R38xUWBLR3QlpoU=;
  b=QuUSuAGIRenE1LIZEHmGj8QcR85H+Z/U8wOcDzJ6QUkU5GAlBe05Ll7p
   PGSIctVR2LbpIzMbwNr2Wp8aeGUSzEGLPxLaf/3vsuW4b8z6oYwAkXGt0
   LVQYc1bOOlVo+o41WSYnsnoQ8Tsj/oI8bCHD87BEnCdzaPpWZqvtHcJsK
   Ec3s5wSJ8i/9b37kmuMaqYzEpBx7nbfx1EDP6qp/5uy2rm8xWrrfsB0Pf
   G5GTnxjUMMZzPnY/2+HdIZpy5mo30bcMARolD1+oPrPEfTfu5P7yl8ogr
   rpG+7LF7rzqJPlN8/yx3yCx+SvmAhAcZVf7ZggwuVtC1R9sFTehDxEf7N
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10328"; a="351712223"
X-IronPort-AV: E=Sophos;i="5.90,288,1643702400"; 
   d="scan'208";a="351712223"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2022 07:41:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,288,1643702400"; 
   d="scan'208";a="595263974"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by orsmga001.jf.intel.com with ESMTP; 25 Apr 2022 07:41:44 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 25 Apr 2022 07:41:44 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 25 Apr 2022 07:41:43 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Mon, 25 Apr 2022 07:41:43 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.173)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Mon, 25 Apr 2022 07:41:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OC/BGjh0AC08EE2yoFNnL7sGkCoRzFYwVLrSNpEd+LmM+LrahoPCHUECmN/7i9dCRFp4WVJ8sPFtXbopl0DXvoX9u5tesDuANPt+sT1ahFQY0Uf3n6kyif2mqqVexCQwZOm2wLgOl1bQ3x7iBBP8PtgxnBhLACovZIw0KHkVl/CjsQK1D5fKXd6DJCXp8CjwZxB+P6AXE0qxyUSPu0ksveBHQLYzTr0mKvAtr2tTBxDsiSLGNr0ljl+A+hBfDmidTvV7PEhh/i4uL26l6e6aPnbJycmeIEUp7NWePQuH2tFFIixjNFiIVJWYsxqthf9wIpaqqy0u2rgbaRRKas2mlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RMF+C8GZel/c7js2b0p58T6SU016R38xUWBLR3QlpoU=;
 b=Ph+XCsU9fOT55sMgp+Ow7/rliY/OzvBg5lukJb+VAYYjAv7hi9fbhzBOHklsWvGWFcy5avKXdmNm+nJnNlUUBM5CzuzfDX/554FEQzKM5jQ137njIjKgyMFIlRkObixJ9GDtFUt98/YRsw5NjMqltDyXt24rfkisIOosFzz3K9TTNFAvwntD4eTlU3lHyRv2XcVpsXGpgxGGUav+NxFTZ+jNWF2zwj06iqZZGekZWU7l2uYnPlRhTdcQniwoT0qAi5r6yt68ls27kxltlxVpQS52D6tSLD5HLkDlcVFIELP2IS1BgHQQ4y06NLWK/hdZIlj18ymzZlLIPRtjH60Q5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SN6PR11MB3055.namprd11.prod.outlook.com (2603:10b6:805:dc::18)
 by MWHPR11MB1535.namprd11.prod.outlook.com (2603:10b6:301:d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Mon, 25 Apr
 2022 14:41:40 +0000
Received: from SN6PR11MB3055.namprd11.prod.outlook.com
 ([fe80::f0ad:94c3:5f16:3c2f]) by SN6PR11MB3055.namprd11.prod.outlook.com
 ([fe80::f0ad:94c3:5f16:3c2f%7]) with mapi id 15.20.5186.021; Mon, 25 Apr 2022
 14:41:39 +0000
From:   "Alessandrelli, Daniele" <daniele.alessandrelli@intel.com>
To:     "Murphy, Paul J" <paul.j.murphy@intel.com>,
        "jacopo@jmondi.org" <jacopo@jmondi.org>,
        "mchehab@kernel.org" <mchehab@kernel.org>,
        "bryan.odonoghue@linaro.org" <bryan.odonoghue@linaro.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "sakari.ailus@iki.fi" <sakari.ailus@iki.fi>
CC:     "hfink@snap.com" <hfink@snap.com>,
        "robert.foss@linaro.org" <robert.foss@linaro.org>,
        "vladimir.zapolskiy@linaro.org" <vladimir.zapolskiy@linaro.org>,
        "dmitry.baryshkov@linaro.org" <dmitry.baryshkov@linaro.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "jgrahsl@snap.com" <jgrahsl@snap.com>
Subject: Re: [PATCH v5 1/4] media: i2c: imx412: Fix reset GPIO polarity
Thread-Topic: [PATCH v5 1/4] media: i2c: imx412: Fix reset GPIO polarity
Thread-Index: AQHYUMBclZbxrTrjN0W37Oro/4KcfK0Aw6GA
Date:   Mon, 25 Apr 2022 14:41:39 +0000
Message-ID: <c8aa1666e223f6ccde80887654b35a574c455967.camel@intel.com>
References: <20220415115954.1649217-1-bryan.odonoghue@linaro.org>
         <20220415115954.1649217-2-bryan.odonoghue@linaro.org>
In-Reply-To: <20220415115954.1649217-2-bryan.odonoghue@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.40.4 (3.40.4-3.fc34) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 80611839-76e2-427d-3a30-08da26c9b4e3
x-ms-traffictypediagnostic: MWHPR11MB1535:EE_
x-microsoft-antispam-prvs: <MWHPR11MB15357EF98EB3DCB5E22DE6A1F2F89@MWHPR11MB1535.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GoBpQnFwzcp2QheKdsN2xhTyRuQtz4izcByDWjSIXCmpF9TEpw1m13Wi2rxafoOreDuFGf3U5YmlWN6hxb9CbiNLjg0i2DsXVdWX+YCmxvhDM9dckP4FbNELgq4ygf5qycBUWQIaS8/MFi4/tXMMa2INk9F4PrWKRYv6KzsVU/17gKhS6W4GureezY9jSRP1eanpfdvKMbth/yqFHNRwupBLMFgihxDMPB8qyQL4r1kRj3tpjdaNxYAGxDhephkyv68XSoUM9yYtLznQRvgPr2vqAUsb2BjJu+Gn2zcp6oxPGdM8QYT75v02kfUr+ViRg7pIOYXqnKsaOjwbOdD3CJhNl4wTD5/N0+9pQ7eY6xEyOHv+ghWhjWowVvF02ml5goMv/vU8QEkOpt68CuajmU1tPCTDnMC25gs4ehAxl8B/d7+VkTOjJzFXGXPBw7LbwtmtVZZOCEnRE0sxHnSB91Gmlos7Iydss5Z6EVm8wdazEKzJ0EXu8QRTHAr5I4E3jH5gNVtnrTiNShYJhvtU0yGXJFXxCUG3Zt3EaTZUhwUoUZhzOd/JvhdhlT9hPRxa1wanW9+2nRvAPPElmLcJ28FASl18oRFwyafyv/OY/vfv4xO91dB9+8yQ1DKAblHjUxTQa+WCViERhNcKxUu+87xzxVQmFkDllAs9p5xfVOSZyI5NAafdRxVwOT7V2Ckff9bxjBwWs/eZ6Erb5zzyNw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3055.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(4326008)(26005)(5660300002)(66556008)(186003)(6486002)(66446008)(8676002)(66476007)(64756008)(54906003)(71200400001)(110136005)(36756003)(8936002)(91956017)(76116006)(66946007)(6512007)(316002)(6506007)(7416002)(508600001)(83380400001)(2616005)(82960400001)(86362001)(38070700005)(122000001)(38100700002)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WXZNK3FrR0ZjeWJINHJLZWVvVW1hUDRIS0hHTyt5N1hCbHdscWVmM0dUVFJS?=
 =?utf-8?B?dGUwTkVGdEhPaFBKMFZpYWRUYkE5b2h3RTJtK0tRNHZQajZ3b3BiU2pyNldx?=
 =?utf-8?B?VUYwTHZjeVZiVEk1Ykh3SnY1a3Bqc3Q0aUJ1VjdOdUUwUGtVU3JPRWk4L3U2?=
 =?utf-8?B?RlVzaTgzNHh4WXYybzJRNWs3aDBBMldzSWNvT3l4eTI4NEMzWEJ0Vm42cURl?=
 =?utf-8?B?WXFWVDQvMEpnc0FxcHhkbTE4VmkzQ0wxdFd1MU5OSDBrSytuV1pTOEh1Z2RP?=
 =?utf-8?B?ZDZHcGdYRklzS0ZKbXp1YktqTDAxV2VrbDBsOS9EV3N3TVhzY0R0SFQ4QWtG?=
 =?utf-8?B?SjI1M2d1ZFBIRnZYNWVKUmpiMVVNd2tUd2NpT1U2UTlMdVB0Qy8vV3NlSlRk?=
 =?utf-8?B?aWwvNjYzTWo5NGMzbWYxRjFOQ2o1c1h6N3ZyVlpLQzVza25BVXUvdGNBeUhE?=
 =?utf-8?B?Y0Q5SlI3MXBBQXFxMzlWcDNMSmJOZmJsbDRBWnJZVDZzQjM1VlBXOUJrVTJC?=
 =?utf-8?B?UkpnNlVWZTRtUGZGait2OGJQdER1THlEMVc2VUM5WnVFRlQzYzZMSUt6Z3ZL?=
 =?utf-8?B?UUN4YUhyVEtoRFZ6T0RxN0hXSTdxbUFRVjlnS3dzbGYrdEZDRjZVYUo3L3l3?=
 =?utf-8?B?cjBBOC9qYUtmelVXaHJkMzg4ZDdtSmpSSzB0bXIrOVJkZUJ3ZG9yYlhwVFlY?=
 =?utf-8?B?MXZDQVpFOUF0cW5kUjN4M2pRNnRNOFN4S08ySEhOa0lsUXpJbzJoUW5XeHk0?=
 =?utf-8?B?bzdCd3NOS3RCS0FIUEYvVnRDcWZTaWNhNjZ3SnFQdnlpSU5lc0x6T1R6SDQ1?=
 =?utf-8?B?S0lvSG8xN0oxb0gybGRKZjBHcTlrRmVjL2FJYkI3R2xOZ3lwMGJZOVlWRmsv?=
 =?utf-8?B?Y3g1MDRTLzdYTktRbklpQ3RlUE11TGZYNHcvZ0ViQkpxRytrRTU2ZFM4QzZV?=
 =?utf-8?B?eVEvbTFaWU01Um5wcHZqLzRNdlpyZUlJTzBiNkIxRmtmS0pQSVRpYTNGS1ZZ?=
 =?utf-8?B?TWpUN3BCbEExSGl1WU10N0tNb0g3dnZVTlJ1dE12L09oS0NJejI4OXh5anpW?=
 =?utf-8?B?QUFFQncrbSsycGFIaDhBcWdrQkEvWHdiWVQyc3NXMWYrOUZ3VGVwWWZ1V1BB?=
 =?utf-8?B?QlQwVktTSWJkZENOR1VKZTFWTE9RUmJqeUxveTRBd2gwV0tSNE5EZUIvbEk2?=
 =?utf-8?B?S3VXRC9IRThhZ2JqclNaempKWEF1ajBzRVpRVGFKMGx6aUpFWnVYU0laOGk3?=
 =?utf-8?B?cW1xcWNHTWZiQ3JTSk96STY5dDlINnVma291SGdqU1RsK1laSHB5OG9jZHZW?=
 =?utf-8?B?VzRzMlpJeGd0NUxPdWYzMkNCRG0vUk4zR0ViSm9FWkozbjB1MHI4YmxGOExp?=
 =?utf-8?B?Q3AwQzJRTitmcEpwZG1TVlhzZ3lHL3VhdXUwY29wQVRPSXpMR2NMLzdTVEZU?=
 =?utf-8?B?QytRS2pjS1RKWVhVNVc4MEdYdXNiaGVsT0dLN1RSM0ZmTXRUb0szVlBhcFR3?=
 =?utf-8?B?dnRKTEJOb0NQRFNKenBSR3pla1dPWFNmUXpHclNzZlhJY1h6b2pQWjRhRzlT?=
 =?utf-8?B?OHNRL1NXRzhyV1JJc3ovV3pIYitoOWpka0ZvbHdkS014U0c1eVlBY1I2VkR6?=
 =?utf-8?B?YjhrZWtKemlPSFB2ZXVKR2xOR3RTTFppRVJMa1dmR2JEclFkOHVqdzZ0L0hw?=
 =?utf-8?B?YzRhcGhLeW5Cd1ppSnJUN21iS1IrK2xmQi9Yazh1V2N1eWFTNzBWdGw1YzNR?=
 =?utf-8?B?b0JSb0x4YUUyNlRMQWVsQTBneVh1RlJEc2luSm1IRktlZ3R6OGtLcXpjSThw?=
 =?utf-8?B?bXIxUVZBcXJJcC9SRFdqZnJzQnRyd0x0WS9heHZFQjgrdlRKWU1MWVd6VnNQ?=
 =?utf-8?B?RG9OWGQrM0FOeHVKakk5dVpCRGp6VlFFNWp6bEZsVjBLbkdFREtiUyttNmpU?=
 =?utf-8?B?NkpWT0pUdEY1c1FSWTdtZTg3Q2tBcjB3c2kwUnRGV29vcnQ3SmkxbU9WVE9V?=
 =?utf-8?B?MUZtRVR1N0l1T0hOUGpwdTNTQTRYRU5wQThUeUJXUDliR2RCbFdGMHdzN09v?=
 =?utf-8?B?L1V3SjNRRWZuL0t4dVpYUDBaQlJDUS9XOGtBeXVJZ1Z5QmNQYmZzSWRrUEIz?=
 =?utf-8?B?alFKWFJnN2h4S3dUYnhVUXlPUVVxdXBTWG90dTcwN0dxdjk2VzhOYVgvcFdJ?=
 =?utf-8?B?a0V3VlROd0p2djN5L0dkWlM4dkltN0RudEUrMkM5MmFVa0xpaFpGRllqMTV5?=
 =?utf-8?B?RGQyMTVheGg0bzJXbHBmRUg4QjdvQS9kdHRlTUFlb2M2QWhLRUhHbFIvd2sy?=
 =?utf-8?B?dWJrVHZ2M3BPMEd2L2NwWkRob1BjMGFGMlFueEVSL2hFdE8zaVloaHpMVmdU?=
 =?utf-8?Q?wvToR6dlMxRJtm8Ze9WesWKPD6rNM5kU2Hw1z?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BDE2078A9CFB8648BB74C5E3660290E5@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3055.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 80611839-76e2-427d-3a30-08da26c9b4e3
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Apr 2022 14:41:39.1106
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Qo704ascxr8+XunOdbXXkTAQOIYzdA1a983yJyE1u7JwwNMwcdt5nVSvRM2NKiYV0W+t6VIyI9xq0w/EtnG2utKedt5P3oDXmAm1MQFj7c8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1535
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGkgQnJ5YW4sDQoNCk9uIEZyaSwgMjAyMi0wNC0xNSBhdCAxMjo1OSArMDEwMCwgQnJ5YW4gTydE
b25vZ2h1ZSB3cm90ZToNCj4gVGhlIGlteDQxMi9pbXg1Nzcgc2Vuc29yIGhhcyBhIHJlc2V0IGxp
bmUgdGhhdCBpcyBhY3RpdmUgbG93IG5vdCBhY3RpdmUNCj4gaGlnaC4gQ3VycmVudGx5IHRoZSBs
b2dpYyBmb3IgdGhpcyBpcyBpbnZlcnRlZC4NCj4gDQo+IFRoZSByaWdodCB3YXkgdG8gZGVmaW5l
IHRoZSByZXNldCBsaW5lIGlzIHRvIGRlY2xhcmUgaXQgYWN0aXZlIGxvdyBpbiB0aGUNCj4gRFRT
IGFuZCBpbnZlcnQgdGhlIGxvZ2ljIGN1cnJlbnRseSBjb250YWluZWQgaW4gdGhlIGRyaXZlci4N
Cj4gDQo+IFRoZSBEVFMgc2hvdWxkIHJlcHJlc2VudCB0aGUgaGFyZHdhcmUgZG9lcyBpLmUuIHJl
c2V0IGlzIGFjdGl2ZSBsb3cuDQo+IFNvOg0KPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oCByZXNldC1ncGlvcyA9IDwmdGxtbSA3OCBHUElPX0FDVElWRV9MT1c+Ow0KPiBub3Q6DQo+IC3C
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHJlc2V0LWdwaW9zID0gPCZ0bG1tIDc4IEdQSU9f
QUNUSVZFX0hJR0g+Ow0KPiANCj4gSSB3YXMgYSBiaXQgcmV0aWNlbnQgYWJvdXQgY2hhbmdpbmcg
dGhpcyBsb2dpYyBzaW5jZSBJIHRob3VnaHQgaXQgbWlnaHQNCj4gbmVnYXRpdmVseSBpbXBhY3Qg
QGludGVsLmNvbSB1c2Vycy4gR29vZ2xpbmcgYSBiaXQgdGhvdWdoIEkgYmVsaWV2ZSB0aGlzDQo+
IHNlbnNvciBpcyB1c2VkIG9uICJLZWVtIEJheSIgd2hpY2ggaXMgY2xlYXJseSBhIERUUyBiYXNl
ZCBzeXN0ZW0gYW5kIGlzIG5vdA0KPiB1cHN0cmVhbSB5ZXQuDQoNClRoYW5rcyBmb3IgdGhlIGZp
eCBhbmQgc29ycnkgZm9yIHRoZSBsYXRlIHJlcGx5IChJJ3ZlIGJlZW4gb2ZmIGZvciB0aGUNCmxh
c3QgMiB3ZWVrcykuDQoNClRoZSBmaXggbG9va3MgZ29vZCB0byBtZSBhbmQgaXQgd2lsbCBub3Qg
bmVnYXRpdmVseSBhZmZlY3QgdXMgKEkNCmFwcHJlY2lhdGUgdGhlIGNvbnNpZGVyYXRpb24hKS4N
Cg0KUmV2aWV3ZWQtYnk6IERhbmllbGUgQWxlc3NhbmRyZWxsaSA8ZGFuaWVsZS5hbGVzc2FuZHJl
bGxpQGludGVsLmNvbT4NCg0KPiANCj4gRml4ZXM6IDkyMTRlODZjMGNjMSAoIm1lZGlhOiBpMmM6
IEFkZCBpbXg0MTIgY2FtZXJhIHNlbnNvciBkcml2ZXIiKQ0KPiBDYzogc3RhYmxlQHZnZXIua2Vy
bmVsLm9yZw0KPiBTaWduZWQtb2ZmLWJ5OiBCcnlhbiBPJ0Rvbm9naHVlIDxicnlhbi5vZG9ub2do
dWVAbGluYXJvLm9yZz4NCj4gLS0tDQo+IMKgZHJpdmVycy9tZWRpYS9pMmMvaW14NDEyLmMgfCA2
ICsrKy0tLQ0KPiDCoDEgZmlsZSBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKyksIDMgZGVsZXRpb25z
KC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9tZWRpYS9pMmMvaW14NDEyLmMgYi9kcml2
ZXJzL21lZGlhL2kyYy9pbXg0MTIuYw0KPiBpbmRleCBiZTNmNmVhNTU1NTkuLmU2YmU2YjQyNTBm
NSAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9tZWRpYS9pMmMvaW14NDEyLmMNCj4gKysrIGIvZHJp
dmVycy9tZWRpYS9pMmMvaW14NDEyLmMNCj4gQEAgLTEwMTEsNyArMTAxMSw3IEBAIHN0YXRpYyBp
bnQgaW14NDEyX3Bvd2VyX29uKHN0cnVjdCBkZXZpY2UgKmRldikNCj4gwqDCoMKgwqDCoMKgwqDC
oHN0cnVjdCBpbXg0MTIgKmlteDQxMiA9IHRvX2lteDQxMihzZCk7DQo+IMKgwqDCoMKgwqDCoMKg
wqBpbnQgcmV0Ow0KPiDCoA0KPiAtwqDCoMKgwqDCoMKgwqBncGlvZF9zZXRfdmFsdWVfY2Fuc2xl
ZXAoaW14NDEyLT5yZXNldF9ncGlvLCAxKTsNCj4gK8KgwqDCoMKgwqDCoMKgZ3Bpb2Rfc2V0X3Zh
bHVlX2NhbnNsZWVwKGlteDQxMi0+cmVzZXRfZ3BpbywgMCk7DQo+IMKgDQo+IMKgwqDCoMKgwqDC
oMKgwqByZXQgPSBjbGtfcHJlcGFyZV9lbmFibGUoaW14NDEyLT5pbmNsayk7DQo+IMKgwqDCoMKg
wqDCoMKgwqBpZiAocmV0KSB7DQo+IEBAIC0xMDI0LDcgKzEwMjQsNyBAQCBzdGF0aWMgaW50IGlt
eDQxMl9wb3dlcl9vbihzdHJ1Y3QgZGV2aWNlICpkZXYpDQo+IMKgwqDCoMKgwqDCoMKgwqByZXR1
cm4gMDsNCj4gwqANCj4gwqBlcnJvcl9yZXNldDoNCj4gLcKgwqDCoMKgwqDCoMKgZ3Bpb2Rfc2V0
X3ZhbHVlX2NhbnNsZWVwKGlteDQxMi0+cmVzZXRfZ3BpbywgMCk7DQo+ICvCoMKgwqDCoMKgwqDC
oGdwaW9kX3NldF92YWx1ZV9jYW5zbGVlcChpbXg0MTItPnJlc2V0X2dwaW8sIDEpOw0KPiDCoA0K
PiDCoMKgwqDCoMKgwqDCoMKgcmV0dXJuIHJldDsNCj4gwqB9DQo+IEBAIC0xMDQwLDcgKzEwNDAs
NyBAQCBzdGF0aWMgaW50IGlteDQxMl9wb3dlcl9vZmYoc3RydWN0IGRldmljZSAqZGV2KQ0KPiDC
oMKgwqDCoMKgwqDCoMKgc3RydWN0IHY0bDJfc3ViZGV2ICpzZCA9IGRldl9nZXRfZHJ2ZGF0YShk
ZXYpOw0KPiDCoMKgwqDCoMKgwqDCoMKgc3RydWN0IGlteDQxMiAqaW14NDEyID0gdG9faW14NDEy
KHNkKTsNCj4gwqANCj4gLcKgwqDCoMKgwqDCoMKgZ3Bpb2Rfc2V0X3ZhbHVlX2NhbnNsZWVwKGlt
eDQxMi0+cmVzZXRfZ3BpbywgMCk7DQo+ICvCoMKgwqDCoMKgwqDCoGdwaW9kX3NldF92YWx1ZV9j
YW5zbGVlcChpbXg0MTItPnJlc2V0X2dwaW8sIDEpOw0KPiDCoA0KPiDCoMKgwqDCoMKgwqDCoMKg
Y2xrX2Rpc2FibGVfdW5wcmVwYXJlKGlteDQxMi0+aW5jbGspOw0KPiDCoA0KDQo=
