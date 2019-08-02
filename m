Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCD0A7F483
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 12:07:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389203AbfHBJaO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 05:30:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:55650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389250AbfHBJaO (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 05:30:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2CACF217D4;
        Fri,  2 Aug 2019 09:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564738213;
        bh=nyQUfzMXckBBhBf+8aH2XxzoL3nOAIQ5wmJfF1l0vSU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eShG4BwrEqS4BAxMgzVsF0U60H2N/y8KpRZ9qQvr5uQrCUz0/mN9mmPMqLC46reuo
         gWp+XRyVECxw8DHCPVq/HX5MRgnvmNP+UIXCWuPdOao41WOD8+H67n2RIqSVJAQRWI
         dh+S4Kp0DD4iOvCZYSisoRtP/imAcATJocsDABD0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tamizh chelvam <tamizhr@codeaurora.org>,
        Anilkumar Kolli <akolli@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 007/158] ath: DFS JP domain W56 fixed pulse type 3 RADAR detection
Date:   Fri,  2 Aug 2019 11:27:08 +0200
Message-Id: <20190802092205.005522753@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190802092203.671944552@linuxfoundation.org>
References: <20190802092203.671944552@linuxfoundation.org>
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
index 2303ef96299d..0835828ffed7 100644
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



