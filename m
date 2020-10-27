Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A63129B59F
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:19:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1794818AbgJ0PNq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:13:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:50626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1794813AbgJ0PNp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:13:45 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8E04920657;
        Tue, 27 Oct 2020 15:13:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603811625;
        bh=b3yn/e1fuNGB/nSvT2z3p0aLOFj4I7+dDr6hA0bzlTk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hADSSXFoRezmmvgQzvyYlWi00/M+2N4jK8GPC1fV2CcZw4B1rT78bwyvwLDps8T+W
         VW9DXteYwgRCbNms/hZ5q7eiXpoj310KdT/YdIGk6MjUZgi6sxL0xLb6NvFdF8hsuG
         PkjBXGosfNkj7yYioCRMJdrH0IstxA6OO4fbkG70=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 560/633] staging: wfx: fix handling of MMIC error
Date:   Tue, 27 Oct 2020 14:55:03 +0100
Message-Id: <20201027135549.077722164@linuxfoundation.org>
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

From: Jérôme Pouiller <jerome.pouiller@silabs.com>

[ Upstream commit 8d350c14ee5eb62ecd40b0991248bfbce511954d ]

As expected, when the device detect a MMIC error, it returns a specific
status. However, it also strip IV from the frame (don't ask me why).

So, with the current code, mac80211 detects a corrupted frame and it
drops it before it handle the MMIC error. The expected behavior would be
to detect MMIC error then to renegotiate the EAP session.

So, this patch correctly informs mac80211 that IV is not available. So,
mac80211 correctly takes into account the MMIC error.

Signed-off-by: Jérôme Pouiller <jerome.pouiller@silabs.com>
Link: https://lore.kernel.org/r/20201007101943.749898-2-Jerome.Pouiller@silabs.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/wfx/data_rx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wfx/data_rx.c b/drivers/staging/wfx/data_rx.c
index 0e959ebc38b56..a9fb5165b33d9 100644
--- a/drivers/staging/wfx/data_rx.c
+++ b/drivers/staging/wfx/data_rx.c
@@ -80,7 +80,7 @@ void wfx_rx_cb(struct wfx_vif *wvif,
 		goto drop;
 
 	if (arg->status == HIF_STATUS_RX_FAIL_MIC)
-		hdr->flag |= RX_FLAG_MMIC_ERROR;
+		hdr->flag |= RX_FLAG_MMIC_ERROR | RX_FLAG_IV_STRIPPED;
 	else if (arg->status)
 		goto drop;
 
-- 
2.25.1



