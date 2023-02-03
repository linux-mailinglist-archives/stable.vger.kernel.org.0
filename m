Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57588689BEB
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 15:35:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232477AbjBCOew (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 09:34:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233181AbjBCOel (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 09:34:41 -0500
Received: from smtp-fw-2101.amazon.com (smtp-fw-2101.amazon.com [72.21.196.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 505B97D8C
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 06:34:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1675434880; x=1706970880;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ukCnZE6i6tDdzjX7N5BgQ8zEl/IfnfCxxzEso6uwR5k=;
  b=iPp7Q28pitujbh4nJRkp8lKZKdnOHkHdcbqGzuzSAHQrgt25u0onjz5e
   w1MeE7mtHnFGdYzQUkk+uHRBj8h+Die89UlPZLppeURLuZnFqWqVgiPme
   NAzYJocqIk/2JGKLugoiggcMolD21YBhIFxKpW/7EZ7pByJ6xuyIg9sF9
   8=;
X-IronPort-AV: E=Sophos;i="5.97,270,1669075200"; 
   d="scan'208";a="289336798"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1d-m6i4x-153b24bc.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2023 14:33:36 +0000
Received: from EX13MTAUEE001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1d-m6i4x-153b24bc.us-east-1.amazon.com (Postfix) with ESMTPS id 2A57CC1C5E;
        Fri,  3 Feb 2023 14:33:32 +0000 (UTC)
Received: from EX19D028UEC003.ant.amazon.com (10.252.137.159) by
 EX13MTAUEE001.ant.amazon.com (10.43.62.200) with Microsoft SMTP Server (TLS)
 id 15.0.1497.45; Fri, 3 Feb 2023 14:33:27 +0000
Received: from [10.94.132.78] (10.43.160.120) by EX19D028UEC003.ant.amazon.com
 (10.252.137.159) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1118.24; Fri, 3 Feb
 2023 14:33:25 +0000
Message-ID: <75a78cdf-7281-72f8-6504-c1dfc2986a8d@amazon.com>
Date:   Fri, 3 Feb 2023 09:33:22 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.0
Subject: Re: [PATH stable 5.4] mm: swap: properly update readahead statistics
 in unuse_pte_range()
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     <stable@vger.kernel.org>,
        Andrea Righi <andrea.righi@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Huang, Ying" <ying.huang@intel.com>,
        Minchan Kim <minchan@kernel.org>,
        Anchal Agarwal <anchalag@amazon.com>,
        Hugh Dickins <hughd@google.com>,
        "Vineeth Remanan Pillai" <vpillai@digitalocean.com>,
        Kelley Nielsen <kelleynnn@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
References: <20230130152823.65880-1-luizcap@amazon.com>
 <Y9zRmZ2KdSMRrO4g@kroah.com>
Content-Language: en-US
From:   Luiz Capitulino <luizcap@amazon.com>
In-Reply-To: <Y9zRmZ2KdSMRrO4g@kroah.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.43.160.120]
X-ClientProxiedBy: EX13D44UWB003.ant.amazon.com (10.43.161.52) To
 EX19D028UEC003.ant.amazon.com (10.252.137.159)
X-Spam-Status: No, score=-12.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2023-02-03 04:19, Greg KH wrote:
> 
> On Mon, Jan 30, 2023 at 03:28:23PM +0000, Luiz Capitulino wrote:
>> From: Andrea Righi <andrea.righi@canonical.com>
>>
>> Commit ebc5951eea499314f6fbbde20e295f1345c67330 upstream.
>>
>> [ This fixes a performance issue we're seeing in AWS instances when
>>    running swapoff and using the global readahead algorithm. For a
>>    particular instance configuration, Without this fix I/O throughput
>>    is very low during swapoff (about 15 MB/s) with this patch is
>>    reaches 500 MB/s. Tested swapoff with different workloads with
>>    this patch applied. 5.10 onwards already have this fix ]
>>
>> In unuse_pte_range() we blindly swap-in pages without checking if the
>> swap entry is already present in the swap cache.
>>
>> By doing this, the hit/miss ratio used by the swap readahead heuristic
>> is not properly updated and this leads to non-optimal performance during
>> swapoff.
>>
>> Tracing the distribution of the readahead size returned by the swap
>> readahead heuristic during swapoff shows that a small readahead size is
>> used most of the time as if we had only misses (this happens both with
>> cluster and vma readahead), for example:
>>
>> r::swapin_nr_pages(unsigned long offset):unsigned long:$retval
>>          COUNT      EVENT
>>          36948      $retval = 8
>>          44151      $retval = 4
>>          49290      $retval = 1
>>          527771     $retval = 2
>>
>> Checking if the swap entry is present in the swap cache, instead, allows
>> to properly update the readahead statistics and the heuristic behaves in a
>> better way during swapoff, selecting a bigger readahead size:
>>
>> r::swapin_nr_pages(unsigned long offset):unsigned long:$retval
>>          COUNT      EVENT
>>          1618       $retval = 1
>>          4960       $retval = 2
>>          41315      $retval = 4
>>          103521     $retval = 8
>>
>> In terms of swapoff performance the result is the following:
>>
>> Testing environment
>> ===================
>>
>>   - Host:
>>     CPU: 1.8GHz Intel Core i7-8565U (quad-core, 8MB cache)
>>     HDD: PC401 NVMe SK hynix 512GB
>>     MEM: 16GB
>>
>>   - Guest (kvm):
>>     8GB of RAM
>>     virtio block driver
>>     16GB swap file on ext4 (/swapfile)
>>
>> Test case
>> =========
>>   - allocate 85% of memory
>>   - `systemctl hibernate` to force all the pages to be swapped-out to the
>>     swap file
>>   - resume the system
>>   - measure the time that swapoff takes to complete:
>>     # /usr/bin/time swapoff /swapfile
>>
>> Result (swapoff time)
>> ======
>>                    5.6 vanilla   5.6 w/ this patch
>>                    -----------   -----------------
>> cluster-readahead      22.09s              12.19s
>>      vma-readahead      18.20s              15.33s
>>
>> Conclusion
>> ==========
>>
>> The specific use case this patch is addressing is to improve swapoff
>> performance in cloud environments when a VM has been hibernated, resumed
>> and all the memory needs to be forced back to RAM by disabling swap.
>>
>> This change allows to better exploits the advantages of the readahead
>> heuristic during swapoff and this improvement allows to to speed up the
>> resume process of such VMs.
>>
>> [andrea.righi@canonical.com: update changelog]
>>    Link: http://lkml.kernel.org/r/20200418084705.GA147642@xps-13
>> Signed-off-by: Andrea Righi <andrea.righi@canonical.com>
>> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>> Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
>> Cc: Minchan Kim <minchan@kernel.org>
>> Cc: Anchal Agarwal <anchalag@amazon.com>
>> Cc: Hugh Dickins <hughd@google.com>
>> Cc: Vineeth Remanan Pillai <vpillai@digitalocean.com>
>> Cc: Kelley Nielsen <kelleynnn@gmail.com>
>> Link: http://lkml.kernel.org/r/20200416180132.GB3352@xps-13
>> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
>> ---
> 
> You forwarded on a backport without signing off on it yourself, sorry, I
> can't take this as-is.  Please fix up and resend.

Duh... resending...

> 
> thanks,
> 
> greg k-h
