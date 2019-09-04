Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D015EA89E1
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:25:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731239AbfIDP5t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 11:57:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:59472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731632AbfIDP5t (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 11:57:49 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9B18823400;
        Wed,  4 Sep 2019 15:57:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567612669;
        bh=fC9zQTXxaXkLzzBujYFrnT6lf8KESuMXzjNmK1gqNEk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QDxSyMMwKkp+UkEQzXkuCuUsbMK7FlWyRSBzUNwnUt8k29OMa7TGE+YOfZt9eKFp0
         zSz+SLkGrhapq2D6b2299RkGiiKNT7jFu6qmrOMEPW5Z9d3f1R985mNkEzYAgnKnIE
         o6RzqS+OUF8vNODjKiiB+LD7dfdgQu0zuzotJtVY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tony Lindgren <tony@atomide.com>, Roger Quadros <rogerq@ti.com>,
        Suman Anna <s-anna@ti.com>, Keerthy <j-keerthy@ti.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.2 05/94] bus: ti-sysc: Fix handling of forced idle
Date:   Wed,  4 Sep 2019 11:56:10 -0400
Message-Id: <20190904155739.2816-5-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190904155739.2816-1-sashal@kernel.org>
References: <20190904155739.2816-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit 6ee8241d17c68b94a91efabfd6bdfe63bb1b79c1 ]

For some devices we can get the following warning on boot:

ti-sysc 48485200.target-module: sysc_disable_module: invalid midlemode

Fix this by treating SYSC_IDLE_FORCE like we do for the other bits
for idlemodes mask.

Fixes: d59b60564cbf ("bus: ti-sysc: Add generic enable/disable functions")
Cc: Roger Quadros <rogerq@ti.com>
Reviewed-by: Suman Anna <s-anna@ti.com>
Tested-by: Keerthy <j-keerthy@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/ti-sysc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/bus/ti-sysc.c b/drivers/bus/ti-sysc.c
index b72741668c927..f5176a5d38cd9 100644
--- a/drivers/bus/ti-sysc.c
+++ b/drivers/bus/ti-sysc.c
@@ -853,7 +853,7 @@ static int sysc_best_idle_mode(u32 idlemodes, u32 *best_mode)
 		*best_mode = SYSC_IDLE_SMART_WKUP;
 	else if (idlemodes & BIT(SYSC_IDLE_SMART))
 		*best_mode = SYSC_IDLE_SMART;
-	else if (idlemodes & SYSC_IDLE_FORCE)
+	else if (idlemodes & BIT(SYSC_IDLE_FORCE))
 		*best_mode = SYSC_IDLE_FORCE;
 	else
 		return -EINVAL;
-- 
2.20.1

