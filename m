Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D92E5BAD5A
	for <lists+stable@lfdr.de>; Fri, 16 Sep 2022 14:24:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231593AbiIPMYS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Sep 2022 08:24:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231561AbiIPMX7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Sep 2022 08:23:59 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D47AB2769
        for <stable@vger.kernel.org>; Fri, 16 Sep 2022 05:23:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1663330987; x=1694866987;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=EozmnGyi+15XwscpReolSNtJTWQ4gw/rftd9bg3RtcY=;
  b=iMETSeswqjNl0wJCgrYbi0jEaCHh9IK7Sdf8BRotvObUK6NjtLBjoLr4
   Y9znbora0i7A9eobSHGrE48+A9wtILowbsaYTQu3ZUDj3SDaxAbLERqZv
   D5TeZOIoP9OL0ETe2cOjtYj644x6ZU85Trq0buz0bVylZDW8yW4pGBY/n
   mHtytFxxcwVZyDGkp/hmTSBPwZoz46JTF1OQMGOz8PnohVYHdJUwXHt2B
   DDOlzglaZd8ztzkPc48Gez0+d2n66XWONoZB7b/XyF/k+juA590Ny5wan
   rxJyjwHbG347MBWZ5sDq/J/zOhHZMr/JdLw5EiaIO+HvJPkXbc3hbf0SL
   g==;
X-IronPort-AV: E=Sophos;i="5.93,320,1654585200"; 
   d="scan'208";a="177488393"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 16 Sep 2022 05:23:07 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Fri, 16 Sep 2022 05:23:05 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12 via Frontend Transport; Fri, 16 Sep 2022 05:23:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=he/t3d3Nhd9Ts7gQutn3oaV9ywqcwRnUCddy0H7txMSBTVcbfla8vc8ZC5WlLoBlSvYz8tX1voTJc7JOInt8/GQV77Il53PE+ZluT9yGJTVJQEcqfRUmFMcbQ9p/b6QyZPh5CUPupDHtkoIr2oCyOzB6oYByXz0W3ahsUU0FVr71EDTpAuYV5hOJKLlyBITqqO7IpxOMxgvyC6z5rzjRA3OTsqarB1g+8FARq6nnQeL5X28QE1+9zlMoYSe7oMLko8wx5yb3peHBiO/DzhWWC7xPrsMHF1om1YBKnGkhtF0kGM4/E0ujDs2q9KPQ+LZR1emg2ocztLnW6XUZeUaj3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EozmnGyi+15XwscpReolSNtJTWQ4gw/rftd9bg3RtcY=;
 b=buSEoLL+cl/7Ib+as4pGJCuYMG4Ii7op2UxKh6M0xwehX15rnyVI5c1WwJON0pBBmi/P+uYWX4vCbGCZuSlFYaRQUM/SvHTjaOcdXFgV1+Fzl8NovoMbpt86F0ozW/FQSFpOKU8Ra6uHzJ3sKtnYscqEXadOXQEjZX6hzqcEq6dcfp3xtEXTlt52DZl/aZR3u0B1PrG+EkKU0V6mc2RR6SN4TvNAv0v6micZDXwVF9jDJIglMslCn7xWOJV73Z+NqeLnuJ64mV4pWqHwl2ghSc+XfZ8iltpEQCB1wHOjE8jSFBmiK4eGrn0JrvRcFYbhbTsxIfs4mlpxGug+g7FrFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EozmnGyi+15XwscpReolSNtJTWQ4gw/rftd9bg3RtcY=;
 b=uxe/PAwZNsUoHhp1FBK7niRpuLPHQxDlfxGOhMNqskVjkX8eT1zZ87R3wDGq2ieUp0cBOagPj+OZzdsNgCD8gQZeNLhzfT7SlZNUw2XL26y59iNvaJtXtE32g0VZeZTeONWuywTYZsh1bZAq0B3fm72jIC8DiQxhbOzITv/WVBY=
Received: from CO1PR11MB5154.namprd11.prod.outlook.com (2603:10b6:303:99::15)
 by LV2PR11MB6071.namprd11.prod.outlook.com (2603:10b6:408:178::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Fri, 16 Sep
 2022 12:22:59 +0000
Received: from CO1PR11MB5154.namprd11.prod.outlook.com
 ([fe80::545a:72f5:1940:e009]) by CO1PR11MB5154.namprd11.prod.outlook.com
 ([fe80::545a:72f5:1940:e009%3]) with mapi id 15.20.5632.017; Fri, 16 Sep 2022
 12:22:59 +0000
From:   <Conor.Dooley@microchip.com>
To:     <palmer@rivosinc.com>, <linux-riscv@lists.infradead.org>
CC:     <stable@vger.kernel.org>, <lkp@intel.com>
Subject: Re: [PATCH] RISC-V: Avoid coupling the T-Head CMOs and Zicbom
Thread-Topic: [PATCH] RISC-V: Avoid coupling the T-Head CMOs and Zicbom
Thread-Index: AQHYySX04J3T8cLKWE+kVDCBPlpova3gur0AgAFA/4A=
Date:   Fri, 16 Sep 2022 12:22:59 +0000
Message-ID: <4d7ab3d1-72cc-f1cf-15bf-50bbb64837da@microchip.com>
References: <20220915170900.22685-1-palmer@rivosinc.com>
 <4d943291-f78f-31ed-0d67-7073e1f762e2@microchip.com>
In-Reply-To: <4d943291-f78f-31ed-0d67-7073e1f762e2@microchip.com>
Accept-Language: en-IE, en-US
Content-Language: en-IE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO1PR11MB5154:EE_|LV2PR11MB6071:EE_
x-ms-office365-filtering-correlation-id: afc3cb2b-c828-43dc-0908-08da97de316c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: V2ql4O0JTeOVbcHpcHGDnZaBDgZehr3EsffuyUJbzmNz5/bhcLDvyFB1avyUmKv4527+s5x4h5+a8PJQNR7v12PhdQH8XtIB1wKgglKrt4t9EFL5fI74RiEwfdbkMgxKVX8A9bzVEocjMzk4VGGhOUCdyrp6McQ5hS76HFdr4Gjy0QCTIvq595XB7DsGrvDCK6b76i3XhLtmHwM+2kRJmto2iPYFahNn+lN1XphUAbYb1rte7FAEA/McarmttCiUlt4zA7Ug72P6Ev0AZ5/Ot78Ypf+Y//7/CoqJZgG0hjpg8KlQG+xpAKb+Gd770CZNpd+uZn/6XQx0iwkvu9c5tG/PFwFp4Y+7WsMhrgJSY3r6RNsQYt1oYnbGcb2KVyo5cn0DPfJwTykd73X0LRVMbX/tUHkIy2WJ1tCSYDHiuOjeWyvRJlw0M0KinNKtuUB7qMBLhPDGcCdVxZPskzPMZKzfoIw9dTU7PCn11mNVWHfG5CiXYhSxtg9PoWnWXnvCHsIlsVRj44r+U7rIxqeAQDKjQt4rUFNNXsuusT8I7vkPgvbVGD6juBSnpCBflksvGX/UGEpXJwhGqlT+3Ser7tpQ7E8aIZR2pM7Tanz+Mx4qZKZ9dgZYyNx25RQiQx2vnveWbp9h1Pf7vBYTbHbn4bIdCUqjOPY0DMHI7VA9jsxi+E/lI2M2S3zUEPmyjjberDqp7zbrx4sKiZ35acChOeXGuoHOXJWBkgj+WWeeqRp91jSaJikvTVehyNy6YXh/fViHJus2R/iWSayQHYQ8HLlKZdNIrrR5jUiEh/eZT92+JAQWaBj1kHdYKtOgtBqsfyYtWdjYi8UV9SYDrNBfGA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5154.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(376002)(39860400002)(136003)(396003)(366004)(451199015)(4326008)(26005)(110136005)(76116006)(6486002)(122000001)(54906003)(86362001)(66446008)(66556008)(5660300002)(31686004)(8676002)(316002)(66476007)(478600001)(38070700005)(36756003)(8936002)(53546011)(64756008)(6506007)(91956017)(6512007)(2616005)(186003)(83380400001)(66946007)(41300700001)(71200400001)(31696002)(38100700002)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YTduU2g4QWpoMWVXZFdjM0laL2lkT2RiTzl6aGFxMXlON3UyM0c0UWxWVzls?=
 =?utf-8?B?WkJIUXF5dkxvazE1Tklra3NFd2NBOUJPY2VBR0l6Wk81RDExNEVUU09nRndR?=
 =?utf-8?B?NHdCVFJrOGc4azVtNnNUZGZXUFVsV2tPUDlRQlZhMytVZ1Q4VVY5ZkR1RFdx?=
 =?utf-8?B?YzZhOHN6MFZGMS9XcnhSLy85OG5OZVV3TlVERlZGZkpQbk5TMEZEcEY3ZlVI?=
 =?utf-8?B?MXRhMTc1MStaako5WU1aS0I4aVBiakltaG53a1NxQkxMWmNTRlpRV3FtdmhT?=
 =?utf-8?B?eVYwSEtHK0tnaEQzQXpjTHFHWVZBMnM3M1J4Y3V1c3BOY3psOVBiNFRRZG5G?=
 =?utf-8?B?VWxwYk5XTEFmTS9MNVpIMzMxZG1rSmpza09pdVFEdEtrcHVRNlBJQUh6MzN6?=
 =?utf-8?B?Nkd2QXd3bi84TmFWNEtkUmtEODZCd2pHWUJETWVVeHJHaG8xSmFZMndEang0?=
 =?utf-8?B?TGRZT1NCcEVSNG5yblVkenFhcnExQzFpRmxmZEU1dU04ekJPSXoxSkdlN09p?=
 =?utf-8?B?b3VKdVFCWXlRL2JBSDZ5Tk91UzNYMVpZTSsvQ2FWUHhxcm9LQTI0d2RnV1Mr?=
 =?utf-8?B?MCtaY3dxRzNaeHMwUFk4cEhmTnh5WVV5bktGVStadnlTYlQxSkxZQm1vWEdV?=
 =?utf-8?B?S0dPbXFuaEhLMlZYd284SWZYcXplV2d4K2xFNkcxWkoyaVplTjNIejJhT2Zp?=
 =?utf-8?B?SmlGenBUcDdNNk4vZjY4R3pnRVpULzJWMjIrRzVvUmUveEFXM2Y5SkNnazNi?=
 =?utf-8?B?S3RzWSt3RUhQSGZXQlQ5Q0h3dE92ZUZFdXhnZ3dEZ0xLSDRtSkx0Nng2YktO?=
 =?utf-8?B?ZVpXdUliK0xxc2NKUklsWUJSYTJGWWlMVnNZRGdNOTB4OCtJMnRNSzBiT0lN?=
 =?utf-8?B?YnVLQS9kNi8vUFNRUGdyaGk0bWNVamgxZ25hMk8zMzZtMDJ1R0V3c1lpWlpD?=
 =?utf-8?B?eTNLVWNhUWxBU3A2T1hONzN5TEl5MTNqdGNWbHVpajNFZmd2dWx2eUNVb3li?=
 =?utf-8?B?bFJkVnpVWGN2am1UTDJ5ODVYaS9PNE1IQXZ5S3BmT3h1SkNESzEycWZIY014?=
 =?utf-8?B?b0hjMnR4MWROYTJUUXcxeWpCUEN5Wm1nN2FzVnBkZVlFRkttVDdzbTE4TXBx?=
 =?utf-8?B?enNQdkQ1NXJUZEFmaTUxVWdocGxBS2w3TWJXTjhUWTMyNndRMUN2bUQ2OEdK?=
 =?utf-8?B?RVFiRWFEa1doK3VkeTJqSGI3KzQwbTBDV0hEUFJkRGoya2xmU3hRRVpQWE1R?=
 =?utf-8?B?Vm80a0lVbWZpS0tKcnpNd2I3TktnZnloUXV6VW5pQ21oMEsrY0dVeDJMV2tI?=
 =?utf-8?B?Ym4yUzF6VCszbW8vRm93SmQ2VTlTT0tFK3pKRzZkZ3RxbHMybVN5R3V6WTht?=
 =?utf-8?B?bFVWQlhlQnB4eGVlOXFDRXp5N0N0bEY1bTYzM1V0WjB4K3JGMFFCNStZTGo5?=
 =?utf-8?B?V1Z2YWpOekczbTMvbHg0aDU3QThGOXlNV2RTSkNMZkx4Y3czZXNuRnZud2hn?=
 =?utf-8?B?VFJQZlEzeFNqMWNtTzhZUkozbHZCR0R4VmV5NTA1NXo1bXFPZTZ5NXRDdkVj?=
 =?utf-8?B?SU0xTHdUSjBzMnlKVnJwQXY2NENXbVF2TklPMFFQZHBJNVdKVHZJS3V0Q3Ux?=
 =?utf-8?B?Qm9kSi9LaXpLeDZVeHh1NXhtRk1sTXVmeDZhU3d2ZzNwM05KeEU3NUIrdTVQ?=
 =?utf-8?B?VlNTK09CUVdzWlVMNEo0clBkQlU1ZDVYZXUxYkRicGM1RUd2cFE5Y1lhY3lp?=
 =?utf-8?B?Y0ptSkkrSmpSVjF0NWNxS21mNEJBWkxETEYyc1gyeHRRV1IzbGpiam50NHJl?=
 =?utf-8?B?L2xNZzZuUzlCdGpkVWEyVnVCeWUwU0VrRXBqVVo3Vk45MG5sSE4ySlJxaVBC?=
 =?utf-8?B?R0ZVZm9xN0pmTGtzRmVOd21YL1gzcWZLMzZHbXM2U0V4QVhFbzlwSGtVaEdW?=
 =?utf-8?B?N0ZTM1p5SU5sMzdtQ21qV21KYnlQTUF6eEE2bktTSURuWm1pRkl2KzdOcHhJ?=
 =?utf-8?B?Wmc3RHhXaTdqcXFvWC9teE9ZRDY0cHJLM21POGdkZENpdEJpTkF6S2tsWTNj?=
 =?utf-8?B?MjVtLzF0NkRuUXUvUzZVNVc2WjFiNklYY2NNalZLUEIrampZUlYrazFZaU42?=
 =?utf-8?Q?gZCKJ4V9Cuu7T7ZLPzk9yTSKP?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7D6CD9A04AF51E40B6083CA7875C9456@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5154.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: afc3cb2b-c828-43dc-0908-08da97de316c
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Sep 2022 12:22:59.3887
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PPlsXQ09oTGqADte0BAHA+xWull3zMXJAnf05xovoC6kJlt38C01jfQ4TGeW8COnwb9MxpskCEOehNDGHPoKKgH/QI7hk9RqrK2ZbQ2ZekI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR11MB6071
X-Spam-Status: No, score=-6.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gMTUvMDkvMjAyMiAxODoxMywgQ29ub3IgRG9vbGV5IHdyb3RlOg0KPiBPbiAxNS8wOS8yMDIy
IDE4OjA5LCBQYWxtZXIgRGFiYmVsdCB3cm90ZToNCj4+IFdlIGNvdWxkIG1ha2UgdGhlIFQtSGVh
ZCBDTU9zIGRlcGVuZCBvbiBhIG5ldy1lbm91Z2ggYXNzZW1ibGVyIHRvIGhhdmUNCj4+IFppY2Jv
bSwgYnV0IGl0J3Mgbm90IHN0cmljdGx5IG5lY2Vzc2FyeSBiZWNhdXNlIHRoZSBULUhlYWQgQ01P
cw0KPj4gY2lyY3VtdmVudCB0aGUgYXNzZW1ibGVyLg0KPj4NCj4+IEZpeGVzOiA4ZjdlMDAxZTAz
MjUgKCJSSVNDLVY6IENsZWFuIHVwIHRoZSBaaWNib20gYmxvY2sgc2l6ZSBwcm9iaW5nIikNCj4+
IENjOiBzdGFibGVAdmdlci5rZXJuZWwub3JnDQo+PiBSZXBvcnRlZC1ieToga2VybmVsIHRlc3Qg
cm9ib3QgPGxrcEBpbnRlbC5jb20+DQo+PiBSZXBvcnRlZC1ieTogQ29ub3IgRG9vbGV5IDxjb25v
ci5kb29sZXlAbWljcm9jaGlwLmNvbT4NCj4gDQo+IEkgYnVpbGQtdGVzdGVkIHRoaXMgbGFzdCBu
aWdodCB3aGVuIEkgYWNjaWRlbnRhbGx5IGZvdW5kIGl0IHNvOg0KPiBSZXZpZXdlZC1ieTogQ29u
b3IgRG9vbGV5IDxjb25vci5kb29sZXlAbWljcm9jaGlwLmNvbT4NCg0KVGhpcyBpcyB0aGUgb25l
IHlvdSBJIG5vdGljZWQgeW91IG1pc3NlZCwgbXNnLWlkIGlzOg0KNGQ5NDMyOTEtZjc4Zi0zMWVk
LTBkNjctNzA3M2UxZjc2MmUyQG1pY3JvY2hpcC5jb20NCg0KPiANCj4+IFNpZ25lZC1vZmYtYnk6
IFBhbG1lciBEYWJiZWx0IDxwYWxtZXJAcml2b3NpbmMuY29tPg0KPj4gLS0tDQo+PiAgIGFyY2gv
cmlzY3YvaW5jbHVkZS9hc20vY2FjaGVmbHVzaC5oIHwgNiArKysrKy0NCj4+ICAgMSBmaWxlIGNo
YW5nZWQsIDUgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQ0KPj4NCj4+IGRpZmYgLS1naXQg
YS9hcmNoL3Jpc2N2L2luY2x1ZGUvYXNtL2NhY2hlZmx1c2guaCBiL2FyY2gvcmlzY3YvaW5jbHVk
ZS9hc20vY2FjaGVmbHVzaC5oDQo+PiBpbmRleCBhODljMDA1YjRiYmYuLjI3M2VjZTZiNjIyZiAx
MDA2NDQNCj4+IC0tLSBhL2FyY2gvcmlzY3YvaW5jbHVkZS9hc20vY2FjaGVmbHVzaC5oDQo+PiAr
KysgYi9hcmNoL3Jpc2N2L2luY2x1ZGUvYXNtL2NhY2hlZmx1c2guaA0KPj4gQEAgLTQyLDggKzQy
LDEyIEBAIHZvaWQgZmx1c2hfaWNhY2hlX21tKHN0cnVjdCBtbV9zdHJ1Y3QgKm1tLCBib29sIGxv
Y2FsKTsNCj4+ICAgDQo+PiAgICNlbmRpZiAvKiBDT05GSUdfU01QICovDQo+PiAgIA0KPj4gLSNp
ZmRlZiBDT05GSUdfUklTQ1ZfSVNBX1pJQ0JPTQ0KPj4gKy8qDQo+PiArICogVGhlIFQtSGVhZCBD
TU8gZXJyYXRhIGludGVybmFsbHkgcHJvYmUgdGhlIENCT00gYmxvY2sgc2l6ZSwgYnV0IG90aGVy
d2lzZQ0KPj4gKyAqIGRvbid0IGRlcGVuZCBvbiBaaWNib20uDQo+PiArICovDQo+PiAgIGV4dGVy
biB1bnNpZ25lZCBpbnQgcmlzY3ZfY2JvbV9ibG9ja19zaXplOw0KPj4gKyNpZmRlZiBDT05GSUdf
UklTQ1ZfSVNBX1pJQ0JPTQ0KPj4gICB2b2lkIHJpc2N2X2luaXRfY2JvbV9ibG9ja3NpemUodm9p
ZCk7DQo+PiAgICNlbHNlDQo+PiAgIHN0YXRpYyBpbmxpbmUgdm9pZCByaXNjdl9pbml0X2Nib21f
YmxvY2tzaXplKHZvaWQpIHsgfQ0KDQo=
