Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E8481040F1
	for <lists+stable@lfdr.de>; Wed, 20 Nov 2019 17:39:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729528AbfKTQi7 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 20 Nov 2019 11:38:59 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:60666 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728632AbfKTQi7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Nov 2019 11:38:59 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAKGcIs8053547;
        Wed, 20 Nov 2019 11:38:46 -0500
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2wd3fkwmjc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Nov 2019 11:38:45 -0500
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id xAKGcdmh055570;
        Wed, 20 Nov 2019 11:38:45 -0500
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2wd3fkwmht-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Nov 2019 11:38:45 -0500
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id xAKGGD3g026193;
        Wed, 20 Nov 2019 16:38:44 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma02wdc.us.ibm.com with ESMTP id 2wa8r6paem-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Nov 2019 16:38:44 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xAKGciAm30146936
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Nov 2019 16:38:44 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4008F112064;
        Wed, 20 Nov 2019 16:38:44 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 40BB1112062;
        Wed, 20 Nov 2019 16:38:43 +0000 (GMT)
Received: from [9.160.73.73] (unknown [9.160.73.73])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTPS;
        Wed, 20 Nov 2019 16:38:43 +0000 (GMT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3601.0.10\))
Subject: Re: [PATCH v2 1/2] KVM: PPC: Book3S HV: XIVE: Free previous EQ page
 when setting up a new one
From:   Lijun Pan <ljp@linux.vnet.ibm.com>
In-Reply-To: <157366357346.1026356.14522564753643067538.stgit@bahia.lan>
Date:   Wed, 20 Nov 2019 10:38:42 -0600
Cc:     Paul Mackerras <paulus@ozlabs.org>,
        Laurent Vivier <lvivier@redhat.com>,
        linux-kernel@vger.kernel.org, kvm-ppc@vger.kernel.org,
        Satheesh Rajendran <sathnaga@linux.vnet.ibm.com>,
        =?utf-8?Q?C=C3=A9dric_Le_Goater?= <clg@kaod.org>,
        Lijun Pan <ljp@linux.ibm.com>, stable@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org,
        David Gibson <david@gibson.dropbear.id.au>
Content-Transfer-Encoding: 8BIT
Message-Id: <6C7372DE-CF54-4EA0-90B1-724C77A81E9F@linux.vnet.ibm.com>
References: <157366357346.1026356.14522564753643067538.stgit@bahia.lan>
To:     Greg Kurz <groug@kaod.org>
X-Mailer: Apple Mail (2.3601.0.10)
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-20_04:2019-11-20,2019-11-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 phishscore=0 spamscore=0 priorityscore=1501 malwarescore=0 mlxlogscore=999
 lowpriorityscore=0 clxscore=1015 adultscore=0 bulkscore=0 suspectscore=2
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-1910280000
 definitions=main-1911200143
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> On Nov 13, 2019, at 10:46 AM, Greg Kurz <groug@kaod.org> wrote:
> 
> The EQ page is allocated by the guest and then passed to the hypervisor
> with the H_INT_SET_QUEUE_CONFIG hcall. A reference is taken on the page
> before handing it over to the HW. This reference is dropped either when
> the guest issues the H_INT_RESET hcall or when the KVM device is released.
> But, the guest can legitimately call H_INT_SET_QUEUE_CONFIG several times,
> either to reset the EQ (vCPU hot unplug) or to set a new EQ (guest reboot).
> In both cases the existing EQ page reference is leaked because we simply
> overwrite it in the XIVE queue structure without calling put_page().
> 
> This is especially visible when the guest memory is backed with huge pages:
> start a VM up to the guest userspace, either reboot it or unplug a vCPU,
> quit QEMU. The leak is observed by comparing the value of HugePages_Free in
> /proc/meminfo before and after the VM is run.
> 
> Ideally we'd want the XIVE code to handle the EQ page de-allocation at the
> platform level. This isn't the case right now because the various XIVE
> drivers have different allocation needs. It could maybe worth introducing
> hooks for this purpose instead of exposing XIVE internals to the drivers,
> but this is certainly a huge work to be done later.
> 
> In the meantime, for easier backport, fix both vCPU unplug and guest reboot
> leaks by introducing a wrapper around xive_native_configure_queue() that
> does the necessary cleanup.
> 
> Reported-by: Satheesh Rajendran <sathnaga@linux.vnet.ibm.com>
> Cc: stable@vger.kernel.org # v5.2
> Fixes: 13ce3297c576 ("KVM: PPC: Book3S HV: XIVE: Add controls for the EQ configuration")
> Signed-off-by: Cédric Le Goater <clg@kaod.org>
> Signed-off-by: Greg Kurz <groug@kaod.org>

Tested-by: Lijun Pan <ljp@linux.ibm.com>

> ---
> v2: use wrapper as suggested by Cedric
> ---
> arch/powerpc/kvm/book3s_xive_native.c |   31 ++++++++++++++++++++++---------
> 1 file changed, 22 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/powerpc/kvm/book3s_xive_native.c b/arch/powerpc/kvm/book3s_xive_native.c
> index 34bd123fa024..0e1fc5a16729 100644
> --- a/arch/powerpc/kvm/book3s_xive_native.c
> +++ b/arch/powerpc/kvm/book3s_xive_native.c
> @@ -50,6 +50,24 @@ static void kvmppc_xive_native_cleanup_queue(struct kvm_vcpu *vcpu, int prio)
> 	}
> }
> 
> +static int kvmppc_xive_native_configure_queue(u32 vp_id, struct xive_q *q,
> +					      u8 prio, __be32 *qpage,
> +					      u32 order, bool can_escalate)
> +{
> +	int rc;
> +	__be32 *qpage_prev = q->qpage;
> +
> +	rc = xive_native_configure_queue(vp_id, q, prio, qpage, order,
> +					 can_escalate);
> +	if (rc)
> +		return rc;
> +
> +	if (qpage_prev)
> +		put_page(virt_to_page(qpage_prev));
> +
> +	return rc;
> +}
> +
> void kvmppc_xive_native_cleanup_vcpu(struct kvm_vcpu *vcpu)
> {
> 	struct kvmppc_xive_vcpu *xc = vcpu->arch.xive_vcpu;
> @@ -575,19 +593,14 @@ static int kvmppc_xive_native_set_queue_config(struct kvmppc_xive *xive,
> 		q->guest_qaddr  = 0;
> 		q->guest_qshift = 0;
> 
> -		rc = xive_native_configure_queue(xc->vp_id, q, priority,
> -						 NULL, 0, true);
> +		rc = kvmppc_xive_native_configure_queue(xc->vp_id, q, priority,
> +							NULL, 0, true);
> 		if (rc) {
> 			pr_err("Failed to reset queue %d for VCPU %d: %d\n",
> 			       priority, xc->server_num, rc);
> 			return rc;
> 		}
> 
> -		if (q->qpage) {
> -			put_page(virt_to_page(q->qpage));
> -			q->qpage = NULL;
> -		}
> -
> 		return 0;
> 	}
> 
> @@ -646,8 +659,8 @@ static int kvmppc_xive_native_set_queue_config(struct kvmppc_xive *xive,
> 	  * OPAL level because the use of END ESBs is not supported by
> 	  * Linux.
> 	  */
> -	rc = xive_native_configure_queue(xc->vp_id, q, priority,
> -					 (__be32 *) qaddr, kvm_eq.qshift, true);
> +	rc = kvmppc_xive_native_configure_queue(xc->vp_id, q, priority,
> +					(__be32 *) qaddr, kvm_eq.qshift, true);
> 	if (rc) {
> 		pr_err("Failed to configure queue %d for VCPU %d: %d\n",
> 		       priority, xc->server_num, rc);
> 

