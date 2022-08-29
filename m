Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9C2E5A4735
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 12:32:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229731AbiH2Kcr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 06:32:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbiH2Kcq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 06:32:46 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90EC35A147;
        Mon, 29 Aug 2022 03:32:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1661769164; x=1693305164;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=50hL9fUVNiSQ/9A39BW3z3brUgtFpX+B48k/5hh/DFg=;
  b=D8V7CsupVQsMAGP4HxV0glnPk/3zgKBguQux2x/6ERp1CSq4NFxQmgQU
   ON/rywqByePTmb8NhGAdK110s2tA5MFFgcBkk9U03VB5Vte7U29m4nRJK
   kBIJAuvxgcHQTP6uCCrWcgdYI1hp0Sp7FgyJUo6FHwO6yYHgFP77RGk68
   /tRxwqrxIdoxosNeWjmPzsT1bpXcKudoMSYpTBC5Hted4UNLwQwzfb+Iz
   ICWNxKpOtoWfUJ04Tvt8nQcQQIfn1wHb7NYo+T7u/JWeJjZ1gr2ZOvx+E
   DqPJ+x6hmRYtc3DIF4+TyKk7RDINSxIOdcPSCoQW01uF2gyEotoqE33up
   A==;
X-IronPort-AV: E=Sophos;i="5.93,272,1654585200"; 
   d="scan'208";a="174599709"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 29 Aug 2022 03:32:43 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Mon, 29 Aug 2022 03:32:43 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.12 via Frontend
 Transport; Mon, 29 Aug 2022 03:32:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gOMZ7QzynqY4A9lbgLQsyOYQFzsQpJGxWFtgMIImaCSzHMjnzU3BBsoyJCtDxCZE8mOuXqxMuEgGWNwq5bHvOHg/LGfb3hTQRvIqTXknaq6tisiVA+wydq/xVpkXvAsFDiNInvgKH1pxprInaYHt8vNocd6h5mNwMz92H3kaSpd1LHoiSrasHWdLOqK1XXggVurIatuFi5gHAtLLZlfuyYoP5bTWBEnMmuUszi2yfSXfrvAewguoDuqv4kZHUGXWojE4PRoQMwna2SQ7ojjWlUnqh+N+z0sxyGe/nd0LF6heYzPLUdZ/VXtmex0JzlGayAgUemUtjsC/bfAsak2Q/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=50hL9fUVNiSQ/9A39BW3z3brUgtFpX+B48k/5hh/DFg=;
 b=aDhuMr6W83VqwtMv8L0KNQWBJtsTM9HA2D2v/AojQQCvWKKhI6kVhkTh7nIq9OF8XSEAxljYmHJQBJa+Zr6E5uAvb5PycUKfDerhFVIXuo5GNd4I4NAFxZG8ObCfg2SAQ5yZTvxxYYC0mBzDiPeDX48nE57GL1uQJaNB0ZNSLo36u2rWH0gjk3OTGKSliNHOBqzwM7iAXfS2qx1yBC8JP/VCWPBH6iGQBfzd3aVWMSApPCccdoAz+GvjvMe9T5RrJj3j1sVGUMI2yup1TnBXDFd5+9G/0eS+ghFjsFFGiBd1t8GtL9+ytQWAGhydAuoO91OyHfZWztIaGlF/H0OJ6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=50hL9fUVNiSQ/9A39BW3z3brUgtFpX+B48k/5hh/DFg=;
 b=Xou/78melj55aBpvmBM7dxIA9QcfrbJxAA1ItebuIQ9+WmueaUSYz5zWvzUah287RSmdpZ7Ow4eOktUuhBd92rodXMbJLllOPUUOSfBBmZM7dhg0Uh2LQxAyuNKzAcVeMTQErhl0Jf83wp+yAGk0tc+eMEZJaPNcDblKVHefoEM=
Received: from CO1PR11MB5154.namprd11.prod.outlook.com (2603:10b6:303:99::15)
 by BL0PR11MB3121.namprd11.prod.outlook.com (2603:10b6:208:7e::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Mon, 29 Aug
 2022 10:32:40 +0000
Received: from CO1PR11MB5154.namprd11.prod.outlook.com
 ([fe80::ac89:75cd:26e0:51c3]) by CO1PR11MB5154.namprd11.prod.outlook.com
 ([fe80::ac89:75cd:26e0:51c3%9]) with mapi id 15.20.5566.021; Mon, 29 Aug 2022
 10:32:40 +0000
From:   <Conor.Dooley@microchip.com>
To:     <heinrich.schuchardt@canonical.com>
CC:     <robh+dt@kernel.org>, <paul.walmsley@sifive.com>,
        <palmer@dabbelt.com>, <aou@eecs.berkeley.edu>,
        <krzysztof.kozlowski@canonical.com>, <sashal@kernel.org>,
        <geert@linux-m68k.org>, <atish.patra@wdc.com>,
        <devicetree@vger.kernel.org>, <linux-riscv@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH 1/1] riscv: dts: microchip: correct L2 cache interrupts
Thread-Topic: [PATCH 1/1] riscv: dts: microchip: correct L2 cache interrupts
Thread-Index: AQHYu4dTtNgUHpEviEaOXT3l7oIUCK3FrjGA
Date:   Mon, 29 Aug 2022 10:32:39 +0000
Message-ID: <4a62d792-012c-f8d1-ff5c-4d0edc2037e4@microchip.com>
References: <20220829091034.109258-1-heinrich.schuchardt@canonical.com>
In-Reply-To: <20220829091034.109258-1-heinrich.schuchardt@canonical.com>
Accept-Language: en-IE, en-US
Content-Language: en-IE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 305479b9-ec5d-46fb-c320-08da89a9cc8e
x-ms-traffictypediagnostic: BL0PR11MB3121:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: x46osSI7b1Gp4gXZuAvHY6UO4ZM/q4DI6WgxdBRLhgovpRVU9r2qsa/LWmlPd6dzANSgIhxtIdVR27MrEUt2NjVqJ9bzTQVuH/DmcCVG3Hw8uyniePu780RzDce5323ChbtDN2o70aeAEvLWZ5nC4W8XLhp6b6FHh6p+62K4tUgiBdZ/6wvNjK7U6YkSAbAI9EbuDYcR+jlSCFMIyOuijEG5sKZM+fLBlsIYR6/Y2TNP2eRS3Tv5wf9syqRn+oi2BovdvpzQZJF4WrfHtDgN3SEC59ZY3uQEFzRwO0OPfyDcD+SKAggTFX2pQJGtyiZGFzr5OJ3V8ppuRnNb8WvH1yIRuc6ePhDd2OZo0+TfNLu+2ZwYp+9+kVeyhsnZr8atII6Q8EKYR8QEUCxjcVPRp772oBizbBG7GYIsaQCnkON1F2xFcgMshseYLwuGAYlSaue3Fg7y2a+r7+Ww0ut03nmIQE7Iy+pr5pf+ERUQHqge3pNC8OCtJZbtlxP49THf7L/YiziXrp8UoeaxeL7XBaGJ1s7yOYN+gpefskY0kSmJuItIy1iDxR6lLN5Zk5DgYefuKg6EtzelhPid6i812gKKDf08HPQe6bEXUW6SnscaLu8NetLrA/2yvE5/A1N7oyRncr4UBdbvdn7Ce7MpsJgiSvDDxGqoQfCylSWa3ixeuMODQQXUB0zlZrSLk/MQ94cuE1FkPBk3rr74rAvWUXwDqwURZrOvoSBCCJ5T8ZCCfj47gVjdhXNt6WE930KWzSgvOLgNQhqkADuCZgI3gzZXcCeaLVf/NRDgDxBpW92n338ZpHwbRDih90D7809kJwIe+Y7S6W4wU+4UFjAvGYWf24ScWPLzeyuRG8e4qKA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5154.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(376002)(136003)(346002)(366004)(396003)(31686004)(66446008)(2906002)(91956017)(4326008)(6512007)(7416002)(66946007)(8676002)(76116006)(66556008)(66476007)(64756008)(8936002)(71200400001)(53546011)(6506007)(316002)(6916009)(54906003)(26005)(966005)(6486002)(41300700001)(478600001)(86362001)(2616005)(186003)(122000001)(38070700005)(83380400001)(31696002)(36756003)(5660300002)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?a1JtTkhuVjUycnI2bnQxOFdaVHg1dXhSNlljZG1FQU1Ga1c4ZzIrZGV5NUFS?=
 =?utf-8?B?Z084SS94RzUwY0lPVklhYWJPb1BVTkNOc2tqOHBqTmxFZDgyQnlKQkpuNDBm?=
 =?utf-8?B?cjlaM1pub05GZGRjUjNIMlAxYkZjSHp4dC82QWtBYWQrN2d2ZTZMN0s0TnZq?=
 =?utf-8?B?MFZRakpMWE0zc1NaQ3BVYWZpZDdNSGpwTUJqRlFYN2RHd2VZbTExdUFyZnhT?=
 =?utf-8?B?NktyRGM5bEQ3U24yNEFvVSs5NWJSa1F6OEJqckg2cndQK2ZhajB0dEEvQ3Z0?=
 =?utf-8?B?STFOYnpFMG9yOTNUWDFQcUVGMFVjQXFSeUlWd21zVnpWZ1J2L2o4MjJZNmdT?=
 =?utf-8?B?TWxJMTRQREozODRRc09kS05HeFc1VTNUVHFSN3MwUm8rUUVFdG9YZEtIQnJW?=
 =?utf-8?B?UHNNVnJ5VjArdXpxdlZyWER6bUpoMVBsUzhDMWxydHJRK1FoUHkyOFArNzBY?=
 =?utf-8?B?Mk04TlZxZFh2NDRRekI3RVdKZS9hMXFyQThkQmlvNFFzNEF6R0ZEcm14N2hl?=
 =?utf-8?B?VE9FQk5NUi9SaXZHYTRSdGVucUc2YlFZUmg4L05jd25JTlFzdkZPaldnMnRo?=
 =?utf-8?B?TkllRTYwcE93TzFIdnMwSk1Zd2huSmJtdFZ0eEJFSHZPc2U1bWovLzVFRW85?=
 =?utf-8?B?ODh1WU5QZDJuSW9QZW11S0xnNWRxRGVjUEpsL2dDbzd0YkI4TGt3VHR5RHF1?=
 =?utf-8?B?RVhOSHQwUFB2bTlyWlRudW5rK1JENnJ3Tm1adXllenRxeHg2Tm4yaEJ5RDZ3?=
 =?utf-8?B?ZGFKQ3o5VDRCblE5RFVwN3hWQ3NiMFNWemdsOElqbE56cE12R1ZOWkYxZjB2?=
 =?utf-8?B?RmFuYzdoZG1ERGNZYXEwcEQyZWlyOW1rZDRiLzNoTnZKdVg4Tm9Yckx3cnRQ?=
 =?utf-8?B?MmpUMVYvbEs4eUdQdG90L0ZndWVUTzFHTWN3MWVjeGJOeS9Ud0hyV015V3Jr?=
 =?utf-8?B?cTh5UkM5dmpvSDJBbTY4c1d1UUNOU0l3RktaTjBycTFVWjBoNnY0TW15bVQ2?=
 =?utf-8?B?RGltM2pseEFHTlVPQkt0V2t3c2VxWFVmSFlCdk9EcHlOVUxqcTNWc3NIYS9X?=
 =?utf-8?B?d0ljcGtLY1dkMkcyL2pyeFVCTzJmeE5PM0FhSXlZS1pra2k0ZFRZMnk2czlt?=
 =?utf-8?B?OEY0QkZSTEtTOUdDeWtDU2RRdCsrV0lJOGhxZUJkLzU4TWhMZHZUZk9HelE0?=
 =?utf-8?B?L0VFV2lYMUJscXNGa3JUWXJpaDhndVpwYjYrQXRpQmdYNHNSV0JTcU1qQVI4?=
 =?utf-8?B?WlNaYmZ5dTBlT284M0RzcndJRElkLzFiQjh6YWsyaWR0Y3V2eDk2RWp4L3p6?=
 =?utf-8?B?Wmg2MTJjSHNYb09qdXFNeFI1cDhLUnd4VVVaYjNiZUtJeGdTMG9DTXdtVHB6?=
 =?utf-8?B?YU5wMk12NloyWUNOOTFkNzNocEl1ZnY4cTlYSnp2alhPZTVzVUxEcDQ3bnVa?=
 =?utf-8?B?N2NnMG9Xd1JVK3VNWUdhb0VwdzJ6K05vdFpHWGtIWDloZnhLNG5tcUtpbFVp?=
 =?utf-8?B?NFlIYXlmdzA3UDJ3VDJCZGhWSkQzVVJnSG4wclV3cUhMSEdHQVdVY083disy?=
 =?utf-8?B?bjlXR004WU5STWZqbEFTQkJBOHZSUC9MbGZMa1RUL3VpWnZadGpaT1BxQy9j?=
 =?utf-8?B?cTkwRURTekFZSGp5cXFIMnBTU25QRzdUcUxJUm5rb0k3NVZCYVlEQ09HZnJK?=
 =?utf-8?B?TWdGMUNxbGdRQ0kvdEtMcGttV3pWcDJSR1dQblhOeGY2Q21RcCt6dDVFTzhu?=
 =?utf-8?B?aGE5eUxmdmFHeDZ4c0hRUkh1MFJscUVsNnYvbDF0OWdlVWFBVis5dmFNeWty?=
 =?utf-8?B?YnZQajlMK1d4V2R5czNjUEM2U1Y5dWpKbnJocnA3OHJiVGMxQ1M3ZlhZT3d2?=
 =?utf-8?B?bmpDdVhPVEMxZlRJUlVuRWE5bHN0dTVENFRiczlPeU8wQmNpT0NjVkZDdjVO?=
 =?utf-8?B?SWhVQlNmTjJNbldBYWt2N2xtVFZuaHBWQWZKdWxPUTdEWVVKMFpZalVtczBR?=
 =?utf-8?B?R0JjL2tmL291b1JZVDcyTnNUWjdURkRTQVErOHp5YjkxZWtqbi9nS2lVWVdi?=
 =?utf-8?B?TVZEc2JqQkFRNVZBOHNCUkg2Z3dlTjVQcjZqSDlCSTFHMDdhWUNDYUIrelNK?=
 =?utf-8?Q?GJG+WvcjfeqwAYBC231vjHcrH?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <29DFBF4D9B3A7F439479794386EB3D19@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5154.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 305479b9-ec5d-46fb-c320-08da89a9cc8e
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Aug 2022 10:32:40.0108
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wH45uCC/mYAjVBpmcx4R1XfMB1JxLONdJ+4cmmUjENd+zRl8mG19bCJDbLtODgGN2xX8tA9qzcddI64MblVVxv7RlEylUk/KNHCrix/oHKw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR11MB3121
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gMjkvMDgvMjAyMiAxMDoxMCwgSGVpbnJpY2ggU2NodWNoYXJkdCB3cm90ZToNCj4gRVhURVJO
QUwgRU1BSUw6IERvIG5vdCBjbGljayBsaW5rcyBvciBvcGVuIGF0dGFjaG1lbnRzIHVubGVzcyB5
b3Uga25vdyB0aGUgY29udGVudCBpcyBzYWZlDQo+IA0KPiBUaGlzIGlzIGEgYmFja3BvcnQgb2Yg
Y29tbWl0IDM0ZmM5Y2MzYWViZSB0byB2NS4xNS4NCj4gDQo+IFRoZSAiUG9sYXJGaXJlIFNvQyBN
U1MgVGVjaG5pY2FsIFJlZmVyZW5jZSBNYW51YWwiIGRvY3VtZW50cyB0aGUNCj4gZm9sbG93aW5n
IFBMSUMgaW50ZXJydXB0czoNCj4gDQo+IDEgLSBMMiBDYWNoZSBDb250cm9sbGVyIFNpZ25hbHMg
d2hlbiBhIG1ldGFkYXRhIGNvcnJlY3Rpb24gZXZlbnQgb2NjdXJzDQo+IDIgLSBMMiBDYWNoZSBD
b250cm9sbGVyIFNpZ25hbHMgd2hlbiBhbiB1bmNvcnJlY3RhYmxlIG1ldGFkYXRhIGV2ZW50IG9j
Y3Vycw0KPiAzIC0gTDIgQ2FjaGUgQ29udHJvbGxlciBTaWduYWxzIHdoZW4gYSBkYXRhIGNvcnJl
Y3Rpb24gZXZlbnQgb2NjdXJzDQo+IDQgLSBMMiBDYWNoZSBDb250cm9sbGVyIFNpZ25hbHMgd2hl
biBhbiB1bmNvcnJlY3RhYmxlIGRhdGEgZXZlbnQgb2NjdXJzDQo+IA0KPiBUaGlzIGRpZmZlcnMg
ZnJvbSB0aGUgU2lGaXZlIEZVNTQwIHdoaWNoIG9ubHkgaGFzIHRocmVlIEwyIGNhY2hlIHJlbGF0
ZWQNCj4gaW50ZXJydXB0cy4NCj4gDQo+IFRoZSBzZXF1ZW5jZSBpbiB0aGUgZGV2aWNlIHRyZWUg
aXMgZGVmaW5lZCBieSBhbiBlbnVtOg0KPiANCj4gICAgICBlbnVtIHsNCj4gICAgICAgICAgICAg
IERJUl9DT1JSID0gMCwNCj4gICAgICAgICAgICAgIERBVEFfQ09SUiwNCj4gICAgICAgICAgICAg
IERBVEFfVU5DT1JSLA0KPiAgICAgICAgICAgICAgRElSX1VOQ09SUiwNCj4gICAgICB9Ow0KPiAN
Cj4gU28gdGhlIGNvcnJlY3Qgc2VxdWVuY2Ugb2YgdGhlIEwyIGNhY2hlIGludGVycnVwdHMgaXMN
Cj4gDQo+ICAgICAgaW50ZXJydXB0cyA9IDwxPiwgPDM+LCA8ND4sIDwyPjsNCj4gDQo+IFRoaXMg
bWFuaWZlc3RzIGFzIGFuIHVudXNhYmxlIHN5c3RlbSBpZiB0aGUgbDItY2FjaGUgZHJpdmVyIGlz
IGVuYWJsZWQsDQo+IGFzIHRoZSB3cm9uZyBpbnRlcnJ1cHQgZ2V0cyBjbGVhcmVkICYgdGhlIGhh
bmRsZXIgcHJpbnRzIGVycm9ycyB0byB0aGUNCj4gY29uc29sZSBhZCBpbmZpbml0dW0uDQo+IA0K
PiBGaXhlczogMGZhNjEwN2VjYTQxICgiUklTQy1WOiBJbml0aWFsIERUUyBmb3IgTWljcm9jaGlw
IElDSUNMRSBib2FyZCIpDQo+IENDOiBzdGFibGVAdmdlci5rZXJuZWwub3JnICMgNS4xNTogZTM1
YjA3YTdkZjliOiByaXNjdjogZHRzOiBtaWNyb2NoaXA6IG1wZnM6IEdyb3VwIHR1cGxlcyBpbiBp
bnRlcnJ1cHQgcHJvcGVydGllcw0KDQpMb29rcyBsaWtlIEkgc2NyZXdlZCB1cCBoZXJlLi4uIEkg
YXNzdW1lIHRoZSBub24tYXBwbGljYXRpb24gaXMgZHVlDQp0byB0aGUgcmVuYW1lLg0KDQo+IExp
bms6IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2FsbC8yMDIyMDgxNzEzMjUyMS4zMTU5Mzg4LTEt
aGVpbnJpY2guc2NodWNoYXJkdEBjYW5vbmljYWwuY29tLw0KPiBTaWduZWQtb2ZmLWJ5OiBIZWlu
cmljaCBTY2h1Y2hhcmR0IDxoZWlucmljaC5zY2h1Y2hhcmR0QGNhbm9uaWNhbC5jb20+DQo+IC0t
LQ0KPiAgIGFyY2gvcmlzY3YvYm9vdC9kdHMvbWljcm9jaGlwL21pY3JvY2hpcC1tcGZzLmR0c2kg
fCAyICstDQo+ICAgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0p
DQo+IA0KPiBkaWZmIC0tZ2l0IGEvYXJjaC9yaXNjdi9ib290L2R0cy9taWNyb2NoaXAvbWljcm9j
aGlwLW1wZnMuZHRzaSBiL2FyY2gvcmlzY3YvYm9vdC9kdHMvbWljcm9jaGlwL21pY3JvY2hpcC1t
cGZzLmR0c2kNCj4gaW5kZXggNGVmNGJjYjc0ODcyLi41Nzk4OWIyYWMxODYgMTAwNjQ0DQo+IC0t
LSBhL2FyY2gvcmlzY3YvYm9vdC9kdHMvbWljcm9jaGlwL21pY3JvY2hpcC1tcGZzLmR0c2kNCj4g
KysrIGIvYXJjaC9yaXNjdi9ib290L2R0cy9taWNyb2NoaXAvbWljcm9jaGlwLW1wZnMuZHRzaQ0K
PiBAQCAtMTUzLDcgKzE1Myw3IEBAIGNhY2hlLWNvbnRyb2xsZXJAMjAxMDAwMCB7DQo+ICAgICAg
ICAgICAgICAgICAgICAgICAgICBjYWNoZS1zaXplID0gPDIwOTcxNTI+Ow0KPiAgICAgICAgICAg
ICAgICAgICAgICAgICAgY2FjaGUtdW5pZmllZDsNCj4gICAgICAgICAgICAgICAgICAgICAgICAg
IGludGVycnVwdC1wYXJlbnQgPSA8JnBsaWM+Ow0KPiAtICAgICAgICAgICAgICAgICAgICAgICBp
bnRlcnJ1cHRzID0gPDEgMiAzPjsNCj4gKyAgICAgICAgICAgICAgICAgICAgICAgaW50ZXJydXB0
cyA9IDwxPiwgPDM+LCA8ND4sIDwyPjsNCg0KQWNrZWQtYnk6IENvbm9yIERvb2xleSA8Y29ub3Iu
ZG9vbGV5QG1pY3JvY2hpcC5jb20+DQoNClRoYW5rcyBIZWlucmljaC4NCg0KPiAgICAgICAgICAg
ICAgICAgICAgICAgICAgcmVnID0gPDB4MCAweDIwMTAwMDAgMHgwIDB4MTAwMD47DQo+ICAgICAg
ICAgICAgICAgICAgfTsNCj4gDQo+IC0tDQo+IDIuMzcuMg0KPiANCg0K
