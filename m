Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32082587B4A
	for <lists+stable@lfdr.de>; Tue,  2 Aug 2022 13:03:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236784AbiHBLDs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Aug 2022 07:03:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236798AbiHBLDk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Aug 2022 07:03:40 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E02950714;
        Tue,  2 Aug 2022 04:03:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1659438216; x=1690974216;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=I+7vwsodOH3O19LT3nNR2W0JCZODGxJ2lb9i+eG1muA=;
  b=1qaK4V5v4KvH8t9NraYtCWtKHtyB2y7uN+Lu9NC31BDJANvRLJcVFF10
   /mkoEGvhibbIC9+UqyNH6Hby6zUqi0QDKYdCMM7B6qygIyJRG7JvoYluW
   rvwq9ywYx+iNqRpPkXWJDEm6iEFVd0dSW76ecRY+RUCGUesV8RVDmrens
   /M5K9gC3Ved26q82SiErAK6xmTiB9mEvVyclNHlAltQn6rRltgGJ9b9JP
   FYnPin3FXzU4WzgKw4rKrSqUGhpH3p6kHz21aP1JKWLBEkUUC5t1M5YTy
   O36slud7zhAKyG0i9ikcjL00UETbdLSojeS3MQlKwm8eIsT++SDyvKqWk
   w==;
X-IronPort-AV: E=Sophos;i="5.93,210,1654585200"; 
   d="scan'208";a="170558622"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 02 Aug 2022 04:03:34 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 2 Aug 2022 04:03:34 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17 via Frontend
 Transport; Tue, 2 Aug 2022 04:03:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f7qYG3ymNFGoF/n70dbPdrXlOX3j50CJaQSbS3TfRs6NVrTEPT3MpM+harAIv9fOqQDYOCxCHbR6OphjyRzXccV3dM2VRKg60Ga9xzhLiO1DMvpCEbXcSjatpV969iAmjcaalTSKtqdFdMx0kNMc/xExARx/wYicG3THmiKisOjzIgfFquO7exKE1pgJUISIanr8nB3U6zPuTnu08vouZJtzmBXHdcRBH4lqzkmT1KVlXmpWJqJhH6r6Es8KYXrGYifpB80TbIzHXXQQXgRkO788TMpaG+EnlqqA7nY/A1FMiFKWP5rZXgF5KB3jEmDtpR955tuz2gMIhHGIuuSG6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I+7vwsodOH3O19LT3nNR2W0JCZODGxJ2lb9i+eG1muA=;
 b=QZe7dDQ/v8zYpi8hUdIM0hubspDHDqESf5/jDLk91pCQ6Uo4T3MIqXm3EebWFWKIFfYreGBWOI5/x+Xzv7bl96edFFx+UrhYcMq8aC0eINwwfGFRPvskZnjwHlqtzJ7yZK5m3IzmZhr1roBaSIJ8EUDUAFsVgwdNRbhFw+ffmntLjI9GLTXK2IauICYjZRt24yoER+8rO7FouNxt2JXziIGelhYxeKvU79tb4EWZ+wP728tH1xLdmd6h7iWyC9ztGu5Dazdur4fLFFUVs/ti2aht3CpXF6zIDiOiY7Fj5OLEIhkdvXbWc2iYWcmD4z8+SsXVkmmaoOGJCLGr4n0q/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I+7vwsodOH3O19LT3nNR2W0JCZODGxJ2lb9i+eG1muA=;
 b=SY4PdN9fDG17lbfMx2VTTKH+dGtteZr2mlqXzjntDn6SsaVI8joipZzRifNrOZH5ZGxcE0ESS0i0Fgk7DXoYQel2JaYHPnwCeSahrWMP85V5n2/rzd0qbQ8Ey0/bU19dGCsZz4NNwmHE7mlMXylEwiDnQ3nmRvZEV+MHnHuS/E0=
Received: from DM4PR11MB6479.namprd11.prod.outlook.com (2603:10b6:8:8c::19) by
 MWHPR11MB1887.namprd11.prod.outlook.com (2603:10b6:300:109::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.11; Tue, 2 Aug
 2022 11:03:32 +0000
Received: from DM4PR11MB6479.namprd11.prod.outlook.com
 ([fe80::d826:894d:b9f:9552]) by DM4PR11MB6479.namprd11.prod.outlook.com
 ([fe80::d826:894d:b9f:9552%5]) with mapi id 15.20.5482.016; Tue, 2 Aug 2022
 11:03:32 +0000
From:   <Tudor.Ambarus@microchip.com>
To:     <miquel.raynal@bootlin.com>, <richard@nod.at>, <vigneshr@ti.com>,
        <peda@axentia.se>
CC:     <Nicolas.Ferre@microchip.com>, <alexandre.belloni@bootlin.com>,
        <Claudiu.Beznea@microchip.com>, <bbrezillon@kernel.org>,
        <linux-mtd@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH] mtd: rawnand: atmel: Unmap streaming DMA mappings
Thread-Topic: [PATCH] mtd: rawnand: atmel: Unmap streaming DMA mappings
Thread-Index: AQHYpl+AL5Ep9vCWYUG2OKyYBcNYJg==
Date:   Tue, 2 Aug 2022 11:03:32 +0000
Message-ID: <81db99e7-d97e-893a-16dd-3b13138b2720@microchip.com>
References: <20220728074014.145406-1-tudor.ambarus@microchip.com>
In-Reply-To: <20220728074014.145406-1-tudor.ambarus@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 96c57c2b-c20c-43f4-3da0-08da7476a36c
x-ms-traffictypediagnostic: MWHPR11MB1887:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZPQx+bPQ5jdiYLX9yLV8eMPXVa350ZDXJLmO/vY5QOJTgzScmLlohFDwEwhJGtB8Fd90v11jeRk828HmSMKIFOdrtBAkThiVoWwmpGHdOx+iSFIjA05aH8vNR2jSLaIaCuVamLHzTDKu9VJitXekctSmA9ARv6BeMKKjXppAxDot8EmxMT/w+S9OEZG1sOT8C+Vr098YYBFwfYDmbMTZbH7Zf6+d+7WIPOzWHLeE3ScJxPGXWUpyJM2b+CmP/Q6EphM2cnQ09lLZnsEH4CLYQmvHvhqvtyoJeW19z6FHbzz8D9bFuGyg1JR/qLMvnAyMrnNhu5czY0vvnAn63xctbpi8SFwRXVEq8hRpUy0mTDQuLGy2I/bLQ/QMCCYxBDDYUGvQBaTcPs2ryhqi1jTsvBNJTCsZgVLBki1UbSzAH9k6I0s4XBmLr2FKmf82lUoKg7tZ8u22w7S3QxhZoQqdz6m9QhvTO2rsCv8BkTv5a5ZDAnSjs83/4DZXUD0PzIz9BPQJeyGX33ofYCUpwfpsxkbw+gvNAVlUL1xb5Y1HbbPQOSnk1DyR1Lpz8MBf0/bpOlvjjJBj2zH/ZEsRSwR/CG3stsolFqtU4djPO8TONe1x38IAaObHdxFs7DOyKgMb3mkDNftOgY/2LrSJWakceV2DR4eTkLIM8AeVNX3CSXCEEIELGx2vBhYgwXxlh1qwaOIuLg051H+6Df6RUSd3Rm/Bf61C4zWK2WZaworlLIrwCpGYN70qjh1ltLG4dEw1GHf6LxiHQZNLVtXNMkXEBHypvqBK9Z8DooFl2j/BV3yjcYixhpPkgj8jxxDRcXMOLNWoBm/ykx1Zw9FUYhWJrVonf3ljYe8AM9w20YRLu7McgUmtZYipFqNkgd6U0KMC
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6479.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(346002)(376002)(396003)(366004)(39860400002)(6512007)(53546011)(6506007)(26005)(86362001)(31696002)(41300700001)(478600001)(110136005)(71200400001)(54906003)(316002)(6486002)(38070700005)(122000001)(38100700002)(5660300002)(2616005)(186003)(2906002)(66946007)(66556008)(91956017)(8676002)(76116006)(66476007)(64756008)(4326008)(66446008)(8936002)(31686004)(4744005)(7416002)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?U0FqTG1NbFlMR0ZZWGMxKzE1MUw4dWFoK2w0eFFaMklmNkVneXR3K1NHaVg3?=
 =?utf-8?B?YTZ5cEpTVE9tRk0yTWZUZFRuSHVvMDlyTWhpWndTOTZ0dURjWlB3NWNGcXhh?=
 =?utf-8?B?OUFyeFBKQ0dQeUxQaVZ5NHNVZnIxM2sxWmV4T3lrTTZXdy9hRk5XWnZSemh5?=
 =?utf-8?B?WG9ZMkI2c21yTm1aaUlQV0VNbWVlS3VMK1oxQUdRV3FqK3lua0NKUERSbjRm?=
 =?utf-8?B?Nk5VRFlBTDZrS0llT045N1lrOFNHOFhYbkZMTy96R3kxUzhLUmhpMEJpN0xI?=
 =?utf-8?B?WGNNME9veUVaM1c4TmNtYXF2MHgwVTE2ZzBMMWwwLzBMNzVGUFNJWC9PMVR2?=
 =?utf-8?B?Zzh6Y3BXYVRZSXJvWjRTOW1JYXFVL2F4VHkyTkpuKzhzQ1RjWnZDUFJCMkww?=
 =?utf-8?B?UmU1cjF3ZG92TnlDQlZmbkNCNjJKU0tuMmtRYkdGQUdGV1FFYnp3b09mN1I5?=
 =?utf-8?B?UzdUSE1KekRzenN6MGhqdkJuZVlCdEc4TzZGWERHSlhiR0gxM1BCWHBRT25T?=
 =?utf-8?B?WUNseDlqODBPejQ4S243cE55MHVOb0wwQWZNZ2duOGJsN1pwNDY3RHpuRkRG?=
 =?utf-8?B?NElhbmYzWmJ1NTlZRUZDSE5sNU1hRk5LcjdPOVRna3FWVGl0SWhxNTNrQ0Jn?=
 =?utf-8?B?VkZYb2V0bU1ibzhxRlRyODRVZnVmWHBodFZEam5DaFc0alo5VkMzNnUvK044?=
 =?utf-8?B?YjM4R1FwcXJOVWJJK25zdEUyU3ZKZWF4Ly9YOTRXMFBVRFFuajBhL0hrUmlm?=
 =?utf-8?B?ZDc1ZThaaDZtWnBnOWF4Q3E1cU9zQnAzM2E5enpCZEN1a2VKajc3cUlndlAy?=
 =?utf-8?B?OVBHazZtMVo1S0tCWndNOWVRZ2FoU0ltaWI5VmRWbmlySnVVWnF2TVYyb0xq?=
 =?utf-8?B?R2s3Ukw1OWwrY1BNU0txSG1TQ0E1SUlsOXNESlM5cHRQcURLams4VlUxeDhN?=
 =?utf-8?B?QnBVU1ZOMDNQZ2hNTU16cDdQSmg1WFJlYlFNN3U5Q3BhNE5oWERVV2RYK2pk?=
 =?utf-8?B?M1d1T05QdGRGQ1hid2c3UlJ3ajFMUCs2YkVKSTlsMUtRV2RRUGpEM0pmNmJ1?=
 =?utf-8?B?dk5YbEhtUXdkWit4cTNISVMwTGVDT0psRUlpU0x5SnlwOFQ2dE9OU2ZVNFpD?=
 =?utf-8?B?eUxvYVJIWi9WUWtXVHhtaC9PcDJUa2I5bU4ybWlSNk1iMGZkVFRjdTY3aUIw?=
 =?utf-8?B?VGQxVjBaYitFNWx4VnM5c1hidzN0eU5SVStjS2JYazc1SWhEMHc5U1d3TUtu?=
 =?utf-8?B?YnY5eVUza1VhMXNOQnkrWjZaRE9yQ1o3dW9QNTRjUENBSWloMytTbyttY1VO?=
 =?utf-8?B?T2RXQ05CTlR1LzdKUURMbEI4TlhBbEJXZ1B2aG90YWQ5T3BHd3o3Qkt6RnNQ?=
 =?utf-8?B?VDVtZERtUm9JeGJWT3BzbXdLZ0NOd0xzZ0NwRWpBWWRGbWcxRVBKd2lTSktJ?=
 =?utf-8?B?a1RhRStQUW92aXJYSnh3YStXTGlya1o3SXRWaHlOOWRncHV5d1BCbStNdEVx?=
 =?utf-8?B?Z1BsUU5XQ3hrbkFucjQ3WkViWVdBWjVFOUZFdVYvUDF6TTNWZkl4MnBQM1NF?=
 =?utf-8?B?cmZrWTBTZ0llRFY2bW5PcTdzR3BzdGdGTWRwMGE3L2ZoQkxkVWtoMXpRYTRq?=
 =?utf-8?B?c1dNVUQzelNmU25oRzBIZm92UnhBM3FOdkl3bG1RSURPbGpMUnB1L1E1d0VD?=
 =?utf-8?B?SjE2ZkUvOTBGMGVKRVVjWXpJN3czQnBRaUpTRmNzOHVWeUFOanUyb1p0aVBS?=
 =?utf-8?B?Q3hIQUdIay9MMm1OTjJhZFYyeThpMXJuOHJWNFRDNzQ0OXMwampOM3RWOTA2?=
 =?utf-8?B?ZGNJZldhcGZDaU1ZRDc3UnA1TEg1aW8rUmt1OUd1NUJuYit1bjJiYzErN1hU?=
 =?utf-8?B?cU80VzFuRDJXVmhqM1YvMi8xclA5dUVhaDQ5ZVN0TWpuaXhjQ0JYTEdtU0gv?=
 =?utf-8?B?dDc1citQVGtsR2UrN1RPSEJxOXhGWWZEclRBa1NUdkl3aWpjcWovbjk4Tmth?=
 =?utf-8?B?emtXMndHdFBHLytxcStmUXJtTXh3aVMwSXNoUFJkVTdPNVB3dHltNHQ0ZjZs?=
 =?utf-8?B?cHE2b2ljam43Z0lyV0JrbGY0eXBKSjdFRTh2SlZOTlNQN09ON3Z0VFphUFVU?=
 =?utf-8?Q?MoW79W66zAqHj60xpbxuqoXHE?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FF61CD5F8DB3934688DFE69E4FC84BFE@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6479.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 96c57c2b-c20c-43f4-3da0-08da7476a36c
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Aug 2022 11:03:32.2776
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Z2/8z5w0MZWGNKUStzxWO3urbFwu1wwZgCH4t5oJswvzgG5cLd8z3GSAgvtRcMUf+48DBdyFhxJlBQ28kaSSbAuBRT5XEq4HIk16OmFp9cU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1887
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gNy8yOC8yMiAxMDo0MCwgVHVkb3IgQW1iYXJ1cyB3cm90ZToNCj4gRXZlcnkgZG1hX21hcF9z
aW5nbGUoKSBjYWxsIHNob3VsZCBoYXZlIGl0cyBkbWFfdW5tYXBfc2luZ2xlKCkgY291bnRlcnBh
cnQsDQo+IGJlY2F1c2UgdGhlIERNQSBhZGRyZXNzIHNwYWNlIGlzIGEgc2hhcmVkIHJlc291cmNl
IGFuZCBvbmUgY291bGQgcmVuZGVyIHRoZQ0KPiBtYWNoaW5lIHVudXNhYmxlIGJ5IGNvbnN1bWlu
ZyBhbGwgRE1BIGFkZHJlc3Nlcy4NCj4gDQo+IENjOiBzdGFibGVAdmdlci5rZXJuZWwub3JnDQo+
IEZpeGVzOiBmODhmYzEyMmNjMzQgKCJtdGQ6IG5hbmQ6IENsZWFudXAvcmV3b3JrIHRoZSBhdG1l
bF9uYW5kIGRyaXZlciIpDQoNClJlcG9ydGVkLWJ5OiBQZXRlciBSb3NpbiA8cGVkYUBheGVudGlh
LnNlPg0KDQo+IFNpZ25lZC1vZmYtYnk6IFR1ZG9yIEFtYmFydXMgPHR1ZG9yLmFtYmFydXNAbWlj
cm9jaGlwLmNvbT4NCj4gLS0tDQo+ICBkcml2ZXJzL210ZC9uYW5kL3Jhdy9hdG1lbC9uYW5kLWNv
bnRyb2xsZXIuYyB8IDEgKw0KPiAgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspDQo+IA0K
PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9tdGQvbmFuZC9yYXcvYXRtZWwvbmFuZC1jb250cm9sbGVy
LmMgYi9kcml2ZXJzL210ZC9uYW5kL3Jhdy9hdG1lbC9uYW5kLWNvbnRyb2xsZXIuYw0KPiBpbmRl
eCA2ZWYxNDQ0MmM3MWEuLjMzMGQyZGFmZGQyZCAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9tdGQv
bmFuZC9yYXcvYXRtZWwvbmFuZC1jb250cm9sbGVyLmMNCj4gKysrIGIvZHJpdmVycy9tdGQvbmFu
ZC9yYXcvYXRtZWwvbmFuZC1jb250cm9sbGVyLmMNCj4gQEAgLTQwNSw2ICs0MDUsNyBAQCBzdGF0
aWMgaW50IGF0bWVsX25hbmRfZG1hX3RyYW5zZmVyKHN0cnVjdCBhdG1lbF9uYW5kX2NvbnRyb2xs
ZXIgKm5jLA0KPiAgDQo+ICAJZG1hX2FzeW5jX2lzc3VlX3BlbmRpbmcobmMtPmRtYWMpOw0KPiAg
CXdhaXRfZm9yX2NvbXBsZXRpb24oJmZpbmlzaGVkKTsNCj4gKwlkbWFfdW5tYXBfc2luZ2xlKG5j
LT5kZXYsIGJ1Zl9kbWEsIGxlbiwgZGlyKTsNCj4gIA0KPiAgCXJldHVybiAwOw0KPiAgDQoNCg0K
LS0gDQpDaGVlcnMsDQp0YQ0K
