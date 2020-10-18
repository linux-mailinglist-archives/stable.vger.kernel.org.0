Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17757291A0C
	for <lists+stable@lfdr.de>; Sun, 18 Oct 2020 21:23:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729302AbgJRTVN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Oct 2020 15:21:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:33160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729298AbgJRTVN (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 18 Oct 2020 15:21:13 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 02BB5222EC;
        Sun, 18 Oct 2020 19:21:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603048872;
        bh=b3yn/e1fuNGB/nSvT2z3p0aLOFj4I7+dDr6hA0bzlTk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nFqvQq+3xHdd9SHiVKCf/+vGouKLZKylAp+2PWtth4U4ffJ7891PJ6M7/pFUw2Fit
         nuATwOBYkfqx4ZZdLDeASf00LG57jHtIeI6/hTzwpK97TK+XfKrELMFA3q5N++DL1K
         PeKP7qY2u6OClhbdoBtQfclHAxrbu4OnNcKYM/kI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, devel@driverdev.osuosl.org
Subject: [PATCH AUTOSEL 5.8 037/101] staging: wfx: fix handling of MMIC error
Date:   Sun, 18 Oct 2020 15:19:22 -0400
Message-Id: <20201018192026.4053674-37-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201018192026.4053674-1-sashal@kernel.org>
References: <20201018192026.4053674-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
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

