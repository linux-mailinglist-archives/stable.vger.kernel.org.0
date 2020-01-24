Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 143A0148344
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:35:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404737AbgAXLen (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:34:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:54668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404747AbgAXLen (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:34:43 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 84AA8222D9;
        Fri, 24 Jan 2020 11:34:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579865683;
        bh=gt9bph1GrJGHkztpsT4H/EYp/BQ6SfJCH9lx63DYKUs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UUEIoMe7mgdFWln8kMl0dYoqn4RywPAP+2oXn3LtClqjaF9D1PYvh5Z/KHvaJMSqS
         0Tnej3JEw2hP21+/4wtWyI7JdOwHsIuZ1yFJ8ZYihd6Zdm4lH8q9RacF4uOro47mpt
         lDudG51o3aAdWq9j5zSIR+i4pcn/ehvcGmXL7NvY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 598/639] act_mirred: Fix mirred_init_module error handling
Date:   Fri, 24 Jan 2020 10:32:48 +0100
Message-Id: <20200124093204.256421216@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit 11c9a7d38af524217efb7a176ad322b97ac2f163 ]

If tcf_register_action failed, mirred_device_notifier
should be unregistered.

Fixes: 3b87956ea645 ("net sched: fix race in mirred device removal")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/act_mirred.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/sched/act_mirred.c b/net/sched/act_mirred.c
index 399e3beae6cf4..a30c17a282819 100644
--- a/net/sched/act_mirred.c
+++ b/net/sched/act_mirred.c
@@ -445,7 +445,11 @@ static int __init mirred_init_module(void)
 		return err;
 
 	pr_info("Mirror/redirect action on\n");
-	return tcf_register_action(&act_mirred_ops, &mirred_net_ops);
+	err = tcf_register_action(&act_mirred_ops, &mirred_net_ops);
+	if (err)
+		unregister_netdevice_notifier(&mirred_device_notifier);
+
+	return err;
 }
 
 static void __exit mirred_cleanup_module(void)
-- 
2.20.1



