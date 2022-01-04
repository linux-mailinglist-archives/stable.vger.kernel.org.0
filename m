Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F81C484368
	for <lists+stable@lfdr.de>; Tue,  4 Jan 2022 15:31:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231777AbiADObj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jan 2022 09:31:39 -0500
Received: from mail-bn7nam10on2124.outbound.protection.outlook.com ([40.107.92.124]:20469
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234221AbiADObi (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 4 Jan 2022 09:31:38 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=irxC/nizxahmITdWL2puYWynWBAR5I1jQ6TmdBRlpGviTZCdh7eZq9wMQTcFqSfhgwwEv5jX79Exb5wSk4PyE+voUBDiwl2EThURrTnhfkpgNPwoL5LhiBZbyYZnBK4hsRPkJxRsZ2++5hlKDUIOKvLtaimpGdvL7KOu4ddOSTHZ9jYMTYNe958U1Pr8RL9JE8JoiKQsqNx7hJSCdOhVeaIdlRp4XiIV15+4dqNpyC4wlyyj8UEGOyeQZKenqRZtCo7HXiz6n+SZia/DZpbUOmCmmHQPmYOZnuUuh0kZVz2NmaBLfvTyONJJbPLP/zQek3eVf0vlkO0EolbNxbZ7Pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OKtqMZ0MCWVonSnuIGh4M42Zf0XuQCa1H3qkX2UtbYc=;
 b=GClGNxUys2zkDmGsnslXbuIqE9lrVyFlyJEPJ+5FwGzLenfGYZ/pGnXowoYSFa1fMw7Nr6myxk/2WFJFmK19wdqKINlBqhPFTOwYMOjzvoqyBNyGK5sVlQxuyPJpvlviG9AukHu3kN/C8U2L1NK9WL+CU+gat9/RWXgbe3NEYlUqkzxqAMLKGAFBkYqtswJIE4SqbKbGyGxDs5uuMYnEPR+cYiKa5AYF6afJCzfL+XbTjSXV5jwEaNnC3o3UeLhm0loY1GFSKgaFk2gGtyzNYweFZVY9Pv/KiI/6MUvU/vnb+fZqyhvp5BT8V2kSxAHRtg7D4KAJpv9zb9edgbmg/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cornelisnetworks.com; dmarc=pass action=none
 header.from=cornelisnetworks.com; dkim=pass header.d=cornelisnetworks.com;
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cornelisnetworks.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OKtqMZ0MCWVonSnuIGh4M42Zf0XuQCa1H3qkX2UtbYc=;
 b=k36oImPy7xLwdR78A/GOmSG41BJc1MHijqCO5TKNTGlpCJRz2WOZD0cSIeu59haOniwsp9CUKIYQUWLVGMYWanQTS0qUSrg7cwdxqsAVxww1UYree1scl7/RAwc/Hctes1o4PdOrN5ieNK+KvbbXW762xImH+mq4Cy+PlF4KwZKDooQeTG0a7Czw8Mmng/XsqJOk8b6a6lpEiYVYukwcItYex211XYOYGDOxFZGl2BCo2SZuoJGWvp2I3Upj0x2IB0XulJA+q82jw7b2znPQkOJPas4dCvUb1zt8sfGOkph+YZ4H5qJYy5kxIr81PMo6HHONtDGvVX4aLehJzgVjWw==
Received: from CH0PR01MB7153.prod.exchangelabs.com (2603:10b6:610:ea::7) by
 CH2PR01MB6021.prod.exchangelabs.com (2603:10b6:610:45::32) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4844.15; Tue, 4 Jan 2022 14:31:34 +0000
Received: from CH0PR01MB7153.prod.exchangelabs.com
 ([fe80::839:2232:58d4:f6d9]) by CH0PR01MB7153.prod.exchangelabs.com
 ([fe80::839:2232:58d4:f6d9%5]) with mapi id 15.20.4844.016; Tue, 4 Jan 2022
 14:31:34 +0000
From:   "Marciniszyn, Mike" <mike.marciniszyn@cornelisnetworks.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        "Dalessandro, Dennis" <dennis.dalessandro@cornelisnetworks.com>
CC:     "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH for-rc] IB/hfi1: Insure preempt is held across
 smp_processor_id
Thread-Topic: [PATCH for-rc] IB/hfi1: Insure preempt is held across
 smp_processor_id
Thread-Index: AQHX8CtbRhBLaSDcVkOARSwjdsfN3axTDv4AgAAAGXA=
Date:   Tue, 4 Jan 2022 14:31:34 +0000
Message-ID: <CH0PR01MB715361213D9E83AE4EB47041F24A9@CH0PR01MB7153.prod.exchangelabs.com>
References: <20211213141119.177982.15684.stgit@awfm-01.cornelisnetworks.com>
 <20220104143048.GA2678196@nvidia.com>
In-Reply-To: <20220104143048.GA2678196@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=cornelisnetworks.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9f43c0dc-e293-4f65-5983-08d9cf8ee8b9
x-ms-traffictypediagnostic: CH2PR01MB6021:EE_
x-microsoft-antispam-prvs: <CH2PR01MB6021398D4764D954B770B0BDF24A9@CH2PR01MB6021.prod.exchangelabs.com>
x-ms-oob-tlc-oobclassifiers: OLM:862;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 380VRGgKMdXb8+cSGIVSzizBPvZdaS/o6kFkP3qBgABltUkDVvx1lrgjAFC+xHctmiW4W0saUKTcpmO/bT8g2I37ffZM6qh5GXX1fBHlLqiLaS2kkqEReVFJOv79gBKQPURkjr4x//JEQkr/VKxqb7cu54qo2Q/WWEQ6gncIEtSTGgrf741DwMYjZzrSSbdd8WPXaJTimSplvPigcVyikv+vEA38tooVWnmzdGZ+NxR79MyChRbsekzToV9ZdBTMfKDow0P0XxyQhBh3PcSlPfyNgfV+bKo4JOXSnzRWi6ATJ1m8EOS/jU2Ydc7zQE9Rdg4Crhm4aOWVLJWiFxcdUdj0Fl77cThsU+ioNaKYV+t9EPkEcjzMHjuAih/mLkWxeLCLnepLnde2u+8Dwd7p8cYECjz1U9DC9w++Cnl7+Gs9vQELrDQLEFiEAHYnzFwYKKCUs3HsHecPruMsokD9whfkZJgFh7FKDtADvtBDsIG6DHP80a0iX+z9l9gnznQIAoMwHjR8Yhz25w/w92VRTbkMOHUIJOEDOxrEZajei7eAGChXKBt+4lRwALFRXbQMyFiYO2K+NPObeM6fpsuJ5CEmlLfYnNF4rLVTPcbUEOGm8a0dSZjjzegpcEi42tnDxZlmQ10T0/+KCLSp2nPCiDZnvmTfHfsznbPbTArazphoC8QnkizmVjqe7xZkq+cg6Phm8fqm9kaNzfOpssvwo5NVVWpIl0mJBJUKCsstGgi6V+aDpjF4Yi7foFShU8DaobObH+06bhS3DMSPtaxw+lqUxA5bZYAE4pOhaJqoGnk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR01MB7153.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(346002)(376002)(39830400003)(136003)(966005)(6506007)(71200400001)(9686003)(508600001)(8676002)(26005)(7696005)(38070700005)(6636002)(4326008)(64756008)(55016003)(8936002)(54906003)(5660300002)(52536014)(66946007)(33656002)(86362001)(76116006)(66556008)(122000001)(316002)(38100700002)(66446008)(186003)(4744005)(83380400001)(110136005)(66476007)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?KTqO2RGTy591LSvz/a8iHNTAC18jQTjijkecEW8mW1G6acF10n2MWB42RZfh?=
 =?us-ascii?Q?K2j9ohf9IJfxdDIQvvHH+3/CTs1d1DwlvHHciQxgNsLCKkUcuHwDpsVe8k+p?=
 =?us-ascii?Q?hz8milUqH0eAS1qQZ4UGbfK1wlHHWQaIsb3fO6VludJOGbP6qjfTC6Dt2uve?=
 =?us-ascii?Q?+wkLnb3aSrHV6RtSMvQCd6VCsboJy0V11v5klcjyK2/W/OFLmTKAqwriKcDa?=
 =?us-ascii?Q?n6aQ5dOxi6XtR/WOsbKMADiSPkyJb55hDS5DfV/PzAj5RoqIeb9nwjTS1z9W?=
 =?us-ascii?Q?y92YAbVUIYXvgWREbCTQW5o3dOphlTbl9PeietdBwqtIC0ujaxs54OZcx+iV?=
 =?us-ascii?Q?sORJqPtfMH2cYqGl80OAcC8+2MzUUYwpmY6vzIcIWw6nYOqjg6k9LnM7uQhI?=
 =?us-ascii?Q?NzWUW4IKh4gLt7tMe2I5NuqYZfcDOFssTGPshxteI17VoT1G8LN82wQbFF/G?=
 =?us-ascii?Q?gXoEiP4UGC0gH8+c6Zm/b9tuvqgMlGKM61WwEwICmOIwqBPPmlPjSCiQ6j/0?=
 =?us-ascii?Q?MMyDC857tzRFuWfcuLNxK3VKupk8BnYVHuv8qiywCfWfNZyDMiMXEc+x1U7j?=
 =?us-ascii?Q?ZiRgir6RpFaXNKc/BTSw9y1WtMSyaankorHAGMZRjmH8QtSrNwPtV6iNEq8y?=
 =?us-ascii?Q?RNxmyUHMo0fnV6SmxuafohT+EXH4wt6CcCsD0B4niQ86uF7wpbNHt37AjZc5?=
 =?us-ascii?Q?yx3JK3zu+WW5VAik13NW97xH8IKU8SO0iXeFgV4sMgHTx+57+vCF4Q+nFWXb?=
 =?us-ascii?Q?IfPcFpyyfcoXG6RKwnech0wQLduYyWv5DVb2nzpUD0FxJtoelHR6VGI8DqeR?=
 =?us-ascii?Q?eWwzedNMuSfxFhrAwQEI1pQmsNSkhk/X9QI/TnYx6EeZkV+GD/X3orAyOL4C?=
 =?us-ascii?Q?qtZW57WFBZfd0F8aKmQAhRRUUP/DHbcGDQYZi/cqaJKKB4iUnuNlwzddcV+R?=
 =?us-ascii?Q?EEgZJQgQuwF2JQOSoszlrO4KO59bCX/5ojgHWviIEY+Og7dcL8eoW/n27YV+?=
 =?us-ascii?Q?SatK3y1pYuKpMyCX2l9kUiCwONONwNpkmGD5M0mQNsE5XdX/W+65QsdHoXBM?=
 =?us-ascii?Q?Sbhxz4YliJK4hkxORuLgCgGGzt8PVo5U5j/BGxFOv0VRKKucGOWLkgXJO7QI?=
 =?us-ascii?Q?MB5ZEyuR6rw3rgshrmEfwq3KhsQcQ1GIShRvl/uiSqX93C6m7yH+MiubAAuO?=
 =?us-ascii?Q?bfXgYhffyIEYEea+ncZPKOE0oSbgs7Niubr52Z0hVcjvTvwhsaea/FP9NFFd?=
 =?us-ascii?Q?6aM9K+T2csCPd69Tyi5WOqBGLbnV89FcJHf5Ye7W48WqZdi7GIfa4NavCWlb?=
 =?us-ascii?Q?DyN2or4xCx5qdwmT+doIRurIeIOSWcrDqSVpNA7i8Sqt3tuet/UF+NR/z6WH?=
 =?us-ascii?Q?U9GrGo8CbTi/63zhbXmkeOzOQWnZ/k8ueOeqL+IU2wvN4ki9IdBVUV/ox1dY?=
 =?us-ascii?Q?f+5acu/9bvTyxc657zP3SMo+KyoNhMUdcqawOqBb+tVERRsecYOqidvPcxhX?=
 =?us-ascii?Q?ytN9itAwth7b0/hE/ucBH+qAoxuIRB5wo0W67dEpwyyTam++CVpRp5tKvNyE?=
 =?us-ascii?Q?8iMAfQUNHcRXlE219AMcpzT8l2y/QDRh9zF6YAWkR4vgC7NWes2bu2uY8NvF?=
 =?us-ascii?Q?Ea/xhy6Yn9fufWb11oGNH7y+i6rTDxFOYoTSDwejMZsju5LsBwDRddhBvcLA?=
 =?us-ascii?Q?tvsMwikcDIMOXuUr7SgbcGZXsAMxEnM4mXJK907n68AAuN2m?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cornelisnetworks.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH0PR01MB7153.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f43c0dc-e293-4f65-5983-08d9cf8ee8b9
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jan 2022 14:31:34.5308
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4dbdb7da-74ee-4b45-8747-ef5ce5ebe68a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zgH/Nwpu3al2ZphuudqSmNWsrBQyjPRRizuRX4la8Exi81vXYnyBuGfvvk334LWmU09/c9X6aH3o/itd0Jqm+4QI1Phos3mS4JwcE0BlSY/RArpsu9yZjKaOFvcFk80A
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR01MB6021
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

>=20
> On Mon, Dec 13, 2021 at 09:11:19AM -0500, Dennis Dalessandro wrote:
> > From: Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>
> >
> > Despite the patch noted below, the warning still happens with certain
> > kernel configs.
> >
> > It appears that either check_preemption_disabled() is inconsistent
> > with with debug_rcu_read_lock() or the patch incorrectly assumes that
> > an RCU critical section will prevent the current cpu from changing.
> >
> > A clarification has been solicited via:
> > https://lore.kernel.org/linux-
> rdma/CH0PR01MB71536FB1BD5ECF16E65CB3BFF2
> > 6F9@CH0PR01MB7153.prod.exchangelabs.com/T/#u
>=20
> Did nobody answer your thread asking about this?
>=20
> Jason

No.
