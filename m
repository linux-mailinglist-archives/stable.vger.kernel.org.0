Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E85EDEEE1
	for <lists+stable@lfdr.de>; Mon, 21 Oct 2019 16:09:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728945AbfJUOJU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Oct 2019 10:09:20 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:39777 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728851AbfJUOJT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Oct 2019 10:09:19 -0400
Received: by mail-qt1-f194.google.com with SMTP id t8so3648297qtc.6
        for <stable@vger.kernel.org>; Mon, 21 Oct 2019 07:09:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=nX1CLR4KImQdQJezAOPOCQCthODN8TlAzpK55nQlU+Q=;
        b=QbODSLH/kOLPH11Cn24zfiEXGTNUNChRP5/NjtqY6dgCggeNH/aaTylD77tPnMWrLi
         iKbeuN07qEz5sqF6bZLNUL9g0FUFO2exJYTG4cF0bN8mSLXgNOUnHdb6OjVtVisJUghe
         8JpnNzS89qNUq6flrmpEhVh0O5veSKVHtZFD3B1mM7e9fsYE2swJthSerH9co4g5hIm5
         Wz5YtIF8hUYoO//HPkGwJdZuCbwdTCUyVQnmEQX9yqleCmNN92kxiQpnaLeftekoe3eO
         LIRYdZZJlneBKQGGMmY80y4qmdMKSD9cqOo0fHGEPBO5KeBSX5QUfRyRRne3+hOJWEXT
         2Viw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=nX1CLR4KImQdQJezAOPOCQCthODN8TlAzpK55nQlU+Q=;
        b=CfBGM4cCVZShYO5ZdVYy7yssbBkA4x1sSmzXXeDmDkrQojGvF3ue/0hK65q/LMKPYp
         yU2LfSpF8bkistrIK5q+tpxzFRqqKy9Okexbzynx7Ng+rktt6AbDGgP3viciArcWu9GW
         nvz1r2Fsl64QXSO0i1l5YZojhzf83SrfjXLwIReZfctBNa8X6Y504yD5FTUGYPTTsVwS
         k5VZJLFcKVA5YUvvckRROoP54fMbp3xUJyyuEvnWed+kmNkbbTpG95zD9h3jmFrLAphr
         U1Z2ADuvm5o9a5WEvu0NrKBavb8o77Jtsqruj2+zOJsWDmwCZ4CCROpMm7lihXJ6iceC
         P+sQ==
X-Gm-Message-State: APjAAAUAMM6l0jauKHK7UGbHFo8ndcjQX6UXzBs3ssBJHZyzldwGyVEI
        jKxmld795VdfQQnhxTGPGWe58Q==
X-Google-Smtp-Source: APXvYqy3G88pVJguXp076wjYGHTIp6t9m/sYf7gEsGwYRwJmp47aIr4jzaRuFj2vD+lgGrj0Qp9nJg==
X-Received: by 2002:a0c:a9d1:: with SMTP id c17mr23061324qvb.246.1571666959029;
        Mon, 21 Oct 2019 07:09:19 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-162-113-180.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.180])
        by smtp.gmail.com with ESMTPSA id z20sm8859353qtu.91.2019.10.21.07.09.18
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 21 Oct 2019 07:09:18 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1iMYN3-00083K-Pw; Mon, 21 Oct 2019 11:09:17 -0300
Date:   Mon, 21 Oct 2019 11:09:17 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, stable@vger.kernel.org
Subject: Re: [PATCH 1/4] RDMA/core: Fix ib_dma_max_seg_size()
Message-ID: <20191021140917.GB25178@ziepe.ca>
References: <20191021021030.1037-1-bvanassche@acm.org>
 <20191021021030.1037-2-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191021021030.1037-2-bvanassche@acm.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Oct 20, 2019 at 07:10:27PM -0700, Bart Van Assche wrote:
> If dev->dma_device->params == NULL then the maximum DMA segment size is
> 64 KB. See also the dma_get_max_seg_size() implementation. This patch
> fixes the following kernel warning:
> 
> DMA-API: infiniband rxe0: mapping sg segment longer than device claims to support [len=126976] [max=65536]
> WARNING: CPU: 4 PID: 4848 at kernel/dma/debug.c:1220 debug_dma_map_sg+0x3d9/0x450
> RIP: 0010:debug_dma_map_sg+0x3d9/0x450
> Call Trace:
>  srp_queuecommand+0x626/0x18d0 [ib_srp]
>  scsi_queue_rq+0xd02/0x13e0 [scsi_mod]
>  __blk_mq_try_issue_directly+0x2b3/0x3f0
>  blk_mq_request_issue_directly+0xac/0xf0
>  blk_insert_cloned_request+0xdf/0x170
>  dm_mq_queue_rq+0x43d/0x830 [dm_mod]
>  __blk_mq_try_issue_directly+0x2b3/0x3f0
>  blk_mq_request_issue_directly+0xac/0xf0
>  blk_mq_try_issue_list_directly+0xb8/0x170
>  blk_mq_sched_insert_requests+0x23c/0x3b0
>  blk_mq_flush_plug_list+0x529/0x730
>  blk_flush_plug_list+0x21f/0x260
>  blk_mq_make_request+0x56b/0xf20
>  generic_make_request+0x196/0x660
>  submit_bio+0xae/0x290
>  blkdev_direct_IO+0x822/0x900
>  generic_file_direct_write+0x110/0x200
>  __generic_file_write_iter+0x124/0x2a0
>  blkdev_write_iter+0x168/0x270
>  aio_write+0x1c4/0x310
>  io_submit_one+0x971/0x1390
>  __x64_sys_io_submit+0x12a/0x390
>  do_syscall_64+0x6f/0x2e0
>  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> 
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: <stable@vger.kernel.org>
> Fixes: 0b5cb3300ae5 ("RDMA/srp: Increase max_segment_size")
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
>  include/rdma/ib_verbs.h | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
> index 6a47ba85c54c..e6c167d03aae 100644
> +++ b/include/rdma/ib_verbs.h
> @@ -4043,9 +4043,7 @@ static inline void ib_dma_unmap_sg_attrs(struct ib_device *dev,
>   */
>  static inline unsigned int ib_dma_max_seg_size(struct ib_device *dev)
>  {
> -	struct device_dma_parameters *p = dev->dma_device->dma_parms;
> -
> -	return p ? p->max_segment_size : UINT_MAX;
> +	return dma_get_max_seg_size(dev->dma_device);
>  }

Should we get rid of this wrapper?

Jason
