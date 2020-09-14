Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A517E268817
	for <lists+stable@lfdr.de>; Mon, 14 Sep 2020 11:17:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726242AbgINJRE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Sep 2020 05:17:04 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:36238 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726199AbgINJRC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Sep 2020 05:17:02 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08E92BQM109513;
        Mon, 14 Sep 2020 05:16:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=x8Ak7cilQngXCRO6fJTm+92sTesOzVFjcI9VAyBve34=;
 b=SkLqwiQmJaq8R9tw3IREemDy/4rZa4FXmhBv8SpqYvFnjkacG0ajy7slPznKzhGaaNe8
 bkaTrMr0eBFUW/H46bIFyeRfEZzDTibG6+z0kR+BQFH/Fea7o1I1bryjiSP+KYtrvRoa
 ZxgHeOfqUqAW6HaafdBnU92TXPMEO7hgtHULzNH6tYnacEv1IDnznY/IxJNZM1eovTbu
 6k9bL4VbGW3nNpSVfDl2IHYsg9wv+BD9SXgpXaF66mzwrYwBowU3THxHC+sXm+mmp1ZV
 hceRYyafKUNXRPKiYtjpI2J5lQF8Dbrs7nQ7n/T2SJxJZeasJZ7NNUTOOthyCf0MlDTv 6w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33j58dgyf0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Sep 2020 05:16:48 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 08E92Kdl110246;
        Mon, 14 Sep 2020 05:16:48 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33j58dgye9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Sep 2020 05:16:48 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08E9CwLB000739;
        Mon, 14 Sep 2020 09:16:45 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03fra.de.ibm.com with ESMTP id 33gny812p0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Sep 2020 09:16:45 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08E9Ggtd12255712
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Sep 2020 09:16:42 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9C21F11C050;
        Mon, 14 Sep 2020 09:16:42 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C66F611C054;
        Mon, 14 Sep 2020 09:16:41 +0000 (GMT)
Received: from pomme.local (unknown [9.145.51.157])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 14 Sep 2020 09:16:41 +0000 (GMT)
Subject: Re: [PATCH 2/3] mm: don't rely on system state to detect hot-plug
 operations
To:     David Hildenbrand <david@redhat.com>,
        Oscar Salvador <osalvador@suse.de>
Cc:     akpm@linux-foundation.org, mhocko@kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-mm@kvack.org, "Rafael J . Wysocki" <rafael@kernel.org>,
        nathanl@linux.ibm.com, cheloha@linux.ibm.com,
        Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>, linux-ia64@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Michal Hocko <mhocko@suse.com>
References: <20200911134831.53258-1-ldufour@linux.ibm.com>
 <20200911134831.53258-3-ldufour@linux.ibm.com>
 <f50fe4ae-faf0-6e03-b87e-45ca8c53960d@redhat.com>
 <20200914081921.GA15113@linux>
 <96736256-a0a6-3126-3810-3380532b9621@redhat.com>
From:   Laurent Dufour <ldufour@linux.ibm.com>
Message-ID: <9990141a-a4e7-6166-c7aa-e0c1199afa38@linux.ibm.com>
Date:   Mon, 14 Sep 2020 11:16:41 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <96736256-a0a6-3126-3810-3380532b9621@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-13_09:2020-09-10,2020-09-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 bulkscore=0 malwarescore=0 suspectscore=0 adultscore=0 spamscore=0
 phishscore=0 mlxscore=0 priorityscore=1501 impostorscore=0 clxscore=1015
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009140072
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Le 14/09/2020 à 10:31, David Hildenbrand a écrit :
>>> static int register_mem_sect_under_node_hotplug(struct memory_block *mem_blk,
>>> 						void *arg)
>>> {
>>> 	const int nid = *(int *)arg;
>>> 	int ret;
>>>
>>> 	/* Hotplugged memory has no holes and belongs to a single node. */
>>> 	mem_blk->nid = nid;
>>> 	ret = sysfs_create_link_nowarn(&node_devices[nid]->dev.kobj,
>>> 				       &mem_blk->dev.kobj,
>>> 				       kobject_name(&mem_blk->dev.kobj));
>>> 	if (ret)
>>> 		returnr et;
>>> 	return sysfs_create_link_nowarn(&mem_blk->dev.kobj,
>>> 					&node_devices[nid]->dev.kobj,
>>> 					kobject_name(&node_devices[nid]->dev.kobj));
>>>
>>> }
>>>
>>> Cleaner, right? :) No unnecessary checks.
>>
>> I tend to agree here, I like more a simplistic version for hotplug.
>>
> 
> ... and while we're at it, we should rename register_mem_sect_under_node
> to something like "register_memory_block_under_node" - "section" is a
> legacy leftover here.
> 
> We could factor out both sysfs_create_link_nowarn() calls into something
> like "do_register_memory_block_under_node" or similar, to minimize code
> duplication.
> 
>>> One could argue if link_mem_section_hotplug() would be better than passing around the context.
>>
>> I am not sure if I would duplicate the code there.
>> We could just pass the pointer of the function we want to call to
>> link_mem_sections? either register_mem_sect_under_node_hotplug or
>> register_mem_sect_under_node_early?
>> Would not that be clean and clear enough?
> 
> I don't particularly like passing around function pointers where it can
> be avoided (e.g., here exporting 3 functions now instead 1). Makes the
> interface harder to get IMHO. But I don't really care about that
> interface, easy to change later on.
>

This would lead to the following.

Do everyone agree?

diff --git a/drivers/base/node.c b/drivers/base/node.c
index 508b80f6329b..444808a7c9b6 100644
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -761,9 +761,32 @@ static int __ref get_nid_for_pfn(unsigned long pfn)
  	return pfn_to_nid(pfn);
  }

+static int do_register_memory_block_under_node(int nid,
+					       struct memory_block *mem_blk)
+{
+	int ret;
+
+	/*
+	 * If this memory block spans multiple nodes, we only indicate
+	 * the last processed node.
+	 */
+	mem_blk->nid = nid;
+
+	ret = sysfs_create_link_nowarn(&node_devices[nid]->dev.kobj,
+				       &mem_blk->dev.kobj,
+				       kobject_name(&mem_blk->dev.kobj));
+	if (ret)
+		return ret;
+
+	return sysfs_create_link_nowarn(&mem_blk->dev.kobj,
+				&node_devices[nid]->dev.kobj,
+				kobject_name(&node_devices[nid]->dev.kobj));
+
+}
+
  /* register memory section under specified node if it spans that node */
-static int register_mem_sect_under_node(struct memory_block *mem_blk,
-					 void *arg)
+static int register_mem_block_under_node_early(struct memory_block *mem_blk,
+					       void *arg)
  {
  	unsigned long memory_block_pfns = memory_block_size_bytes() / PAGE_SIZE;
  	unsigned long start_pfn = section_nr_to_pfn(mem_blk->start_section_nr);
@@ -785,38 +808,35 @@ static int register_mem_sect_under_node(struct 
memory_block *mem_blk,
  		}

  		/*
-		 * We need to check if page belongs to nid only for the boot
-		 * case, during hotplug we know that all pages in the memory
-		 * block belong to the same node.
+		 * We need to check if page belongs to nid only at the boot
+		 * case because node's ranges can be interleaved.
  		 */
-		if (system_state == SYSTEM_BOOTING) {
-			page_nid = get_nid_for_pfn(pfn);
-			if (page_nid < 0)
-				continue;
-			if (page_nid != nid)
-				continue;
-		}
-
-		/*
-		 * If this memory block spans multiple nodes, we only indicate
-		 * the last processed node.
-		 */
-		mem_blk->nid = nid;
+		page_nid = get_nid_for_pfn(pfn);
+		if (page_nid < 0)
+			continue;
+		if (page_nid != nid)
+			continue;

-		ret = sysfs_create_link_nowarn(&node_devices[nid]->dev.kobj,
-					&mem_blk->dev.kobj,
-					kobject_name(&mem_blk->dev.kobj));
+		ret = do_register_memory_block_under_node(nid, mem_blk);
  		if (ret)
  			return ret;
-
-		return sysfs_create_link_nowarn(&mem_blk->dev.kobj,
-				&node_devices[nid]->dev.kobj,
-				kobject_name(&node_devices[nid]->dev.kobj));
  	}
  	/* mem section does not span the specified node */
  	return 0;
  }

+/*
+ * During hotplug we know that all pages in the memory block belong to the same
+ * node.
+ */
+static int register_mem_block_under_node_hotplug(struct memory_block *mem_blk,
+						 void *arg)
+{
+	int nid = *(int *)arg;
+
+	return do_register_memory_block_under_node(nid, mem_blk);
+}
+
  /*
   * Unregister a memory block device under the node it spans. Memory blocks
   * with multiple nodes cannot be offlined and therefore also never be removed.
@@ -832,11 +852,19 @@ void unregister_memory_block_under_nodes(struct 
memory_block *mem_blk)
  			  kobject_name(&node_devices[mem_blk->nid]->dev.kobj));
  }

-int link_mem_sections(int nid, unsigned long start_pfn, unsigned long end_pfn)
+int link_mem_sections(int nid, unsigned long start_pfn, unsigned long end_pfn,
+		      enum memplug_context context)
  {
+	walk_memory_blocks_func_t func;
+
+	if (context == MEMPLUG_HOTPLUG)
+		func = register_mem_block_under_node_hotplug;
+	else
+		func = register_mem_block_under_node_early;
+
  	return walk_memory_blocks(PFN_PHYS(start_pfn),
  				  PFN_PHYS(end_pfn - start_pfn), (void *)&nid,
-				  register_mem_sect_under_node);
+				  func);
  }

  #ifdef CONFIG_HUGETLBFS

