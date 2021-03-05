Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDA0032E82A
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:25:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229493AbhCEMZR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:25:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:60044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231223AbhCEMZE (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:25:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0CD2865028;
        Fri,  5 Mar 2021 12:25:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614947104;
        bh=jtmvNCMSLiFnha0mvyrxJiLQ8NGGtkXO/CgxslNA8RA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gOeZsB908zXygmIkDaWm8glR9HJT6llyCfNyT42wReiz7rOxez3h48YyYJVsxt2tf
         gMDJ35CixZK7qkMTWQixWSvcsPCdeXRhd5sqns6WXxYfvfL4Nt+IJd/V6r/pSCh3Ue
         hwh+R1Kt3oZqL62DjwdhxhEzvUZ6sGLVeEIrRgS4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Di Zhu <zhudi21@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 049/104] pktgen: fix misuse of BUG_ON() in pktgen_thread_worker()
Date:   Fri,  5 Mar 2021 13:20:54 +0100
Message-Id: <20210305120905.572460103@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210305120903.166929741@linuxfoundation.org>
References: <20210305120903.166929741@linuxfoundation.org>
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



