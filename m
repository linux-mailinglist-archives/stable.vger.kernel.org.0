Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BE58268752
	for <lists+stable@lfdr.de>; Mon, 14 Sep 2020 10:40:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726194AbgINIkK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Sep 2020 04:40:10 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:2210 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726070AbgINIkJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Sep 2020 04:40:09 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08E8X2YA029266;
        Mon, 14 Sep 2020 04:39:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=6hyBdWh5wrxsmd/YHbb6vywMegeCd8cNzzgph3fgj4Y=;
 b=lL/OErseBj++/I0oLL2VoqKAdguiPn23sb7mJa321Ztj0deHU7kZrmI4egz9GQ8hl3yU
 u++p0/i84FqtK1ddbFqk1K3p/HzOPIZ14Zz2j7vzcKz8SSPHdJCsSGSls5YghhhAy9xd
 naDo7CjHaUZM45h3PpcH8RmAgInxuHFeovVGzc60rzXTUfQnKElr2TAqkFOidaullVmP
 BR61klf7sqOotiQggpDgDDFDaQrkObnoxDEbXugda1oztcy/R/fuKNnFykX636tuxN55
 SeeFT+q0cCfmY+sxMZOcRhUF96GWg5ZDKgg7OrZeXyHYE4s0h4Mqo5ihDM+MOzTKSCf+ 6Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33j4mvs2b9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Sep 2020 04:39:56 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 08E8XklS032661;
        Mon, 14 Sep 2020 04:39:56 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33j4mvs29s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Sep 2020 04:39:56 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08E8bFTF029992;
        Mon, 14 Sep 2020 08:39:53 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma02fra.de.ibm.com with ESMTP id 33gny811ve-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Sep 2020 08:39:53 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08E8dobx22872534
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Sep 2020 08:39:50 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 77C4211C04A;
        Mon, 14 Sep 2020 08:39:50 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A5F0711C04C;
        Mon, 14 Sep 2020 08:39:49 +0000 (GMT)
Received: from pomme.local (unknown [9.145.51.157])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 14 Sep 2020 08:39:49 +0000 (GMT)
Subject: Re: [PATCH 2/3] mm: don't rely on system state to detect hot-plug
 operations
To:     Oscar Salvador <osalvador@suse.de>,
        David Hildenbrand <david@redhat.com>
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
From:   Laurent Dufour <ldufour@linux.ibm.com>
Message-ID: <678b596a-4d40-be88-daf0-c2edb16dd295@linux.ibm.com>
Date:   Mon, 14 Sep 2020 10:39:49 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200914081921.GA15113@linux>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-13_09:2020-09-10,2020-09-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 mlxlogscore=999 lowpriorityscore=0 malwarescore=0 suspectscore=0
 spamscore=0 priorityscore=1501 bulkscore=0 phishscore=0 adultscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009140067
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Le 14/09/2020 à 10:19, Oscar Salvador a écrit :
> On Mon, Sep 14, 2020 at 09:57:46AM +0200, David Hildenbrand wrote:
>>>   /* register memory section under specified node if it spans that node */
>>> +struct rmsun_args {
>>> +	int nid;
>>> +	enum memplug_context context;
>>> +};
> 
> Uhmf, that is a not so descriptive name.

I do agree, but didn't have a better idea.
Anyway this will disappear since the choosen direction is to have 2 callbacks.

> 
>> Instead of handling this in register_mem_sect_under_node(), I
>> think it would be better two have two separate
>> register_mem_sect_under_node() implementations.
>>
>> static int register_mem_sect_under_node_hotplug(struct memory_block *mem_blk,
>> 						void *arg)
>> {
>> 	const int nid = *(int *)arg;
>> 	int ret;
>>
>> 	/* Hotplugged memory has no holes and belongs to a single node. */
>> 	mem_blk->nid = nid;
>> 	ret = sysfs_create_link_nowarn(&node_devices[nid]->dev.kobj,
>> 				       &mem_blk->dev.kobj,
>> 				       kobject_name(&mem_blk->dev.kobj));
>> 	if (ret)
>> 		returnr et;
>> 	return sysfs_create_link_nowarn(&mem_blk->dev.kobj,
>> 					&node_devices[nid]->dev.kobj,
>> 					kobject_name(&node_devices[nid]->dev.kobj));
>>
>> }
>>
>> Cleaner, right? :) No unnecessary checks.
> 
> I tend to agree here, I like more a simplistic version for hotplug.
> 
>> One could argue if link_mem_section_hotplug() would be better than passing around the context.
> 
> I am not sure if I would duplicate the code there.
> We could just pass the pointer of the function we want to call to
> link_mem_sections? either register_mem_sect_under_node_hotplug or
> register_mem_sect_under_node_early?
> Would not that be clean and clear enough?

That would expose the register_mem_sect_under_node*() prototype to the caller.

I'm wondering if that would be cleaner than passing a MEMPLUG_* constant value 
to link_mem_sections() and let it choose the right callback.
