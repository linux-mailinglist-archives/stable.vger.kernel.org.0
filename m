Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9ADF84F311C
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:39:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244241AbiDEKiW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:38:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240432AbiDEJe1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:34:27 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 818C633EB2;
        Tue,  5 Apr 2022 02:23:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1649150636; x=1680686636;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=+h+jikCQ+5iYylWUvQo8dCvHo5WVl19JmCNY58oxNiQ=;
  b=qQ08ShWxqypLR0Ajc6YRg9vulV9ImZksBaKBEs4oJmndw3LFSxOHYuii
   w+w0ZN2p7+7ZXdWhFGQZJCLsMSEVWXGqn8zwPC9bkCrzEKBpwFqSddyv5
   KWAw4ZOj6HsCZIqKa1rpuj1dIUU/QiyX5OxyH5TJ2xddQpeedH89dfaeB
   gEC26S0ui/zIyI1/oyYE0iAp53mWdivD3q8/u1lESoZOtG2ZsAXzPzUTJ
   Byj6esYAkumqG2REg+EAWWLZjDC71+XMA1B+sriS6RBlR/H4OM3gsryZC
   XFix25TWfsCSEr6gZqMWfXGVEZZq6Y9181823Sm5Uyiy0ykBDI1APzukl
   w==;
X-IronPort-AV: E=Sophos;i="5.90,236,1643698800"; 
   d="scan'208";a="158905544"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 05 Apr 2022 02:23:55 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 5 Apr 2022 02:23:54 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17 via Frontend
 Transport; Tue, 5 Apr 2022 02:23:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BZSIKJ6ziiR3a/+nBsL4Ox9bgYtBDBC86DQ72XBEXHsb0xtIgV45C3WrzNHv3qOURXFG0TvWSp++dvvRh+GxQghAlU+SHpJKvon4VEqA5A7WZbPPaChMUHvmCjQ88I7Haku/kWkjM50TZnVzvVMq6TphYcEumgqyzYDpaQDVCjBCSXnC+3aUSsw4m6Aoi4eRV6Yx9asqn2jFcmuYlioDAUXyLOAfR9kgJB0Kzpb0+8defShOjd4ICBSKn/YAcpszGhsM5XDdouVMzZIxJ5y25PKunx3kbpsk/gXhzLj22ghV9aqh0dMMpmT/i+jAdCrfKtVkj5OonF/T65luzUBlGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+h+jikCQ+5iYylWUvQo8dCvHo5WVl19JmCNY58oxNiQ=;
 b=ke7ZNeqVZTtoU9e7ZwJyr1ceZoUUqicOyDr5PgYSl949shUNTehhvZKnQxWZ5dCk9ws2jKFQfYZIgsNyKQUOZ8oWwG6SFKvIB9YqJLI87v7cWu0Lp7OxlKIWGkZOJnghNIYd45TnB6S8L2BRKPgOk0k7On7rEkNuuJXJDAKzQCJymrLYbokKCV16/CFuOur62HdH0/bHLcZbI1P79KZNOdZY9ghCFOvqimmkNKK/BeAE3ZgiU8rI5+z+WelOJV8qztrFlfbPG+wI+RpKyZiZjsjNqFGQTt3DXm6Bup9WD4AyLkb7qq//IycY9gG55YTAg9FxGFa+u6d5t9w/8AmGnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+h+jikCQ+5iYylWUvQo8dCvHo5WVl19JmCNY58oxNiQ=;
 b=djB4IZgDY9eUx8D3ogwvUJ2m2BB7NO2GSp9DDyz4BbaUqNKJQhI1k8KmWkSE8+O3IbqwFlS5BvfF6kVG7752Et6HCQrmtHZ52iJX6vcRRGu+jUBCSRyNuJ2+Sd0l8UVJrVmjCrPWl9HHQOJJQogPJiUfNcK8OAtjnWVHgt6m3yM=
Received: from DM8PR11MB5687.namprd11.prod.outlook.com (2603:10b6:8:22::7) by
 MWHPR11MB1808.namprd11.prod.outlook.com (2603:10b6:300:10f::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5123.31; Tue, 5 Apr 2022 09:23:46 +0000
Received: from DM8PR11MB5687.namprd11.prod.outlook.com
 ([fe80::fc32:96a4:933f:194f]) by DM8PR11MB5687.namprd11.prod.outlook.com
 ([fe80::fc32:96a4:933f:194f%5]) with mapi id 15.20.5123.031; Tue, 5 Apr 2022
 09:23:46 +0000
From:   <Codrin.Ciubotariu@microchip.com>
To:     <michael@walle.cc>, <Nicolas.Ferre@microchip.com>,
        <alexandre.belloni@bootlin.com>, <Claudiu.Beznea@microchip.com>,
        <sumit.semwal@linaro.org>, <christian.koenig@amd.com>
CC:     <linux-i2c@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>,
        <dri-devel@lists.freedesktop.org>,
        <linaro-mm-sig@lists.linaro.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH] i2c: at91: use dma safe buffers
Thread-Topic: [PATCH] i2c: at91: use dma safe buffers
Thread-Index: AQHYLxo2SrBDkK5iS0KDJl/Ehr5HqazhP32A
Date:   Tue, 5 Apr 2022 09:23:46 +0000
Message-ID: <46e1be55-9377-75b7-634d-9eadbebc98d7@microchip.com>
References: <20220303161724.3324948-1-michael@walle.cc>
In-Reply-To: <20220303161724.3324948-1-michael@walle.cc>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 92e249a4-4fdf-4c36-3ef8-08da16e5fc45
x-ms-traffictypediagnostic: MWHPR11MB1808:EE_
x-microsoft-antispam-prvs: <MWHPR11MB1808803BBD1EA82AA543F11FE7E49@MWHPR11MB1808.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sW+EUAnCKaamwVKKWxDaw+uVUeY5IzDxW5eDNsDl3A9IABfC8WziVRO2u1Dcyt+8bwoCftQAc2ER0p59IyqljvSfYukTUTVuTL5sVNcDEIloNQYMZDcHatTVxD0C7Dfc/vIBBjTQn64E/L6MDTYvU3IB4bCQHNzIaLw4i4vPLfwHX3kehZkFyMn5Y6rYT55vH5MT/lf//reONC/YVCJb9L0DFSIz32xeU96A/yp03v2ZTkmeIDU6aJpbp6ZvauBJWAUMpbAGg+3t24W9A8Hh2YvZuqmNR66erR/N/hYFtueMzUTn+4rXs69mP1mEUYMrpD16qZo3fmdN6/EpKaRFlow6C6v2Zaf9ysclB8yn3yf6hX0Z0gzbZRkg18/ahxUb20NCNrdyRB+fqNKJxKzlLcDtuOSCjTUg1U3g3vqTtSOC6NJlKkrIZcV6/pmWszSWjyeDB1wKu+hM6PSJRRT5hYiPfwF2b9OOkuxkpDz2T4Xm6dlHpJDRoB4hltZ8PPdFSpboBk4PcntIRqLWDcFaMKf93NpPVV+3GEpFcVuCr3OoNoR47QjrpJl/jf2Uwu6k6alGZOWzB/FeVjVdnUPR1Bdkjeu/iYY6ZZhQP1Wy/6beSs+o7aCWO2G0lNrfLSggoLF8BfZ7kePGC69TlgMQQslN83j31MwQH85HNeKcHPAjL4dRsPTaxSYAebmONcFvSJcAgJynJrzAQ1x27NxxW2/NUUI2PbyNoqlQ4yHYXzu+SANsUIlaRfRiD1UosJaWcHSGMjnS9vfJBQMzQccgRg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5687.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(316002)(66946007)(76116006)(2616005)(31696002)(4326008)(110136005)(66446008)(64756008)(66476007)(8676002)(66556008)(91956017)(6512007)(38100700002)(122000001)(54906003)(86362001)(6506007)(53546011)(71200400001)(6486002)(508600001)(38070700005)(4744005)(8936002)(36756003)(5660300002)(31686004)(186003)(7416002)(83380400001)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?b29URVJqOXZTdGtubVdNU1h4ZlJJR3drY2NpdDBvcXUyY05wbEJ0M0loeWVk?=
 =?utf-8?B?SVB5VnE3ZXdWR2xYcXRacmZueGdEZGRuM00wYkIwem1MWUZRRDBMczZRc05W?=
 =?utf-8?B?blIzR2Q3WWJ2bEppL1FaRzMwemZWRFd1MHVSOWN4MlRmVWY4UFJ4MmdkcmtH?=
 =?utf-8?B?WWs0WkZLZlVXZGpucnUzNzlTSnh4a25pTi8xU3U4b0UyWGIxSk95dGs2VmJQ?=
 =?utf-8?B?dklqQWJkeXhKZDhENW1qeW0rSmMxaUlhaFpZQ2FJRllQaFFFTVJ3TGNTQnpo?=
 =?utf-8?B?RHd5UmVwaEN6WVREZ0NJdWZ4ZCsxa3REaEsyOUZsSlduUW81THZlaWNNeUJ4?=
 =?utf-8?B?WlpBLyt2aXQzYlhQQmRLNVhxcSt5YTRrVVBnWVZLZlkvNDJrclZUNStsSlJR?=
 =?utf-8?B?QXQ0Q1dmdmJyN0V0cytJb2VEYm9kWnpLQ3dEMXFlanFKK2RhdHdMck1yUkRn?=
 =?utf-8?B?QmUwZDBPNGVaMkFGNEJ3czdtVWdSNGZIU3NYTXFXR0xTbno3ZUtSNEJxUmRs?=
 =?utf-8?B?V3JNbmUxUURUTG1yUGVKMWhvbFEwdWdJS3c5bXlOOVFDSDRCR0xDeEZUdDda?=
 =?utf-8?B?Y3ZJcEJ2ZWtRMWs3a3hIaExkTHRTcXBlUTZ1MU15U2trWkc4WEk2Y2ZkY28y?=
 =?utf-8?B?RENUNG9aWm9FT2tZczdUV1J3RmxBN0dVU3RLZXl2YmJEUnJkNG1xbWdJOHk3?=
 =?utf-8?B?cVQreFZEUVVSd3lZbGs1aG9BL1JtWEFBaVJBSERTNlFQZk5COGN4YzFVa3Nk?=
 =?utf-8?B?TVAyRzcyNXNteGFnNkJGenV0M01vcmNLRFBlUHYxaXlMc3dDRnhkQzB6YjA1?=
 =?utf-8?B?NFlBMDk5OUNYMTdrQ1B6K0dyUmpzWFFQOEU0TTNtRUNjc3lDZTl1eGlCYTBP?=
 =?utf-8?B?MTNGWjEzN0RiY3JIUlp3a2RhTVJOZTRaYW5tbkwrU2xEdGRNM1IrNEhld3Ew?=
 =?utf-8?B?MzRIbjNtdTBjbnVRWm1aRS9KZDMzME8xTVk0RHFNTUFHUGVhbHR4THZEUm1q?=
 =?utf-8?B?RVA5aStMNGtiVmdyb1Y3WUJlcVlwejJxQ2I3NEpMMTFVR083SUJ5TGFvWmVs?=
 =?utf-8?B?S1A1UXF3cjU2UHJDSnF6QlFWMlFpcEZGeEpmNVpNNmt1MS9CRXl6MUhKV2ww?=
 =?utf-8?B?TTdIMkZQZVZWdzlqNzRzQzY1cGdoaGdrSi9zcDNWTSttR3BVV2swT0tvdXZl?=
 =?utf-8?B?bTNLY3JDbW1YUlhuMlkvR0JMUGpmWnJITEEzY2h2RnNKcnYwU3h3V2V3SW4v?=
 =?utf-8?B?bElVSkx4SE1XclZOQ2NMU0hJSlU2bkJoc1pKbXZPRThtTDg1ejB4Kzk4Q214?=
 =?utf-8?B?YVVJSFZXbkZZblNYREJRS25LS0szbnhwQlRrNkY5endtNGdjK0hwM3FuOWty?=
 =?utf-8?B?R2RxUmNNcTBIVkJuU002d0s2WTk3c0pHWWQrKzBQSGdwSFhoejRWSHBGa2lG?=
 =?utf-8?B?aC9nbTBJdVJPeHlVUUVZZllVSHlVZUpQaWdPeENiRm1oSHUwQU12Qk9GYWFE?=
 =?utf-8?B?UW1ZTHNkaG9vN3g3V3c3S1FaYll3dCtlaWtubWNOUGxOWnJwY1Vjc0FYRlRE?=
 =?utf-8?B?WDM3Y3RHNkxiek4vOURGQ0NhU2g4U2RaU2UxU0drRHo3aEZvTWdjRDJNTTFy?=
 =?utf-8?B?OFY4NFk2MHhoRUl6UWlVMmdVeUdFRzFqdkJnNFNUUWVCQzFGU2RnZWg1NjMy?=
 =?utf-8?B?eDRDcnFTRmlORkFsQXFoSUozVVJMREJtdVBkNnhBdUFxWFQ3RnlidlFNRXBU?=
 =?utf-8?B?c0tKQ2pCUG0xcHczVkZKTEVJcndyZXZrNU52MjBQbTFzUWN3ZmQxKzVUS1BB?=
 =?utf-8?B?c3psb1MzdktaV0gzZklqL0s0SFNtSW5qVWoydDdmV3NqNEtMdzhYSmlhSld3?=
 =?utf-8?B?bTFSd2VpcnB2cXZQSHhHVEtQNG1oMnVtMG5USEcwMW11QW42ekFxNGloMzBC?=
 =?utf-8?B?ei9TYlhRTlZCNnNmNFV1OVVpVVZQMTh0SURqZWF6aTZEZUtqTnRFamNyclNM?=
 =?utf-8?B?WDEycUloSHpkdS9nUEtxTVVRaFpCdjVIUzNMU1RXTUVjSURNR0dJbnhRSDJF?=
 =?utf-8?B?V1RadU1sbm9zWDBOc0Y1K3ZYUENXa0lsajV0Znk1enNqQ1FiR01GZEIwUXNp?=
 =?utf-8?B?cVFLTzExSkhrQWIzMnA2Q25jb09zK2ZRekNxUENPcmhVdm1sT3lwNlRWelB0?=
 =?utf-8?B?aVl3WWl1RlFqVTVRZHFnaDVYUzh1TllIbTlhc2ZRMVNCNEw1emUyUUFCOXJ6?=
 =?utf-8?B?NVMyaGplcXJQQWhDZys3dmhjdXZQdmlkUkc4R3FkeTRhNkxYWm1pWmpWOW1q?=
 =?utf-8?B?djVrZlRCODR6b3NocEFMRGJxNUpZU1gyQ3E0R1RVQ2dOVlc1OTVFTTcxS1dO?=
 =?utf-8?Q?0I/VwiNOk2tgcK0DXmC0aEMdO8u2+Xz7KjkYbucmU65np?=
x-ms-exchange-antispam-messagedata-1: 9HQQSVFuWmARf7h5Uy0dszM9b6rwUAYYsUs=
Content-Type: text/plain; charset="utf-8"
Content-ID: <148B9DECEBE93945BF270F6969AA7E99@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR11MB5687.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 92e249a4-4fdf-4c36-3ef8-08da16e5fc45
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Apr 2022 09:23:46.1283
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Tp1e0qCseNptLvPjq0OKIy1Cy9iZAH+D/RFoh8PPUhTn7EWsDkJ5hNlmC9gIb0WWD0PsYBTcf0a+qPCbBJZuw+cXYM1UnoRZgG3dHdMS/Q0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1808
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gMDMuMDMuMjAyMiAxODoxNywgTWljaGFlbCBXYWxsZSB3cm90ZToNCj4gRVhURVJOQUwgRU1B
SUw6IERvIG5vdCBjbGljayBsaW5rcyBvciBvcGVuIGF0dGFjaG1lbnRzIHVubGVzcyB5b3Uga25v
dyB0aGUgY29udGVudCBpcyBzYWZlDQo+IA0KPiBUaGUgc3VwcGxpZWQgYnVmZmVyIG1pZ2h0IGJl
IG9uIHRoZSBzdGFjayBhbmQgd2UgZ2V0IHRoZSBmb2xsb3dpbmcgZXJyb3INCj4gbWVzc2FnZToN
Cj4gWyAgICAzLjMxMjA1OF0gYXQ5MV9pMmMgZTAwNzA2MDAuaTJjOiByZWplY3RpbmcgRE1BIG1h
cCBvZiB2bWFsbG9jIG1lbW9yeQ0KPiANCj4gVXNlIGkyY197Z2V0LHB1dH1fZG1hX3NhZmVfbXNn
X2J1ZigpIHRvIGdldCBhIERNQS1hYmxlIG1lbW9yeSByZWdpb24gaWYNCj4gbmVjZXNzYXJ5Lg0K
PiANCj4gQ2M6IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcNCj4gU2lnbmVkLW9mZi1ieTogTWljaGFl
bCBXYWxsZSA8bWljaGFlbEB3YWxsZS5jYz4NCg0KUmV2aWV3ZWQtYnk6IENvZHJpbiBDaXVib3Rh
cml1IDxjb2RyaW4uY2l1Ym90YXJpdUBtaWNyb2NoaXAuY29tPg0KDQo+IC0tLQ0KPiANCj4gSSdt
IG5vdCBzdXJlIGlmIG9yIHdoaWNoIEZpeGVzOiB0YWcgSSBzaG91bGQgYWRkIHRvIHRoaXMgcGF0
Y2guIFRoZSBpc3N1ZQ0KPiBzZWVtcyB0byBiZSBzaW5jZSBhIHZlcnkgbG9uZyB0aW1lLCBidXQg
bm9ib2R5IHNlZW0gdG8gaGF2ZSB0cmlnZ2VyZWQgaXQuDQo+IEZXSVcsIEknbSB1c2luZyB0aGUg
c2ZmLHNmcCBkcml2ZXIsIHdoaWNoIHRyaWdnZXJzIHRoaXMuDQoNCkkgdGhpbmsgaXQgc2hvdWxk
IGJlOg0KRml4ZXM6IDYwOTM3YjJjZGJmOSAoImkyYzogYXQ5MTogYWRkIGRtYSBzdXBwb3J0IikN
Cg0KPiArICAgICAgIGlmIChkZXYtPnVzZV9kbWEpIHsNCj4gKyAgICAgICAgICAgICAgIGRtYV9i
dWYgPSBpMmNfZ2V0X2RtYV9zYWZlX21zZ19idWYobV9zdGFydCwgMSk7DQoNCklmIHlvdSB3YW50
LCB5b3UgY291bGQganVzdCBkZXYtPmJ1ZiA9IGkyY19nZXRfZG1hX3NhZmUuLi4NCg0KPiArICAg
ICAgICAgICAgICAgaWYgKCFkbWFfYnVmKSB7DQo+ICsgICAgICAgICAgICAgICAgICAgICAgIHJl
dCA9IC1FTk9NRU07DQo+ICsgICAgICAgICAgICAgICAgICAgICAgIGdvdG8gb3V0Ow0KPiArICAg
ICAgICAgICAgICAgfQ0KPiArICAgICAgICAgICAgICAgZGV2LT5idWYgPSBkbWFfYnVmOw0KDQpU
aGFua3MhDQo=
