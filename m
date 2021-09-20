Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFA384117C7
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 17:06:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241008AbhITPID (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 11:08:03 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:42353 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231887AbhITPIC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Sep 2021 11:08:02 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18KEqSee000704;
        Mon, 20 Sep 2021 11:06:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=KDjxkd14nRVtOgtnT6rhOyJLj0VFlkC67g+lGVb9ldk=;
 b=TcFNURbQ7FtsFDDCMsiET3ZLzfAIWTkWzJj2byu5RuOIfthlsi9Gaqt/eD90cd/zDQ6T
 G9x+7r6FszJUQHUTHKssdaDXMBpAoID//Ll/JPzaZipU/DjPgVvqwTLrDdGabJPG31Gf
 joCMxzKlPp98hI4osI0sswU4cX9LcPaM3P0QvjRbczmZXGC1iVadDVKVzds9u9h636Ep
 jieodcAyuPe8ieFfqeeMjUqHu+XUsqgl5jGPzt38w7nNu4o/8EsOmBP9vUpSbvpa8Ny1
 q/iGC10pmDmQKKResHMjc7XvTro6fHGibC6P2fGuyQqy3fEmhldNR0ueEhDhtGW+47JG dQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3b5w0pd4mg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Sep 2021 11:06:34 -0400
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18KEqQG0000519;
        Mon, 20 Sep 2021 11:06:33 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3b5w0pd4kg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Sep 2021 11:06:33 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18KF39JT021035;
        Mon, 20 Sep 2021 15:06:31 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3b57r9a38q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Sep 2021 15:06:31 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18KF6RZ333685842
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Sep 2021 15:06:28 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DA4E0A4059;
        Mon, 20 Sep 2021 15:06:27 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BFC99A404D;
        Mon, 20 Sep 2021 15:06:27 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon, 20 Sep 2021 15:06:27 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id 4B283E21CB; Mon, 20 Sep 2021 17:06:27 +0200 (CEST)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, KVM <kvm@vger.kernel.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Thomas Huth <thuth@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Nitesh Narayan Lal <nitesh@redhat.com>
Subject: [PATCH 1/1] KVM: s390: index kvm->arch.idle_mask by vcpu_idx
Date:   Mon, 20 Sep 2021 17:06:16 +0200
Message-Id: <20210920150616.15668-2-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210920150616.15668-1-borntraeger@de.ibm.com>
References: <20210920150616.15668-1-borntraeger@de.ibm.com>
Content-Type: text/plain; charset=UTF-8
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: slER6YTUo1wt1kCRgmB23Ny2_ADVxkws
X-Proofpoint-GUID: C_hE8v4HyWOdwhivGakjUcIuSnqGwUa-
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-20_07,2021-09-20_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 adultscore=0
 mlxscore=0 lowpriorityscore=0 suspectscore=0 mlxlogscore=999 spamscore=0
 clxscore=1015 priorityscore=1501 malwarescore=0 impostorscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109200097
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Halil Pasic <pasic@linux.ibm.com>

While in practice vcpu->vcpu_idx ==  vcpu->vcp_id is often true, it may
not always be, and we must not rely on this. Reason is that KVM decides
the vcpu_idx, userspace decides the vcpu_id, thus the two might not
match.

Currently kvm->arch.idle_mask is indexed by vcpu_id, which implies
that code like
for_each_set_bit(vcpu_id, kvm->arch.idle_mask, online_vcpus) {
                vcpu = kvm_get_vcpu(kvm, vcpu_id);
		do_stuff(vcpu);
}
is not legit. Reason is that kvm_get_vcpu expects an vcpu_idx, not an
vcpu_id.  The trouble is, we do actually use kvm->arch.idle_mask like
this. To fix this problem we have two options. Either use
kvm_get_vcpu_by_id(vcpu_id), which would loop to find the right vcpu_id,
or switch to indexing via vcpu_idx. The latter is preferable for obvious
reasons.

Let us make switch from indexing kvm->arch.idle_mask by vcpu_id to
indexing it by vcpu_idx.  To keep gisa_int.kicked_mask indexed by the
same index as idle_mask lets make the same change for it as well.

Fixes: 1ee0bc559dc3 ("KVM: s390: get rid of local_int array")
Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
Reviewed-by: Christian Bornträger <borntraeger@de.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: <stable@vger.kernel.org> # 3.15+
Link: https://lore.kernel.org/r/20210827125429.1912577-1-pasic@linux.ibm.com
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
[borntraeger@de.ibm.com]: change  idle mask, remove kicked_mask 
---
 arch/s390/kvm/interrupt.c | 4 ++--
 arch/s390/kvm/kvm-s390.h  | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
index 3515f2b55eb9..dc5ecaea30d7 100644
--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -318,13 +318,13 @@ static unsigned long deliverable_irqs(struct kvm_vcpu *vcpu)
 static void __set_cpu_idle(struct kvm_vcpu *vcpu)
 {
 	kvm_s390_set_cpuflags(vcpu, CPUSTAT_WAIT);
-	set_bit(vcpu->vcpu_id, vcpu->kvm->arch.float_int.idle_mask);
+	set_bit(kvm_vcpu_get_idx(vcpu), vcpu->kvm->arch.float_int.idle_mask);
 }
 
 static void __unset_cpu_idle(struct kvm_vcpu *vcpu)
 {
 	kvm_s390_clear_cpuflags(vcpu, CPUSTAT_WAIT);
-	clear_bit(vcpu->vcpu_id, vcpu->kvm->arch.float_int.idle_mask);
+	clear_bit(kvm_vcpu_get_idx(vcpu), vcpu->kvm->arch.float_int.idle_mask);
 }
 
 static void __reset_intercept_indicators(struct kvm_vcpu *vcpu)
diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
index 981e3ba97461..0a2ffd5378be 100644
--- a/arch/s390/kvm/kvm-s390.h
+++ b/arch/s390/kvm/kvm-s390.h
@@ -67,7 +67,7 @@ static inline int is_vcpu_stopped(struct kvm_vcpu *vcpu)
 
 static inline int is_vcpu_idle(struct kvm_vcpu *vcpu)
 {
-	return test_bit(vcpu->vcpu_id, vcpu->kvm->arch.float_int.idle_mask);
+	return test_bit(kvm_vcpu_get_idx(vcpu), vcpu->kvm->arch.float_int.idle_mask);
 }
 
 static inline int kvm_is_ucontrol(struct kvm *kvm)
-- 
2.31.1

