Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8BFA32E93D
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:33:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230118AbhCEMbj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:31:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:41564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231489AbhCEMbO (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:31:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D2ECB6501A;
        Fri,  5 Mar 2021 12:31:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614947474;
        bh=jtmvNCMSLiFnha0mvyrxJiLQ8NGGtkXO/CgxslNA8RA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l91PGBHkTm24oZHT7AvhFM3VDV5+FIl08sgyKYvZuHILrwhnJnskzWRPLrehbZliJ
         Xzg0R6JVeQ79Tsi2FhMo1VAOWwA1keU9YgouYA/8RxX07I+d4WtKXOxekuAaxrQ7cK
         qRs8720qYfVhRJtqj9kUOzfxBpOGOO/U3n+GY40E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Di Zhu <zhudi21@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 048/102] pktgen: fix misuse of BUG_ON() in pktgen_thread_worker()
Date:   Fri,  5 Mar 2021 13:21:07 +0100
Message-Id: <20210305120905.658146241@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210305120903.276489876@linuxfoundation.org>
References: <20210305120903.276489876@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Di Zhu <zhudi21@huawei.com>

[ Upstream commit 275b1e88cabb34dbcbe99756b67e9939d34a99b6 ]

pktgen create threads for all online cpus and bond these threads to
relevant cpu repecivtily. when this thread firstly be woken up, it
will compare cpu currently running with the cpu specified at the time
of creation and if the two cpus are not equal, BUG_ON() will take effect
causing panic on the system.
Notice that these threads could be migrated to other cpus before start
running because of the cpu hotplug after these threads have created. so the
BUG_ON() used here seems unreasonable and we can replace it with WARN_ON()
to just printf a warning other than panic the system.

Signed-off-by: Di Zhu <zhudi21@huawei.com>
Link: https://lore.kernel.org/r/20210125124229.19334-1-zhudi21@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/pktgen.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/pktgen.c b/net/core/pktgen.c
index 105978604ffd..3fba429f1f57 100644
--- a/net/core/pktgen.c
+++ b/net/core/pktgen.c
@@ -3464,7 +3464,7 @@ static int pktgen_thread_worker(void *arg)
 	struct pktgen_dev *pkt_dev = NULL;
 	int cpu = t->cpu;
 
-	BUG_ON(smp_processor_id() != cpu);
+	WARN_ON(smp_processor_id() != cpu);
 
 	init_waitqueue_head(&t->queue);
 	complete(&t->start_done);
-- 
2.30.1



