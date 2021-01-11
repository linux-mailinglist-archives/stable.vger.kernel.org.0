Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC3072F15F4
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:47:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730774AbhAKNqw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:46:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:57836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731241AbhAKNKm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:10:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 82A6C22BE9;
        Mon, 11 Jan 2021 13:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370602;
        bh=EAhWSQkXW63VL3rG5c2uB4CZNDm/2e+GJaZ6dJ8vEnA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G/ptOHtUXMWhGAyBllgkD0V5BScGPD7nq9UfuvFUqZK+PzScbZBVOMoTgaQ5+H3s1
         eneCw5wNm+O3dXueS3tFirz+yAXyUZglY8EiSF3B4iVQEGVs/QLeQ4Ur2da/prKhZt
         +ci9uOYrbXJxKOH6WM9ajlvqFsFr8uyjaVVmEGQk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 17/92] atm: idt77252: call pci_disable_device() on error path
Date:   Mon, 11 Jan 2021 14:01:21 +0100
Message-Id: <20210111130039.995280118@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130039.165470698@linuxfoundation.org>
References: <20210111130039.165470698@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 8df66af5c1e5f80562fe728db5ec069b21810144 ]

This error path needs to disable the pci device before returning.

Fixes: ede58ef28e10 ("atm: remove deprecated use of pci api")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lore.kernel.org/r/X93dmC4NX0vbTpGp@mwanda
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/atm/idt77252.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/atm/idt77252.c
+++ b/drivers/atm/idt77252.c
@@ -3606,7 +3606,7 @@ static int idt77252_init_one(struct pci_
 
 	if ((err = dma_set_mask_and_coherent(&pcidev->dev, DMA_BIT_MASK(32)))) {
 		printk("idt77252: can't enable DMA for PCI device at %s\n", pci_name(pcidev));
-		return err;
+		goto err_out_disable_pdev;
 	}
 
 	card = kzalloc(sizeof(struct idt77252_dev), GFP_KERNEL);


