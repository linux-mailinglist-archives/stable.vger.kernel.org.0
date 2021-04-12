Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 168A335BB6C
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 09:53:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237008AbhDLHxU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 03:53:20 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:33004 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S236970AbhDLHxT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Apr 2021 03:53:19 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13C7XC9v059894;
        Mon, 12 Apr 2021 03:52:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : from : to : cc
 : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=pp1;
 bh=2eJvQOS6E/zKOudLH/zDp1EZGSIsPqfv4AhHwqZGA+U=;
 b=HZ/BRyoxWWdvC5YVsjurvvUYv+oszYwLVZaoHq0dZ1JFHZJ203SYNMrpk7oTL5dDx7cV
 HJEb9Pmkx7x4gFw5GKtkKmtNnpnbey30ZmmBNORdjwro2nXgkNu6QZ0AubPrucVWMzle
 RRunND1KbiS5rbFe2eUr3wUbZROSL+QHJutOaRfgRM5cz9VP38WhTyMdWWRzc1LIxExT
 cQmhitGhPMsOn9xtGIqOE7cEBfOKWNjE/HUM5QotCCn2ZzjGFqflAvCY9ngFbiSVg8QZ
 C8esn2IToBXRCf2plQv6glwBkjkQcycaklIxiy54iOZywIkMhQi7W9HIbg6GHh/xVYLI 0A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37usn5h3mp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Apr 2021 03:52:57 -0400
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 13C7b8J6075928;
        Mon, 12 Apr 2021 03:52:57 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37usn5h3m7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Apr 2021 03:52:57 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 13C7m4FZ007447;
        Mon, 12 Apr 2021 07:52:55 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03ams.nl.ibm.com with ESMTP id 37u3n89kd6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Apr 2021 07:52:55 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 13C7qVso35717486
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Apr 2021 07:52:31 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5D8105204F;
        Mon, 12 Apr 2021 07:52:53 +0000 (GMT)
Received: from [192.168.0.71] (unknown [9.77.202.246])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 9270C5204E;
        Mon, 12 Apr 2021 07:52:52 +0000 (GMT)
Subject: [PATCH v2] powerpc/eeh: Fix EEH handling for hugepages in ioremap
 space.
From:   Mahesh Salgaonkar <mahesh@linux.ibm.com>
To:     linuxppc-dev <linuxppc-dev@ozlabs.org>
Cc:     "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        "Oliver O'Halloran" <oohall@gmail.com>, stable@vger.kernel.org
Date:   Mon, 12 Apr 2021 13:22:50 +0530
Message-ID: <161821396263.48361.2796709239866588652.stgit@jupiter>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: eWo9JZbFsZqSfDSfbqHExobxDTFwFzWj
X-Proofpoint-ORIG-GUID: 8sC4WyEOEIX1y_xoYvLpax-TFDYjlwCI
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-12_04:2021-04-12,2021-04-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 impostorscore=0
 clxscore=1015 mlxlogscore=999 lowpriorityscore=0 priorityscore=1501
 malwarescore=0 suspectscore=0 mlxscore=0 adultscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104120048
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

During the EEH MMIO error checking, the current implementation fails to map
the (virtual) MMIO address back to the pci device on radix with hugepage
mappings for I/O. This results into failure to dispatch EEH event with no
recovery even when EEH capability has been enabled on the device.

eeh_check_failure(token)		# token = virtual MMIO address
  addr = eeh_token_to_phys(token);
  edev = eeh_addr_cache_get_dev(addr);
  if (!edev)
	return 0;
  eeh_dev_check_failure(edev);	<= Dispatch the EEH event

In case of hugepage mappings, eeh_token_to_phys() has a bug in virt -> phys
translation that results in wrong physical address, which is then passed to
eeh_addr_cache_get_dev() to match it against cached pci I/O address ranges
to get to a PCI device. Hence, it fails to find a match and the EEH event
never gets dispatched leaving the device in failed state.

The commit 33439620680be ("powerpc/eeh: Handle hugepages in ioremap space")
introduced following logic to translate virt to phys for hugepage mappings:

eeh_token_to_phys():
+	pa = pte_pfn(*ptep);
+
+	/* On radix we can do hugepage mappings for io, so handle that */
+       if (hugepage_shift) {
+               pa <<= hugepage_shift;			<= This is wrong
+               pa |= token & ((1ul << hugepage_shift) - 1);
+       }

This patch fixes the virt -> phys translation in eeh_token_to_phys()
function.

$ cat /sys/kernel/debug/powerpc/eeh_address_cache
mem addr range [0x0000040080000000-0x00000400807fffff]: 0030:01:00.1
mem addr range [0x0000040080800000-0x0000040080ffffff]: 0030:01:00.1
mem addr range [0x0000040081000000-0x00000400817fffff]: 0030:01:00.0
mem addr range [0x0000040081800000-0x0000040081ffffff]: 0030:01:00.0
mem addr range [0x0000040082000000-0x000004008207ffff]: 0030:01:00.1
mem addr range [0x0000040082080000-0x00000400820fffff]: 0030:01:00.0
mem addr range [0x0000040082100000-0x000004008210ffff]: 0030:01:00.1
mem addr range [0x0000040082110000-0x000004008211ffff]: 0030:01:00.0

Above is the list of cached io address ranges of pci 0030:01:00.<fn>.

Before this patch:

Tracing 'arg1' of function eeh_addr_cache_get_dev() during error injection
clearly shows that 'addr=' contains wrong physical address:

   kworker/u16:0-7       [001] ....   108.883775: eeh_addr_cache_get_dev:
	   (eeh_addr_cache_get_dev+0xc/0xf0) addr=0x80103000a510

dmesg shows no EEH recovery messages:

[  108.563768] bnx2x: [bnx2x_timer:5801(eth2)]MFW seems hanged: drv_pulse (0x9ae) != mcp_pulse (0x7fff)
[  108.563788] bnx2x: [bnx2x_hw_stats_update:870(eth2)]NIG timer max (4294967295)
[  108.883788] bnx2x: [bnx2x_acquire_hw_lock:2013(eth1)]lock_status 0xffffffff  resource_bit 0x1
[  108.884407] bnx2x 0030:01:00.0 eth1: MDC/MDIO access timeout
[  108.884976] bnx2x 0030:01:00.0 eth1: MDC/MDIO access timeout
<..>

After this patch:

eeh_addr_cache_get_dev() trace shows correct physical address:

  <idle>-0       [001] ..s.  1043.123828: eeh_addr_cache_get_dev:
	  (eeh_addr_cache_get_dev+0xc/0xf0) addr=0x40080bc7cd8

dmesg logs shows EEH recovery getting triggerred:

[  964.323980] bnx2x: [bnx2x_timer:5801(eth2)]MFW seems hanged: drv_pulse (0x746f) != mcp_pulse (0x7fff)
[  964.323991] EEH: Recovering PHB#30-PE#10000
[  964.324002] EEH: PE location: N/A, PHB location: N/A
[  964.324006] EEH: Frozen PHB#30-PE#10000 detected
<..>

Cc: stable@vger.kernel.org
Fixes: 33439620680be ("powerpc/eeh: Handle hugepages in ioremap space")
Signed-off-by: Mahesh Salgaonkar <mahesh@linux.ibm.com>
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Reported-by: Dominic DeMarco <ddemarc@us.ibm.com>
---
Change in v2:
- Fixed error reported by checkpatch.pl.
---
 arch/powerpc/kernel/eeh.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/arch/powerpc/kernel/eeh.c b/arch/powerpc/kernel/eeh.c
index cd60bc1c87011..7040e430a1249 100644
--- a/arch/powerpc/kernel/eeh.c
+++ b/arch/powerpc/kernel/eeh.c
@@ -362,14 +362,11 @@ static inline unsigned long eeh_token_to_phys(unsigned long token)
 	pa = pte_pfn(*ptep);
 
 	/* On radix we can do hugepage mappings for io, so handle that */
-	if (hugepage_shift) {
-		pa <<= hugepage_shift;
-		pa |= token & ((1ul << hugepage_shift) - 1);
-	} else {
-		pa <<= PAGE_SHIFT;
-		pa |= token & (PAGE_SIZE - 1);
-	}
+	if (!hugepage_shift)
+		hugepage_shift = PAGE_SHIFT;
 
+	pa <<= PAGE_SHIFT;
+	pa |= token & ((1ul << hugepage_shift) - 1);
 	return pa;
 }
 


