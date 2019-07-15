Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7603C696BF
	for <lists+stable@lfdr.de>; Mon, 15 Jul 2019 17:07:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388076AbfGOOFE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jul 2019 10:05:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:51260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387474AbfGOOFD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jul 2019 10:05:03 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 03FB72184B;
        Mon, 15 Jul 2019 14:05:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563199503;
        bh=ycwk6oC+x61BQ/IrIG0u0Xkz817gkuX+WzSCZEZXK54=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HCO/etppHI4Ud2WqeXo8GF2UBqKvlFbtJzfNdY95imvvlaiA/kg5bNgJ8kQEXkQhr
         SbaehkQ8r3kL32aKVkwHx5x1KdFhpMGt8Uq63i1RMJVlUjBWi08phcq6Z6sUytzaKR
         3pbo5QoYhifzix1iPiTVQDpWC6OkGf8hQNASEV44=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kangjie Lu <kjlu@umn.edu>, Mukesh Ojha <mojha@codeaurora.org>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 024/219] media: vpss: fix a potential NULL pointer dereference
Date:   Mon, 15 Jul 2019 10:00:25 -0400
Message-Id: <20190715140341.6443-24-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715140341.6443-1-sashal@kernel.org>
References: <20190715140341.6443-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kangjie Lu <kjlu@umn.edu>

[ Upstream commit e08f0761234def47961d3252eac09ccedfe4c6a0 ]

In case ioremap fails, the fix returns -ENOMEM to avoid NULL
pointer dereference.

Signed-off-by: Kangjie Lu <kjlu@umn.edu>
Reviewed-by: Mukesh Ojha <mojha@codeaurora.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/davinci/vpss.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/media/platform/davinci/vpss.c b/drivers/media/platform/davinci/vpss.c
index 19cf6853411e..89a86c19579b 100644
--- a/drivers/media/platform/davinci/vpss.c
+++ b/drivers/media/platform/davinci/vpss.c
@@ -518,6 +518,11 @@ static int __init vpss_init(void)
 		return -EBUSY;
 
 	oper_cfg.vpss_regs_base2 = ioremap(VPSS_CLK_CTRL, 4);
+	if (unlikely(!oper_cfg.vpss_regs_base2)) {
+		release_mem_region(VPSS_CLK_CTRL, 4);
+		return -ENOMEM;
+	}
+
 	writel(VPSS_CLK_CTRL_VENCCLKEN |
 		     VPSS_CLK_CTRL_DACCLKEN, oper_cfg.vpss_regs_base2);
 
-- 
2.20.1

