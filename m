Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51B3014B435
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 13:32:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726007AbgA1Mco (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 07:32:44 -0500
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:61333 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725948AbgA1Mco (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Jan 2020 07:32:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1580214764; x=1611750764;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=LPk/bOSMWr04QW8BaeqVKDaUQ2yJKgv1LGPcAD4D1g0=;
  b=Hg4h9xj/mwI8ptXxgqll8O6IwnINauGIHv/RbP9Vz0MbohxI2KtkjcNe
   6QCB9ZlLztTbSbFnkzYjAgZcL+VJOIjCs4+rxyanTNmncXHAAzoO5GNYx
   7RIdhxPxdP1YQP/Fni46T0Ra73r3WCil5PR9zBP0Mjy5tjbcq+5Ne5hxW
   Y=;
IronPort-SDR: HJoYPAszfAkdoy33i8CKWpo+cuVbHkt9NPFRgmMQQOANlYHJhiYffA9IP/sdejzCzNUaLB2rRl
 u1cgCoAHtArA==
X-IronPort-AV: E=Sophos;i="5.70,373,1574121600"; 
   d="scan'208";a="22906732"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1a-807d4a99.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 28 Jan 2020 12:32:32 +0000
Received: from EX13MTAUEA002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1a-807d4a99.us-east-1.amazon.com (Postfix) with ESMTPS id 56407A2FF4;
        Tue, 28 Jan 2020 12:32:30 +0000 (UTC)
Received: from EX13D19EUB003.ant.amazon.com (10.43.166.69) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1236.3; Tue, 28 Jan 2020 12:32:29 +0000
Received: from 8c85908914bf.ant.amazon.com (10.43.162.224) by
 EX13D19EUB003.ant.amazon.com (10.43.166.69) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 28 Jan 2020 12:32:25 +0000
Subject: Re: [PATCH for-rc] Revert "RDMA/efa: Use API to get contiguous memory
 blocks aligned to device supported page size"
To:     Jason Gunthorpe <jgg@ziepe.ca>,
        "Saleem, Shiraz" <shiraz.saleem@intel.com>,
        Leon Romanovsky <leon@kernel.org>
CC:     Doug Ledford <dledford@redhat.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Alexander Matushevsky <matua@amazon.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Leybovich, Yossi" <sleybo@amazon.com>
References: <20200120141001.63544-1-galpress@amazon.com>
 <0557a917-b6ad-1be7-e46b-cbe08f2ee4d3@amazon.com>
 <20200121162436.GL51881@unreal>
 <47c20471-2251-b93b-053d-87880fa0edf5@amazon.com>
 <20200123142443.GN7018@unreal>
 <60d8c528-1088-df8d-76f0-4746acfcfc7a@amazon.com>
 <9DD61F30A802C4429A01CA4200E302A7C57244BB@fmsmsx123.amr.corp.intel.com>
 <20200124025221.GA16405@ziepe.ca>
From:   Gal Pressman <galpress@amazon.com>
Message-ID: <def88bd8-357f-54b4-90f7-ee0ab382aa95@amazon.com>
Date:   Tue, 28 Jan 2020 14:32:19 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <20200124025221.GA16405@ziepe.ca>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.43.162.224]
X-ClientProxiedBy: EX13D24UWB004.ant.amazon.com (10.43.161.4) To
 EX13D19EUB003.ant.amazon.com (10.43.166.69)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 24/01/2020 4:52, Jason Gunthorpe wrote:
> On Fri, Jan 24, 2020 at 12:40:18AM +0000, Saleem, Shiraz wrote:
>> It would be good to get the debug data to back this or prove it wrong.
>> But if this is indeed what's happening, then ORing in the sgl->length for the
>> first sge to restrict the page size might cut it. So something like,
> 
> or'ing in the sgl length is a nonsense thing to do, the length has
> nothing to do with the restriction, which is entirely based on IOVA
> bits which can't be passed through.

The weekend runs passed with Leon's proposed patch.
Leon, can you please submit it so I can drop this revert?

Thanks
