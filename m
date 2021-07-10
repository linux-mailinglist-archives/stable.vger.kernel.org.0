Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 323373C2F5C
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:29:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233544AbhGJCbO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:31:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:42542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234440AbhGJC31 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:29:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CABDD613DC;
        Sat, 10 Jul 2021 02:26:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625883992;
        bh=MPu6yhW027A+a3bpr3RxNiEK5BOI8kgsJdNz0Na3NPQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KZCTNXHGF2IGPlBo9j4fGSRf5s4FSSjJEOaRdiwz5roF/hqZxlXjGBZ9o2pGpt5Oc
         1H5WB6ddbDUidjdDJvU3DTcEqhm1W2LZqMMqoh2wV5le57gwywxoFQhQTLOxGTI20p
         4PjzK+2128Ad1DzB8ZlNVkcN59U/ZlKIdWaEPjr9Vz0RowYmkHYbpuS0pM81LMV/Gn
         e4f6tAHdoZM8XL6bTTI40BxADZtjZbQwVhmwDF75iUN8WCrVCVxCswCkceolsI3Ns3
         caYvEo75QYpJs/iwYwmHjSgpfVZ9XeV9hH+HNwcsvje8iXLINdjbY4OAwCzGg9lzfY
         QPh6YP8iCPbQQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Koby Elbaz <kelbaz@habana.ai>, Oded Gabbay <ogabbay@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.10 68/93] habanalabs: remove node from list before freeing the node
Date:   Fri,  9 Jul 2021 22:24:02 -0400
Message-Id: <20210710022428.3169839-68-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710022428.3169839-1-sashal@kernel.org>
References: <20210710022428.3169839-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Koby Elbaz <kelbaz@habana.ai>

[ Upstream commit f5eb7bf0c487a212ebda3c1b048fc3ccabacc147 ]

fix the following smatch warnings:

goya_pin_memory_before_cs()
warn: '&userptr->job_node' not removed from list

gaudi_pin_memory_before_cs()
warn: '&userptr->job_node' not removed from list

Signed-off-by: Koby Elbaz <kelbaz@habana.ai>
Reviewed-by: Oded Gabbay <ogabbay@kernel.org>
Signed-off-by: Oded Gabbay <ogabbay@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/habanalabs/gaudi/gaudi.c | 1 +
 drivers/misc/habanalabs/goya/goya.c   | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/misc/habanalabs/gaudi/gaudi.c b/drivers/misc/habanalabs/gaudi/gaudi.c
index 044b2ae196f9..37edd663603f 100644
--- a/drivers/misc/habanalabs/gaudi/gaudi.c
+++ b/drivers/misc/habanalabs/gaudi/gaudi.c
@@ -3708,6 +3708,7 @@ static int gaudi_pin_memory_before_cs(struct hl_device *hdev,
 	return 0;
 
 unpin_memory:
+	list_del(&userptr->job_node);
 	hl_unpin_host_memory(hdev, userptr);
 free_userptr:
 	kfree(userptr);
diff --git a/drivers/misc/habanalabs/goya/goya.c b/drivers/misc/habanalabs/goya/goya.c
index 986ed3c07208..5b5d6275c249 100644
--- a/drivers/misc/habanalabs/goya/goya.c
+++ b/drivers/misc/habanalabs/goya/goya.c
@@ -3190,6 +3190,7 @@ static int goya_pin_memory_before_cs(struct hl_device *hdev,
 	return 0;
 
 unpin_memory:
+	list_del(&userptr->job_node);
 	hl_unpin_host_memory(hdev, userptr);
 free_userptr:
 	kfree(userptr);
-- 
2.30.2

