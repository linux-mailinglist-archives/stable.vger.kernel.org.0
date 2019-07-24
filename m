Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72AE773AC8
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 21:54:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404216AbfGXTxp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:53:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:36316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387831AbfGXTxo (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:53:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8BEAA22ADA;
        Wed, 24 Jul 2019 19:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563998024;
        bh=59DPuCb/mN6v6DZt/5oquLDKWXIFy+bD+4goqxHYoSw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p1Au8/5SeUNUlaNNDPgTi/DGNy7AeDGobsbsH0N/E4EEiHhbjSaRetpNtMQh3rQI/
         dFUSVKOolOxnkDpPJ0NVEESzW5FwSGusDauhqI4e1/Pt+aJrsNFu/eCVpd73HYyckk
         kvPY2WPuGdB5Ou+gSd20i3uxNQz2+Nac7zXRWV8I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 221/371] iavf: fix dereference of null rx_buffer pointer
Date:   Wed, 24 Jul 2019 21:19:33 +0200
Message-Id: <20190724191741.178168684@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191724.382593077@linuxfoundation.org>
References: <20190724191724.382593077@linuxfoundation.org>
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
 drivers/net/ethernet/intel/iavf/iavf_txrx.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_txrx.c b/drivers/net/ethernet/intel/iavf/iavf_txrx.c
index 9cc2a617c9f3..2a261d849d5a 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_txrx.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_txrx.c
@@ -1296,7 +1296,7 @@ static struct sk_buff *iavf_construct_skb(struct iavf_ring *rx_ring,
 					  struct iavf_rx_buffer *rx_buffer,
 					  unsigned int size)
 {
-	void *va = page_address(rx_buffer->page) + rx_buffer->page_offset;
+	void *va;
 #if (PAGE_SIZE < 8192)
 	unsigned int truesize = iavf_rx_pg_size(rx_ring) / 2;
 #else
@@ -1308,6 +1308,7 @@ static struct sk_buff *iavf_construct_skb(struct iavf_ring *rx_ring,
 	if (!rx_buffer)
 		return NULL;
 	/* prefetch first cache line of first page */
+	va = page_address(rx_buffer->page) + rx_buffer->page_offset;
 	prefetch(va);
 #if L1_CACHE_BYTES < 128
 	prefetch(va + L1_CACHE_BYTES);
@@ -1362,7 +1363,7 @@ static struct sk_buff *iavf_build_skb(struct iavf_ring *rx_ring,
 				      struct iavf_rx_buffer *rx_buffer,
 				      unsigned int size)
 {
-	void *va = page_address(rx_buffer->page) + rx_buffer->page_offset;
+	void *va;
 #if (PAGE_SIZE < 8192)
 	unsigned int truesize = iavf_rx_pg_size(rx_ring) / 2;
 #else
@@ -1374,6 +1375,7 @@ static struct sk_buff *iavf_build_skb(struct iavf_ring *rx_ring,
 	if (!rx_buffer)
 		return NULL;
 	/* prefetch first cache line of first page */
+	va = page_address(rx_buffer->page) + rx_buffer->page_offset;
 	prefetch(va);
 #if L1_CACHE_BYTES < 128
 	prefetch(va + L1_CACHE_BYTES);
-- 
2.20.1



