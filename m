Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD2FD13317A
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 22:01:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728500AbgAGVBL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 16:01:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:37936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727841AbgAGVBK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 16:01:10 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 681A621744;
        Tue,  7 Jan 2020 21:01:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578430869;
        bh=z13CnoUeWhmZSS2tZYusASTt+xbcYV1m6+PgX0H3/Ok=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cbVFpaBjlNBZ2zb4UwVcluMdUn9gAXidEIaEQKHRAWlimy9dRuzTDn+RvcKGr+v4b
         iFQV/BQRr8H7HppnP0NfXVsQNMp/H1OUPlqYhXO1YTCw3C+NtoJ3RhS/dv44HEhp7d
         QVwgOWt83Rww1SISmLhiksOjiYo29/I95jL4MO2c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.4 123/191] dmaengine: virt-dma: Fix access after free in vchan_complete()
Date:   Tue,  7 Jan 2020 21:54:03 +0100
Message-Id: <20200107205339.563984538@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205332.984228665@linuxfoundation.org>
References: <20200107205332.984228665@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Ujfalusi <peter.ujfalusi@ti.com>

commit 24461d9792c2c706092805ff1b067628933441bd upstream.

vchan_vdesc_fini() is freeing up 'vd' so the access to vd->tx_result is
via already freed up memory.

Move the vchan_vdesc_fini() after invoking the callback to avoid this.

Fixes: 09d5b702b0f97 ("dmaengine: virt-dma: store result on dma descriptor")
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Reviewed-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
Link: https://lore.kernel.org/r/20191220131100.21804-1-peter.ujfalusi@ti.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/dma/virt-dma.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/dma/virt-dma.c
+++ b/drivers/dma/virt-dma.c
@@ -104,9 +104,8 @@ static void vchan_complete(unsigned long
 		dmaengine_desc_get_callback(&vd->tx, &cb);
 
 		list_del(&vd->node);
-		vchan_vdesc_fini(vd);
-
 		dmaengine_desc_callback_invoke(&cb, &vd->tx_result);
+		vchan_vdesc_fini(vd);
 	}
 }
 


