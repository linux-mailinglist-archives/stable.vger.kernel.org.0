Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3099D5FA2FB
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 19:55:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229452AbiJJRzs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Oct 2022 13:55:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbiJJRzr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Oct 2022 13:55:47 -0400
Received: from smtp-fw-2101.amazon.com (smtp-fw-2101.amazon.com [72.21.196.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D05FD75FE3;
        Mon, 10 Oct 2022 10:55:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1665424547; x=1696960547;
  h=message-id:date:mime-version:subject:from:to:cc:
   references:in-reply-to:content-transfer-encoding;
  bh=sLlTjQcr0Op/6Zcx8OCFNh8EO9JbDZcvu4VpyKatzLc=;
  b=gNLQzTIcmXBUVKgcptTqVkBlmkzJduXm7h/S3zUAiI4ZeWDjp7DBGnxv
   dG1UVepm2MnIGerQ80YVVgw659qJ9PI+U+aTBFq9niOdWwMArhox0GwW/
   K7KC9Z82Yqm8N8i5Qmf408CcF3igmxYwyV0x1NutlWFdkLnjYS4x12i1P
   k=;
X-IronPort-AV: E=Sophos;i="5.95,173,1661817600"; 
   d="scan'208";a="250379094"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2a-6fd66c4a.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Oct 2022 17:55:45 +0000
Received: from EX13MTAUWC002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2a-6fd66c4a.us-west-2.amazon.com (Postfix) with ESMTPS id BBF55A25CF;
        Mon, 10 Oct 2022 17:55:44 +0000 (UTC)
Received: from EX19D002UWC004.ant.amazon.com (10.13.138.186) by
 EX13MTAUWC002.ant.amazon.com (10.43.162.240) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Mon, 10 Oct 2022 17:55:44 +0000
Received: from [192.168.25.29] (10.43.162.230) by
 EX19D002UWC004.ant.amazon.com (10.13.138.186) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.12;
 Mon, 10 Oct 2022 17:55:43 +0000
Message-ID: <b73250f3-2dd6-36da-4d69-3149959f2e67@amazon.com>
Date:   Mon, 10 Oct 2022 10:55:42 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.3.2
Subject: Re: [PATCH v2] nvme-pci: Set min align mask before calculating
 max_hw_sectors
Content-Language: en-US
From:   "Bhatnagar, Rishabh" <risbhat@amazon.com>
To:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     "hch@lst.de" <hch@lst.de>, "sagi@grimberg.me" <sagi@grimberg.me>,
        "axboe@fb.com" <axboe@fb.com>,
        "kbusch@kernel.org" <kbusch@kernel.org>,
        "Bacco, Mike" <mbacco@amazon.com>,
        "Herrenschmidt, Benjamin" <benh@amazon.com>,
        "Park, SeongJae" <sjpark@amazon.com>
References: <20220929182259.22523-1-risbhat@amazon.com>
 <EB43F4D1-BFD0-408B-93E7-10643B59F766@amazon.com>
In-Reply-To: <EB43F4D1-BFD0-408B-93E7-10643B59F766@amazon.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.43.162.230]
X-ClientProxiedBy: EX13D38UWB003.ant.amazon.com (10.43.161.178) To
 EX19D002UWC004.ant.amazon.com (10.13.138.186)
X-Spam-Status: No, score=-12.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 10/4/22 9:27 AM, Bhatnagar, Rishabh wrote:
> On 9/29/22, 11:23 AM, "Rishabh Bhatnagar" <risbhat@amazon.com> wrote:
>
>      In cases where swiotlb is enabled dma_max_mapping_size takes into
>      account the min align mask for the device. Right now the mask is
>      set after the max hw sectors are calculated which might result in
>      a request size that overflows the swiotlb buffer.
>      Set the min align mask for nvme driver before calling
>      dma_max_mapping_size while calculating max hw sectors.
>      
>      Fixes: 7637de311bd2 ("nvme-pci: limit max_hw_sectors based on the DMA max mapping size")
>      Cc: stable@vger.kernel.org
>      Signed-off-by: Rishabh Bhatnagar <risbhat@amazon.com>
>      ---
>       Changes in V2:
>       - Add Cc: <stable@vger.kernel.org> tag
>       - Improve the commit text
>       - Add patch version
>      
>       Changes in V1:
>       - Add fixes tag
>      
>       drivers/nvme/host/pci.c | 3 ++-
>       1 file changed, 2 insertions(+), 1 deletion(-)
>      
>      diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
>      index 98864b853eef..30e71e41a0a2 100644
>      --- a/drivers/nvme/host/pci.c
>      +++ b/drivers/nvme/host/pci.c
>      @@ -2834,6 +2834,8 @@ static void nvme_reset_work(struct work_struct *work)
>       		nvme_start_admin_queue(&dev->ctrl);
>       	}
>       
>      +	dma_set_min_align_mask(dev->dev, NVME_CTRL_PAGE_SIZE - 1);
>      +
>       	/*
>       	 * Limit the max command size to prevent iod->sg allocations going
>       	 * over a single page.
>      @@ -2846,7 +2848,6 @@ static void nvme_reset_work(struct work_struct *work)
>       	 * Don't limit the IOMMU merged segment size.
>       	 */
>       	dma_set_max_seg_size(dev->dev, 0xffffffff);
>      -	dma_set_min_align_mask(dev->dev, NVME_CTRL_PAGE_SIZE - 1);
>       
>       	mutex_unlock(&dev->shutdown_lock);
>       
>      --
>      2.37.1
>      
>      

Hi. Any review on this patch would be much appreciated!

Thanks
Rishabh

