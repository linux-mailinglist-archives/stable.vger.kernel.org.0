Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95AD64891C7
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 08:42:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235928AbiAJHge (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 02:36:34 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:41404 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240848AbiAJHcr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 02:32:47 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C204B611B6;
        Mon, 10 Jan 2022 07:32:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6AE1C36AEF;
        Mon, 10 Jan 2022 07:32:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641799966;
        bh=Lu4XgzqD4Y66Q0usyFzBvUsYXS/nROphKLCsJuhY/Us=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n4xt85kW5uLbzGpb9ajCodtMSNYFavvtmYp3kuo5ii3kHiq78v5yTehluZNSkwC2G
         9spIkLcsE2WqKXFQiPl4AtDChJJQgP7Px1e8YpbDXnmZcr1mpglfz67noe4g9X4RHW
         5UfRUJhBFlR5Kcv77xVE9o28wOT2HMl/DdYUY7PQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shay Agroskin <shayagr@amazon.com>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.15 31/72] net: ena: Fix error handling when calculating max IO queues number
Date:   Mon, 10 Jan 2022 08:23:08 +0100
Message-Id: <20220110071822.610624488@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220110071821.500480371@linuxfoundation.org>
References: <20220110071821.500480371@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arthur Kiyanovski <akiyano@amazon.com>

commit 5055dc0348b8b7c168e3296044bccd724e1ae6cd upstream.

The role of ena_calc_max_io_queue_num() is to return the number
of queues supported by the device, which means the return value
should be >=0.

The function that calls ena_calc_max_io_queue_num(), checks
the return value. If it is 0, it means the device reported
it supports 0 IO queues. This case is considered an error
and is handled by the calling function accordingly.

However the current implementation of ena_calc_max_io_queue_num()
is wrong, since when it detects the device supports 0 IO queues,
it returns -EFAULT.

In such a case the calling function doesn't detect the error,
and therefore doesn't handle it.

This commit changes ena_calc_max_io_queue_num() to return 0
in case the device reported it supports 0 queues, allowing the
calling function to properly handle the error case.

Fixes: 736ce3f414cc ("net: ena: make ethtool -l show correct max number of queues")
Signed-off-by: Shay Agroskin <shayagr@amazon.com>
Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -4026,10 +4026,6 @@ static u32 ena_calc_max_io_queue_num(str
 	max_num_io_queues = min_t(u32, max_num_io_queues, io_tx_cq_num);
 	/* 1 IRQ for mgmnt and 1 IRQs for each IO direction */
 	max_num_io_queues = min_t(u32, max_num_io_queues, pci_msix_vec_count(pdev) - 1);
-	if (unlikely(!max_num_io_queues)) {
-		dev_err(&pdev->dev, "The device doesn't have io queues\n");
-		return -EFAULT;
-	}
 
 	return max_num_io_queues;
 }


