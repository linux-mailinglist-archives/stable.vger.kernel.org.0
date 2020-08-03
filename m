Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D65823A714
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 14:59:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726729AbgHCM7U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 08:59:20 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2557 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726478AbgHCM7T (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Aug 2020 08:59:19 -0400
Received: from lhreml724-chm.china.huawei.com (unknown [172.18.7.108])
        by Forcepoint Email with ESMTP id A8DF816A36FAD6C13464;
        Mon,  3 Aug 2020 13:59:18 +0100 (IST)
Received: from [127.0.0.1] (10.210.168.55) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1913.5; Mon, 3 Aug 2020
 13:59:17 +0100
Subject: Re: [PATCH 4.14 01/51] scsi: libsas: direct call probe and destruct
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        yanaijie <yanaijie@huawei.com>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        Ewan Milne <emilne@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Tomas Henzl <thenzl@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Hannes Reinecke <hare@suse.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
References: <20200803121849.488233135@linuxfoundation.org>
 <20200803121849.564535738@linuxfoundation.org>
From:   John Garry <john.garry@huawei.com>
Message-ID: <8743227b-adb3-ed1f-3559-e562555ac045@huawei.com>
Date:   Mon, 3 Aug 2020 13:57:14 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <20200803121849.564535738@linuxfoundation.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.210.168.55]
X-ClientProxiedBy: lhreml726-chm.china.huawei.com (10.201.108.77) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 03/08/2020 13:19, Greg Kroah-Hartman wrote:
> From: Jason Yan <yanaijie@huawei.com>
> 
> [ Upstream commit 0558f33c06bb910e2879e355192227a8e8f0219d ]
> 

Hi Greg,

This patch was one of a series from Jason to fix this WARN issue, below:

https://lore.kernel.org/linux-scsi/8f6e3763-2b04-23e8-f1ec-8ed3c58f55d3@huawei.com/

I'm doubtful that it should be taken in isolation. Maybe 1 or 2 other 
patches are required.

The WARN was really annoying, so we could spend a bit of time to test a 
backport of what is strictly required. Let us know.

Thanks,
John

> In commit 87c8331fcf72 ("[SCSI] libsas: prevent domain rediscovery
> competing with ata error handling") introduced disco mutex to prevent
> rediscovery competing with ata error handling and put the whole
> revalidation in the mutex. But the rphy add/remove needs to wait for the
> error handling which also grabs the disco mutex. This may leads to dead
> lock.So the probe and destruct event were introduce to do the rphy
> add/remove asynchronously and out of the lock.
> 
> The asynchronously processed workers makes the whole discovery process
> not atomic, the other events may interrupt the process. For example,
> if a loss of signal event inserted before the probe event, the
> sas_deform_port() is called and the port will be deleted.
> 
> And sas_port_delete() may run before the destruct event, but the
> port-x:x is the top parent of end device or expander. This leads to
> a kernel WARNING such as:
> 
> [   82.042979] sysfs group 'power' not found for kobject 'phy-1:0:22'
> [   82.042983] ------------[ cut here ]------------
> [   82.042986] WARNING: CPU: 54 PID: 1714 at fs/sysfs/group.c:237
> sysfs_remove_group+0x94/0xa0
> [   82.043059] Call trace:
> [   82.043082] [<ffff0000082e7624>] sysfs_remove_group+0x94/0xa0
> [   82.043085] [<ffff00000864e320>] dpm_sysfs_remove+0x60/0x70
> [   82.043086] [<ffff00000863ee10>] device_del+0x138/0x308
> [   82.043089] [<ffff00000869a2d0>] sas_phy_delete+0x38/0x60
> [   82.043091] [<ffff00000869a86c>] do_sas_phy_delete+0x6c/0x80
> [   82.043093] [<ffff00000863dc20>] device_for_each_child+0x58/0xa0
> [   82.043095] [<ffff000008696f80>] sas_remove_children+0x40/0x50
> [   82.043100] [<ffff00000869d1bc>] sas_destruct_devices+0x64/0xa0
> [   82.043102] [<ffff0000080e93bc>] process_one_work+0x1fc/0x4b0
> [   82.043104] [<ffff0000080e96c0>] worker_thread+0x50/0x490
> [   82.043105] [<ffff0000080f0364>] kthread+0xfc/0x128
> [   82.043107] [<ffff0000080836c0>] ret_from_fork+0x10/0x50
> 
> Make probe and destruct a direct call in the disco and revalidate function,
> but put them outside the lock. The whole discovery or revalidate won't
> be interrupted by other events. And the DISCE_PROBE and DISCE_DESTRUCT
> event are deleted as a result of the direct call.
> 
> Introduce a new list to destruct the sas_port and put the port delete after
> the destruct. This makes sure the right order of destroying the sysfs
> kobject and fix the warning above.
> 
> In sas_ex_revalidate_domain() have a loop to find all broadcasted
> device, and sometimes we have a chance to find the same expander twice.
> Because the sas_port will be deleted at the end of the whole revalidate
> process, sas_port with the same name cannot be added before this.
> Otherwise the sysfs will complain of creating duplicate filename. Since
> the LLDD will send broadcast for every device change, we can only
> process one expander's revalidation.
> 
> [mkp: kbuild test robot warning]
> 
> Signed-off-by: Jason Yan <yanaijie@huawei.com>
> CC: John Garry <john.garry@huawei.com>
> CC: Johannes Thumshirn <jthumshirn@suse.de>
> CC: Ewan Milne <emilne@redhat.com>
> CC: Christoph Hellwig <hch@lst.de>
> CC: Tomas Henzl <thenzl@redhat.com>
> CC: Dan Williams <dan.j.williams@intel.com>
> Reviewed-by: Hannes Reinecke <hare@suse.com>
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---

