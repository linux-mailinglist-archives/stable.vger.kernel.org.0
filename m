Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 001C35FB8ED
	for <lists+stable@lfdr.de>; Tue, 11 Oct 2022 19:06:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229641AbiJKRGP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Oct 2022 13:06:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbiJKRGO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Oct 2022 13:06:14 -0400
Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1206C82743;
        Tue, 11 Oct 2022 10:06:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1665507974; x=1697043974;
  h=message-id:date:mime-version:to:cc:references:from:
   in-reply-to:content-transfer-encoding:subject;
  bh=07xQWyffa4Ix1g/pvcHIWfwGdtig1uyAadKbd+ed3as=;
  b=oqJeyYaFTMT3zENT96T0UAvQigcVzmo/s3kPmts04gN6w0KEot5gPH2p
   5uOlK8NbwRdJCwmdbc2GcnQ6w418dgCcgqNftprnBDhHEmFonQTPIeXtd
   3jfDL0lpSOklCy4S2XdHma/nXNhpZWnu76QoNoDy6uBOx1RbUSm35dTGB
   Y=;
Subject: Re: [PATCH v2] nvme-pci: Set min align mask before calculating max_hw_sectors
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-iad-1d-54a073b7.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Oct 2022 17:06:12 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1d-54a073b7.us-east-1.amazon.com (Postfix) with ESMTPS id 5E2D49BC32;
        Tue, 11 Oct 2022 17:06:10 +0000 (UTC)
Received: from EX19D002UWC004.ant.amazon.com (10.13.138.186) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Tue, 11 Oct 2022 17:05:40 +0000
Received: from [10.85.223.213] (10.43.162.213) by
 EX19D002UWC004.ant.amazon.com (10.13.138.186) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.12;
 Tue, 11 Oct 2022 17:05:39 +0000
Message-ID: <8f451a9e-3324-c7d4-cf61-a105fd087192@amazon.com>
Date:   Tue, 11 Oct 2022 10:05:38 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.3.2
Content-Language: en-US
To:     "hch@lst.de" <hch@lst.de>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
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
From:   "Bhatnagar, Rishabh" <risbhat@amazon.com>
In-Reply-To: <20221011060829.GA3172@lst.de>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.43.162.213]
X-ClientProxiedBy: EX13D41UWC002.ant.amazon.com (10.43.162.127) To
 EX19D002UWC004.ant.amazon.com (10.13.138.186)
X-Spam-Status: No, score=-14.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 10/10/22 11:08 PM, hch@lst.de wrote:
> CAUTION: This email originated from outside of the organization. Do not click links or open attachments unless you can confirm the sender and know the content is safe.
>
>
>
> The patch already made it to Linux 6.0, so I'm not sure what we need
> to review again.

Oh, I never got any email that this was being picked up so sent it 
again. Anyways thanks for taking it.
We need this patch for 5.10/5.15 stable kernels as well. I can send 
backport patches to stable tree
maintainers unless there is a way for you to mark it so that its 
automatically picked for stable trees.

Thanks
Rishabh

