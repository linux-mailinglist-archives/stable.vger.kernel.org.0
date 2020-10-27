Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBB4129C4B0
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 19:07:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1823005AbgJ0R4p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 13:56:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:46082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2895154AbgJ0OVn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:21:43 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C0D56206FA;
        Tue, 27 Oct 2020 14:21:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603808503;
        bh=I1H2B+rxmdy3Cb5TaHHdUkYZqaruyRjqeqtWmvaVEAE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iM5B3rYWGU9EZNEqYrzRuSMvKu2MNbnflOnGxs2nrr22HWq1L1gd8Q65ASaKh5Ktc
         deL40f6UyMgCui5qD44W3fCF0EY2Uc1Kb+UdsPMOu69RvWNO9/cHnjEm9WjGg++CF0
         Y8GipTjDcw4wEfZ3j5uLJXh2Wq+edMmzlbnYEW3I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 076/264] staging: rtl8192u: Do not use GFP_KERNEL in atomic context
Date:   Tue, 27 Oct 2020 14:52:14 +0100
Message-Id: <20201027135434.276297905@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135430.632029009@linuxfoundation.org>
References: <20201027135430.632029009@linuxfoundation.org>
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
index 28cae82d795c7..fb824c5174497 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c
@@ -599,7 +599,7 @@ static void RxReorderIndicatePacket(struct ieee80211_device *ieee,
 
 	prxbIndicateArray = kmalloc_array(REORDER_WIN_SIZE,
 					  sizeof(struct ieee80211_rxb *),
-					  GFP_KERNEL);
+					  GFP_ATOMIC);
 	if (!prxbIndicateArray)
 		return;
 
-- 
2.25.1



