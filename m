Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3B24450B36
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:17:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236477AbhKORUk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:20:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:44996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237341AbhKORTZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:19:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5B09E63259;
        Mon, 15 Nov 2021 17:14:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636996462;
        bh=9nz0x7iTpe50Pw2n8ju7MYMoLXnaSly4sFR4aWZPcHY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rcZheccdn73T5FCWOfz03orQECAzHaOmrv4SF2JF/xPsF+k6DO5EZbHCbLxije0Vj
         tzUa1XKkJi5Hv4h3wDEcdl0Qu36+04OEisIg0dcRDcmmbql93J6C3K9hZQUcOwjcUf
         sfEnPgjP0r1z3dw96JmqVEIiLJnBwyDznAkNi9PU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, TOTE Robot <oslab@tsinghua.edu.cn>,
        Tuo Li <islituo@gmail.com>, Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 149/355] ath: dfs_pattern_detector: Fix possible null-pointer dereference in channel_detector_create()
Date:   Mon, 15 Nov 2021 18:01:13 +0100
Message-Id: <20211115165318.615608825@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165313.549179499@linuxfoundation.org>
References: <20211115165313.549179499@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tuo Li <islituo@gmail.com>

[ Upstream commit 4b6012a7830b813799a7faf40daa02a837e0fd5b ]

kzalloc() is used to allocate memory for cd->detectors, and if it fails,
channel_detector_exit() behind the label fail will be called:
  channel_detector_exit(dpd, cd);

In channel_detector_exit(), cd->detectors is dereferenced through:
  struct pri_detector *de = cd->detectors[i];

To fix this possible null-pointer dereference, check cd->detectors before
the for loop to dereference cd->detectors.

Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Signed-off-by: Tuo Li <islituo@gmail.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20210805153854.154066-1-islituo@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/dfs_pattern_detector.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/dfs_pattern_detector.c b/drivers/net/wireless/ath/dfs_pattern_detector.c
index a274eb0d19688..a0ad6e48a35b4 100644
--- a/drivers/net/wireless/ath/dfs_pattern_detector.c
+++ b/drivers/net/wireless/ath/dfs_pattern_detector.c
@@ -182,10 +182,12 @@ static void channel_detector_exit(struct dfs_pattern_detector *dpd,
 	if (cd == NULL)
 		return;
 	list_del(&cd->head);
-	for (i = 0; i < dpd->num_radar_types; i++) {
-		struct pri_detector *de = cd->detectors[i];
-		if (de != NULL)
-			de->exit(de);
+	if (cd->detectors) {
+		for (i = 0; i < dpd->num_radar_types; i++) {
+			struct pri_detector *de = cd->detectors[i];
+			if (de != NULL)
+				de->exit(de);
+		}
 	}
 	kfree(cd->detectors);
 	kfree(cd);
-- 
2.33.0



