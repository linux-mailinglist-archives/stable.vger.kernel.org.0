Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB67A1A0C91
	for <lists+stable@lfdr.de>; Tue,  7 Apr 2020 13:11:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728461AbgDGLKy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Apr 2020 07:10:54 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:17322 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726399AbgDGLKy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Apr 2020 07:10:54 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 037B4ZGn026122
        for <stable@vger.kernel.org>; Tue, 7 Apr 2020 07:10:53 -0400
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3082mqc6t2-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Tue, 07 Apr 2020 07:10:52 -0400
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <stable@vger.kernel.org> from <imbrenda@linux.ibm.com>;
        Tue, 7 Apr 2020 12:10:23 +0100
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 7 Apr 2020 12:10:20 +0100
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 037B9frB50856328
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 7 Apr 2020 11:09:41 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 404A1A4054;
        Tue,  7 Apr 2020 11:10:46 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B3D8AA405B;
        Tue,  7 Apr 2020 11:10:45 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.8.150])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  7 Apr 2020 11:10:45 +0000 (GMT)
Date:   Tue, 7 Apr 2020 12:48:15 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/5] KVM: s390: vsie: Fix region 1 ASCE sanity shadow
 address checks
In-Reply-To: <3431ccbb-25b2-66fc-5e07-3f449c03b087@de.ibm.com>
References: <20200403153050.20569-1-david@redhat.com>
        <20200403153050.20569-2-david@redhat.com>
        <ee3f6c69-4401-066d-6f87-806667facf35@de.ibm.com>
        <c5c9fdcd-37ce-029d-a412-8987a901a116@redhat.com>
        <3431ccbb-25b2-66fc-5e07-3f449c03b087@de.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 20040711-0020-0000-0000-000003C33E87
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20040711-0021-0000-0000-0000221BFC1D
Message-Id: <20200407124815.4577e98c@p-imbrenda>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-07_03:2020-04-07,2020-04-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 adultscore=0
 spamscore=0 phishscore=0 lowpriorityscore=0 bulkscore=0 clxscore=1011
 suspectscore=0 impostorscore=0 mlxscore=0 mlxlogscore=967
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004070091
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 7 Apr 2020 09:52:53 +0200
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> On 07.04.20 09:49, David Hildenbrand wrote:
> > On 07.04.20 09:33, Christian Borntraeger wrote:  
> >>
> >> On 03.04.20 17:30, David Hildenbrand wrote:  
> >>> In case we have a region 1 ASCE, our shadow/g3 address can have
> >>> any value. Unfortunately, (-1UL << 64) is undefined and triggers
> >>> sometimes, rejecting valid shadow addresses when trying to walk
> >>> our shadow table hierarchy.
> >>>
> >>> The result is that the prefix cannot get mapped and will loop
> >>> basically forever trying to map it (-EAGAIN loop).
> >>>
> >>> After all, the broken check is only a sanity check, our table
> >>> shadowing code in kvm_s390_shadow_tables() already checks these
> >>> conditions, injecting proper translation exceptions. Turn it into
> >>> a WARN_ON_ONCE().  
> >>
> >> After some testing I now triggered this warning:
> >>
> >> [  541.633114] ------------[ cut here ]------------
> >> [  541.633128] WARNING: CPU: 38 PID: 2812 at
> >> arch/s390/mm/gmap.c:799 gmap_shadow_pgt_lookup+0x98/0x1a0 [
> >> 541.633129] Modules linked in: vhost_net vhost macvtap macvlan tap
> >> kvm xt_CHECKSUM xt_MASQUERADE nf_nat_tftp nf_conntrack_tftp xt_CT
> >> tun bridge stp llc xt_tcpudp ip6t_REJECT nf_reject_ipv6
> >> ip6t_rpfilter ipt_REJECT nf_reject_ipv4 xt_conntrack ip6table_nat
> >> ip6table_mangle ip6table_raw ip6table_security iptable_nat nf_nat
> >> iptable_mangle iptable_raw iptable_security nf_conntrack
> >> nf_defrag_ipv6 nf_defrag_ipv4 ip_set nfnetlink ip6table_filter
> >> ip6_tables iptable_filter rpcrdma sunrpc rdma_ucm rdma_cm iw_cm
> >> ib_cm configfs mlx5_ib s390_trng ghash_s390 prng aes_s390
> >> ib_uverbs des_s390 ib_core libdes sha3_512_s390 genwqe_card
> >> sha3_256_s390 vfio_ccw crc_itu_t vfio_mdev sha512_s390 mdev
> >> vfio_iommu_type1 sha1_s390 vfio eadm_sch zcrypt_cex4 sch_fq_codel
> >> ip_tables x_tables mlx5_core sha256_s390 sha_common pkey zcrypt
> >> rng_core autofs4 [  541.633164] CPU: 38 PID: 2812 Comm: CPU 0/KVM
> >> Not tainted 5.6.0+ #354 [  541.633166] Hardware name: IBM 3906 M04
> >> 704 (LPAR) [  541.633167] Krnl PSW : 0704d00180000000
> >> 00000014e05dc454 (gmap_shadow_pgt_lookup+0x9c/0x1a0) [
> >> 541.633169]            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3
> >> CC:1 PM:0 RI:0 EA:3 [  541.633171] Krnl GPRS: 0000000000000000
> >> 0000001f00000000 0000001f487b8000 ffffffff80000000 [  541.633172]
> >>           ffffffffffffffff 000003e003defa18 000003e003defa1c
> >> 000003e003defa18 [  541.633173]            fffffffffffff000
> >> 000003e003defa18 000003e003defa28 0000001f70e06300 [  541.633174]
> >>           0000001f43484000 00000000043ed200 000003e003def978
> >> 000003e003def920 [  541.633203] Krnl Code: 00000014e05dc448:
> >> b9800038		ngr	%r3,%r8 00000014e05dc44c:
> >> a7840014		brc	8,00000014e05dc474
> >> #00000014e05dc450: af000000		mc	0,0  
> >>                          >00000014e05dc454: a728fff5
> >>                          >	lhi	%r2,-11  
> >>                           00000014e05dc458: a7180000
> >> 	lhi	%r1,0 00000014e05dc45c: b2fa0070
> >> niai	7,0 00000014e05dc460: 4010b04a
> >> sth	%r1,74(%r11) 00000014e05dc464: b9140022
> >> lgfr	%r2,%r2 [  541.633215] Call Trace:
> >> [  541.633218]  [<00000014e05dc454>]
> >> gmap_shadow_pgt_lookup+0x9c/0x1a0 [  541.633257]
> >> [<000003ff804c57d6>] kvm_s390_shadow_fault+0x66/0x1e8 [kvm] [
> >> 541.633265]  [<000003ff804c72dc>] vsie_run+0x43c/0x710 [kvm] [
> >> 541.633273]  [<000003ff804c85ca>] kvm_s390_handle_vsie+0x632/0x750
> >> [kvm] [  541.633281]  [<000003ff804c123c>]
> >> kvm_s390_handle_b2+0x84/0x4e0 [kvm] [  541.633289]
> >> [<000003ff804b46b2>] kvm_handle_sie_intercept+0x172/0xcb8 [kvm] [
> >> 541.633297]  [<000003ff804b18a8>] __vcpu_run+0x658/0xc90 [kvm] [
> >> 541.633305]  [<000003ff804b2920>]
> >> kvm_arch_vcpu_ioctl_run+0x248/0x858 [kvm] [  541.633313]
> >> [<000003ff8049d454>] kvm_vcpu_ioctl+0x284/0x7b0 [kvm] [
> >> 541.633316]  [<00000014e087d5ae>] ksys_ioctl+0xae/0xe8 [
> >> 541.633318]  [<00000014e087d652>] __s390x_sys_ioctl+0x2a/0x38 [
> >> 541.633323]  [<00000014e0ff02a2>] system_call+0x2a6/0x2c8 [
> >> 541.633323] Last Breaking-Event-Address: [  541.633334]
> >> [<000003ff804983e0>] kvm_running_vcpu+0x3ea9ee997d8/0x3ea9ee99950
> >> [kvm] [  541.633335] ---[ end trace f69b6021855ea189 ]---
> >>
> >>
> >> Unfortunately no dump at that point in time.
> >> I have other tests which are clearly fixed by this patch, so we
> >> should propbably go forward anyway. Question is, is this just
> >> another bug we need to fix or is the assumption that somebody else
> >> checked all conditions so we can warn false?  
> > 
> > Yeah, I think it is via
> > 
> > kvm_s390_shadow_fault()->gmap_shadow_pgt_lookup()->gmap_table_walk()
> > 
> > where we just peek if there is already something shadowed. If not,
> > we go via the full kvm_s390_shadow_tables() path.
> > 
> > So we could either do sanity checks in gmap_shadow_pgt_lookup(), or
> > rather drop the WARN_ON_ONCE. I think the latter makes sense, now
> > that we understood the problem.  
> 
> Ok, so I will drop the WARN_ON_ONCE and fixup the commit message.
> 

with those fixes, you can also add:

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

