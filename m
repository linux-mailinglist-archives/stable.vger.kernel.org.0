Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE4F746E683
	for <lists+stable@lfdr.de>; Thu,  9 Dec 2021 11:23:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231514AbhLIK11 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Dec 2021 05:27:27 -0500
Received: from mail-co1nam11on2086.outbound.protection.outlook.com ([40.107.220.86]:30427
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229613AbhLIK11 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Dec 2021 05:27:27 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DDqhLIKt6sX9msRP2/qf64e/Wm8E9fGRt4Y1zWBohQRzHfz89pGdNRRlA7+1GZrFLjrtQ7kdilNLd18h5TIVQRmpYZSCW706bEPFloVXczvEbJUKlWUtr8vCGBGxN6YfUaNdNHNDeVoYzHoVZVvLnGDiAYPQOtdrldw5IPpXTmSpsmUOag4hsFBEwr9WsOkpdyDY4WLVUwrJAZ5kg2tSoW+HkuYqhGZMujHqnl8MLGDUxQjKEW3JjkNnk7sKUdCWEli64ohsRrBeGm4MQjqhyQLxuZFuU1jmOoLx9XzVxUCCOQBJLGZA+vHHhamhdh05GYmIF8tb8LTWWrWT4CnVNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+1kQ/AOR12D2IWctAddU5q+IxQLM/Bt9jGohh1whKls=;
 b=GzqeCEAFEyQgaZUrMPbZ8AcPzRuvvyujhbfYCNjwr1BjWZl3Css1YEH48J1+RnYkPe5tpzxL4CMFR7gXqDKyRHALxwuhlRYE+ZzWtR++kXaY03ENXodu1H99W4MllUwPt3axb3jarG5cfj9yUDUr/Ru1yW2wmGBXezeNyJrVXA8ylN73NyDd/mrL9J1KoJhp6VEGoNnm/6Nz+0ZZy9/twXdgUyN/zDi7PqafgInoMr11TnzFC3FMtjCMWfCGl4iMYSXgpyT7UnksgPrbnAg6FXLYlH67oGUG48zFkR+l+Nsz7xmxWaW3dEBjWyNqDMh/ns+SNc2bL5D3Hv4FyEj2pQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+1kQ/AOR12D2IWctAddU5q+IxQLM/Bt9jGohh1whKls=;
 b=vmFIH4sl0BNRYtv68LUwhTxpriv6iH+gzII4CQ5AsH907qBemJS1umVl8GCL3OEztt31KI0+Pt3oJSnHw6E3/hbQSAT2B6GbGtCLFxaH1jzJ6OmObLrZRbySY608PSHQJWXrPORM1B1pLv9kfKnPLUEZrJZHf9W4eqj43Hoybzg=
Received: from MWHPR05MB3648.namprd05.prod.outlook.com (2603:10b6:301:45::23)
 by MWHPR0501MB3836.namprd05.prod.outlook.com (2603:10b6:301:7d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.7; Thu, 9 Dec
 2021 10:23:52 +0000
Received: from MWHPR05MB3648.namprd05.prod.outlook.com
 ([fe80::6929:b34e:d8b9:70bc]) by MWHPR05MB3648.namprd05.prod.outlook.com
 ([fe80::6929:b34e:d8b9:70bc%3]) with mapi id 15.20.4801.007; Thu, 9 Dec 2021
 10:23:52 +0000
From:   Alexey Makhalov <amakhalov@vmware.com>
To:     Michal Hocko <mhocko@suse.com>
CC:     Dennis Zhou <dennis@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>,
        Oscar Salvador <osalvador@suse.de>, Tejun Heo <tj@kernel.org>,
        Christoph Lameter <cl@linux.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v3] mm: fix panic in __alloc_pages
Thread-Topic: [PATCH v3] mm: fix panic in __alloc_pages
Thread-Index: AQHX1N5+lqzX5/9/hUCR9L+z9tfLRKv6c74AgAD9U4CAAB7tAIAADZWAgAnMHQCAAIIHgIAAufyAgAJfDQCAHgMmAIABcMIAgAEjF4CAAGztgIAAC/IAgAAHxwCAAAeTgA==
Date:   Thu, 9 Dec 2021 10:23:52 +0000
Message-ID: <B5B3BCE0-853B-444E-BAD8-823CEE8A3E59@vmware.com>
References: <YYrSC7vtSQXz652a@dhcp22.suse.cz>
 <BAE95F0C-FAA7-40C6-A0D6-5049B1207A27@vmware.com>
 <YZN3ExwL7BiDS5nj@dhcp22.suse.cz>
 <5239D699-523C-4F0C-923A-B068E476043E@vmware.com>
 <YZYQUn10DrKhSE7L@dhcp22.suse.cz> <Ya89aqij6nMwJrIZ@dhcp22.suse.cz>
 <YbBywDwc2bCxWGAQ@dhcp22.suse.cz>
 <77BCF61E-224F-435D-8620-670C9E874A9A@vmware.com>
 <YbHCT1r7NXyIvpsS@dhcp22.suse.cz>
 <2291C572-3B22-4BE5-8C7A-0D6A4609547B@vmware.com>
 <YbHS2qN4wY+1hWZp@dhcp22.suse.cz>
In-Reply-To: <YbHS2qN4wY+1hWZp@dhcp22.suse.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vmware.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c0462e0d-5e5b-4986-8047-08d9bafdff77
x-ms-traffictypediagnostic: MWHPR0501MB3836:EE_
x-microsoft-antispam-prvs: <MWHPR0501MB3836364710802749AC3CB424D5709@MWHPR0501MB3836.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 30Ge1avR3fp67NpYEh/n2AqboIVMFL4u+xGeRuBa5WYBxhg9vLnDUaMwBTTYxqixu9m0AXruqo8vDk21rWUflUjIjYPEOWmMUtbRHrrkJEM/LwuGl7ntmR5KbpfPat+MWr2P8lG29eJ+fR1iwye9veNHI5yQAxH1ugsrOVD12vZHV7Gli/B0iYqWG3ofYx7Ko8PNmiI0P7/uNbSgpZJsSkFxUPoR3nrVnie5bm49rWsa4aigWMOqXkDbFgE/GXzWh9knOkgw2Z4Ciut8MuNzcW140+5SBLtHHEdCX2Ktu75KTZav0tlS3+3RTIY5QTKwY2wTpi5F61qaVIh9ZqohWGxDTrbGpF1SSMdv0Gx7OVt/VazGcLKN/5LyMU22WeedLJ6IA5+4WdSvm3+iAd5B5imrlRPLC4/oI1zar5nOUH7g0HATGGxopqFpBWvDdbcKUzfEddf6EZSbGij+9fflpJm4ZEvdbLTImg6tRY9FjHAFUjV3AEoLnpAHSGtvWmCVrUQ2WMHg0JdofMbTT9mZD6vY1/SzeI2kXmUjoGWzw/ubSbrXOt1TavGt1ncnd0JiFB9us5goMYAj6jMs+tKyTPg3n+syzYzpbiK24xzc/pkxAYy+FJV+p963lbYSUuoUhEAsRbrJs9TQtq+YkLo5nZw0iYEhqbjubqYsH7zG5xNSGcio9krWlcqq3kE8hfyuqTq3PEQa8Tqugf6PXsDoQwhkQZxFuLhqUtz/3q+0bII3tpB4eBuadoi5bLa36mij
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR05MB3648.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(316002)(8936002)(508600001)(76116006)(122000001)(91956017)(54906003)(2906002)(6512007)(66476007)(66556008)(64756008)(4326008)(66946007)(5660300002)(71200400001)(99936003)(66446008)(83380400001)(8676002)(36756003)(6486002)(7416002)(26005)(38070700005)(6916009)(186003)(2616005)(53546011)(6506007)(86362001)(38100700002)(33656002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RDFSU2pXcnhGYjdJK2tmSjVHQ2ZBN3B3QVZaRkF3blRBem15K0llZVBNeWJJ?=
 =?utf-8?B?U3l4M2lkZ0wxWUtETllPNTIxY1F3bkliVzdGNnF1aFRKMEtodGxHM0UxcEVO?=
 =?utf-8?B?UUVlemJjR1lvbERiL2ZxTzNQLzNoREtXaC9hTVJvMCt5MmxBbS9sdmRFekZq?=
 =?utf-8?B?TmQ0blg0OHI0M2tMT3JjOXVMUU1qNEVNVTA3S2J0eVJVT0tnTUJmZ3dGUnpU?=
 =?utf-8?B?MzQySlhSbndFWXNPbmJwL1N4dWxVOW9NeWZEVmZ6UHZNZ2dXdy9RSGEyUVVZ?=
 =?utf-8?B?Qmk5MzRxZFR5Szk1YitIczMyRVphL1J2dzFhKytkeFZPSm10eDNyTXFWYUJD?=
 =?utf-8?B?NVFLMFAySDVVTVg4bXBaWTVmQks0OVAvOWlrNTIzNjVGeWV4N0lQTUp5RURl?=
 =?utf-8?B?R3VQSWp6dnNmcTFHYXhOTjFZVWlNUDcxa24zd3pMTTExelhXSFNCRUY5dEJi?=
 =?utf-8?B?Z2t2bGU1QURBcXV0bHpGMmZ0UW4ydUVXbkV2aXpYQUQyR0x5dnRjMnVvTnBG?=
 =?utf-8?B?U0hiZGxlZ1JTNWo5NGxQd2RqbnQ4NUNJZE5IamhGV1R4L1J2Tmd2cGRpODUw?=
 =?utf-8?B?bkg5UHMvc2JCNk9PeEVYOHQvakplRDdDQm9SK1ZqR3JLRTB5SDJEQnRObU1t?=
 =?utf-8?B?TGRTWmQwbkRiYWhrd2txUUdqelJtbDlvdWdxUVoxZHc5K1VHUVQ1ZWZTQzFX?=
 =?utf-8?B?YUJPdURHRTIwSVZmM3EyRXNqd3hya1NWWXFld1lUT0FFN29uTVBpbTF2YVRz?=
 =?utf-8?B?ZTFhRVdFNXVMWkhkNytWbmdjMnI4NzhQaEQrakswNEQyWXFFYmdxK3g1bVpT?=
 =?utf-8?B?MHR2STlsd3pDdmpVS2l0RjlyR0drRGxBdkdpVjgwUW9mTWZxMW9BYU5kRW83?=
 =?utf-8?B?NUorRndaZ3BXZzBSKzBEUndRcW1jYitSYm43clN0N3IyVlRxYzg1c3lsM2ZJ?=
 =?utf-8?B?TG1abGpQMDQrNEliUk9yaCtGY3JYcjV3S09NZ3c2dmJOQmNwYkFwcVp5Q1I2?=
 =?utf-8?B?YTNxc1V0dW9XOU1MTExhVFNiYTg5d2pnOTNJZUk5d0pGWlhrRTVlZlFYUEE2?=
 =?utf-8?B?b2prbTdsekM2UU5YRWJCS3oyZWtBNk1kT0l2REdxNlZhSit5UW1Va2lyM2RN?=
 =?utf-8?B?QWowRWlselhnMmprT1N6QjFzbTdTWUlGRVVLS3F6V3FaTmR0K0taUmVWdnJR?=
 =?utf-8?B?bDlEWjg3MEx6cUo1amprUnh5VmZ4Rk5IRUdsVTl6M2k0Z0IxUEZmZmEvRFUx?=
 =?utf-8?B?Sjg5TkQ3RmFFTjV0VUFLZFMxcGhtb2V4dm1tZXFtYkhFTmwwbFlBSld0OHFW?=
 =?utf-8?B?WVlHNkkzMmdOWEJrN2ZRZkhtNDNud05wYUlNVWFLSEdJWWdveG5xQSttT2xv?=
 =?utf-8?B?bXdEUjJyaFVsS1hmdFpVZFlOT0g5S1lBS2VMdWN0cEtZbENKVnNhMlBiOXBp?=
 =?utf-8?B?ZldkZmszOEVPQjc1VlM3ZlBRTkRNZmJhRDdhekE4MGo3ODNxenlscERFdWxO?=
 =?utf-8?B?bUN6OStZdW5xQXlBVkRHTDRIZkh4OHdFMjgzYWZsaTNyaDdUOXNsekRwNitC?=
 =?utf-8?B?T21tSzRsaUI3c0w3dlVhcnJkTlpnQ2JSRWNTKzVBRXdrbXEwSE0zemwwNVdN?=
 =?utf-8?B?dVhtU2V1TEVHejJGdjJrTHRBOGFpbjVHVmpNcEdXWitjMUYwYklJeEJVWU5B?=
 =?utf-8?B?cGRRUUJuSjh6TXhmTDI5bnc1MzRBV0ZmeW1tc0E3eFF6L0xqbTgrS2h5TmJZ?=
 =?utf-8?B?RG1QWUZOZ044ektpZjY5UjAwSk5TaS9MbWFISEdxdlRHbGVCMk1YN0swNHFm?=
 =?utf-8?B?Q3BjTUJYcW5SejlCdURNTVZENklWeFllV0h4Wi9nWTVCUUIyT0FWcnZOVnIz?=
 =?utf-8?B?OVRVQjVHK2NmZ0s3Z0hLbjZKZlZ4QmRmQjVQZlJaTHNENGZlWDh1bUZXenI0?=
 =?utf-8?B?RURvQi83TVdZWitkbTlDNktGYmZTTHFnSThsMUQrOXBlbFJIYmlNRHNPNXU5?=
 =?utf-8?B?U3R1MkRFS0pGOFh6NWFTNEtmdVYwYUVDS2cwY3dLM1JONjV6bVJVaEs5SDFZ?=
 =?utf-8?B?OTBNZlRsYU82cDRWejFJbEdidWtKeHJORm5XS01vSitUeUozMkVaaEN5S0dH?=
 =?utf-8?B?V25LMzhHY1NNQkhWMVhMa3FwM2h3OEJhY3R6U095VGdwMDVIRERJaUt1YW93?=
 =?utf-8?Q?r7xwPHujf03gv79fwZUbBUM=3D?=
Content-Type: multipart/signed;
        boundary="Apple-Mail=_8355A091-C534-4B23-A20E-904E49BA972D";
        protocol="application/pgp-signature";
        micalg=pgp-sha256
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR05MB3648.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0462e0d-5e5b-4986-8047-08d9bafdff77
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Dec 2021 10:23:52.3899
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VnwWDfcPHoQFHgw3hmbegbhx6e68LNTh4+gYiQxQdH73zlLjJedHqluEPG3EKM7Rqb1RwWdRUH03QhEbhapmMg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR0501MB3836
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--Apple-Mail=_8355A091-C534-4B23-A20E-904E49BA972D
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8



> On Dec 9, 2021, at 1:56 AM, Michal Hocko <mhocko@suse.com> wrote:
>=20
> On Thu 09-12-21 09:28:55, Alexey Makhalov wrote:
>>=20
>>=20
>> [    0.081777] Node 4 uninitialized by the platform. Please report =
with boot dmesg.
>> [    0.081790] Initmem setup node 4 [mem =
0x0000000000000000-0x0000000000000000]
>> ...
>> [    0.086441] Node 127 uninitialized by the platform. Please report =
with boot dmesg.
>> [    0.086454] Initmem setup node 127 [mem =
0x0000000000000000-0x0000000000000000]
>=20
> Interesting that only those two didn't get a proper arch specific
> initialization. Could you check why? I assume init_cpu_to_node
> doesn't see any CPU pointing at this node. Wondering why that would be
> the case but that can be a bug in the affinity tables.

My bad shrinking. Not just these 2, but all possible and not present =
nodes from 4 to 127
are having this message.


>=20
>> vCPU/node hot add works.
>> Onlining works as well, but with warning. I do not think it is =
related to the patch:
>> [   36.838838] CPU4 has been hot-added
>> [   36.838987] acpi_processor_hotadd_init:205 cpu 4, node 4, online =
0, ndata 00000000e9c7f79b
>> [   48.480498] Built 4 zonelists, mobility grouping on.  Total pages: =
961440
>> [   48.480508] Policy zone: Normal
>> [   48.508318] smpboot: Booting Node 4 Processor 4 APIC 0x8
>> [   48.509255] Disabled fast string operations
>> [   48.509807] smpboot: CPU 4 Converting physical 8 to logical =
package 4
>> [   48.509825] smpboot: CPU 4 Converting physical 0 to logical die 4
>> [   48.510040] WARNING: workqueue cpumask: online intersect > =
possible intersect
>=20
> I will double check. There are changes required on the hotplug side. I
> would like to see that this one doesn't blow up before diving there.
>=20
>> [   48.510324] vmware: vmware-stealtime: cpu 4, pa 3e667000
>> [   48.511311] Will online and init hotplugged CPU: 4
>>=20
>> Hot remove does not quite work. It might be issue in ACPI/Firmware =
code or Hypervisor. Debugging=E2=80=A6
>>=20
>> Do you want me to perform any specific tests?
>=20
> No, not really. AFAIU your issue has been reproducible during boot and
> that seems to be fixed. I will work on the hotplug side of the things
> and post something resembling a real patch soon. That would require =
also
> memory hotplug testing.
I can help you with memory hotplug testing if needed.

Thanks,
=E2=80=94Alexey

--Apple-Mail=_8355A091-C534-4B23-A20E-904E49BA972D
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEQe6bu7hIFElmsM7CGW4w8WwwaSUFAmGx2TUACgkQGW4w8Www
aSWAVA/+IFQXpaUSoK9kXzVyBVGh43WyMGq2ikgDJkxAmEJXXSUFGwNmS3ChfJKZ
a4xOKdif4H9qlY538jewmTeyh9Q0NHtKSGznowAUEVfQaaFsQyIrdeth5HDbZSk4
UVmTwqaWjq0HKKv5RFIJeilea0wfmmU3VzqwX0NUF4nBDrBCjBEyvNhGPt1y+Oam
BWXRGLzoMcbnqhiGZKEyl0ZzohZ0zn5BdGJS7W01y5rJbanJ1417SQZDNaQPhRML
L5f273RrrpatXvvJDjhMvCKaamFzc8hi03YOCvdM/zxRueKu1asoNq8uvR3Rk2qp
FvzXw61hyZJ3wpgSLjrHeqobLqn8+fCkrORqWzjW2Wk1qR3E6HZl+53agHTqmYbn
KEPDMb1OkDYZs60lwDSysihPpZq6OULKFttk9wH1431QzambUT47AoYPC8VqiRAt
q4AVKGQMrYPxDzdyy0Ei/Inrzuo7G7EF5G3K0pU4Zd6qFieFLNAgC2JvI7jMMr2/
Hg59KhT0LYXPLN/15jbWfnIWg6/iCZUi+isN9ajUsVg4gbCxlvqY9IvBLept7bbh
ik1SDOqSagZEnO/Xig32JonE9ubX/H9Ue289lNHqgcrbFRGtO0b88oqK4Zl8vQGJ
ByhccrhTh4+eFKdHW0F/alRvYrHMPMgDk9O0MpKQ1iH7L+I02kQ=
=zlSe
-----END PGP SIGNATURE-----

--Apple-Mail=_8355A091-C534-4B23-A20E-904E49BA972D--
