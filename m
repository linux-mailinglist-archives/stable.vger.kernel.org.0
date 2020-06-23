Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D5A52065E7
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:51:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388526AbgFWVfD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 17:35:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:51956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387829AbgFWUKl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:10:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 61E4020707;
        Tue, 23 Jun 2020 20:10:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592943040;
        bh=qfDGp8y2Sgz/L41SXVjn+sgKFR3izMpAf5AaFrTPn+g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bU9r0xn/SwF19LlsU5J02SU4aUwZJNP/bTOU4hORXPpTj2DsVaJacMkNc2auY16uz
         LCsKurod/nJS2YphzO7y9POdzDdzbRDRhO1lZ+bqHcliDpyQO0BRI9MuzbVqZdv9VH
         oYq348HEI+bdfKKcEySwXq4bgEkPl/86PFnfvFvE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 205/477] staging: wfx: fix value of scan timeout
Date:   Tue, 23 Jun 2020 21:53:22 +0200
Message-Id: <20200623195417.271609796@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jérôme Pouiller <jerome.pouiller@silabs.com>

[ Upstream commit 6598b12d6635e8e3060863b84c04e472546ee126 ]

Before to start the scan request, the firmware signals (with a null
frame) to the AP it won't be able to receive data. This frame can be
long to send: up to 512TU. The current calculus of the scan timeout does
not take into account this delay.

Signed-off-by: Jérôme Pouiller <jerome.pouiller@silabs.com>
Link: https://lore.kernel.org/r/20200515083325.378539-5-Jerome.Pouiller@silabs.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/wfx/hif_tx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wfx/hif_tx.c b/drivers/staging/wfx/hif_tx.c
index 77bca43aca428..20b3045d76674 100644
--- a/drivers/staging/wfx/hif_tx.c
+++ b/drivers/staging/wfx/hif_tx.c
@@ -268,7 +268,7 @@ int hif_scan(struct wfx_vif *wvif, struct cfg80211_scan_request *req,
 	tmo_chan_bg = le32_to_cpu(body->max_channel_time) * USEC_PER_TU;
 	tmo_chan_fg = 512 * USEC_PER_TU + body->probe_delay;
 	tmo_chan_fg *= body->num_of_probe_requests;
-	tmo = chan_num * max(tmo_chan_bg, tmo_chan_fg);
+	tmo = chan_num * max(tmo_chan_bg, tmo_chan_fg) + 512 * USEC_PER_TU;
 
 	wfx_fill_header(hif, wvif->id, HIF_REQ_ID_START_SCAN, buf_len);
 	ret = wfx_cmd_send(wvif->wdev, hif, NULL, 0, false);
-- 
2.25.1



