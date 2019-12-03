Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 615D5111EBE
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:04:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729231AbfLCXEH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 18:04:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:44920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729999AbfLCWwO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:52:14 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A60FF207DD;
        Tue,  3 Dec 2019 22:52:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413534;
        bh=gjGA4RaMSHT64+qS1HoDY2NasMLucSNVblWZNdWGt3U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aRlN2Rcfy6fyyq/dYOkIm6NCU8W2nLnKD62O+LPBvnN83mVKhbDec7aE6VERTRjA3
         WX46edkKLCIOe0qyfYkjl/4S+U6TBpEpQpvGtdHIRWLfDH1MkdS0uc+9hL6dHTgLr5
         CUG87zGjEePKMvpbH/Wjp5S6Z0wKykhr/ablSYT4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kyle Roeschley <kyle.roeschley@ni.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 163/321] ath6kl: Fix off by one error in scan completion
Date:   Tue,  3 Dec 2019 23:33:49 +0100
Message-Id: <20191203223435.619030257@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203223427.103571230@linuxfoundation.org>
References: <20191203223427.103571230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kyle Roeschley <kyle.roeschley@ni.com>

[ Upstream commit 5803c12816c43bd09e5f4247dd9313c2d9a2c41b ]

When ath6kl was reworked to share code between regular and scheduled scans
in commit 3b8ffc6a22ba ("ath6kl: Configure probed SSID list consistently"),
probed SSID entry changed from 1-index to 0-indexed. However,
ath6kl_cfg80211_scan_complete_event() was missed in that change. Fix its
indexing so that we correctly clear out the probed SSID list.

Signed-off-by: Kyle Roeschley <kyle.roeschley@ni.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 6c98d7903ffb6..d7c626d9594e1 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -1093,7 +1093,7 @@ void ath6kl_cfg80211_scan_complete_event(struct ath6kl_vif *vif, bool aborted)
 	if (vif->scan_req->n_ssids && vif->scan_req->ssids[0].ssid_len) {
 		for (i = 0; i < vif->scan_req->n_ssids; i++) {
 			ath6kl_wmi_probedssid_cmd(ar->wmi, vif->fw_vif_idx,
-						  i + 1, DISABLE_SSID_FLAG,
+						  i, DISABLE_SSID_FLAG,
 						  0, NULL);
 		}
 	}
-- 
2.20.1



