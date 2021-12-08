Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57C4A46CEC4
	for <lists+stable@lfdr.de>; Wed,  8 Dec 2021 09:19:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236070AbhLHIWu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Dec 2021 03:22:50 -0500
Received: from mail-dm6nam12on2078.outbound.protection.outlook.com ([40.107.243.78]:59680
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231496AbhLHIWt (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 8 Dec 2021 03:22:49 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ESeXqua+lj7i4aBeuqQwjUfm50esAX3E0nYk8rDtBGCCPQaT4/GdfSUfdMeaB8JYJvMSBYlw8LveWbCUIac/qfx/nLj/hQjiTvNoiYA5arlJ9WIJLgVCgolTW7+nKi362YsP1s1o/4UnQwf7pyqKysaCe6KujCdshSS35Tgcy4dW1FG+zNX+ElE9ZBqOgLmjnZJLKWfuc8q3hYsogcaXB3YAHFttPeO86YTFgBTxIJnvPJ6Nfk5H6eh09iVaglh3NN7Xk0/2YB+gdS3ogJfVUsn4CN6wPnQlAh54MzQuOEEQ/nybJTSohPi15dptc8N1DIZP4shBiNXoD/EkOa1AoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=09YRmKc+PmkVSTiQ8XWGDxAa4n3zH8PXDZbSHzgGcZM=;
 b=GCPiZ33MOMZvO3O9NBzRaguK0zmsEMymCwFFuJd4lP0w1g7BRAZt4HhC5kMR20Itvjmj3Sl02/2kdcdKIzDD95GYT8JW4/Rgfiys2lAsydFPGxER4L5qqYMhiLxcyGXtXicOV9HB91G0d66je/8ZeHJ8VlZnNNawg6QSZdv3VfzGKqfMWi53fVoh3qCim5NpD4lT+ypZg1joKzOh3MrfYTXXRpVV5qzGkOZXBtfe02u3hLBSEvJqtWQYNUTkcQRmyRTpD0cbZaxZwua3e3bGpAHwXyQaYGWCNsuywI7sXpbeFmhvuPPKbVX1Ls6HOgYd3uXGKrNspOKtvSqQPl7dfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=09YRmKc+PmkVSTiQ8XWGDxAa4n3zH8PXDZbSHzgGcZM=;
 b=lKtmBjSLdSVUcz98mybb2hO4QYwzoAwvPghFMNHBoM/ca6dBFKFXBF081neuO8b39PmdY/P7W3HckGZn30/ZncKmmk5hskn6Dahuj8Q+qVD+vpyIQ50v3C/6DJRR+WQCpjAo+vZZGvmq/3qmAUllazPTmF+m7qUbmHLW7K8+HEA=
Received: from MWHPR05MB3648.namprd05.prod.outlook.com (10.174.250.151) by
 MWHPR05MB2832.namprd05.prod.outlook.com (10.168.244.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4778.11; Wed, 8 Dec 2021 08:19:16 +0000
Received: from MWHPR05MB3648.namprd05.prod.outlook.com
 ([fe80::6929:b34e:d8b9:70bc]) by MWHPR05MB3648.namprd05.prod.outlook.com
 ([fe80::6929:b34e:d8b9:70bc%3]) with mapi id 15.20.4778.012; Wed, 8 Dec 2021
 08:19:16 +0000
From:   Alexey Makhalov <amakhalov@vmware.com>
To:     Michal Hocko <mhocko@suse.com>
CC:     David Hildenbrand <david@redhat.com>,
        Dennis Zhou <dennis@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oscar Salvador <osalvador@suse.de>, Tejun Heo <tj@kernel.org>,
        Christoph Lameter <cl@linux.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v3] mm: fix panic in __alloc_pages
Thread-Topic: [PATCH v3] mm: fix panic in __alloc_pages
Thread-Index: AQHX1N5+lqzX5/9/hUCR9L+z9tfLRKv6c74AgAD9U4CAAB7tAIAADZWAgAnMHQCAAIIHgIAAufyAgAJfDQCAHgMmAIAABAWAgAASAgCAAAQ5gIAADzyAgAAdyYCAAAWLgIAAAWYAgAAGEoCAAAPOAIAABOmAgAACrYCAAAckgIAAAy2AgAAA/ACAAPfNgIAABCeA
Date:   Wed, 8 Dec 2021 08:19:16 +0000
Message-ID: <0E315E66-7EE2-42D8-B1B5-BD49E21AD67E@vmware.com>
References: <77e785e6-cf34-0cff-26a5-852d3786a9b8@redhat.com>
 <Ya992YvnZ3e3G6h0@dhcp22.suse.cz>
 <b7deaf90-8c3c-c22a-b8dc-e6d98bc93ae6@redhat.com>
 <Ya+EHUYgzo8GaCeq@dhcp22.suse.cz>
 <d01c20fe-86d2-1dc8-e56d-15c0da49afb3@redhat.com>
 <Ya+LbaD8mkvIdq+c@dhcp22.suse.cz> <Ya+Nq2fWrSgl79Bn@dhcp22.suse.cz>
 <2E174230-04F3-4798-86D5-1257859FFAD8@vmware.com>
 <21539fc8-15a8-1c8c-4a4f-8b85734d2a0e@redhat.com>
 <78E39A43-D094-4706-B4BD-18C0B18EB2C3@vmware.com>
 <YbBnBQLcOSJaB7Px@dhcp22.suse.cz>
In-Reply-To: <YbBnBQLcOSJaB7Px@dhcp22.suse.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vmware.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4fe9c416-f553-4eea-576e-08d9ba236cc7
x-ms-traffictypediagnostic: MWHPR05MB2832:EE_
x-microsoft-antispam-prvs: <MWHPR05MB2832AC3ED061C205E56A3713D56F9@MWHPR05MB2832.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1u96nj4pjyQuHWXy7vDgthpUe5Dp23g5EuqodoBLAGr+fGo6H2wtFrsxpLAF1aTjU+FmBzLoTzym/0AOyJhfiSQSdhTicDYCTu9wY7tv+kt8Q/javVhwAAPUvQx90ClZiapykKTkmyiNqURJGGmSY8Eku7N2Oa0n/IdTMmtizJza2L9znGNjWH/RhKwWi2JvQbLDQsXwJmcIY9qQAHcXf1ad7gXZydoJK2/E2dF3NgswT8Ixf8U2FG17NN9Y7+uj9wIOgNrs4eKqkdrxDaXX2BTGU9K/sSXiLIV3ewVzPu2PNw+AMYDV+ywqmkRN4oezGRQKZFpLxdqMQiCmy4Fif+gpVVDBNVwWcWiCvwkXlO2Tv78U4Ylx7V6nz6vfB47+3YIZW3jHtKr0aBcpV5nImEf7aaoH4p6avOV/yFx1nYKgm3t9FFjc6JrhoScwXu1uCNRVHdMKdI2sGs6ga5CCR5EYvFMdrRHx/mmD0nP3/KnEP70ttBJj5FK+NRUX3w+9CCa5X3LLe5MFDwAwyLm4AfW26vGvF/KuOIq+bc/aaNIDe/phFtP4urcyoi8lKu9Q4YNdBQ5mS5eb7ARribLdTM6VSfZNH45FYC5nS8gt4tMvxGE7ZsTiTNe3sRbP6vBpcXIAW7iSPBpkj4uxQahg+MsUiB+RzolAKU70mwjD26wQX1RKK0YSToH4SmS5crpV3EP/AB+RVLOLXstHgQVRmzth39Bzx7AeUJY6t6DftuRB/oLbCaDbJyE4uImUuBzL
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR05MB3648.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(4326008)(6506007)(2616005)(122000001)(6486002)(5660300002)(83380400001)(38100700002)(53546011)(186003)(86362001)(36756003)(38070700005)(26005)(6512007)(99936003)(316002)(7416002)(66476007)(66556008)(91956017)(76116006)(8936002)(8676002)(33656002)(66946007)(71200400001)(6916009)(2906002)(66446008)(64756008)(54906003)(508600001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NmxaMXJMRlFNSVpXT1hDS3pwS01GbW1ZeGxNOXBhK25yS1V5VVJWa1pGM0RM?=
 =?utf-8?B?d2E2R1NVaXlqeGZHZG1UTzc5U2F4QmtqZXQveWh2UnBrN3orUWxyakZabXU3?=
 =?utf-8?B?UXFhT0toTVMvdE1UQnhjd0N5elpPaGJJYVRyaTRkaGZEWUZWT3h5MXNqVUxU?=
 =?utf-8?B?aTVYZ1ZGZnZXQy9HVGZSSEFVbVk5OERPSVUxTXRIWFhqVUcwVWMvS1J5Z2Rk?=
 =?utf-8?B?NVhrZGFhM0NtQWxVSUdJeUtLdWowS3ZVWlFUZlRrK0dtQy9ucXAxbkhJYUdF?=
 =?utf-8?B?UjM0VXNxSE8vRGlqcFc3ajJiaS91ZjVwYnZLNkxoQ09YSERoNmZoUUxlUXE3?=
 =?utf-8?B?K25PdW56czlvbERpRXpMN2hxb2N6ZmFrVWFVVFFWbFFrYk93NXpPS1FGcFZq?=
 =?utf-8?B?WmpwdE1CcGNmZWJ3TUVub2g5SXhRL0F3OTFhYWJFaXF3a3I1UnZXTC9KMG52?=
 =?utf-8?B?a2FPb3pjYjNLYytEYUV2RVRCV0JJOFNBU3J3bWU1NXBWc09SOTlMM2grTkJi?=
 =?utf-8?B?cXVyNCtDZkNVRjNXZXkyYVBYUDdTSU5aUUlLN0oyL3NOdlV1c0lINDBkb2FM?=
 =?utf-8?B?dnB0RmQ5SzUvYWpQdk9SV0cvTUNoenBOR1FpTmJaN0hKN1NRRGs2cXZ0ak13?=
 =?utf-8?B?Szl3TGpuM2ljWDZBZUU2TVJheFM1L0Q3ZFV2YmdXOTduazJ3MmFIZDU1WFkx?=
 =?utf-8?B?MFIyekxCWDlGK29abTVzVDRJNnNPSkVTUGlId0xkN1BvTHptUk42UWgxSUc1?=
 =?utf-8?B?K0FZSVh4M2pkRmVta1RiS2ovVEZnQ2RyYkQ3UUZzb3FRZnBWYzhOSHVoRjBW?=
 =?utf-8?B?b1p0bWxpVE5mTVk1V1BCRDM3Wk1NV0Zyb1R0eVhyQXFKeW5ad2c4MlVEY0VN?=
 =?utf-8?B?OUtkUUNMR2ZKbjVMK0VDSXBTaTZmN3VxWGpxT3djQVl5ZXZZR0dJeWpiKzYr?=
 =?utf-8?B?NFFialFNZ2Vibk81cTdIWXArSWs0SnIyVzV1SlJJZWVURGY0dFJoT0ZzbWtw?=
 =?utf-8?B?SzNjaFhDNmprTDFwQ0dnakdBcnBtclZlZUY0eGNReVpLanF6OUo4ZUhkVUZr?=
 =?utf-8?B?RTdWVTFJYjB2aXBqL0Ruek1iSkVSSGRXMi9Vd1BqcFlWZC9QTGV5emtXV1JH?=
 =?utf-8?B?a0FlR3lOZXA0aE44bklrZnloWGdrbTJpQThWK0p0YlRKR0JDNVBUTVo0aVBT?=
 =?utf-8?B?eVBGYmoyblpVMzhiU3gvWXdaK2FtWTFGUkFuTnF4VmRSaGRzaEVvNkdkbkdO?=
 =?utf-8?B?NW5GL3ZvaGxJQ3FIbnMrSFlHTUo4Szk5RVR1K1hRRjI4a090V0x2cExDUEFD?=
 =?utf-8?B?SndDN1RtRk01dzk4U3VsWkRRVHpjQkQyQVRMMlNxM09hMEd3Y3dSemxwS1Aw?=
 =?utf-8?B?NzF3MjRYbVU5cEFuNnM1VEVLbE8ydG5QdnVwZ0VCV1cxRW43T254Z00xSDB2?=
 =?utf-8?B?OG12Z1h5ZG50VkxQWkpqU1N6L3d0bzV3K1U1aTdRQnNsdC8yMEQrRnpMWmtH?=
 =?utf-8?B?N05XU3Z6OVIvWm5tQXh4TTJIY1ZSZzZNRjNRMmJyRWc2azVOL0o1L0VSVi9J?=
 =?utf-8?B?QzRYOWVCVUJUcUtUam15Z2xhendZT3VIVTZ6aGo4SXFWVVBNYTlRZ01iOGF6?=
 =?utf-8?B?eUtnSkRsV0FOamxoOHh2a2NDcWRGWDMzVEY4NmxCNlA1NW5HSmVWOHI2Lyta?=
 =?utf-8?B?M1BVUXpsT3l3VE5jWE5ZSElsY09BdTNoTVNpS3BwL0lTeHhqU2c0RW5ERFcz?=
 =?utf-8?B?RC9GRWVkZHhwdnkyMFJWYXREMmRtZVlKOE4yenRKZFk1Umhva0ovOEprYnE2?=
 =?utf-8?B?VC82TVVubXR5VGhTaE96bkxHc0ppbjJvcHlsVEQySUtBcis0ZjRBZk13SjBm?=
 =?utf-8?B?ZlBwUWExUXo1Q2dIOWZWNDlHZ052ckY2RGV2dHEzdFcrVG4yZHF4QUI2KzZn?=
 =?utf-8?B?dUNFYk94MVpZOHp3blpxanpFaHFoSmdkWkZKT2pQdDliVWZ4V3ZtaENhZEdh?=
 =?utf-8?B?KzlNV3l1b2ppNTU3T25OeHcyNm9DbG44c0lodTdwYmRPWERCYzY2L0h6ZklE?=
 =?utf-8?B?MnpNNkhCVnE4b015QVVNOFNqb3hNQkxVMGhmRDdMUmt6UEp6UWxOVGp5VnlV?=
 =?utf-8?B?V3YxbjlvV2xOc0c4TU1kYUIyRWV2ZzNOSmV6WGFMZGRtMmhmVCtvWWxjTk1m?=
 =?utf-8?Q?/6IkrnNQbFnaIQ0hAyX0IbU=3D?=
Content-Type: multipart/signed;
        boundary="Apple-Mail=_4261D8A3-F9C0-4216-A162-95463D354A6A";
        protocol="application/pgp-signature";
        micalg=pgp-sha256
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR05MB3648.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4fe9c416-f553-4eea-576e-08d9ba236cc7
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Dec 2021 08:19:16.0167
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ffjiiueKnw8CWIgEuF9qTO4uIf0YnY11jiG3cCCgN3J600bkJ1N/lIPYhSgZem6c6pijmFU9jz2jrKY50r0Nmw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR05MB2832
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--Apple-Mail=_4261D8A3-F9C0-4216-A162-95463D354A6A
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8

Hi Michal,

> On Dec 8, 2021, at 12:04 AM, Michal Hocko <mhocko@suse.com> wrote:
>=20
> On Tue 07-12-21 17:17:27, Alexey Makhalov wrote:
>>=20
>>=20
>>> On Dec 7, 2021, at 9:13 AM, David Hildenbrand <david@redhat.com> =
wrote:
>>>=20
>>> On 07.12.21 18:02, Alexey Makhalov wrote:
>>>>=20
>>>>=20
>>>>> On Dec 7, 2021, at 8:36 AM, Michal Hocko <mhocko@suse.com> wrote:
>>>>>=20
>>>>> On Tue 07-12-21 17:27:29, Michal Hocko wrote:
>>>>> [...]
>>>>>> So your proposal is to drop set_node_online from the patch and =
add it as
>>>>>> a separate one which handles
>>>>>> 	- sysfs part (i.e. do not register a node which doesn't span a
>>>>>> 	  physical address space)
>>>>>> 	- hotplug side of (drop the pgd allocation, register node lazily
>>>>>> 	  when a first memblocks are registered)
>>>>>=20
>>>>> In other words, the first stage
>>>>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>>>>> index c5952749ad40..f9024ba09c53 100644
>>>>> --- a/mm/page_alloc.c
>>>>> +++ b/mm/page_alloc.c
>>>>> @@ -6382,7 +6382,11 @@ static void __build_all_zonelists(void =
*data)
>>>>> 	if (self && !node_online(self->node_id)) {
>>>>> 		build_zonelists(self);
>>>>> 	} else {
>>>>> -		for_each_online_node(nid) {
>>>>> +		/*
>>>>> +		 * All possible nodes have pgdat preallocated
>>>>> +		 * free_area_init
>>>>> +		 */
>>>>> +		for_each_node(nid) {
>>>>> 			pg_data_t *pgdat =3D NODE_DATA(nid);
>>>>>=20
>>>>> 			build_zonelists(pgdat);
>>>>=20
>>>> Will it blow up memory usage for the nodes which might never be =
onlined?
>>>> I prefer the idea of init on demand.
>>>>=20
>>>> Even now there is an existing problem.
>>>> In my experiments, I observed _huge_ memory consumption increase by =
increasing number
>>>> of possible numa nodes. I=E2=80=99m going to report it in separate =
mail thread.
>>>=20
>>> I already raised that PPC might be problematic in that regard. Which
>>> architecture / setup do you have in mind that can have a lot of =
possible
>>> nodes?
>>>=20
>> It is x86_64 VMware VM, not the regular one, but specially configured =
(1 vCPU per node,
>> with hot-plug support, 128 possible nodes)
>=20
> This is slightly tangent but could you elaborate more on this setup =
and
> reasoning behind it. I was already curious when you mentioned this
> previously. Why would you want to have so many nodes and having 1:1 =
with
> CPUs. What is the resulting NUMA topology?

This setup with 128 nodes was used purely for development purposes. That =
is when the issue
with hot adding numa nodes was found. Original issue presents even with =
feasible number of
nodes.

Thanks,
=E2=80=94Alexey

--Apple-Mail=_4261D8A3-F9C0-4216-A162-95463D354A6A
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEQe6bu7hIFElmsM7CGW4w8WwwaSUFAmGwaoIACgkQGW4w8Www
aSV++BAAgR/2yrKilIDIOOMOxbb4nW0SyWWhUJb6WBZGp9O5RIqC6wsi4bJdd0z4
9WIhGGWVWFFRJZtmiGDldRQnYMwfdFB0uQPRKWEqnxcozoHim/1HhS5ICWGO9OSm
/EnEoE/xo7wwEQuaJGf1Ju9bM94eNmEK3jOsz/w98isodwi0AatJnbnyYhqL/3mK
pyTNtJm6DjITNBkhYQGm4P67aO/uulJd3R/Z/ORNvVchKEAoPrMT1F2ZnvyVtjcA
IW0Kzg+PycxmNf/o7QSl3uDSmKi2lu73LvG5XftUJ3OETEpaLyJNs8dWbN4n9KjH
8+WrUxuW7uD6O3AeARp5bDQ94LwL0OJs4lPXmvS6glRikad0WpiuYK145q4qvBC1
GFPVukU2KtH3V3CfqaZ3U/pegP6U+7POqSsgo1bN9k32N4x14elVA8ZGj8U8cPk3
N37tOKJw6Cbp3k3XTbbuum+U8CiBPQ1wzsG0+J+jc5LO0twRgV5/HD7omizTNTqJ
F1cdHtjkIKXDTKEDpDPl/50nve/IG40rmTCfR2KFK6BI1vko+4MJ+qDzBZlMQJb+
zBHajg+u5tToRbKjldVeJzR6ewR9jBqTPOUtF1ZB8BQFetlLReuBsB3mkTMhUqqZ
BKBso0XijZVCkITVbKdtLltIzY6vHx3GIP3RceKKI65Kwwr5a8I=
=1X5J
-----END PGP SIGNATURE-----

--Apple-Mail=_4261D8A3-F9C0-4216-A162-95463D354A6A--
