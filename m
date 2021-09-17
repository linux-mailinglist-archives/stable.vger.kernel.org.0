Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A14C440EF60
	for <lists+stable@lfdr.de>; Fri, 17 Sep 2021 04:36:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242886AbhIQCfb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 22:35:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:60994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242961AbhIQCfZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 22:35:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8C8C961108;
        Fri, 17 Sep 2021 02:34:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631846043;
        bh=Q2Qo8lNxj5jm88ju1KOPZz/wGUgtP/5uwrX63RayjVA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bbABQa+JsxUCmWLCowmvB34IW2IvBDaKovOhtmugGtbAxtcGqpuE1kG4YLSLwcaRf
         r3XOpUTR3rPbiNzLz9AxO80jgjjEOfkSinBBQNohETJxJDseHKppifVFLjODf3doQl
         hIgKf4pTShTxIpLSIczOWz4/IGVY857IUf4t5Ha3abx1aP4zHnccJK3Fs0HNtiPqvn
         Wn2r9+DuumZ6gFqojUrVZoaRyUwUlOWcAi1Ox/qIrpTAH7cUzNHXMzv6dJQmI1PFQM
         ANJOa9xVlDj64qFEMe3KQX9/DOEQDlZZz9bsBrMuxjb0qbpnyZzLbWF0atYX9AX4MH
         Vdqx3FEAPkLWA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ofir Bitton <obitton@habana.ai>, Oded Gabbay <ogabbay@kernel.org>,
        Sasha Levin <sashal@kernel.org>, Arnd@vger.kernel.org,
        gregkh@linuxfoundation.org, osharabi@habana.ai, kelbaz@habana.ai,
        ttayar@habana.ai, ynudelman@habana.ai, fkassabri@habana.ai,
        amizrahi@habana.ai, bjauhari@habana.ai
Subject: [PATCH AUTOSEL 5.14 07/21] habanalabs: add validity check for event ID received from F/W
Date:   Thu, 16 Sep 2021 22:33:01 -0400
Message-Id: <20210917023315.816225-7-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210917023315.816225-1-sashal@kernel.org>
References: <20210917023315.816225-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ofir Bitton <obitton@habana.ai>

[ Upstream commit a6c849012b0f51c674f52384bd9a4f3dc0a33c31 ]

Currently there is no validity check for event ID received from F/W,
Thus exposing driver to memory overrun.

Signed-off-by: Ofir Bitton <obitton@habana.ai>
Reviewed-by: Oded Gabbay <ogabbay@kernel.org>
Signed-off-by: Oded Gabbay <ogabbay@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/habanalabs/gaudi/gaudi.c | 6 ++++++
 drivers/misc/habanalabs/goya/goya.c   | 6 ++++++
 2 files changed, 12 insertions(+)

diff --git a/drivers/misc/habanalabs/gaudi/gaudi.c b/drivers/misc/habanalabs/gaudi/gaudi.c
index aa8a0ca5aca2..409f05c962f2 100644
--- a/drivers/misc/habanalabs/gaudi/gaudi.c
+++ b/drivers/misc/habanalabs/gaudi/gaudi.c
@@ -7809,6 +7809,12 @@ static void gaudi_handle_eqe(struct hl_device *hdev,
 	u8 cause;
 	bool reset_required;
 
+	if (event_type >= GAUDI_EVENT_SIZE) {
+		dev_err(hdev->dev, "Event type %u exceeds maximum of %u",
+				event_type, GAUDI_EVENT_SIZE - 1);
+		return;
+	}
+
 	gaudi->events_stat[event_type]++;
 	gaudi->events_stat_aggregate[event_type]++;
 
diff --git a/drivers/misc/habanalabs/goya/goya.c b/drivers/misc/habanalabs/goya/goya.c
index 755e08cf2ecc..bfb22f96c1a3 100644
--- a/drivers/misc/habanalabs/goya/goya.c
+++ b/drivers/misc/habanalabs/goya/goya.c
@@ -4797,6 +4797,12 @@ void goya_handle_eqe(struct hl_device *hdev, struct hl_eq_entry *eq_entry)
 				>> EQ_CTL_EVENT_TYPE_SHIFT);
 	struct goya_device *goya = hdev->asic_specific;
 
+	if (event_type >= GOYA_ASYNC_EVENT_ID_SIZE) {
+		dev_err(hdev->dev, "Event type %u exceeds maximum of %u",
+				event_type, GOYA_ASYNC_EVENT_ID_SIZE - 1);
+		return;
+	}
+
 	goya->events_stat[event_type]++;
 	goya->events_stat_aggregate[event_type]++;
 
-- 
2.30.2

