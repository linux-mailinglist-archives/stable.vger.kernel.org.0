Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12892109B45
	for <lists+stable@lfdr.de>; Tue, 26 Nov 2019 10:33:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727388AbfKZJdW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Nov 2019 04:33:22 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:48184 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727275AbfKZJdV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Nov 2019 04:33:21 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAQ9WFWL002413
        for <stable@vger.kernel.org>; Tue, 26 Nov 2019 04:33:19 -0500
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2wfju971np-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Tue, 26 Nov 2019 04:33:19 -0500
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <stable@vger.kernel.org> from <borntraeger@de.ibm.com>;
        Tue, 26 Nov 2019 09:33:17 -0000
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 26 Nov 2019 09:33:13 -0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xAQ9XCf021037316
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 Nov 2019 09:33:12 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7352BA405F;
        Tue, 26 Nov 2019 09:33:12 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0CF99A4060;
        Tue, 26 Nov 2019 09:33:12 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.145.22.13])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 26 Nov 2019 09:33:11 +0000 (GMT)
Subject: Re: [PATCH] mm: memcg/slab: wait for !root kmem_cache refcnt killing
 on root kmem_cache destruction
To:     Michal Hocko <mhocko@kernel.org>, Roman Gushchin <guro@fb.com>
Cc:     linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        linux-kernel@vger.kernel.org, kernel-team@fb.com,
        stable@vger.kernel.org
References: <20191125185453.278468-1-guro@fb.com>
 <20191126092918.GB20912@dhcp22.suse.cz>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Autocrypt: addr=borntraeger@de.ibm.com; prefer-encrypt=mutual; keydata=
 xsFNBE6cPPgBEAC2VpALY0UJjGmgAmavkL/iAdqul2/F9ONz42K6NrwmT+SI9CylKHIX+fdf
 J34pLNJDmDVEdeb+brtpwC9JEZOLVE0nb+SR83CsAINJYKG3V1b3Kfs0hydseYKsBYqJTN2j
 CmUXDYq9J7uOyQQ7TNVoQejmpp5ifR4EzwIFfmYDekxRVZDJygD0wL/EzUr8Je3/j548NLyL
 4Uhv6CIPf3TY3/aLVKXdxz/ntbLgMcfZsDoHgDk3lY3r1iwbWwEM2+eYRdSZaR4VD+JRD7p8
 0FBadNwWnBce1fmQp3EklodGi5y7TNZ/CKdJ+jRPAAnw7SINhSd7PhJMruDAJaUlbYaIm23A
 +82g+IGe4z9tRGQ9TAflezVMhT5J3ccu6cpIjjvwDlbxucSmtVi5VtPAMTLmfjYp7VY2Tgr+
 T92v7+V96jAfE3Zy2nq52e8RDdUo/F6faxcumdl+aLhhKLXgrozpoe2nL0Nyc2uqFjkjwXXI
 OBQiaqGeWtxeKJP+O8MIpjyGuHUGzvjNx5S/592TQO3phpT5IFWfMgbu4OreZ9yekDhf7Cvn
 /fkYsiLDz9W6Clihd/xlpm79+jlhm4E3xBPiQOPCZowmHjx57mXVAypOP2Eu+i2nyQrkapaY
 IdisDQfWPdNeHNOiPnPS3+GhVlPcqSJAIWnuO7Ofw1ZVOyg/jwARAQABzUNDaHJpc3RpYW4g
 Qm9ybnRyYWVnZXIgKDJuZCBJQk0gYWRkcmVzcykgPGJvcm50cmFlZ2VyQGxpbnV4LmlibS5j
 b20+wsF5BBMBAgAjBQJdP/hMAhsDBwsJCAcDAgEGFQgCCQoLBBYCAwECHgECF4AACgkQEXu8
 gLWmHHy/pA/+JHjpEnd01A0CCyfVnb5fmcOlQ0LdmoKWLWPvU840q65HycCBFTt6V62cDljB
 kXFFxMNA4y/2wqU0H5/CiL963y3gWIiJsZa4ent+KrHl5GK1nIgbbesfJyA7JqlB0w/E/SuY
 NRQwIWOo/uEvOgXnk/7+rtvBzNaPGoGiiV1LZzeaxBVWrqLtmdi1iulW/0X/AlQPuF9dD1Px
 hx+0mPjZ8ClLpdSp5d0yfpwgHtM1B7KMuQPQZGFKMXXTUd3ceBUGGczsgIMipZWJukqMJiJj
 QIMH0IN7XYErEnhf0GCxJ3xAn/J7iFpPFv8sFZTvukntJXSUssONnwiKuld6ttUaFhSuSoQg
 OFYR5v7pOfinM0FcScPKTkrRsB5iUvpdthLq5qgwdQjmyINt3cb+5aSvBX2nNN135oGOtlb5
 tf4dh00kUR8XFHRrFxXx4Dbaw4PKgV3QLIHKEENlqnthH5t0tahDygQPnSucuXbVQEcDZaL9
 WgJqlRAAj0pG8M6JNU5+2ftTFXoTcoIUbb0KTOibaO9zHVeGegwAvPLLNlKHiHXcgLX1tkjC
 DrvE2Z0e2/4q7wgZgn1kbvz7ZHQZB76OM2mjkFu7QNHlRJ2VXJA8tMXyTgBX6kq1cYMmd/Hl
 OhFrAU3QO1SjCsXA2CDk9MM1471mYB3CTXQuKzXckJnxHkHOwU0ETpw8+AEQAJjyNXvMQdJN
 t07BIPDtbAQk15FfB0hKuyZVs+0lsjPKBZCamAAexNRk11eVGXK/YrqwjChkk60rt3q5i42u
 PpNMO9aS8cLPOfVft89Y654Qd3Rs1WRFIQq9xLjdLfHh0i0jMq5Ty+aiddSXpZ7oU6E+ud+X
 Czs3k5RAnOdW6eV3+v10sUjEGiFNZwzN9Udd6PfKET0J70qjnpY3NuWn5Sp1ZEn6lkq2Zm+G
 9G3FlBRVClT30OWeiRHCYB6e6j1x1u/rSU4JiNYjPwSJA8EPKnt1s/Eeq37qXXvk+9DYiHdT
 PcOa3aNCSbIygD3jyjkg6EV9ZLHibE2R/PMMid9FrqhKh/cwcYn9FrT0FE48/2IBW5mfDpAd
 YvpawQlRz3XJr2rYZJwMUm1y+49+1ZmDclaF3s9dcz2JvuywNq78z/VsUfGz4Sbxy4ShpNpG
 REojRcz/xOK+FqNuBk+HoWKw6OxgRzfNleDvScVmbY6cQQZfGx/T7xlgZjl5Mu/2z+ofeoxb
 vWWM1YCJAT91GFvj29Wvm8OAPN/+SJj8LQazd9uGzVMTz6lFjVtH7YkeW/NZrP6znAwv5P1a
 DdQfiB5F63AX++NlTiyA+GD/ggfRl68LheSskOcxDwgI5TqmaKtX1/8RkrLpnzO3evzkfJb1
 D5qh3wM1t7PZ+JWTluSX8W25ABEBAAHCwV8EGAECAAkFAk6cPPgCGwwACgkQEXu8gLWmHHz8
 2w//VjRlX+tKF3szc0lQi4X0t+pf88uIsvR/a1GRZpppQbn1jgE44hgF559K6/yYemcvTR7r
 6Xt7cjWGS4wfaR0+pkWV+2dbw8Xi4DI07/fN00NoVEpYUUnOnupBgychtVpxkGqsplJZQpng
 v6fauZtyEcUK3dLJH3TdVQDLbUcL4qZpzHbsuUnTWsmNmG4Vi0NsEt1xyd/Wuw+0kM/oFEH1
 4BN6X9xZcG8GYUbVUd8+bmio8ao8m0tzo4pseDZFo4ncDmlFWU6hHnAVfkAs4tqA6/fl7RLN
 JuWBiOL/mP5B6HDQT9JsnaRdzqF73FnU2+WrZPjinHPLeE74istVgjbowvsgUqtzjPIG5pOj
 cAsKoR0M1womzJVRfYauWhYiW/KeECklci4TPBDNx7YhahSUlexfoftltJA8swRshNA/M90/
 i9zDo9ySSZHwsGxG06ZOH5/MzG6HpLja7g8NTgA0TD5YaFm/oOnsQVsf2DeAGPS2xNirmknD
 jaqYefx7yQ7FJXXETd2uVURiDeNEFhVZWb5CiBJM5c6qQMhmkS4VyT7/+raaEGgkEKEgHOWf
 ZDP8BHfXtszHqI3Fo1F4IKFo/AP8GOFFxMRgbvlAs8z/+rEEaQYjxYJqj08raw6P4LFBqozr
 nS4h0HDFPrrp1C2EMVYIQrMokWvlFZbCpsdYbBI=
Date:   Tue, 26 Nov 2019 10:33:11 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20191126092918.GB20912@dhcp22.suse.cz>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19112609-0012-0000-0000-0000036C6207
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19112609-0013-0000-0000-000021A805A9
Message-Id: <abe23ff5-a0fb-2b85-cf7b-1166e47609d6@de.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-26_01:2019-11-26,2019-11-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 impostorscore=0 clxscore=1011 bulkscore=0 adultscore=0
 priorityscore=1501 malwarescore=0 spamscore=0 phishscore=0 mlxlogscore=484
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911260087
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 26.11.19 10:29, Michal Hocko wrote:
> On Mon 25-11-19 10:54:53, Roman Gushchin wrote:
>> Christian reported a warning like the following obtained during running some
>> KVM-related tests on s390:
>>
>> WARNING: CPU: 8 PID: 208 at lib/percpu-refcount.c:108 percpu_ref_exit+0x50/0x58
>> Modules linked in: kvm(-) xt_CHECKSUM xt_MASQUERADE bonding xt_tcpudp ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 ipt_REJECT nf_reject_ipv4 xt_conntrack ip6table_na>
>> CPU: 8 PID: 208 Comm: kworker/8:1 Not tainted 5.2.0+ #66
>> Hardware name: IBM 2964 NC9 712 (LPAR)
>> Workqueue: events sysfs_slab_remove_workfn
>> Krnl PSW : 0704e00180000000 0000001529746850 (percpu_ref_exit+0x50/0x58)
>>            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:2 PM:0 RI:0 EA:3
>> Krnl GPRS: 00000000ffff8808 0000001529746740 000003f4e30e8e18 0036008100000000
>>            0000001f00000000 0035008100000000 0000001fb3573ab8 0000000000000000
>>            0000001fbdb6de00 0000000000000000 0000001529f01328 0000001fb3573b00
>>            0000001fbb27e000 0000001fbdb69300 000003e009263d00 000003e009263cd0
>> Krnl Code: 0000001529746842: f0a0000407fe        srp        4(11,%r0),2046,0
>>            0000001529746848: 47000700            bc         0,1792
>>           #000000152974684c: a7f40001            brc        15,152974684e
>>           >0000001529746850: a7f4fff2            brc        15,1529746834
>>            0000001529746854: 0707                bcr        0,%r7
>>            0000001529746856: 0707                bcr        0,%r7
>>            0000001529746858: eb8ff0580024        stmg       %r8,%r15,88(%r15)
>>            000000152974685e: a738ffff            lhi        %r3,-1
>> Call Trace:
>> ([<000003e009263d00>] 0x3e009263d00)
>>  [<00000015293252ea>] slab_kmem_cache_release+0x3a/0x70
>>  [<0000001529b04882>] kobject_put+0xaa/0xe8
>>  [<000000152918cf28>] process_one_work+0x1e8/0x428
>>  [<000000152918d1b0>] worker_thread+0x48/0x460
>>  [<00000015291942c6>] kthread+0x126/0x160
>>  [<0000001529b22344>] ret_from_fork+0x28/0x30
>>  [<0000001529b2234c>] kernel_thread_starter+0x0/0x10
>> Last Breaking-Event-Address:
>>  [<000000152974684c>] percpu_ref_exit+0x4c/0x58
>> ---[ end trace b035e7da5788eb09 ]---
>>
>> The problem occurs because kmem_cache_destroy() is called immediately
>> after deleting of a memcg, so it races with the memcg kmem_cache
>> deactivation.
>>
>> flush_memcg_workqueue() at the beginning of kmem_cache_destroy()
>> is supposed to guarantee that all deactivation processes are finished,
>> but failed to do so. It waits for an rcu grace period, after which all
>> children kmem_caches should be deactivated. During the deactivation
>> percpu_ref_kill() is called for non root kmem_cache refcounters,
>> but it requires yet another rcu grace period to finish the transition
>> to the atomic (dead) state.
>>
>> So in a rare case when not all children kmem_caches are destroyed
>> at the moment when the root kmem_cache is about to be gone, we need
>> to wait another rcu grace period before destroying the root
>> kmem_cache.
> 
> Could you explain how rare this really is please? I still have to wrap
> my head around the overall logic here. It looks quite fragile to me TBH.
> I am worried that is relies on implementation detail of the PCP ref
> counters too much.

I can actually reproduce this very reliably by doing an

# virsh destroy <lastguest>; rmmod kvm

