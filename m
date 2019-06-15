Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D6F547270
	for <lists+stable@lfdr.de>; Sun, 16 Jun 2019 00:41:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726800AbfFOWlQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Jun 2019 18:41:16 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:44396 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726400AbfFOWlQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 Jun 2019 18:41:16 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5FMdwX7175194;
        Sat, 15 Jun 2019 22:40:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2018-07-02; bh=HojXcpLYEfNeWMx2xn7s/vumWeb8ZgNi7exTOWmAOCI=;
 b=TD7c7l1EqckZJC33MU8pnf1ePkCAt2U/6knTeoTcQ3T0nOYyNq1ee8cto0UlCq/n/F8a
 k96j53sUJ8LEDPbyJb0KHVxFF/9hfjCQoE7lRjOet3vizerIs2FaSHXCyMZzc7E/0vtT
 VfziKh+jjbrBzr1iU0ZLuKfXHn3IWi+TPTqmmu8pzDAAnWBKS/+VNlQ6WWvMF7tsTkMr
 o76RR0qPrMcbjPE/S99MhpsKZYjy4jDKHGAiw7oWth0wJfkt3ROXiYjUNGin5WztP+iL
 HI2m5psvXj3Sccf33MFaxcELZ/LKXqBd5r3QycFabneYz7PqFoVcODqeZxOnQcxGYNdd kg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2t4r3t9qx4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 15 Jun 2019 22:40:47 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5FMeMd7055087;
        Sat, 15 Jun 2019 22:40:47 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2t59gcr1qn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 15 Jun 2019 22:40:47 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x5FMejPD013168;
        Sat, 15 Jun 2019 22:40:45 GMT
Received: from [192.168.14.112] (/109.67.217.108)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 15 Jun 2019 15:40:44 -0700
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [PATCH 16/43] KVM: nVMX: Always sync GUEST_BNDCFGS when it comes
 from vmcs01
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <20190615221602.93C5721851@mail.kernel.org>
Date:   Sun, 16 Jun 2019 01:40:40 +0300
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        stable@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <52A3BB36-61D8-4CD1-8032-6EEDCB4213C9@oracle.com>
References: <1560445409-17363-17-git-send-email-pbonzini@redhat.com>
 <20190615221602.93C5721851@mail.kernel.org>
To:     Sasha Levin <sashal@kernel.org>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9289 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906150214
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9289 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906150214
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

You should apply something as the following instead of the original fix =
by Sean
to play nicely on upstream without additional dependency:

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index f1a69117ac0f..3fc44852ed4f 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2234,12 +2234,9 @@ static void prepare_vmcs02_full(struct vcpu_vmx =
*vmx, struct vmcs12 *vmcs12)

        set_cr4_guest_host_mask(vmx);

-       if (kvm_mpx_supported()) {
-               if (vmx->nested.nested_run_pending &&
-                       (vmcs12->vm_entry_controls & =
VM_ENTRY_LOAD_BNDCFGS))
-                       vmcs_write64(GUEST_BNDCFGS, =
vmcs12->guest_bndcfgs);
-               else
-                       vmcs_write64(GUEST_BNDCFGS, =
vmx->nested.vmcs01_guest_bndcfgs);
+       if (kvm_mpx_supported() && vmx->nested.nested_run_pending &&
+               (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS)) {
+               vmcs_write64(GUEST_BNDCFGS, vmcs12->guest_bndcfgs);
        }
 }

@@ -2283,6 +2280,10 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, =
struct vmcs12 *vmcs12,
                kvm_set_dr(vcpu, 7, vcpu->arch.dr7);
                vmcs_write64(GUEST_IA32_DEBUGCTL, =
vmx->nested.vmcs01_debugctl);
        }
+       if (kvm_mpx_supported() && (!vmx->nested.nested_run_pending ||
+               !(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS))) {
+               vmcs_write64(GUEST_BNDCFGS, =
vmx->nested.vmcs01_guest_bndcfgs);
+       }
        vmx_set_rflags(vcpu, vmcs12->guest_rflags);

        /* EXCEPTION_BITMAP and CR0_GUEST_HOST_MASK should basically be =
the

-Liran

> On 16 Jun 2019, at 1:16, Sasha Levin <sashal@kernel.org> wrote:
>=20
> Hi,
>=20
> [This is an automated email]
>=20
> This commit has been processed because it contains a "Fixes:" tag,
> fixing commit: 62cf9bd8118c KVM: nVMX: Fix emulation of =
VM_ENTRY_LOAD_BNDCFGS.
>=20
> The bot has tested the following trees: v5.1.9, v4.19.50.
>=20
> v5.1.9: Build OK!
> v4.19.50: Failed to apply! Possible dependencies:
>    09abb5e3e5e5 ("KVM: nVMX: call kvm_skip_emulated_instruction in =
nested_vmx_{fail,succeed}")
>    09abe3200266 ("KVM: nVMX: split pieces of prepare_vmcs02() to =
prepare_vmcs02_early()")
>    1438921c6dc1 ("KVM: nVMX: Flush TLB entries tagged by dest EPTP on =
L1<->L2 transitions")
>    199b118ab3d5 ("KVM: VMX: Alphabetize the includes in vmx.c")
>    1abf23fb42f5 ("KVM: nVMX: use vm_exit_controls_init() to write exit =
controls for vmcs02")
>    327c072187f7 ("KVM: nVMX: Flush linear and combined mappings on =
VPID02 related flushes")
>    3d5bdae8b164 ("KVM: nVMX: Use correct VPID02 when emulating L1 =
INVVPID")
>    3df5c37e55c8 ("KVM: nVMX: try to set EFER bits correctly when =
initializing controls")
>    55d2375e58a6 ("KVM: nVMX: Move nested code to dedicated files")
>    5b8ba41dafd7 ("KVM: nVMX: move vmcs12 EPTP consistency check to =
check_vmentry_prereqs()")
>    609363cf81fc ("KVM: nVMX: Move vmcs12 code to dedicated files")
>    75edce8a4548 ("KVM: VMX: Move eVMCS code to dedicated files")
>    7671ce21b13b ("KVM: nVMX: move check_vmentry_postreqs() call to =
nested_vmx_enter_non_root_mode()")
>    945679e301ea ("KVM: nVMX: add enlightened VMCS state")
>    a633e41e7362 ("KVM: nVMX: assimilate nested_vmx_entry_failure() =
into nested_vmx_enter_non_root_mode()")
>    a821bab2d1ee ("KVM: VMX: Move VMX specific files to a "vmx" =
subdirectory")
>    b8bbab928fb1 ("KVM: nVMX: implement enlightened VMPTRLD and =
VMCLEAR")
>    d63907dc7dd1 ("KVM: nVMX: rename enter_vmx_non_root_mode to =
nested_vmx_enter_non_root_mode")
>    efebf0aaec3d ("KVM: nVMX: Do not flush TLB on L1<->L2 transitions =
if L1 uses VPID and EPT")
>=20
>=20
> How should we proceed with this patch?
>=20
> --
> Thanks,
> Sasha

