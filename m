Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE791447A56
	for <lists+stable@lfdr.de>; Mon,  8 Nov 2021 07:12:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237667AbhKHGPC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 01:15:02 -0500
Received: from mail-bn8nam11on2053.outbound.protection.outlook.com ([40.107.236.53]:12719
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237670AbhKHGPB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Nov 2021 01:15:01 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=grq4fyz+TCovSOF/6wps6hsY+r23gS18Hd1ijk76zTSd0yxgSy5kNrONQf8RxOCvSWmDW6IkkXcCqd6ch3P/RNbiTkDYbIDe6Y3SedVjDS5q4NxUtS+Pi9RauUpBH5p37dOFVwIVIMX7lwpCzOo1+n0o22FLDQYHyjRuCc+puRoJ9MR+WhfZFq0Dsdx3ptqji7DMrm4fbrRe9JkSUi6p+8xLQpFiwF5+GhHM840UHbZpkHJ6vmllgZM22LMvtzHHxMXp9JMQKZ9SjDAyXQirsCzP31T61FwSV/H4KoIKp5D0+CuMwxfXBBWKUD5LA+HfaR+j58oUVaAy8MlUUUu07A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HqQMlLp73u1sFygNn10yZe3ISwTH1N0O3BsXqB4pBas=;
 b=TQVcPBbOxkff4Yn5j7yY5tdOE9xJ9jmdVy5zHmQkuDKuD8HCWrKQke+lPiMYoET2aDjY8zgHMA13KGfMixTuarQKcNo56S1e+nFGpg/00x8YDodBne4TXMDcjo8xbOHj/5ZZgS+tyup9Ou7U+rwRcGrgl4c62sTdCW+It6gSfWb5QAJBYY7r+WF+CsAqohqNN/RoMdkf3HNa+r+5fTiBQPb1LQZQYNatfuPBKPpM1zTokHZvaIlmotHHQ6db0jolj0kOdhvttb6hBnmvJCV7V4wI1Z7d16GZVaIvJwAA9ZOVEwzHWur52vel1gpzS6Mf9uQbZYzA4jgJj2v2R0RTxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HqQMlLp73u1sFygNn10yZe3ISwTH1N0O3BsXqB4pBas=;
 b=aa3q8OvOf0iNWg2ladkb9mx5zGoLoUaeYSOYAqvfsgrX4G48T/4iU158wHAat5Y3EVATLj7UvusEizzZtOGxL0eAvhAAb0dA6VyDQ68NgFw7bnfQ0JJouBtrezF1KjBKk1EMY1HyX+sX0TWYF1NbRyr5j7bpV0G/7ueu3x3a3VY=
Received: from MWHPR05MB3648.namprd05.prod.outlook.com (2603:10b6:301:45::23)
 by MWHPR05MB3647.namprd05.prod.outlook.com (2603:10b6:301:3d::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.8; Mon, 8 Nov
 2021 06:12:15 +0000
Received: from MWHPR05MB3648.namprd05.prod.outlook.com
 ([fe80::d871:f5de:8800:46dc]) by MWHPR05MB3648.namprd05.prod.outlook.com
 ([fe80::d871:f5de:8800:46dc%4]) with mapi id 15.20.4690.014; Mon, 8 Nov 2021
 06:12:14 +0000
From:   Alexey Makhalov <amakhalov@vmware.com>
To:     David Hildenbrand <david@redhat.com>
CC:     Michal Hocko <mhocko@suse.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Oscar Salvador <OSalvador@suse.com>
Subject: Re: [PATCH] mm: fix panic in __alloc_pages
Thread-Topic: [PATCH] mm: fix panic in __alloc_pages
Thread-Index: AQHXz1zvSxS/i+mFgUadpM+6bJvGtavv3QcAgAAG4YD//5TPAIAAec8AgAAFsICAABNmgIAAB32AgAAMNwCAAAX9AIAJCxiA
Date:   Mon, 8 Nov 2021 06:12:11 +0000
Message-ID: <86BDA7AC-3E7A-4779-9388-9DF7BA7230AA@vmware.com>
References: <20211101201312.11589-1-amakhalov@vmware.com>
 <YYDtDkGNylpAgPIS@dhcp22.suse.cz>
 <7136c959-63ff-b866-b8e4-f311e0454492@redhat.com>
 <C69EF2FE-DFF6-492E-AD40-97A53739C3EC@vmware.com>
 <YYD/FkpAk5IvmOux@dhcp22.suse.cz>
 <b2e4a611-45a6-732a-a6d3-6042afd2af6e@redhat.com>
 <E34422F0-A44A-48FD-AE3B-816744359169@vmware.com>
 <b3908fce-6b07-8390-b691-56dd2f85c05f@redhat.com>
 <YYEkqH8l0ASWv/JT@dhcp22.suse.cz>
 <42abfba6-b27e-ca8b-8cdf-883a9398b506@redhat.com>
In-Reply-To: <42abfba6-b27e-ca8b-8cdf-883a9398b506@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vmware.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 48547b1f-aa2d-4f05-06b9-08d9a27eb5b1
x-ms-traffictypediagnostic: MWHPR05MB3647:
x-microsoft-antispam-prvs: <MWHPR05MB3647A94B7448F589D30E0265D5919@MWHPR05MB3647.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: D7Cp2ianPJEb3JDALkXvftwPQ2Dh3EmA1y/ZONk8j4mX8LL89EVVhI5M+uBoSsDQcy7uRCpQmp6suj1qsaf3Z58II8Ywk3aeSndd9rxHV0mTBM5WZ9E6+WgroiLDnWfJCdvaPLTNg6poEslEMelqQKViNCAjIqvL34ol/AywfLAjB1QxUb8Fj9DIzngm0ni1uCqv/f6HdvcCNYIi4ERPnzsy4t4emW0Hg2pIzbgBkLCMc9IiLW3U133r6kXWUNlcqe7uCcWD1KnUdA8QXUiBcP92sdt3iHH+F7uH0bGNas9XXUKV1NPYgZf3sJ8RYAlXppEA4LwhiH3SUOTddGzv7ujuukAJK+T0vQi7n0Ip9Yul4pY2c4V6MBeAqRf7ckhNVqIXe0M1qHgmZ1Uk0edKJe8xpk8or1AbXeXn2tn5fOwfSPM5PocvUlWLPKYDvRZWSLXTOHszVCi56cfM8Eoln2NGvl5x+GSyfrwcJgoEDhkJ8r3bwiY7Pwn214vPE9oNT7W5cj3cHGCAgAFELeFL25W0nun7Y3bWLkkqTJ8iZ/H3Pr/qbz76ThmL1vo9qMAAWZJF0ny83IuRPKBNSS8Ro841UBkS+d3BXbU9C0nDqXe4/ypEQtsiO8uGpRjYF4KeioSpGKkgI3lPvR9VZUUlzUffEW6KJd6E3vF7Z8EJZ+246kFmlYAfgktC2xg5iAWD/fHDq9L9X9VLciiTEJANQ6LSxX0XfBWz9ftT+OGNe9NJItio53Ve2qhlO1NXu51j
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR05MB3648.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66476007)(91956017)(76116006)(33656002)(8936002)(66556008)(66446008)(26005)(6506007)(122000001)(64756008)(38100700002)(36756003)(8676002)(186003)(83380400001)(6666004)(71200400001)(66946007)(38070700005)(99936003)(6916009)(2906002)(86362001)(5660300002)(6486002)(4326008)(54906003)(316002)(508600001)(2616005)(6512007)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dm5qS1Q3dFdtczc5aThQZnQyT3JFczhZQVpQaG1EckFUN3JXWGd6Mkx3RG1E?=
 =?utf-8?B?T0RmT3FmZWdHVmF6Z1NtRnZLNzk5YmNZV2ROU1BYNDlybFFjalptaUtEYy96?=
 =?utf-8?B?dXlFR0JXMzBBMlZ4S3NtaWIwMWlsOE1jZlJOcmJhSWFZNmVEYStkd3EzWFB1?=
 =?utf-8?B?MlRMMC9ib3h1S1JSSHh4UDhtUDFMWGUyRGNac2hPOWV2UHdTQys5RDZjSzU0?=
 =?utf-8?B?cWIyYi9sMWZVWjNubHFIeCtHQUpaODVtQzBsZzRwZjJZQ25EbW9JbmlQMkdY?=
 =?utf-8?B?OTdpek4zdGFjN3hCT2cxeTFzY2ViTlFTbTdEZUx2RHFWWDgwL3ZYbWh2NkZo?=
 =?utf-8?B?TDh1UmlLNnVDR0thMWw2UTUwNDBJajJOdkZRazJYZGV5WWVnT29xTmZOYWdK?=
 =?utf-8?B?STloZEtCT2N4ZThnVzQ3TTBZRjk0KzQzT0krUldaU0YzVjhoZDViZmZBaUFU?=
 =?utf-8?B?NjF4NHl1eHY5TGFpMUlMTjVIUExCTTB3NndkdzNWNVR2aEI1SE5aQnJob2Vl?=
 =?utf-8?B?bC9GU0o3dGhITHJOTU43RGkrUGlYZHNrbVRIcGc5Ulc5VE9BeGgyb0J0UWcw?=
 =?utf-8?B?U242cTdJYWRWajJlQlhpVDhqbnlISXExR2ZLSzVEMUJhVk5hT1pPT0tiUEkx?=
 =?utf-8?B?S2tIVWxZS3VwQVI0MG90ZnUyRCs2c3JWeTNMVkVJd1d6Q0RHTEU2NVAzRUZU?=
 =?utf-8?B?bGhoOVB3M2lKb2cvZWw0bUlORFE1eGtsU2RRMkFYN3NaWGVXZ0dSZFhGTG1G?=
 =?utf-8?B?d0J3Wk9va3ZEaTJhbWt5NUltZGdHSHN5USswdHNhbFo0Y2M3NnFvUkcwdXk2?=
 =?utf-8?B?K1dhMzRyemxSTkJzUmRCcmZhQ3FVZytrZ2RRcG9KTDMwRlhvSGU0Q0xna0xq?=
 =?utf-8?B?aW1NSkEycllaYUtlWlBHcTg1aUt1aTZZOWc3ck54M1MvYy90ZmNrY3A2Q2p3?=
 =?utf-8?B?UjF1VzRGZUN4bUdDbFFvcjU1cXhQOXdtL1Fsd05BQlNzRXY1QUt0MjJmVjc4?=
 =?utf-8?B?VTlnTGpEdkFjTDAyczRyT2xiNkdjcExBN21wYjQrcldDOUszZEtIYU5kNW4w?=
 =?utf-8?B?V3dvN0N4SGhSSW1oTUdwclJ4elRZcFFJNkM4Yml5QUdHMHJUSnhLVStUZ0dH?=
 =?utf-8?B?SVFmdEI5bmZMM2hGZlJjTnFOQTNXbUdnaTNCQzQwWTJmWHYxVFNSNndacE5s?=
 =?utf-8?B?UURRU1BqNEtOUXNmYWxZcHhVMDRCaGJZcW5NL0hNYjdKNmNDeTZqcWxFVGZv?=
 =?utf-8?B?N2FGb1ZRcWZpcFRIT3g3blZiK01yT015dUNIRVArRE5vNzVLOUVsK09qTXpM?=
 =?utf-8?B?OFdEVXpkYjIwT2Q5OXk5eU4rZjZhV0NwZDhXOEpFaVRxb3g2ZFVaREdMUTNC?=
 =?utf-8?B?OFFXQlp2R2JFdW9oQXpyV2pYbVZaeW5sRWZPMUJ0Rk5mY244UnNUL3NBeFN5?=
 =?utf-8?B?Z0FwMWU1RDBENzdYZzNiNFJhQW9VQlJ2YWNpREpNNnNtUHltWkluWEtCSFBa?=
 =?utf-8?B?eXFVY0FCVjBiTXF6Qi8wN3Nqak4wV3gvYUxkTURWZitDTzE3U1JqT0hXUGZt?=
 =?utf-8?B?UThoci8wYUxEdGIxbWJXYTVabGt4K2V0YlpkWVVvWkhKVFhwSCtoR0ZWdlAr?=
 =?utf-8?B?Y3pVVmQzQlkvY3g3RjV6MVVwdzNyeFFZVUU0YmlVbjdQWHdmL3RiYkpPbHp3?=
 =?utf-8?B?Z3kvZ2pKejJhSDNYc2lTT1Q3WEh5cXlsbzc4eVBla2MwSjhkaEhZbFlpT1ZG?=
 =?utf-8?B?dmVJNXFqVUZRamR2bkRDdWFkSlh5WG5CamZ3SFJsZjRSUmJQL0NsVVk4b1Ay?=
 =?utf-8?B?RnVKZjRQczJEMFdWL2tXV1pBUW5UNXFTTDgvZUprVVdNakwvK0NmSTdQRVh0?=
 =?utf-8?B?NkJQTlVRdUxyWEs1NkFPOEVpNEJiZkMyZHRSdHZVT3cvMkErbm9BZk5XanY1?=
 =?utf-8?B?YWVEeTZCaDdEVDFMOG41ZE05czFnSlNuNUVKdVJZZmZnV3RNRHBOQjZ2b29X?=
 =?utf-8?B?WUpZWmROT0FmejlrTXpkZU9PWS92TFB0TVphamN1MCsybnl1V2pEcHVpQXJ6?=
 =?utf-8?B?MUE3d05DcXM2SmljYWluRWxmTHQvYUc5L0QwcUZqdVVrc0l5YW41WnE1cXlp?=
 =?utf-8?B?aW83N0J0YXNBdEpoR0JkSUtxVlRnNFVVS245VGQyb3duMCtvTkFlVkVkbzFk?=
 =?utf-8?Q?NQfqffPsX53CFKl6275niDc=3D?=
Content-Type: multipart/signed;
        boundary="Apple-Mail=_475BFF22-2311-4207-B664-6FFB5E6C07DF";
        protocol="application/pgp-signature";
        micalg=pgp-sha256
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR05MB3648.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48547b1f-aa2d-4f05-06b9-08d9a27eb5b1
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2021 06:12:11.6120
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MbBW7DPG9sDp6wm5RrPEUgekBT0vOtfc5e3Eu5DSW75s1E9M8WEM7GFgRvsB9xOTAnZsmN9ep8svLBT9dv6rqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR05MB3647
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--Apple-Mail=_475BFF22-2311-4207-B664-6FFB5E6C07DF
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8

I=E2=80=99m going to send patch v2, with node_online check moved to =
caller (pcpu_alloc_pages() function)
as was suggested by David. It seems as it is only one place which passes =
present but offlined
node to alloc-pages_node(). Moving node online check to the caller keeps =
hot path (alloc_pages)
simple and performant.

> diff --git a/mm/percpu-vm.c b/mm/percpu-vm.c
> index 2054c9213c43..c21ff5bb91dc 100644
> --- a/mm/percpu-vm.c
> +++ b/mm/percpu-vm.c
> @@ -84,15 +84,19 @@ static int pcpu_alloc_pages(struct pcpu_chunk =
*chunk,
>                           gfp_t gfp)
> {
>       unsigned int cpu, tcpu;
> -       int i;
> +       int i, nid;
>=20
>       gfp |=3D __GFP_HIGHMEM;
>=20
>       for_each_possible_cpu(cpu) {
> +               nid =3D cpu_to_node(cpu);
> +
> +               if (nid =3D=3D NUMA_NO_NODE || !node_online(nid))
> +                       nid =3D numa_mem_id();
>               for (i =3D page_start; i < page_end; i++) {
>                       struct page **pagep =3D =
&pages[pcpu_page_idx(cpu, i)];
>=20
> -                       *pagep =3D alloc_pages_node(cpu_to_node(cpu), =
gfp, 0);
> +                       *pagep =3D alloc_pages_node(nid, gfp, 0);
>                       if (!*pagep)
>                               goto err;
>               }
>=20

Thanks,
=E2=80=94Alexey


--Apple-Mail=_475BFF22-2311-4207-B664-6FFB5E6C07DF
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEQe6bu7hIFElmsM7CGW4w8WwwaSUFAmGIv7kACgkQGW4w8Www
aSVfrBAAhPUXz2WK7kqGySpExA6fv8K501LUIITp0O4Eef+UeX3xFIq07/w/9GSE
tkHzwoAZ3r5a5LpGkQlITxZEOAKgIlMCie0ky6WYihBkzT/jIqDlywLSyL54xYrE
P3sTWOmJTlVjyDK57BkSfzwZqEFpzmc824wfQGVvFHjzn67wxK/Dr/43F8rVJY0b
qSjYOBkfxMf0lNMHbEr3koHVwjqkmsW7AzuUEGfhAjQNFZdPbd3ylClzXBilwv4A
1GrsZ8IxjOHTKuTkghuvVS6oG0GHEzAzVRSRQVtarEGrjFwlan+nGQJEDtNcNWxi
8PfKpo5kqAO0Yu0kvIAR0IHyg29Gv/4Kz78m9ivrnlS/RBjZreAx7Y+VGX9ZSunc
znXyh0xSI2rv8nde282gfuwtMn9GYyMG5JYqEbAN9iZmF54ZBbqOfCa4I9yh8QPZ
caPCZNJXxsm/m8f3zijCF9SwHUrq45WTxd+qqNU8Kp9NeToaF18Wchq5FQYQtsh2
AGs1vc7nePYNW7R3gWW48z2Tf1upq6d8B+R7C+dEb4TsUkWMam5HQZ+X1YbQVgr8
aeCormXZ1NmyNIln8/+ibWwaAdTAIB9rQw78SEYvhBcFmJPCJCvB4s6uDLqCLB8o
u0bG8Xmpgu+j1p4BYain9wCpcX+CdIKdN5VwrzafWvq/D0h3L10=
=oxZE
-----END PGP SIGNATURE-----

--Apple-Mail=_475BFF22-2311-4207-B664-6FFB5E6C07DF--
