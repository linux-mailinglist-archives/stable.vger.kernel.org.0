Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95AC7269225
	for <lists+stable@lfdr.de>; Mon, 14 Sep 2020 18:52:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726121AbgINQwj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Sep 2020 12:52:39 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:7042 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726174AbgINQvB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Sep 2020 12:51:01 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08EGUqrn126648;
        Mon, 14 Sep 2020 12:50:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=pp1;
 bh=F+6vQedN52j8wgtFjBUAiJBhp+e0vxfPw/ZjD+hUdYk=;
 b=gw8SIyU+lBQfuXuu9NGvUbGkH3uqOnZfQ8/G0Z2nyn21hf+zAxg24vFq6JjLsTN9zKNd
 PwEXeyV/VYBFG+sH+fDqLCU9x59p+zzoxgb/cFCat4wKQE865xO6hr7HCEKYyr/QHAvm
 W+uXayO62Z4+pTywaTr/1iZk6clYjRgglFc/hGcXgmikPpND/JBB/yE+AlgX0N3T3cNm
 3pBBLcUM8tPFRugcB5VYIoZq4PF7tO3f2q4mdXWTBEQAerMmNNBV9/tGQ7zn4NmvdFVX
 o2Ti1ikigkAvtMGsc1Sf0/A6oxnxM6l+8IWlciJ73k61BVXHOy7J4d7Iw7YmfJ+FMmej dw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33jbx7guyd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Sep 2020 12:50:50 -0400
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 08EGV8je127370;
        Mon, 14 Sep 2020 12:50:49 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33jbx7guxw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Sep 2020 12:50:49 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08EGlGAW015707;
        Mon, 14 Sep 2020 16:50:48 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04ams.nl.ibm.com with ESMTP id 33h2r99ybs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Sep 2020 16:50:47 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08EGojis21037426
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Sep 2020 16:50:45 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F3EBCA4059;
        Mon, 14 Sep 2020 16:50:44 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7F681A4055;
        Mon, 14 Sep 2020 16:50:44 +0000 (GMT)
Received: from pomme.tlslab.ibm.com (unknown [9.145.51.157])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 14 Sep 2020 16:50:44 +0000 (GMT)
From:   Laurent Dufour <ldufour@linux.ibm.com>
To:     akpm@linux-foundation.org, David Hildenbrand <david@redhat.com>,
        Oscar Salvador <osalvador@suse.de>, mhocko@kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-mm@kvack.org, "Rafael J . Wysocki" <rafael@kernel.org>,
        nathanl@linux.ibm.com, cheloha@linux.ibm.com,
        Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>, linux-ia64@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH v2 0/3] mm: fix memory to node bad links in sysfs
Date:   Mon, 14 Sep 2020 18:50:39 +0200
Message-Id: <20200914165042.96218-1-ldufour@linux.ibm.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-14_06:2020-09-14,2020-09-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 clxscore=1015
 impostorscore=0 priorityscore=1501 lowpriorityscore=0 suspectscore=0
 malwarescore=0 phishscore=0 spamscore=0 bulkscore=0 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009140129
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Sometimes, firmware may expose interleaved memory layout like this:
 Early memory node ranges
   node   1: [mem 0x0000000000000000-0x000000011fffffff]
   node   2: [mem 0x0000000120000000-0x000000014fffffff]
   node   1: [mem 0x0000000150000000-0x00000001ffffffff]
   node   0: [mem 0x0000000200000000-0x000000048fffffff]
   node   2: [mem 0x0000000490000000-0x00000007ffffffff]

In that case, we can see memory blocks assigned to multiple nodes in sysfs:

$ ls -l /sys/devices/system/memory/memory21
total 0
lrwxrwxrwx 1 root root     0 Aug 24 05:27 node1 -> ../../node/node1
lrwxrwxrwx 1 root root     0 Aug 24 05:27 node2 -> ../../node/node2
-rw-r--r-- 1 root root 65536 Aug 24 05:27 online
-r--r--r-- 1 root root 65536 Aug 24 05:27 phys_device
-r--r--r-- 1 root root 65536 Aug 24 05:27 phys_index
drwxr-xr-x 2 root root     0 Aug 24 05:27 power
-r--r--r-- 1 root root 65536 Aug 24 05:27 removable
-rw-r--r-- 1 root root 65536 Aug 24 05:27 state
lrwxrwxrwx 1 root root     0 Aug 24 05:25 subsystem -> ../../../../bus/memory
-rw-r--r-- 1 root root 65536 Aug 24 05:25 uevent
-r--r--r-- 1 root root 65536 Aug 24 05:27 valid_zones

The same applies in the node's directory with a memory21 link in both the
node1 and node2's directory.

This is wrong but doesn't prevent the system to run. However when later one
of these memory blocks is hot-unplugged and then hot-plugged, the system is
detecting an inconsistency in the sysfs layout and a BUG_ON() is raised:

------------[ cut here ]------------
kernel BUG at /Users/laurent/src/linux-ppc/mm/memory_hotplug.c:1084!
Oops: Exception in kernel mode, sig: 5 [#1]
LE PAGE_SIZE=64K MMU=Hash SMP NR_CPUS=2048 NUMA pSeries
Modules linked in: rpadlpar_io rpaphp pseries_rng rng_core vmx_crypto gf128mul binfmt_misc ip_tables x_tables xfs libcrc32c crc32c_vpmsum autofs4
CPU: 8 PID: 10256 Comm: drmgr Not tainted 5.9.0-rc1+ #25
NIP:  c000000000403f34 LR: c000000000403f2c CTR: 0000000000000000
REGS: c0000004876e3660 TRAP: 0700   Not tainted  (5.9.0-rc1+)
MSR:  800000000282b033 <SF,VEC,VSX,EE,FP,ME,IR,DR,RI,LE>  CR: 24000448  XER: 20040000
CFAR: c000000000846d20 IRQMASK: 0
GPR00: c000000000403f2c c0000004876e38f0 c0000000012f6f00 ffffffffffffffef
GPR04: 0000000000000227 c0000004805ae680 0000000000000000 00000004886f0000
GPR08: 0000000000000226 0000000000000003 0000000000000002 fffffffffffffffd
GPR12: 0000000088000484 c00000001ec96280 0000000000000000 0000000000000000
GPR16: 0000000000000000 0000000000000000 0000000000000004 0000000000000003
GPR20: c00000047814ffe0 c0000007ffff7c08 0000000000000010 c0000000013332c8
GPR24: 0000000000000000 c0000000011f6cc0 0000000000000000 0000000000000000
GPR28: ffffffffffffffef 0000000000000001 0000000150000000 0000000010000000
NIP [c000000000403f34] add_memory_resource+0x244/0x340
LR [c000000000403f2c] add_memory_resource+0x23c/0x340
Call Trace:
[c0000004876e38f0] [c000000000403f2c] add_memory_resource+0x23c/0x340 (unreliable)
[c0000004876e39c0] [c00000000040408c] __add_memory+0x5c/0xf0
[c0000004876e39f0] [c0000000000e2b94] dlpar_add_lmb+0x1b4/0x500
[c0000004876e3ad0] [c0000000000e3888] dlpar_memory+0x1f8/0xb80
[c0000004876e3b60] [c0000000000dc0d0] handle_dlpar_errorlog+0xc0/0x190
[c0000004876e3bd0] [c0000000000dc398] dlpar_store+0x198/0x4a0
[c0000004876e3c90] [c00000000072e630] kobj_attr_store+0x30/0x50
[c0000004876e3cb0] [c00000000051f954] sysfs_kf_write+0x64/0x90
[c0000004876e3cd0] [c00000000051ee40] kernfs_fop_write+0x1b0/0x290
[c0000004876e3d20] [c000000000438dd8] vfs_write+0xe8/0x290
[c0000004876e3d70] [c0000000004391ac] ksys_write+0xdc/0x130
[c0000004876e3dc0] [c000000000034e40] system_call_exception+0x160/0x270
[c0000004876e3e20] [c00000000000d740] system_call_common+0xf0/0x27c
Instruction dump:
48442e35 60000000 0b030000 3cbe0001 7fa3eb78 7bc48402 38a5fffe 7ca5fa14
78a58402 48442db1 60000000 7c7c1b78 <0b030000> 7f23cb78 4bda371d 60000000
---[ end trace 562fd6c109cd0fb2 ]---

This has been seen on PowerPC LPAR.

The root cause of this issue is that when node's memory is registered, the
range used can overlap another node's range, thus the memory block is
registered to multiple nodes in sysfs.

There are 2 issues here:

a. The sysfs memory and node's layout are broken due to these multiple
   links

b. The link errors in link_mem_sections() should not lead to a system
   panic.

To address a. register_mem_sect_under_node should not rely on the system
state to detect whether the link operation is triggered by a hot plug
operation or not. This is addressed by the patches 1 and 2 of this series.

The patch 3 is addressing the point b.

Thanks,
Laurent

Since v1:
- change context enum's name from Michal's comment
- use 2 callbacks in link_mem_sections from David's comment
- use dev_err_ratelimited from Greg's comment

Laurent Dufour (3):
  mm: replace memmap_context by memplug_context
  mm: don't rely on system state to detect hot-plug operations
  mm: don't panic when links can't be created in sysfs

 arch/ia64/mm/init.c    |  6 +--
 drivers/base/node.c    | 99 ++++++++++++++++++++++++++++--------------
 include/linux/mm.h     |  2 +-
 include/linux/mmzone.h | 11 +++--
 include/linux/node.h   | 13 +++---
 mm/memory_hotplug.c    |  6 +--
 mm/page_alloc.c        | 10 ++---
 7 files changed, 94 insertions(+), 53 deletions(-)

-- 
2.28.0

