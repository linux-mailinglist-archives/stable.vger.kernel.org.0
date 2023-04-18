Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBA796E69AA
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 18:36:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229453AbjDRQgw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 12:36:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232371AbjDRQgu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 12:36:50 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25CC4BBB2;
        Tue, 18 Apr 2023 09:36:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1681835805; x=1713371805;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=dN8dxMUthumR+nb0g8XUJ6vtRI2q0eK51Yym/zl33CQ=;
  b=1fptTwoQCTG956Aa7hSE6/IhsjKtG8L63k/nBX46LOaHcA54lzaZlBzB
   YE8NbiqAxVuMZW4DVLqVA6QgZ5PWkVk9taHefVWRVhihc7Cc09r33mwE8
   Bx0afVTqvVmC0paFMHUdihOKbZHu5GLift4M1y3jzfDu3rKc8GhF4fzKI
   NRWKnhV5M6mL8Uif9xPmMU+8+uWW+a6MIOgt9fQfuv3Ca5w3iTEKdEgPD
   Y/z7GVH4EQ2uU7G4N8SJrkR0q6DZrh4BJvfjvokmb0+ZqJ+VFjaeDaVEF
   RMUCNo0declqPXkvpOlI8LbzyLY34Aw/pT4hkEkTguUdLCVJLxSc0fKEc
   g==;
X-IronPort-AV: E=Sophos;i="5.99,207,1677567600"; 
   d="scan'208";a="211051212"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 18 Apr 2023 09:36:43 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 18 Apr 2023 09:36:43 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21 via Frontend
 Transport; Tue, 18 Apr 2023 09:36:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F51l5NMcLM0nC8jJ5aCV/Ix+H4pZ88qZ1lHKUJJOljNUIs9YKykMe3iWesZ4n2C/GXjtoKDMi4YW6AeOLqGTP5eWVI7OZsY/xBfTajbhotJJQa7UXshcG6Q0N/sDHWkG2M6T5KeakJU3+1nKMoNrB2WBiwQku7eueTXht5X20bZXmXIu6um/T3V07AmQFobMrAT45zRGfy3NsKgFRwJ8mvCvE0sWsh0ERwfHLr+fN+GoafnNXg3eE6wzqOuJn0i4r6lYb408GvrRYqVDiB2kriwlMlAD7ceh5VjS7QBW6S/2RQPcjtM4MLei1dFAZPpI3TSKAAi30nkaqINosA6YQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dN8dxMUthumR+nb0g8XUJ6vtRI2q0eK51Yym/zl33CQ=;
 b=enULnQuR13bhJosVptUAv4FJTVTkMjQ5x32THaQMv//v4y8kGq1UqIKIsuJiS86iu6iGr0tZRk5l54X/kewkipoGPtzXwn8oVyL8+ZRw1w/nj6l832kVgbQcxgagcaTXOOxLmdvz9XV8ZSC9l8T3Ejc4L1ViDDDS6BhFjSagwZrJTNffkCj1k/PfTiZUuJkXHKuRRFil5BPN6LLMyC4gd5m2AgEBie3I/T6EsNa+buFkqk5KXQqGBW2Y9r9LsJ0RdS2f2l6XtDnRZA6VuJPmzCiWuZDmXCwkHUlgMIFeDW2xeKruWWlqe19ORXRn831FgQVhi2pk0xOTjFUBwL3LFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dN8dxMUthumR+nb0g8XUJ6vtRI2q0eK51Yym/zl33CQ=;
 b=Ben0s9dpQthIyKJDxp4x2R702Hdux7drhqZ+QJlQheV8vdP5bTx63cxYbHuUiV8K7ohWhz6EPOPS4Ls2MMS+P9VYcnBVTllpsRcAClHWRtv58vmxusMA2m7OjDCAb7BMvey7BPyuIkaImvBiCKOXL5A2UI41IXb7C++O28nw+4U=
Received: from BYAPR11MB3606.namprd11.prod.outlook.com (2603:10b6:a03:b5::25)
 by MW4PR11MB5909.namprd11.prod.outlook.com (2603:10b6:303:168::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Tue, 18 Apr
 2023 16:36:40 +0000
Received: from BYAPR11MB3606.namprd11.prod.outlook.com
 ([fe80::d838:54c1:6d00:d064]) by BYAPR11MB3606.namprd11.prod.outlook.com
 ([fe80::d838:54c1:6d00:d064%6]) with mapi id 15.20.6298.045; Tue, 18 Apr 2023
 16:36:40 +0000
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
Thread-Index: AQHZYb4PYBI21vPRIUeRtFcfEd9THa8RVvYAgBPI3YCAAmG6gIAD0uVwgAYPnzA=
Date:   Tue, 18 Apr 2023 16:36:39 +0000
Message-ID: <BYAPR11MB360638EB956EC22064A3E1EDFA9D9@BYAPR11MB3606.namprd11.prod.outlook.com>
References: <20230328214124.26419-1-sagar.biradar@microchip.com>
 <3bce4faf-e843-914c-4822-784188e3436e@oracle.com>
 <BYAPR11MB3606BFE903D1BBE56C89D31BFA959@BYAPR11MB3606.namprd11.prod.outlook.com>
 <d7abc010-4d02-c04d-64d5-5fa857b0e690@oracle.com>
 <BYAPR11MB360644221F15706FA165CC5CFA999@BYAPR11MB3606.namprd11.prod.outlook.com>
In-Reply-To: <BYAPR11MB360644221F15706FA165CC5CFA999@BYAPR11MB3606.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR11MB3606:EE_|MW4PR11MB5909:EE_
x-ms-office365-filtering-correlation-id: af05d788-95fc-4883-991e-08db402b1601
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: itiv55jd3JTAkVuPei/zwBJJv0LdH0KSH82BTMoKGMaqq5vAOhDS3N0lpRHJsrk/OxbB2ww1KMn7lPJHbRF4epiNvGTUI51/O9EplqNWWa7znyM8QrMG+91Mm6SJcC4ss0/RB0fHTLzhBTtGOBetaP2THT3YrwpL6hiaNGlSkZh8Aq8+VoQ7iBAy6g+Q9w7Xnb0vgevpuQjecUdv0resBHcnAjJ9sZb3B1k77PflQhX/uSGfuaH4ohD4nYUkOqnzsbt5qH16L/8tX/H+x68n5lReMsAnsqYOAmSOpXweC4Qbmf7NOtHmWVIApUaEZBd7uNsJ+TnSDGtruKhUQvwY2ljM8CBwo+Rq/SwBCjOAV+/OWWn9h5LaNt83ZDF4rA7sq2hPZX9vMom4JMQFdygRB00hcsLCk6tL2j9Fa1k1D2u7seMamzG5lgldeBWWxsgf9y8qYWoRJ9Vxb11ewCYZ9mfKNQeLkeytvc6zxyCyjfoce35iTnJ9TIxsrUB0aJzpwd1rh7WYYgEL68BrKCoFGX8smo0NeXBJxPgebkapx5L9lrTVW3hF7v04KjmDi0/CMneCYYQmhurxE2+0r5fYWbfb9MES3/M/E16fRVR2P5es88K9fG9dHFm46iuYBEYjqh0QY9vwXFb1rPIBwI9o/q924p71QAMXJbQ3ZTwcYtY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3606.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(136003)(376002)(39860400002)(346002)(366004)(451199021)(7696005)(71200400001)(6636002)(110136005)(55016003)(2906002)(33656002)(38100700002)(122000001)(478600001)(83380400001)(186003)(6506007)(26005)(9686003)(53546011)(966005)(5660300002)(52536014)(66946007)(316002)(66556008)(64756008)(76116006)(66476007)(66446008)(86362001)(38070700005)(41300700001)(8936002)(8676002)(491001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?R3kzaVVaUENiYUpuZytQV0ZSUktiTlN4M2crZEtVa0pTamV0dVZ1eGpmSnFt?=
 =?utf-8?B?OXNYSjNONkpqekMyNWp0ZWp3SGlUZmFKS1ZHUjJQK2xxVzFSWGlaVCtOMDg3?=
 =?utf-8?B?TDhRWFpxUzVudWFKNEdzU3VlTGhlVVVUdVpDYng0b1kwL2JnWlBOZDRTMVFu?=
 =?utf-8?B?YXNPTmdLSngwZVNOb01oSGI4Nyt1bFo5elJ2QW9BQ3pSNnFITHNPc0o3Mkoz?=
 =?utf-8?B?d01pRU51eU5ldU51dXhsbmkzTnFZVmFCSTN0bG9pd1RIK1Z3RWZpVDI5eVhP?=
 =?utf-8?B?bm5Jd3R4aHBJU09qYkFiS1h3WXFabFNXS0ZqbUJQNENYTnpUUzAzdGVVM1dh?=
 =?utf-8?B?V1ZvV0lrSkdYYjh5YUpoTXltcWsvejZYUXcydFNtL1NFeGM1dGNTbUFCeXhP?=
 =?utf-8?B?UmR1ME9pNnRZWUlGSUovdVBzQS83N2IxV2h0ZnJPME51SXh5THBTai84eGJD?=
 =?utf-8?B?ai9hQnlQN3BwRk1EenljbEZraksyVzlXSnUvVkVIQ0d1UjZrRlg2QUxVaVFw?=
 =?utf-8?B?NVZkWEFKVGFrQ0x6SDArNWRhRTBqRExjdW0zL1NsUkFEY0pzQlpHWnl3MjR4?=
 =?utf-8?B?b2lZejZDVTNMM01rM0NnWHVqOVRhYldnQ1BnNlhlY2I1alAyeWRWMEYrV2dn?=
 =?utf-8?B?Y2JIUEVnYUFiMWJYZ3AwWHlwUVN1d2QydTgrdXByU3lRZGVubkNpT2FMR3RW?=
 =?utf-8?B?dUQ4b08vZFlVVEVmdS9BcmFzU1huV3M5SjN6UGhaTGZkeE1CT1FoWXJ6L2k1?=
 =?utf-8?B?Y0hCd0x3TnRRem1vRzhVL05UMWMrMUFwWGFmWUY4bWRFTmtpLytveUVSc3Y4?=
 =?utf-8?B?Q2Rkcng2enBUd3ZzSVo4NEFiY21IMGl4aEdGcGxTRU5SbVFrbllTbmJCcS9N?=
 =?utf-8?B?TE5pU1R5bmdSeFlKRmUzRDd0L01VMzcwZlJtTUhvWTdaOXVCYnNLYUppSW81?=
 =?utf-8?B?T29kZXZRMVM2L3RrdkpkYzJnZkQzQ0VBOWhrcVNuMyt5WUxsQVRING1CUGJZ?=
 =?utf-8?B?UFlZSzB2Q202c0lSeWo0VVRKeUpGOWkzNkpGOVJlR0g0bUl1NUFhazNmSnBx?=
 =?utf-8?B?cUVFclB5QldyZnpndkh2eVVhOTJRUjFnZkNzZU5XN2h3R0E5ZTZ3THE5ZHdp?=
 =?utf-8?B?MXp3S0JvakpFNHluUldldGdsT0FGTGh2aDAvalprdGhvbkl1cU4wZWpwVHBK?=
 =?utf-8?B?Ky9nRmtCNlliYkQ2MGxzOEtHb1ArdllvNzMzbjB3L2JnaTlsVjV4eHVFR0V2?=
 =?utf-8?B?b0xlbDZYN1BiajZlblBya1MvcHNIU0RlbWpOdUVMZFE5RVM3SG01bElQUTZi?=
 =?utf-8?B?dlp0SG5Dam5uL3ZhbGtMVHBWT1lWOGdvOHpqZng2dHVoYXJzNy9kdzl1Uisw?=
 =?utf-8?B?ODhXaVBTVWx5YUNLdnN0V3JwTG5YUDBBakRkaTZ1UUtHUGd0dzIvLzM1dml5?=
 =?utf-8?B?YmFrOUV6NFBOM0U5MGRES2dtazlpWTRCRGdqMUlkUDY1VzgzS0xHRWpsZk1q?=
 =?utf-8?B?ZkRncXBMQ01Kc01QY0s5cnlKVWIzRFRFQXhDZExWNHA4eVhZeHlTRXhVZ09G?=
 =?utf-8?B?ZCtJNm9YSEVrVTVRWTlQcmFzdmo0enVsRGF1T2cwamJtc0FQUUI1YmNsYlhV?=
 =?utf-8?B?NDk0aGVUREZqYW0xbmw0ZDBBTFhlRWpvUG1STEsrQXpWUFVyNnNCSEdHdWpL?=
 =?utf-8?B?WUlWZ011aytyTjUweUVhM1M1WmdpSHNlcTRLRmRYM2NDME5wcU9hbHV6MHJG?=
 =?utf-8?B?Y1FORHFIVjM2eXpBb05ST2ZsZ2htY2hOK3lVZ1B5RndzUjF1aXdRZDdxSytv?=
 =?utf-8?B?ZWM4YWpyeHVKZi82a2tyRDRZbkRzRGNaMk5SWmE1Q2RqRzNVTC95aFR2akRy?=
 =?utf-8?B?U1A0SGV1bWYwVXJEWXlLTjlGNGxaYm5JTU52STNWNmkzOHJ0YVV6d1J2eTlN?=
 =?utf-8?B?bXVOMHVjeGFna0FVaWlrUllFUkV6WTBvd0RDdmlnQ05laFlja28xaVBUdnAz?=
 =?utf-8?B?UE50VTdReDhXSUxXM3c0NjFZeFFOaDRzVUFsMG0yWXY5YkYyaEZQQ05OblU1?=
 =?utf-8?B?MkdSNS9MbFRtc3Z2N1paTUduM3phR1RoQ0J5TFROMkR2Q1prczA3WWFsYmlU?=
 =?utf-8?Q?XHdxqbwR1Adp7l1T/slt2naZD?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3606.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af05d788-95fc-4883-991e-08db402b1601
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Apr 2023 16:36:39.9639
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dp1U9lTdRjuhHfq4oLDalAjWPWle3smFbQF31w5nrYktCkAgjJqs8eBxCo3PQ4iobnOKf09ZwL7UVo6dCNlR/dM4sI3/fAnhcXRDB3SrVMM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB5909
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DQoNCi0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQpGcm9tOiBTYWdhciBCaXJhZGFyIC0gQzM0
MjQ5IA0KU2VudDogRnJpZGF5LCBBcHJpbCAxNCwgMjAyMyAxOjA3IFBNDQpUbzogSm9obiBHYXJy
eSA8am9obi5nLmdhcnJ5QG9yYWNsZS5jb20+OyBEb24gQnJhY2UgLSBDMzM3MDYgPERvbi5CcmFj
ZUBtaWNyb2NoaXAuY29tPjsgR2lsYmVydCBXdSAtIEMzMzUwNCA8R2lsYmVydC5XdUBtaWNyb2No
aXAuY29tPjsgbGludXgtc2NzaUB2Z2VyLmtlcm5lbC5vcmc7IG1hcnRpbi5wZXRlcnNlbkBvcmFj
bGUuY29tOyBqZWpiQGxpbnV4LmlibS5jb207IGJya2luZ0BsaW51eC52bmV0LmlibS5jb207IHN0
YWJsZUB2Z2VyLmtlcm5lbC5vcmc7IFRvbSBXaGl0ZSAtIEMzMzUwMyA8VG9tLldoaXRlQG1pY3Jv
Y2hpcC5jb20+DQpTdWJqZWN0OiBSRTogW1BBVENIXSBhYWNyYWlkOiByZXBseSBxdWV1ZSBtYXBw
aW5nIHRvIENQVXMgYmFzZWQgb2YgSVJRIGFmZmluaXR5DQoNCltTYWdhciBCaXJhZGFyXSBKdXN0
IGNoZWNraW5nIGlmIGFueW9uZSBnZXQgYSBjaGFuY2UgdG8gcmV2aWV3IHRoaXMgcGF0Y2g/DQpU
aGFua3MsIGluIGFkdmFuY2UuDQoNCg0KLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCkZyb206
IEpvaG4gR2FycnkgPGpvaG4uZy5nYXJyeUBvcmFjbGUuY29tPg0KU2VudDogV2VkbmVzZGF5LCBB
cHJpbCAxMiwgMjAyMyAyOjM4IEFNDQpUbzogU2FnYXIgQmlyYWRhciAtIEMzNDI0OSA8U2FnYXIu
QmlyYWRhckBtaWNyb2NoaXAuY29tPjsgRG9uIEJyYWNlIC0gQzMzNzA2IDxEb24uQnJhY2VAbWlj
cm9jaGlwLmNvbT47IEdpbGJlcnQgV3UgLSBDMzM1MDQgPEdpbGJlcnQuV3VAbWljcm9jaGlwLmNv
bT47IGxpbnV4LXNjc2lAdmdlci5rZXJuZWwub3JnOyBtYXJ0aW4ucGV0ZXJzZW5Ab3JhY2xlLmNv
bTsgamVqYkBsaW51eC5pYm0uY29tOyBicmtpbmdAbGludXgudm5ldC5pYm0uY29tOyBzdGFibGVA
dmdlci5rZXJuZWwub3JnOyBUb20gV2hpdGUgLSBDMzM1MDMgPFRvbS5XaGl0ZUBtaWNyb2NoaXAu
Y29tPg0KU3ViamVjdDogUmU6IFtQQVRDSF0gYWFjcmFpZDogcmVwbHkgcXVldWUgbWFwcGluZyB0
byBDUFVzIGJhc2VkIG9mIElSUSBhZmZpbml0eQ0KDQpFWFRFUk5BTCBFTUFJTDogRG8gbm90IGNs
aWNrIGxpbmtzIG9yIG9wZW4gYXR0YWNobWVudHMgdW5sZXNzIHlvdSBrbm93IHRoZSBjb250ZW50
IGlzIHNhZmUNCg0KT24gMTAvMDQvMjAyMyAyMjoxNywgU2FnYXIuQmlyYWRhckBtaWNyb2NoaXAu
Y29tIHdyb3RlOg0KPiBPbiAyOC8wMy8yMDIzIDIyOjQxLCBTYWdhciBCaXJhZGFyIHdyb3RlOg0K
Pj4gRml4IHRoZSBJTyBoYW5nIHRoYXQgYXJpc2VzIGJlY2F1c2Ugb2YgTVNJeCB2ZWN0b3Igbm90
IGhhdmluZyBhIA0KPj4gbWFwcGVkIG9ubGluZSBDUFUgdXBvbiByZWNlaXZpbmcgY29tcGxldGlv
bi4NCj4gV2hhdCBhYm91dCBpZiB0aGUgQ1BVIHRhcmdldGVkIGdvZXMgb2ZmbGluZSB3aGlsZSB0
aGUgSU8gaXMgaW4tZmxpZ2h0Pw0KPg0KPj4gVGhpcyBwYXRjaCBzZXRzIHVwIGEgcmVwbHkgcXVl
dWUgbWFwcGluZyB0byBDUFVzIGJhc2VkIG9uIHRoZSBJUlEgDQo+PiBhZmZpbml0eSByZXRyaWV2
ZWQgdXNpbmcgcGNpX2lycV9nZXRfYWZmaW5pdHkoKSBBUEkuDQo+Pg0KPiBibGstbXEgYWxyZWFk
eSBkb2VzIHdoYXQgeW91IHdhbnQgaGVyZSwgaW5jbHVkaW5nIGhhbmRsaW5nIGZvciB0aGUgY2Fz
ZSBJIG1lbnRpb24gYWJvdmUuIEl0IG1haW50YWlucyBhIENQVSAtPiBIVyBxdWV1ZSBtYXBwaW5n
LCBhbmQgdXNpbmcgYSByZXBseSBtYXAgaW4gdGhlIExMRCBpcyB0aGUgb2xkIHdheSBvZiBkb2lu
ZyB0aGlzLg0KPg0KPiBDb3VsZCB5b3UgaW5zdGVhZCBmb2xsb3cgdGhlIGV4YW1wbGUgaW4gY29t
bWl0IDY2NGYwZGNlMjA1OCAoInNjc2k6DQo+IG1wdDNzYXM6IEFkZCBzdXBwb3J0IGZvciBzaGFy
ZWQgaG9zdCB0YWdzZXQgZm9yIENQVSBob3RwbHVnIiksIGFuZCBleHBvc2UgdGhlIEhXIHF1ZXVl
cyB0byB0aGUgdXBwZXIgbGF5ZXI/IFlvdSBjYW4gYWx0ZXJuYXRpdmVseSBjaGVjayB0aGUgZXhh
bXBsZSBvZiBhbnkgU0NTSSBkcml2ZXIgd2hpY2ggc2V0cyBzaG9zdC0+aG9zdF90YWdzZXQgZm9y
IHRoaXMuDQo+DQo+IFRoYW5rcywNCj4gSm9obg0KPiBbU2FnYXIgQmlyYWRhcl0NCj4NCj4gKioq
V2hhdCBhYm91dCBpZiB0aGUgQ1BVIHRhcmdldGVkIGdvZXMgb2ZmbGluZSB3aGlsZSB0aGUgSU8g
aXMgaW4tZmxpZ2h0Pw0KPiBXZSByYW4gbXVsdGlwbGUgcmFuZG9tIGNhc2VzIHdpdGggdGhlIElP
J3MgcnVubmluZyBpbiBwYXJhbGxlbCBhbmQgZGlzYWJsaW5nIGxvYWQtYmVhcmluZyBDUFUncy4g
V2Ugc2F3IHRoYXQgdGhlIGxvYWQgd2FzIHRyYW5zZmVycmVkIHRvIHRoZSBvdGhlciBvbmxpbmUg
Q1BVcyBzdWNjZXNzZnVsbHkgZXZlcnkgdGltZS4NCj4gVGhlIHNhbWUgd2FzIHRlc3RlZCBhdCB2
ZW5kb3IgYW5kIHRoZWlyIGN1c3RvbWVyIHNpdGUgLSB0aGV5IGRpZCBub3Qgc2VlIGFueSBpc3N1
ZXMgdG9vLg0KDQpZb3UgbmVlZCB0byBlbnN1cmUgdGhhdCBhbGwgQ1BVcyBhc3NvY2lhdGVkIHdp
dGggdGhlIEhXIHF1ZXVlIGFyZSBvZmZsaW5lIGFuZCBzdGF5IG9mZmxpbmUgdW50aWwgYW55IElP
IG1heSB0aW1lb3V0LCB3aGljaCB3b3VsZCBiZSAzMCBzZWNvbmRzIGFjY29yZGluZyB0byBTQ1NJ
IHNkIGRlZmF1bHQgdGltZW91dC4gSSBhbSBub3Qgc3VyZSBpZiB5b3Ugd2VyZSBkb2luZyB0aGF0
IGV4YWN0bHkuIA0KDQpbU2FnYXIgQmlyYWRhcl0NClJlc3BvbmRpbmcgYWdhaW4gaW5saW5lIHRv
IHRoZSBvcmlnaW5hbCB0aHJlYWQgdG8gYXZvaWQgY29uZnVzaW9uIC4gLiAuIA0KDQpXZSBkaXNh
YmxlZCAxNCBvdXQgb2YgMTYgQ1BVcyBhbmQgZWFjaCB0aW1lIHdlIHNhdyB0aGUgaW50ZXJydXB0
cyBtaWdyYXRlZCB0byB0aGUgb3RoZXIgQ1BVcy4NClRoZSBDUFVzIHJlbWFpbmVkIG9mZmxpbmUg
Zm9yIHZhcnlpbmcgdGltZXMsIGVhY2ggb2Ygd2hpY2ggd2VyZSBtb3JlIHRoYW4gMzAgc2Vjb25k
cy4NCldlIG1vbml0b3JlZCBwcm9wZXIgYmVoYXZpb3Igb2YgdGhlIHRocmVhZHMgcnVubmluZyBv
biBDUFVzIGFuZCBvYnNlcnZlZCB0aGVtIG1pZ3JhdGluZyB0byBvdGhlciBDUFVzIGFzIHRoZXkg
d2VyZSBkaXNhYmxlZC4NCldlLCBhbG9uZyB3aXRoIHRoZSB2ZW5kb3IvY3VzdG9tZXIsIGRpZCBu
b3Qgb2JzZXJ2ZSBhbnkgY29tbWFuZCB0aW1lb3V0cyBpbiB0aGVzZSBleHBlcmltZW50cy4gDQpJ
biBjYXNlIGFueSBjb21tYW5kcyB0aW1lIG91dCAtIHRoZSBkcml2ZXIgd2lsbCByZXNvcnQgdG8g
dGhlIGVycm9yIGhhbmRsaW5nIG1lY2hhbmlzbS4NCg0KQWxzbywgdGhlcmUgaXMgdGhpcyBwYXRj
aCB3aGljaCBhZGRyZXNzZXMgdGhlIGNvbmNlcm5zIEpvaG4gR2FycnkgcmFpc2VkLg0KaHR0cHM6
Ly9sb3JlLmtlcm5lbC5vcmcvbGttbC8yMDIyMDkyOTAzMzQyOC4yNTk0OC0xLW1qMDEyMy5sZWVA
c2Ftc3VuZy5jb20vVC8NCg0KVGhpcyBwYXRjaCBleHBsYWlucyBob3cgdGhlIGNvb3JkaW5hdGlv
biBoYXBwZW5zIHdoZW4gYSBDUFUgZ29lcyBvZmZsaW5lLg0KSVBJIGNhbiBiZSByZWFkIEludGVy
LVByb2Nlc3NvciBJbnRlcnJ1cHQuDQpUaGUgcmVxdWVzdCBzaGFsbCBiZSBjb21wbGV0ZWQgZnJv
bSB0aGUgQ1BVIHdoZXJlIGl0IGlzIHJ1bm5pbmcgd2hlbiB0aGUgb3JpZ2luYWwgQ1BVIGdvZXMg
b2ZmbGluZS4NCg0KPg0KPg0KPiAqKipibGstbXEgYWxyZWFkeSBkb2VzIHdoYXQgeW91IHdhbnQg
aGVyZSwgaW5jbHVkaW5nIGhhbmRsaW5nIGZvciB0aGUgY2FzZSBJIG1lbnRpb24gYWJvdmUuIEl0
IG1haW50YWlucyBhIENQVSAtPiBIVyBxdWV1ZSBtYXBwaW5nLCBhbmQgdXNpbmcgYSByZXBseSBt
YXAgaW4gdGhlIExMRCBpcyB0aGUgb2xkIHdheSBvZiBkb2luZyB0aGlzLg0KPiBXZSBhbHNvIHRy
aWVkIGltcGxlbWVudGluZyB0aGUgYmxrLW1xIG1lY2hhbmlzbSBpbiB0aGUgZHJpdmVyIGFuZCB3
ZSBzYXcgY29tbWFuZCB0aW1lb3V0cy4NCj4gVGhlIGZpcm13YXJlIGhhcyBsaW1pdGF0aW9uIG9m
IGZpeGVkIG51bWJlciBvZiBxdWV1ZXMgcGVyIHZlY3RvciBhbmQgdGhlIGJsay1tcSBjaGFuZ2Vz
IHdvdWxkIHNhdHVyYXRlIHRoYXQgbGltaXQuDQo+IFRoYXQgYW5zd2VycyB0aGUgcG9zc2libGUg
Y29tbWFuZCB0aW1lb3V0Lg0KPg0KPiBBbHNvIHRoaXMgaXMgRU9MIHByb2R1Y3QgYW5kIHRoZXJl
IHdpbGwgYmUgbm8gZmlybXdhcmUgY29kZSBjaGFuZ2VzLiBHaXZlbiB0aGlzLCB3ZSBoYXZlIGRl
Y2lkZWQgdG8gc3RpY2sgdG8gdGhlIHJlcGx5X21hcCBtZWNoYW5pc20uDQo+IChodHRwczovL3Vy
bGRlZmVuc2UuY29tL3YzL19faHR0cHM6Ly9zdG9yYWdlLm1pY3Jvc2VtaS5jb20vZW4tdXMvc3Vw
cG8NCj4gcnQvc2VyaWVzOC9pbmRleC5waHBfXzshIUFDV1Y1TjlNMlJWOTloUSFQTHJiZm9FQnZF
R3h3MkN2YWhDTDBBUDVjNGY1Yw0KPiBROGdUMGFoWFZnQjBtU2J5cXhXSjhwZHRZWTBKd1JMOHha
NTlrME5ISmhYQ0JiTXRWV2xxNXBZTWVPRUhtdzd3dyQgICkNCj4NCj4gVGhhbmsgeW91IGZvciB5
b3VyIHJldmlldyBjb21tZW50cyBhbmQgd2UgaG9wZSB5b3Ugd2lsbCByZWNvbnNpZGVyIHRoZSBv
cmlnaW5hbCBwYXRjaC4NCg0KSSd2ZSBiZWVuIGNoZWNraW5nIHRoZSBkcml2ZXIgYSBiaXQgbW9y
ZSBhbmQgdGhpcyBkcml2ZXJzIHVzZXMgc29tZSAicmVzZXJ2ZWQiIGNvbW1hbmRzLCByaWdodD8g
VGhhdCB3b3VsZCBiZSBpbnRlcm5hbCBjb21tYW5kcyB3aGljaCB0aGUgZHJpdmVyIHNlbmRzIHRv
IHRoZSBhZGFwdGVyIHdoaWNoIGRvZXMgbm90IGhhdmUgYSBzY3NpX2NtbmQgYXNzb2NpYXRlZC4N
CklmIHNvLCBpdCBnZXRzIGEgYml0IG1vcmUgdHJpY2t5IHRvIHVzZSBibGstbXEgc3VwcG9ydCBm
b3IgSFcgcXVldWVzLCBhcyB3ZSBuZWVkIHRvIG1hbnVhbGx5IGZpbmQgYSBIVyBxdWV1ZSBmb3Ig
dGhvc2UgInJlc2VydmVkIGNvbW1hbmRzIiwgbGlrZQ0KaHR0cHM6Ly9naXQua2VybmVsLm9yZy9w
dWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvdG9ydmFsZHMvbGludXguZ2l0L3RyZWUvZHJpdmVycy9z
Y3NpL2hpc2lfc2FzL2hpc2lfc2FzX21haW4uYz9oPXY2LjMtcmM2I241MzINCg0KQW55d2F5LCBp
dCdzIG5vdCB1cCB0byBtZSAuLi4gDQoNCltTYWdhciBCaXJhZGFyXQ0KWWVzLCB3ZSBoYXZlIHJl
c2VydmVkIGNvbW1hbmRzLCB0aGF0IG9yaWdpbmF0ZSBmcm9tIHdpdGhpbiB0aGUgZHJpdmVyLg0K
V2UgcmVseSBvbiB0aGUgcmVwbHlfbWFwIG1lY2hhbmlzbSAoZnJvbSB0aGUgb3JpZ2luYWwgcGF0
Y2gpIHRvIGdldCBpbnRlcnJ1cHQgdmVjdG9yIGZvciB0aGUgcmVzZXJ2ZWQgY29tbWFuZHMgdG9v
Lg0KDQpUaGFua3MsDQpKb2huDQoNCg0K
