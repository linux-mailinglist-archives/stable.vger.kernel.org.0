Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCAEB3643AA
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 15:31:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240532AbhDSNVQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 09:21:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:55076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240064AbhDSNSw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 09:18:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DB306613DA;
        Mon, 19 Apr 2021 13:15:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618838102;
        bh=sSGAmc6Zvs7js8q5Cf3tMvFCnq1syBouk8yfFuKKSpc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CHqlqsagogYNX0gn1LjbI+sbtagF6MZOV3xaoUooSmKj7MyGe9aJnWf9KKZeE9H+O
         fQZL1qKsLKWKFa9wNfgMTs2+aHYwYqAsX0Mx3UvuaomZXEI8DTxBKTvYP2cAXSkHf3
         /nKr6cH94SGasuxqS7ooZdHBi+TkU4/qKyFmVZgQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dave Jiang <dave.jiang@intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 008/103] dmaengine: idxd: fix wq size store permission state
Date:   Mon, 19 Apr 2021 15:05:19 +0200
Message-Id: <20210419130528.081098620@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210419130527.791982064@linuxfoundation.org>
References: <20210419130527.791982064@linuxfoundation.org>
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
index b3ab86ced355..ad46b3c648af 100644
--- a/drivers/dma/idxd/sysfs.c
+++ b/drivers/dma/idxd/sysfs.c
@@ -923,7 +923,7 @@ static ssize_t wq_size_store(struct device *dev,
 	if (!test_bit(IDXD_FLAG_CONFIGURABLE, &idxd->flags))
 		return -EPERM;
 
-	if (wq->state != IDXD_WQ_DISABLED)
+	if (idxd->state == IDXD_DEV_ENABLED)
 		return -EPERM;
 
 	if (size + total_claimed_wq_size(idxd) - wq->size > idxd->max_wq_size)
-- 
2.30.2



