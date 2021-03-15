Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAF8B33A9FF
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 04:31:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229672AbhCODbE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Mar 2021 23:31:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:37244 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229607AbhCODao (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Mar 2021 23:30:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615779044;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jJtBr9vTOWvQZ16JQjPGETDhPNwBqit02DMZwKL2LGQ=;
        b=eSEiaLKpH1uUxhN9gGadpGcj9C/smQI8EL7a3YJvZqRbdW7SwmHU6mWsO8ETSqdxc6plEw
        5ICXr2BvnX4GERglWoeT6vyJbcPNcvNb2H+0G422IBn5VpyasSGattJl5gxUqLBZsnT9au
        AJNkZ96VUPK5Nl4NRpywNf1qlDu9c1Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-416-IFiYBgq1MwioN3eVuFw8kA-1; Sun, 14 Mar 2021 23:30:42 -0400
X-MC-Unique: IFiYBgq1MwioN3eVuFw8kA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B79CE1084D68;
        Mon, 15 Mar 2021 03:30:40 +0000 (UTC)
Received: from localhost.localdomain (ovpn-13-12.pek2.redhat.com [10.72.13.12])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9EEEB5D9CD;
        Mon, 15 Mar 2021 03:30:38 +0000 (UTC)
Subject: Re: [PATCH] RDMA/srp: Fix support for unpopulated and unbalanced NUMA
 nodes
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Nicolas Morey-Chaisemartin <nmoreychaisemartin@suse.com>
Cc:     "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        bart.vanassche@wdc.com, stable@vger.kernel.org
References: <9cb4d9d3-30ad-2276-7eff-e85f7ddfb411@suse.com>
 <20210217133740.GA2296847@nvidia.com>
From:   Yi Zhang <yi.zhang@redhat.com>
Message-ID: <45c0875e-be7f-d59b-04cf-6e9cb0cb6747@redhat.com>
Date:   Mon, 15 Mar 2021 11:30:34 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20210217133740.GA2296847@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello

I reproduced the issue on 5.11.7-rc1, could we port this patch to stable 
branch.

Thanks
Yi


On 2/17/21 9:37 PM, Jason Gunthorpe wrote:
> On Fri, Feb 05, 2021 at 09:14:28AM +0100, Nicolas Morey-Chaisemartin wrote:
>> The current code computes a number of channels per SRP target and spreads
>> them equally across all online NUMA nodes.
>> Each channel is then assigned a CPU within this node.
>>
>> In the case of unbalanced, or even unpopulated nodes, some channels
>> do not get a CPU associated and thus do not get connected.
>> This causes the SRP connection to fail.
>>
>> This patch solves the issue by rewriting channel computation and allocation:
>> - Drop channel to node/CPU association as it had
>>    no real effect on locality but added unnecessary complexity.
>> - Tweak the number of channels allocated to reduce CPU contention when possible:
>>    - Up to one channel per CPU (instead of up to 4 by node)
>>    - At least 4 channels per node, unless ch_count module parameter is used.
>>
>> Signed-off-by: Nicolas Morey-Chaisemartin <nmoreychaisemartin@suse.com>
>> Reviewed-by: Bart Van Assche <bvanassche@acm.org>
>> ---
>>   drivers/infiniband/ulp/srp/ib_srp.c | 110 ++++++++++++----------------
>>   1 file changed, 45 insertions(+), 65 deletions(-)
> Applied to for-next, thanks
>
> Jason
>

