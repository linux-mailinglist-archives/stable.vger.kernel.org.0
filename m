Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC83B3C909E
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 22:02:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239828AbhGNTzr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:55:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:44850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241258AbhGNTu3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:50:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BBA1E60FF2;
        Wed, 14 Jul 2021 19:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626292054;
        bh=qVR5cTcj82tY3+nCt+CucjDK6kDSVVx4WNl1E5lKETY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RjnMcDcZOaDIWzVQWqiQW6/9794jpeUMLLmVKgnhxOZn6r5nd4wgv6sgzF2Wa0SXL
         OblEHrDnNve3sFLRbEurzzoikNA1UCAi3uaoPMjfwhz+WPiaTE4rhshV/PyQ9c9/Cu
         J6FFvMPHpL5FbXrvpoUY7oosGKr+pk/leXEd9wn9uKDq71/bJawtQg93qN7pEiR8Kt
         9UxBrFkvcAP0Pn3RA2Es7lnrbDqB/276b8qNkJc6djATdX9O1UpfaNitRhtl9CK7Cp
         1f8QoYUuGDUD/UombGikXjI3JonAXNry7+XT3dp+UyJ2O20/6SLQaBdWqHU1ie3StH
         lJ0tO7i0GeEoA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Philipp Zabel <p.zabel@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 07/28] reset: ti-syscon: fix to_ti_syscon_reset_data macro
Date:   Wed, 14 Jul 2021 15:47:02 -0400
Message-Id: <20210714194723.55677-7-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714194723.55677-1-sashal@kernel.org>
References: <20210714194723.55677-1-sashal@kernel.org>
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
index 99520b0a1329..3d375747c4e6 100644
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

