Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8811D1AA417
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 15:23:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2506260AbgDONRR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 09:17:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:54634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2897019AbgDOLfG (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Apr 2020 07:35:06 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6785920936;
        Wed, 15 Apr 2020 11:35:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586950506;
        bh=xnctP96IABKORGoIgvVEM+OiiZ2hWkTGMixUA2d1amo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AJopUODkknX24E3yiKAgNzwUGy1sT4l3nA65naGYPyX6nQimsZWczvPRrhqkXY3ET
         Akk3I6Hgt6ik6kn3JmSJqGTd0Xulyv5MTG7MkmOtpItXysmg7Ld4/humvY4poYZs5G
         yqlrYYKaOm9VzEuKltnNiwh83lmm/I/sf2yKDPxs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dave Jiang <dave.jiang@intel.com>,
        Yixin Zhang <yixin.zhang@intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>,
        dmaengine@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 017/129] dmaengine: idxd: reflect shadow copy of traffic class programming
Date:   Wed, 15 Apr 2020 07:32:52 -0400
Message-Id: <20200415113445.11881-17-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200415113445.11881-1-sashal@kernel.org>
References: <20200415113445.11881-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Jiang <dave.jiang@intel.com>

[ Upstream commit a1fcaf07ec718bb1f11e29e952c9a4cb733d57a5 ]

The traffic class are set to -1 at initialization until the user programs
them. If the user choose not to, the driver will program appropriate
defaults. The driver also needs to update the shadowed copies of the values
after doing the programming.

Fixes: c52ca478233c ("dmaengine: idxd: add configuration component of driver")
Reported-by: Yixin Zhang <yixin.zhang@intel.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/158386263076.10898.4586509576813094559.stgit@djiang5-desk3.ch.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/idxd/device.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/idxd/device.c b/drivers/dma/idxd/device.c
index ada69e722f84a..f6f49f0f6fae2 100644
--- a/drivers/dma/idxd/device.c
+++ b/drivers/dma/idxd/device.c
@@ -584,11 +584,11 @@ static void idxd_group_flags_setup(struct idxd_device *idxd)
 		struct idxd_group *group = &idxd->groups[i];
 
 		if (group->tc_a == -1)
-			group->grpcfg.flags.tc_a = 0;
+			group->tc_a = group->grpcfg.flags.tc_a = 0;
 		else
 			group->grpcfg.flags.tc_a = group->tc_a;
 		if (group->tc_b == -1)
-			group->grpcfg.flags.tc_b = 1;
+			group->tc_b = group->grpcfg.flags.tc_b = 1;
 		else
 			group->grpcfg.flags.tc_b = group->tc_b;
 		group->grpcfg.flags.use_token_limit = group->use_token_limit;
-- 
2.20.1

