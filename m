Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F2FA14812A
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:17:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390527AbgAXLRh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:17:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:54604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390522AbgAXLRg (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:17:36 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CF6F220704;
        Fri, 24 Jan 2020 11:17:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579864656;
        bh=rO20ReY0D17Z08+D6hDKugrRpVERf/wymJFyg4vn6yo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HlhTOHoXxr8+w+qzHzT3mTm1MC8VCWCSo1/NX2VFCBwHzbgbZwRM9T1sRpYQn+7xE
         4TqoBAficnU/RGPv1znjwYYrkPUDC5Op5RQfWWu/2j9bIX0qWtWK+RkXsaLn8z6Eac
         Lu/JVoxxVCNG/G+GM1LzHb3G4aKiOzga3sDze8jM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jie Liu <liujie165@huawei.com>,
        Qiang Ning <ningqiang1@huawei.com>,
        Zhiqiang Liu <liuzhiqiang26@huawei.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 315/639] tipc: set sysctl_tipc_rmem and named_timeout right range
Date:   Fri, 24 Jan 2020 10:28:05 +0100
Message-Id: <20200124093126.408794801@linuxfoundation.org>
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

From: Jie Liu <liujie165@huawei.com>

[ Upstream commit 4bcd4ec1017205644a2697bccbc3b5143f522f5f ]

We find that sysctl_tipc_rmem and named_timeout do not have the right minimum
setting. sysctl_tipc_rmem should be larger than zero, like sysctl_tcp_rmem.
And named_timeout as a timeout setting should be not less than zero.

Fixes: cc79dd1ba9c10 ("tipc: change socket buffer overflow control to respect sk_rcvbuf")
Fixes: a5325ae5b8bff ("tipc: add name distributor resiliency queue")
Signed-off-by: Jie Liu <liujie165@huawei.com>
Reported-by: Qiang Ning <ningqiang1@huawei.com>
Reviewed-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tipc/sysctl.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/tipc/sysctl.c b/net/tipc/sysctl.c
index 1a779b1e85100..40f6d82083d7b 100644
--- a/net/tipc/sysctl.c
+++ b/net/tipc/sysctl.c
@@ -37,6 +37,8 @@
 
 #include <linux/sysctl.h>
 
+static int zero;
+static int one = 1;
 static struct ctl_table_header *tipc_ctl_hdr;
 
 static struct ctl_table tipc_table[] = {
@@ -45,14 +47,16 @@ static struct ctl_table tipc_table[] = {
 		.data		= &sysctl_tipc_rmem,
 		.maxlen		= sizeof(sysctl_tipc_rmem),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1         = &one,
 	},
 	{
 		.procname	= "named_timeout",
 		.data		= &sysctl_tipc_named_timeout,
 		.maxlen		= sizeof(sysctl_tipc_named_timeout),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1         = &zero,
 	},
 	{}
 };
-- 
2.20.1



