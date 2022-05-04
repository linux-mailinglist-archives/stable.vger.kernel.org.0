Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76E2C519816
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 09:26:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345378AbiEDH3r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 03:29:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345349AbiEDH3k (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 03:29:40 -0400
Received: from FRA01-MR2-obe.outbound.protection.outlook.com (mail-eopbgr90088.outbound.protection.outlook.com [40.107.9.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80DA222BCB;
        Wed,  4 May 2022 00:26:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c7AJYDspqKw95AWCHq5Fo4EOjL/T1blPWbHS1G6qVhFGfuN0Qm/NyNG10o0tB69Z/nEyClnsq8U4uZXdIoP2EeP2GvHeATssp/ZSTzLjCl5Ul5vpqsa8ICVczjHuumo59dDLjHE9SXteV4bgWPMKZxhu4If+76PqGLq66VfMNaeQAGz+kFlmxSm0a5WyCP/kc060RY/mKe11bHTy7SNFZA6L1Gd0TEWjoyiBpNNmmuRJw96k/lrJ/ZmAggtkuwr9r//3n0a0wXUfmq3duvXCiU/Y60M4n1Q32rmiKGbBcAt+eTyf9U/T72FFFPdX+ykOBoxWaBnJth78xg9RMDkHpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5IG51IY4o071yQs2/aOOfLevjVzGJKFlKcFCS9DvctE=;
 b=bCj0NYYDtdU/YBMuJSymHMBAuxJb+wWMfGO9xMbM9cFeXhAr7ZovBQB4VI3G6N7K+XoJZ5jzkConVf6S1wHnvt9G1PeabLQEJgRYXpObirxftwzVVq/YNhuwWidD70OxpFP35glzQsSQ/KfhgnKICtRqm5lg/jO2rD5LRIAxI6U8bJ+0LV8KLy2dzWuOTchS6tuIXP1KgrzwrEnHQ078iRkiQYngUFPDcP2zzlnTCqZLNy1T9U77QaR5tg3JHFe/EbiTCzI8V1TbbwXHbzBfUTL/AoMiazryCIzQBkI+tjf62M4JxIrtVp1tFW3r+HUQ81zZvY7CDeHy7eGtTqfSdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=csgroup.eu; dmarc=pass action=none header.from=csgroup.eu;
 dkim=pass header.d=csgroup.eu; arc=none
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:31::15)
 by PR0P264MB4154.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:25d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.13; Wed, 4 May
 2022 07:26:00 +0000
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::d572:ae3f:9e0c:3c6]) by MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::d572:ae3f:9e0c:3c6%7]) with mapi id 15.20.5206.025; Wed, 4 May 2022
 07:26:00 +0000
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Steve Capper <steve.capper@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] [Rebased for 5.4] mm, hugetlb: allow for "high" userspace
 addresses
Thread-Topic: [PATCH] [Rebased for 5.4] mm, hugetlb: allow for "high"
 userspace addresses
Thread-Index: AQHYXuv4lZxY20xjWUWOGxalddzvYa0NKu2AgAEnowA=
Date:   Wed, 4 May 2022 07:26:00 +0000
Message-ID: <9853ade6-3f32-7811-474e-2da2361af16c@csgroup.eu>
References: <9367809ff3091ff451f9ab6fc029cef553c758fa.1651581958.git.christophe.leroy@csgroup.eu>
 <YnEyiYh/NIFJG16V@kroah.com>
In-Reply-To: <YnEyiYh/NIFJG16V@kroah.com>
Accept-Language: fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=csgroup.eu;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2929fc2f-80a5-47c7-1695-08da2d9f56c5
x-ms-traffictypediagnostic: PR0P264MB4154:EE_
x-microsoft-antispam-prvs: <PR0P264MB4154093C86D422C43AA06CAAEDC39@PR0P264MB4154.FRAP264.PROD.OUTLOOK.COM>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: s/0g1WvdY1r62MwLV0yCRB20xDluu19pSWS8k3Wtf0LqKbHU901skQz+MHLeYDM4rx/SiOqN0PZ14AkyE4PCSLENyZHuO4rkr9193sLblRILradffSl60Pc6buwJIUW45O2ld/HKh9wAug7GYIAUeB73SKEW57U+2KYZ0Ck6bekUCzz24iWJyeIoX+dFrsMaP7AbXukSC2o6f3v+n8W7FfVJHWzZUZ+++/ZZKSDR3jPcSZVHTRVkjfg30O0aXMjdRKYDNURM5Dy+KqCZXj+xgVIJJLsdsRZJC1aY5IM0XSlN8/BzsgIlCXJTNMesq1zuvsDZlinRwO2/AhXnKpPc62Lzq7IIZ6pVNy7Y+FIz0g0zPybV2723h59+yCvNOVVWhpAN0/8TRJaDjvnD78VvBHBS80h3OPb7frC/zc1TzmQEGjfAqmdcwqCUoGNJbBJAWydWlfPFHUbCFyLqdscHjdcO7BH/5vq42LrBTcoP66oC417WNfKtUPJZN61Pi2J33jZ1jJ8tJqD42D/3c2j7PDVb1LrjXCltbMnW96q5WRIrsKnWmznKxF1KAckPjbiM2Hgci1e3+eUbK37Na4xFZI6Uj+cXIG4qW4TbFR6rrLFqxb8X5C9rADrRwHSU1byG+ZgK0L2poO2UxNQWM5UQw6AoyR0Bo8w78cWtHJSs8DPZgQpI+vhoB9yJVef5JMaGeAnDrZXNcFjiHHMor9G2782w6TB3HysvJozs26XJgbKgd2JO+4hcibAodT+EBUZ0blLsZ/lvx+BCVLIdI5/Xkw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(76116006)(66556008)(71200400001)(8676002)(66476007)(66446008)(4326008)(122000001)(6512007)(66946007)(26005)(86362001)(83380400001)(44832011)(31696002)(6486002)(2906002)(508600001)(4744005)(38070700005)(8936002)(64756008)(2616005)(316002)(186003)(5660300002)(38100700002)(31686004)(36756003)(6916009)(66574015)(54906003)(91956017)(6506007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MkJUV05VSllkZitBYVFkOENoYjc3RDI3bU5OUzVRMHY1enFkK0d4YXpQVlBZ?=
 =?utf-8?B?MHVEZEppZTFJelhYbCtYSUI1N0RxYUNsUWRHQmxneGI5WXBXN2ZQcHNSL0tq?=
 =?utf-8?B?NjdmUG9qRlhWTjVqUGtnQVN0VllSMlNqZzVIY0pDS0NtMWkybkhRTk9VSVZn?=
 =?utf-8?B?bW5HRDY4dlV5aUpJZUdXbFJyUnlNdHRiUDg3Y21QVC9NZ3pRS3FIUGd0S3RC?=
 =?utf-8?B?V3RXTGNOZEF0WThpSnlNUXV4T3pkd0RCSUN4QjlLQWNKUEk0cWhTbmVVSmI3?=
 =?utf-8?B?eE9VR1lTam1za09FNnM4RnIzMlRxYmR2VDk1WnM3OFMza1dOYzdCZjNLdTlD?=
 =?utf-8?B?bXNubzF1blZJaDRGWDlpMCtXUzdPOHlHL2ZENmRMMDNCY0Q3R0J0NStYMkd2?=
 =?utf-8?B?ZUF0VEwwVytkZ0RYWTFVc2dTZDl5SFNEUVBoSGFwU2NXKzdFSW9KK3J6VFNo?=
 =?utf-8?B?ZW14NmNsTStDV1BYVlZZMEpBcHMwTFg5WExieEtNMlAvYWRWNUR1TVRnYUk2?=
 =?utf-8?B?ajRBWEFlKzdiWENrRHlWMzdnQ1lJOXZxUk93c0pWTE9yNG11eXRQZmJKU3or?=
 =?utf-8?B?cmhEZnQ2eGZ3TVNXZXR1aHh4OTR5NUNrVXNHNlh3Z21mR2o5b1VoQTFOTHdt?=
 =?utf-8?B?UkdVVER4U0dXNFZ5MUYwZG5Lelo2QTlnTnpLV0RSZ2FPYmVoSXdoQ3A3cmpn?=
 =?utf-8?B?OGphSFdnUUQvQXMxSG1HS0FCVkEvZjcwN1BBc21Yby9VMXhkSk9BMFZQeDVJ?=
 =?utf-8?B?Uld2cXp2SGNyZnJkdzZwOFhpQmFDTjBzSGVkS2VEbVByUE4zRTZSRjdQdEdR?=
 =?utf-8?B?OW5yTWtlNUhtdStKVVB1b1FjR0h5Y1ZyUGdZdHlkVUdmaUh0aCtpdkZxNXdD?=
 =?utf-8?B?SUs2aUZvYUNOWXROWmxRVW5RYmRpenk2aVNLQ2sxQjZzUXNUMUpIUXluZUZy?=
 =?utf-8?B?b2ZUMXNoa1puMEVLc2xmUG9WVmtUK3F4UXJ4YjljOS9UeEFMV2psaUNBWVB6?=
 =?utf-8?B?bEROTExPRHpxblI5bE80Kzl6YTN2UjlnUG1FckxSNDhIVkxJR0R4cFBocUdM?=
 =?utf-8?B?NGV5aGpzR2hocVo0QzFSNTVIQzZNditHalR4MzJUZmIyL3RhUVh0MDA0UWZQ?=
 =?utf-8?B?enRXVnk1bC82ZU52U3g0UWN6NGNJQWtSK0NpRGczTWxteWsrUExCeGpaOUxp?=
 =?utf-8?B?L2c5Z1lNOFEzNlhzbVBqYVpxdXJYMUo3KzBHRVZnc0s1MUxDcTVMZnVUYTRG?=
 =?utf-8?B?Q3BrRjNUT0luUFVBRWZLMktDWWRqdlNEK2pOZktzQUxYMWpCOXVqMHN1eFBS?=
 =?utf-8?B?UmpNZDhnVHlVR0d1S0x1Yko1VWtxc0RQanM5YUZuTFVYd1BqUC9wV2YySnBC?=
 =?utf-8?B?R2pOUWRsS3FoamtXc3phSFdUVmc5VHdtLzl6NmdrNUxTVjhtZ0NCSjJIVG5w?=
 =?utf-8?B?c2pPVVJMc3MzZlR6ZUtwdEpqUWo5NENKNktNcnc4Z0Qva1hVWnQvUzcvTVpv?=
 =?utf-8?B?WUlJRERJcWhDT3VvWUNuTWR2by9DaVpZZHdnUm5WVUxySHh3UEdLZ1J5dG5l?=
 =?utf-8?B?LzdQUHZFZlRaNC8zVFhDM2JTNkc2dmh3ellSUkNHNStiZGNySFZ0Z1pleTVK?=
 =?utf-8?B?ZkJkcFNPNHJhSmF1dmFmN3BVMnpOdXdnY012K0I1M1dpTlJkMjlUZHNoRlRy?=
 =?utf-8?B?QWdGMUNiSEV1bUtoeFlsa25hdk9QRVpPbDFMSXNYMXdWWkhOQmVDTno4UUl3?=
 =?utf-8?B?ajc0eWdlT2QzVXZQcEU4cnZYRUxLQXQyK0RzVjN4WEFLTGs5RU9VYVptQmE4?=
 =?utf-8?B?S0hHWHBJK3RwNUhwODJ5Z2hZN3FhVnZYVFpGOWlZRUtZckxJTG1MMHcvMldI?=
 =?utf-8?B?OGNGLzFsZGRWVHVHYjVNY1JkN1YvS1M0Y3ViUGlic3VNR1BHaUp4NDFGQ1lH?=
 =?utf-8?B?aTYxYXB4SEZmNXpuckFVblRUeldSWGdMcnd4dEE1SUNrR2pOK0kvNXdwMmJ2?=
 =?utf-8?B?VHN2aDhwT3A0RmtNa0Vqei9PSldFTndRZGlmZ3FEM2YrRHFhOUlmdDBEMTY5?=
 =?utf-8?B?Ylk4UW53OEFtMUlkOURpRnY0YWlMbEZpUVUrd0tQZkRoU3FsQU9jdGNFc0FX?=
 =?utf-8?B?RTNTc1pOdXBZNHZtSElHU0lPaHhMSXd3NFgrTkFmcjZCWmF0RWJudjM1RGl0?=
 =?utf-8?B?THpLc3QyM0dyOWMwOFEwMFREMkFva1dJMnc2a2ZpTmk2bEVRa25WUnFiY2ho?=
 =?utf-8?B?M0V5Rm04QWtBVDdvbnVEUjBtTTNPMnJrdEJGTUQvamZiNW4vZUtqbVIyc0Vp?=
 =?utf-8?B?U2ZDMCswRHF5MVo2b3J2VGhyWnBLMWNQaUZTaG5PcTB5ZHZCa0tSbkY3bHlo?=
 =?utf-8?Q?l0xX4mVwkoPG2+StKudRx8YmNABE2thq7sQsc?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E80044065E01E64298126536E2D11E9E@FRAP264.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: csgroup.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 2929fc2f-80a5-47c7-1695-08da2d9f56c5
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 May 2022 07:26:00.4684
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9914def7-b676-4fda-8815-5d49fb3b45c8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: v39laNjfcGKHWRLRQt2vYVw7x/EL5lILBXShYYuUwh+pV8dg39mpL6vBtVhefffrFtVPDeNmKEXAZBJ+X0sbxVr4VN4gDSR8qFPmmIjQsCU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR0P264MB4154
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DQoNCkxlIDAzLzA1LzIwMjIgw6AgMTU6NDcsIEdyZWcgS0ggYSDDqWNyaXTCoDoNCj4gT24gVHVl
LCBNYXkgMDMsIDIwMjIgYXQgMDI6NDc6MTFQTSArMDIwMCwgQ2hyaXN0b3BoZSBMZXJveSB3cm90
ZToNCj4+IFRoaXMgaXMgYmFja3BvcnQgZm9yIGxpbnV4IDUuNA0KPj4NCj4+IGNvbW1pdCA1ZjI0
ZDVhNTc5ZDFlYWNlNzlkNTA1YjE0ODgwOGE4NTBiNDE3ZDRjIHVwc3RyZWFtLg0KPiANCj4gTm93
IHF1ZXVlZCB1cCwgdGhhbmtzLg0KPiANCg0KTG9va3MgbGlrZSB0aGUgcm9ib3QgaGFzIGZvdW5k
IGEgYnVpbGQgZmFpbHVyZSwgZHVlIHRvIG1pc3NpbmcgI2luY2x1ZGUgDQo8bGludXgvc2NoZWQv
bW0uaD4NCg0KSG93ZXZlciwgbG9va2luZyBpbnRvIGl0IGluIG1vcmUgZGV0YWlscywgSSB0aGlu
ayAgd2Ugc2hvdWxkIGp1c3QgYXBwbHkgDQp0aGUgdHdvIGZvbGxvd2luZyBjb21taXRzIHVubW9k
aWZpZWQgaW5zdGVhZCBvZiBtb2RpZnlpbmcgdGhlIG9yaWdpbmFsIA0KY29tbWl0Og0KDQo4ODU5
MDI1MzE1ODYgKCJodWdldGxiZnM6IGdldCB1bm1hcHBlZCBhcmVhIGJlbG93IFRBU0tfVU5NQVBQ
RURfQkFTRSBmb3IgDQpodWdldGxiZnMiKQ0KNWYyNGQ1YTU3OWQxICgibW0sIGh1Z2V0bGI6IGFs
bG93IGZvciAiaGlnaCIgdXNlcnNwYWNlIGFkZHJlc3NlcyIpDQoNClRoYW5rcw0KQ2hyaXN0b3Bo
ZQ==
