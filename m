Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8669737CE
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 21:23:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387722AbfGXTXP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:23:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:38826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728558AbfGXTXO (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:23:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6F575218EA;
        Wed, 24 Jul 2019 19:23:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563996193;
        bh=k7obKKqlAkIYwKC6eR3tddu+08+X5r047EbyTzv6Ksg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aGp2iKCt73pbwa1aTFAlngoseXzDaAvIdSz5YcQ4bfwM6+PgWm1M5vA90f7SCCAuI
         dmDhT1ZcaSnX9Xe88BWJvFXWFUXeVP/BNgcJLj1cfAIJjFMF71K6soU6VJhIBy1aZL
         ijNB+lTKsYbYtFjd8kg842Ou+yWWQSNz4dAvDcJk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tamizh chelvam <tamizhr@codeaurora.org>,
        Anilkumar Kolli <akolli@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 014/413] ath: DFS JP domain W56 fixed pulse type 3 RADAR detection
Date:   Wed, 24 Jul 2019 21:15:05 +0200
Message-Id: <20190724191736.427122511@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191735.096702571@linuxfoundation.org>
References: <20190724191735.096702571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit d8792393a783158cbb2c39939cb897dc5e5299b6 ]

Increase pulse width range from 1-2usec to 0-4usec.
During data traffic HW occasionally fails detecting radar pulses,
so that SW cannot get enough radar reports to achieve the success rate.

Tested ath10k hw and fw:
	* QCA9888(10.4-3.5.1-00052)
	* QCA4019(10.4-3.2.1.1-00017)
	* QCA9984(10.4-3.6-00104)
	* QCA988X(10.2.4-1.0-00041)

Tested ath9k hw: AR9300

Tested-by: Tamizh chelvam <tamizhr@codeaurora.org>
Signed-off-by: Tamizh chelvam <tamizhr@codeaurora.org>
Signed-off-by: Anilkumar Kolli <akolli@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/dfs_pattern_detector.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/dfs_pattern_detector.c b/drivers/net/wireless/ath/dfs_pattern_detector.c
index d52b31b45df7..a274eb0d1968 100644
--- a/drivers/net/wireless/ath/dfs_pattern_detector.c
+++ b/drivers/net/wireless/ath/dfs_pattern_detector.c
@@ -111,7 +111,7 @@ static const struct radar_detector_specs jp_radar_ref_types[] = {
 	JP_PATTERN(0, 0, 1, 1428, 1428, 1, 18, 29, false),
 	JP_PATTERN(1, 2, 3, 3846, 3846, 1, 18, 29, false),
 	JP_PATTERN(2, 0, 1, 1388, 1388, 1, 18, 50, false),
-	JP_PATTERN(3, 1, 2, 4000, 4000, 1, 18, 50, false),
+	JP_PATTERN(3, 0, 4, 4000, 4000, 1, 18, 50, false),
 	JP_PATTERN(4, 0, 5, 150, 230, 1, 23, 50, false),
 	JP_PATTERN(5, 6, 10, 200, 500, 1, 16, 50, false),
 	JP_PATTERN(6, 11, 20, 200, 500, 1, 12, 50, false),
-- 
2.20.1



