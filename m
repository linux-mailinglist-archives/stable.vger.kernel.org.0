Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5B73193FC9
	for <lists+stable@lfdr.de>; Thu, 26 Mar 2020 14:33:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726359AbgCZNdU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Mar 2020 09:33:20 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:23166 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726318AbgCZNdU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Mar 2020 09:33:20 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02QDW0Ql040299;
        Thu, 26 Mar 2020 09:33:03 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ywbtk8jkh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 26 Mar 2020 09:33:03 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 02QDWC8H041188;
        Thu, 26 Mar 2020 09:33:02 -0400
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ywbtk8jht-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 26 Mar 2020 09:33:02 -0400
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 02QDV3Ar024883;
        Thu, 26 Mar 2020 13:33:00 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma02wdc.us.ibm.com with ESMTP id 2ywawk9xdt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 26 Mar 2020 13:33:00 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 02QDWxlq47972700
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 26 Mar 2020 13:32:59 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DCA65136053;
        Thu, 26 Mar 2020 13:32:58 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 909F5136055;
        Thu, 26 Mar 2020 13:32:53 +0000 (GMT)
Received: from skywalker.ibmuc.com (unknown [9.199.60.66])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 26 Mar 2020 13:32:53 +0000 (GMT)
From:   "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
To:     linux-mm@kvack.org, akpm@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, mpe@ellerman.id.au,
        linuxppc-dev@lists.ozlabs.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Sachin Sant <sachinp@linux.vnet.ibm.com>,
        Baoquan He <bhe@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
        David Hildenbrand <david@redhat.com>,
        Michal Hocko <mhocko@suse.com>,
        Wei Yang <richardw.yang@linux.intel.com>,
        Oscar Salvador <osalvador@suse.de>,
        Mike Rapoport <rppt@linux.ibm.com>, stable@vger.kernel.org
Subject: [PATCH v2] mm/sparse: Fix kernel crash with pfn_section_valid check
Date:   Thu, 26 Mar 2020 19:02:35 +0530
Message-Id: <20200326133235.343616-1-aneesh.kumar@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-26_03:2020-03-26,2020-03-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 phishscore=0 impostorscore=0 priorityscore=1501 spamscore=0 bulkscore=0
 mlxlogscore=999 lowpriorityscore=0 clxscore=1011 adultscore=0
 suspectscore=2 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003260100
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Fixes the below crash

BUG: Kernel NULL pointer dereference on read at 0x00000000
Faulting instruction address: 0xc000000000c3447c
Oops: Kernel access of bad area, sig: 11 [#1]
LE PAGE_SIZE=64K MMU=Hash SMP NR_CPUS=2048 NUMA pSeries
CPU: 11 PID: 7519 Comm: lt-ndctl Not tainted 5.6.0-rc7-autotest #1
...
NIP [c000000000c3447c] vmemmap_populated+0x98/0xc0
LR [c000000000088354] vmemmap_free+0x144/0x320
Call Trace:
 section_deactivate+0x220/0x240
 __remove_pages+0x118/0x170
 arch_remove_memory+0x3c/0x150
 memunmap_pages+0x1cc/0x2f0
 devm_action_release+0x30/0x50
 release_nodes+0x2f8/0x3e0
 device_release_driver_internal+0x168/0x270
 unbind_store+0x130/0x170
 drv_attr_store+0x44/0x60
 sysfs_kf_write+0x68/0x80
 kernfs_fop_write+0x100/0x290
 __vfs_write+0x3c/0x70
 vfs_write+0xcc/0x240
 ksys_write+0x7c/0x140
 system_call+0x5c/0x68

The crash is due to NULL dereference at

test_bit(idx, ms->usage->subsection_map); due to ms->usage = NULL; in pfn_section_valid()

With commit: d41e2f3bd546 ("mm/hotplug: fix hot remove failure in SPARSEMEM|!VMEMMAP case")
section_mem_map is set to NULL after depopulate_section_mem(). This
was done so that pfn_page() can work correctly with kernel config that disables
SPARSEMEM_VMEMMAP. With that config pfn_to_page does

	__section_mem_map_addr(__sec) + __pfn;
where

static inline struct page *__section_mem_map_addr(struct mem_section *section)
{
	unsigned long map = section->section_mem_map;
	map &= SECTION_MAP_MASK;
	return (struct page *)map;
}

Now with SPASEMEM_VMEMAP enabled, mem_section->usage->subsection_map is used to
check the pfn validity (pfn_valid()). Since section_deactivate release
mem_section->usage if a section is fully deactivated, pfn_valid() check after
a subsection_deactivate cause a kernel crash.

static inline int pfn_valid(unsigned long pfn)
{
...
	return early_section(ms) || pfn_section_valid(ms, pfn);
}

where

static inline int pfn_section_valid(struct mem_section *ms, unsigned long pfn)
{
	int idx = subsection_map_index(pfn);

	return test_bit(idx, ms->usage->subsection_map);
}

Avoid this by clearing SECTION_HAS_MEM_MAP when mem_section->usage is freed.
For architectures like ppc64 where large pages are used for vmmemap mapping (16MB),
a specific vmemmap mapping can cover multiple sections. Hence before a vmemmap
mapping page can be freed, the kernel needs to make sure there are no valid sections
within that mapping. Clearing the section valid bit before
depopulate_section_memap enables this.

Fixes: d41e2f3bd546 ("mm/hotplug: fix hot remove failure in SPARSEMEM|!VMEMMAP case")
Reported-by: Sachin Sant <sachinp@linux.vnet.ibm.com>
Tested-by: Sachin Sant <sachinp@linux.vnet.ibm.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Wei Yang <richardw.yang@linux.intel.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
---
 mm/sparse.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/sparse.c b/mm/sparse.c
index aadb7298dcef..65599e8bd636 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -781,6 +781,12 @@ static void section_deactivate(unsigned long pfn, unsigned long nr_pages,
 			ms->usage = NULL;
 		}
 		memmap = sparse_decode_mem_map(ms->section_mem_map, section_nr);
+		/*
+		 * Mark the section invalid so that valid_section()
+		 * return false. This prevents code from dereferencing
+		 * ms->usage array.
+		 */
+		ms->section_mem_map &= ~SECTION_HAS_MEM_MAP;
 	}
 
 	if (section_is_early && memmap)
-- 
2.25.1

