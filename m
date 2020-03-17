Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01507187FCE
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 12:04:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726272AbgCQLEp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 07:04:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:45038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727940AbgCQLEk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 07:04:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A80EA20736;
        Tue, 17 Mar 2020 11:04:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584443080;
        bh=9NoQVqoZS1Vz2ny1kBlQ6fnhup0i0q5dtmWUnuZaFbA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lCCrKGMhOhLx20RIRGgpmWrYklPvqe7IBPLda/hSWfr51VBpqT8GhGfSZk5VmKT/v
         52jX1lBYSVsZ924s1B/8Bqf4K/H2iz7ip5WBcX4UpCMZELuA6wsYGiGKP3SZy2TdnU
         CDHYzGICrMfxAf0o7YyRkGENMZ+Cep5SQw3CJNcA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 5.4 090/123] mt76: fix array overflow on receiving too many fragments for a packet
Date:   Tue, 17 Mar 2020 11:55:17 +0100
Message-Id: <20200317103316.934745037@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200317103307.343627747@linuxfoundation.org>
References: <20200317103307.343627747@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

commit b102f0c522cf668c8382c56a4f771b37d011cda2 upstream.

If the hardware receives an oversized packet with too many rx fragments,
skb_shinfo(skb)->frags can overflow and corrupt memory of adjacent pages.
This becomes especially visible if it corrupts the freelist pointer of
a slab page.

Cc: stable@vger.kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/mediatek/mt76/dma.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/net/wireless/mediatek/mt76/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/dma.c
@@ -448,10 +448,13 @@ mt76_add_fragment(struct mt76_dev *dev,
 	struct page *page = virt_to_head_page(data);
 	int offset = data - page_address(page);
 	struct sk_buff *skb = q->rx_head;
+	struct skb_shared_info *shinfo = skb_shinfo(skb);
 
-	offset += q->buf_offset;
-	skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags, page, offset, len,
-			q->buf_size);
+	if (shinfo->nr_frags < ARRAY_SIZE(shinfo->frags)) {
+		offset += q->buf_offset;
+		skb_add_rx_frag(skb, shinfo->nr_frags, page, offset, len,
+				q->buf_size);
+	}
 
 	if (more)
 		return;


