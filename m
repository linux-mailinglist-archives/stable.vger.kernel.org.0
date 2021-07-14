Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E95DA3C8FD5
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:59:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240452AbhGNTxZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:53:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:46242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240507AbhGNTtu (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:49:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3A703613F4;
        Wed, 14 Jul 2021 19:45:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291931;
        bh=wzFNLVPeIlQlLrIQZ3+S8W4G1Mep2IE4KMTCFszJ1gQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aYqyt0x8oc54jMHIK5MABAU5/Dw3YTsDOjNYPJLIyDGxiWwm6Bc21KnMCIR8/WJ2+
         rfDH7bf8eHPlp0Zcd86qPK9gXg5J+KB4nMvfP6EgTUq68EM7GCQl/zMYXJFfAtRqKg
         RwQtE/cTbcRls/dPN4F2D/Wg795Mi/iqHCPCnoFoy5yptTJ/BmVz/uoML4JLngZsOh
         6H9IG4/1Lxmt1vhgYvjKs8mBhGBJEvxRC+14TaE5D+JH6Jza2yiDTvV7HQvOWxN3Th
         BORReIrBDkPBTmVlpwVr4tEaeVvFNugWjR/+0+HmMa5eXpRDN/cQAVHTatl9h2Y1dg
         jftX4YTSo0p+g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Philipp Zabel <p.zabel@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 12/51] reset: ti-syscon: fix to_ti_syscon_reset_data macro
Date:   Wed, 14 Jul 2021 15:44:34 -0400
Message-Id: <20210714194513.54827-12-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714194513.54827-1-sashal@kernel.org>
References: <20210714194513.54827-1-sashal@kernel.org>
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

