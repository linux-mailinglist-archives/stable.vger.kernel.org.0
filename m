Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6DB55FBC2D
	for <lists+stable@lfdr.de>; Tue, 11 Oct 2022 22:35:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229480AbiJKUfn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Oct 2022 16:35:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230010AbiJKUf0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Oct 2022 16:35:26 -0400
Received: from smtp-fw-33001.amazon.com (smtp-fw-33001.amazon.com [207.171.190.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 174BA1B78D;
        Tue, 11 Oct 2022 13:35:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1665520516; x=1697056516;
  h=message-id:date:mime-version:to:cc:references:from:
   in-reply-to:content-transfer-encoding:subject;
  bh=l+UDoqY8SAjjQoyPGhCWbqLhxgeVvuWrW3n0iwV8+4c=;
  b=KZ2g6FxMbjTjUBrQgsTT81KhYqtldxjQPUXh0nqij5S6GtcgT5pGHr3v
   0t+LU5qxWJq56ahoD4b8rGqxhi3WlE+O6PL+nEIqsRPdgSiu9bpZ/zn60
   7CPvIFGu92VmJj+oWTD3RcbLG2JmvR9RxvdgdlhCTniB9lxrdvEEzADsH
   E=;
X-IronPort-AV: E=Sophos;i="5.95,177,1661817600"; 
   d="scan'208";a="232474151"
Subject: Re: [PATCH v2] nvme-pci: Set min align mask before calculating max_hw_sectors
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2a-e6c05252.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Oct 2022 20:35:15 +0000
Received: from EX13MTAUWC002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2a-e6c05252.us-west-2.amazon.com (Postfix) with ESMTPS id 19E9045542;
        Tue, 11 Oct 2022 20:35:13 +0000 (UTC)
Received: from EX19D002UWC004.ant.amazon.com (10.13.138.186) by
 EX13MTAUWC002.ant.amazon.com (10.43.162.240) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Tue, 11 Oct 2022 20:35:12 +0000
Received: from [192.168.21.170] (10.43.162.208) by
 EX19D002UWC004.ant.amazon.com (10.13.138.186) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.12;
 Tue, 11 Oct 2022 20:35:12 +0000
Message-ID: <bc7b08f4-673d-538f-e053-4edf899b9d60@amazon.com>
Date:   Tue, 11 Oct 2022 13:35:11 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.3.2
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     "hch@lst.de" <hch@lst.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "sagi@grimberg.me" <sagi@grimberg.me>,
        "axboe@fb.com" <axboe@fb.com>,
        "kbusch@kernel.org" <kbusch@kernel.org>,
        "Bacco, Mike" <mbacco@amazon.com>,
        "Herrenschmidt, Benjamin" <benh@amazon.com>,
        "Park, SeongJae" <sjpark@amazon.com>
References: <20220929182259.22523-1-risbhat@amazon.com>
 <EB43F4D1-BFD0-408B-93E7-10643B59F766@amazon.com>
 <b73250f3-2dd6-36da-4d69-3149959f2e67@amazon.com>
 <20221011060829.GA3172@lst.de>
 <8f451a9e-3324-c7d4-cf61-a105fd087192@amazon.com>
 <Y0W09tcGK/1ZAhQh@kroah.com>
From:   "Bhatnagar, Rishabh" <risbhat@amazon.com>
In-Reply-To: <Y0W09tcGK/1ZAhQh@kroah.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.43.162.208]
X-ClientProxiedBy: EX13D36UWA002.ant.amazon.com (10.43.160.24) To
 EX19D002UWC004.ant.amazon.com (10.13.138.186)
X-Spam-Status: No, score=-14.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 10/11/22 11:24 AM, Greg KH wrote:
> CAUTION: This email originated from outside of the organization. Do not click links or open attachments unless you can confirm the sender and know the content is safe.
>
>
>
> On Tue, Oct 11, 2022 at 10:05:38AM -0700, Bhatnagar, Rishabh wrote:
>> On 10/10/22 11:08 PM, hch@lst.de wrote:
>>> CAUTION: This email originated from outside of the organization. Do not click links or open attachments unless you can confirm the sender and know the content is safe.
>>>
>>>
>>>
>>> The patch already made it to Linux 6.0, so I'm not sure what we need
>>> to review again.
>> Oh, I never got any email that this was being picked up so sent it again.
>> Anyways thanks for taking it.
>> We need this patch for 5.10/5.15 stable kernels as well. I can send backport
>> patches to stable tree
>> maintainers unless there is a way for you to mark it so that its
>> automatically picked for stable trees.
> <formletter>
>
> This is not the correct way to submit patches for inclusion in the
> stable kernel tree.  Please read:
>      https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
> for how to do this properly.
>
> </formletter>

Since the original patch doesn't contain the CC:stable@vger.kernel.org, 
using option 2
makes sense as there is no special handling required to apply this for 
5.10/5.15.

