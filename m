Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C71E199213
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 11:23:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730428AbgCaJDa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 05:03:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:43238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730603AbgCaJDa (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 05:03:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 77AA9208E0;
        Tue, 31 Mar 2020 09:03:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585645409;
        bh=2vGgD4H5dto+NnkoP/8GmGv6oQW+1nr5MOXHsQ/uGgQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AdDA6UlWn96wI5SYsP9CCq9SD8DUN2g4kuSDB8DS61xxKm3tibNHX04LNPR01S/cY
         /Up5PuYbjw2HM4X8CR6AZ+93xu5MD/FaYboCm3KHRhmqshT3yTZcFt7n3UZ6qAqXTn
         rvnKsX8bqSDUv4ORaXW4t03cDgwNFzZurL5r1+3Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.5 045/170] bnxt_en: Free context memory after disabling PCI in probe error path.
Date:   Tue, 31 Mar 2020 10:57:39 +0200
Message-Id: <20200331085429.255371508@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200331085423.990189598@linuxfoundation.org>
References: <20200331085423.990189598@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Chan <michael.chan@broadcom.com>

[ Upstream commit 62bfb932a51f6d08eb409248e69f8d6428c2cabd ]

Other shutdown code paths will always disable PCI first to shutdown DMA
before freeing context memory.  Do the same sequence in the error path
of probe to be safe and consistent.

Fixes: c20dc142dd7b ("bnxt_en: Disable bus master during PCI shutdown and driver unload.")
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -11959,12 +11959,12 @@ init_err_pci_clean:
 	bnxt_hwrm_func_drv_unrgtr(bp);
 	bnxt_free_hwrm_short_cmd_req(bp);
 	bnxt_free_hwrm_resources(bp);
-	bnxt_free_ctx_mem(bp);
-	kfree(bp->ctx);
-	bp->ctx = NULL;
 	kfree(bp->fw_health);
 	bp->fw_health = NULL;
 	bnxt_cleanup_pci(bp);
+	bnxt_free_ctx_mem(bp);
+	kfree(bp->ctx);
+	bp->ctx = NULL;
 
 init_err_free:
 	free_netdev(dev);


