Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 039323C8EAA
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:46:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238884AbhGNTsr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:48:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:38626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237838AbhGNTrq (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:47:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2A847613F8;
        Wed, 14 Jul 2021 19:43:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291807;
        bh=5TOpWB1pcM8gFuuZ8wVGaPryL5r1nQeuwb5SKodCLUM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cq/FKLkLzilGwQRpnx8t9vjBlJ6C7DhG8bN20gtBKMkj+YSZoNPJhkgOu+34cUb8m
         MLBJTb46krgvj0SjQh5Cbnn8dCqD3Cq4P3IAKSHOmpWM1Tzr9PmhMzRndQl+CtvYG6
         JqkdcF/dcHKB7ZkSk/up/N775NdKdlLQap+PxM9MfP6MXAE7jk9yQbvEph6ifSTz87
         dqFpHJ5kG9WOYxfoV0bhkfxxJBGGMUtQUOZ/2DzcbEK0Q+k7cwm0JkQm+pzCPBt0wz
         LPBwQFejnHPsDNJLk2g4TdetDgbp3A+IOcX00cWvQPQKqJeu+gqCqDc8jWveLudV1V
         4r5eyW2OwwZRg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Philipp Zabel <p.zabel@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.10 14/88] reset: ti-syscon: fix to_ti_syscon_reset_data macro
Date:   Wed, 14 Jul 2021 15:41:49 -0400
Message-Id: <20210714194303.54028-14-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714194303.54028-1-sashal@kernel.org>
References: <20210714194303.54028-1-sashal@kernel.org>
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
index ef97c4dbbb4e..742056a2a756 100644
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

