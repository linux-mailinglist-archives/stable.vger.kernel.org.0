Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8728141745B
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 15:07:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345966AbhIXNFF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 09:05:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:33206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346212AbhIXNDE (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 09:03:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 128DE6127A;
        Fri, 24 Sep 2021 12:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632488098;
        bh=qdIPaW6ag/Li33VUPZ+fKmew2a7KNEm384xhvom0p/U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0uq9yiXjBfSoO/Bql/nbDGQC5SWtuFu6eOarnyNbCO/fp+cxVT7kH3B5YBTJ3yKkg
         1eYCTuQAxE9FP/3fZkC5FWxvbvNm3wWT4DPjCgwgRUyedPr57yZeDxnZsQ3yeVBIpT
         5OpSv8JPnqxKv3xAInO9kSt9CxuXe/pyG615N1UE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ofir Bitton <obitton@habana.ai>,
        Oded Gabbay <ogabbay@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 084/100] habanalabs: add validity check for event ID received from F/W
Date:   Fri, 24 Sep 2021 14:44:33 +0200
Message-Id: <20210924124344.277199418@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124341.214446495@linuxfoundation.org>
References: <20210924124341.214446495@linuxfoundation.org>
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
2.33.0



