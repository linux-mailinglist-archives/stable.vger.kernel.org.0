Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D102176CC9
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 03:59:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728201AbgCCCry (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Mar 2020 21:47:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:43032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728156AbgCCCrv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Mar 2020 21:47:51 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8F6E824673;
        Tue,  3 Mar 2020 02:47:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583203671;
        bh=DJ7m9Kjn2gggjYhzhVkrVZAJu0ldu3G8qeweFwR+9ko=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C2C1O/2lkvWDZaqyNpbskr7xok96PvxPXHlcg+kRFuxMXikwysnyx6F9heD1+xgcF
         zzMuPedRiP8zi6JlBwl5tyAlO6tLsosH73/wd1FN+4d2MS03OolGohj38s84+PYET2
         QK8o1jnQNRIMILo7t8HPpsb4iO5seMYagjCU1lCU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Omer Shpigelman <oshpigelman@habana.ai>,
        Oded Gabbay <oded.gabbay@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 09/58] habanalabs: do not halt CoreSight during hard reset
Date:   Mon,  2 Mar 2020 21:46:51 -0500
Message-Id: <20200303024740.9511-9-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200303024740.9511-1-sashal@kernel.org>
References: <20200303024740.9511-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Omer Shpigelman <oshpigelman@habana.ai>

[ Upstream commit a37e47192dfa98f79a0cd5ab991c224b5980c982 ]

During hard reset we must not write to the device.
Hence avoid halting CoreSight during user context close if it is done
during hard reset.
In addition, we must not re-enable clock gating afterwards as it was
deliberately disabled in the beginning of the hard reset flow.

Signed-off-by: Omer Shpigelman <oshpigelman@habana.ai>
Reviewed-by: Oded Gabbay <oded.gabbay@gmail.com>
Signed-off-by: Oded Gabbay <oded.gabbay@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/habanalabs/device.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/misc/habanalabs/device.c b/drivers/misc/habanalabs/device.c
index eb9c07833a517..a7a4fed4d8995 100644
--- a/drivers/misc/habanalabs/device.c
+++ b/drivers/misc/habanalabs/device.c
@@ -600,7 +600,9 @@ int hl_device_set_debug_mode(struct hl_device *hdev, bool enable)
 			goto out;
 		}
 
-		hdev->asic_funcs->halt_coresight(hdev);
+		if (!hdev->hard_reset_pending)
+			hdev->asic_funcs->halt_coresight(hdev);
+
 		hdev->in_debug = 0;
 
 		goto out;
-- 
2.20.1

