Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 212164891E1
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 08:43:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240437AbiAJHhA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 02:37:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240991AbiAJHeb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 02:34:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF190C0253BA;
        Sun,  9 Jan 2022 23:30:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6DB86611CE;
        Mon, 10 Jan 2022 07:30:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54D2FC36AED;
        Mon, 10 Jan 2022 07:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641799816;
        bh=3dspLntcUy2ueE+BT3e4HrJZXKrmVmN8PqhoofAlJkA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ML+EJA95DcR8kTwla1pN1ahKJt7hWTZRtZmplNvlHs2S0brN/1gXxlsNHWOjVOiAn
         /bMiUuSgHTAHJSJ6mKmyFNg/kTkDomxxnndq2eZOJsLzJw+Izkm+1RsFQ26S4kN87X
         goBzTfSZU0VEvOtGoM8RF3Nn6gBYHO18iuu7vXqs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shay Agroskin <shayagr@amazon.com>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 25/43] net: ena: Fix error handling when calculating max IO queues number
Date:   Mon, 10 Jan 2022 08:23:22 +0100
Message-Id: <20220110071818.195583561@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220110071817.337619922@linuxfoundation.org>
References: <20220110071817.337619922@linuxfoundation.org>
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
@@ -3927,10 +3927,6 @@ static u32 ena_calc_max_io_queue_num(str
 	max_num_io_queues = min_t(u32, max_num_io_queues, io_tx_cq_num);
 	/* 1 IRQ for for mgmnt and 1 IRQs for each IO direction */
 	max_num_io_queues = min_t(u32, max_num_io_queues, pci_msix_vec_count(pdev) - 1);
-	if (unlikely(!max_num_io_queues)) {
-		dev_err(&pdev->dev, "The device doesn't have io queues\n");
-		return -EFAULT;
-	}
 
 	return max_num_io_queues;
 }


