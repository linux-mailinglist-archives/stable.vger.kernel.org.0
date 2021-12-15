Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 384B1476310
	for <lists+stable@lfdr.de>; Wed, 15 Dec 2021 21:20:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235425AbhLOUU5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Dec 2021 15:20:57 -0500
Received: from mail-dm6nam11on2078.outbound.protection.outlook.com ([40.107.223.78]:27424
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233601AbhLOUU4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Dec 2021 15:20:56 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ob9Ge6NT1IxCWYokl9sNijqXrd4nN+o7I68ZbRCcooruql/iMGYgrGJEB7OrTFmJ9MQVKpMo3LUbylRhCm0NX+FNhyzc9TZfnpMQQYf1B5cpOTb1yqfEXqinguTxIc5WQC8yy7zoCgFV3YA75/xCjCk839fELpnz3bSgUz7ruXsmzwDpjo6+YJ4V8n1UlUFUf5l4RC0gO5XWc5slFU6gDKdcsUp9zEsrfdkzioAcJoKZsAPCmC77swCdTfrXI8ppjZZgA803y0IhI5E4lPQp7W9fZKNzoXMLw6O4S55aV0lILycF8OnRZ2zQ0A/z/kwKHg9TXrwhx+/a6vjP72AL6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IjLsgjbaeeDgCZBXXPx8U/Q0tBBuhUqa9xDuCLHPGhg=;
 b=n9NcKYDUcNuwysgXHxKqp8Li3GOlF8r7jz7VkSM/sW9Fda/1alpHNItbPy3ycpZ0ctXRxgRzeMEIJicpjs8+aNeyfGyk3ZGiH7NnAsCF7eJWDqljVauqWWyPlHKgIC1gyAkdRF89GCX3+3MM8YFWg5yWlGKbUneyXyZ8qVLuMFRlo4D+EGQvlUEItjVrMZqxDK5Uv9iV4FmWcErThUmuDAekW3WKtPAOmk3O5XEV4INPIVRPgLgjNSfzzmVgKld6WTu57I4Je46ldy06FDmSdQfbSxM9dG7IFlG5lKzKBzcX37Ikexvf2ULCMxiq5kw3lXW5lxYEf1m0IKKFnRdV7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IjLsgjbaeeDgCZBXXPx8U/Q0tBBuhUqa9xDuCLHPGhg=;
 b=EUWe0QzNuJaWWTpIfscIhBIKgH40syeYMTw/yIoGpaqOjThu5t2B+HQ7DPpjIUs3LmXVDd/V0b4w+PyjY27i6LOHjaQ0KO2pc5Cre5wOYQaENAyqVYwNbu00rfpYSOYX7RZskHWklNPO7Q9EnmFpe9CfbP6rr+RpD78103U0v4w=
Received: from SA0PR12MB4510.namprd12.prod.outlook.com (2603:10b6:806:94::8)
 by SA0PR12MB4509.namprd12.prod.outlook.com (2603:10b6:806:9e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.17; Wed, 15 Dec
 2021 20:20:55 +0000
Received: from SA0PR12MB4510.namprd12.prod.outlook.com
 ([fe80::9481:9017:a6a:3028]) by SA0PR12MB4510.namprd12.prod.outlook.com
 ([fe80::9481:9017:a6a:3028%8]) with mapi id 15.20.4778.018; Wed, 15 Dec 2021
 20:20:54 +0000
From:   "Limonciello, Mario" <Mario.Limonciello@amd.com>
To:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: pinctrl: amd: Fix wakeups when IRQ is shared with SCI
Thread-Topic: pinctrl: amd: Fix wakeups when IRQ is shared with SCI
Thread-Index: Adfx8Jc1mBT85u6fQmOf3NrtasxjcgAAIxmA
Date:   Wed, 15 Dec 2021 20:20:54 +0000
Message-ID: <SA0PR12MB4510B62D8E36E908364FED36E2769@SA0PR12MB4510.namprd12.prod.outlook.com>
References: <SA0PR12MB4510B2B719F0088CD98DA17FE2769@SA0PR12MB4510.namprd12.prod.outlook.com>
In-Reply-To: <SA0PR12MB4510B2B719F0088CD98DA17FE2769@SA0PR12MB4510.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Enabled=true;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SetDate=2021-12-15T20:17:40Z;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Method=Privileged;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Name=Public-AIP 2.0;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ActionId=daabaf21-690a-4276-a36e-5ab76ade9b43;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ContentBits=1
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_enabled: true
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_setdate: 2021-12-15T20:20:53Z
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_method: Privileged
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_name: Public-AIP 2.0
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_actionid: bd50e7d4-e062-49f2-bc9e-d740f84a2d5f
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bb417da3-874d-4821-5f60-08d9c00865cc
x-ms-traffictypediagnostic: SA0PR12MB4509:EE_
x-microsoft-antispam-prvs: <SA0PR12MB45093305C325409A8C06B404E2769@SA0PR12MB4509.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: P+bY9d8ha/QSAUiPoAnOBAYPDaHcjlcGK9AyZSvp0sUQV5t5xx2T6n0EwPYG8LPJ4Vc84zhWvxCAmBiqpw+PPpN6HeCMvHBZXTaidTr0iZFStBUgs7Wb+iqEiEQA8SLxg+yjMVmsGbRQUHu8Fj2k8jrXudbiXYomO7pvm1LgB6oRqN9NTP3HC49QNVpjzrd5rpvxSgFKemjQ/qTBkNr3fcc7Q4L9cwDrywMUen/JlN4t1ADIx4kV8xPeCOnEF0oTCOPvFeU55yC+dbuA8Nea3e3XZFJcKdIsB8EJLmIOy961XdJFsDolXYG1ElDS06uAapVksiKvMS3/24tO/vI9mRGqYJWuNbcqHMbacMPJDlbzIGIVTIOFargcONfjcSHHkmfRPTR1aCMHAcN0Q+l0SHfSQFwg5iqvb6nUZgsNzMWRuTX1DyW9DH03J0MyMk+ncRsxfe4RKV0mWaijyBe8weflrKicm89BF0/DdUIf9JmwnzW/QjavCChmiEgyO6LtKQc/xY6qwjjNXv0hQGKeSy8ohiB2D1C7Q84DN9eFLShoBpAondWx5DPe0CV7X5/GtltMiuv2fvF5/Yf1vXFu85Np0d4BHEA39NGbALy3a8TlM/5/LkBlgKxeofk1p+NRhphq9OYxtnyCHKmAUIOsNtHAV7anMvxTcZ/zCAZWqhlk9o/Ln9ngW2zzGGpWpW0WnamalW3sqUKmZ6qnf65IaJaRV7mbtjBZXtwpqbFN/mv3G5vM74z7XPqH9TzdGcLz
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR12MB4510.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(83380400001)(2940100002)(4744005)(508600001)(122000001)(71200400001)(33656002)(52536014)(38100700002)(186003)(76116006)(38070700005)(316002)(66946007)(7696005)(9686003)(5660300002)(6506007)(55016003)(66476007)(66556008)(64756008)(66446008)(2906002)(6916009)(8676002)(53546011)(8936002)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?cLrQApEZTyjMh/VECWrBVHKoa/d8BnWRkTRAydvZx0ou2zV5KhLKZg0wDVaq?=
 =?us-ascii?Q?Ubpr4q32ICZwsycF6KuyxhgHdfNVL3L8kdt2wva7rrNFODS1fseUptBM/XwE?=
 =?us-ascii?Q?Jx1OHJMtfDDoSflO+YMkYG9/kTxiFQWm5/9do9Hod0EM7FwgayjqizuSvsas?=
 =?us-ascii?Q?AZvGeH8xEEszKQGmnn3E+2BPFu+TvqQRQLQ1T1u9KDXNhydeqUOZ88Kyjo0s?=
 =?us-ascii?Q?AVIxOdzehiCjmCDo/jo6tmw+tqwA93woXDPh230DiejyXDMROyY1GjUrdewd?=
 =?us-ascii?Q?rx6Pv+j7rfX7oeE4DUBWFAX5Be/q5o145VuFygBeNSBTw2hCprWtmgHm1L3/?=
 =?us-ascii?Q?cWZ9RQp0QVcN+uL+Ngeb85jbMhExLqBStwtiEpIsp4XBoz1LIdNdVvM3dbJc?=
 =?us-ascii?Q?DIVniUSeax+ZIl5zJqivMGNnhpQZJjQ340pwuEo7gTDevhE5wvYsr803E/g6?=
 =?us-ascii?Q?OWaSZs4i/C2nQn9wo656LgzdCb9cV0InR9hJF1tB3TwA5ZiKGPPjIZZBqnu8?=
 =?us-ascii?Q?KXlTjv71ZOsaoU+3AtTy0ix0EiyslsRPIDn4SHvS2yb29uye2+K6dY6Sz/5y?=
 =?us-ascii?Q?Aq0sBpp5odvqk5t+8rE0kXmvjXP7CPSjCRXEXh7+JygChStp8iwi2s2JfrwL?=
 =?us-ascii?Q?wBuxpEoJ7GpPmN5Qk8tGd4hRHXRspqNFLk7DbipMNIcV2dmJNj7XrxkAQpqu?=
 =?us-ascii?Q?ijrAbH66HudDo076wLMb0BJhwNrpSh0diN5SR4GtmR24QmTQs7xEyrD7RgOQ?=
 =?us-ascii?Q?Q95ru21i/LAr+c6K5fMaX5hJ/+82ObrCCKCtgz9uYOgotMXEF6CyDH+d3qwz?=
 =?us-ascii?Q?4bIVGq48ozP/ugOfBNaVtwsl1SWR1WrhUjj634tl+S3p1sTUZ17PP4OGYHEx?=
 =?us-ascii?Q?sqU0L8ktJP8zsYItSMiKx8ywhjN+ayZpUZE5dQCXgFu/2Ko+lO+Mzq5UDDfL?=
 =?us-ascii?Q?ao5hQUF/gBIes4kGmg6ropTFCNBBLAcUXzz/N+BXZfv0qn6wWn0IYrTqxTuz?=
 =?us-ascii?Q?qwxZEzP+9Ygo0CYDnkljSTEYmFHBWXLfXGJ/A6ZIoB+sBHzK525TmaGnw5Z4?=
 =?us-ascii?Q?3g0eUy+69FfN9QZrRbTfswcv4gX+LLjD3hcj711QN163wrocuTkag61J63OY?=
 =?us-ascii?Q?Br2pdCQyXE4a0hDn3XxyW5t8YIW3OOo/bjTb4HE2dwNYZV4h/yTK++4d1Guc?=
 =?us-ascii?Q?vGSMqAr4FMpvx4XKqFyw73lk420Ntht8kFb8JYOi9zazkJPpvGtpCaLq+zYv?=
 =?us-ascii?Q?Ifx3sB7ORDBXj/OK2iZtsAUzpkBxVo3E5SIXjAwGprm+ndcrdAvAkYVF4e0A?=
 =?us-ascii?Q?33oOeDQcuzS5QMA74NVeocEL/rHUPaGsOkAQDhqlKqPalIPlbbAWSTnU+Rlo?=
 =?us-ascii?Q?tc6+cx3PV2LmaM/HWebt7fCyVOSiljCnK6ChGRzYq33hTaZAZgJXE9lajvkC?=
 =?us-ascii?Q?azfM5n5KC6fj3ynyA7bZlEkxuDzQ0AWmWwMdXhhFCc5W2FePv8/qpfppFrtF?=
 =?us-ascii?Q?C35SpVKM+OSkmzh8ebngtBhe7nfsSmf+68n+Lf74no1Iamt4XdTLF/4SbeJ+?=
 =?us-ascii?Q?8kXc3XtN39f/VEwSQj06lw5UQvbUB6x/JNwVzetEbIi9WsHdW/ZGHPwz+wRq?=
 =?us-ascii?Q?0exLYx3Obu/A/wQgZXvODlgc20rUKiAa2HkiPbmYjam9qTn6trPhmJ8V6K1g?=
 =?us-ascii?Q?kTuk4A=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA0PR12MB4510.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb417da3-874d-4821-5f60-08d9c00865cc
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Dec 2021 20:20:54.8993
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0vFnASwwzBj7HzBpajyQqJBi2XxTzcJ9qKGARZm1aoV+0D0WYpUhNSBW9jwCyOP9K7u9WIWe4Y+sZMv16rJAfw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4509
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[Public]

> -----Original Message-----
> From: Limonciello, Mario
> Sent: Wednesday, December 15, 2021 14:18
> To: stable@vger.kernel.org
> Subject: pinctrl: amd: Fix wakeups when IRQ is shared with SCI
>=20
> [Public]
>=20
> Hi,
>=20
> Can you please apply
> commit 2d54067fcd23aae61e23508425ae5b29e973573d ("pinctrl: amd: Fix
> wakeups when IRQ is shared with SCI") to 5.15.y?
>=20
> This commit helps s2idle wakeup from internal wake sources on several shi=
pping
> Lenovo laptops.

FYI

To help prevent certain rare configurations having problems it may make sen=
se to take
commit e9380df851878cee71df5a1c7611584421527f7e ("ACPI: Add stubs for wakeu=
p
handler functions") as well, but this isn't as important.

>=20
> Thanks,
