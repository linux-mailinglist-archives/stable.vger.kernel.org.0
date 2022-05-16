Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E50E528962
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 18:02:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233180AbiEPQCb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 12:02:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245487AbiEPQCa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 12:02:30 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2071.outbound.protection.outlook.com [40.107.243.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B21CAE56;
        Mon, 16 May 2022 09:02:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IoWvHhcGpARRt6GkFsyqxB5cEAWM7iop8d3SqiYTIcd8mAuPnqmzbJGkAH3Y3GRBK4CIGYlwbNPDXNlDP3nfY2GqcioAKr8dhV6Kxy/5lP06cvQf2Dw9e3aH/nubakW3f+hSXzop2TZ5te9LXQCGzhpbC+2qcuE8q1cwQgFSZEiUdKaldRzOenHu+dYTxDr10okJkuWnVmYYuCAYErlJdes9iDQGRQusLa5qUHXnu/9gLAdtqJ7A54+JPpX5/gbSKQIjh3+ferLamV49W2zfMaMmmFbBQxusnUYzWcl/b4R/jD7+2bbKbi8+HRW6mHPn4ElF1946Kh05kVJ26lVkgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JthlsO0Ru/TVC7DiTetTDbnFA9tMwgqx0ul4vBQS7nY=;
 b=kptqnkHplmosDiJxmhyjGVyOJC1k/vtw0VqRq3LIj+uGC9EyQrGTfji2dtvSdxAXtCvJjfAbnxP4FPklgysBDa3L9zr4aQt7JZmT9lNnN8RcRYfrBqjgSlCLsBddkE95pbcHzSsD2CqVHzv7rcz7c4hCCR5QPpXpkwONhV9ehbygONsytUkDlUEJU1ri8Tc2FSR6m5UPsRBycST6E5P89AB26FjBY80+34lXIebSp8K7QaoAQPwoKX4skf5Moim/Dnp6AWYX9UxKh2i/81GnIa0miUSfnDeqKWbutomro8jxInZfZcBcoa2XbpJW9+TuQzpguW66XTuKbv4kVRDZTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JthlsO0Ru/TVC7DiTetTDbnFA9tMwgqx0ul4vBQS7nY=;
 b=bhkYWbbqE1meBkCEl3JDkylWU6XeR9ZJWWEjT2+gFHt8aJUEPfi/bNnY5jOUnI29ydAFM3HercgOOsqwXL96jcZenMW/ssrtQoBjdrJkxgDPxHV0Tn3aVB744tE/qyXy++W/u0M9gffHsdX0XvJFgyhbhcmzXzI7oNAk1cf5Jy0=
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by MN2PR12MB3439.namprd12.prod.outlook.com (2603:10b6:208:cf::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.17; Mon, 16 May
 2022 16:02:27 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::25d7:1ecc:64f2:f9c0]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::25d7:1ecc:64f2:f9c0%6]) with mapi id 15.20.5250.018; Mon, 16 May 2022
 16:02:27 +0000
From:   "Kalra, Ashish" <Ashish.Kalra@amd.com>
To:     Peter Gonda <pgonda@google.com>, "Allen, John" <John.Allen@amd.com>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andy Nguyen <theflow@google.com>,
        David Rientjes <rientjes@google.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH v2] crypto: ccp - Use kzalloc for sev ioctl interfaces to
 prevent kernel memory leak
Thread-Topic: [PATCH v2] crypto: ccp - Use kzalloc for sev ioctl interfaces to
 prevent kernel memory leak
Thread-Index: AQHYaTwUxoMisTo8TEW3VgseD18R+K0hp6QAgAABb8A=
Date:   Mon, 16 May 2022 16:02:27 +0000
Message-ID: <SN6PR12MB27678261F176C5D9B5BF64EF8ECF9@SN6PR12MB2767.namprd12.prod.outlook.com>
References: <20220516154512.259759-1-john.allen@amd.com>
 <CAMkAt6oUxUFtNS4W0bzu13oWMdfnzfNrphH3OqwAkmxJcXhOqw@mail.gmail.com>
In-Reply-To: <CAMkAt6oUxUFtNS4W0bzu13oWMdfnzfNrphH3OqwAkmxJcXhOqw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Enabled=true;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SetDate=2022-05-16T15:58:24Z;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Method=Standard;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Name=General;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ActionId=abb0ab40-4f8e-4b7c-a6c2-65fdac7a748a;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ContentBits=1
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_enabled: true
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_setdate: 2022-05-16T16:02:25Z
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_method: Standard
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_name: General
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_actionid: a201740e-57c9-49de-a67d-44c86ec4a6fa
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 98a0b89e-aed3-4b53-c92f-08da3755794f
x-ms-traffictypediagnostic: MN2PR12MB3439:EE_
x-microsoft-antispam-prvs: <MN2PR12MB3439CE86AE84F32C1185415D8ECF9@MN2PR12MB3439.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /XRLCrFnp1HmdZYYy2/LuImGfviqj/bewHmJIFnk87W8gO7RIMrMI3UEFfsZAjbOt1x8IMF+hshu3R5CX+yiiRX40Sw3SsEZewQpZapWkXidTUiv0pirBlxXLaiDLN5uEp6XL5ojcdkQlDvRWOtyQ7Z9X7W0G6qUVh0GQLMrnl4mSS5aspDFOuHaXuA8PYVJzHkSPYPLaBwVvgbYJh1yJ5Zzh+UEfRXO1p2xpDg9xT6ux9/Zdg8nWH8qHMYDkK0AceTBoblIMYhV3diwgVQGtehvyoGkU9HdIdvPw9FVTMkWZlCyzZFpiHudJvk8dVO4m693Z6O3wExTxA7U9Y9xEzvDGuUquY6G6aMNKnCVSZ+bmf4EJRnoEtBMVO10qyjfatWFSX4TxSf320nds8b2594m0xbN6GAN/eknc0xHi6P+hDeg2FD8/BwsZysQCa6UQMbquDB2xHDJRUX+QCxZ0E6b0o+SyQ/cqbYrgfjEAb3mGcS4HnulbJTXK/tbK/CV60pMIcBe8NmV4Zp2fYinvH9tafVak0akgN7cvmu0GPs+MiwlTBweBVgH0DSYg9zp3iEdeyrP3NzWu4kjg5aAlZaUeA23/s39zCF03DdxCscxUsdSL0WbfRZVM5WEKAxiTVWeqwbdLsxzZ9byv+hMGqESoHbR2EZtuhwekRsMks38wfmWEkmm+qOlIYfsUHgcfLEQArSXQdXlaXLHeijpFg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(508600001)(71200400001)(53546011)(6506007)(122000001)(54906003)(8936002)(9686003)(26005)(316002)(86362001)(7696005)(110136005)(83380400001)(38100700002)(38070700005)(66446008)(4326008)(8676002)(64756008)(66556008)(66946007)(76116006)(66476007)(52536014)(2906002)(55016003)(6636002)(33656002)(5660300002)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QTAwVWpFZWxQNkpuOUp5QngybUpHaFNXTmdVWXlpSkFMeFdRQ21nZG9JY0Zn?=
 =?utf-8?B?a2N0UDQ1aTQyZll5NXhVNVBWY2QwUzNjZXN3NlphQW9WRFA3dGREVUZTTTFV?=
 =?utf-8?B?WjlYc0FVU085ZFNxckl3OFZJVkIya09RTW5JbE9JOWZxdis2bmdwYXY5bzBQ?=
 =?utf-8?B?NVowYjcxeFlCd2M2czZsbTVvYUlURDdnVDBleVdGVkkyVUFUc3FKc24yZkYw?=
 =?utf-8?B?UXNvaE9VNGNnc3VFemkzUUFvZWI0SU1VOFZOT0JpcWlnL1E2c3ZmRzdsY0N5?=
 =?utf-8?B?SVZKNUREd1FaQ0JnSFJ3b1RvcWlFSGVvQ2JsLzZDUGhyOHR1dEdsZGlNaE9s?=
 =?utf-8?B?L2ROQnFUa21RNW1rOFhxejN2Q2tuc2dERzZtSU5lRmVoc0NWdG41TlkxdE9q?=
 =?utf-8?B?YW5PZ0xPaXRaeHVLdW5rSno0SEVQclZjSjE3NkZyVXFIS3ZsdW1sSFY3ZXFl?=
 =?utf-8?B?anc2OHpGVEZPM2FsY0V1SHB1TFc4akd5Y3RFa3c5VGJrMWFGZklobkY4clU0?=
 =?utf-8?B?a2M0aU5qUjJySHp6aC9uTlQxcitkRk9Reks1NmpDNW5ielFnbGRFdTFSZC92?=
 =?utf-8?B?VmVDempwWUgzOW5VenE0azNMcnozS2I3aGtuYXFxb3pWUmIrMCsxakdNRlZ2?=
 =?utf-8?B?Z0ZTcW5lVEV4YUdwQ3RhdldxSmdKVUhmeExER3gvNW9HVG1DN0xzQUIyNDd3?=
 =?utf-8?B?S29wWnNycGxTc2VrK09vL1N5Z0w3WlNCSHZ6OHIyWmdJOW11TWdEdU9mMUtU?=
 =?utf-8?B?VzdqM0RrV0Nxa01waUh6R3c5QUFKTWJWSzNmcWdBMEtsSGtNSVpGd0JzYUhF?=
 =?utf-8?B?REgvVWlSSDZEd05XQ0U4WDBubE0yVHRPcGt1ZCt1cE02dmswUTR5Z1VmaklY?=
 =?utf-8?B?L1loZEdvMEovRlc3RTVyTnQ4a1cvMWxyTnhQSnE3S2lTMmpETTcwRWpHMVg4?=
 =?utf-8?B?ZVgvWWdVYUcyODJjazY3OGhod3VWYTlaTGY0eHMwS0FUdk1nM09TM3UrcEdC?=
 =?utf-8?B?ZE5pT3VjZ3BVYnBNVjhXSEtONlJwWFhPeGNJVTRYM0VBRC9BandJWWtOdGtq?=
 =?utf-8?B?TXMvVm0ydnE3d2lHYkdRa2VRRmN1eHgzWFRkSmZOT2QvaTBCaG5FQTZKSlNm?=
 =?utf-8?B?d0VDWS9IU2F1VW5NZ01tOVFIOHd3aEY1am5qeDVhL3Q5cTd1K0d6VmNubVNx?=
 =?utf-8?B?d3psRjBpem5VbTNINUtZUk5aZ2ZtUG82V0tldHI4M2l3OGhaREU5Qmk4NGVv?=
 =?utf-8?B?cXQ0N1RVc2NXR3J1bFVlTnBaaUp5d3F3NXZKQU1QcjdWTTRSbjV5d0lJMFZE?=
 =?utf-8?B?VXJLN1BMbmJKT1ZSMk5PbXlJd0d0djlaMVRKYXIvaHgycCtWTVJEdnY0eTRE?=
 =?utf-8?B?ckVHME84d05PYW5LQ1JFSHpKY0hoL0pSM2RCc2lKMkFEeExCVi9RLzYzSURK?=
 =?utf-8?B?S3pQdjkzMnFQb0dwT2c3eE5qaWxhclFpM0xBY3VYV0ZNRDEwM3VhWjZBb2ZG?=
 =?utf-8?B?eE9pOFJaR0RyWFV1Y2dlYjlEOUE2SWlxWDNOalplcUZJbkpoVVZDQ1B6M09Q?=
 =?utf-8?B?aytZWjkxNnFGMGxYVVpnRHBlYlFZcFlmZFhKeFJRRmF4UmduVFRLQmIyeXQw?=
 =?utf-8?B?b1dWMlM4Q1NydiswUkVVVUd6aTBxZkdtZVNubmhsa0ppMFhZSWFjS3BBUXJP?=
 =?utf-8?B?RnFvWE1HMEtxVmxqZStkYUE1SUhiaDRZRjF2alZSTm40d05sN2tyb3owVENT?=
 =?utf-8?B?TTQ4T0FVSytvUWludnQ2N25YZk1yZDM4Y2MvZjgxcmMyUWpYNW5rUnI4cVZE?=
 =?utf-8?B?NHE5cXR1aGN0Ylp5bHQ2R2oxaWN4Sjl4MGo3NHZzQTJGbElCQ2FnelpuenBR?=
 =?utf-8?B?VUs5WE0vRHJBWWFiZGJQYU9EVE1ZdUdxbko2cWdiNW9rQXNqQmpwSEUrNkdu?=
 =?utf-8?B?cE1GekE5Mnh1SWt5MFZwVDZTbGhaV01SS3ExaWhXemJDQjJ6VFFMQkRxZmpZ?=
 =?utf-8?B?OVErbjNLYkJyWnVsK283OHNKVVBFSExSRlhBUzlQSEJnb3IvYVV5K2JFUlF2?=
 =?utf-8?B?a3lqck5qN1J3bG9vRFVLUlhMVkdMeUI0eGNFWTFOdHlZWlAzVUZGNWllTFoz?=
 =?utf-8?B?Vkc4d1o2akcxWWNpNmR0Y25oQnZZMUVlMVU3QmFtSnB0TnpLSS93eHdnL3hZ?=
 =?utf-8?B?emRFUGVkaFkzd3dRZXJQc0pqdVZidDlCZ3k4MkR5MVdjbXUzNlhPWi9qWXl1?=
 =?utf-8?B?N2ZzSlJ1dElJLzMzR3htTDZUSXM2bG5SQW1VTi8xYitGU1ZpeDdyLzR3dUVv?=
 =?utf-8?Q?pRugN05kk4LHBJoeWs?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98a0b89e-aed3-4b53-c92f-08da3755794f
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 May 2022 16:02:27.2897
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tcum0ooKv0W0KpgF8oJCagpGco+g1K8dh3+EhUTJqRkspFgiS9ZJyyJNTOGubQg6DY/pxE3r18q1TyJ/cKjAsQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3439
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

W0FNRCBPZmZpY2lhbCBVc2UgT25seSAtIEdlbmVyYWxdDQoNCkhlbGxvIFBldGVyLA0KDQotLS0t
LU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KRnJvbTogUGV0ZXIgR29uZGEgPHBnb25kYUBnb29nbGUu
Y29tPiANClNlbnQ6IE1vbmRheSwgTWF5IDE2LCAyMDIyIDEwOjUzIEFNDQpUbzogQWxsZW4sIEpv
aG4gPEpvaG4uQWxsZW5AYW1kLmNvbT4NCkNjOiBIZXJiZXJ0IFh1IDxoZXJiZXJ0QGdvbmRvci5h
cGFuYS5vcmcuYXU+OyBMaW51eCBDcnlwdG8gTWFpbGluZyBMaXN0IDxsaW51eC1jcnlwdG9Admdl
ci5rZXJuZWwub3JnPjsgU2VhbiBDaHJpc3RvcGhlcnNvbiA8c2VhbmpjQGdvb2dsZS5jb20+OyBM
ZW5kYWNreSwgVGhvbWFzIDxUaG9tYXMuTGVuZGFja3lAYW1kLmNvbT47IEthbHJhLCBBc2hpc2gg
PEFzaGlzaC5LYWxyYUBhbWQuY29tPjsgTEtNTCA8bGludXgta2VybmVsQHZnZXIua2VybmVsLm9y
Zz47IEFuZHkgTmd1eWVuIDx0aGVmbG93QGdvb2dsZS5jb20+OyBEYXZpZCBSaWVudGplcyA8cmll
bnRqZXNAZ29vZ2xlLmNvbT47IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcNClN1YmplY3Q6IFJlOiBb
UEFUQ0ggdjJdIGNyeXB0bzogY2NwIC0gVXNlIGt6YWxsb2MgZm9yIHNldiBpb2N0bCBpbnRlcmZh
Y2VzIHRvIHByZXZlbnQga2VybmVsIG1lbW9yeSBsZWFrDQoNCk9uIE1vbiwgTWF5IDE2LCAyMDIy
IGF0IDg6NDYgQU0gSm9obiBBbGxlbiA8am9obi5hbGxlbkBhbWQuY29tPiB3cm90ZToNCj4NCj4g
Rm9yIHNvbWUgc2V2IGlvY3RsIGludGVyZmFjZXMsIGlucHV0IG1heSBiZSBwYXNzZWQgdGhhdCBp
cyBsZXNzIHRoYW4gDQo+IG9yIGVxdWFsIHRvIFNFVl9GV19CTE9CX01BWF9TSVpFLCBidXQgbGFy
Z2VyIHRoYW4gdGhlIGRhdGEgdGhhdCBQU1AgDQo+IGZpcm13YXJlIHJldHVybnMuIEluIHRoaXMg
Y2FzZSwga21hbGxvYyB3aWxsIGFsbG9jYXRlIG1lbW9yeSB0aGF0IGlzIA0KPiB0aGUgc2l6ZSBv
ZiB0aGUgaW5wdXQgcmF0aGVyIHRoYW4gdGhlIHNpemUgb2YgdGhlIGRhdGEuIFNpbmNlIFBTUCAN
Cj4gZmlybXdhcmUgZG9lc24ndCBmdWxseSBvdmVyd3JpdGUgdGhlIGJ1ZmZlciwgdGhlIHNldiBp
b2N0bCBpbnRlcmZhY2VzIA0KPiB3aXRoIHRoZSBpc3N1ZSBtYXkgcmV0dXJuIHVuaW5pdGlhbGl6
ZWQgc2xhYiBtZW1vcnkuDQo+DQo+IEN1cnJlbnRseSwgYWxsIG9mIHRoZSBpb2N0bCBpbnRlcmZh
Y2VzIGluIHRoZSBjY3AgZHJpdmVyIGFyZSBzYWZlLCBidXQgDQo+IHRvIHByZXZlbnQgZnV0dXJl
IHByb2JsZW1zLCBjaGFuZ2UgYWxsIGlvY3RsIGludGVyZmFjZXMgdGhhdCBhbGxvY2F0ZSANCj4g
bWVtb3J5IHdpdGgga21hbGxvYyB0byB1c2Uga3phbGxvYy4NCj4NCj4gRml4ZXM6IGU3OTkwMzU2
MDllMTUgKCJjcnlwdG86IGNjcDogSW1wbGVtZW50IFNFVl9QRUtfQ1NSIGlvY3RsIA0KPiBjb21t
YW5kIikNCj4gRml4ZXM6IDc2YTJiNTI0YTRiMWQgKCJjcnlwdG86IGNjcDogSW1wbGVtZW50IFNF
Vl9QREhfQ0VSVF9FWFBPUlQgDQo+IGlvY3RsIGNvbW1hbmQiKQ0KPiBGaXhlczogZDYxMTJlYTBj
YjM0NCAoImNyeXB0bzogY2NwIC0gaW50cm9kdWNlIFNFVl9HRVRfSUQyIGNvbW1hbmQiKQ0KPiBD
Yzogc3RhYmxlQHZnZXIua2VybmVsLm9yZw0KPiBSZXBvcnRlZC1ieTogQW5keSBOZ3V5ZW4gPHRo
ZWZsb3dAZ29vZ2xlLmNvbT4NCj4gU3VnZ2VzdGVkLWJ5OiBEYXZpZCBSaWVudGplcyA8cmllbnRq
ZXNAZ29vZ2xlLmNvbT4NCj4gU3VnZ2VzdGVkLWJ5OiBQZXRlciBHb25kYSA8cGdvbmRhQGdvb2ds
ZS5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IEpvaG4gQWxsZW4gPGpvaG4uYWxsZW5AYW1kLmNvbT4N
Cj4gLS0tDQo+IHYyOg0KPiAgIC0gQWRkIGZpeGVzIHRhZ3MgYW5kIENDIHN0YWJsZUB2Z2VyLmtl
cm5lbC5vcmcNCj4gLS0tDQoNCg0KPnN0YXRpYyBpbnQgc2V2X2lvY3RsX2RvX3BsYXRmb3JtX3N0
YXR1cyhzdHJ1Y3Qgc2V2X2lzc3VlX2NtZCAqYXJncCkgeyBzdHJ1Y3Qgc2V2X3VzZXJfZGF0YV9z
dGF0dXMgZGF0YTsgaW50IHJldDsNCg0KPnJldCA9IF9fc2V2X2RvX2NtZF9sb2NrZWQoU0VWX0NN
RF9QTEFURk9STV9TVEFUVVMsICZkYXRhLCAmYXJncC0+ZXJyb3IpOyBpZiAocmV0KSByZXR1cm4g
cmV0Ow0KDQo+aWYgKGNvcHlfdG9fdXNlcigodm9pZCBfX3VzZXIgKilhcmdwLT5kYXRhLCAmZGF0
YSwgc2l6ZW9mKGRhdGEpKSkgcmV0ID0gLUVGQVVMVDsNCg0KPnJldHVybiByZXQ7DQo+fQ0KDQo+
V291bGQgaXQgYmUgc2FmZXIgdG8gbWVtc2V0IEBkYXRhIGhlcmUgdG8gYWxsIHplcm9zIHRvbz8N
Cg0KSXQgd2lsbCBiZSwgYnV0IHRoaXMgY29tbWFuZC9mdW5jdGlvbiBpcyBzYWZlIGFzIGZpcm13
YXJlIHdpbGwgZmlsbCBpbiB0aGUgd2hvbGUgYnVmZmVyIGhlcmUgd2l0aCB0aGUgUExBVEZPUk0g
U1RBVFVTIGRhdGEgcmV0dW5lZCB0byB0aGUgdXNlci4NCg0KVGhhbmtzLA0KQXNoaXNoDQo=
