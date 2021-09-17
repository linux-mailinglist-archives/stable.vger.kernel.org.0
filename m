Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12EA040EF7D
	for <lists+stable@lfdr.de>; Fri, 17 Sep 2021 04:36:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242989AbhIQCgV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 22:36:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:33442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243126AbhIQCgA (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 22:36:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 66F4B61152;
        Fri, 17 Sep 2021 02:34:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631846079;
        bh=TGY6vaCNeUrYVtHB3VN4F6W7aYwipak6wq3beLh+/KU=;
        h=From:To:Cc:Subject:Date:From;
        b=P73iqS05LuCOO3rE+A1C2eMLew4W1mSEFnfynzMn8uxafxe346cH9eo6282XYTQ+y
         i9vCOgmdQlKMDl3LrIpQtsNolaYumbN7GcRkw6Xye/kAwTMyxx/2oV9aW3f14GBYx7
         DwUImkvNw+Cm+RJfsaS9KGq/WygFYe9QFoKzPdLlayuLCDN2SGc3sNY0IenckeVRYA
         vui7yb32o1phNN6r07HCcJ5UURimIe5lL8k1tUSpyRlkDuFNB7EBSiB/l4USW0JBSi
         Zj/uNDqp0KJyjk/fNTh2y7gYzu00g5uTTm7tmzbC3svLWEWTLDB8ztP9F5Hool+gyH
         R0CiG7oha+sbw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ofir Bitton <obitton@habana.ai>, Oded Gabbay <ogabbay@kernel.org>,
        Sasha Levin <sashal@kernel.org>, Arnd@vger.kernel.org,
        gregkh@linuxfoundation.org, osharabi@habana.ai, kelbaz@habana.ai,
        ttayar@habana.ai, ynudelman@habana.ai, fkassabri@habana.ai,
        amizrahi@habana.ai, bjauhari@habana.ai
Subject: [PATCH AUTOSEL 5.10 1/8] habanalabs: add validity check for event ID received from F/W
Date:   Thu, 16 Sep 2021 22:34:26 -0400
Message-Id: <20210917023437.816574-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
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
2.30.2

