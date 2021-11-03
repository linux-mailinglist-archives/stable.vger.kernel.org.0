Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69BC64444A3
	for <lists+stable@lfdr.de>; Wed,  3 Nov 2021 16:25:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231577AbhKCP2T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Nov 2021 11:28:19 -0400
Received: from mail-dm3nam07on2100.outbound.protection.outlook.com ([40.107.95.100]:28128
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231651AbhKCP2S (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 3 Nov 2021 11:28:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IDAvwC0dcHZ6cEPOdgzH7+4v1zSs2QkiWiAna59GAY+indTF7665L6khvTZzVwOSx9qFXnRzNOsotqQFjfxx4Zwo0NFilOlh6ZxAfV8dipz0AWpF+FKCmUQzrvF7lKyy3jOLWb0nBM0D9KTtgQldGzPvNSUhxdTHKbsYLoLfTtGvuc6igWzsVnUhh0Nu1nCONkr+cvwIFT0GBJT3a/q0x0mRijbgeQ0XNKkT6KeVq4yzI8RvLS80it8hQQl6KzehYMRYwG1BsW59LA2eRb3ekqu5RsOvifibCd9SXubvTc6A3tw86l9nsxxIKfzINUNbI9JCkJapIfyR5gGAiBvp4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OvEtVCxcKHVPAP9ypRe3j08xANpjo0Srj1F+VJq98h8=;
 b=U7HNFeasueI853m59Ia4q6e/7OrkbBhq2m+B7ggAqWNbCnz6AGBoxn0AMF/0bKknqfZ78RtayRxy2xFOzpcOwE9Tv97Giwuambav5izwk6apNw4bDkUQ8zXzl3SvSQTvTdZWONfBrZBnOqH188TKde89g0UmQJMv9EK2mXeZOGroHHVYrHrgCwn4a5hydap/LMdPIwIKQOjdZwLXMP27KjQ/9rWx8w8aYX6g8Sn9aKyHAr4/CT1rybOKTphJUYZZDYJKY4d877gTNoOABffujFm1rkcazELMA/00YB6/Ov8y2cTw+l1LaYXPIt4Z8KwY0Wm+j33nRHkYiQYu5hzn2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cornelisnetworks.com; dmarc=pass action=none
 header.from=cornelisnetworks.com; dkim=pass header.d=cornelisnetworks.com;
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cornelisnetworks.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OvEtVCxcKHVPAP9ypRe3j08xANpjo0Srj1F+VJq98h8=;
 b=IZCAFmkuHMIC6hosYlltE1i8tbGhWMwFV3XRW5OSfMyQ39G7zJtU3VYAi2q4xrDPVxdQ7fNuNUjgfmN0EhTUyH83IvnFQ780ASZTVkUJaxnWoiwPUfEyvKvGZAcCq0LmEEhhrzJD2Yrkofl94/Lfy3OnPT5iQQHlg7zTFRWZ0IgLLJBJyxdINEYRSmNYmxeTadnBIwivFnMu9VMv0WB7ReW8s2277zzf3BDY4g1mulhKavT6Aami3v4+FOe1O9EKzxRlZzPkcfqeA2yGdafFSlz1ILTxtLPB8unbrSg7dVNxxa6541pGmr5NL4wxl7iC3emyd3f6zyqw2UK7gDimmA==
Received: from CH0PR01MB7153.prod.exchangelabs.com (2603:10b6:610:ea::7) by
 CH2PR01MB5927.prod.exchangelabs.com (2603:10b6:610:3e::30) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4649.15; Wed, 3 Nov 2021 15:25:39 +0000
Received: from CH0PR01MB7153.prod.exchangelabs.com
 ([fe80::bdea:4e22:1b89:24e0]) by CH0PR01MB7153.prod.exchangelabs.com
 ([fe80::bdea:4e22:1b89:24e0%7]) with mapi id 15.20.4649.019; Wed, 3 Nov 2021
 15:25:39 +0000
From:   "Marciniszyn, Mike" <mike.marciniszyn@cornelisnetworks.com>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "Dalessandro, Dennis" <dennis.dalessandro@cornelisnetworks.com>,
        "ivansprundel@ioactive.com" <ivansprundel@ioactive.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: FAILED: patch "[PATCH] IB/qib: Protect from buffer overflow in
 struct" failed to apply to 4.14-stable tree
Thread-Topic: FAILED: patch "[PATCH] IB/qib: Protect from buffer overflow in
 struct" failed to apply to 4.14-stable tree
Thread-Index: AQHXzY3GTwK0YivjsEWUaqYtzO9ye6vx8iog
Date:   Wed, 3 Nov 2021 15:25:39 +0000
Message-ID: <CH0PR01MB7153A85CF46D541FA76F1F95F28C9@CH0PR01MB7153.prod.exchangelabs.com>
References: <163559866445226@kroah.com>
In-Reply-To: <163559866445226@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=cornelisnetworks.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 90b7947c-e8fa-407d-c525-08d99ede315d
x-ms-traffictypediagnostic: CH2PR01MB5927:
x-microsoft-antispam-prvs: <CH2PR01MB5927D4886B8E77B710856EC1F28C9@CH2PR01MB5927.prod.exchangelabs.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GPBxuwckoVQ9s/uzzea3HhgZw3c9wkDH9xay8ZZXu/tDiIkDIbAbSbaP/iH5/2dXVO21E40vB62/oJAQJU8UaRh/8SxTHlvqNIEYv36pZxV0CPJwHX9axXNuNdvpo9Af2yqOHSB7NmKG5D/naQL31Nzq1ww8rwEAXAQHNyQpeifpbmOdLDdHjUExPyuL7dthTpmtvDBYxFQX00h14x/Ir+fbfbprJ/ZzCJDgsypHVYbQEKW1oxwbuAEntPljVOMbyv5zdq71n1BuFyMaL6eRGtkPJPcbmWcAzAh0TfNcRN1VQaQ2IuwWuDTaG/xVIDNw6WTxJA8UM5uNiJzqkpY8A3Qfh6rSadD315Du4JscopzzqTKDfMtECHqZ671SCLRyYG0bk72UGeqQCG8gluYFt+mLnWTKCMp6JQXmAOkoUfTYhmvOl4He5Yn83PrVuoQfjAcjRHUqmst5/jUtOPSK/bIl2eNKvV9OGtvMSW/VB7gtMceOgrMuawFukOwePPNToEZ1hTNO1CBig6QcHtkMHycU5NXdIE7adIvq2LAuXD0U0wJYiOh4rfbZdkrJOkQqHOwUsu1mPYeVA2bx/Nspe0enadlq22AdTbMUPG1XjCwWB5w15zwGGeXn3RVDfHw0AC+eevIekBRLyVo2nXfHcOjI0YkZfcDoenXR+k2JDGcM4Fl1Owz2Wz4IkZrFopk6PIMdGlF6JbiuDOY88uzJ7Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR01MB7153.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(346002)(39840400004)(136003)(376002)(508600001)(33656002)(5660300002)(38070700005)(52536014)(316002)(110136005)(71200400001)(66446008)(38100700002)(122000001)(8936002)(66946007)(55016002)(186003)(86362001)(9686003)(26005)(7696005)(4744005)(8676002)(66476007)(64756008)(53546011)(66556008)(6506007)(2906002)(76116006)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?JT3pA2ztwJBL5+2idKvTy/7S5VZqVMaRoPq1KLRNPNou55cOazwOe7cHLwl4?=
 =?us-ascii?Q?faYL6jdLqZ+7hSndO1Yj7eTSdF9o51gOWItiXvuefskf6fKCx9Ki+irPz6ys?=
 =?us-ascii?Q?MPqKRnox4dBBsitBMWYkTumNUQKXGcVam/5sRL1WIFDCJcA+IN81+n0zj8hR?=
 =?us-ascii?Q?tU5s9BHrXu0C5wTw3h6NhFXMHb7haqI59InJAf9v6TMSjzGl8WmfdPPnj6G9?=
 =?us-ascii?Q?W/39XNb80O2uzqaQ1vgEWIopdBEPv+C31AW8wKhIsySEcmBHBGACd6fU9r27?=
 =?us-ascii?Q?1Df6Q0KWJbrFx15HxsuZv/bdSZzOx1vWP4HRHxivRNfxfKUYVq+8dg2pTGq7?=
 =?us-ascii?Q?kOYJzDvDby0JlwM6C4a6Qg8y+eCVUT/cBNDhAYsVf9CkbRIRkU/Zj5F9Rdt9?=
 =?us-ascii?Q?MJdhjyYoQ7D4cAlVwgzsiOBVXXkvM/kMA4ebb0PfkonRDXODGRdUp3V5ccMA?=
 =?us-ascii?Q?ohzJlJCH3s6K//upXlDyTTD2LI02rpJuu749ZqS9KCpMC8euADJ9SMqtbcta?=
 =?us-ascii?Q?UrvUVGfuIGPI/NHXWenOyiViqjzBa29JgNIZDDubmcuOjzFqWbSikWHAuCg+?=
 =?us-ascii?Q?4HKYacBpHkmNmicKahNsrnCWmPivaH+8LuBZ41CihlIGAufRq8UkbyVgQ+53?=
 =?us-ascii?Q?+sK06Y2jbT2oStbA0A1dlKbDkkKt7biFkulwyZOjkKn8vxR0Lm+BHJDgtLnG?=
 =?us-ascii?Q?cByolHcTmPoc6UFJHfvBe1UIiJoR30lltUMAZzXtbjm7m+NYUCKHxUpkh4Ip?=
 =?us-ascii?Q?4RVQoJri7tylJzsO4BG7bt8dYkqxTbBI2KNbUO3U8rjZ5kydVk3UmZJS7Xn8?=
 =?us-ascii?Q?F2iiAgcNfWjYwVnER5lshgsljjM6zTtSrHGRvz//3llm+buKVMqn7tvkOmmD?=
 =?us-ascii?Q?v9NC1TnsnjZQ4vB/Oxh5KWR/L8TuIavvKGG2KJ/h/4ZbUQ8R4pHlyolG9Br7?=
 =?us-ascii?Q?Sf6JpqnO5SIZ/ulH68P2Pfb8rdXg6xv8xYk4fdU9nIIGWKPgGpqMyYMbQ9fQ?=
 =?us-ascii?Q?HfZvqpI88vPrtrcetkl/tKbYbdX/DmwmxQnSP7dtPiBQxDuNw6P+f0Kr5USp?=
 =?us-ascii?Q?tP1d/EGb1cY7Ry9yB2+QLAAoBImuI8sOUppY2J8u9f36ltxG9K52TC1mkQrX?=
 =?us-ascii?Q?fngAcK8MpeMgNc0/VLPwDTn/UMWmtgIZhJzBqjjSINk3iMoDaupGxCWE0ydF?=
 =?us-ascii?Q?p833vh8OntCbaHoheV01U6FBukgZ8NZCOVEhFhnOF7VNTjFfSM6z/gXMCUmJ?=
 =?us-ascii?Q?/BKmTcyPOOVhsEkHAu5V3lgFOz7rxWUYqBUBbcjeGROWxH6U6J+y0wHx6tZP?=
 =?us-ascii?Q?lG8kjHBST/57BGGbSI7ui2oisQLZsK3AGTsVdx4Adw53eIcYahyVJN3GfxNo?=
 =?us-ascii?Q?4dJ+blCQKKBXCvE1laeSppT0QVwbFOu/Evx2b9WyHQHcyKg8t8m/CIOvmge8?=
 =?us-ascii?Q?Maq1NjytdPD2rKUIJx3r1wTl1upvwh0U72izsaEbeFRNV+CRu8aSyxCTemyr?=
 =?us-ascii?Q?8wrlufCjTP5B8WpMF/lVRuvK37hQYm0YuB7XGme26+1nSmd8PttnJXV3Mp/O?=
 =?us-ascii?Q?syq9cVhw73Z4eVAEOo+K7gc6QQ0MqY1MK5i1UcD5LRUVo5UefY73abqKyy+T?=
 =?us-ascii?Q?kTn4gIg8O3Tgju4aj60tmwfxQUO6DRYR+g5Ip4CHZEnXjKrkaBjQt3jOuh7l?=
 =?us-ascii?Q?4nCslRxr1prC8lylj1doa+lesxzwiLEKSSMXd3f9a/RI2Mq1?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cornelisnetworks.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH0PR01MB7153.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 90b7947c-e8fa-407d-c525-08d99ede315d
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Nov 2021 15:25:39.6439
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4dbdb7da-74ee-4b45-8747-ef5ce5ebe68a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hY8yNCOR3jpRR6TeMY+WGqZyLLloXqlP8eM409TSu4wXm2MEyNCfm2gGUYSV0q4G+HmGaM4S//Tz0Oe9PVKyGzsnly+j1KJNcwW+wbJbIDSxz0j5u1lwp8yH+OuWMyBC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR01MB5927
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> From: gregkh@linuxfoundation.org <gregkh@linuxfoundation.org>
> Sent: Saturday, October 30, 2021 8:58 AM
> To: Marciniszyn, Mike <mike.marciniszyn@cornelisnetworks.com>;
> Dalessandro, Dennis <dennis.dalessandro@cornelisnetworks.com>;
> ivansprundel@ioactive.com; jgg@nvidia.com
> Cc: stable@vger.kernel.org
> Subject: FAILED: patch "[PATCH] IB/qib: Protect from buffer overflow in
> struct" failed to apply to 4.14-stable tree
>=20
>=20
> The patch below does not apply to the 4.14-stable tree.
> If someone wants it applied there, or to any other stable or longterm tre=
e,
> then please email the backport, including the original git commit id to
> <stable@vger.kernel.org>.
>=20
> thanks,
>=20
> greg k-h
>=20

This patch requires a backport of upstream commit:

829ca44ecf60 ("IB/qib: Use struct_size() helper")

That commit needs to me modified to include linux/overflow.h.

The overflow patch then picks clean after that modified patch is present.

How do you want to see that expressed in patches?

Mike
