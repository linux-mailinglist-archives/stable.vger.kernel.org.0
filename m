Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30A66442A8C
	for <lists+stable@lfdr.de>; Tue,  2 Nov 2021 10:40:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229577AbhKBJnN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Nov 2021 05:43:13 -0400
Received: from mail-bn1nam07on2068.outbound.protection.outlook.com ([40.107.212.68]:56009
        "EHLO NAM02-BN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229505AbhKBJnM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Nov 2021 05:43:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DpzZ6caCBiZJ761rITphmc0mgky5juEHr/EhZUjN4scSa8ZQ76UZY1411fTGXq7JjJM+jwba03ku4Ecua/r4b9RS1fyLRrosBzwHjk0kYHNX3MTkGHFVTRPcB9oaerS9YYdhWMJtW0nGhXtmfQAnetrt61M73DLs02KrK5Ey2LDTlUw25wXrP9pNFO40LywO5ExYzQ6z8PatpIU9xgjGkn+pTePm8zxjivUGxbg0saL8aP9eH9WM3pN9P/xX9Vm5R+2bm1cPpx+466P/JoYI7WrXsS3nwN+SyTtRDTiXsYR9Zqpyr0is2KzwOaseV/82J3yvNJLERMxsLvj+GpjwCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ai98l+xUgdH9VOYOnSLyGFvuran9JyWLM3D2tOS81gE=;
 b=g5ca4ocgQgvDgExO6/GNBtZsIs8jrVw75qWRBCwhcmssd+8FtzXvte17hZTK0qOxx3fpCe+jD2E/oXhHuBo0EEdK8VAUhpaPwe/4hYUAFPxKYE2oJjCrSxndH47lerN5rUC7BMMbt7MaAhLtm3bPQuMyHymWEJJCMfqH8/xy41xh+B1x0fn8QM7oNk7SSphWXuQKPlFiHqVMqAHDgqhacMn8eI0guRxj8YXRS1DE6AqE9++SAsgkl644F+VxcCwZwtbqiEZ/fA4YaAYRy/ZW1oUINpp8TODx2Gu4VwUvVDIIZgYL8xFkSnHcRD7pFH5M5z/vqftYAeG1vbJG1qHI+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ai98l+xUgdH9VOYOnSLyGFvuran9JyWLM3D2tOS81gE=;
 b=EMePXdlwQbr9mVaR1TOEGB/H47FfVezBEuXit5lmsHJCvtl/lsvV7mrQ40igkCnso5E9snH3YBRIKdV0MDlrd9K9fbkQvvv0ZNhyDTaR0R9db3UdTjdx0dca1bJu4+HQr9JROpMCBbr48KhJZUVo/hxKpnSIToaME+KLEJIl8pU=
Received: from MWHPR05MB3648.namprd05.prod.outlook.com (2603:10b6:301:45::23)
 by MWHPR0501MB3915.namprd05.prod.outlook.com (2603:10b6:301:7c::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.11; Tue, 2 Nov
 2021 09:40:35 +0000
Received: from MWHPR05MB3648.namprd05.prod.outlook.com
 ([fe80::d871:f5de:8800:46dc]) by MWHPR05MB3648.namprd05.prod.outlook.com
 ([fe80::d871:f5de:8800:46dc%4]) with mapi id 15.20.4669.010; Tue, 2 Nov 2021
 09:40:34 +0000
From:   Alexey Makhalov <amakhalov@vmware.com>
To:     Michal Hocko <mhocko@suse.com>
CC:     David Hildenbrand <david@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Oscar Salvador <OSalvador@suse.com>
Subject: Re: [PATCH] mm: fix panic in __alloc_pages
Thread-Topic: [PATCH] mm: fix panic in __alloc_pages
Thread-Index: AQHXz1zvSxS/i+mFgUadpM+6bJvGtavv3QcAgAAG4YD//5TPAIAAec8AgAAKHIA=
Date:   Tue, 2 Nov 2021 09:40:34 +0000
Message-ID: <E1D4EDDB-5637-45CD-A1D9-77FA43BC9DBA@vmware.com>
References: <20211101201312.11589-1-amakhalov@vmware.com>
 <YYDtDkGNylpAgPIS@dhcp22.suse.cz>
 <7136c959-63ff-b866-b8e4-f311e0454492@redhat.com>
 <C69EF2FE-DFF6-492E-AD40-97A53739C3EC@vmware.com>
 <YYD/FkpAk5IvmOux@dhcp22.suse.cz>
In-Reply-To: <YYD/FkpAk5IvmOux@dhcp22.suse.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
authentication-results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=vmware.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bdbd759b-2109-4cb6-3418-08d99de4d1e0
x-ms-traffictypediagnostic: MWHPR0501MB3915:
x-microsoft-antispam-prvs: <MWHPR0501MB39150164474048E9E930FB7BD58B9@MWHPR0501MB3915.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ClJsWZIPt+7laGbUT1/8ufxwlnnrTUL/uAXZEIuzc3g10RIicIi540fW8beg9kV3PABQ/BYDgu94ywZQYKWEbdk96FtbUL+rNTEYJzV41rSiJbnZl9WpBV4+OW1UFIgkJtT15qczUno1HgQBQ3N++sZSoM6eJM8aZCnzSgneGluJh7pLmhYrSFMTa4r/fHd22DJ7htTuzvpeyD9rg2fnhPIeD3oPzMBK7VPJcVeSmBFNENf6h+y2QpgqpD0KPNSDulzluJy5fJWOiTsM1VACP6eDdHQPl5AScNKCvF5UtCdEYt/h47CPrey5mmuqt8ckOtwSKPj6l/I8iZRyK/I9fu33EZy1ZrcFJ8PCA08kMSDxdBefKC7/lC1IWJNk9rHJ0kLkjCg3CFk5hhmRuabUeLNQiDNJQnPgSM5hwLPMNyAfRUGSEQ5wwVhi7Rw5rxi65o0C5alLjPo6nk1iJZQoJKtvpHRqlKaEhL20r0uuM8oOE1YY9zwQQF51eXtE+u2rsQsVkPfTqgxRJdXNxQ3aXk+QbyzmKpZtbpTsVM9SaxuOqRJVGBh+C3bHxbGuQqkCn9XDHas6pz8agykyJ6k0hhe0kTht62H6uyzYCApvnr5uWBwj+VlgSK+ck9oNs+mcTPdp2huBUadWB6zhe7078EZbAFMBf+he9SIrqz0RmxFjvTTQM6n0Bzm97OYilCgGBuMxDweXUTmX3X0PxV+nvpsU1j3bpOIZUnJyRSYhGHRLfaRcClFqrCbWM4mbxJAx
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR05MB3648.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8676002)(2616005)(6486002)(66946007)(71200400001)(316002)(64756008)(4326008)(66446008)(66476007)(8936002)(6916009)(83380400001)(76116006)(66556008)(6512007)(38070700005)(33656002)(86362001)(36756003)(2906002)(38100700002)(53546011)(122000001)(91956017)(5660300002)(26005)(99936003)(6506007)(508600001)(54906003)(186003)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TVM1NDR5dFBBZmJvM2ZyMUkrSmRORjA5SkMxZVFUd21WOE5IaVg0R2c3dVBV?=
 =?utf-8?B?cUtjY1k3UUtCMkJXa0U0aHlTNkhXUm81WDVUMDNnZVJvb0F4YXVwNEc1OWg3?=
 =?utf-8?B?WU0zMDhySU5iSWJXRWU1KzRSZ2VwOTVhTXpucWRMVS9CWEF1eVdleENpd2k0?=
 =?utf-8?B?K0tjVUJrOW1ZNDEwNmZ0bFB1emJ2Z0l6dCtQMHhxd0o2Z0VZMUJtUHIzVjF3?=
 =?utf-8?B?NFVvdlhiczFlbUQ5VG1USDRlckx2UTI3RjhSOWRkWlZRdW1MSStCRW9CcHBY?=
 =?utf-8?B?WEVLb09XT2V6MmdyTXZCdDgwb0dPUEJFTStJRlZWTlhGT00zWGVnTWJ4dVpS?=
 =?utf-8?B?ZFNzWG43MFZCeDJ0Q3BvM0VoT3gyODh1RTJtazFjaEo2YW1FWHovWXBNZEI3?=
 =?utf-8?B?cTZ3M3Zoc3BQNWU5QmRyazdCVTVWbXhMTVdtRDhmaTRDVTFHWVFLZkxBRkwz?=
 =?utf-8?B?ZE9kZ0h5ZHdZWEZrbElydHBjK0xPYjRWblE2emdXN0JsbmxhRGwxRVdMcmF3?=
 =?utf-8?B?clF6UnNNQ2pqbnMzNEtTY3JUazc4bGY3bmNvdXhJQ1JOdDJyUlhtdTJ6QUt6?=
 =?utf-8?B?aUdkVmtNRHkxRERzeW01SzRrcHRWeUk0WHViblp0bmZwT1l4aDc5UjlOcXRU?=
 =?utf-8?B?dmlqQVJaOFhUcEZZSWswd0QvK1pSR1R0cTVOMS81R1hjS3daQVFsY0NaajZN?=
 =?utf-8?B?S0Q1MzE3ZmRzSEM2aXVWa3p5YVgzQ0tGdWUzdU83SXp0aDFBUmkyQWNNd1Rr?=
 =?utf-8?B?ejRYUVdLZndjRDhkMldkWFE5VGN0TEZkaXZ4WnJOLzQwaTZqMWxJNkpjUEE3?=
 =?utf-8?B?d21ua0EzbGk1OGhiajgydmpMQWdIWmNsR1VjVVY0b0tENXI3cWJpVlRMcFlo?=
 =?utf-8?B?MGNpL2laYmN3QWZ0RjhtS3Fmem01UkF0emxMOVVMR3FPVWZxYlI2ZHRQSGxE?=
 =?utf-8?B?NXZXdDdvNUl2N2Z6UG9yRXB2M1VzNDYrVjJ3cWQ1OWtFSUpsVDI0MTdPbWhZ?=
 =?utf-8?B?VkpNN2pxZWd4eis5aVVSN3d6bkpQQzBMeUFVSlB4YjJ3Y2Z5SDVXc3RkRytI?=
 =?utf-8?B?SXBRY2trTTdVc0pud1JRd0ZXNjVDRnEzMFdGblkzalFXSHQ1MnZOdklBL1BD?=
 =?utf-8?B?TisxT3FNaWtWbWc5MFpScVcrL21GMFFrOGx1c3d5T1FBblR1dW95Z3VJNHc0?=
 =?utf-8?B?dzZqZ2hEUWk2UlBzZlVZcDllM05uMDNrajBmNHNVckZ5ekxVaEVzTy9TRnZh?=
 =?utf-8?B?Y2xNYllUUm4zRDVvUDdVR0MrT2ZSbUY4ZDRYZDVkb05TbXM3Qk12K3BWK0lG?=
 =?utf-8?B?eTArdExwZzVwRGU1QUpOelhRamVTd25Xc0xrNEZZQ0ovRzhFWnArUlVTVHh5?=
 =?utf-8?B?Y29NSEg2OHBuZDZGVnNCelhOcDVZQ1RWbUowemdnWGNZR2NLWDZLVFpGMjcy?=
 =?utf-8?B?bGZxT084UTdDMy8xNnpTdndqVVUvYVBiY0VZNktiVWVxdUxNRERmYzVvWXdR?=
 =?utf-8?B?WW5hckgwQ1dobFo3eW9UaFd4c1ZzbC8vL2txampYbVliZUlCZTUxMHVWTlI5?=
 =?utf-8?B?dGhGMGxCdWpJTVdsK3BtRlByOHc5YzZHRndHZzJnWFRENkhsZTRlTFJOVklS?=
 =?utf-8?B?b3lZdkNrZVZhZ09BamFTUDgrM0x3R09jVGhKYVZubVJOV3l3bUVqK0l2b2RJ?=
 =?utf-8?B?a2xJNkpLa0hLU0RNWm16T1cvVmNKWlZiVEpIWHVXTy8vWHA0VFk2N09OS0Rj?=
 =?utf-8?B?OTFISUhUK01IZk9MUFZLbzd3dDJtbWtqZEF4S0pmd2JNd25vOXdtZ2lDTWFB?=
 =?utf-8?B?N3hZRkxaN21DeWhQaFBPbW9nWjdpekxRV2wvbCtWbGI3YjFvNnZBbnh1dWUy?=
 =?utf-8?B?U04zRHdlVHZDTFpibmVIajd0R0RZUG9mbjZzUzdlTFo0NFViWkgrZktVSGtI?=
 =?utf-8?B?MW0vUjJXcVd4cjdCNERYQ3VRQndlR3FuZzR1alBjd2Vpb3lsN1ljVTdYVThL?=
 =?utf-8?B?cjRXYVkrdHd6eSt6VGtwNC9rVzEwc1QxN2VIMjB3MzVzbTB4MEJYWTBzMUtI?=
 =?utf-8?B?ZzRBbDhjWU1BSFd5UWpxTVErbWhTanJnUnpub2JUeG03ZE5wUEFhUGJxSEU4?=
 =?utf-8?B?dzIycFdEZlBJWktrYmEyYStrekF1cGhJVmxia2NUN0pOOERHREVuOGluWi9p?=
 =?utf-8?Q?zM3pOKkncNhh9xABbI3r1os=3D?=
Content-Type: multipart/signed;
        boundary="Apple-Mail=_A058B4B4-19B4-44AE-8BE9-284BD44DC727";
        protocol="application/pgp-signature";
        micalg=pgp-sha256
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR05MB3648.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bdbd759b-2109-4cb6-3418-08d99de4d1e0
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Nov 2021 09:40:34.7712
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Crt2EVJVPbgmtnwQ/7VtYVIz2Hr+1GK6pdFDzK7ENq9j/3+y2SoMAzwveg9s11mJAzWdkyK29yHkQsEvKyF/gw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR0501MB3915
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--Apple-Mail=_A058B4B4-19B4-44AE-8BE9-284BD44DC727
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8

>=20
> It is hard to follow your reply as your email client is not quoting
> properly. Let me try to reconstruct
>=20
> On Tue 02-11-21 08:48:27, Alexey Makhalov wrote:
>> On 02.11.21 08:47, Michal Hocko wrote:
> [...]
>>>>> CPU2 has been hot-added
>>>>> BUG: unable to handle page fault for address: 0000000000001608
>>>>> #PF: supervisor read access in kernel mode
>>>>> #PF: error_code(0x0000) - not-present page
>>>>> PGD 0 P4D 0
>>>>> Oops: 0000 [#1] SMP PTI
>>>>> CPU: 0 PID: 1 Comm: systemd Tainted: G            E     =
5.15.0-rc7+ #11
>>>>> Hardware name: VMware, Inc. VMware7,1/440BX Desktop Reference =
Platform, BIOS VMW
>>>>>=20
>>>>> RIP: 0010:__alloc_pages+0x127/0x290
>>>>=20
>>>> Could you resolve this into a specific line of the source code =
please?
>=20
> This got probably unnoticed. I would be really curious whether this is
> a broken zonelist or something else.

backtrace (including inline functions)
pcpu_alloc_pages()
alloc_pages_node()
  __alloc_pages_node()
    __alloc_pages()
      prepare_alloc_pages()
        node_zonelist()

Panic happens in node_zonelist(), dereferencing NULL pointer of =
NODE_DATA(nid) in
include/linux/gfp.h:514
512 static inline struct zonelist *node_zonelist(int nid, gfp_t flags)
513 {
514         return NODE_DATA(nid)->node_zonelists + gfp_zonelist(flags);
515 }


>=20
>>>>> Node can be in one of the following states:
>>>>> 1. not present (nid =3D=3D NUMA_NO_NODE)
>>>>> 2. present, but offline (nid > NUMA_NO_NODE, node_online(nid) =3D=3D=
 0,
>>>>> 				NODE_DATA(nid) =3D=3D NULL)
>>>>> 3. present and online (nid > NUMA_NO_NODE, node_online(nid) > 0,
>>>>> 				NODE_DATA(nid) !=3D NULL)
>>>>>=20
>>>>> alloc_page_{bulk_array}node() functions verify for nid validity =
only
>>>>> and do not check if nid is online. Enhanced verification check =
allows
>>>>> to handle page allocation when node is in 2nd state.
>>>>=20
>>>> I do not think this is a correct approach. We should make sure that =
the
>>>> proper fallback node is used instead. This means that the zone list =
is
>>>> initialized properly. IIRC this has been a problem in the past and =
it
>>>> has been fixed. The initialization code is quite subtle though so =
it is
>>>> possible that this got broken again.
>=20
>> This approach behaves in the same way as CPU was not yet added. =
(state #1).
>> So, we can think of state #2 as state #1 when CPU is not present.
>=20
>>> I'm a little confused:
>>>=20
>>> In add_memory_resource() we hotplug the new node if required and set =
it
>>> online. Memory might get onlined later, via online_pages().
>>=20
>> You are correct. In case of memory hot add, it is true. But in case =
of adding
>> CPU with memoryless node, try_node_online() will be called only =
during CPU
>> onlining, see cpu_up().
>>=20
>> Is there any reason why try_online_node() resides in cpu_up() and not =
in add_cpu()?
>> I think it would be correct to online node during the CPU hot add to =
align with
>> memory hot add.
>=20
> I am not familiar with cpu hotplug, but this doesn't seem to be =
anything
> new so how come this became problem only now?

This is not CPU only hotplug, but CPU + NUMA node, and this new node is =
with no memory.
We accidentally found it by not unlining the CPU immediately.
>=20
>>> So after add_memory_resource()->__try_online_node() succeeded, we =
have
>>> an online pgdat -- essentially 3.
>>>=20
>> This patch detects if we're past 3. but says that it reproduced by
>> disabling *memory* onlining.
>> This is the hot adding of both new CPU and new _memoryless_ node =
(with CPU only)
>> And onlining CPU makes its node online. Disabling CPU onlining puts =
new node
>> into state #2, which leads to repro.
>>=20
>>> Before we online memory for a hotplugged node, all zones are =
!populated.
>>> So once we online memory for a !populated zone in online_pages(), we
>>> trigger setup_zone_pageset().
>>>=20
>>>=20
>>> The confusing part is that this patch checks for 3. but says it can =
be
>>> reproduced by not onlining *memory*. There seems to be something =
missing.
>>=20
>> Do we maybe need a proper populated_zone() check before accessing =
zone data?
>=20
> No, we need them initialize properly.
>=20

Thanks,
=E2=80=94Alexey


--Apple-Mail=_A058B4B4-19B4-44AE-8BE9-284BD44DC727
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEQe6bu7hIFElmsM7CGW4w8WwwaSUFAmGBB5EACgkQGW4w8Www
aSVECQ//YC51z6/1ImbayvSdje7aLwF7ODxa7r6/PZxIl/0Y+JGEo+NIlQzQhjhK
SQhH3MmLwCM/kwSFQfiPMQ1pUew5wlHtFYWr5bDI7hnhTgHTXaJTfJR3czo87Wca
JG5bogFbn0uRYSO2eDdJSSnho+PB/3D4RTU/W/XTG1ZR7dnVZtvL/fv/H5ePLdpL
eDoistgby9FxxEc/6g8ZFPMfm60G91OL3Kx3tE5nY+z7scYdJ6sqwthBA6ocGr+M
4S4tmXQnwbhUo9TMGIYTmqvKaNB75rIstIMcTBffvRhCW1TRJi6UFwWsxIOON9PF
4nNTo9RX6VAGocH13PrhwlrNEW3CPcOkucwYTMdM6aLM9s/r2lkF7nynkJ87/UXM
iI4VZC9nx65IBAxUtkWm2Q9fKM6c6Ajsr4qNL7kkFBlWWQ7x3e85ShSZjkCELiXv
lJ/57brqd5wFVR2Wc45jAqbQWDCy+YjUNDMIGSptjMU7JEuziQvP3m0ar7xW3oMb
9LglYg786YuMxsmDz+SYDWoiJvFvqAqmZDP0WNmgliBpb3FVNqlAPtk6Xa0T0xMZ
IiGGq73G68VWaLQc+OaHIhkae66TVADX2GwD525E6w6np5uJZb2jsxO1PDDT2vq3
YR7wRnuJjhKwXcIV7w/IifI3SbW2MUTwxgxir1KEDVyyFjVH0Jk=
=Vrkn
-----END PGP SIGNATURE-----

--Apple-Mail=_A058B4B4-19B4-44AE-8BE9-284BD44DC727--
