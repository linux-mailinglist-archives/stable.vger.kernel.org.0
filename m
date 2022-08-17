Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BC6859757E
	for <lists+stable@lfdr.de>; Wed, 17 Aug 2022 20:04:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241107AbiHQSEa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Aug 2022 14:04:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231196AbiHQSE3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Aug 2022 14:04:29 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B81235E570;
        Wed, 17 Aug 2022 11:04:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1660759468; x=1692295468;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=TJ+obnNYX1oseTeRQnvAsiFWMcRJshTIfFGqkEI2EjY=;
  b=gM8VaGzuft9HQ1FBEyA4ldFkY0pm4l1TszfFc72VUlvnrM/5GhrMRbq9
   kP4y1RfJWw8e1ZUehXfYzFl3nTkKBI5RReb28ViXUacUx2VwJWSQcQqn6
   7fQdwdkxWhRzBmh0dYeypvjPygdPy51qxIn6+QjhzaRNC6PMvMdGkuM/j
   O7iHbvfcNdBFC+3MndliZ28BEgx749XJv/kI7XdVkVR08Zwhxh6l3Dp6e
   j9D8BC0GjLCIyLEaw9yggh9i2EkvGm4w2Gj8YrkirKBErHNnJkdmXkbJC
   MJtBfy5AK1mEBVrx8oRKtwBt4SKHZBhnjomXVZAWvkTVieG0z9YUbWfvX
   g==;
X-IronPort-AV: E=Sophos;i="5.93,243,1654585200"; 
   d="scan'208";a="176658523"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Aug 2022 11:04:27 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Wed, 17 Aug 2022 11:04:26 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12 via Frontend Transport; Wed, 17 Aug 2022 11:04:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DkO4HMwFJ+Ho2FN3FGo56ISqFLLSnmbtsQwcQFwpHSByT8Y3cpKjWfT3qi0e2VYGgdYFJwrk1p1AxVgLCH7Y94JAcT0rPA36L68UgVBuQHgYP5Gf9naqkc4eQxq/YRwhwQV3TTkfIFotvOEOz/PT+O7xq05mZy0o9z5WzmDDdKChwTs2eu9SGU4k7jjA4+CR0Bh0IltQwC8cFKbgqXYGgycPnqplNCottvVdpYdJz7G6V09f4vz5s4bEMTN6lbq5yyc8J3Z/lstdY+TfSS1wsuGDqzCtHndfAOqOtSClVfoftZ4uOA/xu1orwQm6ZXZOZwHECN6YKsKP0xptfZAJbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TJ+obnNYX1oseTeRQnvAsiFWMcRJshTIfFGqkEI2EjY=;
 b=WX2WvhYgzVi7VGDQSjOWnlqIrS8aJWL+K+4Jetctd5AbUXWCYjdIVWZnGv05GEQL1OWKjwtgWqPo6Td7KemEqXJTXd1jzaSlnZMCmNgqkvsDqg3yyVWJmiyP0W3uCWadFNUWwD1rDwemoOMkZWz4+WZCs97vUNIx/+4bD+nOjDJ6hP3fEufQ9L94KcnlDfveFw8bvOMx81NDfoCtlE9MIkGYJ+tDfe/IIOzhkgOGW2TTL/paQbAjAdVvsZtYQWDz2uOaD6fPiQkznBcanHG/v3vtGm5lqECkwBRAq1ba8avh5XfqYhwaldTyt7zxJvMOR5+wQYTZDsDSuOJLhdSECQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TJ+obnNYX1oseTeRQnvAsiFWMcRJshTIfFGqkEI2EjY=;
 b=rGOENW9Y4g3+QFFlXBII9OMkYUF4DplSgUsdeic4sDShfRGBNACqMrxGt2lsQ2hmlmofW303CIhnr+7MplsgMNMXRNTIo66PTIlvoCk4ZD5uMD1J/t1Duy8WfXQ5WMg3qI+T/VPFMBjhfXc4zHqnz3g94bXh4A5rSJ1UhA0OvxM=
Received: from CO1PR11MB5154.namprd11.prod.outlook.com (2603:10b6:303:99::15)
 by SA2PR11MB5193.namprd11.prod.outlook.com (2603:10b6:806:fa::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.11; Wed, 17 Aug
 2022 18:04:21 +0000
Received: from CO1PR11MB5154.namprd11.prod.outlook.com
 ([fe80::ac89:75cd:26e0:51c3]) by CO1PR11MB5154.namprd11.prod.outlook.com
 ([fe80::ac89:75cd:26e0:51c3%8]) with mapi id 15.20.5525.011; Wed, 17 Aug 2022
 18:04:21 +0000
From:   <Conor.Dooley@microchip.com>
To:     <heinrich.schuchardt@canonical.com>, <robh+dt@kernel.org>
CC:     <paul.walmsley@sifive.com>, <palmer@dabbelt.com>,
        <aou@eecs.berkeley.edu>, <geert@linux-m68k.org>,
        <emil.renner.berthing@canonical.com>, <devicetree@vger.kernel.org>,
        <linux-riscv@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>, <atishp@rivosinc.com>,
        <krzysztof.kozlowski+dt@linaro.org>, <Daire.McNamara@microchip.com>
Subject: Re: [PATCH 1/1] riscv: dts: microchip: correct L2 cache interrupts
Thread-Topic: [PATCH 1/1] riscv: dts: microchip: correct L2 cache interrupts
Thread-Index: AQHYsjzjuV6JQqnbNU6bXELDL6GyqK2zYxOA
Date:   Wed, 17 Aug 2022 18:04:21 +0000
Message-ID: <32a72954-c692-6c5d-b07b-266d426c3cb4@microchip.com>
References: <20220817132521.3159388-1-heinrich.schuchardt@canonical.com>
In-Reply-To: <20220817132521.3159388-1-heinrich.schuchardt@canonical.com>
Accept-Language: en-IE, en-US
Content-Language: en-IE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 892ecb2b-58d7-4937-5e31-08da807ae95c
x-ms-traffictypediagnostic: SA2PR11MB5193:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 687vFcwiHrjYYegr6f00guxIuU6jdIqZ4vfxBgotLPvEwkA/8TK9AaxaKzhSab15ikjM8cocmkARBPiECYL/VqvCP7heNa18FK8tS8kkHIAG72Sw0sOYNis47/6l5L3d+a+zRzEmdxnh0cVrvaLLOoGdY4S+w5+U+s3Qn8Oma6Nwd9M6GbrCyJjYv//wiKeoIx82hyL++d/jnJnk3WogOuSjRsdl80HfWcUIukLVRS8E5FKhbI2Sh3WPzEUjuytWRhhC8JtO0nzP563z5TuTWEgoeNP1r+AkO2haC8ftV0yDq24ea8GQnCUb+nr7zzdPiRJsFQjFGb0lH/DBVqstU/Dmc4u1e8+MswhxObEPSUfBSrR6rdojhrHbbAnruWRfeL56TtrXRWSD8IL5zDLGqDcWFAGNFQomL6CkAdUACAqDxv4TwicUlaAeMsUxqefrPyAeDQGWyPEYaCWvGzkOKrkTahfYvuOUG0jQ3Z+sFuw4QEunbx/vg0OJwkHfvyGxI19R5H2nPFvZXXMQI91ulaBOgq9xuMXg0qaG74O7G20k/74GMuCAQuujkwW2rGw1UX2pQ/nZEb6sqmNyCujayR5WQ7cmUwLvGI+kYyatsBJAN3PGExzn6Im6orMrV+DM7DMpZD8uYFvwb0VQKGjoJPU0iisK1huIsPW6AurbIh8BtpwSCNcLm39+jFfWsVCDrT6J5J9Q0q/1FHeftueEu5S5a/4L0X2FoyZBHb/qF0o60AD8ouwlmFxnNpgiZ5r1MxA32Q8+sAaEFVpiGBfx4C9F26VaiEd+cP5C2YeVojonTHSWs3A0A7wa4EJlX7VbaFuHr0Z/TtnNaQpPXqfAarSX716/S0EpQRMgg5WOx6o9EdHyC35V6XW6fN2iTzkm
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5154.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(39860400002)(136003)(376002)(396003)(366004)(7416002)(2906002)(31696002)(71200400001)(66556008)(66446008)(66946007)(66476007)(38070700005)(76116006)(64756008)(8676002)(4326008)(107886003)(31686004)(38100700002)(110136005)(54906003)(122000001)(86362001)(316002)(5660300002)(36756003)(83380400001)(8936002)(478600001)(6486002)(26005)(6512007)(41300700001)(186003)(91956017)(53546011)(2616005)(6506007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Y0UwOUxCeit3VHh1SnQxb1hOTlhSR3pDMEw1SkpBQ0dKeEs1THVHWHJGMndK?=
 =?utf-8?B?ZVRqZDR0V05ZQ1ZxNFJPaHp5N3lQM2dQUStkbVFkUHg2K3pjeDNpRXZ2Y2o1?=
 =?utf-8?B?ZjFpV0ppUUYwTW9IMCtUaFcwZEZtMjZaSXdHMzFhMWlPNFBMWmxsSDErUEhk?=
 =?utf-8?B?RE1telFuVEx3eVBvWU5zbFFTZ1NKWTZqeUErcHNpVnVrSWU3YVBuNnBUQUxZ?=
 =?utf-8?B?OVZOQ0Y2bmhJZTVQaTRBd0pGR3FydDJkVXliUVBYNDVKTFg0eDlQK3Q3SDV6?=
 =?utf-8?B?eC9KK2tFeTI5TUtqRXdoMy8ySitKRUVVRmZDcGExdFBOeUJ6VWNVMlhkeWtt?=
 =?utf-8?B?WlZtSjJEWXY5WFdOZWhheE1mdEFjdDdpSnBmSzgvdUlNTkFQenlLWTNTU09S?=
 =?utf-8?B?Q0JaSnVqYkxDMXBwTTJzb2ZmVGsxM0VJQXQycXJ3VnNtMEloZTdQNW1wZDNM?=
 =?utf-8?B?ZGxPbTFNUUZyUlphUjdFNmhmWWV5YkVDKytJS0pVL00zdHc0RTJxc3lkbnpX?=
 =?utf-8?B?YzRTNTlUbFpwQUlmR2tCZjk0dzg1YWR5ZWZVeDRCeUs3dU4yRmtDYWpKT0RU?=
 =?utf-8?B?RjE4Wnl4enY5d29DVDkwbGY4NmN1MCs2UkhYOXl0NjY0U09xOHUvdjZTV2lM?=
 =?utf-8?B?WnRScVhkRjk3UUhaSWNSTG1jQUZYVnc3NU4rSXFEbHd6M1lTdThjSnh3YzZn?=
 =?utf-8?B?RzZ2RnZJWnJITENveDFCVnJYNWJ4QjRUU29xWHp1RkJXMlVTZ3BzM2duTHVw?=
 =?utf-8?B?c3cwZk5PYUx6bWF3RkFsc1FuUEVVK01rSTQ1MnZISGZQSkZEU2kxYlVramVT?=
 =?utf-8?B?ZGRjUThJT1MrOWpLaVpSczQ0M1FGclNZK1p6bUltb2s5RFVKSE85SHBEL1NV?=
 =?utf-8?B?S3J5YWNPM3ZDTGE2dUtRYml1cVVRWmdXMER0VVN6S2VMQWkwMGZoaTU1aE9U?=
 =?utf-8?B?QzU1aVVHR1hCZkQ5MHkzTUJLekJCZWtyY1dvSEVISzUzc1hjY3p3YUNVazFu?=
 =?utf-8?B?WlJBaWJiY1BqMWpGbjFsQ1JpN3hGdzEzWkVNM2xhSWljT2M0R25sdmVHZGgw?=
 =?utf-8?B?M0ZPdkRuUjBMVGRsL1ZUdnBCQlFvY0lBMkhQNXVuVUc4ZU9zbXR0Z1FXaEs1?=
 =?utf-8?B?dTdUSmZMOForQVpNMllnbU9ENWQ3ZWlBaHFhN1dwd3JkSWUyTGVtTG1FTHdG?=
 =?utf-8?B?aEdkVjZKNmJBSGh0VGVLM3ZIcStiaVZTTjBoVTNZTS9NbTdUTHNoWlFyOCtL?=
 =?utf-8?B?T1FQN0VYa0lpbllvVUpzcDZtUjk1RE9BMWVsLytCaGpUZy9yR0wyZVYxcnBR?=
 =?utf-8?B?SnY5OWI3b1RTUFhMM2ZUOWlqdFljd2wzK0pzK25vb0pZM3dWREhScTlsODVM?=
 =?utf-8?B?TWhDNTZLTEc3eGd1eTZ3V2NSVm1ZTkFReGJLUHZFVjQrQ2dpTWlydFR6czNx?=
 =?utf-8?B?Z3IvU2hvVTR0b2o2YUxOSzZmTzNuTk9YQkZuU3VYSTFvZFl3NWJySXAwMEpP?=
 =?utf-8?B?MmV6bUM0QzdkS0E0enV1Q2RHWEFnZHZ1V09CL3k2VkZaYVo4UlNEN1IrVUlp?=
 =?utf-8?B?a0ErMjJqZjViSDlJUjZyT0o5SFIyTTlneDIzL1V3bU1kREJHRU1TZGdZaVZs?=
 =?utf-8?B?WlBMNm0vUmpQcmJOVXZ1cXFJVTN5U3BLVWZ4aXdBOFdHQmpEWno1NXlpUnN1?=
 =?utf-8?B?dG40UkxGbVNHbTVTL1VwbVFtY2R2bGJlcHc0d2x6NTBuRnl5SVhERExKK3RL?=
 =?utf-8?B?UDNhcm44S0JYRmFOclhUVjdFdFh3SFRGN1RQRzZLK3c2RVhrRC9iRUZtWG14?=
 =?utf-8?B?aVdZRFQ3YXBLRVR2VS8yR2pMeXhrV3k4WFgrd0wvSEtOV3R2MW9IUHY0ZnNu?=
 =?utf-8?B?aFBvTHZXUitFbkM3Z0F1Nkg0SHdVaDBkNFoxSjhHeXIyL3F5MlE0aVZyZG1J?=
 =?utf-8?B?eCtGVFU4UHZoRnVINDJzTWZqTVQzMWFJeEZ3ZnBVTEhqTy9yeW5xbVVBYVRY?=
 =?utf-8?B?N0kvYlJXYVdGdnVnOWpQcENyL0svOHdJRzVhTy94dzgycjhDQ1dTV1pSc2dD?=
 =?utf-8?B?T2FQTjRKL0l4NGdscTdrL0xZT1RnUW9LM2hQMWNMWmcrUndramtSZy9ySk1k?=
 =?utf-8?Q?5684Z5+EE2qz2JGLEQDKRr/nj?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F0C61FA70990FA499E970D3FC0DC8107@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5154.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 892ecb2b-58d7-4937-5e31-08da807ae95c
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Aug 2022 18:04:21.5544
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xf2eiUKDCbGP9h0JsgQlxWakZUDjCcwjQMmTfGn4myuIA/Pd4RV4C5voeCXj5ZdFX0kGMxG+mIGQsjhifnYZsEbzuDYbGoQSO8AlGNwumSY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5193
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGV5IEhlaW5yaWNoLA0KSW50ZXJlc3RpbmcgQ0MgbGlzdCB5b3UgZ290IHRoZXJlISBTdXJwcmlz
ZWQgdGhlIG1haWxtYXAgZGlkbid0IHNvcnQNCm91dCBBdGlzaCAmIEtyenlzenRvZidzIGFkZHJl
c3NlcywgYnV0IEkgdGhpbmsgSSd2ZSBmaXhlZCB0aGVtIHVwLg0KIEkgc2VlIERhaXJlIGlzbid0
IHRoZXJlIGVpdGhlciBzbyArQ0MgaGltIHRvby4NCg0KT24gMTcvMDgvMjAyMiAxNDoyNSwgSGVp
bnJpY2ggU2NodWNoYXJkdCB3cm90ZToNCj4gRVhURVJOQUwgRU1BSUw6IERvIG5vdCBjbGljayBs
aW5rcyBvciBvcGVuIGF0dGFjaG1lbnRzIHVubGVzcyB5b3Uga25vdyB0aGUgY29udGVudCBpcyBz
YWZlDQo+IA0KPiBUaGUgIlBvbGFyRmlyZSBTb0MgTVNTIFRlY2huaWNhbCBSZWZlcmVuY2UgTWFu
dWFsIiBkb2N1bWVudHMgdGhlDQo+IGZvbGxvd2luZyBQTElDIGludGVycnVwdHM6DQo+IA0KPiAx
IC0gTDIgQ2FjaGUgQ29udHJvbGxlciBTaWduYWxzIHdoZW4gYSBtZXRhZGF0YSBjb3JyZWN0aW9u
IGV2ZW50IG9jY3Vycw0KPiAyIC0gTDIgQ2FjaGUgQ29udHJvbGxlciBTaWduYWxzIHdoZW4gYW4g
dW5jb3JyZWN0YWJsZSBtZXRhZGF0YSBldmVudCBvY2N1cnMNCj4gMyAtIEwyIENhY2hlIENvbnRy
b2xsZXIgU2lnbmFscyB3aGVuIGEgZGF0YSBjb3JyZWN0aW9uIGV2ZW50IG9jY3Vycw0KPiA0IC0g
TDIgQ2FjaGUgQ29udHJvbGxlciBTaWduYWxzIHdoZW4gYW4gdW5jb3JyZWN0YWJsZSBkYXRhIGV2
ZW50IG9jY3Vycw0KPiANCj4gVGhpcyBkaWZmZXJzIGZyb20gdGhlIFNpRml2ZSBGVTU0MCB3aGlj
aCBvbmx5IGhhcyB0aHJlZSBMMiBjYWNoZSByZWxhdGVkDQo+IGludGVycnVwdHMuDQo+IA0KPiBU
aGUgc2VxdWVuY2UgaW4gdGhlIGRldmljZSB0cmVlIGlzIGRlZmluZWQgYnkgYW4gZW51bToNCj4g
DQo+ICAgICBlbnVtIHsNCj4gICAgICAgICAgICAgRElSX0NPUlIgPSAwLA0KPiAgICAgICAgICAg
ICBEQVRBX0NPUlIsDQo+ICAgICAgICAgICAgIERBVEFfVU5DT1JSLA0KPiAgICAgICAgICAgICBE
SVJfVU5DT1JSLA0KPiAgICAgfTsNCg0KTml0OiBtb3JlIGFjY3VyYXRlbHkgYnkgdGhlIGR0LWJp
bmRpbmc6DQogIGludGVycnVwdHM6DQogICAgbWluSXRlbXM6IDMNCiAgICBpdGVtczoNCiAgICAg
IC0gZGVzY3JpcHRpb246IERpckVycm9yIGludGVycnVwdA0KICAgICAgLSBkZXNjcmlwdGlvbjog
RGF0YUVycm9yIGludGVycnVwdA0KICAgICAgLSBkZXNjcmlwdGlvbjogRGF0YUZhaWwgaW50ZXJy
dXB0DQogICAgICAtIGRlc2NyaXB0aW9uOiBEaXJGYWlsIGludGVycnVwdA0KDQpJIGRvIGZpbmQg
dGhlIG5hbWVzIGluIHRoZSBlbnVtIHRvIGJlIGEgYml0IG1vcmUgdW5kZXJzdGFuZGFibGUgaG93
ZXZlciwNCmFuZCBkaXR0byBmb3IgdGhlIGRlc2NyaXB0aW9ucyBpbiBvdXIgVFJNLi4uIE1heWJl
IEkgc2hvdWxkIHB1dCB0aGF0IG9uDQpteSB0b2RvIGxpc3Qgb2YgY2xlYW51cHMgOikNCg0KDQo+
IA0KPiBTbyB0aGUgY29ycmVjdCBzZXF1ZW5jZSBvZiB0aGUgTDIgY2FjaGUgaW50ZXJydXB0cyBp
cw0KPiANCj4gICAgIGludGVycnVwdHMgPSA8MT4sIDwzPiwgPDQ+LCA8Mj47DQoNClRoaXMgbG9v
a3MgY29ycmVjdCB0byBtZS4gWW91IG1lbnRpb25lZCBvbiBJUkMgdGhhdCB3aGF0IHlvdSB3ZXJl
IHNlZWluZw0Kd2FzIGEgd2FsbCBvZg0KTDJDQUNIRTogRGF0YUZhaWwgQCAweDAwMDAwMDAwLjA4
MDdGRkQ4DQpGcm9tIGEgcXVpY2sgbG9vayBhdCB0aGUgZHJpdmVyLCB3aGF0IHNlZW1zIHRvIGJl
IGhhcHBlbmluZyBoZXJlIGlzIHRoYXQNCmF0IHNvbWUgcG9pbnQgKHBvc3NpYmx5IGJlZm9yZSBM
aW51eCBldmVuIGNvbWVzIGludG8gdGhlIHBpY3R1cmUpIHRoZXJlDQppcyBhbiB1bmNvcnJlY3Rh
YmxlIGRhdGEgZXJyb3IuIEJlY2F1c2UgdGhlIG9yZGVyaW5nIGluIHRoZSBkdCBpcyB3cm9uZywN
CndlIHJlYWQgdGhlIHdyb25nIHJlZ2lzdGVyIGFuZCBzbyB0aGUgaW50ZXJydXB0IGlzIG5ldmVy
IGFjdHVhbGx5DQpjbGVhcmVkLiBXaXRoIHRoaXMgcGF0Y2ggYXBwbGllZCwgSSBzZWUgYSBzaW5n
bGUgRGF0YUZhaWwgcmlnaHQgYXMgdGhlDQppbnRlcnJ1cHQgZ2V0cyByZWdpc3RlZCAmIG5vdGhp
bmcgYWZ0ZXIgdGhhdC4NCg0KSSBhbSBub3QgcmVhbGx5IHN1cmUgd2hhdCB2YWx1ZSB0aGVyZSBp
cyBpbiBlbmFibGluZyB0aGF0IGRyaXZlciB0aG91Z2gsDQptb3N0bHkganVzdCBzZWVtcyBsaWtl
IGEgZGVidWdnaW5nIHRvb2wgJiBmcm9tIG91ciBwb3Ygd2Ugd291bGQgc2VlIHRoZQ0KSFNTIHJ1
bm5pbmcgaW4gdGhlIG1vbml0b3IgY29yZSBhcyBiZWluZyByZXNwb25zaWJsZSBmb3IgaGFuZGxp
bmcgdGhlDQpsMi1jYWNoZSBlcnJvcnMuDQoNCkBEYWlyZSwgbWF5YmUgeW91IGhhdmUgYW4gb3Bp
bmlvbiBoZXJlPw0KDQpQYXRjaCBMR1RNLCBzbyBJJ2xsIGxpa2VseSBhcHBseSBpdCBpbiB0aGUg
bmV4dCBkYXkgb3IgdHdvLCB3b3VsZCBqdXN0DQpsaWtlIHRvIHNlZSB3aGF0IERhaXJlIGhhcyB0
byBzYXkgZmlyc3QuDQoNCj4gDQo+IEZpeGVzOiBlMzViMDdhN2RmOWIgKCJyaXNjdjogZHRzOiBt
aWNyb2NoaXA6IG1wZnM6IEdyb3VwIHR1cGxlcyBpbiBpbnRlcnJ1cHQgcHJvcGVydGllcyIpDQoN
CkJUVywgaXQgaXNuJ3QgcmVhbGx5IGZpeGluZyB0aGlzIHBhdGNoIHJpZ2h0PyBUaGlzIGlzIGEg
ZGVwZW5kZW5jeSBmb3INCmJhY2twb3J0cyB0byA1LjE1Lg0KDQpUaGFua3MgZm9yIHlvdXIgcGF0
Y2gsDQpDb25vci4NCg0KPiBGaXhlczogMGZhNjEwN2VjYTQxICgiUklTQy1WOiBJbml0aWFsIERU
UyBmb3IgTWljcm9jaGlwIElDSUNMRSBib2FyZCIpDQo+IENjOiBDb25vciBEb29sZXkgPGNvbm9y
LmRvb2xleUBtaWNyb2NoaXAuY29tPg0KPiBDYzogc3RhYmxlQHZnZXIua2VybmVsLm9yZw0KPiBT
aWduZWQtb2ZmLWJ5OiBIZWlucmljaCBTY2h1Y2hhcmR0IDxoZWlucmljaC5zY2h1Y2hhcmR0QGNh
bm9uaWNhbC5jb20+DQo+IC0tLQ0KPiAgYXJjaC9yaXNjdi9ib290L2R0cy9taWNyb2NoaXAvbXBm
cy5kdHNpIHwgMiArLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0
aW9uKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvYXJjaC9yaXNjdi9ib290L2R0cy9taWNyb2NoaXAv
bXBmcy5kdHNpIGIvYXJjaC9yaXNjdi9ib290L2R0cy9taWNyb2NoaXAvbXBmcy5kdHNpDQo+IGlu
ZGV4IDQ5NmQzYjc2NDJiZC4uZWMxZGU2MzQ0YmU5IDEwMDY0NA0KPiAtLS0gYS9hcmNoL3Jpc2N2
L2Jvb3QvZHRzL21pY3JvY2hpcC9tcGZzLmR0c2kNCj4gKysrIGIvYXJjaC9yaXNjdi9ib290L2R0
cy9taWNyb2NoaXAvbXBmcy5kdHNpDQo+IEBAIC0xNjksNyArMTY5LDcgQEAgY2N0cmxscjogY2Fj
aGUtY29udHJvbGxlckAyMDEwMDAwIHsNCj4gICAgICAgICAgICAgICAgICAgICAgICAgY2FjaGUt
c2l6ZSA9IDwyMDk3MTUyPjsNCj4gICAgICAgICAgICAgICAgICAgICAgICAgY2FjaGUtdW5pZmll
ZDsNCj4gICAgICAgICAgICAgICAgICAgICAgICAgaW50ZXJydXB0LXBhcmVudCA9IDwmcGxpYz47
DQo+IC0gICAgICAgICAgICAgICAgICAgICAgIGludGVycnVwdHMgPSA8MT4sIDwyPiwgPDM+Ow0K
PiArICAgICAgICAgICAgICAgICAgICAgICBpbnRlcnJ1cHRzID0gPDE+LCA8Mz4sIDw0PiwgPDI+
Ow0KPiAgICAgICAgICAgICAgICAgfTsNCj4gDQo+ICAgICAgICAgICAgICAgICBjbGludDogY2xp
bnRAMjAwMDAwMCB7DQo+IC0tDQo+IDIuMzYuMQ0KPiANCg0K
