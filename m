Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A45E43C9037
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 22:00:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240972AbhGNTyH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:54:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:45484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241034AbhGNTuU (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:50:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 913A260FF2;
        Wed, 14 Jul 2021 19:46:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291998;
        bh=wzFNLVPeIlQlLrIQZ3+S8W4G1Mep2IE4KMTCFszJ1gQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZxsTgqkRIAohCpImNyhQ3NqzcM42q3GoCBgBPtH7ntQxsxIz6UwcPm1w4J3VkdGhD
         0Lu4BdDZP3PTYmMYs+bpnsMhFQvfyNkdHyTMSShfbdxqsCgikTXDxGG0FGQqMo5DNw
         jYr6nYJlR1g4ZVJugP58tD6AvaQsnJxR5GoSDHaavaJ47i1BrWSddB/WJ1eDnNgPz9
         NZlnDcaQiFF4BQTJVievfoHFxrj0cGgJ/4rkFnY5M2ADPUqIQAOBvfp/4FzT3XUQMd
         0VhQb13UcA/E5V9xJ2TgfEBJED1q8BUQuVt5crXZ9Rr4FCozL5Zod950NjxZIaeUcU
         ogh7bunil43Rg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Philipp Zabel <p.zabel@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 09/39] reset: ti-syscon: fix to_ti_syscon_reset_data macro
Date:   Wed, 14 Jul 2021 15:45:54 -0400
Message-Id: <20210714194625.55303-9-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714194625.55303-1-sashal@kernel.org>
References: <20210714194625.55303-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Philipp Zabel <p.zabel@pengutronix.de>

[ Upstream commit 05cf8fffcdeb47aef1203c08cbec5224fd3a0e1c ]

The to_ti_syscon_reset_data macro currently only works if the
parameter passed into it is called 'rcdev'.

Fixes a checkpatch --strict issue:

  CHECK: Macro argument reuse 'rcdev' - possible side-effects?
  #53: FILE: drivers/reset/reset-ti-syscon.c:53:
  +#define to_ti_syscon_reset_data(rcdev)	\
  +	container_of(rcdev, struct ti_syscon_reset_data, rcdev)

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/reset/reset-ti-syscon.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/reset/reset-ti-syscon.c b/drivers/reset/reset-ti-syscon.c
index a2635c21db7f..ecb8873e3a19 100644
--- a/drivers/reset/reset-ti-syscon.c
+++ b/drivers/reset/reset-ti-syscon.c
@@ -58,8 +58,8 @@ struct ti_syscon_reset_data {
 	unsigned int nr_controls;
 };
 
-#define to_ti_syscon_reset_data(rcdev)	\
-	container_of(rcdev, struct ti_syscon_reset_data, rcdev)
+#define to_ti_syscon_reset_data(_rcdev)	\
+	container_of(_rcdev, struct ti_syscon_reset_data, rcdev)
 
 /**
  * ti_syscon_reset_assert() - assert device reset
-- 
2.30.2

