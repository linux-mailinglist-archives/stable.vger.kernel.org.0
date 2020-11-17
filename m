Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 990DB2B6517
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:54:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731851AbgKQNa0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:30:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:39450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730960AbgKQNaW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:30:22 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA3B520867;
        Tue, 17 Nov 2020 13:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605619822;
        bh=QWC6TFlGCmkC0dUBM9p+EI4xQbqmy9zPMCVefHKXA0o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M+qnN/SSuPDL2ysRzjusB1qVi7/eSNypS8UXm3zLeE1M3CZavdRUdzh/VVkkWQk/l
         MmoWyc5x/iaASQlZasmAFdbHvbLh9N4nGqU2g+K/b5Tanjnwfeb6pWilgcKE5rERqH
         gtWIYnhDoHUkngrIrMRRk3kBAQCGyVRC3BLFEbac=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Chen <peter.chen@nxp.com>,
        Ran Wang <ran.wang_1@nxp.com>, Felipe Balbi <balbi@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 016/255] usb: gadget: fsl: fix null pointer checking
Date:   Tue, 17 Nov 2020 14:02:36 +0100
Message-Id: <20201117122139.733445682@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ran Wang <ran.wang_1@nxp.com>

[ Upstream commit 48e7bbbbb261b007fe78aa14ae62df01d236497e ]

fsl_ep_fifo_status() should return error if _ep->desc is null.

Fixes: 75eaa498c99e (“usb: gadget: Correct NULL pointer checking in fsl gadget”)
Reviewed-by: Peter Chen <peter.chen@nxp.com>
Signed-off-by: Ran Wang <ran.wang_1@nxp.com>
Signed-off-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/udc/fsl_udc_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/udc/fsl_udc_core.c b/drivers/usb/gadget/udc/fsl_udc_core.c
index a6f7b2594c090..c0cb007b749ff 100644
--- a/drivers/usb/gadget/udc/fsl_udc_core.c
+++ b/drivers/usb/gadget/udc/fsl_udc_core.c
@@ -1051,7 +1051,7 @@ static int fsl_ep_fifo_status(struct usb_ep *_ep)
 	u32 bitmask;
 	struct ep_queue_head *qh;
 
-	if (!_ep || _ep->desc || !(_ep->desc->bEndpointAddress&0xF))
+	if (!_ep || !_ep->desc || !(_ep->desc->bEndpointAddress&0xF))
 		return -ENODEV;
 
 	ep = container_of(_ep, struct fsl_ep, ep);
-- 
2.27.0



