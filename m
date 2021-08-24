Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB2553F664C
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:22:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239500AbhHXRWS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:22:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:56900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241072AbhHXRTz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:19:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DE5E761AF7;
        Tue, 24 Aug 2021 17:03:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824592;
        bh=/1KCBuAms3b1aWl2Q1R77gjYjw+DWezUpQrbs3Fpw5k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kNZQPrMbtJeMS3m2aea91USlNnrwgkbuecYLhgP10kb/EsDXkAlq8zbC24asiJizD
         udTldoLZiEtsnZkamj06C4rqZINAf9sCeYBaaFUi23C9J4xaBY4BNj4GaMFHXecxtq
         KQqIZINb9BQE9ulYcf42vEENZFa2HV4yOV1tGTFNJYXGS7AbxYXaoVGO+JnAbqbw2z
         zDlf5Ds6pw/g+0YYT5TCYO6pyufdDy37l81s9ikWS+d/TouNrHG1vvkMmHcC/RSVKt
         XXLihd16e/9359zFLPM5WO70pY05HKylXOcUVB8WLK07RhvPvj3jPfT69jiJ09R7XN
         cWnk4fJiKC2OQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 21/84] net: igmp: increase size of mr_ifc_count
Date:   Tue, 24 Aug 2021 13:01:47 -0400
Message-Id: <20210824170250.710392-22-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824170250.710392-1-sashal@kernel.org>
References: <20210824170250.710392-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.205-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.205-rc1
X-KernelTest-Deadline: 2021-08-26T17:02+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit b69dd5b3780a7298bd893816a09da751bc0636f7 ]

Some arches support cmpxchg() on 4-byte and 8-byte only.
Increase mr_ifc_count width to 32bit to fix this problem.

Fixes: 4a2b285e7e10 ("net: igmp: fix data-race in igmp_ifc_timer_expire()")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20210811195715.3684218-1-eric.dumazet@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/inetdevice.h | 2 +-
 net/ipv4/igmp.c            | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/inetdevice.h b/include/linux/inetdevice.h
index a64f21a97369..131f93f8d587 100644
--- a/include/linux/inetdevice.h
+++ b/include/linux/inetdevice.h
@@ -41,7 +41,7 @@ struct in_device {
 	unsigned long		mr_qri;		/* Query Response Interval */
 	unsigned char		mr_qrv;		/* Query Robustness Variable */
 	unsigned char		mr_gq_running;
-	unsigned char		mr_ifc_count;
+	u32			mr_ifc_count;
 	struct timer_list	mr_gq_timer;	/* general query timer */
 	struct timer_list	mr_ifc_timer;	/* interface change timer */
 
diff --git a/net/ipv4/igmp.c b/net/ipv4/igmp.c
index 95ec3923083f..dca7fe0ae24a 100644
--- a/net/ipv4/igmp.c
+++ b/net/ipv4/igmp.c
@@ -807,7 +807,7 @@ static void igmp_gq_timer_expire(struct timer_list *t)
 static void igmp_ifc_timer_expire(struct timer_list *t)
 {
 	struct in_device *in_dev = from_timer(in_dev, t, mr_ifc_timer);
-	u8 mr_ifc_count;
+	u32 mr_ifc_count;
 
 	igmpv3_send_cr(in_dev);
 restart:
-- 
2.30.2

