Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47D8126461F
	for <lists+stable@lfdr.de>; Thu, 10 Sep 2020 14:35:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730544AbgIJMfT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Sep 2020 08:35:19 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:18212 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730629AbgIJMdE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Sep 2020 08:33:04 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08ACREPD090926;
        Thu, 10 Sep 2020 08:32:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=UdKC4iFr09EHp/EEFoTiuPzvrqhtYISXi8fJ0IdZ1U4=;
 b=Fsi8tMgrKCaZM/lqBoa2qSpERUH5S91V3ByKmF+YAD67ZEANtVL1NA9J0ohIQIR2Y5M8
 6PxDDW0pKLCscdEeChDIJZrLNKfLc1ykfCXEOFiOCnff0vsBVKlEsIANMwbhcnbnon1w
 JHmOHYM4oldJiWuf4myBfgLex3q2DfCd0VKuCN+LwruH/Ua0YQSM4Jyf15RSUrASIadW
 ABgzScRuZope//9SZkjS+8mrOPlDI1BXQp4GYQaSwnedR/KKx2/1NsYaSqMTha/3qGcF
 MjjHsfdnSgX0FKmP+kUj9RNMTaSPTM7BLk4yp5zvfoKYi30Tkwy16NACOdG+viy47lXK WA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33fkta0vhs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Sep 2020 08:32:17 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 08ACRdDG092327;
        Thu, 10 Sep 2020 08:32:11 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33fkta0vfk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Sep 2020 08:32:10 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08ACVBX7011978;
        Thu, 10 Sep 2020 12:32:07 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma02fra.de.ibm.com with ESMTP id 33c2a83fse-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Sep 2020 12:32:06 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08ACUU5K63570418
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Sep 2020 12:30:31 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E3FEDA405B;
        Thu, 10 Sep 2020 12:32:03 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2F2B4A4053;
        Thu, 10 Sep 2020 12:32:03 +0000 (GMT)
Received: from pomme.local (unknown [9.145.147.189])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 10 Sep 2020 12:32:03 +0000 (GMT)
Subject: Re: [PATCH] mm: don't rely on system state to detect hot-plug
 operations
To:     Oscar Salvador <osalvador@suse.de>
Cc:     Michal Hocko <mhocko@suse.com>, akpm@linux-foundation.org,
        David Hildenbrand <david@redhat.com>, rafael@kernel.org,
        nathanl@linux.ibm.com, cheloha@linux.ibm.com,
        stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>
References: <20200909074011.GD7348@dhcp22.suse.cz>
 <9faac1ce-c02d-7dbc-f79a-4aaaa5a73d28@linux.ibm.com>
 <20200909090953.GE7348@dhcp22.suse.cz>
 <4cdb54be-1a92-4ba4-6fee-3b415f3468a9@linux.ibm.com>
 <20200909105914.GF7348@dhcp22.suse.cz>
 <74a62b00-235e-7deb-2814-f3b240fea25e@linux.ibm.com>
 <20200910072331.GB28354@dhcp22.suse.cz>
 <31cfdf35-618f-6f56-ef16-0d999682ad02@linux.ibm.com>
 <20200910111246.GE28354@dhcp22.suse.cz>
 <bd6f2d09-f4e2-0a63-3511-e0f9bf283fe3@linux.ibm.com>
 <20200910120343.GA6635@linux>
From:   Laurent Dufour <ldufour@linux.ibm.com>
Message-ID: <5104d47f-9b39-6f51-2cee-f2a153fab1df@linux.ibm.com>
Date:   Thu, 10 Sep 2020 14:32:02 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200910120343.GA6635@linux>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-10_03:2020-09-10,2020-09-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 clxscore=1015
 priorityscore=1501 malwarescore=0 impostorscore=0 lowpriorityscore=0
 bulkscore=0 suspectscore=0 phishscore=0 spamscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009100112
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Le 10/09/2020 à 14:03, Oscar Salvador a écrit :
> On Thu, Sep 10, 2020 at 01:35:32PM +0200, Laurent Dufour wrote:
>   
>> That points has been raised by David, quoting him here:
>>
>>> IIRC, ACPI can hotadd memory while SCHEDULING, this patch would break that.
>>>
>>> Ccing Oscar, I think he mentioned recently that this is the case with ACPI.
>>
>> Oscar told that he need to investigate further on that.
> 
> I think my reply got lost.
> 
> We can see acpi hotplugs during SYSTEM_SCHEDULING:
> 
> $QEMU -enable-kvm -machine pc -smp 4,sockets=4,cores=1,threads=1 -cpu host -monitor pty \
>          -m size=$MEM,slots=255,maxmem=4294967296k  \
>          -numa node,nodeid=0,cpus=0-3,mem=512 -numa node,nodeid=1,mem=512 \
>          -object memory-backend-ram,id=memdimm0,size=134217728 -device pc-dimm,node=0,memdev=memdimm0,id=dimm0,slot=0 \
>          -object memory-backend-ram,id=memdimm1,size=134217728 -device pc-dimm,node=0,memdev=memdimm1,id=dimm1,slot=1 \
>          -object memory-backend-ram,id=memdimm2,size=134217728 -device pc-dimm,node=0,memdev=memdimm2,id=dimm2,slot=2 \
>          -object memory-backend-ram,id=memdimm3,size=134217728 -device pc-dimm,node=0,memdev=memdimm3,id=dimm3,slot=3 \
>          -object memory-backend-ram,id=memdimm4,size=134217728 -device pc-dimm,node=1,memdev=memdimm4,id=dimm4,slot=4 \
>          -object memory-backend-ram,id=memdimm5,size=134217728 -device pc-dimm,node=1,memdev=memdimm5,id=dimm5,slot=5 \
>          -object memory-backend-ram,id=memdimm6,size=134217728 -device pc-dimm,node=1,memdev=memdimm6,id=dimm6,slot=6 \
> 
> kernel: [    0.753643] __add_memory: nid: 0 start: 0100000000 - 0108000000 (size: 134217728)
> kernel: [    0.756950] register_mem_sect_under_node: system_state= 1
> 
> kernel: [    0.760811]  register_mem_sect_under_node+0x4f/0x230
> kernel: [    0.760811]  walk_memory_blocks+0x80/0xc0
> kernel: [    0.760811]  link_mem_sections+0x32/0x40
> kernel: [    0.760811]  add_memory_resource+0x148/0x250
> kernel: [    0.760811]  __add_memory+0x5b/0x90
> kernel: [    0.760811]  acpi_memory_device_add+0x130/0x300
> kernel: [    0.760811]  acpi_bus_attach+0x13c/0x1c0
> kernel: [    0.760811]  acpi_bus_attach+0x60/0x1c0
> kernel: [    0.760811]  acpi_bus_scan+0x33/0x70
> kernel: [    0.760811]  acpi_scan_init+0xea/0x21b
> kernel: [    0.760811]  acpi_init+0x2f1/0x33c
> kernel: [    0.760811]  do_one_initcall+0x46/0x1f4

Thanks Oscar!
