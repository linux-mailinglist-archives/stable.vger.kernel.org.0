Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1163E29C091
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:18:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1818034AbgJ0RQ7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 13:16:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:56082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1771581AbgJ0Oz3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:55:29 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5593B222EA;
        Tue, 27 Oct 2020 14:55:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810527;
        bh=SLhEyF3hgDlogsJ6Uca8qPk92jkYmsXIc7BMuHkNdsI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZScKkKelBU8AAPvp6T/EMYQXWQecjTbaEdgolO/atuk+6I220oSF+DBiTYleKe1dN
         QpfXVq/qvCfqC4MzDMlYjJGs+s0nO9vOS2t1bQQl2Cc0YKOu85UCNAKCSAqbpXd2t/
         FgseyybHleXCAbUdE796MbmsAolJ0PIlPoUC//0s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 170/633] staging: rtl8192u: Do not use GFP_KERNEL in atomic context
Date:   Tue, 27 Oct 2020 14:48:33 +0100
Message-Id: <20201027135530.647714740@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit acac75bb451fd39344eb54fad6602dfc9482e970 ]

'rtl8192_irq_rx_tasklet()' is a tasklet initialized in
'rtl8192_init_priv_task()'.
>From this function it is possible to allocate some memory with the
GFP_KERNEL flag, which is not allowed in the atomic context of a tasklet.

Use GFP_ATOMIC instead.

The call chain is:
  rtl8192_irq_rx_tasklet            (in r8192U_core.c)
    --> rtl8192_rx_nomal            (in r8192U_core.c)
      --> ieee80211_rx              (in ieee80211/ieee80211_rx.c)
        --> RxReorderIndicatePacket (in ieee80211/ieee80211_rx.c)

Fixes: 79a5ccd97209 ("staging: rtl8192u: fix large frame size compiler warning")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://lore.kernel.org/r/20200813173458.758284-1-christophe.jaillet@wanadoo.fr
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c
index 195d963c4fbb4..b6fee7230ce05 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c
@@ -597,7 +597,7 @@ static void RxReorderIndicatePacket(struct ieee80211_device *ieee,
 
 	prxbIndicateArray = kmalloc_array(REORDER_WIN_SIZE,
 					  sizeof(struct ieee80211_rxb *),
-					  GFP_KERNEL);
+					  GFP_ATOMIC);
 	if (!prxbIndicateArray)
 		return;
 
-- 
2.25.1



