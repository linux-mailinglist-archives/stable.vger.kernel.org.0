Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 222F3106AA4
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 11:36:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727413AbfKVKgk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:36:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:36650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728407AbfKVKgj (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:36:39 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1D64E20840;
        Fri, 22 Nov 2019 10:36:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574418998;
        bh=MiXJ9nE9BIca3R0PMQHYhfA4j1O4nqbXbnRC6oW2A5c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zw0/KnVzGxTEQF+5ZubSVS9EvSYDmgPJAaXSrTu8uTzIOUE3F3WOEflynGDIf/6aS
         iQHdrk0O6MzPBN9egZeMnTJLqXNGM+pGCqU62S0cENJsCgRKM5H8ooOG/FaPSySiww
         KWqyeB8QyvPg3JJOpv596QzXte/H2R9DmPaduM2A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jia-Ju Bai <baijiaju1990@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 079/159] media: pci: ivtv: Fix a sleep-in-atomic-context bug in ivtv_yuv_init()
Date:   Fri, 22 Nov 2019 11:27:50 +0100
Message-Id: <20191122100802.872464557@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100704.194776704@linuxfoundation.org>
References: <20191122100704.194776704@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jia-Ju Bai <baijiaju1990@gmail.com>

[ Upstream commit 8d11eb847de7d89c2754988c944d51a4f63e219b ]

The driver may sleep in a interrupt handler.

The function call paths (from bottom to top) in Linux-4.16 are:

[FUNC] kzalloc(GFP_KERNEL)
drivers/media/pci/ivtv/ivtv-yuv.c, 938:
	kzalloc in ivtv_yuv_init
drivers/media/pci/ivtv/ivtv-yuv.c, 960:
	ivtv_yuv_init in ivtv_yuv_next_free
drivers/media/pci/ivtv/ivtv-yuv.c, 1126:
	ivtv_yuv_next_free in ivtv_yuv_setup_stream_frame
drivers/media/pci/ivtv/ivtv-irq.c, 827:
	ivtv_yuv_setup_stream_frame in ivtv_irq_dec_data_req
drivers/media/pci/ivtv/ivtv-irq.c, 1013:
	ivtv_irq_dec_data_req in ivtv_irq_handler

To fix this bug, GFP_KERNEL is replaced with GFP_ATOMIC.

This bug is found by my static analysis tool DSAC.

Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/ivtv/ivtv-yuv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/ivtv/ivtv-yuv.c b/drivers/media/pci/ivtv/ivtv-yuv.c
index 9cd995f418e0f..1d67407ffbf62 100644
--- a/drivers/media/pci/ivtv/ivtv-yuv.c
+++ b/drivers/media/pci/ivtv/ivtv-yuv.c
@@ -936,7 +936,7 @@ static void ivtv_yuv_init(struct ivtv *itv)
 	}
 
 	/* We need a buffer for blanking when Y plane is offset - non-fatal if we can't get one */
-	yi->blanking_ptr = kzalloc(720 * 16, GFP_KERNEL|__GFP_NOWARN);
+	yi->blanking_ptr = kzalloc(720 * 16, GFP_ATOMIC|__GFP_NOWARN);
 	if (yi->blanking_ptr) {
 		yi->blanking_dmaptr = pci_map_single(itv->pdev, yi->blanking_ptr, 720*16, PCI_DMA_TODEVICE);
 	} else {
-- 
2.20.1



