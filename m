Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BE0E111EB4
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:04:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728637AbfLCWwM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:52:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:44832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729831AbfLCWwM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:52:12 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 43F37207DD;
        Tue,  3 Dec 2019 22:52:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413531;
        bh=rMifvJk44VUgDhLnKLoatsmGOruqWykVcVVtAmoDzZc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kBVQCA1M4B8DQFtEPOaClsNOceSeegXAiQtNhljSJOXvH9ZUPM7vuGCpyBB0Veh9a
         SkvOtxfLyT0hOGgG//RN9nm9irwzCJX8dPUtM1d1Db9Aa0s2n5hTqiteeWIJyf/FW4
         ukKv85DNsvlz5iSoJOFJG7UaZFNYNFMrdMHGu3Rk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kyle Roeschley <kyle.roeschley@ni.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 162/321] ath6kl: Only use match sets when firmware supports it
Date:   Tue,  3 Dec 2019 23:33:48 +0100
Message-Id: <20191203223435.567703667@linuxfoundation.org>
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

[ Upstream commit fb376a495fbdb886f38cfaf5a3805401b9e46f13 ]

Commit dd45b7598f1c ("ath6kl: Include match ssid list in scheduled scan")
merged the probed and matched SSID lists before sending them to the
firmware. In the process, it assumed match set support is always available
in ath6kl_set_probed_ssids, which breaks scans for hidden SSIDs. Now, check
that the firmware supports matching SSIDs in scheduled scans before setting
MATCH_SSID_FLAG.

Fixes: dd45b7598f1c ("ath6kl: Include match ssid list in scheduled scan")
Signed-off-by: Kyle Roeschley <kyle.roeschley@ni.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index e121187f371ff..6c98d7903ffb6 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -939,7 +939,7 @@ static int ath6kl_set_probed_ssids(struct ath6kl *ar,
 		else
 			ssid_list[i].flag = ANY_SSID_FLAG;
 
-		if (n_match_ssid == 0)
+		if (ar->wiphy->max_match_sets != 0 && n_match_ssid == 0)
 			ssid_list[i].flag |= MATCH_SSID_FLAG;
 	}
 
-- 
2.20.1



