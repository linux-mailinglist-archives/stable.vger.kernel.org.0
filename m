Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A99F13899F6
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 01:40:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229498AbhESXl1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 May 2021 19:41:27 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:37088 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229465AbhESXl1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 May 2021 19:41:27 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14JNZYwH161307;
        Wed, 19 May 2021 23:39:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2020-01-29; bh=BcmI4hjQDkYphdnMZxGeoJI1nIZOlj7azvP2k3pgjCM=;
 b=HG1MqiVQWXhwNjNoqDSQM4IZ8H+RmAqeWj714fp2NjGPpve/UpSvtn6NyhVrLkv3Z5bv
 kAhsFuib6q42LIWnHKHgpdIMkTAAgJ5oOIUXh96BeLmX8QrSDUWE1MCco7tJ7jTfg1KQ
 p7acC3U9shMn0ct/DJxI0I/nAql/nxVI9jkb2A0kQ53EbEyONJTBYd+t+fl/WoPmAm6s
 bpIKD6+7SzqFttp0aEA0bnP7sVaLzqOlINBP7PnBYSW1AcNgLwuTUs5YjlAvyMFaAN+y
 jBaztkFtY0/5ZrJpwp93h8nFtl9SzrgwYG2AFfH7IePOOr++y6u+Hx7CmZ4Y8TzIQD5L oA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 38j3tbk7gr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 May 2021 23:39:42 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14JNaPuf046782;
        Wed, 19 May 2021 23:39:42 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 38megkwgd9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 May 2021 23:39:41 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 14JNdb9I023642;
        Wed, 19 May 2021 23:39:38 GMT
Received: from imrkkhan-dev-1.osdevelopmeniad.oraclevcn.com (/100.100.251.75)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 19 May 2021 23:39:36 +0000
From:   Imran Khan <imran.f.khan@oracle.com>
To:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de
Cc:     x86@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [RFC PATCH] x86/apic: Fix BUG due to multiple allocation of legacy vectors.
Date:   Wed, 19 May 2021 23:39:28 +0000
Message-Id: <20210519233928.2157496-1-imran.f.khan@oracle.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9989 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 adultscore=0 malwarescore=0 bulkscore=0 mlxscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105190148
X-Proofpoint-ORIG-GUID: omrLNv57IsOoqoxeSKrS0GbcDyESt3UT
X-Proofpoint-GUID: omrLNv57IsOoqoxeSKrS0GbcDyESt3UT
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9989 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 malwarescore=0
 spamscore=0 priorityscore=1501 suspectscore=0 mlxlogscore=999 mlxscore=0
 impostorscore=0 adultscore=0 clxscore=1011 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105190148
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

During activation of secondary CPUs, lapic_online is
invoked to initialize vectors. While lapic_online
installs legacy vectors on all CPUs, it does not set
the corresponding bits in per CPU bitmap maintained
under irq_matrix.
This may result in these legacy vectors getting allocated
by irq_matrix_alloc and if that happens subsequent invocation
of apic_update_vector will cause BUG like the one shown below:

[  154.738226] kernel BUG at arch/x86/kernel/apic/vector.c:172!
[  154.805956] invalid opcode: 0000 [#1] SMP PTI
[  154.858092] CPU: 22 PID: 3569 Comm: ifup-eth Not tainted 5.8.0-20200716.x86_64 #1
[  154.954939] Hardware name: Oracle Corporation ORACLE SERVER X6-2/ASM,MOTHERBOARD,1U
[  155.073636] RIP: 0010:apic_update_vector+0xa7/0x190
[  155.131996] Code: 01 00 4a 8b 14 ed 80 69 01 a6 48 89 c8 4a 8d 04 e0 48 8b 04 10 48
85 c0 0f 84 d2 00 00 00 48 3d 00 f0 ff ff 0f 87 c6 00 00 00 <0f> 0b 41 8b 46 10 48 0f
a3 05 6b 3e 7c 01 0f 92 c0 84 c0 0f 84 83
[  155.356788] RSP: 0018:ffffb3848b417970 EFLAGS: 00010087
[  155.419311] RAX: ffff9e9047c79000 RBX: 0000000000000000 RCX: 0000000000017040
[  155.504719] RDX: ffff9e9fbf800000 RSI: 0000000000000182 RDI: ffff9e9fbe7936c0
[  155.590127] RBP: ffffb3848b4179b0 R08: 0000000000000000 R09: 0004000000000000
[  155.675533] R10: ffff000000000000 R11: 0000000000000246 R12: 0000000000000030
[  155.760939] R13: 000000000000000a R14: ffff9e9fbe7939c0 R15: 0000000000000030
[  155.846341] FS:  00007f6513279740(0000) GS:ffff9e979fb00000(0000) knlGS:0000000000000000
[  155.943189] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  156.011947] CR2: 00007f6513280000 CR3: 00000007f2cbc003 CR4: 00000000003606e0
[  156.097355] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  156.182761] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  156.268168] Call Trace:
[  156.297409]  ? irq_matrix_alloc+0x8a/0x150
[  156.346408]  assign_vector_locked+0xd2/0x170
[  156.397489]  x86_vector_activate+0x1b5/0x320
[  156.448570]  __irq_domain_activate_irq+0x64/0xa0
[  156.503808]  __irq_domain_activate_irq+0x38/0xa0
[  156.559050]  irq_domain_activate_irq+0x2b/0x40
[  156.612213]  irq_activate+0x25/0x30
[  156.653930]  __setup_irq+0x58f/0x7b0
[  156.696690]  request_threaded_irq+0xf8/0x1b0
[  156.747784]  ixgbe_open+0x3af/0x600 [ixgbe]
[  156.797827]  __dev_open+0xd8/0x160
[  156.838503]  dev_open+0x48/0x90
[  156.876065]  bond_enslave+0x2b6/0x12c0 [bonding]
[  156.931310]  ? vsscanf+0x5af/0x8e0
[  156.971986]  ? sscanf+0x4e/0x70
[  157.009546]  bond_option_slaves_set+0x112/0x1c0 [bonding]
[  157.074148]  __bond_opt_set+0xdc/0x320 [bonding]
[  157.129389]  __bond_opt_set_notify+0x2c/0x90 [bonding]
[  157.190871]  bond_opt_tryset_rtnl+0x56/0xa0 [bonding]
[  157.251315]  bonding_sysfs_store_option+0x52/0x90 [bonding]

This patch marks these legacy vectors as assigned in irq_matrix
so that corresponding bits in percpu bitmaps get set and these
legacy vectors don't get reallocted.

Signed-off-by: Imran Khan <imran.f.khan@oracle.com>
---
 arch/x86/kernel/apic/vector.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/apic/vector.c b/arch/x86/kernel/apic/vector.c
index 6dbdc7c22bb7..ea92b12614b9 100644
--- a/arch/x86/kernel/apic/vector.c
+++ b/arch/x86/kernel/apic/vector.c
@@ -806,6 +806,7 @@ static struct irq_desc *__setup_vector_irq(int vector)
 void lapic_online(void)
 {
 	unsigned int vector;
+	struct irq_desc *desc = VECTOR_UNUSED;
 
 	lockdep_assert_held(&vector_lock);
 
@@ -821,8 +822,17 @@ void lapic_online(void)
 	 * must be installed on all CPUs. All non legacy interrupts can be
 	 * cleared.
 	 */
-	for (vector = 0; vector < NR_VECTORS; vector++)
-		this_cpu_write(vector_irq[vector], __setup_vector_irq(vector));
+	for (vector = 0; vector < NR_VECTORS; vector++) {
+		desc = __setup_vector_irq(vector);
+		this_cpu_write(vector_irq[vector], desc);
+		/*
+		 * Mark legacy vectors assigned, so that
+		 * irq_matrix_alloc does not see them as
+		 * free in bitmap
+		 */
+		if (desc != VECTOR_UNUSED)
+			irq_matrix_assign(vector_matrix, vector);
+	}
 }
 
 void lapic_offline(void)
-- 
2.27.0

