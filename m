Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B7B146F390
	for <lists+stable@lfdr.de>; Thu,  9 Dec 2021 20:01:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229693AbhLITEk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Dec 2021 14:04:40 -0500
Received: from mail-dm6nam11on2066.outbound.protection.outlook.com ([40.107.223.66]:17761
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229820AbhLITEj (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Dec 2021 14:04:39 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iMoowcwX7gUeHxQWXDMR1RiSOqBVxjy+pZ90yYLzMfcemZLrKgob1AHMlLnZNAzZkRWMd8STf+xH/YmwukJl22bJ8CwKb2NoHLDZ0s3Fp/LlZikKoBGbiSt5Ic/omIfCeKRORp+JiYkgtwMt3jiWBIsKsietRhnSAhkRNIpIFuEZIyRji2w6ju5G40EGr+S2s3OtdN+IGSnWV9+lThSidT5AFNCAJcSXQ8o28J4OQOwEn9xbnuJv/3Ko9mceRXpdW8XOMhlMV80tJ7aSo16niyBrGdQuHiRKbpbiK8cpR23sFb93IpWyHgRpyshbagfHo7szhfiH4clIRo2FBerSVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7JdXg9MIePtgBQb87O98Fn1WzkRz0oZEKeID75shHpQ=;
 b=hzFys2n9awliHE38LSDJcqsTzdbfZFZq+25qZrXIDExhFnFAE7i1axnGLGLuL0qswepUU79oUQ/d6sTWiLz77dpBCcJoQZl6kkcRf4o7g0fr94LAlwi672jIkfQDdU10cCuT9zpJzk59G7I5g+OPQl0nfBRx+8r5+6f9318Bpp7M/4vSHNK4TDU9EfsCfILCRqqGdz2rfcRXuFlmAbC0hVhr67pXJX2zgdCLnJheBveWHd17L8A/mYb6nCEhfgsjnHWYbwbmkUXhvA5wW+t6KZb+VM9uKrK1lUKihXZvrubXr4h4Wlh8+ra6tqSCER3LvohvO/qok3x2G7eCwUawNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7JdXg9MIePtgBQb87O98Fn1WzkRz0oZEKeID75shHpQ=;
 b=CqQuHofxc2Mk/NK6oh6cAVWK/BN19WCmKzkH3I1XZmm6LscPW4b3DtcLRBxWqitcNqO++0513uPfZO8FWucaL+omIGuRhHHs6E6AUtk9nk9iOJPoGJTR+mgtbugH3thF9o1P5DlHvu2bN+qKAZgqtjPMXNiXKUjThptQU6qlDXQ=
Received: from MWHPR05MB3648.namprd05.prod.outlook.com (2603:10b6:301:45::23)
 by MW4PR05MB8794.namprd05.prod.outlook.com (2603:10b6:303:12d::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11; Thu, 9 Dec
 2021 19:01:03 +0000
Received: from MWHPR05MB3648.namprd05.prod.outlook.com
 ([fe80::6929:b34e:d8b9:70bc]) by MWHPR05MB3648.namprd05.prod.outlook.com
 ([fe80::6929:b34e:d8b9:70bc%3]) with mapi id 15.20.4801.007; Thu, 9 Dec 2021
 19:01:03 +0000
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
Thread-Index: AQHX1N5+lqzX5/9/hUCR9L+z9tfLRKv6c74AgAD9U4CAAB7tAIAADZWAgAnMHQCAAIIHgIAAufyAgAJfDQCAHgMmAIABcMIAgAEjF4CAAGztgIAAC/IAgAAHxwCAAAeTgIAAM82AgABcswA=
Date:   Thu, 9 Dec 2021 19:01:03 +0000
Message-ID: <7D1564FA-5AC6-47F3-BC5A-A11716CD40F2@vmware.com>
References: <YZN3ExwL7BiDS5nj@dhcp22.suse.cz>
 <5239D699-523C-4F0C-923A-B068E476043E@vmware.com>
 <YZYQUn10DrKhSE7L@dhcp22.suse.cz> <Ya89aqij6nMwJrIZ@dhcp22.suse.cz>
 <YbBywDwc2bCxWGAQ@dhcp22.suse.cz>
 <77BCF61E-224F-435D-8620-670C9E874A9A@vmware.com>
 <YbHCT1r7NXyIvpsS@dhcp22.suse.cz>
 <2291C572-3B22-4BE5-8C7A-0D6A4609547B@vmware.com>
 <YbHS2qN4wY+1hWZp@dhcp22.suse.cz>
 <B5B3BCE0-853B-444E-BAD8-823CEE8A3E59@vmware.com>
 <YbIEqflrP/vxIsXZ@dhcp22.suse.cz>
In-Reply-To: <YbIEqflrP/vxIsXZ@dhcp22.suse.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vmware.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 511e26c9-0f70-404a-e7d3-08d9bb463f75
x-ms-traffictypediagnostic: MW4PR05MB8794:EE_
x-microsoft-antispam-prvs: <MW4PR05MB87946D866F3C19CADA18FDC6D5709@MW4PR05MB8794.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DNBhFENpsB94QVWEeNgTZSB0DW1wQN2ZE3AA66cDK5tVuBZGg7F1Q4u7uDiuHp71cSUn3c+lxn3EPIXLcd+1l/1cpT5m0zaEnAgqz1+1pD0nOClDmlidz78JWL1ZxH9ktPUOQPsb5zPAuMYdccWeY69mPyqXzNGjxi4r7zDtq4CkH+Iiy74mcrKtZlgFEkiS641LVmXsRI4vweIX7b8yVzBuwGaT/E4vu8JaBjLNv2W1VGg9RFSoDiWFfFAqQD/dfJsHtXToxBCifGP5m6Yut5gstCL1oYY/Bobqzy4Nf2JsBJUpdxUZidj1FHmRnHCGFm6xWCwn/5BuxU32D4JJIrmYq22A0yC1huUdswob62UB4ZnPFTpUCCK3LMml6wZ9Pjh3u3TcVl1R0kNFqoryk/eKDjAHca7DFbjMYW0z99FTprH2W17J2r5sOEFDGrJjxh1/aC3WIco7ItPhitnmbEhH3jbfY7XkM1wGiRog0pRB/dRNVfUbHWjyj/X/snULr3xGZMnKNIZJn0SCWz4XKKsk3zANoymaegFXMsRFOgQCE/01kvfprYuVgmoTestGTdu2tiE/IHVjr8oGvKSKRI2fIveZXiHCwrgxM06bQA8svOvD9BIEIovjL/d3z825JMalm3//EHZfSr9/BuzmI6qcOYm9xERIQtUdklN718WPmyJrTWvY91oGCaDHtfG6Zm9RPoAEMmd2vvjHSP7v+zEjKQZpZ771mbDBgsa1HVK1TncyYjjTXtyth8+T+4JH
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR05MB3648.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(38100700002)(316002)(122000001)(76116006)(91956017)(99936003)(66946007)(71200400001)(5660300002)(83380400001)(6506007)(6916009)(66446008)(2616005)(26005)(508600001)(66476007)(86362001)(64756008)(66556008)(6512007)(33656002)(54906003)(8676002)(53546011)(38070700005)(186003)(2906002)(6486002)(4326008)(8936002)(36756003)(7416002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Zmc5Vm93bmhRR04vYUxVNUNRV2paMlhjWThJSTVnYTNEZXZnUCswNVZ3SStw?=
 =?utf-8?B?bU9MZll1VzZwZVpjTDg5MHNZZ0ZXK3paQ1RmREI5TndONm85bHdyZDFwUGtQ?=
 =?utf-8?B?aStRVHhvNFlqRG16ejA2Y21NZ3U5SHkzeXpGRFhqYkYwd3czU3lRNXEwSDR3?=
 =?utf-8?B?aUJ5Vm5ZZFJ1TTluc21KRVZSWFdNSDRheGtwQjVnSEI4VEpyeU1hRWN1Y1c3?=
 =?utf-8?B?V1J1UEZQSmpsSzVHaSs2dUEyNU1WQlVZdG9IOG1qYW1iQUFBMzNMemtXT0RT?=
 =?utf-8?B?T1Y4d3VxWFBDQUVrZGpVUEZuRk56Qkg4ZXVhNDB2V3J1R2xTalpwQzR2Zzh2?=
 =?utf-8?B?ejJQNGo5ekw0YUZMM2wxV3ZyTWt4Z1BNbzI4c2x0Y283WWJuUC94V085LzZl?=
 =?utf-8?B?dHRjU3QxKzhuVW1zY2pHb0R1YzZ0T2t1ellJM1hXMzB0MkM0dzAwblI3MFdq?=
 =?utf-8?B?ZjZiamFZcVo0UDNaWTFwZS9GYm9hUXo4Vjd1T3JMWlJEK2VnbUJ2OGJJNzhw?=
 =?utf-8?B?Z1ZkMTJySTRpSUo2azlGSjE2MWlOVVRKUHN4MTNJeUtHWTJQazNGUmp4cXhx?=
 =?utf-8?B?T0JlR1pBZEJGWnF5VGJ5SHd4ak5pcDNLQnBjSDlZazFrU0o2OURrR2hRdEUw?=
 =?utf-8?B?UU8yNFJVdU1NL21UVVRqRXZTdTBVbVcrZ21hWEpObkcrcDRvMUxtcHVMM2tl?=
 =?utf-8?B?KzhnV1VTTzZNc1N6U1JPZURoMndEeVV5cmFqMk0xVmtiUnE0NTIwVWNHSmk5?=
 =?utf-8?B?R3BSOG1tTnA5OStZenN0dzBieHgyNk1JSGZPc2dQRzh4RWxqZzNXa1pNR285?=
 =?utf-8?B?NEdVNzJtS2dTdVQybVMzaWw4ZFVjRGJ1OE5mV3YxQUdVKzFXZ3hYQmJRdWla?=
 =?utf-8?B?a0lIVGMwalZpdmZSS0cxdkVMSTNvNUJnTlkxU05rYlhuR2EydVd3c0tpNGs2?=
 =?utf-8?B?UmprTWVzbFZLSGg5RTJWYkhhQTFhVElFZm1Zam84S0UrZFdjNFJkQzlJdHhJ?=
 =?utf-8?B?NWlWL0pQNUF2eXJ0elRFZm13enZLL1Z0cEl3ZnRsUENMdGdjMTVWR2JQQ1Iz?=
 =?utf-8?B?ZGViZTNoa25JekZhWXRRRzk5eE0yMHU5ejQ3cGxmUDg3Q0VMbUs2UW9ubFp3?=
 =?utf-8?B?YzhVMk9XeWNiUTQzYTd3SDNhVjBFNUM2Tm5VS0M5M0ZIeEt0VUZnZEtCRlpS?=
 =?utf-8?B?bVNERzRVVFJuUTJ2a21NWWZuZkZ4MTJPTXl0dGpCTERHU1JBVnk3SlBQenFj?=
 =?utf-8?B?RUZVaTljcVZFS21wTWlETVI0MWF6QXo1ZEZjVTlzQnkwTCsvU2IzVlVKcmNK?=
 =?utf-8?B?TVhZL1d3RUhtZnZidkZhQldIajhrbUNMRnAxTGhIODcxSlZLYWNPTHFjWEtV?=
 =?utf-8?B?bTI0VWVId0hQUEtOc3c2UTZ5KzkrUjBKWXowd3V6OFBQc1B1ZzlnUTR0NGZQ?=
 =?utf-8?B?cDVCZThrMUxCMjFmeTJmcFRTcTZWL1c3ZEF0V2JDWXhOYkp2WVRpKzkwajVW?=
 =?utf-8?B?alhjM1dValRjNlQ2NW40eGw4YTFXQWRRQWJ5c1ZaaG9zdktHbjFDSHBHcEVk?=
 =?utf-8?B?SXN0bldhTEp2bTNpbkozbzdxZzZWanBNV2JDTytjUG5ydnpuZGVIVlN1QkI2?=
 =?utf-8?B?bjlRVDB3bTlGdSs4V3NXWTFGdnNLL2V4dmZGOFcvTlh1Vk9oTXltQkRjZDht?=
 =?utf-8?B?TWd0cms3VGxRYSsxVkVZa1VCQWdUeUsyTW9OOW5IK1RpQkFJa3RzMFRDNERj?=
 =?utf-8?B?TXNGem5HTnVtMnRJZDdISEZ0WXU5SkNOelVhYUJXeG1Pd1pLMWY1MGJKOGpo?=
 =?utf-8?B?SW5FYnBCclhRazlIWDFaTDRvODVKaW0wbkdaTjRnQzUwazdEUDlWNzAyZXZm?=
 =?utf-8?B?Rlc3NjRvQ0VFUGVlbFlGRERPWVRlU2YxMHQrT0IvVlQ0aTJRYitlaXo3YjMx?=
 =?utf-8?B?cmlqKzhMZmV6dVNoa0VySmtJUFE5dFR2SGNlVU9YWGdpZy93Tmtwd09HR3dW?=
 =?utf-8?B?NlBXWWpxSGFmelM0TVJrOHVCQ2pZa0YzNWNHWGRDUHhPK1JTSWplb1ZHU2Zo?=
 =?utf-8?B?djc1YktEdHRhRGI0L2N3K05HTzhvSlprcHhKd0d3dTlYbDlhSXM0N1lOdFh0?=
 =?utf-8?B?T3R3azJPbmplOGxtcXp3Y0FjblVidFQzK3ByUlBvSmdlU3VvMXRHRHJiQ0tz?=
 =?utf-8?Q?A0p2JRuSq7tzCaxQGbOODed6spcXw/ZkQ8cUeraPlDEc?=
Content-Type: multipart/signed;
        boundary="Apple-Mail=_1D71E1A9-1DBB-4BBE-BA3F-71DB1B8CB671";
        protocol="application/pgp-signature";
        micalg=pgp-sha256
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR05MB3648.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 511e26c9-0f70-404a-e7d3-08d9bb463f75
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Dec 2021 19:01:03.5338
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: whQZZliMdGmfQLav1s8e1VPEBwkCYFN6lpK6kY3ibKEkuHFJuMpTQhk6hJPF2oafNYocLwtvV+t+oys/JHQr8A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR05MB8794
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--Apple-Mail=_1D71E1A9-1DBB-4BBE-BA3F-71DB1B8CB671
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8



> On Dec 9, 2021, at 5:29 AM, Michal Hocko <mhocko@suse.com> wrote:
>=20
> On Thu 09-12-21 10:23:52, Alexey Makhalov wrote:
>>=20
>>=20
>>> On Dec 9, 2021, at 1:56 AM, Michal Hocko <mhocko@suse.com> wrote:
>>>=20
>>> On Thu 09-12-21 09:28:55, Alexey Makhalov wrote:
>>>>=20
>>>>=20
>>>> [    0.081777] Node 4 uninitialized by the platform. Please report =
with boot dmesg.
>>>> [    0.081790] Initmem setup node 4 [mem =
0x0000000000000000-0x0000000000000000]
>>>> ...
>>>> [    0.086441] Node 127 uninitialized by the platform. Please =
report with boot dmesg.
>>>> [    0.086454] Initmem setup node 127 [mem =
0x0000000000000000-0x0000000000000000]
>>>=20
>>> Interesting that only those two didn't get a proper arch specific
>>> initialization. Could you check why? I assume init_cpu_to_node
>>> doesn't see any CPU pointing at this node. Wondering why that would =
be
>>> the case but that can be a bug in the affinity tables.
>>=20
>> My bad shrinking. Not just these 2, but all possible and not present =
nodes from 4 to 127
>> are having this message.
>=20
> Does that mean that your possible (but offline) cpus do not set their
> affinity?
>=20
Hi Michal,

I didn=E2=80=99t quite gut a question here. Do you mean scheduler =
affinity for offlined/not present CPUs?
=46rom the patch, this message should be printed for every possible =
offlined node:
	for_each_node(nid) {
...
		if (!node_online(nid)) {
			pr_warn("Node %d uninitialized by the platform. =
Please report with boot dmesg.\n", nid);

Thanks,
=E2=80=94Alexey



--Apple-Mail=_1D71E1A9-1DBB-4BBE-BA3F-71DB1B8CB671
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEQe6bu7hIFElmsM7CGW4w8WwwaSUFAmGyUm0ACgkQGW4w8Www
aSW3Ow//aFW2gAqDAKuIEIsilC0kMe5NYxdEfxDily2EQerW6Bb6wvf5UY1+Mcr+
g2XpKssL62fVRHS3Ugr7WtJvNksK9O3EN2NQKS+oTANLNwVCe+uBWkBoxPOeptEm
SZqgEIg6/kqMVwm4+Ma4+pjMUIMq10K09Cj7beHT3Nlc+PUp2dPM2LyunC1JMmIF
xMAGpwebkBUQTAmOzmBNRVCxhKp/2XXE3Q42ZTneTPj6FHPeqLcc7pqHkDjVK6BG
Ly5nUIFG02NN7jT1ySj68Zm8G84Z73sOUN4+VgZKVPCLQbI6EoRSkNjOeluYQ+k6
z/Tfe6dup92WEUl50HZldf+sUygrd+F7TecAUrm2/MaVsPnhgC6dIRhLQxxRT+nr
/X8/14a8JtXIJvIlpWtwcHiEotBzDHggTs6M8q2gV/ZChsc64h2Uo+/5tCX4K4hX
7F1tRTNvAaSa85nn5ojiAw1XfJWrB4qdVD8EZ4rESHztzxDg8TrZ0mZqI2BK1uS4
OqJv50W0XpkhA/o2hWc7MpAbU7/+rIFmfO+vvw/yXVIPbXTaE4+iwi3ykEgk8+ro
7SF+H6pEN+C4anV/yGqNVtgeZP93HjKcK+cxnXoG0rfgcPrFtkEPUWt1vAmK0jGN
aGOVLOELq17FgVmI5AXf1DE9spoV6ZW3fFPnTzZSWC2XZ4nel/c=
=/qth
-----END PGP SIGNATURE-----

--Apple-Mail=_1D71E1A9-1DBB-4BBE-BA3F-71DB1B8CB671--
