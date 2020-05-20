Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 005C71DB595
	for <lists+stable@lfdr.de>; Wed, 20 May 2020 15:49:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726452AbgETNtw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 May 2020 09:49:52 -0400
Received: from mga02.intel.com ([134.134.136.20]:45663 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726436AbgETNtv (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 20 May 2020 09:49:51 -0400
IronPort-SDR: WY4ccGOdhT8uRmvLYsQT+jwUvGImKzdwVyX7xcK4XFhTHlTdrpT0Wk0UWOf/5FMo5i5uc8znN9
 UvhRp10S0wwA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2020 06:49:51 -0700
IronPort-SDR: 5ygiNmK+1sKINB96rOtGQsGhDIVe9xyZC8hfKfmrHhoOHrjNv9uOXOaHjFa0fuyWU8E5BK5eD6
 YVq0eCUKd7Sg==
X-IronPort-AV: E=Sophos;i="5.73,414,1583222400"; 
   d="scan'208";a="440034217"
Received: from ddalessa-mobl.amr.corp.intel.com (HELO [10.254.201.222]) ([10.254.201.222])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2020 06:49:50 -0700
Subject: Re: [PATCH for-rc or next 3/3] IB/qib: Call kobject_put() when
 kobject_init_and_add() fails
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     dledford@redhat.com, linux-rdma@vger.kernel.org,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        stable@vger.kernel.org, Kaike Wan <kaike.wan@intel.com>
References: <20200512030622.189865.65024.stgit@awfm-01.aw.intel.com>
 <20200512031328.189865.48627.stgit@awfm-01.aw.intel.com>
 <20200520000055.GA6205@ziepe.ca>
From:   Dennis Dalessandro <dennis.dalessandro@intel.com>
Message-ID: <1ce35d57-8b21-0379-17a1-61b9d6dc1f02@intel.com>
Date:   Wed, 20 May 2020 09:49:48 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200520000055.GA6205@ziepe.ca>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/19/2020 8:00 PM, Jason Gunthorpe wrote:
> On Mon, May 11, 2020 at 11:13:28PM -0400, Dennis Dalessandro wrote:
>> From: Kaike Wan <kaike.wan@intel.com>
>>
>> When kobject_init_and_add() returns an error in the function
>> qib_create_port_files(), the function kobject_put() is not called for
>> the corresponding kobject, which potentially leads to memory leak.
>>
>> This patch fixes the issue by calling kobject_put() even if
>> kobject_init_and_add() fails. In addition, the ppd->diagc_kobj is
>> released along with other kobjects when the sysfs is unregistered.
>>
>> Fixes: f931551bafe1 ("IB/qib: Add new qib driver for QLogic PCIe InfiniBand adapters")
>> Cc: <stable@vger.kernel.org>
>> Suggested-by: Lin Yi <teroincn@gmail.com>
>> Reviewed-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
>> Signed-off-by: Kaike Wan <kaike.wan@intel.com>
>> Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
>> Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
>> ---
>>   drivers/infiniband/hw/qib/qib_sysfs.c |    9 +++++----
>>   1 file changed, 5 insertions(+), 4 deletions(-)
> 
> Applied to for-rc
> 
> Are you respinning the other two patches?

Yes, Kaike is working on getting updates to those two out.

-Denny

