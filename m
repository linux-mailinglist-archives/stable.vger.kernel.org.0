Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E78A481B3A
	for <lists+stable@lfdr.de>; Thu, 30 Dec 2021 11:04:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238368AbhL3KE3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Dec 2021 05:04:29 -0500
Received: from smtp25.cstnet.cn ([159.226.251.25]:56756 "EHLO cstnet.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238256AbhL3KE3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Dec 2021 05:04:29 -0500
Received: from localhost.localdomain (unknown [124.16.138.126])
        by APP-05 (Coremail) with SMTP id zQCowACHjwMWhM1hULpQBQ--.24591S2;
        Thu, 30 Dec 2021 18:04:06 +0800 (CST)
From:   Jiasheng Jiang <jiasheng@iscas.ac.cn>
To:     pavel@denx.de, gregkh@linuxfoundation.org
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        habetsm.xilinx@gmail.com, kuba@kernel.org, sashal@kernel.org,
        Jiasheng Jiang <jiasheng@iscas.ac.cn>
Subject: Re: Re: [PATCH 5.10 26/76] sfc: Check null pointer of rx_queue->page_ring
Date:   Thu, 30 Dec 2021 18:04:05 +0800
Message-Id: <20211230100405.1846844-1-jiasheng@iscas.ac.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: zQCowACHjwMWhM1hULpQBQ--.24591S2
X-Coremail-Antispam: 1UD129KBjvJXoW7Kr13JFWxCF43uFy3Cr1fCrg_yoW8Xw4rpa
        yxKa47ua1kJa9xGFyjkrn7uF9ayw15tFW7Wr1fG34Fv345AF9rZr9xK3ZF9r4qyr4DJF42
        vr4DJa1qyanxX37anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkq14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
        6F4UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s
        0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xII
        jxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr
        1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxkIecxEwVAFwVW8twCF
        04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r
        18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vI
        r41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr
        1lIxAIcVCF04k26cxKx2IYs7xG6rW3Jr0E3s1lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAI
        cVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUbGQ6JUUUUU==
X-Originating-IP: [124.16.138.126]
X-CM-SenderInfo: pmld2xxhqjqxpvfd2hldfou0/
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 29 Dec 2021 19:17:30 +0800, Pavel Machek wrote:
> So we have !rx_queue->page_ring. But in efx_reuse_page, we do
>
>       index = rx_queue->page_remove & rx_queue->page_ptr_mask;
> 	page = rx_queue->page_ring[index];
>
> So index is now zero, but we'll derefernce null pointer
> anyway.

Thanks for your reply.
I am so sorry to submit the wrong patch and cause the trouble.
Now there are two ways to fix it.
One is to directly return error when fails and finally cause the failure
of the efx_start_all().
But I notice that efx_start_channels() -> efx_init_rx_queue() ->
efx_init_rx_recycle_ring(), and efx_start_channels() starts many
channels.
Maybe the last channel fails without the enough memory, but the other
are success and can work regularly.
To work more efficiently, I think the second way is better that we just
check every where using rx_queue->page_ring.
In this way, we don't need to alloc and free the channels frequently and
finish most of the job.
The patch is something that likes as follow.

diff --git a/drivers/net/ethernet/sfc/rx_common.c
b/drivers/net/ethernet/sfc/rx_common.c
index 68fc7d317693..7172b5fcc104 100644
--- a/drivers/net/ethernet/sfc/rx_common.c
+++ b/drivers/net/ethernet/sfc/rx_common.c
@@ -45,6 +45,9 @@ static struct page *efx_reuse_page(struct efx_rx_queue
*rx_queue)
        unsigned int index;
	struct page *page;

+       if (!rx_queue->page_ring)
+               return NULL;
+
	index = rx_queue->page_remove &
	rx_queue->page_ptr_mask;
	page = rx_queue->page_ring[index];
	if (page == NULL)

