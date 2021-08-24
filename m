Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD4243F64F4
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:08:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239283AbhHXRI4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:08:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:46256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239367AbhHXRGz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:06:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3A1BC619EE;
        Tue, 24 Aug 2021 16:59:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824392;
        bh=3AlQTigumnT1uHdisyjRTr/f2fpblGxAwchy2ZdM4Hg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ivtwmZ7XRXsCznqvXIv/3V2daS5C2aqGsAW8VL9j4YKNhqQHKaEKRFF+Q/rHj66B8
         MgdfrOhe0DC3I/Xml4n+FeqwC8qfBaI2SzBS90GxHT17YvhOZL/Ld55GLY6vKPwXlt
         mf/O9uOVUN6DhuIX8XjoDOMs9StxJ/bdqjBV8avo3Y3HOiXgTmWw1eHJnm/LjoJoL1
         JeDsFM2eqHA7Ot85/GOg1NUtDraPN44Lcmhv2USobzTdv09t3SAfyQe0u6SQgVVEmy
         yAuVbKP2xKDMPJVBOxn3eiyK33ld18f7HY9GR3J09CLNT2sTuCfh8bUliolJtbswRr
         pRf5E1uwHCmvw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tony Lindgren <tony@atomide.com>, Pavel Machek <pavel@denx.de>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Jarkko Nikula <jarkko.nikula@bitmer.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 42/98] bus: ti-sysc: Fix error handling for sysc_check_active_timer()
Date:   Tue, 24 Aug 2021 12:58:12 -0400
Message-Id: <20210824165908.709932-43-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824165908.709932-1-sashal@kernel.org>
References: <20210824165908.709932-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.61-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.61-rc1
X-KernelTest-Deadline: 2021-08-26T16:58+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit 06a089ef644934372a3062528244fca3417d3430 ]

We have changed the return type for sysc_check_active_timer() from -EBUSY
to -ENXIO, but the gpt12 system timer fix still checks for -EBUSY. We are
also not returning on other errors like we did earlier as noted by
Pavel Machek <pavel@denx.de>.

Commit 3ff340e24c9d ("bus: ti-sysc: Fix gpt12 system timer issue with
reserved status") should have been updated for commit 65fb73676112
("bus: ti-sysc: suppress err msg for timers used as clockevent/source").

Let's fix the issue by checking for -ENXIO and returning on any other
errors as suggested by Pavel Machek <pavel@denx.de>.

Fixes: 3ff340e24c9d ("bus: ti-sysc: Fix gpt12 system timer issue with reserved status")
Depends-on: 65fb73676112 ("bus: ti-sysc: suppress err msg for timers used as clockevent/source")
Reported-by: Pavel Machek <pavel@denx.de>
Reviewed-by: Pavel Machek (CIP) <pavel@denx.de>
Cc: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: Jarkko Nikula <jarkko.nikula@bitmer.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/ti-sysc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/bus/ti-sysc.c b/drivers/bus/ti-sysc.c
index c3d8d44f28d7..159b57c6dc4d 100644
--- a/drivers/bus/ti-sysc.c
+++ b/drivers/bus/ti-sysc.c
@@ -3061,8 +3061,10 @@ static int sysc_probe(struct platform_device *pdev)
 		return error;
 
 	error = sysc_check_active_timer(ddata);
-	if (error == -EBUSY)
+	if (error == -ENXIO)
 		ddata->reserved = true;
+	else if (error)
+		return error;
 
 	error = sysc_get_clocks(ddata);
 	if (error)
-- 
2.30.2

