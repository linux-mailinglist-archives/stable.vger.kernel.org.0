Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B7B6283ACE
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 17:37:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727440AbgJEPh3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 11:37:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:59480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727937AbgJEPcG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Oct 2020 11:32:06 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0BB1E206DD;
        Mon,  5 Oct 2020 15:32:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601911925;
        bh=wQCFzCdhjnD9ZKAePJ3HjzMMAumFLdPf43/b/FMorBU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b6oChiRyrW81DMZGCwo4SV8aEdm8eEyWWYlOPM6amOf9kW36qprXxBjIEJz/ziQ8Q
         ExblzHKNd58fDK7t4PjN6km9M5of6EVYEQE3dAy3Qzsg5tH+VEQ8BCzavjyidmJqNp
         69KF/lD78OKxNM9Q1epUj1h+CBPvBHuLmiCBqiIs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lucy Yan <lucyyan@google.com>,
        Moritz Fischer <mdf@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 32/85] net: dec: de2104x: Increase receive ring size for Tulip
Date:   Mon,  5 Oct 2020 17:26:28 +0200
Message-Id: <20201005142116.282144167@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201005142114.732094228@linuxfoundation.org>
References: <20201005142114.732094228@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lucy Yan <lucyyan@google.com>

[ Upstream commit ee460417d254d941dfea5fb7cff841f589643992 ]

Increase Rx ring size to address issue where hardware is reaching
the receive work limit.

Before:

[  102.223342] de2104x 0000:17:00.0 eth0: rx work limit reached
[  102.245695] de2104x 0000:17:00.0 eth0: rx work limit reached
[  102.251387] de2104x 0000:17:00.0 eth0: rx work limit reached
[  102.267444] de2104x 0000:17:00.0 eth0: rx work limit reached

Signed-off-by: Lucy Yan <lucyyan@google.com>
Reviewed-by: Moritz Fischer <mdf@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/dec/tulip/de2104x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/dec/tulip/de2104x.c b/drivers/net/ethernet/dec/tulip/de2104x.c
index 592454f444ce2..0b30011b9839e 100644
--- a/drivers/net/ethernet/dec/tulip/de2104x.c
+++ b/drivers/net/ethernet/dec/tulip/de2104x.c
@@ -85,7 +85,7 @@ MODULE_PARM_DESC (rx_copybreak, "de2104x Breakpoint at which Rx packets are copi
 #define DSL			CONFIG_DE2104X_DSL
 #endif
 
-#define DE_RX_RING_SIZE		64
+#define DE_RX_RING_SIZE		128
 #define DE_TX_RING_SIZE		64
 #define DE_RING_BYTES		\
 		((sizeof(struct de_desc) * DE_RX_RING_SIZE) +	\
-- 
2.25.1



