Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1A8A6EC63
	for <lists+stable@lfdr.de>; Sat, 20 Jul 2019 00:07:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728376AbfGSWGm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 18:06:42 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:33146 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727344AbfGSWGm (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Jul 2019 18:06:42 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6JM4TOR030145;
        Fri, 19 Jul 2019 22:06:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2018-07-02; bh=AyCDw5eS2gHSdtk2d/K7siUKLe143t2UqK+Wt0Mb2Y4=;
 b=bFvTmgg9GWglSd1kgZYfKfAKFK+zBAXU87xdBXi3jXfKem9IIPyeEk03TuvxHIg1ZZZ0
 FxsjkTaNNKQmhja/V68hhA27UBqGT9MrR5VKS9BmrmsWQo612zmdlFi42gGYHOQfhNEN
 8lGu/X1iA0rpXc+BUijLZ951xUVPJeHrjU4XJienovtTDsNdDLP/Hki8rhGGemzn+yQH
 ZN11c+bAZ/f4ttz3nwdbQ3fIvvIGxy9VSV7g9UDRcE8OBC0qrH+VD4LYzIr17CvUhvOY
 /urmVxfB4W7dhu/I0lXHDwSOP+rvrs7zY5lL5y/NdlgrlzAeKgpEcQQ8z1svD7fVOuJw 2w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2tq78q8teb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Jul 2019 22:06:29 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6JM2nYT102761;
        Fri, 19 Jul 2019 22:06:28 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2tsmcdtsgr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Jul 2019 22:06:28 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x6JM6RJ7022517;
        Fri, 19 Jul 2019 22:06:27 GMT
Received: from [10.74.126.79] (/10.74.126.79)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 19 Jul 2019 22:06:27 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [PATCH v2] KVM: nVMX: do not use dangling shadow VMCS after guest
 reset
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <1563572390-28823-1-git-send-email-pbonzini@redhat.com>
Date:   Sat, 20 Jul 2019 01:06:23 +0300
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        stable@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <A523C8F1-2A15-4B14-AB83-9D2659A7E78F@oracle.com>
References: <1563572390-28823-1-git-send-email-pbonzini@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9323 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907190232
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9323 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907190232
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> On 20 Jul 2019, at 0:39, Paolo Bonzini <pbonzini@redhat.com> wrote:
>=20
> If a KVM guest is reset while running a nested guest, free_nested will
> disable the shadow VMCS execution control in the vmcs01.  However,
> on the next KVM_RUN vmx_vcpu_run would nevertheless try to sync
> the VMCS12 to the shadow VMCS which has since been freed.
>=20
> This causes a vmptrld of a NULL pointer on my machime, but Jan reports
> the host to hang altogether.  Let's see how much this trivial patch =
fixes.
>=20
> Reported-by: Jan Kiszka <jan.kiszka@siemens.com>
> Cc: Liran Alon <liran.alon@oracle.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

1) Are we sure we prefer WARN_ON() instead of WARN_ON_ONCE()?
2) Should we also check for WARN_ON(!vmcs12)? As free_nested() also =
kfree(vmx->nested.cached_vmcs12).
In fact, because free_nested() don=E2=80=99t put NULL in cached_vmcs12 =
after kfree() it, I wonder if we shouldn=E2=80=99t create a separate =
patch that does:
(a) Modify free_nested() to put NULL in cached_vmcs12 after kfree().
(b) Put BUG_ON(!cached_vmcs12) in get_vmcs12() before returning value.

-Liran

> ---
> arch/x86/kvm/vmx/nested.c | 8 +++++++-
> 1 file changed, 7 insertions(+), 1 deletion(-)
>=20
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 4f23e34f628b..0f1378789bd0 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -194,6 +194,7 @@ static void vmx_disable_shadow_vmcs(struct =
vcpu_vmx *vmx)
> {
> 	secondary_exec_controls_clearbit(vmx, =
SECONDARY_EXEC_SHADOW_VMCS);
> 	vmcs_write64(VMCS_LINK_POINTER, -1ull);
> +	vmx->nested.need_vmcs12_to_shadow_sync =3D false;
> }
>=20
> static inline void nested_release_evmcs(struct kvm_vcpu *vcpu)
> @@ -1341,6 +1342,9 @@ static void copy_shadow_to_vmcs12(struct =
vcpu_vmx *vmx)
> 	unsigned long val;
> 	int i;
>=20
> +	if (WARN_ON(!shadow_vmcs))
> +		return;
> +
> 	preempt_disable();
>=20
> 	vmcs_load(shadow_vmcs);
> @@ -1373,6 +1377,9 @@ static void copy_vmcs12_to_shadow(struct =
vcpu_vmx *vmx)
> 	unsigned long val;
> 	int i, q;
>=20
> +	if (WARN_ON(!shadow_vmcs))
> +		return;
> +
> 	vmcs_load(shadow_vmcs);
>=20
> 	for (q =3D 0; q < ARRAY_SIZE(fields); q++) {
> @@ -4436,7 +4443,6 @@ static inline void nested_release_vmcs12(struct =
kvm_vcpu *vcpu)
> 		/* copy to memory all shadowed fields in case
> 		   they were modified */
> 		copy_shadow_to_vmcs12(vmx);
> -		vmx->nested.need_vmcs12_to_shadow_sync =3D false;
> 		vmx_disable_shadow_vmcs(vmx);
> 	}
> 	vmx->nested.posted_intr_nv =3D -1;
> --=20
> 1.8.3.1
>=20

