Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 929C7453ADE
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 21:22:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229456AbhKPUZv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 15:25:51 -0500
Received: from mail-bn1nam07on2083.outbound.protection.outlook.com ([40.107.212.83]:62597
        "EHLO NAM02-BN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229955AbhKPUZv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Nov 2021 15:25:51 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jJ6CH0wdoO6Qgbl3TaA7BYJKzqabXdG82qg56wUQLdB/PxPZQwwlRtyunb47sw7mmaVlLm7qOXXsjv3aWr781a/6gWvsXhOFezsVLUZIIP/o8vTpCrHxY+rGVAQUiEfWB9s0ar1bKqaIUQ4cQYFBwzM6aKE2WJuqDz8TgN3n1ozKTu1SyCqF58LWMGfgY0wyelAJg7XcNLS1VxiymURyzjWdNsuFbfiz5EAS1ygddtgdAP4+qASfXUPBhr8lNIJ4wKgGe4i4rOHkvRtpcQdyY3Epks3kDKaEWwcBYl4Beg/jDCpavy7zRVMj4ZvonE0bBbrezSxdk69O5Z2F12/oQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xz9CG6xelug1mpCjZVVBeeguOKyomJIamvHi9I+MjsY=;
 b=AkNLQzs5cGeQJ4UJw/3lVLsjzZTaVUW/izfuJLJpQ1+4fJpft/nWBaM9yof+FlFDG948Q3Rq9eWuTmlj4oyLKEOav1gEZ0jkltRq4dZXVnd+8LoMp9DXV2YmXwHbo+mvw6pw4HFYEmIX1uoaA6xXMVglrF51Llr/llIjsWFcuuVjznViFU8mq0iMuB/ZkmEP0rAeVOLu9j0bcR8um4hXUGh45cH5iwtU41UKyo8D/BAIYXT4pbpGKfz+IcXcq4F3B/Qi6jfaV25Hol/vmQS96CCVEAdhxD9x/RL4JIIQxcHqKonzBkguTC+xKbGk0rtFc1tOVh6MKd70aZnJI6sZ2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xz9CG6xelug1mpCjZVVBeeguOKyomJIamvHi9I+MjsY=;
 b=ak0mtTZwIKNTaLuCjlQIMYq3Djv1n5wLdazoPfdz+bslB14D0cFwmfhEqN0kgQaIXztkz1xa6KeWQGTFRAmiUeSlbb1RgVaX+dSIK22Q4xx499JT0z3cwVQkeEXpd7zF5RepDoLDVq4+T96O2P0ApmMbgIasBHHIeNefUfPuyRI=
Received: from MWHPR05MB3648.namprd05.prod.outlook.com (2603:10b6:301:45::23)
 by MWHPR05MB3566.namprd05.prod.outlook.com (2603:10b6:301:45::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.12; Tue, 16 Nov
 2021 20:22:49 +0000
Received: from MWHPR05MB3648.namprd05.prod.outlook.com
 ([fe80::d871:f5de:8800:46dc]) by MWHPR05MB3648.namprd05.prod.outlook.com
 ([fe80::d871:f5de:8800:46dc%4]) with mapi id 15.20.4713.019; Tue, 16 Nov 2021
 20:22:49 +0000
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
Thread-Index: AQHX1N5+lqzX5/9/hUCR9L+z9tfLRKv6c74AgAD9U4CAAB7tAIAADZWAgAnMHQCAAIIHgIAAufyA
Date:   Tue, 16 Nov 2021 20:22:49 +0000
Message-ID: <5239D699-523C-4F0C-923A-B068E476043E@vmware.com>
References: <908909e0-4815-b580-7ff5-d824d36a141c@redhat.com>
 <20211108202325.20304-1-amakhalov@vmware.com>
 <2e191db3-286f-90c6-bf96-3f89891e9926@gmail.com>
 <YYqstfX8PSGDfWsn@dhcp22.suse.cz> <YYrGpn/52HaLCAyo@fedora>
 <YYrSC7vtSQXz652a@dhcp22.suse.cz>
 <BAE95F0C-FAA7-40C6-A0D6-5049B1207A27@vmware.com>
 <YZN3ExwL7BiDS5nj@dhcp22.suse.cz>
In-Reply-To: <YZN3ExwL7BiDS5nj@dhcp22.suse.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vmware.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 205ed46b-7875-4cb5-127f-08d9a93edbe4
x-ms-traffictypediagnostic: MWHPR05MB3566:
x-microsoft-antispam-prvs: <MWHPR05MB35663E32FE0FA49AB354A60FD5999@MWHPR05MB3566.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2887;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +rFrFwUM1055APInQ6EpAwX0Tq9rfMpxSmLX7ZMSN5WMAE6ygN1SYy7vxLZtk2t+MAEN/op7fHctkP7k2oVP+lxmnhm3jNVBTHCOshBNv5N5Wv/ecBkYQs6NNcjaFtgNX1Io6hxlDfveD7yMyntyimzMr+MCaVsQ/K5IUyR/H4XokyD1fgkSv3LY++e05oviNmYg+nakbEPlik95iM5RRoyLpI+gTeJUkTBC3H/0/xjjPqZ4qAY7fe7TH9D19sPll4FNkEMIyE8VXk3Lri7W66Rgg/6HHA4xRj094WmQ062SerkIj9uXPtsWO5g1DXUmXItsJXY/Ezow70vo4FcuG0hJqCZQYlfRCiZ4lhM62WwuhqWDCXacoGkrMUIW1wwPXhq4tm2gAUE/ocxzaNAMBzAEaCQjUOlX9rv+cVdJqDMweIyCsO1Y1zuje30loNCYxPPQ7nu6Oe3Sz+JeWcTImLpQHHP/0MECtOo2IIvNGfaElPN+vV7umAiwPUSocv1ZaYmnbN1XtgU158ibViknLnXZqHyoHBjtoW5Q1996x0EbrOjgjb+AFKfJ03RYVKkmDh+A4HAhafO+1vKiyh5lBKufwTOw+zi67aMXv+W1j1ekUK9sEziN/49A8n8hMnnKUwJOKzCQW+FmH5Sl+BRNzG7UfBQYM68IpHp06jvP0jaRUs1L9zuHEaPfhcWKZkoG8HoCRDyaKtT+bOXVKv11XvQSgdyDvRmBj2NljP9idRtOuorz7/8nPbDnNfS8szQ1
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR05MB3648.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6512007)(6506007)(53546011)(83380400001)(122000001)(8936002)(508600001)(7416002)(8676002)(99936003)(38070700005)(36756003)(33656002)(186003)(26005)(86362001)(71200400001)(2616005)(5660300002)(6486002)(66556008)(66946007)(66446008)(64756008)(76116006)(66476007)(2906002)(316002)(38100700002)(4326008)(91956017)(6916009)(54906003)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ejNkMWtrdVdyWGZJMkEzNUd3MEpWdjE5d1lEWmlVMTFSUjBReUpFbjV1SXdx?=
 =?utf-8?B?NEM5QzBjYkdua2tyMDVacjRqUmg2WVFxYTM0WTF1RE1kcmR5cjNleWtWMWor?=
 =?utf-8?B?MWZUL082S2QxNVZHTFlxOTBYUFVjVDFGSmhDYnNVVGUrSUloMHdZVkJJMWlC?=
 =?utf-8?B?YWZaN3MyV3pyeGU3RUd2Vk02bWxZUlZ5MDM5RmtFSXFKN2ZORklRMEJzOCtO?=
 =?utf-8?B?ZXBPVk5zWjVyK2xhcnFTdHdDWEl2NmpCQXNwcVRBcjk3TE51OFF3UzhRRTZv?=
 =?utf-8?B?Y2RqYkwrSmZ4ZHhOSWZiZFZ3QldPbmFwQjh6YzdRQUF6NWlRRFFSY0NtVXpy?=
 =?utf-8?B?S2g3VGpva2x4ZXovRkp3cVJFL09xUERRckNndmJvOHhFSHNqQVNsdGpiZGJS?=
 =?utf-8?B?QkczU2NPRUs4QkIxQ2Z3N2JicThqSDZTVytGcEdzTG9HVHZqUVFFZ0p0SDIr?=
 =?utf-8?B?Zm5xUGZ1bTg0WkQvMDdnb1JONjFMUC9ScFZsUktIS1ZNNFBmYm0rb0NpWlRw?=
 =?utf-8?B?M1pUaVczREhPN2c2aDdySGk1RHNtLytzYlZJakpMZzVZMzF2L1FUOWVEL0pX?=
 =?utf-8?B?cXlPVFFYMFVSdHNQUmNaaVFRTkhjOGpadnpKdlFES09LY1pTcWtJMFoyU3M2?=
 =?utf-8?B?Z0ZjK1hDM28xUUVGSTRxUDN0a01Qb3hvTEJJSHNXcGZWSjdFN2svUkE0aU93?=
 =?utf-8?B?b2hvRitHcmRJSU04YnFwMEd2SHBXOWMzWjcxaTF5Q0VweVNJaTVHckpxaDN4?=
 =?utf-8?B?cEh1c3BWYnhKMlFYbE1uZHl0eGI1Z2dCU3p4cVhUUXhCbFJKTjNRV2tpYmlr?=
 =?utf-8?B?WEd1MzVVNEg3OEJZd0dNOXUrME5DM2RFd1B5T2g0R3RSWGtzcG1iWkJXM0JV?=
 =?utf-8?B?R2tqOE9DZmtHSTVWaDRzU3FIMk9JcnYyRUxZdjU0TWIwRGRVZHQ1ZWRPaXVM?=
 =?utf-8?B?SG1tQjJ2L29KVnN5MDdRWldZbi9kWmFxY3IrbXJXNDZtd0V1a0JZc2lHaGJ1?=
 =?utf-8?B?elpRSml3Z3B5a3I3WXAvWllabHd5QmdHL1I5M2RMZFpOYzdhR2JVdFhBUkg0?=
 =?utf-8?B?Snc4SmlkTnAvNWI0ZHVSUjEvbFdUSFg3V0xrY3d1am56bkYzcU9Sd0ZhdVBT?=
 =?utf-8?B?eE1VcGVoN2VFWExiTXRvOUNyNkpEN0t1OXNlVU5zSTBUNnhzRklEcFIvSXZa?=
 =?utf-8?B?QlljaExlOUx0ZmlkUS9ITE56d0FQeVZ1ZU43TG1seDM4NHVuRXVrc1U5ZUda?=
 =?utf-8?B?c2xxL0FCbFk5eEdSMHRVSjVRYWxFNVpqbWlSZkFvOWhKSTZRUGpiYi8zZk1k?=
 =?utf-8?B?Y1hmYmxzZFYyUXprTk1sTGtmOTRZSGFsZHhmT3NTcVg1d05GV0R2dzFENkRH?=
 =?utf-8?B?QkRLaXFnQUs5djZJZHViS3RJVWN5V0JuN2ovMHJrbjYvRzg1dWNubGtIWGxP?=
 =?utf-8?B?UWhVblRKeDFob0xadUZkWEYySmhHMTdST2hadGxDVlRZRjI5T3NWSUxXV3VI?=
 =?utf-8?B?dTVJOVFaQStjVnNxUFBQZG9hZDBvVnd0dHRwY2h5U3ZDa09wU2lCcC9Bb09J?=
 =?utf-8?B?ckN1V2xDSXRDaVJzWEx3WFVHczF4NDVEMWJ2cnhYZkg1NFAzeGRxNzBEbGc3?=
 =?utf-8?B?VHFIaGJoeDNtcERtNTVWM3Y2QzV6OWl4N3Y2UlV5K1JrMDY4UlEyTFZXcmor?=
 =?utf-8?B?bkx0c04vWmo2dHowLzAwbC9HZUdKaUlNQkhXb3c1cW5QMm9zeTM3elozZ0xG?=
 =?utf-8?B?dzJ1SlcwSDEzSnI4YlE4blY5TnJ0SVRNSUJwQ2JvRXczVFN1ZXBGYllXWFcv?=
 =?utf-8?B?bDExNmp0c3NXdEtORkF2NW1SeTJlRWFveEMwaEp2MWpNcmhkSHdXNUxuNTgv?=
 =?utf-8?B?ZnFGbWFVcmhneXhhektOZVp0b1lHRFBwUHVZN1hUWjdqTlk2Q21jSFRPY2Nr?=
 =?utf-8?B?aVdBQ0E5UmJMWTRjZDE1UHFUTnpEYzRtb1lNRnJpWlY2czZ0OW1LcUZwUHli?=
 =?utf-8?B?L29xUjJaZyt1cEd0SmJEWEtKamU1cmJUN0tHOW0yclRsUkdsdjMwZVk5N2NB?=
 =?utf-8?B?QTFxemE4SHJVOEZxNEpMOVcrSEIrRGc4SGxIWG5WVEVFUEsvQ1Vva05mdVln?=
 =?utf-8?B?L3lMR2F0RWk5dmRxbFpnc05Zb0ZselhIdDYrckRKbzZVL2M1OWU2SWduU3pr?=
 =?utf-8?Q?5fbq3ElrIeta1r7mkcqmPEU=3D?=
Content-Type: multipart/signed;
        boundary="Apple-Mail=_A9D5E52F-CD13-4CFA-8FAC-D8A4D3B725A0";
        protocol="application/pgp-signature";
        micalg=pgp-sha256
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR05MB3648.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 205ed46b-7875-4cb5-127f-08d9a93edbe4
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Nov 2021 20:22:49.0700
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5n9ifsxoz+IIlp6ft/S6cdTiBbqtLwAILuXJIkmMN0BZ40zqtRmFwfXKYv+KcQJjUqDfj8JEW7SzXOvBI1c8ww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR05MB3566
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--Apple-Mail=_A9D5E52F-CD13-4CFA-8FAC-D8A4D3B725A0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8



> On Nov 16, 2021, at 1:17 AM, Michal Hocko <mhocko@suse.com> wrote:
>=20
> On Tue 16-11-21 01:31:44, Alexey Makhalov wrote:
> [...]
>> diff --git a/drivers/acpi/acpi_processor.c =
b/drivers/acpi/acpi_processor.c
>> index 6737b1cbf..bbc1a70d5 100644
>> --- a/drivers/acpi/acpi_processor.c
>> +++ b/drivers/acpi/acpi_processor.c
>> @@ -200,6 +200,10 @@ static int acpi_processor_hotadd_init(struct =
acpi_processor *pr)
>>        * gets online for the first time.
>>        */
>>       pr_info("CPU%d has been hot-added\n", pr->id);
>> +       {
>> +               int nid =3D cpu_to_node(pr->id);
>> +               printk("%s:%d cpu %d, node %d, online %d, ndata =
%p\n", __FUNCTION__, __LINE__, pr->id, nid, node_online(nid), =
NODE_DATA(nid));
>> +       }
>>       pr->flags.need_hotplug_init =3D 1;
>=20
> OK, IIUC you are adding a processor which is outside of
> possible_cpu_mask and that means that the node is not allocated for =
such
> a future to be hotplugged cpu and its memory node. init_cpu_to_node
> would have done that initialization otherwise.
It is not correct.

possible_cpus is 128 for this VM. Look at SRAT and percpu output for =
proof.
[    0.085524] SRAT: PXM 127 -> APIC 0xfe -> Node 127
[    0.118928] setup_percpu: NR_CPUS:128 nr_cpumask_bits:128 =
nr_cpu_ids:128 nr_node_ids:128

It is impossible to add processor outside of possible_cpu_mask. =
possible_cpus is absolute maximum
that system can support. See Documentation/core-api/cpu_hotplug.rst

Number of present and onlined CPUs (and nodes) is 4. Other 124 CPUs (and =
nodes) are not present, but can
be potentially hot added.
Number of initialized nodes is 4, as init_cpu_to_node() will skip not =
yet present nodes,
see arch/x86/mm/numa.c:798 (numa_cpu_node(CPU #4) =3D=3D NUMA_NO_NODE)
788 void __init init_cpu_to_node(void)
789 {
790         int cpu;
791         u16 *cpu_to_apicid =3D early_per_cpu_ptr(x86_cpu_to_apicid);
792
793         BUG_ON(cpu_to_apicid =3D=3D NULL);
794
795         for_each_possible_cpu(cpu) {
796                 int node =3D numa_cpu_node(cpu);
797
798                 if (node =3D=3D NUMA_NO_NODE)
799                         continue;
800

After CPU (and node) hot plug:
- CPU 4 is marker as present, but not yet online
- New node got ID 4. numa_cpu_node(CPU #4) returns 4
- node_online(4) =3D=3D 0 and NODE_DATA(4) =3D=3D NULL, but it will be =
accessed inside
for_each_possible_cpu loop in percpu allocation.

Digging further.
Even if x86/CPU hot add maintainers decide to clean up memoryless node =
hot add code to initialize the node on time of
attaching it (to be aligned with mm node while memory hot add), this =
percpu fix is still needed as it is used during
the node onlining, See chicken and egg problem that I described above.
Or as 2nd option, numa_cpu_node(4) should return NUMA_NO_NODE until node =
4 get fully initialized.

Regards,
=E2=80=94Alexey



--Apple-Mail=_A9D5E52F-CD13-4CFA-8FAC-D8A4D3B725A0
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEQe6bu7hIFElmsM7CGW4w8WwwaSUFAmGUExcACgkQGW4w8Www
aSWD0w//e9gUC5fPuCNWoXK5dSLWAE1mOkktuLz+IlB3HYrJQWFvN9/OXVjk+1g5
mGO6gqzZJhsfsJgzKXxALABNL5+ztRGtCrSKVeCpCH5LhFOdldyUMgGfZkOrX9RK
sBVLZuv8FMW1OEr2cyA/IyYtygqq1s00wLp8THMlmDiUPJlUV5WBM/MNsqAtqd/T
L7WEemwyPNVIPLLcaNPojsdFncIe/e7E5KLuxKm7/s6GWdxTqjwKkGRfp/4ag+zY
bcM3e4Sk1TqZnD0sr0bz69QsKl1D+WRLsFqZv8TOqCGmbYqvXsWz9wXvrRu2Valu
umb4RuSbWbrRlHBZ0CYbXGacX/2pKej84sKnkZmzaqZSv/+9dJhMdoBy7gDeH034
u8amS7HqJCYspjtZvJZlmoW0bD/8kP7eGkt7mUnSObMnDDcZ6lFKUkyUJMiVxTeD
4nwPPIFBswv/AyiINSK8PlYcfjT0x0rs2KXrw2KS5SWmkh8JwY4vJTj3ocoVz+oG
SJh7fQuAAzvbycakRS8Gy/g698O/i8XDV5djmtRUJgNECE9DtymOMYxBfBYAykD9
xFK+hHSEofnDvZdYYC5Gei7wlADyLyXj7ixhUob/VJnjDU5LDEs/Tl/sbgunbqwX
HhA+awO87Yla0Fz+wlCaXWtj/G9zDlbcxMBzjcYuifK0rdL6ATc=
=O0Z0
-----END PGP SIGNATURE-----

--Apple-Mail=_A9D5E52F-CD13-4CFA-8FAC-D8A4D3B725A0--
