Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2721E147B1D
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 10:42:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731051AbgAXJk7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 04:40:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:38368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732654AbgAXJk5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 04:40:57 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 863F920718;
        Fri, 24 Jan 2020 09:40:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579858856;
        bh=yUnc2YeJOHkI3QdEe+20GyGweQc1ZTTNkFIkcuElrP4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gBR6qNTG/UBP8qhVTLjOdp8RHD9cMXlzyKvn72CcaEmc429VKQda0vuIXc1YM78/L
         Rp7qwc9YXHIjuq1lFw4un9yaTs/eWnqktaa1+5+DpFQ1sP5sXBVmXoHOJ74V+Znlk4
         Dft/+A4tA2WjtkFW6PBORQyLpvPeH9cZLK59mLvU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 5.4 049/102] rtw88: fix beaconing mode rsvd_page memory violation issue
Date:   Fri, 24 Jan 2020 10:30:50 +0100
Message-Id: <20200124092813.712359521@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092806.004582306@linuxfoundation.org>
References: <20200124092806.004582306@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

commit c3594559f49c601d410dee4b767c3536a5535bfd upstream.

When downloading the reserved page, the first page always contains
a beacon for the firmware to reference. For non-beaconing modes such
as station mode, also put a blank skb with length=1.

And for the beaconing modes, driver will get a real beacon with a
length approximate to the page size. But as the beacon is always put
at the first page, it does not need a tx_desc, because the TX path
will generate one when TXing the reserved page to the hardware. So we
could allocate a buffer with a size smaller than the reserved page,
when using memcpy() to copy the content of reserved page to the buffer,
the over-sized reserved page will violate the kernel memory.

To fix it, add the tx_desc before memcpy() the reserved packets to
the buffer, then we can get SKBs with correct length when counting
the pages in total. And for page 0, count the extra tx_desc_sz that
the TX path will generate. This way, the first beacon that allocated
without tx_desc can be counted with the extra tx_desc_sz to get
actual pages it requires.

Fixes: e3037485c68e ("rtw88: new Realtek 802.11ac driver")
Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/realtek/rtw88/fw.c |   52 ++++++++++++++++++++++++++------
 1 file changed, 43 insertions(+), 9 deletions(-)

--- a/drivers/net/wireless/realtek/rtw88/fw.c
+++ b/drivers/net/wireless/realtek/rtw88/fw.c
@@ -498,9 +498,6 @@ static void rtw_rsvd_page_list_to_buf(st
 {
 	struct sk_buff *skb = rsvd_pkt->skb;
 
-	if (rsvd_pkt->add_txdesc)
-		rtw_fill_rsvd_page_desc(rtwdev, skb);
-
 	if (page >= 1)
 		memcpy(buf + page_margin + page_size * (page - 1),
 		       skb->data, skb->len);
@@ -625,16 +622,37 @@ static u8 *rtw_build_rsvd_page(struct rt
 	list_for_each_entry(rsvd_pkt, &rtwdev->rsvd_page_list, list) {
 		iter = rtw_get_rsvd_page_skb(hw, vif, rsvd_pkt->type);
 		if (!iter) {
-			rtw_err(rtwdev, "fail to build rsvd packet\n");
+			rtw_err(rtwdev, "failed to build rsvd packet\n");
 			goto release_skb;
 		}
+
+		/* Fill the tx_desc for the rsvd pkt that requires one.
+		 * And iter->len will be added with size of tx_desc_sz.
+		 */
+		if (rsvd_pkt->add_txdesc)
+			rtw_fill_rsvd_page_desc(rtwdev, iter);
+
 		rsvd_pkt->skb = iter;
 		rsvd_pkt->page = total_page;
-		if (rsvd_pkt->add_txdesc)
+
+		/* Reserved page is downloaded via TX path, and TX path will
+		 * generate a tx_desc at the header to describe length of
+		 * the buffer. If we are not counting page numbers with the
+		 * size of tx_desc added at the first rsvd_pkt (usually a
+		 * beacon, firmware default refer to the first page as the
+		 * content of beacon), we could generate a buffer which size
+		 * is smaller than the actual size of the whole rsvd_page
+		 */
+		if (total_page == 0) {
+			if (rsvd_pkt->type != RSVD_BEACON) {
+				rtw_err(rtwdev, "first page should be a beacon\n");
+				goto release_skb;
+			}
 			total_page += rtw_len_to_page(iter->len + tx_desc_sz,
 						      page_size);
-		else
+		} else {
 			total_page += rtw_len_to_page(iter->len, page_size);
+		}
 	}
 
 	if (total_page > rtwdev->fifo.rsvd_drv_pg_num) {
@@ -647,13 +665,24 @@ static u8 *rtw_build_rsvd_page(struct rt
 	if (!buf)
 		goto release_skb;
 
+	/* Copy the content of each rsvd_pkt to the buf, and they should
+	 * be aligned to the pages.
+	 *
+	 * Note that the first rsvd_pkt is a beacon no matter what vif->type.
+	 * And that rsvd_pkt does not require tx_desc because when it goes
+	 * through TX path, the TX path will generate one for it.
+	 */
 	list_for_each_entry(rsvd_pkt, &rtwdev->rsvd_page_list, list) {
 		rtw_rsvd_page_list_to_buf(rtwdev, page_size, page_margin,
 					  page, buf, rsvd_pkt);
-		page += rtw_len_to_page(rsvd_pkt->skb->len, page_size);
-	}
-	list_for_each_entry(rsvd_pkt, &rtwdev->rsvd_page_list, list)
+		if (page == 0)
+			page += rtw_len_to_page(rsvd_pkt->skb->len +
+						tx_desc_sz, page_size);
+		else
+			page += rtw_len_to_page(rsvd_pkt->skb->len, page_size);
+
 		kfree_skb(rsvd_pkt->skb);
+	}
 
 	return buf;
 
@@ -706,6 +735,11 @@ int rtw_fw_download_rsvd_page(struct rtw
 		goto free;
 	}
 
+	/* The last thing is to download the *ONLY* beacon again, because
+	 * the previous tx_desc is to describe the total rsvd page. Download
+	 * the beacon again to replace the TX desc header, and we will get
+	 * a correct tx_desc for the beacon in the rsvd page.
+	 */
 	ret = rtw_download_beacon(rtwdev, vif);
 	if (ret) {
 		rtw_err(rtwdev, "failed to download beacon\n");


