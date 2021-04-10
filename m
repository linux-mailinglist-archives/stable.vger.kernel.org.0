Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C1B435ACC3
	for <lists+stable@lfdr.de>; Sat, 10 Apr 2021 12:53:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234334AbhDJKyA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Apr 2021 06:54:00 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:17942 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234091AbhDJKx7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Apr 2021 06:53:59 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13AAYCNC184034;
        Sat, 10 Apr 2021 06:53:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : from : to : cc
 : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=pp1;
 bh=nUQNm2CQa0B9cBDRzsYwCrSnAyURWU+Hz7InaBxw1og=;
 b=UhtcUIQkqd4BUFRXw8bLBX5u6Bg0b+9dt64IOkUfD/qUVqK9peanvjY582Ap946kyeKp
 PWBer7mUKoxTCInCBC1LoWywAmPppdsR3ps0MPSOSnQvHO75dU+tfrBV9eGQr3xSrZn8
 IvIUjve4+u86PXrTobI4tWwmN/DkSUnEZQuBLqj2mlUJ0FN3HQo7Ck4PngiBgNT7yWoU
 SYbgoDgkKGy8GkbU7uNI/JW8ESP3zAQT7OutZzMbU06UIrTZ9TCQPXKibCPy2erPjtdZ
 Qj3NvNSdvY9l/T58eX7Yt9A9msmmnNnfC7+Yd82Cx/ewzwSqbCmzRmrITRd5RSSYCjr+ Mg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37u7nx2grs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 10 Apr 2021 06:53:39 -0400
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 13AArcvn034185;
        Sat, 10 Apr 2021 06:53:38 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37u7nx2grg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 10 Apr 2021 06:53:38 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 13AArZs9022995;
        Sat, 10 Apr 2021 10:53:35 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma02fra.de.ibm.com with ESMTP id 37u3n8g3m4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 10 Apr 2021 10:53:35 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 13AArXrI27132258
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 10 Apr 2021 10:53:33 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 60F01A405C;
        Sat, 10 Apr 2021 10:53:33 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 94B40A4054;
        Sat, 10 Apr 2021 10:53:32 +0000 (GMT)
Received: from [127.0.0.1] (unknown [9.85.75.114])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Sat, 10 Apr 2021 10:53:32 +0000 (GMT)
Subject: [PATCH] powerpc/eeh: Fix EEH handling for hugepages in ioremap space.
From:   Mahesh Salgaonkar <mahesh@linux.ibm.com>
To:     linuxppc-dev <linuxppc-dev@ozlabs.org>
Cc:     "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        "Oliver O'Halloran" <oohall@gmail.com>, stable@vger.kernel.org
Date:   Sat, 10 Apr 2021 16:23:31 +0530
Message-ID: <161805199853.261673.7916384243925355614.stgit@jupiter>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 6zDw5VkTidqSJoZQiNyQxWWRKtuNeSe3
X-Proofpoint-ORIG-GUID: tFNMatB9o4ju5PL1A0mMWqRJ4vtTAisU
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-10_06:2021-04-09,2021-04-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 phishscore=0
 impostorscore=0 clxscore=1011 mlxscore=0 lowpriorityscore=0 suspectscore=0
 adultscore=0 bulkscore=0 priorityscore=1501 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104100080
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

# cat /sys/kernel/debug/powerpc/eeh_address_cache
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
 arch/powerpc/kernel/eeh.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/arch/powerpc/kernel/eeh.c b/arch/powerpc/kernel/eeh.c
index cd60bc1c87011..c8a8020ef7768 100644
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
+	pa |= token & ((1ul << hugepage_shift) -1);
 	return pa;
 }
 


