Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAAD559257C
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 18:43:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243320AbiHNQms (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 12:42:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243375AbiHNQkw (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 12:40:52 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A4B455BE;
        Sun, 14 Aug 2022 09:31:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1660494679; x=1692030679;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=JSv6xgpMbY9Mw606h2vLVvw60voRSNZfQLGy3otBtWg=;
  b=UNO62Fl+1ggNoKin18ODR5uYOETpVl/pxNWGCxeVXECWgbK7kHrzzTkj
   LoKbcFIdDm2CBaplXeQ+DzUC0p7CI/xqoyNqnoP16jdVTjqLPj370hAR/
   3Vbn34wLSJLHdJnGdwDN1nS2xyOt905Tcg/CuJv0vl66i1aqHb1h2yngy
   ay8HSvFCSeSO7PwwECOvLr5x02thKjdJ4ihlCUIMmyl3prtmvrQoAozsE
   lc+2cn1p30asZxKoGbWSzx2f9i3lNW3xCtELNM9AIQr+VF2cgbtD06UD3
   t5qs7kjKwc/dzD8rMzM2zYaell1eof4C2ipXbYN2ax1SGteiMYD06YhKv
   A==;
X-IronPort-AV: E=Sophos;i="5.93,236,1654585200"; 
   d="scan'208";a="186414220"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 14 Aug 2022 09:31:18 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Sun, 14 Aug 2022 09:31:12 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12 via Frontend Transport; Sun, 14 Aug 2022 09:31:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SrlsKNwPEeQclJnEitUBZC8+CjlhkdBrcXDSALvBnJIJuGPC3DoBC2dCvHElQzFO/9fVb1UDCTmngkn3/PLUSLifb0TCZl3mjLLiHiarvQghM7ZPhFkGimHWfCXC4c05zHT0nK5hltYQXHsBQsRpu6g97ft8ZvLQsgttvMPsiHh3Fl2zYytJuTwKDO2KMSezF+LEjGLi0bgl8So8e1xWb7OCc8BOO+hEQZC5NR+6Mx781DapAHlnJJ5HcSelBIWaio4Jk+Fw3oqcvh5uAtA3O0+e771b1y9ucYMS+7SWoKEEyHXsXJ9wYbiAlhk1alZVVo32JGE7Jsg9WKjzGR+mXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JSv6xgpMbY9Mw606h2vLVvw60voRSNZfQLGy3otBtWg=;
 b=D5xzB7eDVjYKPMK7mF/6qlfb8xLfdZhxvAyXwbPmpVuQsfiem60YDcc2o6JK7Und/pS1DnwnfXJNIkyGfqCdg+a5yI9pYrjvAknjxVRwUKmodX1EC4PTYE0z+kNC/uBKiRkB6wAIe/8quxe+C9gEJoKt6JuS2lqp0ayygnGGNNadqmVXuNeGYQWM0lSq9wMKuBzHUZN4kfir7nJDia8CFT47hcb9pGOtARjJoqvXkC8ykFz5ycvTS3vVMjciW1dogz6wcQqOMVhf+Q02hxlt1onay0lilxMHf78sm95wDyryyProOkU80gKPDvRkg4EOMx3pYGestJDvs+WUbdR2JA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JSv6xgpMbY9Mw606h2vLVvw60voRSNZfQLGy3otBtWg=;
 b=r8+AiWRqbHjn+U8cUCQNqvT4xqQ0fl3crEbljVIn8gpiQqSnsIZ/jtz+lEpWeQujV7VIQfmd9bvM9k4LdPVFgwONn/XgqABq1xBzsW3uxIy+o9buv2RcCMr7qjOAH7rSaYIBVOC9G1JsiC7bYSK9vcpy8oKAnAS3cXx6V7a7uHg=
Received: from CO1PR11MB5154.namprd11.prod.outlook.com (2603:10b6:303:99::15)
 by DM5PR11MB0010.namprd11.prod.outlook.com (2603:10b6:4:6c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.16; Sun, 14 Aug
 2022 16:31:08 +0000
Received: from CO1PR11MB5154.namprd11.prod.outlook.com
 ([fe80::ac89:75cd:26e0:51c3]) by CO1PR11MB5154.namprd11.prod.outlook.com
 ([fe80::ac89:75cd:26e0:51c3%8]) with mapi id 15.20.5525.011; Sun, 14 Aug 2022
 16:31:08 +0000
From:   <Conor.Dooley@microchip.com>
To:     <sashal@kernel.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>, <gregkh@linuxfoundation.org>
CC:     <Conor.Dooley@microchip.com>, <Brice.Goglin@inria.fr>,
        <sudeep.holla@arm.com>, <Daire.McNamara@microchip.com>,
        <robh+dt@kernel.org>, <krzysztof.kozlowski+dt@linaro.org>,
        <paul.walmsley@sifive.com>, <palmer@dabbelt.com>,
        <aou@eecs.berkeley.edu>, <linux-riscv@lists.infradead.org>,
        <devicetree@vger.kernel.org>
Subject: Re: [PATCH AUTOSEL 5.19 08/48] riscv: dts: microchip: Add mpfs'
 topology information
Thread-Topic: [PATCH AUTOSEL 5.19 08/48] riscv: dts: microchip: Add mpfs'
 topology information
Thread-Index: AQHYr/m4lChJmAGntk+nQ0QOTFr9M62ulo6A
Date:   Sun, 14 Aug 2022 16:31:08 +0000
Message-ID: <eeee7a72-8200-a374-8038-405605e0c290@microchip.com>
References: <20220814161943.2394452-1-sashal@kernel.org>
 <20220814161943.2394452-8-sashal@kernel.org>
In-Reply-To: <20220814161943.2394452-8-sashal@kernel.org>
Accept-Language: en-IE, en-US
Content-Language: en-IE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 78e08000-1bed-4526-3591-08da7e12641d
x-ms-traffictypediagnostic: DM5PR11MB0010:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Gc63RG0RcsnC3iKxMcicEZGTgw9m1w54eWwJxeZ2SEFRaWAXILeUf+flKbI794gikiqSu3RoWsVQ1oha4Dhn3bO5ivJ0s4oOeIzXpBGMS3OLXqvTtBSU5OCiPMSTeh5iZNhv+EQT/HhMUec1OsbHVjAjMu/qmy61y2KYrH37XgGf5zqTFxnfhOVfbTxLG/tf/6qnSuwYvHGyWor+UPoJDH/IWJE0YX/xEGUycPNZZVV/fQIa6qq/jEwmbibK5nBdWRMFZsYxiQUdT0U+K2hBLMp0sgs/xBUtdnK2n2G1XHF87kToay0aibuHBnjahtoxKDNncJk91Wwyjanhnz/y07gRNr3MCDSGt/PcyXwzFzlsLz268ellXgPAucl1WzJPndFAOTbbqNVJkHFe8bZ/UR9Q01v4zQSPW8pJVW81Egjyfp99wa4QdCLQGXwQh3EapP1F1duU1gIAKPuF3dABw5+7Qq2y0RBGQXTCvAbp9+XW5vcckV9DzTnxhg/9WoGOdA4xbdxP5JDDwAbMGVfI9N8IdbWXgePgnviijz5QHnD/06ed/b5BHgyZzzSiFMBof0neXhpwaKuxRHHv5JvY8edMts3CGvSKlFz0AXK4d71LBkYN+c1SZ3WraXKj3fc/36KeVb7nOQIz7m/uCb3DYgnqTc4v49Y34pZexLzLNSihHBq0Q//BaSA9M7fKHUGElV9kanBMrzedGaxMUrZCW60a2w8ZpSEv/OVWkksoLrV0hmCUpCzj+M/vyX4Pgdfc7AELMCyG04Rk6MJKYvdA7cPcCVc6iERuT1PHvgw3NUzNAYI7IaBnspsblY4Q45dzkDEgWCvD8/CxmI+xBCexThHQ9eqSymvtAXLh52dpa5/XmPqf6eqBsKzjTPbfQmkT2OYJ2SYigGV2LuSx4i9WVHB6Djxqvgk30L/AIkQXaofQV2QWhJ7IqOz2aQBA1O5V
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5154.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(366004)(376002)(39850400004)(136003)(396003)(7416002)(5660300002)(2906002)(38070700005)(86362001)(31696002)(122000001)(38100700002)(71200400001)(6506007)(53546011)(41300700001)(6512007)(26005)(478600001)(8676002)(966005)(31686004)(186003)(76116006)(4326008)(66476007)(66556008)(66446008)(64756008)(66946007)(6486002)(91956017)(8936002)(2616005)(316002)(54906003)(110136005)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Qlo1Z2JCdGFaRHF4SkdhY3gvV2J2NW14T2YxSS9OZ2F2UDliUkUxcmFhbjFY?=
 =?utf-8?B?WFg1Uk1oMExtbjVUQytHY0UrbEU0WEsvR25mZWZyMHBhc1I2QjdVaVhISFQ4?=
 =?utf-8?B?ZmY3RXAwVURPMmsvYVN5K1k3dW9TekR4THBKeVNnRHlsRjZSVGR5QThWbEVa?=
 =?utf-8?B?ODdOYlMrMDFGME5MVDNUSUROdmc2OENSbk5kRWM4a1RaL0p2M2lOQ3Nvdk5p?=
 =?utf-8?B?L0h4SitaVXB6bWcxOUZhTk9Gd1ZmaDNkNjNqN0tvUlVRbldvaUFGQk5EZWxO?=
 =?utf-8?B?cnBqVGZNcmp4L3oyV2xPMU9oL05seFY2TDNyZGc4MjBIb2hxTXJrNEs0UXBy?=
 =?utf-8?B?a0wyZXBQcFZyQVRRTlJhb1diWHh3R2UzVVhwanZtV0N6NHNTb25Yc3RoTDM2?=
 =?utf-8?B?a3oxZzNqRVFoUzhCd01Dc1ZoT1JobjlKWW13YmViYzV3K0NFd3BEeWZpbXZQ?=
 =?utf-8?B?VVgwVHJDbkppb1NoZmRtNnk3Z3N0OVRjbjd1d1BndW9OMlF1UGF6UDBKWnMr?=
 =?utf-8?B?RTlHVW1MdXBWdmxiZU02YWtWQWxuemVGbWVKS213c3ZvbUs3VEZSZW9ZV09T?=
 =?utf-8?B?Z09LeXMzUjJmK3pXRit5OGtub1U5cDRrbEUzOFRLbjFSWHlyaXNnVldFbGU2?=
 =?utf-8?B?QkJLU3JwaFJkb1VveStHc2pSL1RSWWxwMURZT1ExZHFxc21uY2JXd1A2SHpt?=
 =?utf-8?B?ZWRzS2Z0UFFWR1BPQ1g4c3pydTJIY3Z1cVNyK2xsbmNITGZKRjZIS1l6YTJs?=
 =?utf-8?B?T0VaMDdDTWoxUCtKK2o1NFJzdk5Ta2hMUlA4dFNvaVN4cjJmTWFWbmFuR1VZ?=
 =?utf-8?B?Qyt4Sk1BRTkrQ3FvWjlDdGl1Tmlva3c3WDQ2dHhIelB4QVJieGkzNVJuajVs?=
 =?utf-8?B?ci9sQjZ0Vlc1MURtOFFRVU92ZTZ1TFcxRU15ckZ1Qm5wckVtRUZRTDk3d2Nz?=
 =?utf-8?B?b1lESnBnVW5lOUQ4cTc1VS9MakdOYkN6bzBhYXFRcVZMcVBCTnBvSnZKTGdS?=
 =?utf-8?B?Nng3VFR2blY0OU5OaTBLcFI2NnRmTXRhMUhZNTBmQUJUc3plaGRjdHMyTlp1?=
 =?utf-8?B?VldYSWJ5aGhHbzB1S2YrR0RiVS9haTlXSzlFQllCOVpsTVhRSTVwSGR5a0tD?=
 =?utf-8?B?L2t6L3A0bmgya0x3a05TK3RvWEM0eHNGSUppZUNBYnIrSzRMT0o2NUhjZ2hv?=
 =?utf-8?B?S2pXdks4eWRoWm1lL2RJRnpTOVU5VDMzbDRvRHdBbllPTHNLcTFFeFRGMVlQ?=
 =?utf-8?B?UFB5aE9sc2ptUGxmcitTNE9hajQxSDcyZExtd0oza3FXSG5XSzB0a2pncnlF?=
 =?utf-8?B?ZjlFZTY2aE5aQVBqcm5ENkNWRWZEM3dTNkdGdEgvakttUVBKNFlNeVBWKzJL?=
 =?utf-8?B?TjUzbitGVUYrYlIxajRPKzdYbU9zdmd4U09PN1hUTWJybVBZU001NWVqUVgw?=
 =?utf-8?B?SE1XMXJlM242Z2xOQjROYnpUaEZPSWRjUW90aWpZNU1yTW80VGlucUlKUnlm?=
 =?utf-8?B?N0VCVVBsMlpvRm1VbXBQd2hnRDh5c1I2UU5kbWkyY2JZWWxqUDNPWCs4S2FM?=
 =?utf-8?B?dTY4dG9UVFZoTm1xendma256RHJNVXJoWkFHUWhib1ZNbjVnVVYzellTak50?=
 =?utf-8?B?RWdUeXRLZEVvRTZyYml2VFUrMG44Vjh6WVZEZHlaNEk4cWIyT3FHTURKZ05l?=
 =?utf-8?B?dFloVndDdUFoS1VLcVFyd1U0RHQvODAxTVpMNFI3M2hzYzhuUVBNcXlhL25C?=
 =?utf-8?B?UXZPWjB2anFqOWtZZlQ5YlVteXArTnRMdFZJUGN1TFhQb25KWkZwbnFtUFNY?=
 =?utf-8?B?UnNpM1dtMEtZS3o5T1dBYjZ6djI2VVZsVU5HbUNLTnVDZVZHNU9HQ2ZsOGRB?=
 =?utf-8?B?TXQrQkNzb1VSZFJydUJqQWJ5VVNhcFJxMWFaODZSdml1bHNnK1VHM0J2YmFX?=
 =?utf-8?B?NFFaUG40NkErMXJWSkJmV1hmbW0weHZjN1pmaUpqSndQQVk1N3ZJS0MyUWJD?=
 =?utf-8?B?ejdJVXNTblZmWURoQXp1cE5rQWY4NHhFRWl6NVRKZDhILzRtUko5dTlPQUlo?=
 =?utf-8?B?dGpZOGhzeGZOV2JPdUh3TUJheGpTNEs5emlkcXR2Tlg3VWJQcGNNVGhlQVM5?=
 =?utf-8?Q?HHqSBmS1TNjEUW+Ig+LknZyd1?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <386AE2A009D16C4DBA245F588D379943@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5154.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78e08000-1bed-4526-3591-08da7e12641d
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Aug 2022 16:31:08.0337
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6e+1Lbd60JexMsK0eODhQ/A2wyx4M5aM7yaT27WEFNNDnsHAm995lqYau6Krh9o49iCPivfOBAe0SZ3q5E8G/BCvAgiNqlTheb76sdWTSXg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB0010
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gMTQvMDgvMjAyMiAxNzoxOSwgU2FzaGEgTGV2aW4gd3JvdGU6DQo+IEZyb206IENvbm9yIERv
b2xleSA8Y29ub3IuZG9vbGV5QG1pY3JvY2hpcC5jb20+DQo+IA0KPiBbIFVwc3RyZWFtIGNvbW1p
dCA4OGQzMTljNmFiYWViMzdmMGUyMzIzMjc1ZWFmNTdhODM4OGUwMjY1IF0NCj4gDQo+IFRoZSBt
cGZzIGhhcyBubyBjcHUtbWFwIG5vZGUsIHNvIHRvb2xzIGxpa2UgaHdsb2MgY2Fubm90IGNvcnJl
Y3RseQ0KPiBwYXJzZSB0aGUgdG9wb2xvZ3kuIEFkZCB0aGUgbm9kZSB1c2luZyB0aGUgZXhpc3Rp
bmcgbm9kZSBsYWJlbHMuDQo+IA0KK0NDIEdyZWcNCg0KSGV5IFNhc2hhLA0KVGVjaG5pY2FsbHkg
dGhpcyBpcyBhbiBvcHRpb25hbCBwcm9wZXJ0eSBzbyBJIGRpZG4ndCBtYXJrIGFueSBvZg0KdGhl
IHBhdGNoZXMgYXMgQ0M6IHN0YWJsZSBhcyB0aGV5IG5vdCByZWFsbHkgZml4ZXMuIFRoZSBwbGFu
IHRvIGlzDQp0byBmaXggdGhlIGh3bG9jIHByb2JsZW0gYXQgdGhlIHNvdXJjZSByYXRoZXIgdGhh
biBwYXBlcmluZyBvdmVyIGl0DQp3aXRoIHRoZSBkdHM6DQpodHRwczovL2xvcmUua2VybmVsLm9y
Zy9saW51eC1yaXNjdi8yMDIyMDcxNTE3NTE1NS4zNTY3MjQzLTEtbWFpbEBjb25jaHVvZC5pZS8N
Cg0KVGhvc2UgcGF0Y2hlcyBhcmUgZGVsYXllZCB1bnRpbCBhZnRlciAtcmMxIGFzIHRoZXkgd2Vy
ZW4ndCByZXZpZXdlZA0KZnJvbSB0aGUgcmlzY3Ygc2lkZSBwcmlvciB0byB0aGUgYXJtNjQgdHJl
ZSBjbG9zaW5nLCBidXQgdGhlIHBsYW4gaXMNCnRvIGJhY2twb3J0IHRob3NlIGluc3RlYWQuDQoN
Ckkgc3VwcG9zZSB0aGVyZSdzIG5vIGhhcm0gaGF2aW5nIHRoZXNlIHRvbywgYnV0IEknbGwgbGVh
dmUgdGhhdCB1cA0KdG8gdGhlIGJldHRlciBqdWRnZW1lbnQgb2Ygb3RoZXJzLi4uIFdoYXQgZG8g
eW91IChwbHVyYWwpIHRoaW5rPw0KVGhhbmtzLA0KQ29ub3IuDQoNClRoaXMgYXBwbGllcyB0byB0
aGUgZm9sbG93aW5nIGNvbW1pdHMgdG9vOg0KcmlzY3Y6IGR0czogc2lmaXZlOiBBZGQgZnU1NDAg
dG9wb2xvZ3kgaW5mb3JtYXRpb24NCnJpc2N2OiBkdHM6IHNpZml2ZTogQWRkIGZ1NzQwIHRvcG9s
b2d5IGluZm9ybWF0aW9uDQpyaXNjdjogZHRzOiBjYW5hYW46IEFkZCBrMjEwIHRvcG9sb2d5IGlu
Zm9ybWF0aW9uDQoNCj4gUmVwb3J0ZWQtYnk6IEJyaWNlIEdvZ2xpbiA8QnJpY2UuR29nbGluQGlu
cmlhLmZyPg0KPiBMaW5rOiBodHRwczovL2dpdGh1Yi5jb20vb3Blbi1tcGkvaHdsb2MvaXNzdWVz
LzUzNg0KPiBTaWduZWQtb2ZmLWJ5OiBDb25vciBEb29sZXkgPGNvbm9yLmRvb2xleUBtaWNyb2No
aXAuY29tPg0KPiBSZXZpZXdlZC1ieTogU3VkZWVwIEhvbGxhIDxzdWRlZXAuaG9sbGFAYXJtLmNv
bT4NCj4gU2lnbmVkLW9mZi1ieTogU2FzaGEgTGV2aW4gPHNhc2hhbEBrZXJuZWwub3JnPg0KPiAt
LS0NCj4gIGFyY2gvcmlzY3YvYm9vdC9kdHMvbWljcm9jaGlwL21wZnMuZHRzaSB8IDI0ICsrKysr
KysrKysrKysrKysrKysrKysrKw0KPiAgMSBmaWxlIGNoYW5nZWQsIDI0IGluc2VydGlvbnMoKykN
Cj4gDQo+IGRpZmYgLS1naXQgYS9hcmNoL3Jpc2N2L2Jvb3QvZHRzL21pY3JvY2hpcC9tcGZzLmR0
c2kgYi9hcmNoL3Jpc2N2L2Jvb3QvZHRzL21pY3JvY2hpcC9tcGZzLmR0c2kNCj4gaW5kZXggNDk2
ZDNiNzY0MmJkLi5lMzc5MzkxNmExZTUgMTAwNjQ0DQo+IC0tLSBhL2FyY2gvcmlzY3YvYm9vdC9k
dHMvbWljcm9jaGlwL21wZnMuZHRzaQ0KPiArKysgYi9hcmNoL3Jpc2N2L2Jvb3QvZHRzL21pY3Jv
Y2hpcC9tcGZzLmR0c2kNCj4gQEAgLTE0Miw2ICsxNDIsMzAgQEAgY3B1NF9pbnRjOiBpbnRlcnJ1
cHQtY29udHJvbGxlciB7DQo+ICAJCQkJaW50ZXJydXB0LWNvbnRyb2xsZXI7DQo+ICAJCQl9Ow0K
PiAgCQl9Ow0KPiArDQo+ICsJCWNwdS1tYXAgew0KPiArCQkJY2x1c3RlcjAgew0KPiArCQkJCWNv
cmUwIHsNCj4gKwkJCQkJY3B1ID0gPCZjcHUwPjsNCj4gKwkJCQl9Ow0KPiArDQo+ICsJCQkJY29y
ZTEgew0KPiArCQkJCQljcHUgPSA8JmNwdTE+Ow0KPiArCQkJCX07DQo+ICsNCj4gKwkJCQljb3Jl
MiB7DQo+ICsJCQkJCWNwdSA9IDwmY3B1Mj47DQo+ICsJCQkJfTsNCj4gKw0KPiArCQkJCWNvcmUz
IHsNCj4gKwkJCQkJY3B1ID0gPCZjcHUzPjsNCj4gKwkJCQl9Ow0KPiArDQo+ICsJCQkJY29yZTQg
ew0KPiArCQkJCQljcHUgPSA8JmNwdTQ+Ow0KPiArCQkJCX07DQo+ICsJCQl9Ow0KPiArCQl9Ow0K
PiAgCX07DQo+ICANCj4gIAlyZWZjbGs6IG1zc3JlZmNsayB7DQo=
