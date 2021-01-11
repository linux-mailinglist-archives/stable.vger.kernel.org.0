Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7412F2F179C
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 15:09:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729955AbhAKOId (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 09:08:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:50254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729904AbhAKNDf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:03:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7D59B22D08;
        Mon, 11 Jan 2021 13:03:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370192;
        bh=/baKpyauMrwoRkDSxTcryXp5Jvs4bjqPSZqSOJHSRxk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vdu+LJQI/EdNQVb1oz/G+jq/xuOBX2RITv1ngz4uSiu+EI0hdPR8eTo3VxfwWBb+A
         5XGbXJXk1c77HMqRXKrDOf8g692mq32wPWfevXfsCWHXfHu4g8ionqDhljWofEpblY
         iZcbRs7RSexgZ+TucnX+KofsYAagJqmYkdWD4BII=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.9 06/45] atm: idt77252: call pci_disable_device() on error path
Date:   Mon, 11 Jan 2021 14:00:44 +0100
Message-Id: <20210111130033.984053236@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130033.676306636@linuxfoundation.org>
References: <20210111130033.676306636@linuxfoundation.org>
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
@@ -3615,7 +3615,7 @@ static int idt77252_init_one(struct pci_
 
 	if ((err = dma_set_mask_and_coherent(&pcidev->dev, DMA_BIT_MASK(32)))) {
 		printk("idt77252: can't enable DMA for PCI device at %s\n", pci_name(pcidev));
-		return err;
+		goto err_out_disable_pdev;
 	}
 
 	card = kzalloc(sizeof(struct idt77252_dev), GFP_KERNEL);


