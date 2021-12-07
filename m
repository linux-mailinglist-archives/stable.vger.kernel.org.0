Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AC6B46C144
	for <lists+stable@lfdr.de>; Tue,  7 Dec 2021 18:02:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239739AbhLGRGJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Dec 2021 12:06:09 -0500
Received: from mail-bn7nam10on2045.outbound.protection.outlook.com ([40.107.92.45]:36705
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235162AbhLGRGI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Dec 2021 12:06:08 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BTy+AUt7qACpiTx4nPI5Mi9acoCd3ugoF4xNbE7Fs/viSR8cLesCc96D6igJ8hkouzgATNWSGfyzv3nUhmOBXPWOAKUXQ8nl+YSj+9X+5zUSgsyagK073Ye6cNNTw7O3p6+oL4uTw6ospKfE89otqQ8SqrDtI6pOu+p++1e08CVzx8zcdh9kb/kSqQvyuSYUa5O4ngCo7rLXDzg7JeUyBHAVfOO0ETl+HYJHMbSWmdMZek4EMHmL26wevrzP2zK9H+3BQM1v6i240/oU4vU7r47XNI7YBfgrX9DI0Q/Hwux8DtvQFBLfvyrPCIXFtWX+V94Xvnq2lLtK6LfjDETbOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ewgBeKwKUXCpN/IxZkqyFMKsvYBT73z5J4G9ddIpUdo=;
 b=IZrKHL0ZHrZivzthA+uqa8qQ/KvPuCCtf6IPAtBgywnANcitbZ6c9Kf9miLX/QlzNgh3hUN3y7sM6UslPkajLRBYtw3js/LbpQvEB2wOv6Rbs9vXi4UXNfxKNJZFwRbgxRaV19eXdKRIIgI4FZKvS3na+s6x19tAysS6AffU8KjZfFwjxsHMaFtFtmReJ1enry5fMlDYo3ORajseNjqlDLBxWYbQtC1vupc8ZgtKFBoezJUF7Ks4IhhtArlbn1+md7dcpY9Pq1UmXIvjbSPuR5lJn8g8lg7BSZk+oxLff9sDt1J6HdUkjMVDcPiuo8DtzUYF1LIwqQxvAOKQ8ND6gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ewgBeKwKUXCpN/IxZkqyFMKsvYBT73z5J4G9ddIpUdo=;
 b=IrgXsuhyWtQT3VPQTvRT+GbS7QjVQBrAmuabnenHZhItB0fbjYVfCuvFLHMfDXRL2QD+3G1Qv4x+OwUNkGV+8HE6GJ658OwQCVfslw6b0N4QT54TDoACLKhHfay4DQSuUsWI75h/+0SIISw9traVISgHBgbhfrPaLrjG614R4LY=
Received: from MWHPR05MB3648.namprd05.prod.outlook.com (2603:10b6:301:45::23)
 by MWHPR0501MB3753.namprd05.prod.outlook.com (2603:10b6:301:79::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.11; Tue, 7 Dec
 2021 17:02:35 +0000
Received: from MWHPR05MB3648.namprd05.prod.outlook.com
 ([fe80::ad1f:5c06:a9cf:3dfa]) by MWHPR05MB3648.namprd05.prod.outlook.com
 ([fe80::ad1f:5c06:a9cf:3dfa%5]) with mapi id 15.20.4755.011; Tue, 7 Dec 2021
 17:02:35 +0000
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
Thread-Index: AQHX1N5+lqzX5/9/hUCR9L+z9tfLRKv6c74AgAD9U4CAAB7tAIAADZWAgAnMHQCAAIIHgIAAufyAgAJfDQCAHgMmAIAABAWAgAASAgCAAAQ5gIAADzyAgAAdyYCAAAWLgIAAAWYAgAAGEoCAAAPOAIAABOmAgAACrYCAAAckgA==
Date:   Tue, 7 Dec 2021 17:02:35 +0000
Message-ID: <2E174230-04F3-4798-86D5-1257859FFAD8@vmware.com>
References: <1043a1a4-b7f2-8730-d192-7cab9f15ee24@redhat.com>
 <Ya9P5NxhcZDcyptT@dhcp22.suse.cz>
 <ab5cfba0-1d49-4e4d-e2c8-171e24473c1b@redhat.com>
 <Ya9gN3rZ1eQou3rc@dhcp22.suse.cz>
 <77e785e6-cf34-0cff-26a5-852d3786a9b8@redhat.com>
 <Ya992YvnZ3e3G6h0@dhcp22.suse.cz>
 <b7deaf90-8c3c-c22a-b8dc-e6d98bc93ae6@redhat.com>
 <Ya+EHUYgzo8GaCeq@dhcp22.suse.cz>
 <d01c20fe-86d2-1dc8-e56d-15c0da49afb3@redhat.com>
 <Ya+LbaD8mkvIdq+c@dhcp22.suse.cz> <Ya+Nq2fWrSgl79Bn@dhcp22.suse.cz>
In-Reply-To: <Ya+Nq2fWrSgl79Bn@dhcp22.suse.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vmware.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 88a10127-a603-421b-d02c-08d9b9a35df4
x-ms-traffictypediagnostic: MWHPR0501MB3753:EE_
x-microsoft-antispam-prvs: <MWHPR0501MB3753C2D4A7D299B502CFD4A1D56E9@MWHPR0501MB3753.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kOj8eauXr/te1xnYNLdmosd5zu6E+1bRiLH9cpM2IrlQU19qOXuNR9XL3JVaBllATQOD5XaC6PZoZkQZeTSTOeW5lUoi2PNiGzExfLq33O5u4utoHkT6begUjWk0t+6s4z/4Qgs1qGB7aJ9qmAktKg/IGYmQZ5+oHRgjEPeDUs4WSDeA2q3bJLr00Qz4VqM1y8sJ/EA71hXPi9RLFrV7YsdTXpdMSgEJMwBw8kXXKg5j4f+EMZvxWPW3V2cZfJQID+PpPTD8y6yrc6ufEcdFXaqgQR7gtTix8GbZI9zxoVHUY2pWi4UTF9BGOrigYxGExnSM0jqjkdPvKDwrgvpyQRLs8ydXEHgiLmPl9e5ju1Rxqw9HZN6adipb8o/m/gVDz+oNJSLVt948evdfy9KYlKCmpFqXVm7itFmabsBT24NK4r9u7niE/P2KTjl1N1ix4jVdAJpxOdk3GiCVvEZf1KCglkycVqSH3mmMzAbaZRuGsuYz+dqOuTaoPDK606Va9edHxUiSJtm8/HX2LH3qhCHueUzHuNsgJsG4cA7YUMrd8Mq2oY3ZyX7e+TIRYiS49Lv4izdPNnO6DkbVulSSTa3wZgLgthd6EZtKo6w+ScOE84iOybsHZYZGSrB0C1sVdsrovqUSGUsgIcEZHHfQ89IpixKjcWbiXd3VRFZ6dXjgKycqC01PblHG4ejIay1OrR6oJYwGO7Htc4XsOFvPiZgfn0DzIrHS1oCk+A+CTxfNnrgoYbeaBf6wyEBa22JU
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR05MB3648.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(122000001)(66446008)(64756008)(66556008)(66476007)(38100700002)(6916009)(316002)(99936003)(76116006)(6486002)(33656002)(8676002)(91956017)(36756003)(508600001)(66946007)(6512007)(71200400001)(2906002)(53546011)(6506007)(86362001)(38070700005)(5660300002)(4326008)(186003)(83380400001)(54906003)(2616005)(7416002)(8936002)(26005)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QlViZWVsNFpVRnRWZTk2eVFSTWtrS2M5bUVwbUg4K0xLZC9vNkxPQy9GZnFV?=
 =?utf-8?B?MGFNVTBnRzM5NzdMTk1zN3JkWHBhWnVoM1F4MDF2RUdCdDRZTUd4TnF0cS9D?=
 =?utf-8?B?M2NaRkt0S1lxa3E1V1FQMncyWUNsUkVORFpWMURONytKbWdQNWFWN1F6T2h6?=
 =?utf-8?B?ZFVtZDVjdVhBbmFDajV1Sy95QTZBVWVRbU5kYTBta0ZmcDk0dnh0SWtUdHVz?=
 =?utf-8?B?OVMvMXl0YzR1K0gzSXFYdWo4SXdZZk82YkVlY0Nrb1huNHBPRUxyMDZpb1dz?=
 =?utf-8?B?QVRRNWROKzk4aDhybGlDbzhBVmZDeDB6Yjk4SnB1V0w2Vyt1eFBqOHA2TzRo?=
 =?utf-8?B?cDVvZVM5TEE1WXVpM2NnK1VWNkk1RW81U3ZPLzc2TmtHQVNGYWQxR3plN1FV?=
 =?utf-8?B?bEYvQkZFRnMxWExkUURSdlBHWmRRcXI5aSt6TDlHalhpWnRrYlNWTFJRaCs2?=
 =?utf-8?B?ODI1NkorZFpST3hIM0NKM3lnWlV5Nmc1MWd6R0NKSkpQZ2xOWEhmUkRTeHRI?=
 =?utf-8?B?ZTVyRVByMFlIdUFUSGNuMEhhd2hrKy9Ranh3V0JFZjJNV1RJRkgrWThSM1ZQ?=
 =?utf-8?B?akFEUW91NzFMek56R3ZsUHg2Rm9WWmxOVVZhOVRncnBqU3JUS2VRR0w4dXN1?=
 =?utf-8?B?M3ZYWjd3L1lEQWlCRFJGUVpNQ0J6QmljQTFFN2syL1BsL2VtVzRyY1ZFZkhr?=
 =?utf-8?B?bDdjZnhteURMNjAwQmIwWG1OT1Y5L0JkS1AxdU5kWTdLOEYyamJ2dXFNMzhu?=
 =?utf-8?B?MjRnbUx4ZnR1VjZwcmV1anlESmhqdHZJOE5vRkM1VnhQT1E0c0tiY1poZGIr?=
 =?utf-8?B?Sk13SXZFbGhNZVY1VCsyQjRUcFlBMVBOL0g5VVNMU3Y5SzBRNzhWb3ZZdVRu?=
 =?utf-8?B?bG1STU5FQlRQOWFlUUphUCt3RjNkMzUxZTh5UE9VbHkzVkN4bmpqT1I0WGlU?=
 =?utf-8?B?VDEvRjBJdkRYWnFqa2xtME1Fei9SNVhNRXV3QmhCWXVyTlRmTE1JZkxvVmtm?=
 =?utf-8?B?U05CTnhDUmg4MEYzUTBUR1FvQVlxVC90RG50Tm1FaWNRejZKdUZvcGlnTmpC?=
 =?utf-8?B?NDYvbVRxcDd0STRkbEFqNXlVdTNLZmR6eWlqY0V3NnFuU1JFNGRwNmhtdG9F?=
 =?utf-8?B?d09xZDg5aG9XVXRLRzRSdjlLbGNuejFERmVldXQ4RzFlT2RLazhraXZxeTNP?=
 =?utf-8?B?cFQvcDVSNE1wUXZyRWtVWElUMC82eWMraWE4emZ0SVlUOTZoVkRhSVBPUEpY?=
 =?utf-8?B?Z3k5bGJUYk9YNklKUk5OamZBbnRHZnN4bDRLcXZxZ1pOcjhtWEVmRHlxMEhm?=
 =?utf-8?B?eFFTdWJidENNdWdjRDh6NUJFSWJvSEl5Um1sY3M3NFRyQTg3cUI2WmhHLzFZ?=
 =?utf-8?B?RHFaTGxLM2hnaDRQSllSZmphUFd4MjNQWGUraW1xV2dUaXpWWGNNQlZxTndp?=
 =?utf-8?B?THI2a3lLcDVkTTF5YTI4TTFDbHJMV2gwR1dTMDBkQ05KUHJpRFRIZGlNbjF2?=
 =?utf-8?B?Z1FSRGc2b2V4eHRRajJwc05vY0hteHpZYTd4TUdDajFwV0dlM3RZSnZ4Skx6?=
 =?utf-8?B?TjU2VkZ4aWI4cEVxcTZGbnQrQ1Vwb1lzbkxRM2RqVE90aURuN0VycXZnanRG?=
 =?utf-8?B?N1JpbkNoNC8ybXg3ZW1QLzhQZzZwUElyU3R2QXptTjRNYzlvVUtlZTA1ZDVU?=
 =?utf-8?B?aWFOMGFWRThtQVRGZFYvdll2ZXNnc0ltK3o4aVNqUTRXYUlOQzlqQWNTZkdE?=
 =?utf-8?B?am80WUtRN0lJSDI0NXYvNk5nUEVBcXZkY3RObVRMWWJnRlRxNHJyNVhmekk2?=
 =?utf-8?B?VERqTlRhUEVZS212YTN1TzVwK20xTEk1NzZRc284bG1xTktwY003SG4wWVBN?=
 =?utf-8?B?RHhZWkZFSGpDZ3E5bVpOallqUmRhYmVjSDdSczFBK1VZVFdNZWpYaW9IVXZk?=
 =?utf-8?B?b0NyS1RhdWZRRTJFNXhuMGNqMFlyQUJESUl3TS9xNnZPeEpBL2RXdnRHT3pU?=
 =?utf-8?B?ZW0wWmxtZVhIbGpQa2tIY1pUOVpkTEtUaG5ueUFYZ29jeHJ1RVJQbVBZbVRV?=
 =?utf-8?B?UnlIMUFGcmRFWSsrRXhUblUyRjlDZk9oNXNmN1hPa3REb0I1VDlIQjNTL1dL?=
 =?utf-8?B?U1lvSVA5ODUzdnhXWmJZVDNXc2dIbFFQMmdMcVRGbk9ncWdPOTBiOEhyeVVx?=
 =?utf-8?Q?yHMBbqLZmSjBtYXQE0VPFjY=3D?=
Content-Type: multipart/signed;
        boundary="Apple-Mail=_EA2B0AC5-AE23-4BF8-89D6-DA8355F45385";
        protocol="application/pgp-signature";
        micalg=pgp-sha256
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR05MB3648.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88a10127-a603-421b-d02c-08d9b9a35df4
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Dec 2021 17:02:35.6143
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5SCMDVMN9xUbuOcOXoz2K2dLKYpEXj47e7Is1/1VO0I2Z2lOfzTOF70fTn19+CodYFSKKosk8Eu+5hIjRuaEEA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR0501MB3753
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--Apple-Mail=_EA2B0AC5-AE23-4BF8-89D6-DA8355F45385
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8



> On Dec 7, 2021, at 8:36 AM, Michal Hocko <mhocko@suse.com> wrote:
>=20
> On Tue 07-12-21 17:27:29, Michal Hocko wrote:
> [...]
>> So your proposal is to drop set_node_online from the patch and add it =
as
>> a separate one which handles
>> 	- sysfs part (i.e. do not register a node which doesn't span a
>> 	  physical address space)
>> 	- hotplug side of (drop the pgd allocation, register node lazily
>> 	  when a first memblocks are registered)
>=20
> In other words, the first stage
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index c5952749ad40..f9024ba09c53 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -6382,7 +6382,11 @@ static void __build_all_zonelists(void *data)
> 	if (self && !node_online(self->node_id)) {
> 		build_zonelists(self);
> 	} else {
> -		for_each_online_node(nid) {
> +		/*
> +		 * All possible nodes have pgdat preallocated
> +		 * free_area_init
> +		 */
> +		for_each_node(nid) {
> 			pg_data_t *pgdat =3D NODE_DATA(nid);
>=20
> 			build_zonelists(pgdat);

Will it blow up memory usage for the nodes which might never be onlined?
I prefer the idea of init on demand.

Even now there is an existing problem.
In my experiments, I observed _huge_ memory consumption increase by =
increasing number
of possible numa nodes. I=E2=80=99m going to report it in separate mail =
thread.

Thanks,
=E2=80=94-Alexey


--Apple-Mail=_EA2B0AC5-AE23-4BF8-89D6-DA8355F45385
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEQe6bu7hIFElmsM7CGW4w8WwwaSUFAmGvk6kACgkQGW4w8Www
aSV2xw//dRGhvzXrBeA4B9VqqcxQwJ8u0PWUj7xY+bLBdIQDeP3qy0wwbl9N9AN4
upnS6DkIW2y03otM30hNcDruEqr93o0oZlq03cW1kHoap3lOKLW3/ISDwlbZARrR
4EOSfeHyb/3YSTToaOaRJm6Mq8RitypM6E+Y6aNPJaSoMcWbuZfRlH0y7j+Fnh0+
BYrNYfFHS5zm2HQ5BL26KWTuSDeGyBlq736gMyEaKh/tuJTH/x3AdJRLCwiOjUpF
doqPtSft8jc5WE3HVYUWy/uEkx7psQ7cKxEn7WcncA/1J1wPiUgWTaAsSLebS8uv
K6oMBjrH0LbN5AzltDrQFY5oMwVDMnj6oQ1j2Vblgffv00BeVYMx16STxVoilJU2
D6PEeB87vry9HmAnST0nDpSSydnVafZpUVmffubBVSuGwntDuRJGI7tFcvyeV/Kj
18SvC1oWJX6/7QA7WA8TajKCNFiVWdt3sGdKHKoMlKm1H8CXm4eIOj5Fh+ke1+/S
KKZtdSqD3tLu0CNGq+dcYaueWyQ+0xLq7V3RNILD3Ug9UMkdMJ2zJYGwB7wssc1P
kHpGloxjMCPakhvaETusvwAg7ZMOp0I8kmlmmcaKU41PFUYkaQiAE24Vyax2aog4
ENmJ5IdpYz0vihfiszspJhsTQxdMiakibrk01fUszsQ5sHLT/Rw=
=eM6Y
-----END PGP SIGNATURE-----

--Apple-Mail=_EA2B0AC5-AE23-4BF8-89D6-DA8355F45385--
