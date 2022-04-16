Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61670503476
	for <lists+stable@lfdr.de>; Sat, 16 Apr 2022 08:29:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbiDPGbh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Apr 2022 02:31:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229659AbiDPGbh (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 16 Apr 2022 02:31:37 -0400
Received: from FRA01-PR2-obe.outbound.protection.outlook.com (mail-eopbgr120084.outbound.protection.outlook.com [40.107.12.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF1DCEA34A;
        Fri, 15 Apr 2022 23:29:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Weez7c2PchH1jfMbXi5t0idpo4ICjFg59pDLV6DeTLTpqn0YxbXa2Uq5rCGJp/vTWZfQVTItNqWWfHkU41JpcWcc5jW/KO5nt4PWUkKiDp/Q8mjVIAvImhnTbP3i/ZBUbyGQa/lJhsO4ViJrS8U2IM8x3CZ/KC1fBXoolwX2wkSVL6sgGbenVP+XyJ7cqFnFoOBcFSJ/rnYN5WxUBwoM4RHVot6sLbGPtM+yWBnj4IxQDlVHXyjl+NpLRtn2+2/6JdHuvJ3ccl28cuKbUIrjwMav/PnWJ8cMffXyvndv3yB1LtqyBvyRYaCpMVcDP/lAm3Cecuu1fZPM1PpvW1gOcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v7oNDYSHZGVHOV7n1UxvEnuu9Fx5HfDLx1/8SYyL744=;
 b=EME1Sv53ys4mbtScC+iJzjGWu6VnDk+eJE6Iv7k8FKIMeEqGCSch4GHyF6TKQiF6ehZzTy9PlfR6u89jUwVtdInVIXV1kzV+Naj31oAGhBRnheD/QvwNHQifvGCy1/j7PkdTcvMazewPBET8p3d2CwbGspFGkPI8MKmr60Sugce/Xobli5K8pfwe6WsRhqDMWhUv3K9IscwH/xr12r1dKF5nRrmdwQDAsTkeq6+sverQPEBnK1bkhlH0eXmtaFnF3qAeBIO5T+J+iSH02sf9dGD1vi89qzocB9g8r2sXWkJI6lg8nSalPuIjMWCRwsaJ/cLCalLOW08VDdi/QlRjPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=csgroup.eu; dmarc=pass action=none header.from=csgroup.eu;
 dkim=pass header.d=csgroup.eu; arc=none
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:31::15)
 by PAZP264MB2397.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:1e4::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Sat, 16 Apr
 2022 06:29:04 +0000
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::59c:ae33:63c1:cb1c]) by MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::59c:ae33:63c1:cb1c%8]) with mapi id 15.20.5164.020; Sat, 16 Apr 2022
 06:29:04 +0000
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
To:     Andrew Morton <akpm@linux-foundation.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Steve Capper <steve.capper@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v10] mm, hugetlbfs: Allow for "high" userspace addresses
Thread-Topic: [PATCH v10] mm, hugetlbfs: Allow for "high" userspace addresses
Thread-Index: AQHYUNd8NrewNF7+0Uq1IxdWLzIplqzxii0AgACKqgA=
Date:   Sat, 16 Apr 2022 06:29:04 +0000
Message-ID: <f9d7a5ef-640f-8982-894e-46d823e32b4a@csgroup.eu>
References: <ab847b6edb197bffdfe189e70fb4ac76bfe79e0d.1650033747.git.christophe.leroy@csgroup.eu>
 <20220415151244.c29ad0c9c481dab0ade1022b@linux-foundation.org>
In-Reply-To: <20220415151244.c29ad0c9c481dab0ade1022b@linux-foundation.org>
Accept-Language: fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=csgroup.eu;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f9d44ee5-7036-4f91-dd82-08da1f726720
x-ms-traffictypediagnostic: PAZP264MB2397:EE_
x-microsoft-antispam-prvs: <PAZP264MB23971E6DCFA631F75E80F970EDF19@PAZP264MB2397.FRAP264.PROD.OUTLOOK.COM>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ErAHWzmNyQFOMmu+oTCj7zpEfIvePNMiJzGk1f3GqmOmOBbNoyoHcfk6U6tGwsr/ff/a2oqVa49vAp1xGsHg27z6TIe4LUMSH8ViYqB/RhibO6xrfmjIhk8MLMdXadt+T3WYgXU4Do0/OAkEx24lVnclXQe78ruBP1hoT8andimJZplFZgwR9yweqUgNyHmojSJw5sDsi9pkl+uzWvSjVvkG+HmZBTE1SL9f9PGFHzyNMQpURr2jDOXxXsbvjvhyy9eqZZgaaG3khK1bjXna8VzX/rT3+TjeeZz1Y58M+vLwAiXloobyh2p8e/GwvPiC6nN/V+rALlIcNQedTC9Y1XbjoBhpP2y98gOfRX0VoHcuoZ3xRPnygECDAbYa0LeiWjNyPa+LfFqE+hNmFXOK1MfhFaaq6W1WoKFSY0QfzkPrt2LpLAH4gOcb8QoUpcUXjHWTJ6DDOxalxfrPMYaTSOCFAGTIYMF5S/xqzUtd8MfOmTpd2001yj5zBlU8NBfJSrapnAsBUYvyYFpOEOQqGTuB2Tcfr14xKhV9kveXXTqMPnI3Z+huS4wLucgMMc9sDpvffPDL26eYquhAzMqTkcizf2IPp3N/F+9aUI/MxNCa/R+hURFWZs+MkggDXuatETNKNvRR4xYRjTYHhSxNtCWdYE+boBBbPjHiiqWvNaBE3yJOevmCGy3sUcFBAyVEy8kUq5KjLIxd8fKQB/KstPNnZ1lS1DITWD+dO2cSFle/sEdUhcHhYPJNXsaAgcZrphYX5C3dIuAcUWRV/ot5pQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(5660300002)(508600001)(86362001)(6916009)(6506007)(66476007)(76116006)(66446008)(186003)(2616005)(64756008)(66574015)(31696002)(122000001)(38070700005)(38100700002)(71200400001)(4326008)(8676002)(66946007)(6512007)(91956017)(26005)(316002)(4744005)(2906002)(36756003)(8936002)(54906003)(44832011)(66556008)(31686004)(6486002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NnZrZUlFSkJNSVhyb0JoT1ovMDR2UllFdFNvMHFvdVlnbFRuNjQ2Z1dlNFBo?=
 =?utf-8?B?OGhpb09rajdMK2F2alFGN0w1MjhSc0orMFlxMHhrKzRYbUl3OUNaekhuTklo?=
 =?utf-8?B?RTQ2VzJreklzZ2dlVlNRa1BXbWErdmYrSDVzTGZGSnp1SVZWV1FFZEJJOWJi?=
 =?utf-8?B?ZGFBMmtJN0F0aUtVSUhSZ1hwNGN5T1dpUkNFVUYzV0ZIdGVpK3BsQjFXUENM?=
 =?utf-8?B?TFp0MWZpc3RQTGk3b3lEbUNtai95bnlPRkdrdzhTT0xqM29IMkxYbUk4K1NN?=
 =?utf-8?B?YkpFa1lvaFoxMWMwb002V3BjSFFKZzN3NnZGeXcxUWdDZU8rbmN4QVJlTEF1?=
 =?utf-8?B?T3ZRY0VLRit4SnArQjgwVGhoK3k3bjBmb0tNKzdLU1pGSkh2bHFWa1pSWUJB?=
 =?utf-8?B?Z29MV3RUQ2ZSbVVZaHVYQlRUaHR4ajhpSVRITmJKSWlnQUxqWjZ3SGMrMDFi?=
 =?utf-8?B?N3dzVjVCaFhPZDdxVVUwTWtJWGpVM2RPd0VmZGVlbEpjSkVmSHBJRk9mNTYr?=
 =?utf-8?B?WHBOaFBBZzY1YTBtNTVBTzJQbzlWejJHbU5oWmNXZWkwZk1LMDE0MjIycnNw?=
 =?utf-8?B?bms4VnlvaG9MOUszRis1R0xSYTF6VHlOUVZDczJ1N2hTMUVyamFCOTArN1Fh?=
 =?utf-8?B?NzcxUmdTZHV1VUVKSDdQTkIrdmN4R1BJOWpxd1kwTk5iTGN3eHpaUkkrbWhl?=
 =?utf-8?B?NDhjeFByRWRaaGxmSHVySVdlRmVnYU9Mb2l4ZnlBdWYvNHgxeElkdnYrdUlO?=
 =?utf-8?B?bFc3VTN4OVNwaCtZY2EyTzhLNTI5NkJpQ2pqbHJubEUrY0NFbzJYUlY4V1ZF?=
 =?utf-8?B?RFk0NDV4U1VLVmFseDNaUkpnb05EaWR5WW4xZUphZFh0bkNXQ0MyWndkZ3VT?=
 =?utf-8?B?OTZDcngvK3o0M0VKT1R6REppTW1Tdk4vU2NSeVQxeWVpeGhmMG9pZ0NhMyty?=
 =?utf-8?B?Mk1wOTRCVVBHNFdoaDZldlJMdi9RVjMvUnQrY25pMWIxZDRoM21KSmwwdzUx?=
 =?utf-8?B?M0V3YzR2a29EWEZOanRrZ1F6VzFKRmQ3bTVwRmNkQklxK0ViWUV0Y2JRdmZn?=
 =?utf-8?B?NGZTVk9PU0h0allzSXk0dHFMaHJsa3ZLS0lFbGFObEJXVHdJVlZmajY3WU5N?=
 =?utf-8?B?SEpXT25Qa2hZaStQZFhraHFNMmkzbXpSZlhIbWlFQ2wwV21oTjhVSmJPRi9M?=
 =?utf-8?B?TUJPY3U3UVhYTjhkTjEvQ1E5M1RpdnlKc2lpdUV0S0FiY05hak9rZkw5MzBx?=
 =?utf-8?B?RCtUVmdIZDd4QWEvS2k1TzFrMEFlZzUya1gvOHRJNWxiRU9aNzZiVmNQRXJz?=
 =?utf-8?B?RFUzcnVlcS9IWk9PVVp4cDByTnFFVkY2bHB6NVFKWUQ4cWJvbXZyNE1udG9K?=
 =?utf-8?B?WkxSeFdLeldQcSt6SjZBdW9jRnV5Umh1T2J4YzloTFUzYlp6NGRrc2xkZSt1?=
 =?utf-8?B?REIxa3R3ZTZ0NCtrMTd1VXhSWjZpRldQMk9odWtQODhiSFcvMXlNTW1UZEo1?=
 =?utf-8?B?YkNRWmhmQkVIc3dvYjAvVkV3Vm5wMUlCbDVQMytKWk1UdW43UzBrdHhyYkhV?=
 =?utf-8?B?WGcyT1ZGRlJzYmQ2SzJHZldRUWZwUEtwMW1XZDRXb0FLQWhPZXpsTGZPSzh4?=
 =?utf-8?B?dlVGYXVCMUxiblpOQU9JYmVjNGNNRnFGakxyYklkbE9vRHErVXVCS1czcEk2?=
 =?utf-8?B?ZHpEc3ZOQ0pkbnNvYnVGamlFQ3Z5NTB3UWVsK0pKZHozMzFWRlVnME1jQlBP?=
 =?utf-8?B?ckZBZzVmNC9pTW5WSHlyejdmcHZDVk5mcE5tMnFkY0pzVWxaTzczZXZvTlpo?=
 =?utf-8?B?d1VBbVJSUVVJOGk3TW9VWTNQQWZERVJQT2FTNUlSenNBa1VrWmltaVo1a1BE?=
 =?utf-8?B?bjV0djIrTmh3RzdSSjJpTVFjOERqbjYzazVOSVcyL2xleWw5VXpYZTJZNVB6?=
 =?utf-8?B?OEh0a1BCdU94V3FXMFZDUldCR3pYNUpzU2l1UWcyTm9NMzZyaVJqMldkczY4?=
 =?utf-8?B?ckJxbWF6UjU3M095SVVUNG1iek5jek5JSjlUUWRRUTdIblc2TGtTTHBwY1NZ?=
 =?utf-8?B?ZmFKT3NvK1E0dEVyTmd2Wi95Ykt2aUJvV2tWN3hRaEdRaEVtZGhWU0hreUdr?=
 =?utf-8?B?Vnpjd0dibzl1SGtvSHBjcFVTcXB1a0hBZlNtNnE1UjFFQ3RnZXpxSUZ4Z2g5?=
 =?utf-8?B?KzllcHQ2emtjWmJEblc5L2szMk4zaHlUL01UVkJPUHY5U2NnRVIvM25jL3o2?=
 =?utf-8?B?bkdLL0h2Yi9RN0cxOHdJL2dVOEpLT1pHOUVxUGhZdTBGZ1R4bXBoU0VENGpl?=
 =?utf-8?B?TU1zMnFWYVlIdzFvQ0ZPbU5OaTl4TVord2luYWNKeHNwUVhlbnhoTWtTRGU1?=
 =?utf-8?Q?5abkk30b1s6kazqfex5hR4G26oIm3MolvKyma?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9CCCA0658C169B4392DF23D0771A1A1B@FRAP264.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: csgroup.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: f9d44ee5-7036-4f91-dd82-08da1f726720
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Apr 2022 06:29:04.2192
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9914def7-b676-4fda-8815-5d49fb3b45c8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3MSEuHIEiMdjLAgMFtkz+jvgOz913OWQF/Vy6CuNQMCv1OAJalzvACraWVDHNjIX2Lw2gFsZUpnznRqtZHoxGHvNnc1eg+uVh5QZ5pGnJCM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAZP264MB2397
X-Spam-Status: No, score=-5.8 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DQoNCkxlIDE2LzA0LzIwMjIgw6AgMDA6MTIsIEFuZHJldyBNb3J0b24gYSDDqWNyaXTCoDoNCj4g
T24gRnJpLCAxNSBBcHIgMjAyMiAxNjo0NToxMyArMDIwMCBDaHJpc3RvcGhlIExlcm95IDxjaHJp
c3RvcGhlLmxlcm95QGNzZ3JvdXAuZXU+IHdyb3RlOg0KPiANCj4+IFRoaXMgaXMgYSBmaXggZm9y
IGNvbW1pdCBmNjc5NTA1M2RhYzggKCJtbTogbW1hcDogQWxsb3cgZm9yICJoaWdoIg0KPj4gdXNl
cnNwYWNlIGFkZHJlc3NlcyIpIGZvciBodWdldGxiLg0KPiANCj4gU28gdGhlICJodWdldGxiZnMi
IGluIHRoZSBTdWJqZWN0OiBpcyBhIHRweW8/DQoNClRoaXMgcGF0Y2ggbW9kaWZpZXMgZnMvaHVn
ZXRsYmZzL2lub2RlLmMgLCBoZW5jZSB0aGUgImh1Z2V0bGJmcyIgaW4gdGhlIA0KU3ViamVjdC4N
Cg0KQW0gSSBkb2luZyBpdCB3cm9uZyA/DQoNCkNocmlzdG9waGU=
