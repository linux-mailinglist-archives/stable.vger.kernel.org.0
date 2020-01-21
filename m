Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E78E8143919
	for <lists+stable@lfdr.de>; Tue, 21 Jan 2020 10:07:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729076AbgAUJHh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jan 2020 04:07:37 -0500
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:58305 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728816AbgAUJHh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jan 2020 04:07:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1579597656; x=1611133656;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=xxUKV6eYs53CctdQJsRE86nf14teuaNxvJM6Mv3hu9E=;
  b=lUFLTnEpNtPqKkcqP0P5eScYn7+kjSqvUI88pRfhTPE+STFTBrDAJ0fD
   01J42+PwWYoBmElmhbPJ1TM6NGe7sDWLfFvyI9MhMcHukuNQ0I1bQiN2L
   rKl688xGxYgRAa6EvD250OOx3pCVtiqbmrZq0V9Q37wLKaM8kflSPs6mH
   A=;
IronPort-SDR: aBkEAAS/9ty2ykz38l03NWTrPw/FI8gZO+Qhb8tyaE4ANF7W03kBYS5pYwXQwohV/wgwVokz7I
 vGm1E9HRjnrg==
X-IronPort-AV: E=Sophos;i="5.70,345,1574121600"; 
   d="scan'208";a="13990018"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1d-f273de60.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 21 Jan 2020 09:07:35 +0000
Received: from EX13MTAUEA002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1d-f273de60.us-east-1.amazon.com (Postfix) with ESMTPS id 19757A18F8;
        Tue, 21 Jan 2020 09:07:32 +0000 (UTC)
Received: from EX13D19EUB003.ant.amazon.com (10.43.166.69) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1236.3; Tue, 21 Jan 2020 09:07:30 +0000
Received: from 8c85908914bf.ant.amazon.com (10.43.161.253) by
 EX13D19EUB003.ant.amazon.com (10.43.166.69) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 21 Jan 2020 09:07:26 +0000
Subject: Re: [PATCH for-rc] Revert "RDMA/efa: Use API to get contiguous memory
 blocks aligned to device supported page size"
To:     Shiraz Saleem <shiraz.saleem@intel.com>
CC:     Jason Gunthorpe <jgg@ziepe.ca>, Doug Ledford <dledford@redhat.com>,
        <linux-rdma@vger.kernel.org>,
        Alexander Matushevsky <matua@amazon.com>,
        <stable@vger.kernel.org>, "Leybovich, Yossi" <sleybo@amazon.com>
References: <20200120141001.63544-1-galpress@amazon.com>
From:   Gal Pressman <galpress@amazon.com>
Message-ID: <0557a917-b6ad-1be7-e46b-cbe08f2ee4d3@amazon.com>
Date:   Tue, 21 Jan 2020 11:07:21 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <20200120141001.63544-1-galpress@amazon.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.43.161.253]
X-ClientProxiedBy: EX13D08UWB003.ant.amazon.com (10.43.161.186) To
 EX13D19EUB003.ant.amazon.com (10.43.166.69)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 20/01/2020 16:10, Gal Pressman wrote:
> The cited commit leads to register MR failures and random hangs when
> running different MPI applications. The exact root cause for the issue
> is still not clear, this revert brings us back to a stable state.
> 
> This reverts commit 40ddb3f020834f9afb7aab31385994811f4db259.
> 
> Fixes: 40ddb3f02083 ("RDMA/efa: Use API to get contiguous memory blocks aligned to device supported page size")
> Cc: Shiraz Saleem <shiraz.saleem@intel.com>
> Cc: stable@vger.kernel.org # 5.3
> Signed-off-by: Gal Pressman <galpress@amazon.com>

Shiraz, I think I found the root cause here.
I'm noticing a register MR of size 32k, which is constructed from two sges, the
first sge of size 12k and the second of 20k.

ib_umem_find_best_pgsz returns page shift 13 in the following way:

0x103dcb2000      0x103dcb5000       0x103dd5d000           0x103dd62000
          +----------+                      +------------------+
          |          |                      |                  |
          |  12k     |                      |     20k          |
          +----------+                      +------------------+

          +------+------+                 +------+------+------+
          |      |      |                 |      |      |      |
          | 8k   | 8k   |                 | 8k   | 8k   | 8k   |
          +------+------+                 +------+------+------+
0x103dcb2000       0x103dcb6000   0x103dd5c000              0x103dd62000


The top row is the original umem sgl, and the bottom is the sgl constructed by
rdma_for_each_block with page size of 8k.

Is this the expected output? The 8k pages cover addresses which aren't part of
the MR. This breaks some of the assumptions in the driver (for example, the way
we calculate the number of pages in the MR) and I'm not sure our device can
handle such sgl.
