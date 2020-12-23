Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79AAA2E1E36
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 16:40:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728283AbgLWPeC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Dec 2020 10:34:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:44716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726558AbgLWPd7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 23 Dec 2020 10:33:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 91C3C2335A;
        Wed, 23 Dec 2020 15:32:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1608737580;
        bh=Sa8wnWGI+jrp/L3LiFuUnc4c/d7KE7JE2axxyux/NqI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wLJgBBJh0SMp/P09G15QW4WuFQYhlNCQAxmUpPWso3/xkJw+JRAVrxqi+bEKnFOjo
         o4vMAmT+G0NC4mHq6jQfz0JZbKhk0wzWv49lLRipAhfu/WhvVca4NyMKbZ7J7ExreY
         OeftDMOYxa2TMSNLqMoiIeB7yB33WymoWzPeK6G4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Suzuki K Poulose <suzuki.poulose@arm.com>,
        Mao Jinlong <jinlmao@codeaurora.org>,
        Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: [PATCH 5.10 16/40] coresight: tmc-etr: Check if page is valid before dma_map_page()
Date:   Wed, 23 Dec 2020 16:33:17 +0100
Message-Id: <20201223150516.338413247@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201223150515.553836647@linuxfoundation.org>
References: <20201223150515.553836647@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mao Jinlong <jinlmao@codeaurora.org>

commit 1cc573d5754e92372a7e30e35468644f8811e1a4 upstream.

alloc_pages_node() return should be checked before calling
dma_map_page() to make sure that valid page is mapped or
else it can lead to aborts as below:

 Unable to handle kernel paging request at virtual address ffffffc008000000
 Mem abort info:
 <snip>...
 pc : __dma_inv_area+0x40/0x58
 lr : dma_direct_map_page+0xd8/0x1c8

 Call trace:
  __dma_inv_area
  tmc_pages_alloc
  tmc_alloc_data_pages
  tmc_alloc_sg_table
  tmc_init_etr_sg_table
  tmc_alloc_etr_buf
  tmc_enable_etr_sink_sysfs
  tmc_enable_etr_sink
  coresight_enable_path
  coresight_enable
  enable_source_store
  dev_attr_store
  sysfs_kf_write

Fixes: 99443ea19e8b ("coresight: Add generic TMC sg table framework")
Cc: stable@vger.kernel.org
Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Mao Jinlong <jinlmao@codeaurora.org>
Signed-off-by: Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Link: https://lore.kernel.org/r/20201127175256.1092685-13-mathieu.poirier@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hwtracing/coresight/coresight-tmc-etr.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/hwtracing/coresight/coresight-tmc-etr.c
+++ b/drivers/hwtracing/coresight/coresight-tmc-etr.c
@@ -217,6 +217,8 @@ static int tmc_pages_alloc(struct tmc_pa
 		} else {
 			page = alloc_pages_node(node,
 						GFP_KERNEL | __GFP_ZERO, 0);
+			if (!page)
+				goto err;
 		}
 		paddr = dma_map_page(real_dev, page, 0, PAGE_SIZE, dir);
 		if (dma_mapping_error(real_dev, paddr))


