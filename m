Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC2E73C8D7D
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:43:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236053AbhGNToy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:44:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:37944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236046AbhGNToI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:44:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0ADE361370;
        Wed, 14 Jul 2021 19:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291658;
        bh=tDcA3x5D/PZAB9wfm1zWhrszxwij3r3eXSDVbOmxIaM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Me0UajsMe2KblFdzT2dCl35/vw0irAVNZJamAE792zRDwBlGFY4U1t0yzXO8jJhD2
         bfoQcnrQRGBi9lgDjxaKOzNAgsgZZjxuph9SVufWF1sKnMZ6w9CZIQHDe69bKfgqz0
         uC+TuWLmhQ5Nas0919odKO3CJg1jfLRr3ji69a/Cm49beZ8YiX8T2jmxav6FBpHaIn
         Qepv+xxD3qroEcyuaB9uhLpvX7641H/AMOBYUOm/QAfyEoQeTBAioVcnyfG+Joc0pN
         Q8y/rqOm/k162OhLJt5NukWcV/2Zy8EoIbUmD89oN3/r3d2OtoCpSR2+DjWXwK5G9A
         j/OYm8uJ/Z5xQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Philipp Zabel <p.zabel@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.12 015/102] reset: ti-syscon: fix to_ti_syscon_reset_data macro
Date:   Wed, 14 Jul 2021 15:39:08 -0400
Message-Id: <20210714194036.53141-15-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714194036.53141-1-sashal@kernel.org>
References: <20210714194036.53141-1-sashal@kernel.org>
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
index 218370faf37b..2b92775d58f0 100644
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

