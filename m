Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58242383622
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:32:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244853AbhEQP2l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:28:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:41300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243904AbhEQP0g (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:26:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A95DD6101E;
        Mon, 17 May 2021 14:36:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621262193;
        bh=WigA0s0Qf+Uvz3qLM/a7I0FAlGbfIRPrRCmCmQAPl78=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PSdWxC0LBuPAdzq03OqzamK2EEaeuvnfWUv4OUfTaf+rfMotbbrDU7Djva08iREBd
         H/h0KcUBeKBZQGd2nti4ojszp9r54Z79xaGolyn0vlHleoGs2L+unoMdezCPfW7RVu
         C5xqVZXKxb15AUUAP47SB/OWiAtzG0lY0zDaMXi4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 130/289] dmaengine: idxd: Fix potential null dereference on pointer status
Date:   Mon, 17 May 2021 16:00:55 +0200
Message-Id: <20210517140309.535466038@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140305.140529752@linuxfoundation.org>
References: <20210517140305.140529752@linuxfoundation.org>
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
index 459e9fbc2253..f90fdf7aeeef 100644
--- a/drivers/dma/idxd/device.c
+++ b/drivers/dma/idxd/device.c
@@ -378,7 +378,8 @@ static void idxd_cmd_exec(struct idxd_device *idxd, int cmd_code, u32 operand,
 
 	if (idxd_device_is_halted(idxd)) {
 		dev_warn(&idxd->pdev->dev, "Device is HALTED!\n");
-		*status = IDXD_CMDSTS_HW_ERR;
+		if (status)
+			*status = IDXD_CMDSTS_HW_ERR;
 		return;
 	}
 
-- 
2.30.2



