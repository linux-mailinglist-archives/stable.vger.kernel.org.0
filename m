Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A08D6E2AE8
	for <lists+stable@lfdr.de>; Fri, 14 Apr 2023 22:07:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229953AbjDNUHd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Apr 2023 16:07:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229864AbjDNUHc (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Apr 2023 16:07:32 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86A0319AA;
        Fri, 14 Apr 2023 13:07:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1681502845; x=1713038845;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=BdB2gz9BaUid1c+3vheBgz+mn/2gpIPH5Tv7Dr8ByAI=;
  b=g6sv9G+Ub2N0HZ7ghW+nJK4N2OynBVXLevD0XEK8JXSpjpxKeeshHPsh
   km7DAoHmsfozikLZw5W+VvBhLZe9ZrFkHN5aTRSMhnIqnPcVvIvGXdxpg
   wVA+BiwgxhXow/U4qSnVntkLIngbjgfCLayZB+MWzO201zUuUU/nrcHX4
   WU4aT6HlqF6LUx+5EFg684FlRqFsKRTx6GOgOGuE0XnL5W2Yfn8hVZJ8B
   z+Sv0b/gNqDk2Jva00gqqHSsXJtsvAJXtsdbtDOWDhC8hliiXNK/yIF2O
   R8RqNEHaX44Z90ViFW/4Hvxa77tikMtyyXL6YrTof6SMaGYCCLjf003xD
   A==;
X-IronPort-AV: E=Sophos;i="5.99,197,1677567600"; 
   d="scan'208";a="209613188"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 14 Apr 2023 13:07:25 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 14 Apr 2023 13:07:23 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21 via Frontend
 Transport; Fri, 14 Apr 2023 13:07:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iMtkA7PXng2jrld08hRsUNX+keGinPszIiuQOb+sU9pkMwIK4B12NDYdToJRSG1GHTxpVQ9J7RXDysb3P91cfQ/56wYaZja2/CZ/aLCv1bREQm+n6XCVI1Ipe0+P+enVwzD9/kZI2XeEQX8rd8kJSB+fwK0sdgdM4VdEDVQFPl5Dc0ZWQH63uEnJusg1p1Q/j1AycNdqgQXFq3SBuOaCPxrSXfgGZeqNmZpg4/vxX4hcSKBUVqD0wE266GoCRAlclAhm5Q5k5lZsRG2bpXfLqMqIHPtGMv45VDn35NAoiGoPIWJBgKrOFNO1CcaCrXpOZTc5PUMogryPZ5xgFZSX4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BdB2gz9BaUid1c+3vheBgz+mn/2gpIPH5Tv7Dr8ByAI=;
 b=EUVaaCrnBXoqYbEokfl6POsBABgOPLLxJL7uxlkviqnuwh14qDH5YqKLwEMik52eusoGwHkjKZqhdJEhlw2ZgIDVCfIeQnvHo6dDWoqrBqMBy3wkPRXYWv6pB9nG7sfBKTtTWCmmNnvrLgNtAWLsQdvOfxvKoXgehXTWFIiTIa9kUSeNsULfBVg7qOil8mLoeK65vrA2MDfSGnE17frlUVRfH2TA8NrK8uXoMfLrkC9kIBRvS9h+91oe8aJ9pgm/+Gt0awzDBiq6OH8Q0X3PeZPPH18eW182m8QduBlMQRf81C+ItyBXSuUgjvuqHf0cdDp7841Uq8ypi/a1nb0XDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BdB2gz9BaUid1c+3vheBgz+mn/2gpIPH5Tv7Dr8ByAI=;
 b=dazaMPgEtIKaB8F/+FnHMzjG3t+MDR7qO8jd7zUdZQcNv1V0pk1YnYrDbMp69uVEzBl6mSbyLRu0kmmsZXNWuYI0UJd5IgFeVkYgYyyVb6ut3KyUUFh18NCXULFen1zlpDIuw+GkzZVzf4eSgTVX5z8wfiHdve6fDFgGUZ8fU+4=
Received: from BYAPR11MB3606.namprd11.prod.outlook.com (2603:10b6:a03:b5::25)
 by PH0PR11MB4885.namprd11.prod.outlook.com (2603:10b6:510:35::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Fri, 14 Apr
 2023 20:07:21 +0000
Received: from BYAPR11MB3606.namprd11.prod.outlook.com
 ([fe80::d838:54c1:6d00:d064]) by BYAPR11MB3606.namprd11.prod.outlook.com
 ([fe80::d838:54c1:6d00:d064%6]) with mapi id 15.20.6298.028; Fri, 14 Apr 2023
 20:07:21 +0000
From:   <Sagar.Biradar@microchip.com>
To:     <john.g.garry@oracle.com>, <Don.Brace@microchip.com>,
        <Gilbert.Wu@microchip.com>, <linux-scsi@vger.kernel.org>,
        <martin.petersen@oracle.com>, <jejb@linux.ibm.com>,
        <brking@linux.vnet.ibm.com>, <stable@vger.kernel.org>,
        <Tom.White@microchip.com>
Subject: RE: [PATCH] aacraid: reply queue mapping to CPUs based of IRQ
 affinity
Thread-Topic: [PATCH] aacraid: reply queue mapping to CPUs based of IRQ
 affinity
Thread-Index: AQHZYb4PYBI21vPRIUeRtFcfEd9THa8RVvYAgBPI3YCAAmG6gIAD0uVw
Date:   Fri, 14 Apr 2023 20:07:20 +0000
Message-ID: <BYAPR11MB360644221F15706FA165CC5CFA999@BYAPR11MB3606.namprd11.prod.outlook.com>
References: <20230328214124.26419-1-sagar.biradar@microchip.com>
 <3bce4faf-e843-914c-4822-784188e3436e@oracle.com>
 <BYAPR11MB3606BFE903D1BBE56C89D31BFA959@BYAPR11MB3606.namprd11.prod.outlook.com>
 <d7abc010-4d02-c04d-64d5-5fa857b0e690@oracle.com>
In-Reply-To: <d7abc010-4d02-c04d-64d5-5fa857b0e690@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR11MB3606:EE_|PH0PR11MB4885:EE_
x-ms-office365-filtering-correlation-id: d5bbcc15-1c19-4531-e490-08db3d23dae6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PmBCK3A7/oTYW3LPRtdq5W2p0SVvhHOwFZTQ2y+/qjnaSCNqmZURZaLjqS4eLqoGxGVOOBzwr8Zb+pu647V0zMjlUGWuVj0UF1/xAVK+qiG+xGy9ygVielkLmA5WBqjiFWV9a5PaF41UV1bpdeWTR4C5nboXeoh3WG7tRjpUCHrWNMwoZcqRbfz4OmLQqYMnJbs5d3JuLinFBJCIVCT5c7HZYqp1BSLU3NuY3OSxSDO+YAJko7MIhtfhoRy8Hukaye/AEDnC9QXWMtcswI++RChUHQchuUtkU7A34i7zuJMA55HaTLyIyBBssp739Oz13F5a6u/kqhzPzQXh8jZwdAO6Bwl3uZ0QsqM66pPel9RbJbySKVowfHEt+Vo0sbi4O75I4ITO1WyUd/AD18pB1ta3FdpBitRYTq913VB7rDMm/E72BJ41iFdweFApnC2GomskvU1XgBKQcnGsJ5nZFWjSCG63vvFlCs1GJQFwxkIwYDf4zO6bsqSY1gtRqpUe4JY7B+HCoSqt/TUcSvKG5maMIVlepgB1TNUdsuiIAsHCnMih3+osRtUIDgA8C0kYBdfWrEfOdF4onR/7cukSScCdPuServ5qiL9QMX3eE3Og3ZEYhKMUnz/YT/LV2bsZbGPp0JvZlFlpF7OAJtVjQA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3606.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(346002)(366004)(39860400002)(396003)(136003)(451199021)(38070700005)(26005)(76116006)(66476007)(64756008)(66556008)(66446008)(55016003)(53546011)(9686003)(6506007)(71200400001)(2906002)(966005)(83380400001)(7696005)(186003)(66946007)(6636002)(86362001)(110136005)(5660300002)(52536014)(8676002)(38100700002)(8936002)(122000001)(33656002)(316002)(478600001)(41300700001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ajZ5MitsNldjdlpWMFNnZVVYNkR2T0pzYzYwTGJxZEJhZlZyQkJrakFBdlNO?=
 =?utf-8?B?bmdwY0tmemFrMjZOQTJraHRNdUpTNW5nMTFuck5XKzhXOXNlNndoWUFqWm44?=
 =?utf-8?B?aEVpay9YZk00YWZES1labWxOOTVlQk9pNlR0TGlJQ2w4NGxjMWZvS1Q2YS9Z?=
 =?utf-8?B?bFkvTGZnQS81bUd1OEtWRlQ3U1FxQmg1VHpiSUxnMmlOaEdPQlNXNndOWFh4?=
 =?utf-8?B?bjdJdVc5cGdjajQycy9rZ09nRDZxczAzY3dmWklLdjNqWXY0N0RuUnhuUlZl?=
 =?utf-8?B?UmNrbDdML0JkQTJrZ0ZmSFdFcEY0UGh4NFJuNmlpcmU3N3NHdXpRU1ZDYjhJ?=
 =?utf-8?B?SjVNSEhLRXhlMTBVaFpkNGd1Z0xybG9jdVM3T2hZVElnYkFZZzZIMzBPeUxN?=
 =?utf-8?B?aEFGRHJCR3JjNFBKdVVic3R5NzJWcmNkSHJsc0E5dlZxRXBzSUlBVTg3ZTl4?=
 =?utf-8?B?WTNHMVRDRHVXb3pjazBpbVI5T3JLN3hsSE90anhYU3dadlp5cGtZTjRYY2N3?=
 =?utf-8?B?a2RzbTBZVkROT3k3c0pHS2QzMXVnQWZ0T2ppOEhMVEM3T3dKMnZkVTN2U01S?=
 =?utf-8?B?WktyZjNBcm5JT29tTC9oODJkbXdDQkdoNFovRTlTQUMrWTNrOWdqcUg5RXVE?=
 =?utf-8?B?OXgrbFlqMG5kNGdDaEJ5SCtNSCtzM2MyeW54a0t0bmRNVjRINHArZm9Cbm5B?=
 =?utf-8?B?cUlWZnlRMU94azgvQUVSb2tVRVFMVzdZTURkZTIyVitVemxmeWFaaVE4aEY4?=
 =?utf-8?B?K1EraDZLUDl1UmRLV2x4NWRZVlpJbkk3eTdhOVVra3lDdGZIWjJubWVUb3Rr?=
 =?utf-8?B?YzA0NG9sRlM4MTJ5Sy8rQXlhWm9HV2dUUHN6V29zQ3MrUUxCZzFqNmdCeHNS?=
 =?utf-8?B?STdlVFNwdlkvSmExbVlSZGVVc3dmd0xOOHptOHpUVzBDd0p0VDZENlNxdGFt?=
 =?utf-8?B?UzRNNlphTFlRN3lIcGJFZ0FUbnM4T2tzaTVNcUlvMzlKRnpYb25HN0lzZGNv?=
 =?utf-8?B?RUE0alM4eVpPL2ttUGVEWGZVQ2FTcG12czhWcDNBWDFEUEdiM1ZaTFJPT05w?=
 =?utf-8?B?RzBuTWJ5NTUxTGlhRkpPenMzRXkvbWEzVEZUaGVyL01KTHozMmQwNVpkR1Nj?=
 =?utf-8?B?VEtYbW9IaTlNVlRvWHhPbzRIeVFpRTV6LzNSa2hZTk5ITVVhVjZXU2RPZ2JH?=
 =?utf-8?B?VkI2aXVtZnpaNFNJK2R4ODBOS2pvdUZQM2RldndXaWZQRlBzWlZOeDRiUDNu?=
 =?utf-8?B?by9EcEkrL1p1Q2pob1hPdmtoakc4OS8rbnNuem83bVlyVkdJMytBS25wUDhS?=
 =?utf-8?B?WFNvYy9UbjRHZUxJY3JnSStvMFQ3Q3VZNHJMWHZTSVR3dCtkWnUwYkVmMUtG?=
 =?utf-8?B?eW9UN09sZ2dSU2YwOVBpV1QzZnhPd0NZUm03cEJJRjFZWWkyRFR4RXVnZnBK?=
 =?utf-8?B?QzJaS2ZBUHRQMzJFWWc1cGV0ZitiSGNIdGFzUGJxOFFUZktDM3EwM2YvR2FP?=
 =?utf-8?B?L0xaTzJpTTRjS2RVSytkSE1SWWlQYVR2UVpFYzZEQUdJNzU4a1VJamt4WGZ3?=
 =?utf-8?B?b2FmUWN6OVNpNkhaY2FMS1NmU2lPcnZ5VFlvZzdrSzdPOXRON1hPR2pRMWxv?=
 =?utf-8?B?Q1pzT3N1TFRJMUg3ZkNQby90Z05NcGtYSDNqLzNRa2wrU3d1V3lnZS9UcmdU?=
 =?utf-8?B?VTFNQkh1ZUNEblVuRnJlWHhYNU5wbTMxMjJWWjdsUW1icTQ5ZG1jblRZNy9r?=
 =?utf-8?B?NktVUGRFS21MV1EvaUhoRUY4RXMyb3Y4b2hZT2Q5K1RvcjY4MVNGcitkUHhE?=
 =?utf-8?B?Z0VaZ3k4N0tsQVFtQlVwcVFJOWszQ3dMaUs5MnpyV1JBNm5EQWNnOWlILzIv?=
 =?utf-8?B?VXJwVllrNHlpWVV3dGxXdTcralhCek5xK1RZaXVVbWU0OTBTR2M0bmo0cVZU?=
 =?utf-8?B?cEp5VTlOaG1SNzlGS0xFNGFUenA4c0c3UGs1aVpFSy85Q2huS2d2QWZPVlUv?=
 =?utf-8?B?K2poSm1rZkVKOTUrbkRFb0NRMG1Ma01tWnkzV3ZQRmxaNmZJcVhYNFJXNG9V?=
 =?utf-8?B?TmxDSXVzRzVDamJlZlhrR0s2YjFvaktqQVJxemszREhVNks4UmZxRkJtRTlV?=
 =?utf-8?Q?ZpfiU2VUZOsujPj0OKPXymdsl?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3606.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5bbcc15-1c19-4531-e490-08db3d23dae6
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Apr 2023 20:07:20.8599
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SKQjxYt6qTwk6YPOjTQzpV/Mn7ugj4dtrlrcqS8BvpGVfXZTqUYhI1tTZ7l42vobKtPqgJEdsOjwvUnQfnezuG/zBUSXppjzG4HAd96dcPc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4885
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        T_SCC_BODY_TEXT_LINE,T_SPF_TEMPERROR autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DQoNCi0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQpGcm9tOiBKb2huIEdhcnJ5IDxqb2huLmcu
Z2FycnlAb3JhY2xlLmNvbT4gDQpTZW50OiBXZWRuZXNkYXksIEFwcmlsIDEyLCAyMDIzIDI6Mzgg
QU0NClRvOiBTYWdhciBCaXJhZGFyIC0gQzM0MjQ5IDxTYWdhci5CaXJhZGFyQG1pY3JvY2hpcC5j
b20+OyBEb24gQnJhY2UgLSBDMzM3MDYgPERvbi5CcmFjZUBtaWNyb2NoaXAuY29tPjsgR2lsYmVy
dCBXdSAtIEMzMzUwNCA8R2lsYmVydC5XdUBtaWNyb2NoaXAuY29tPjsgbGludXgtc2NzaUB2Z2Vy
Lmtlcm5lbC5vcmc7IG1hcnRpbi5wZXRlcnNlbkBvcmFjbGUuY29tOyBqZWpiQGxpbnV4LmlibS5j
b207IGJya2luZ0BsaW51eC52bmV0LmlibS5jb207IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmc7IFRv
bSBXaGl0ZSAtIEMzMzUwMyA8VG9tLldoaXRlQG1pY3JvY2hpcC5jb20+DQpTdWJqZWN0OiBSZTog
W1BBVENIXSBhYWNyYWlkOiByZXBseSBxdWV1ZSBtYXBwaW5nIHRvIENQVXMgYmFzZWQgb2YgSVJR
IGFmZmluaXR5DQoNCkVYVEVSTkFMIEVNQUlMOiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBh
dHRhY2htZW50cyB1bmxlc3MgeW91IGtub3cgdGhlIGNvbnRlbnQgaXMgc2FmZQ0KDQpPbiAxMC8w
NC8yMDIzIDIyOjE3LCBTYWdhci5CaXJhZGFyQG1pY3JvY2hpcC5jb20gd3JvdGU6DQo+IE9uIDI4
LzAzLzIwMjMgMjI6NDEsIFNhZ2FyIEJpcmFkYXIgd3JvdGU6DQo+PiBGaXggdGhlIElPIGhhbmcg
dGhhdCBhcmlzZXMgYmVjYXVzZSBvZiBNU0l4IHZlY3RvciBub3QgaGF2aW5nIGEgDQo+PiBtYXBw
ZWQgb25saW5lIENQVSB1cG9uIHJlY2VpdmluZyBjb21wbGV0aW9uLg0KPiBXaGF0IGFib3V0IGlm
IHRoZSBDUFUgdGFyZ2V0ZWQgZ29lcyBvZmZsaW5lIHdoaWxlIHRoZSBJTyBpcyBpbi1mbGlnaHQ/
DQo+DQo+PiBUaGlzIHBhdGNoIHNldHMgdXAgYSByZXBseSBxdWV1ZSBtYXBwaW5nIHRvIENQVXMg
YmFzZWQgb24gdGhlIElSUSANCj4+IGFmZmluaXR5IHJldHJpZXZlZCB1c2luZyBwY2lfaXJxX2dl
dF9hZmZpbml0eSgpIEFQSS4NCj4+DQo+IGJsay1tcSBhbHJlYWR5IGRvZXMgd2hhdCB5b3Ugd2Fu
dCBoZXJlLCBpbmNsdWRpbmcgaGFuZGxpbmcgZm9yIHRoZSBjYXNlIEkgbWVudGlvbiBhYm92ZS4g
SXQgbWFpbnRhaW5zIGEgQ1BVIC0+IEhXIHF1ZXVlIG1hcHBpbmcsIGFuZCB1c2luZyBhIHJlcGx5
IG1hcCBpbiB0aGUgTExEIGlzIHRoZSBvbGQgd2F5IG9mIGRvaW5nIHRoaXMuDQo+DQo+IENvdWxk
IHlvdSBpbnN0ZWFkIGZvbGxvdyB0aGUgZXhhbXBsZSBpbiBjb21taXQgNjY0ZjBkY2UyMDU4ICgi
c2NzaToNCj4gbXB0M3NhczogQWRkIHN1cHBvcnQgZm9yIHNoYXJlZCBob3N0IHRhZ3NldCBmb3Ig
Q1BVIGhvdHBsdWciKSwgYW5kIGV4cG9zZSB0aGUgSFcgcXVldWVzIHRvIHRoZSB1cHBlciBsYXll
cj8gWW91IGNhbiBhbHRlcm5hdGl2ZWx5IGNoZWNrIHRoZSBleGFtcGxlIG9mIGFueSBTQ1NJIGRy
aXZlciB3aGljaCBzZXRzIHNob3N0LT5ob3N0X3RhZ3NldCBmb3IgdGhpcy4NCj4NCj4gVGhhbmtz
LA0KPiBKb2huDQo+IFtTYWdhciBCaXJhZGFyXQ0KPg0KPiAqKipXaGF0IGFib3V0IGlmIHRoZSBD
UFUgdGFyZ2V0ZWQgZ29lcyBvZmZsaW5lIHdoaWxlIHRoZSBJTyBpcyBpbi1mbGlnaHQ/DQo+IFdl
IHJhbiBtdWx0aXBsZSByYW5kb20gY2FzZXMgd2l0aCB0aGUgSU8ncyBydW5uaW5nIGluIHBhcmFs
bGVsIGFuZCBkaXNhYmxpbmcgbG9hZC1iZWFyaW5nIENQVSdzLiBXZSBzYXcgdGhhdCB0aGUgbG9h
ZCB3YXMgdHJhbnNmZXJyZWQgdG8gdGhlIG90aGVyIG9ubGluZSBDUFVzIHN1Y2Nlc3NmdWxseSBl
dmVyeSB0aW1lLg0KPiBUaGUgc2FtZSB3YXMgdGVzdGVkIGF0IHZlbmRvciBhbmQgdGhlaXIgY3Vz
dG9tZXIgc2l0ZSAtIHRoZXkgZGlkIG5vdCBzZWUgYW55IGlzc3VlcyB0b28uDQoNCllvdSBuZWVk
IHRvIGVuc3VyZSB0aGF0IGFsbCBDUFVzIGFzc29jaWF0ZWQgd2l0aCB0aGUgSFcgcXVldWUgYXJl
IG9mZmxpbmUgYW5kIHN0YXkgb2ZmbGluZSB1bnRpbCBhbnkgSU8gbWF5IHRpbWVvdXQsIHdoaWNo
IHdvdWxkIGJlIDMwIHNlY29uZHMgYWNjb3JkaW5nIHRvIFNDU0kgc2QgZGVmYXVsdCB0aW1lb3V0
LiBJIGFtIG5vdCBzdXJlIGlmIHlvdSB3ZXJlIGRvaW5nIHRoYXQgZXhhY3RseS4gDQoNCltTYWdh
ciBCaXJhZGFyXSANClJlc3BvbmRpbmcgYWdhaW4gaW5saW5lIHRvIHRoZSBvcmlnaW5hbCB0aHJl
YWQgdG8gYXZvaWQgY29uZnVzaW9uIC4gLiAuIA0KDQpXZSBkaXNhYmxlZCAxNCBvdXQgb2YgMTYg
Q1BVcyBhbmQgZWFjaCB0aW1lIHdlIHNhdyB0aGUgaW50ZXJydXB0cyBtaWdyYXRlZCB0byB0aGUg
b3RoZXIgQ1BVcy4NClRoZSBDUFVzIHJlbWFpbmVkIG9mZmxpbmUgZm9yIHZhcnlpbmcgdGltZXMs
IGVhY2ggb2Ygd2hpY2ggd2VyZSBtb3JlIHRoYW4gMzAgc2Vjb25kcy4NCldlIG1vbml0b3JlZCBw
cm9wZXIgYmVoYXZpb3Igb2YgdGhlIHRocmVhZHMgcnVubmluZyBvbiBDUFVzIGFuZCBvYnNlcnZl
ZCB0aGVtIG1pZ3JhdGluZyB0byBvdGhlciBDUFVzIGFzIHRoZXkgd2VyZSBkaXNhYmxlZC4NCldl
LCBhbG9uZyB3aXRoIHRoZSB2ZW5kb3IvY3VzdG9tZXIsIGRpZCBub3Qgb2JzZXJ2ZSBhbnkgY29t
bWFuZCB0aW1lb3V0cyBpbiB0aGVzZSBleHBlcmltZW50cy4gDQpJbiBjYXNlIGFueSBjb21tYW5k
cyB0aW1lIG91dCAtIHRoZSBkcml2ZXIgd2lsbCByZXNvcnQgdG8gdGhlIGVycm9yIGhhbmRsaW5n
IG1lY2hhbmlzbS4NCg0KQWxzbywgdGhlcmUgaXMgdGhpcyBwYXRjaCB3aGljaCBhZGRyZXNzZXMg
dGhlIGNvbmNlcm5zIEpvaG4gR2FycnkgcmFpc2VkLg0KaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcv
bGttbC8yMDIyMDkyOTAzMzQyOC4yNTk0OC0xLW1qMDEyMy5sZWVAc2Ftc3VuZy5jb20vVC8NCg0K
VGhpcyBwYXRjaCBleHBsYWlucyBob3cgdGhlIGNvb3JkaW5hdGlvbiBoYXBwZW5zIHdoZW4gYSBD
UFUgZ29lcyBvZmZsaW5lLg0KSVBJIGNhbiBiZSByZWFkIEludGVyLVByb2Nlc3NvciBJbnRlcnJ1
cHQuDQpUaGUgcmVxdWVzdCBzaGFsbCBiZSBjb21wbGV0ZWQgZnJvbSB0aGUgQ1BVIHdoZXJlIGl0
IGlzIHJ1bm5pbmcgd2hlbiB0aGUgb3JpZ2luYWwgQ1BVIGdvZXMgb2ZmbGluZS4NCg0KPg0KPg0K
PiAqKipibGstbXEgYWxyZWFkeSBkb2VzIHdoYXQgeW91IHdhbnQgaGVyZSwgaW5jbHVkaW5nIGhh
bmRsaW5nIGZvciB0aGUgY2FzZSBJIG1lbnRpb24gYWJvdmUuIEl0IG1haW50YWlucyBhIENQVSAt
PiBIVyBxdWV1ZSBtYXBwaW5nLCBhbmQgdXNpbmcgYSByZXBseSBtYXAgaW4gdGhlIExMRCBpcyB0
aGUgb2xkIHdheSBvZiBkb2luZyB0aGlzLg0KPiBXZSBhbHNvIHRyaWVkIGltcGxlbWVudGluZyB0
aGUgYmxrLW1xIG1lY2hhbmlzbSBpbiB0aGUgZHJpdmVyIGFuZCB3ZSBzYXcgY29tbWFuZCB0aW1l
b3V0cy4NCj4gVGhlIGZpcm13YXJlIGhhcyBsaW1pdGF0aW9uIG9mIGZpeGVkIG51bWJlciBvZiBx
dWV1ZXMgcGVyIHZlY3RvciBhbmQgdGhlIGJsay1tcSBjaGFuZ2VzIHdvdWxkIHNhdHVyYXRlIHRo
YXQgbGltaXQuDQo+IFRoYXQgYW5zd2VycyB0aGUgcG9zc2libGUgY29tbWFuZCB0aW1lb3V0Lg0K
Pg0KPiBBbHNvIHRoaXMgaXMgRU9MIHByb2R1Y3QgYW5kIHRoZXJlIHdpbGwgYmUgbm8gZmlybXdh
cmUgY29kZSBjaGFuZ2VzLiBHaXZlbiB0aGlzLCB3ZSBoYXZlIGRlY2lkZWQgdG8gc3RpY2sgdG8g
dGhlIHJlcGx5X21hcCBtZWNoYW5pc20uDQo+IChodHRwczovL3VybGRlZmVuc2UuY29tL3YzL19f
aHR0cHM6Ly9zdG9yYWdlLm1pY3Jvc2VtaS5jb20vZW4tdXMvc3VwcG8NCj4gcnQvc2VyaWVzOC9p
bmRleC5waHBfXzshIUFDV1Y1TjlNMlJWOTloUSFQTHJiZm9FQnZFR3h3MkN2YWhDTDBBUDVjNGY1
Yw0KPiBROGdUMGFoWFZnQjBtU2J5cXhXSjhwZHRZWTBKd1JMOHhaNTlrME5ISmhYQ0JiTXRWV2xx
NXBZTWVPRUhtdzd3dyQgICkNCj4NCj4gVGhhbmsgeW91IGZvciB5b3VyIHJldmlldyBjb21tZW50
cyBhbmQgd2UgaG9wZSB5b3Ugd2lsbCByZWNvbnNpZGVyIHRoZSBvcmlnaW5hbCBwYXRjaC4NCg0K
SSd2ZSBiZWVuIGNoZWNraW5nIHRoZSBkcml2ZXIgYSBiaXQgbW9yZSBhbmQgdGhpcyBkcml2ZXJz
IHVzZXMgc29tZSAicmVzZXJ2ZWQiIGNvbW1hbmRzLCByaWdodD8gVGhhdCB3b3VsZCBiZSBpbnRl
cm5hbCBjb21tYW5kcyB3aGljaCB0aGUgZHJpdmVyIHNlbmRzIHRvIHRoZSBhZGFwdGVyIHdoaWNo
IGRvZXMgbm90IGhhdmUgYSBzY3NpX2NtbmQgYXNzb2NpYXRlZC4NCklmIHNvLCBpdCBnZXRzIGEg
Yml0IG1vcmUgdHJpY2t5IHRvIHVzZSBibGstbXEgc3VwcG9ydCBmb3IgSFcgcXVldWVzLCBhcyB3
ZSBuZWVkIHRvIG1hbnVhbGx5IGZpbmQgYSBIVyBxdWV1ZSBmb3IgdGhvc2UgInJlc2VydmVkIGNv
bW1hbmRzIiwgbGlrZQ0KaHR0cHM6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5l
bC9naXQvdG9ydmFsZHMvbGludXguZ2l0L3RyZWUvZHJpdmVycy9zY3NpL2hpc2lfc2FzL2hpc2lf
c2FzX21haW4uYz9oPXY2LjMtcmM2I241MzINCg0KQW55d2F5LCBpdCdzIG5vdCB1cCB0byBtZSAu
Li4gDQoNCltTYWdhciBCaXJhZGFyXSANClllcywgd2UgaGF2ZSByZXNlcnZlZCBjb21tYW5kcywg
dGhhdCBvcmlnaW5hdGUgZnJvbSB3aXRoaW4gdGhlIGRyaXZlci4NCldlIHJlbHkgb24gdGhlIHJl
cGx5X21hcCBtZWNoYW5pc20gKGZyb20gdGhlIG9yaWdpbmFsIHBhdGNoKSB0byBnZXQgaW50ZXJy
dXB0IHZlY3RvciBmb3IgdGhlIHJlc2VydmVkIGNvbW1hbmRzIHRvby4NCg0KVGhhbmtzLA0KSm9o
bg0KDQoNCg==
