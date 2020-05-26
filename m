Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 726111E2D83
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:24:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392462AbgEZTVM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 15:21:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:41604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391545AbgEZTME (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 15:12:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 91EAA208B3;
        Tue, 26 May 2020 19:12:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590520324;
        bh=rFk4ndRXik1qE5fwJ3x+1OM2AUjpwZLqi+jCYlMawr8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yHeG3Mn51OlqOzLp3W/AQUKD+SA35IKZnnG65NbtAiOkD8HWdAuqCGHKD2RxNuppF
         Gp2nQW6aAHnWCuqkTnthLt3QR3+dxb2mjC+nLEYuAs3M3g078P4i9IiZMLq5/QDsRo
         2fbGXOEfTBn7PGt66fIWWQTe7IyfLpZMF7VrYCOw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gavin Shan <gshan@redhat.com>,
        Shay Agroskin <shayagr@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 035/126] net/ena: Fix build warning in ena_xdp_set()
Date:   Tue, 26 May 2020 20:52:52 +0200
Message-Id: <20200526183940.822041433@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183937.471379031@linuxfoundation.org>
References: <20200526183937.471379031@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gavin Shan <gshan@redhat.com>

[ Upstream commit caec66198d137c26f0d234abc498866a58c64150 ]

This fixes the following build warning in ena_xdp_set(), which is
observed on aarch64 with 64KB page size.

   In file included from ./include/net/inet_sock.h:19,
      from ./include/net/ip.h:27,
      from drivers/net/ethernet/amazon/ena/ena_netdev.c:46:
   drivers/net/ethernet/amazon/ena/ena_netdev.c: In function         \
   ‘ena_xdp_set’:                                                    \
   drivers/net/ethernet/amazon/ena/ena_netdev.c:557:6: warning:      \
   format ‘%lu’                                                      \
   expects argument of type ‘long unsigned int’, but argument 4      \
   has type ‘int’                                                    \
   [-Wformat=] "Failed to set xdp program, the current MTU (%d) is   \
   larger than the maximum allowed MTU (%lu) while xdp is on",

Signed-off-by: Gavin Shan <gshan@redhat.com>
Acked-by: Shay Agroskin <shayagr@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.h b/drivers/net/ethernet/amazon/ena/ena_netdev.h
index 8795e0b1dc3c..8984aa211112 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.h
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.h
@@ -69,7 +69,7 @@
  * 16kB.
  */
 #if PAGE_SIZE > SZ_16K
-#define ENA_PAGE_SIZE SZ_16K
+#define ENA_PAGE_SIZE (_AC(SZ_16K, UL))
 #else
 #define ENA_PAGE_SIZE PAGE_SIZE
 #endif
-- 
2.25.1



