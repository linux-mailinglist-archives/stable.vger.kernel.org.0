Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FBE2F634E
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 03:51:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729960AbfKJCvX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Nov 2019 21:51:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:35854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729959AbfKJCvW (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Nov 2019 21:51:22 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 31EAE22790;
        Sun, 10 Nov 2019 02:51:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573354282;
        bh=MiXJ9nE9BIca3R0PMQHYhfA4j1O4nqbXbnRC6oW2A5c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IajOO6HqWicJ2bS4x+EMjFvodbd9xvRRUF1wz2o2iBuiQTwVCEgGNYljf6x5hDNB1
         49lOuDJSf1fKRjHST6MxtFUBcu0qO5xZx4nMl3gZ5v4KSJhIUQoyG1uF3IPUXtJHyj
         Aa9xovtvMVhJ0d+V6sIZmzn+mzQHbvaYWu6M2lA4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jia-Ju Bai <baijiaju1990@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 24/40] media: pci: ivtv: Fix a sleep-in-atomic-context bug in ivtv_yuv_init()
Date:   Sat,  9 Nov 2019 21:50:16 -0500
Message-Id: <20191110025032.827-24-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110025032.827-1-sashal@kernel.org>
References: <20191110025032.827-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

