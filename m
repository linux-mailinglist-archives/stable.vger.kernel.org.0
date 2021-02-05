Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4C6F311484
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 23:07:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231252AbhBEWHY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 17:07:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:44672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232672AbhBEOwM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Feb 2021 09:52:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C7F1D64FE4;
        Fri,  5 Feb 2021 14:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612534213;
        bh=W7Vpy83IOBxnKH/43Ksz8+uME4R/QTSbwanOW1c2S1g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oxYze5t/vuK9ygGUAXVLa006CfwroiT16Oq76IeF+YYvhM10A0drV5fHlO1TF/YDf
         2vc0eFotntsrMw7hRk5Hh8n76KxWdaQOXYvZ8vDc9TVGmUIPNAlRcWtbEgufO9NpX+
         WfIuknq1lpVJMpCL/cbE0eNU08mH0MSdPdekqX/s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Subbaraya Sundeep <sbhatta@marvell.com>,
        Kevin Hao <haokexin@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 04/57] net: octeontx2: Make sure the buffer is 128 byte aligned
Date:   Fri,  5 Feb 2021 15:06:30 +0100
Message-Id: <20210205140656.168305608@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210205140655.982616732@linuxfoundation.org>
References: <20210205140655.982616732@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kevin Hao <haokexin@gmail.com>

commit db2805150a0f27c00ad286a29109397a7723adad upstream.

The octeontx2 hardware needs the buffer to be 128 byte aligned.
But in the current implementation of napi_alloc_frag(), it can't
guarantee the return address is 128 byte aligned even the request size
is a multiple of 128 bytes, so we have to request an extra 128 bytes and
use the PTR_ALIGN() to make sure that the buffer is aligned correctly.

Fixes: 7a36e4918e30 ("octeontx2-pf: Use the napi_alloc_frag() to alloc the pool buffers")
Reported-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Kevin Hao <haokexin@gmail.com>
Tested-by: Subbaraya Sundeep <sbhatta@marvell.com>
Link: https://lore.kernel.org/r/20210121070906.25380-1-haokexin@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -473,10 +473,11 @@ dma_addr_t __otx2_alloc_rbuf(struct otx2
 	dma_addr_t iova;
 	u8 *buf;
 
-	buf = napi_alloc_frag(pool->rbsize);
+	buf = napi_alloc_frag(pool->rbsize + OTX2_ALIGN);
 	if (unlikely(!buf))
 		return -ENOMEM;
 
+	buf = PTR_ALIGN(buf, OTX2_ALIGN);
 	iova = dma_map_single_attrs(pfvf->dev, buf, pool->rbsize,
 				    DMA_FROM_DEVICE, DMA_ATTR_SKIP_CPU_SYNC);
 	if (unlikely(dma_mapping_error(pfvf->dev, iova))) {


