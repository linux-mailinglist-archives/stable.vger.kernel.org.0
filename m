Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAD8A14B966
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:33:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727369AbgA1ObY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:31:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:55862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387440AbgA1O17 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:27:59 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4BD3721739;
        Tue, 28 Jan 2020 14:27:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580221677;
        bh=Y/HWBZEFvdTGW6XNFPNxL6VXarzoQPnz8xuwDjlImvA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K8HP1Gg5Ao4tKp5O9vn1JM16C92W2Z6raBp4CB9BqwQIfaDXkSfG4O6GTCAR57MEn
         p/WDBFGxK7T+l9miWu4dpltjO9VYwumk2qh6MvVCCYE7hrL4Ct5Ue5gP57ZJgMKMen
         +1JnU/ViycVVMszLdpKrrF6XwNmrvXE30YD23LYA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stan Johnson <userm57@yahoo.com>,
        Finn Thain <fthain@telegraphics.com.au>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 46/92] net/sonic: Use MMIO accessors
Date:   Tue, 28 Jan 2020 15:08:14 +0100
Message-Id: <20200128135814.994516357@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135809.344954797@linuxfoundation.org>
References: <20200128135809.344954797@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Finn Thain <fthain@telegraphics.com.au>

commit e3885f576196ddfc670b3d53e745de96ffcb49ab upstream.

The driver accesses descriptor memory which is simultaneously accessed by
the chip, so the compiler must not be allowed to re-order CPU accesses.
sonic_buf_get() used 'volatile' to prevent that. sonic_buf_put() should
have done so too but was overlooked.

Fixes: efcce839360f ("[PATCH] macsonic/jazzsonic network drivers update")
Tested-by: Stan Johnson <userm57@yahoo.com>
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/natsemi/sonic.h |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/drivers/net/ethernet/natsemi/sonic.h
+++ b/drivers/net/ethernet/natsemi/sonic.h
@@ -345,30 +345,30 @@ static void sonic_msg_init(struct net_de
    as far as we can tell. */
 /* OpenBSD calls this "SWO".  I'd like to think that sonic_buf_put()
    is a much better name. */
-static inline void sonic_buf_put(void* base, int bitmode,
+static inline void sonic_buf_put(u16 *base, int bitmode,
 				 int offset, __u16 val)
 {
 	if (bitmode)
 #ifdef __BIG_ENDIAN
-		((__u16 *) base + (offset*2))[1] = val;
+		__raw_writew(val, base + (offset * 2) + 1);
 #else
-		((__u16 *) base + (offset*2))[0] = val;
+		__raw_writew(val, base + (offset * 2) + 0);
 #endif
 	else
-	 	((__u16 *) base)[offset] = val;
+		__raw_writew(val, base + (offset * 1) + 0);
 }
 
-static inline __u16 sonic_buf_get(void* base, int bitmode,
+static inline __u16 sonic_buf_get(u16 *base, int bitmode,
 				  int offset)
 {
 	if (bitmode)
 #ifdef __BIG_ENDIAN
-		return ((volatile __u16 *) base + (offset*2))[1];
+		return __raw_readw(base + (offset * 2) + 1);
 #else
-		return ((volatile __u16 *) base + (offset*2))[0];
+		return __raw_readw(base + (offset * 2) + 0);
 #endif
 	else
-		return ((volatile __u16 *) base)[offset];
+		return __raw_readw(base + (offset * 1) + 0);
 }
 
 /* Inlines that you should actually use for reading/writing DMA buffers */


