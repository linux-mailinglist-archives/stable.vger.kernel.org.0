Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E23249993E
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:44:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352038AbiAXVeQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:34:16 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:37066 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1448902AbiAXVOM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:14:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 563066148B;
        Mon, 24 Jan 2022 21:14:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CC6FC340E5;
        Mon, 24 Jan 2022 21:14:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058850;
        bh=br5AcrBFtY1joqdyAs9YGFFLMk3rYlCqyHCcz2VHz0k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZtJcfE6dLT5uXD0cobMhB6toFjtos9FGy5QwwlDcqwCBmRkAIdS3GvGSfQG82KjXG
         02yjf6iGlrcvHI5jOQPy1mccy6pwkBV5zv3Js41zv9LpOv6T0GupNfzIk2PkVlwRCN
         Ss5uUzvfcu3K1txT4YTsFIR4Tm9sIDdKsJfGxU30=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Subbaraya Sundeep <sbhatta@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0423/1039] octeontx2-af: Increment ptp refcount before use
Date:   Mon, 24 Jan 2022 19:36:52 +0100
Message-Id: <20220124184139.523946948@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Subbaraya Sundeep <sbhatta@marvell.com>

[ Upstream commit 93440f4888cf049dbd22b41aaf94d2e2153b3eb8 ]

Before using the ptp pci device by AF driver increment
the reference count of it.

Fixes: a8b90c9d26d6 ("octeontx2-af: Add PTP device id for CN10K and 95O silcons")
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/ptp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/ptp.c b/drivers/net/ethernet/marvell/octeontx2/af/ptp.c
index d6321de3cc171..e682b7bfde640 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/ptp.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/ptp.c
@@ -60,6 +60,8 @@ struct ptp *ptp_get(void)
 	/* Check driver is bound to PTP block */
 	if (!ptp)
 		ptp = ERR_PTR(-EPROBE_DEFER);
+	else
+		pci_dev_get(ptp->pdev);
 
 	return ptp;
 }
-- 
2.34.1



