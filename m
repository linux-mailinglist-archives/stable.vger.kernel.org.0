Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BD9341751B
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 15:13:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345425AbhIXNO1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 09:14:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:38878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346675AbhIXNKO (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 09:10:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5A718613A6;
        Fri, 24 Sep 2021 12:58:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632488287;
        bh=v/vqUdqTSUnR96EXa4I9dB+riotHyEVMBExY2ds6+Jo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q1ugftOiOPcW0piHV60VX0vy+SHnddAyi5TfdHMTNQqharGpPRuKJaDUqfLcmZmvC
         QFz7vay6YPLqkGbwQM4mDkCA/iy6ZYl0zBs8Rea3e7v1anH5W8627S4+xAz88bV8Ap
         gPQu6LgZcVYgjn7CheDko0B8R/wgJULQC70tccmw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ofir Bitton <obitton@habana.ai>,
        Oded Gabbay <ogabbay@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 55/63] habanalabs: add validity check for event ID received from F/W
Date:   Fri, 24 Sep 2021 14:44:55 +0200
Message-Id: <20210924124336.161503743@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124334.228235870@linuxfoundation.org>
References: <20210924124334.228235870@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 37edd663603f..ebac53a73bd1 100644
--- a/drivers/misc/habanalabs/gaudi/gaudi.c
+++ b/drivers/misc/habanalabs/gaudi/gaudi.c
@@ -5723,6 +5723,12 @@ static void gaudi_handle_eqe(struct hl_device *hdev,
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
index 5b5d6275c249..c8023b4428c5 100644
--- a/drivers/misc/habanalabs/goya/goya.c
+++ b/drivers/misc/habanalabs/goya/goya.c
@@ -4623,6 +4623,12 @@ void goya_handle_eqe(struct hl_device *hdev, struct hl_eq_entry *eq_entry)
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
2.33.0



