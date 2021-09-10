Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 367284063A6
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:50:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232460AbhIJAsS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:48:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:49792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234848AbhIJAYm (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:24:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 60CB7611BF;
        Fri, 10 Sep 2021 00:23:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233412;
        bh=2MjKKLz7JzePmBVcQDgPEuCsbqkT4iHdNk9yelbTGWk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CCsx7xpCr6g88miLZiMbIAMqW/KeFbGynaKDu/fWPrm9nB4OTJM5+18BO73W6XUAM
         N6B3hGIBLx8tT39U6qO2SJwAEJUpwPmw2nJzZxUh5Tq4FabdXG9MV6yu5GJo7goXnh
         3kwR9u9TFP88/S34OmmWGrs3eRnMyBjoHkakS0mN9JB+p+A1oB/0WnfAd6ZzKJw+mo
         OR/WXihDPMlVjqNlN2VmLX4bELQeD8K4X9YoBAO6UXyFDESmiZsaV1g+xGL19VW6ig
         dj+3VdHVzJPFgJlLXnmUiNI0JHN0YD2xNwAzA+ZPx2VuIPEt+JPzJHkG7jWUieO9vG
         ZJAN/noPlfI7A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Juergen Gross <jgross@suse.com>, Sasha Levin <sashal@kernel.org>,
        xen-devel@lists.xenproject.org
Subject: [PATCH AUTOSEL 4.14 16/19] xen: remove stray preempt_disable() from PV AP startup code
Date:   Thu,  9 Sep 2021 20:23:06 -0400
Message-Id: <20210910002309.176412-16-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910002309.176412-1-sashal@kernel.org>
References: <20210910002309.176412-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Juergen Gross <jgross@suse.com>

[ Upstream commit 58e636039b512697554b579c2bb23774061877f5 ]

In cpu_bringup() there is a call of preempt_disable() without a paired
preempt_enable(). This is not needed as interrupts are off initially.
Additionally this will result in early boot messages like:

BUG: scheduling while atomic: swapper/1/0/0x00000002

Signed-off-by: Juergen Gross <jgross@suse.com>
Link: https://lore.kernel.org/r/20210825113158.11716-1-jgross@suse.com
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/xen/smp_pv.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/xen/smp_pv.c b/arch/x86/xen/smp_pv.c
index f779d2a5b04c..44468d6fa188 100644
--- a/arch/x86/xen/smp_pv.c
+++ b/arch/x86/xen/smp_pv.c
@@ -59,7 +59,6 @@ static void cpu_bringup(void)
 
 	cpu_init();
 	touch_softlockup_watchdog();
-	preempt_disable();
 
 	/* PVH runs in ring 0 and allows us to do native syscalls. Yay! */
 	if (!xen_feature(XENFEAT_supervisor_mode_kernel)) {
-- 
2.30.2

