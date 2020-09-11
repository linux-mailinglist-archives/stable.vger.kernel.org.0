Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBBC026652F
	for <lists+stable@lfdr.de>; Fri, 11 Sep 2020 18:55:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725899AbgIKQyh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Sep 2020 12:54:37 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:58294 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725871AbgIKPGC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Sep 2020 11:06:02 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08BDbb4P093848;
        Fri, 11 Sep 2020 09:48:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=ei5AstFw1vGIIFkfnjqzkVRUvf9FSHCCUXQaJx3hUw0=;
 b=aALmu7lOKsENbHb4b21fh7Z58izDZa7+2CxErqPWuAgx3bbSpSd6sYWcnTWxfbvb5ick
 iagSSOcPCCwkYJ1p5qXOwLMe/gI9cAh4SGHVqsgVoYbROod8I8ROxfwJW/4Q4Af9l4w3
 kmqtNsZY+oJMai6s+hhtgs+t8gf2Kq7DN8Yz4PDUDJYujqQuBRHRQGhr4nHPvT/B6HKv
 7dcog170tJ9+6SOuFY4aDNLUEapxdYeWXChA6WmQn26S6d/YqSZWIMHmi6t/4dsZZ7XM
 e1zrfdi0/eXX3CmJWNFPl2n8aqO3/ydQ75EYrnGYiHDxR3bX7TulNKMa/XdCQgt/o8Vq WA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33ga35ghm7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Sep 2020 09:48:40 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 08BDdqUQ101786;
        Fri, 11 Sep 2020 09:48:39 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33ga35ghkp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Sep 2020 09:48:39 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08BDgnOP029604;
        Fri, 11 Sep 2020 13:48:37 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 33c2a8f9u2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Sep 2020 13:48:37 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08BDmY5u24969602
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Sep 2020 13:48:34 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A8C55AE045;
        Fri, 11 Sep 2020 13:48:34 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2FE8AAE055;
        Fri, 11 Sep 2020 13:48:34 +0000 (GMT)
Received: from pomme.tlslab.ibm.com (unknown [9.145.47.39])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 11 Sep 2020 13:48:34 +0000 (GMT)
From:   Laurent Dufour <ldufour@linux.ibm.com>
To:     akpm@linux-foundation.org, David Hildenbrand <david@redhat.com>,
        Oscar Salvador <osalvador@suse.de>, mhocko@kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-mm@kvack.org, "Rafael J . Wysocki" <rafael@kernel.org>,
        nathanl@linux.ibm.com, cheloha@linux.ibm.com,
        Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>, linux-ia64@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Michal Hocko <mhocko@suse.com>
Subject: [PATCH 2/3] mm: don't rely on system state to detect hot-plug operations
Date:   Fri, 11 Sep 2020 15:48:30 +0200
Message-Id: <20200911134831.53258-3-ldufour@linux.ibm.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200911134831.53258-1-ldufour@linux.ibm.com>
References: <20200911134831.53258-1-ldufour@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-11_05:2020-09-10,2020-09-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 adultscore=0
 bulkscore=0 impostorscore=0 phishscore=0 priorityscore=1501
 mlxlogscore=999 lowpriorityscore=0 suspectscore=0 spamscore=0
 clxscore=1011 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2009110109
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In register_mem_sect_under_node() the system_state’s value is checked to
detect whether the operation the call is made during boot time or during an
hot-plug operation. Unfortunately, that check against SYSTEM_BOOTING is
wrong because regular memory is registered at SYSTEM_SCHEDULING state. In
addition memory hot-plug operation can be triggered at this system state
too by the ACPI. So checking against the system state is not enough.

The consequence is that on system with interleaved node's ranges like this:
 Early memory node ranges
   node   1: [mem 0x0000000000000000-0x000000011fffffff]
   node   2: [mem 0x0000000120000000-0x000000014fffffff]
   node   1: [mem 0x0000000150000000-0x00000001ffffffff]
   node   0: [mem 0x0000000200000000-0x000000048fffffff]
   node   2: [mem 0x0000000490000000-0x00000007ffffffff]

This can be seen on PowerPC LPAR after multiple memory hot-plug and
hot-unplug operations are done. At the next reboot the node's memory ranges
can be interleaved and since the call to link_mem_sections() is made in
topology_init() while the system is in the SYSTEM_SCHEDULING state, the
node's id is not checked, and the sections registered to multiple nodes:

$ ls -l /sys/devices/system/memory/memory21/node*
total 0
lrwxrwxrwx 1 root root     0 Aug 24 05:27 node1 -> ../../node/node1
lrwxrwxrwx 1 root root     0 Aug 24 05:27 node2 -> ../../node/node2

In that case, the system is able to boot but if later one of theses memory
block is hot-unplugged and then hot-plugged, the sysfs inconsistency is
detected and triggered a BUG_ON():

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

This patch addresses the root cause by not relying on the system_state
value to detect whether the call is due to a hot-plug operation. An extra
parameter is needed in register_mem_sect_under_node() detailing whether the
operation is due to a hot-plug operation.

Fixes: 4fbce633910e ("mm/memory_hotplug.c: make register_mem_sect_under_node() a callback of walk_memory_range()")
Signed-off-by: Laurent Dufour <ldufour@linux.ibm.com>
Cc: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: David Hildenbrand <david@redhat.com>
---
 drivers/base/node.c  | 21 ++++++++++++++++-----
 include/linux/node.h |  9 ++++++---
 mm/memory_hotplug.c  |  3 ++-
 3 files changed, 24 insertions(+), 9 deletions(-)

diff --git a/drivers/base/node.c b/drivers/base/node.c
index 508b80f6329b..862516c5a5ae 100644
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -762,14 +762,19 @@ static int __ref get_nid_for_pfn(unsigned long pfn)
 }
 
 /* register memory section under specified node if it spans that node */
+struct rmsun_args {
+	int nid;
+	enum memplug_context context;
+};
 static int register_mem_sect_under_node(struct memory_block *mem_blk,
-					 void *arg)
+					void *args)
 {
 	unsigned long memory_block_pfns = memory_block_size_bytes() / PAGE_SIZE;
 	unsigned long start_pfn = section_nr_to_pfn(mem_blk->start_section_nr);
 	unsigned long end_pfn = start_pfn + memory_block_pfns - 1;
-	int ret, nid = *(int *)arg;
+	int ret, nid = ((struct rmsun_args *)args)->nid;
 	unsigned long pfn;
+	enum memplug_context context = ((struct rmsun_args *)args)->context;
 
 	for (pfn = start_pfn; pfn <= end_pfn; pfn++) {
 		int page_nid;
@@ -789,7 +794,7 @@ static int register_mem_sect_under_node(struct memory_block *mem_blk,
 		 * case, during hotplug we know that all pages in the memory
 		 * block belong to the same node.
 		 */
-		if (system_state == SYSTEM_BOOTING) {
+		if (context == MEMPLUG_EARLY) {
 			page_nid = get_nid_for_pfn(pfn);
 			if (page_nid < 0)
 				continue;
@@ -832,10 +837,16 @@ void unregister_memory_block_under_nodes(struct memory_block *mem_blk)
 			  kobject_name(&node_devices[mem_blk->nid]->dev.kobj));
 }
 
-int link_mem_sections(int nid, unsigned long start_pfn, unsigned long end_pfn)
+int link_mem_sections(int nid, unsigned long start_pfn, unsigned long end_pfn,
+		      enum memplug_context context)
 {
+	struct rmsun_args args = {
+		.nid = nid,
+		.context = context,
+	};
+
 	return walk_memory_blocks(PFN_PHYS(start_pfn),
-				  PFN_PHYS(end_pfn - start_pfn), (void *)&nid,
+				  PFN_PHYS(end_pfn - start_pfn), (void *)&args,
 				  register_mem_sect_under_node);
 }
 
diff --git a/include/linux/node.h b/include/linux/node.h
index 4866f32a02d8..8ff08520488c 100644
--- a/include/linux/node.h
+++ b/include/linux/node.h
@@ -100,10 +100,12 @@ typedef  void (*node_registration_func_t)(struct node *);
 
 #if defined(CONFIG_MEMORY_HOTPLUG_SPARSE) && defined(CONFIG_NUMA)
 extern int link_mem_sections(int nid, unsigned long start_pfn,
-			     unsigned long end_pfn);
+			     unsigned long end_pfn,
+			     enum memplug_context context);
 #else
 static inline int link_mem_sections(int nid, unsigned long start_pfn,
-				    unsigned long end_pfn)
+				    unsigned long end_pfn,
+				    enum memplug_context context)
 {
 	return 0;
 }
@@ -128,7 +130,8 @@ static inline int register_one_node(int nid)
 		if (error)
 			return error;
 		/* link memory sections under this node */
-		error = link_mem_sections(nid, start_pfn, end_pfn);
+		error = link_mem_sections(nid, start_pfn, end_pfn,
+					  MEMPLUG_EARLY);
 	}
 
 	return error;
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index fc21625e42de..912d355ca446 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1080,7 +1080,8 @@ int __ref add_memory_resource(int nid, struct resource *res)
 	}
 
 	/* link memory sections under this node.*/
-	ret = link_mem_sections(nid, PFN_DOWN(start), PFN_UP(start + size - 1));
+	ret = link_mem_sections(nid, PFN_DOWN(start), PFN_UP(start + size - 1),
+				MEMPLUG_HOTPLUG);
 	BUG_ON(ret);
 
 	/* create new memmap entry */
-- 
2.28.0

