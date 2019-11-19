Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21A181016E4
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:57:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731302AbfKSFwF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:52:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:49688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730634AbfKSFwE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:52:04 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BE54B214D9;
        Tue, 19 Nov 2019 05:52:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574142723;
        bh=0V0ylmDejaYia5CRLo0lS05lj+Q0a8zKivPVI6lYOYA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uelFJmv3Y/KElNgqzNXbSZC6vx5xcVv/ORa1JM6G5HpCPwBcqX5qE6WyKz6NFLcci
         png+d47DybrWbhYABaLEJ0DICp6q1HCBRrWp3G2RSossEyPr3ijqH3W3yh/z+qlNrL
         AG1zleFgGnKUYAFBoG6rbkEqLIAFC6E4vgPJ4YE4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jia-Ju Bai <baijiaju1990@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 179/239] media: pci: ivtv: Fix a sleep-in-atomic-context bug in ivtv_yuv_init()
Date:   Tue, 19 Nov 2019 06:19:39 +0100
Message-Id: <20191119051334.507452836@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051255.850204959@linuxfoundation.org>
References: <20191119051255.850204959@linuxfoundation.org>
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
index 44936d6d7c396..1380474519f2b 100644
--- a/drivers/media/pci/ivtv/ivtv-yuv.c
+++ b/drivers/media/pci/ivtv/ivtv-yuv.c
@@ -935,7 +935,7 @@ static void ivtv_yuv_init(struct ivtv *itv)
 	}
 
 	/* We need a buffer for blanking when Y plane is offset - non-fatal if we can't get one */
-	yi->blanking_ptr = kzalloc(720 * 16, GFP_KERNEL|__GFP_NOWARN);
+	yi->blanking_ptr = kzalloc(720 * 16, GFP_ATOMIC|__GFP_NOWARN);
 	if (yi->blanking_ptr) {
 		yi->blanking_dmaptr = pci_map_single(itv->pdev, yi->blanking_ptr, 720*16, PCI_DMA_TODEVICE);
 	} else {
-- 
2.20.1



