Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47F454A43A6
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:22:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377156AbiAaLWf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:22:35 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:52438 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378691AbiAaLUg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:20:36 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 469666114D;
        Mon, 31 Jan 2022 11:20:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50DB4C340E8;
        Mon, 31 Jan 2022 11:20:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643628032;
        bh=tB7JCLFXx3Iwrv0oV3/fnaCWjJ379uUPqtNDv1Sgty0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mw40r12mByCcdt/Bcbc3W0fMQGxNbjPuyOh/WmBCZIET4LRiK73dBPSAJPhq5WuJ/
         KhpshxWFs00s6ninkPOjVl+kQsfkHMYBJG59dsW5CFriWAydpGnUFksa7kGblRpX8z
         DGufEVbo3vUa7XO8xQ5lc2yHdyV++m0dlsNs3Mjg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        James Smart <jsmart2021@gmail.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.16 104/200] scsi: elx: efct: Dont use GFP_KERNEL under spin lock
Date:   Mon, 31 Jan 2022 11:56:07 +0100
Message-Id: <20220131105237.085540545@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105233.561926043@linuxfoundation.org>
References: <20220131105233.561926043@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

commit 61263b3a11a2594b4e898f166c31162236182b5c upstream.

GFP_KERNEL/GFP_DMA can't be used under a spin lock. According the comment,
els_ios_lock is used to protect els ios list so we can move down the spin
lock to avoid using this flag under the lock.

Link: https://lore.kernel.org/r/20220111012441.3232527-1-yangyingliang@huawei.com
Fixes: 8f406ef72859 ("scsi: elx: libefc: Extended link Service I/O handling")
Reported-by: Hulk Robot <hulkci@huawei.com>
Reviewed-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/elx/libefc/efc_els.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/drivers/scsi/elx/libefc/efc_els.c
+++ b/drivers/scsi/elx/libefc/efc_els.c
@@ -46,18 +46,14 @@ efc_els_io_alloc_size(struct efc_node *n
 
 	efc = node->efc;
 
-	spin_lock_irqsave(&node->els_ios_lock, flags);
-
 	if (!node->els_io_enabled) {
 		efc_log_err(efc, "els io alloc disabled\n");
-		spin_unlock_irqrestore(&node->els_ios_lock, flags);
 		return NULL;
 	}
 
 	els = mempool_alloc(efc->els_io_pool, GFP_ATOMIC);
 	if (!els) {
 		atomic_add_return(1, &efc->els_io_alloc_failed_count);
-		spin_unlock_irqrestore(&node->els_ios_lock, flags);
 		return NULL;
 	}
 
@@ -74,7 +70,6 @@ efc_els_io_alloc_size(struct efc_node *n
 					      &els->io.req.phys, GFP_DMA);
 	if (!els->io.req.virt) {
 		mempool_free(els, efc->els_io_pool);
-		spin_unlock_irqrestore(&node->els_ios_lock, flags);
 		return NULL;
 	}
 
@@ -94,10 +89,11 @@ efc_els_io_alloc_size(struct efc_node *n
 
 		/* add els structure to ELS IO list */
 		INIT_LIST_HEAD(&els->list_entry);
+		spin_lock_irqsave(&node->els_ios_lock, flags);
 		list_add_tail(&els->list_entry, &node->els_ios_list);
+		spin_unlock_irqrestore(&node->els_ios_lock, flags);
 	}
 
-	spin_unlock_irqrestore(&node->els_ios_lock, flags);
 	return els;
 }
 


