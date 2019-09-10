Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CAD6AEB71
	for <lists+stable@lfdr.de>; Tue, 10 Sep 2019 15:25:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732199AbfIJNZO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Sep 2019 09:25:14 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:19252 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726651AbfIJNZO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Sep 2019 09:25:14 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x8ADNuWh129973
        for <stable@vger.kernel.org>; Tue, 10 Sep 2019 09:25:13 -0400
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2uxbr2tjbq-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Tue, 10 Sep 2019 09:25:12 -0400
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <stable@vger.kernel.org> from <imbrenda@linux.ibm.com>;
        Tue, 10 Sep 2019 14:25:10 +0100
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 10 Sep 2019 14:25:06 +0100
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x8ADOdAC38207808
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Sep 2019 13:24:39 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0D27F42054;
        Tue, 10 Sep 2019 13:25:04 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9A9A64204D;
        Tue, 10 Sep 2019 13:25:03 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.39])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 10 Sep 2019 13:25:03 +0000 (GMT)
Date:   Tue, 10 Sep 2019 15:25:02 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Igor Mammedov <imammedo@redhat.com>
Cc:     linux-kernel@vger.kernel.org, borntraeger@de.ibm.com,
        david@redhat.com, cohuck@redhat.com, frankja@linux.ibm.com,
        heiko.carstens@de.ibm.com, gor@linux.ibm.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] KVM: s390: kvm_s390_vm_start_migration: check
 dirty_bitmap before using it as target for memset()
In-Reply-To: <20190910130215.23647-1-imammedo@redhat.com>
References: <20190910130215.23647-1-imammedo@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.13.2 (GTK+ 2.24.30; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19091013-0016-0000-0000-000002A98282
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19091013-0017-0000-0000-0000330A09CF
Message-Id: <20190910152502.4e90735d@p-imbrenda.boeblingen.de.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-09-10_09:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=944 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1909100131
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 10 Sep 2019 09:02:15 -0400
Igor Mammedov <imammedo@redhat.com> wrote:

> If userspace doesn't set KVM_MEM_LOG_DIRTY_PAGES on memslot before
> calling kvm_s390_vm_start_migration(), kernel will oops with:
> 
>   Unable to handle kernel pointer dereference in virtual kernel
> address space Failing address: 0000000000000000 TEID: 0000000000000483
>   Fault in home space mode while using kernel ASCE.
>   AS:0000000002a2000b R2:00000001bff8c00b R3:00000001bff88007
> S:00000001bff91000 P:000000000000003d Oops: 0004 ilc:2 [#1] SMP
>   ...
>   Call Trace:
>   ([<001fffff804ec552>] kvm_s390_vm_set_attr+0x347a/0x3828 [kvm])
>    [<001fffff804ecfc0>] kvm_arch_vm_ioctl+0x6c0/0x1998 [kvm]
>    [<001fffff804b67e4>] kvm_vm_ioctl+0x51c/0x11a8 [kvm]
>    [<00000000008ba572>] do_vfs_ioctl+0x1d2/0xe58
>    [<00000000008bb284>] ksys_ioctl+0x8c/0xb8
>    [<00000000008bb2e2>] sys_ioctl+0x32/0x40
>    [<000000000175552c>] system_call+0x2b8/0x2d8
>   INFO: lockdep is turned off.
>   Last Breaking-Event-Address:
>    [<0000000000dbaf60>] __memset+0xc/0xa0
> 
> due to ms->dirty_bitmap being NULL, which might crash the host.
> 
> Make sure that ms->dirty_bitmap is set before using it or
> print a warning and return -ENIVAL otherwise.
> 
> Fixes: afdad61615cc ("KVM: s390: Fix storage attributes migration
> with memory slots") Signed-off-by: Igor Mammedov <imammedo@redhat.com>
> ---
> Cc: stable@vger.kernel.org # v4.19+
> 
> v2:
>    - drop WARN()
> 
>  arch/s390/kvm/kvm-s390.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index f329dcb3f44c..2a40cd3e40b4 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -1018,6 +1018,8 @@ static int kvm_s390_vm_start_migration(struct
> kvm *kvm) /* mark all the pages in active slots as dirty */
>  	for (slotnr = 0; slotnr < slots->used_slots; slotnr++) {
>  		ms = slots->memslots + slotnr;
> +		if (!ms->dirty_bitmap)
> +			return -EINVAL;
>  		/*
>  		 * The second half of the bitmap is only used on x86,
>  		 * and would be wasted otherwise, so we put it to
> good

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

