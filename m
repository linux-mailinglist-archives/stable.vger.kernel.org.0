Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B035D10BC0A
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:18:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731160AbfK0VMG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:12:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:42078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733257AbfK0VMF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 16:12:05 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA7F521845;
        Wed, 27 Nov 2019 21:12:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574889125;
        bh=dH0C3TLUdquRRSK09HP8uOlvs+JuimrpXUVJ+N3nNl0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M/LUqGmkY+WCAMGdv9hDyO/acWhh+0t4vJnkgnYHVHmk1orzTErSDMDiQhd2+V8XQ
         hej8q1lQrG57oo26VxwdVeU3hRCvlhnXtpKrsVG3tPv4mEcpl3ORP3SCc+d8NCEZtX
         WTznko4svI0qNQfAKsKYHEXR5eozegZHQqUj4F3g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adi Suresh <adisuresh@google.com>,
        Catherine Sullivan <csully@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.3 50/95] gve: fix dma sync bug where not all pages synced
Date:   Wed, 27 Nov 2019 21:32:07 +0100
Message-Id: <20191127202916.306351502@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127202845.651587549@linuxfoundation.org>
References: <20191127202845.651587549@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adi Suresh <adisuresh@google.com>

commit db96c2cb4870173ea9b08df130f1d1cc9b5dd53d upstream.

The previous commit had a bug where the last page in the memory range
could not be synced. This change fixes the behavior so that all the
required pages are synced.

Fixes: 9cfeeb576d49 ("gve: Fixes DMA synchronization")
Signed-off-by: Adi Suresh <adisuresh@google.com>
Reviewed-by: Catherine Sullivan <csully@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/google/gve/gve_tx.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/net/ethernet/google/gve/gve_tx.c
+++ b/drivers/net/ethernet/google/gve/gve_tx.c
@@ -393,12 +393,13 @@ static void gve_tx_fill_seg_desc(union g
 static void gve_dma_sync_for_device(struct device *dev, dma_addr_t *page_buses,
 				    u64 iov_offset, u64 iov_len)
 {
+	u64 last_page = (iov_offset + iov_len - 1) / PAGE_SIZE;
+	u64 first_page = iov_offset / PAGE_SIZE;
 	dma_addr_t dma;
-	u64 addr;
+	u64 page;
 
-	for (addr = iov_offset; addr < iov_offset + iov_len;
-	     addr += PAGE_SIZE) {
-		dma = page_buses[addr / PAGE_SIZE];
+	for (page = first_page; page <= last_page; page++) {
+		dma = page_buses[page];
 		dma_sync_single_for_device(dev, dma, PAGE_SIZE, DMA_TO_DEVICE);
 	}
 }


