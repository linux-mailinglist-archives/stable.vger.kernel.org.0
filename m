Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CA186E7796
	for <lists+stable@lfdr.de>; Wed, 19 Apr 2023 12:42:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231574AbjDSKmK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Apr 2023 06:42:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231513AbjDSKmH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Apr 2023 06:42:07 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95B6CBE
        for <stable@vger.kernel.org>; Wed, 19 Apr 2023 03:42:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1681900926; x=1713436926;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=BV9wq1PEkDhoAQ2LQgZbfDEIA8nlBy4wAKipWJLWCGE=;
  b=KjRN0FUbQX9SVOzONfmrbxZy8fdudaR0QKpsxNLHILOGUJ+v7cwvdlOA
   1o8VA6nGNr9J2H/GqerbkBYTxJ32ufzM9pIPWjGRkPlA+Xk2MfM9fPh10
   B5Z2uMukjzqXtnONyoHvYEigWVJtBbPAIVJxNzrxZB8nvwNgqdd9JLoqv
   lUubZSrPvRgemLftPr6a8IWg4jxYL1O86OOXH+vaKYgAPRP6qyZWgC0yw
   YYKeFTumaoHQg5z+PFcpxs5GwBk2iO5cT8YIKL4UY8mr8k+T6T+MIyTXg
   W7BD3DvKtKwLd0HE3GqRbzvSKzrXMSgX0bpJkrYNnqj8zj50uj6zzR7NA
   w==;
X-IronPort-AV: E=Sophos;i="5.99,208,1677567600"; 
   d="scan'208";a="209769116"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 19 Apr 2023 03:42:05 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 19 Apr 2023 03:42:05 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 19 Apr 2023 03:42:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CNIZBS4MJt2aPtedrqFvS7KmF+tQOib4RyhlINLbEVK+UbT7+3sC7LrJHSkHQNDtV62MzajCpW+oIU5xHu0K0Wxr8rL//aReR/cvnA+gZcvAARTlHgeOMKX9mjXIBZOtAWWoJOfDa25sNykKEQ41v56artpl816R7uVUcEbEfDNPdgT5GYhWhlOfoTmizQUVOnuyCxPJkPk8yjqCfFlSG9uPL3u6PvmmIUq5lxL1xugZxvEdJrME854ZgQCetjhji+clVB0vpYrLhiH2W9w2hDb96mDvYlBdL/Lf0H3MJtdPgjRnfif5TwiD0EpNsApHTtisG2LzWclsRNEYbLYppw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BV9wq1PEkDhoAQ2LQgZbfDEIA8nlBy4wAKipWJLWCGE=;
 b=Fc9EYzKRsNkqP5KQu2xXxPv2SR3ATzqdJZ+FufNWUE0C4POHy52GDVyTwxHFVWA66UrHvl8ZTwN887mEq//6C/QEmCrb/jlJsHQga40h799woKNpmSjqVRQ219tD04FK8kGiq2FvrZ+WvmM8XV9gXrRDOvICujgpvKQDVX/EyvK+H3eTYkRHN8Hryx8IMWhvUUZrlShimar6vZW5kiB8e8Oxzf6KGfnZWgQ3jeMFAOg8mFfsBDUzXiYF/7wmQp5GKqoEDQV37iY/3P/5HE24I16e9IktCf9+c3n8AoidnYvWg1fefhFvOhLEAWJ4y7bIepBXMQIIzSd2WvwyUhFhWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BV9wq1PEkDhoAQ2LQgZbfDEIA8nlBy4wAKipWJLWCGE=;
 b=CHbogAd8EUtH6hdPsDaTY52SqNwvPreKqsclZCaO5SWInIrzysfcnTEBTJc8pkr0dmlHW4z9Dm6zummK6e9Vyt0kll3mHZ2fy+UefHbqZJB4nqisuM0arkwwtSc7H0dwrFiLQOZqYRh/ygAIBEnvilogSQHX2QpwYuGO8SqNrNQ=
Received: from CO1PR11MB5154.namprd11.prod.outlook.com (2603:10b6:303:99::15)
 by SN7PR11MB7707.namprd11.prod.outlook.com (2603:10b6:806:322::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Wed, 19 Apr
 2023 10:42:03 +0000
Received: from CO1PR11MB5154.namprd11.prod.outlook.com
 ([fe80::5615:499e:2fe2:20dd]) by CO1PR11MB5154.namprd11.prod.outlook.com
 ([fe80::5615:499e:2fe2:20dd%3]) with mapi id 15.20.6319.022; Wed, 19 Apr 2023
 10:42:03 +0000
From:   <Conor.Dooley@microchip.com>
To:     <alexghiti@rivosinc.com>
CC:     <gregkh@linuxfoundation.org>, <stable@vger.kernel.org>,
        <patches@lists.linux.dev>, <palmer@rivosinc.com>,
        <sashal@kernel.org>
Subject: Re: [PATCH 6.1 129/134] riscv: Move early dtb mapping into the fixmap
 region
Thread-Topic: [PATCH 6.1 129/134] riscv: Move early dtb mapping into the
 fixmap region
Thread-Index: AQHZcfPlkyqgaT0hXkupHA1KbKu8i68yPQK1gAAkK4CAAAXsK4AADBUA
Date:   Wed, 19 Apr 2023 10:42:02 +0000
Message-ID: <8e59155d-3236-f757-0b31-12ee29fa5650@microchip.com>
References: <20230418120313.001025904@linuxfoundation.org>
 <20230418120317.673170852@linuxfoundation.org>
 <20230418-tactile-cocoa-4242e87bf994@wendy>
 <2023041948-overthrow-debtor-289d@gregkh>
 <20230419-uninstall-fragile-51c326b1adbc@wendy>
 <2023041918-stammer-subgroup-fbd1@gregkh>
 <20230419-unpeeled-squabble-986a9e40e4d5@wendy>
 <CAHVXubgRXAzGWwyTPwUpWxjP++0Yybu=wPMRCPuaPs2mEaA86w@mail.gmail.com>
In-Reply-To: <CAHVXubgRXAzGWwyTPwUpWxjP++0Yybu=wPMRCPuaPs2mEaA86w@mail.gmail.com>
Accept-Language: en-IE, en-US
Content-Language: en-IE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO1PR11MB5154:EE_|SN7PR11MB7707:EE_
x-ms-office365-filtering-correlation-id: e7520f7b-f672-45a6-13e4-08db40c2b653
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jmofvef/E6J69Or45TEQxN7W6N7jiEuZNXyELO9jQMi3+lmL7hMtSrWnf7N0/WSAQTJr/mCN/udrtLiS6VWyiX/wuXX0I/ZJNxiJK/Q7NApPxvQZONSOph3ZzP19e1sB2QXujiFox6oYGrD+PebFPjnP4DkyPVrQv1b1P0ru5HF4r3Gs/b0+CWzvL6FviKDoGOppeV6QDB2F7UGCzKh8BjUSFHNu1pprhdqTrAyJ5SSfEAX/dx8e5WG7oVbcFi/wW+QmOTs3LCk58FW0iO2mk1OAffeGq5ncr4u2KwxyZlccDfAV6zWMFJgxDEZ+9StfiDsL8UI/JeoqZhosSKOCSf+7GiQ7dJFk3pstpK9+RDpaSPd3esAlo7G+zeiVNKO5S+VE7kmn6LE+2Riab4hxCEOJQzxRau2+ObN+KrzMNHMQM0MrtRloGNgKFcjRNETQnzHtXsivFxYQPYJYKZUWjufPiGbRJV6PMXw9xi0dswRy6O2K8mNvCHeuIZ2GyRFqS1w7s48hWzXg1DWoSof66mU07Ph4fdbS6h0AMKAQBdaTM3OyMXBSeNSrEuwTbUTUtWYB5Myd7cDAZojqV7AExOGLv3Pci2h1+bTLk56+mTdt4O2z4ANLE+H2VOWAM4jD6PRkblYnC7LsZCpGsouBfZtlCwsTzKbTu2GaGxw06Yul5XZqsfcOQLHw9slcaFsd
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5154.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(366004)(396003)(346002)(136003)(39860400002)(451199021)(2616005)(6506007)(26005)(6512007)(86362001)(54906003)(478600001)(31686004)(66946007)(66556008)(316002)(66446008)(64756008)(66476007)(4326008)(83380400001)(6916009)(186003)(6486002)(71200400001)(91956017)(53546011)(76116006)(66899021)(122000001)(41300700001)(38100700002)(5660300002)(2906002)(8936002)(8676002)(38070700005)(31696002)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OGdDc3NTa3AwWHRRNjZ3Vm0yYVZOckdsNXBMRS85Q21PNGtSSTJNbmVPZE1m?=
 =?utf-8?B?aHFUVWxBcnV4bDNnYThPeHVhSmV4UVlFZlJ6UlluTldNQWtVZWlBUUVidFdL?=
 =?utf-8?B?bmxtUjhHT1BJTEp1bUU3WitzWDZ1L3FDKzZDZDNpR1FKZER0cmlqbnVJZHI4?=
 =?utf-8?B?Q3pnZVpUeWZEdFVNd0d4ZUgvS2plVnpUUkFuYTVuV3JXSS9SRFVWY0VIeGN2?=
 =?utf-8?B?RlhsS1pBeEdjWUFvaHZPeXk4ODRhd1I5UlV1eEtqT2FGWnVaaVRob0Y0SDhJ?=
 =?utf-8?B?ZU53Nm8vSVJzZittR0pDRjg4d0ZDa2phbFVPYm9aVjlvVEhaNGYvT08vTHdz?=
 =?utf-8?B?ejMzU2dyc3l1SVM5SmdSM1hIRFB1cnpiYVRpbHhURUxDdjdTYUliZXdoeFBh?=
 =?utf-8?B?aE9lRVJQbkRKeTNwKzN6eFhmRy9iejVNTVg2RGRrRWpzK0h2VSs1VDJCYmhL?=
 =?utf-8?B?SEFJbng2R0VRT0RNUmJjbHRkUUJNbkh0ZjV3Uy8rZlNVOW54c3YrSzI2QU02?=
 =?utf-8?B?dnNiVHM3SDIwOU5tRDJTWDlGck9aT1hvZWxleEYwMXE1Rks5VEFnZC9zYk9x?=
 =?utf-8?B?YW9sRExWOUpXU1NMS1cvckVycDNKTjdTWGROWS9acFNmTFkwNmFpSUxOSkxB?=
 =?utf-8?B?UzBGSUU3VWRRV0JQczdJWTJLd2tMQjRMQTZYYXpIUlUzcmVIb3dsakdSYWZB?=
 =?utf-8?B?SGFCZUpBZ0o3bXVvUHMvSDVpQm9VRHltc3hxRVY0cUl0YXNERmJJWXZ1Q0ha?=
 =?utf-8?B?TlBmaFJlOFpaNnJKeC9XeUc0cEVkVlI0eHhQaUxLUENmZ3N0ZlE5VGVuTENH?=
 =?utf-8?B?d3ZTR3EraWtoVjdOcExtRGoybCtTdThSK0RWS0J0Ny9wTG50S1ZwUUNCMHZh?=
 =?utf-8?B?SUpIU1JrOGNRclIwVWpaRE5SdVFqbmhqcWFHK0xHTWZSUmNvSjNUSzNDc0pl?=
 =?utf-8?B?YWhaVU5nRW11TWZpTG4vaUZVQkxTQ080SHJNYXM2bktwbElFNmRvM3JnWjh2?=
 =?utf-8?B?NGM1VzVZaHVucG1pckNjTm9zMFFTeEZvUzBycnF1WUtQMkF3RkZXVFk3ekJ3?=
 =?utf-8?B?TkkvdGEvSlN3VDlCTTBxbElvNWl3WGs0L0ZYeStxSjdlZnpRaGJrbHNqOWM4?=
 =?utf-8?B?TkhoMytmRk0yR2VGZ1h0a0huTlBJOFdSRThRbm05ZFBSZkl5aWM3Yjhwa01K?=
 =?utf-8?B?RU5ZcWwvNkdXMEs5Y0tRSGtTTkdpc2dMZXFCTVBBVlZvVm14VHFrVzdOMzVF?=
 =?utf-8?B?U1Z6NUhZRjhoMkFwbnJVbUtRdEN2WGdtVDdiRGt5RHk0Z3pPOFM5V3ZSZHlj?=
 =?utf-8?B?cjE2d3cxbml2QncvR0pvUkxucXc4QnVxbmk0UVU4RnE5ZFd0dXVvcTVEODha?=
 =?utf-8?B?U2hmYTVEbjV2R1pmcnNKTWxuVjF2dUFmTTNrdkUxRDlvYUV5Tnp0VGtBZitT?=
 =?utf-8?B?aEk4eGtCQS9TUC9tSU5hQnBiMnY5eFh1N3NZNmpmV0pZMzBwdkJnaFZnd1ZF?=
 =?utf-8?B?U2thRWdoRFhqTXVTSkl4VU53anFyUEpNY2UvbXRwai9ydzJaWFNmcU5jY2RP?=
 =?utf-8?B?MUVrRkV6SHN1SW5MaDhqYVBWd0c0aGM4UFZ6K1JKcUk3NUxOQ2dlSkxTdWhM?=
 =?utf-8?B?d0p4R3BlT2k0NDhHVjlRMGp4eDBRbGthWWVXby9QVmJlN2JoRFZETHFXcFJk?=
 =?utf-8?B?a1ptS2RIYjNtbHZkaWl3eEwwNTZKcDFJVzJKZytnMktXWEdjZ0IwS1JldENC?=
 =?utf-8?B?M2cweUVlWitENUNBVGhWTGkvVVR1bjRRNThkWjQyM0wrYjd4d1JpQXI2Witt?=
 =?utf-8?B?a2dvK1JCT2R1NFBYQ1lrWUpqWnlZSkpDd2JzMEowcHdFVlR6ODFkWlA0TkR4?=
 =?utf-8?B?ZUJtbVVhcXgzdGdpYm5ydzFXNndzcUpNcVJjL3I0anJBMlc3ZVA3UEVCL2kw?=
 =?utf-8?B?NXRsNndhZmt3dDlHSXdFbHlmcnZ3VUh6R3RsaS80Y21BNGNhclZ1bE5yWk1l?=
 =?utf-8?B?eURDRzMwdEVZM3ROa1F3bzB2RXBQZFZmeVQvNWRJUGhYaFJLSlZGTStJaTdR?=
 =?utf-8?B?SncwenFRQjBGd3VjVXlLQkRyUWZiN2VaR3ZuSExVSXA3Uy9KNGF2QlNKektY?=
 =?utf-8?Q?+icBn8wuijDm8Z2b6JUkTQqzI?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <20BCAB56904C5C4BABC7A23FF5092815@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5154.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7520f7b-f672-45a6-13e4-08db40c2b653
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Apr 2023 10:42:02.9508
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iX3ZhL9dzdk5mIw2mA/3nR8QwCfNJLQ8sWtwDs2GvWNhp+XkGNWjDgcw0Xd+G0h98N7FNGMxqJ158nB4gGnHCS2i/bsi28uprzbWuks4PlY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7707
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gMTkvMDQvMjAyMyAxMDo1NywgQWxleGFuZHJlIEdoaXRpIHdyb3RlOg0KDQpsb3JlIHNlZW1z
IHRvIGJlIHF1aXRlIHNsdWdnaXNoLCBzbyBteSB1c3VhbCBvZmZpY2Ugc2V0dXANCm9mIHB1Ymxp
Yy1pbmJveCArIG11dHQgaXNuJ3Qgd29ya2luZy4uDQoNCj4gDQo+IEhpIENvbm9yLA0KPiANCj4g
T24gV2VkLCBBcHIgMTksIDIwMjMgYXQgMTE6NTHigK9BTSBDb25vciBEb29sZXkNCj4gPGNvbm9y
LmRvb2xleUBtaWNyb2NoaXAuY29tPiB3cm90ZToNCj4+DQo+PiBPbiBXZWQsIEFwciAxOSwgMjAy
MyBhdCAxMTozNjo0M0FNICswMjAwLCBHcmVnIEtyb2FoLUhhcnRtYW4gd3JvdGU6DQo+Pj4gT24g
V2VkLCBBcHIgMTksIDIwMjMgYXQgMDg6NTU6MzRBTSArMDEwMCwgQ29ub3IgRG9vbGV5IHdyb3Rl
Og0KPj4NCj4+Pj4gSG93ZXZlciwgdGhpcyBwYXRjaCAoInJpc2N2OiBNb3ZlIGVhcmx5IGR0YiBt
YXBwaW5nIGludG8gdGhlIGZpeG1hcA0KPj4+PiByZWdpb24iKSBkaWQgZW5kIHVwIGdldHRpbmcg
YXBwbGllZCB0byA2LjEueSBhbmQgNi4yLnksIGRlc3BpdGUgd2hhdCB0aGUNCj4+Pj4gZW1haWwg
SSBnb3Qgc2FpZCBmb3IgNi4xLnkhDQo+Pj4NCj4+PiBUaGF0J3MgYmVjYXVzZSBTYXNoYSBiYWNr
cG9ydGVkIHRoZSBkZXBlbmRlbnQgcGF0Y2hlcyB0byBnZXQgaXQgdG8NCj4+PiBhcHBseS4NCj4+
DQo+PiBTaG91bGQgcHJvYmFibHkgc2VuZCBvdXQgYSBub3RpZmljYXRpb24gb2Ygc3VjY2VzcyB0
aGVuLCBubz8NCj4+IEF0IGxlYXN0LCBJIGRpZG4ndCBzZWUgb25lIGxhbmQgaW4gbXkgaW5ib3gu
DQo+Pg0KPj4+IExldCBtZSBqdXN0IGRyb3AgYWxsIG9mIHRoZW0sIHRoYXQgbWFrZXMgaXQgc2lt
cGxlciBhbmQgdGhlbiBpZiBhbnlvbmUNCj4+PiB3YW50cyB0aGVtIGFwcGxpZWQsIHRoZW4gdGhl
eSBjYW4gc2VuZCB1cyBhbiBleHBsaWNpdCBzZXQgb2YgcGF0Y2hlcy4NCj4+DQo+PiBQZXJmZWN0
LCBJIHNob3VsZCBiZSBhYmxlIHRvIGRvIHRoYXQuDQo+PiBTb21lIHRpbWUgaGVyZSBtaWdodCBh
Y3R1YWxseSB3b3JrIGluIG91ciBmYXZvdXIsIGFzIEkgZG9uJ3QgdGhpbmsgdGhpcw0KPj4gc3R1
ZmYgaGFzIGJlZW4gdGVzdGVkIHlldCBieSBhbnlvbmUgdXNpbmcgWElQIGFuZCBJIGhhZCBleHBy
ZXNzZWQgc29tZQ0KPj4gY29uY2VybnMgdGhhdCB3ZSB3b3VsZCBjYXVzZSB0aGVtIGlzc3Vlcy4N
Cj4gDQo+IExldCBtZSBrbm93IGhvdyBmYXIgeW91J2QgbGlrZSB0byBzZWUgaXQgYmFja3BvcnRl
ZCwgSSdsbCBkbyBpdCwgSQ0KPiBhbHJlYWR5IGxldCB5b3UgZGVhbCB3aXRoIGFsbCB0aGUgYmFj
a3BvcnQgZXJyb3JzLCB0aGF0J3MgdGhlIGxlYXN0IEkNCj4gY2FuIGRvIDopDQoNClVoLCBzdXJl
ISBBbHdheXMgaGFwcHkgdG8gaGF2ZSBsZXNzIHRvIGRvLg0KSSB0aGluayA2LjEgYW5kIDYuMiBh
cmUgImZyZWUiLCBpdCdzIGp1c3QgYSBjYXNlIG9mIHRlbGxpbmcgR3JlZy9TYXNoYQ0KZXhhY3Rs
eSB3aGF0IGNvbW1pdHMgdG8gcGljay4NCkkgYmVsaWV2ZSB0aGF0IGlzIHlvdXIgMyBwYXRjaGVz
IGZvciA2LjIueSBhbmQgeW91ciAzIHBhdGNoZXMgcGx1cw0KQmpvcm4ncyB2aXJ0dWFsIG1lbW9y
eSBkb2N1bWVudGF0aW9uIHBhdGNoIGZvciA2LjEueQ0KSSBkb24ndCBrbm93IHdoYXQgNS4xNS55
IG5lZWRzLCB0aGF0IG1heSBiZSBhIGN1c3RvbSBiYWNrcG9ydC4NCkkgZG9uJ3QgY2FyZSBhYm91
dCA1LjEwIChhbmQgaXQgbWF5IHByZWRhdGUgYW55IG9mIHRoZSBjb21taXRzIGluIHRoZQ0KRml4
ZXM6IHRhZ3MuDQoNCkNoZWVycywNCkNvbm9yLg0K
