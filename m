Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FD164ADB3
	for <lists+stable@lfdr.de>; Wed, 19 Jun 2019 00:11:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730333AbfFRWLN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jun 2019 18:11:13 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:47254 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729982AbfFRWLM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jun 2019 18:11:12 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5IM9Wp6080715;
        Tue, 18 Jun 2019 22:10:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=Zc2OUm1tnM3N2m7NXIMcwM3Hdgj3tqDikz5h/JZLlPw=;
 b=pChkqb2/rjNMRDRJzKlMsm16PdLxVJCZ10fEz2t3p+DvZsTUNdQq+YZgzkFrJ3IqK9Hc
 DM8cDMG7F0TCra0DDX+J3I5TU5qskXQD/1nbeA43TDZq7sVefljpljvMfxfi3IaaXI3U
 iKiuEa+Mw3wPAE+sWYFsLAHnQatG2AbO9KcUdGJcWkk9IUKfqNwHhaOpj7nAjMcRpqHp
 SdnJrlUV8wtS0g1X5ysVMy7UWs6Y4MopeiLMIyeeEUJkpTu3/IW+wJoPtiayxTxGtABm
 wwe4axjpwLYzzebmfYEUwi1+YsHBQuGfpUgybKABBZN5OAXqsODj7VizdE9Gf2LZoQwK 2g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2t7809839u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jun 2019 22:10:37 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5IM983t057436;
        Tue, 18 Jun 2019 22:10:37 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2t77ymrcde-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jun 2019 22:10:37 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x5IMAZqp004922;
        Tue, 18 Jun 2019 22:10:35 GMT
Received: from [10.159.158.20] (/10.159.158.20)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 18 Jun 2019 15:10:35 -0700
Subject: Re: [PATCH 0/6] libnvdimm: Fix async operations and locking
To:     Dan Williams <dan.j.williams@intel.com>, linux-nvdimm@lists.01.org
Cc:     Ira Weiny <ira.weiny@intel.com>, Dave Jiang <dave.jiang@intel.com>,
        Keith Busch <keith.busch@intel.com>, stable@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Will Deacon <will.deacon@arm.com>,
        Ingo Molnar <mingo@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Erwin Tsaur <erwin.tsaur@oracle.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Vishal Verma <vishal.l.verma@intel.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        linux-kernel@vger.kernel.org
References: <156029554317.419799.1324389595953183385.stgit@dwillia2-desk3.amr.corp.intel.com>
From:   Jane Chu <jane.chu@oracle.com>
Organization: Oracle Corporation
Message-ID: <53fa618d-376f-2200-c8ba-e22ba004cdc0@oracle.com>
Date:   Tue, 18 Jun 2019 15:10:33 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <156029554317.419799.1324389595953183385.stgit@dwillia2-desk3.amr.corp.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9292 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906180177
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9292 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906180177
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/11/2019 4:25 PM, Dan Williams wrote:
> The libnvdimm subsystem uses async operations to parallelize device
> probing operations and to allow sysfs to trigger device_unregister() on
> deleted namepsaces. A multithreaded stress test of the libnvdimm sysfs
> interface uncovered a case where device_unregister() is triggered
> multiple times, and the subsequent investigation uncovered a broken
> locking scenario.
> 
> The lack of lockdep coverage for device_lock() stymied the debug. That
> is, until patch6 "driver-core, libnvdimm: Let device subsystems add
> local lockdep coverage" solved that with a shadow lock, with lockdep
> coverage, to mirror device_lock() operations. Given the time saved with
> shadow-lock debug-hack, patch6 attempts to generalize device_lock()
> debug facility that might be able to be carried upstream. Patch6 is
> staged at the end of this fix series in case it is contentious and needs
> to be dropped.
> 
> Patch1 "drivers/base: Introduce kill_device()" could be achieved with
> local libnvdimm infrastructure. However, the existing 'dead' flag in
> 'struct device_private' aims to solve similar async register/unregister
> races so the fix in patch2 "libnvdimm/bus: Prevent duplicate
> device_unregister() calls" can be implemented with existing driver-core
> infrastructure.
> 
> Patch3 is a rare lockdep warning that is intermittent based on
> namespaces racing ahead of the completion of probe of their parent
> region. It is not related to the other fixes, it just happened to
> trigger as a result of the async stress test.
> 
> Patch4 and patch5 address an ABBA deadlock tripped by the stress test.
> 
> These patches pass the failing stress test and the existing libnvdimm
> unit tests with CONFIG_PROVE_LOCKING=y and the new "dev->lockdep_mutex"
> shadow lock with no lockdep warnings.
> 
> ---
> 
> Dan Williams (6):
>        drivers/base: Introduce kill_device()
>        libnvdimm/bus: Prevent duplicate device_unregister() calls
>        libnvdimm/region: Register badblocks before namespaces
>        libnvdimm/bus: Stop holding nvdimm_bus_list_mutex over __nd_ioctl()
>        libnvdimm/bus: Fix wait_nvdimm_bus_probe_idle() ABBA deadlock
>        driver-core, libnvdimm: Let device subsystems add local lockdep coverage
> 
> 
>   drivers/acpi/nfit/core.c        |   28 ++++---
>   drivers/acpi/nfit/nfit.h        |   24 ++++++
>   drivers/base/core.c             |   30 ++++++--
>   drivers/nvdimm/btt_devs.c       |   16 ++--
>   drivers/nvdimm/bus.c            |  154 +++++++++++++++++++++++++++------------
>   drivers/nvdimm/core.c           |   10 +--
>   drivers/nvdimm/dimm_devs.c      |    4 +
>   drivers/nvdimm/namespace_devs.c |   36 +++++----
>   drivers/nvdimm/nd-core.h        |   71 ++++++++++++++++++
>   drivers/nvdimm/pfn_devs.c       |   24 +++---
>   drivers/nvdimm/pmem.c           |    4 +
>   drivers/nvdimm/region.c         |   24 +++---
>   drivers/nvdimm/region_devs.c    |   12 ++-
>   include/linux/device.h          |    6 ++
>   14 files changed, 308 insertions(+), 135 deletions(-)
> 

Tested-by: Jane Chu <jane.chu@oracle.com>

Specifically, running parallel ndctls creating/destroying namespaces in 
multiple processes concurrently led to system panic, that has been 
verified fixed by this patch series.

Thanks!
-jane
