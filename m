Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CC03144CB2
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 08:59:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727141AbgAVH7B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 02:59:01 -0500
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:56733 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726077AbgAVH7B (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Jan 2020 02:59:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1579679940; x=1611215940;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=eNuhrgSKsx0reswq4Jh0hGHfh6pPsqeQyjK5MBHJqUA=;
  b=KU0m2/GmTeZgBvFudEfmJ62zoDp22NAHEtUO7vmVEV7gxmOwToMK8Nrq
   NZUtMtjPGU4ZTlshcHp5U6k+lEh0py5ZZ2d/ssR+NBnj6QK1DEs1GBvYU
   gSz80ZTZLZEfzLtgzzuJy6b9znf7EbnlKHLxlr7/Sg93XgQTLKdG8gMqm
   Q=;
IronPort-SDR: Hxv1I/KMQHR27ineNaLBPfDhL/rwSIio1yjiVUARMQ1+paqdQxAaWLI5bwmUnuHQwE7OZis1zs
 tNXzfribzvqQ==
X-IronPort-AV: E=Sophos;i="5.70,348,1574121600"; 
   d="scan'208";a="11905177"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2c-2225282c.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 22 Jan 2020 07:58:49 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2c-2225282c.us-west-2.amazon.com (Postfix) with ESMTPS id 67EC1A2522;
        Wed, 22 Jan 2020 07:58:49 +0000 (UTC)
Received: from EX13D19EUB003.ant.amazon.com (10.43.166.69) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1236.3; Wed, 22 Jan 2020 07:58:49 +0000
Received: from 8c85908914bf.ant.amazon.com (10.43.160.8) by
 EX13D19EUB003.ant.amazon.com (10.43.166.69) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 22 Jan 2020 07:58:44 +0000
Subject: Re: [PATCH for-rc] Revert "RDMA/efa: Use API to get contiguous memory
 blocks aligned to device supported page size"
To:     "Saleem, Shiraz" <shiraz.saleem@intel.com>
CC:     Jason Gunthorpe <jgg@ziepe.ca>, Doug Ledford <dledford@redhat.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "Alexander Matushevsky" <matua@amazon.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Leybovich, Yossi" <sleybo@amazon.com>
References: <20200120141001.63544-1-galpress@amazon.com>
 <0557a917-b6ad-1be7-e46b-cbe08f2ee4d3@amazon.com>
 <9DD61F30A802C4429A01CA4200E302A7C1E2A8D0@fmsmsx124.amr.corp.intel.com>
From:   Gal Pressman <galpress@amazon.com>
Message-ID: <d118c957-90f2-18d4-9baf-9b0c9a8a972b@amazon.com>
Date:   Wed, 22 Jan 2020 09:58:39 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <9DD61F30A802C4429A01CA4200E302A7C1E2A8D0@fmsmsx124.amr.corp.intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.43.160.8]
X-ClientProxiedBy: EX13D29UWA004.ant.amazon.com (10.43.160.33) To
 EX13D19EUB003.ant.amazon.com (10.43.166.69)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 21/01/2020 18:39, Saleem, Shiraz wrote:
>> Subject: Re: [PATCH for-rc] Revert "RDMA/efa: Use API to get contiguous
>> memory blocks aligned to device supported page size"
>>
>> On 20/01/2020 16:10, Gal Pressman wrote:
>>> The cited commit leads to register MR failures and random hangs when
>>> running different MPI applications. The exact root cause for the issue
>>> is still not clear, this revert brings us back to a stable state.
>>>
>>> This reverts commit 40ddb3f020834f9afb7aab31385994811f4db259.
>>>
>>> Fixes: 40ddb3f02083 ("RDMA/efa: Use API to get contiguous memory
>>> blocks aligned to device supported page size")
>>> Cc: Shiraz Saleem <shiraz.saleem@intel.com>
>>> Cc: stable@vger.kernel.org # 5.3
>>> Signed-off-by: Gal Pressman <galpress@amazon.com>
>>
>> Shiraz, I think I found the root cause here.
>> I'm noticing a register MR of size 32k, which is constructed from two sges, the first
>> sge of size 12k and the second of 20k.
>>
>> ib_umem_find_best_pgsz returns page shift 13 in the following way:
>>
>> 0x103dcb2000      0x103dcb5000       0x103dd5d000           0x103dd62000
>>           +----------+                      +------------------+
>>           |          |                      |                  |
>>           |  12k     |                      |     20k          |
>>           +----------+                      +------------------+
>>
>>           +------+------+                 +------+------+------+
>>           |      |      |                 |      |      |      |
>>           | 8k   | 8k   |                 | 8k   | 8k   | 8k   |
>>           +------+------+                 +------+------+------+
>> 0x103dcb2000       0x103dcb6000   0x103dd5c000              0x103dd62000
>>
>>
> 
> Gal - would be useful to know the IOVA (virt) and umem->addr also for this MR in ib_umem_find_best_pgsz

I'll update my debug prints to include the iova and rerun the tests.
