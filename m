Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8445579464
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 21:31:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728882AbfG2TbB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:31:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:43712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727655AbfG2TbB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:31:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A78D921655;
        Mon, 29 Jul 2019 19:30:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564428660;
        bh=tb6Wue0nMrY0wThjJWknmrt5Xv4PEKW57ycJTLp7c4w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nfk1pLnGyeBMk0jM0wBiiCn8hWnBYmx/KEcZahCUIFmCiRy0yPa0SH0F2B1VVbRzr
         qmvBiN3xNfSQa6nXf1tTi60yXTelrYBv4pYxzeSJpddr/SeE5XR+I9pPcT6f+9+tYo
         c3gM0ro8CZVnBCEX2d3mpGp69p1Rac4TdCp0aezE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 106/293] iavf: fix dereference of null rx_buffer pointer
Date:   Mon, 29 Jul 2019 21:19:57 +0200
Message-Id: <20190729190832.782080642@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190820.321094988@linuxfoundation.org>
References: <20190729190820.321094988@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 9fe06a51287b2d41baef7ece94df34b5abf19b90 ]

A recent commit efa14c3985828d ("iavf: allow null RX descriptors") added
a null pointer sanity check on rx_buffer, however, rx_buffer is being
dereferenced before that check, which implies a null pointer dereference
bug can potentially occur.  Fix this by only dereferencing rx_buffer
until after the null pointer check.

Addresses-Coverity: ("Dereference before null check")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40evf/i40e_txrx.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40evf/i40e_txrx.c b/drivers/net/ethernet/intel/i40evf/i40e_txrx.c
index 7368b0dc3af8..4afdabbe95e8 100644
--- a/drivers/net/ethernet/intel/i40evf/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40evf/i40e_txrx.c
@@ -1117,7 +1117,7 @@ static struct sk_buff *i40e_construct_skb(struct i40e_ring *rx_ring,
 					  struct i40e_rx_buffer *rx_buffer,
 					  unsigned int size)
 {
-	void *va = page_address(rx_buffer->page) + rx_buffer->page_offset;
+	void *va;
 #if (PAGE_SIZE < 8192)
 	unsigned int truesize = i40e_rx_pg_size(rx_ring) / 2;
 #else
@@ -1127,6 +1127,7 @@ static struct sk_buff *i40e_construct_skb(struct i40e_ring *rx_ring,
 	struct sk_buff *skb;
 
 	/* prefetch first cache line of first page */
+	va = page_address(rx_buffer->page) + rx_buffer->page_offset;
 	prefetch(va);
 #if L1_CACHE_BYTES < 128
 	prefetch(va + L1_CACHE_BYTES);
@@ -1181,7 +1182,7 @@ static struct sk_buff *i40e_build_skb(struct i40e_ring *rx_ring,
 				      struct i40e_rx_buffer *rx_buffer,
 				      unsigned int size)
 {
-	void *va = page_address(rx_buffer->page) + rx_buffer->page_offset;
+	void *va;
 #if (PAGE_SIZE < 8192)
 	unsigned int truesize = i40e_rx_pg_size(rx_ring) / 2;
 #else
@@ -1191,6 +1192,7 @@ static struct sk_buff *i40e_build_skb(struct i40e_ring *rx_ring,
 	struct sk_buff *skb;
 
 	/* prefetch first cache line of first page */
+	va = page_address(rx_buffer->page) + rx_buffer->page_offset;
 	prefetch(va);
 #if L1_CACHE_BYTES < 128
 	prefetch(va + L1_CACHE_BYTES);
-- 
2.20.1



