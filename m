Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F539364259
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 15:07:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237734AbhDSNIN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 09:08:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:42684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231998AbhDSNIM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 09:08:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BD23261245;
        Mon, 19 Apr 2021 13:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618837662;
        bh=IyByWZluu048j7Tol+of3xi5ZkTMq1zSjbSfiqXyh0c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nALv5v9xVOKGohngf41Oh5f0XhFoRd9XL73kGlrFZEH2trAJCFmJv3akNYu3l8Cp1
         HY3bzhhVWNYXP0NBLyNKLNj52H7HFOxvWUUnpFfDOSMFNTzI/nfUYsGnt4wK797gV4
         7U10DsHl38gIaljuRn99dQCcyiUzuBuhFXg0YhwY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dave Jiang <dave.jiang@intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 010/122] dmaengine: idxd: fix wq size store permission state
Date:   Mon, 19 Apr 2021 15:04:50 +0200
Message-Id: <20210419130530.519179929@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210419130530.166331793@linuxfoundation.org>
References: <20210419130530.166331793@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Jiang <dave.jiang@intel.com>

[ Upstream commit 0fff71c5a311e1264988179f7dcc217fda15fadd ]

WQ size can only be changed when the device is disabled. Current code
allows change when device is enabled but wq is disabled. Change the check
to detect device state.

Fixes: c52ca478233c ("dmaengine: idxd: add configuration component of driver")
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/161782558755.107710.18138252584838406025.stgit@djiang5-desk3.ch.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/idxd/sysfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/idxd/sysfs.c b/drivers/dma/idxd/sysfs.c
index c27ca01cf8b2..5f7bc4b1621a 100644
--- a/drivers/dma/idxd/sysfs.c
+++ b/drivers/dma/idxd/sysfs.c
@@ -989,7 +989,7 @@ static ssize_t wq_size_store(struct device *dev,
 	if (!test_bit(IDXD_FLAG_CONFIGURABLE, &idxd->flags))
 		return -EPERM;
 
-	if (wq->state != IDXD_WQ_DISABLED)
+	if (idxd->state == IDXD_DEV_ENABLED)
 		return -EPERM;
 
 	if (size + total_claimed_wq_size(idxd) - wq->size > idxd->max_wq_size)
-- 
2.30.2



