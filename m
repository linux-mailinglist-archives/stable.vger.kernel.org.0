Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF62E38346F
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:11:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241611AbhEQPI5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:08:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:47776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242863AbhEQPE4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:04:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E3E7B61624;
        Mon, 17 May 2021 14:28:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261715;
        bh=6sevLBjQRawxKCUul0smE+K6rL/V3rBWtnuTo9KgPbY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=owL0CkwwA4zhx983Wu7ucnXJkuBiKY+whxLaw4YIcwfBlOeXG5AVkAhYsBAyj5G17
         XP/GpbZt/xI7IQZbPWN1gdnlKhxcO8aZJgGcDcluM1iu7pQ3xDSFZ+QGxacapyHe2U
         z8+GQVoEJLg8Nk/bW2ONMxFwOE/QAe/oK+59o/Y0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 154/329] dmaengine: idxd: Fix potential null dereference on pointer status
Date:   Mon, 17 May 2021 16:01:05 +0200
Message-Id: <20210517140307.319486387@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.043055203@linuxfoundation.org>
References: <20210517140302.043055203@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit 28ac8e03c43dfc6a703aa420d18222540b801120 ]

There are calls to idxd_cmd_exec that pass a null status pointer however
a recent commit has added an assignment to *status that can end up
with a null pointer dereference.  The function expects a null status
pointer sometimes as there is a later assignment to *status where
status is first null checked.  Fix the issue by null checking status
before making the assignment.

Addresses-Coverity: ("Explicit null dereferenced")
Fixes: 89e3becd8f82 ("dmaengine: idxd: check device state before issue command")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Acked-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/20210415110654.1941580-1-colin.king@canonical.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/idxd/device.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/idxd/device.c b/drivers/dma/idxd/device.c
index 31c819544a22..78d2dc5e9bd8 100644
--- a/drivers/dma/idxd/device.c
+++ b/drivers/dma/idxd/device.c
@@ -451,7 +451,8 @@ static void idxd_cmd_exec(struct idxd_device *idxd, int cmd_code, u32 operand,
 
 	if (idxd_device_is_halted(idxd)) {
 		dev_warn(&idxd->pdev->dev, "Device is HALTED!\n");
-		*status = IDXD_CMDSTS_HW_ERR;
+		if (status)
+			*status = IDXD_CMDSTS_HW_ERR;
 		return;
 	}
 
-- 
2.30.2



