Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B5CA88E03
	for <lists+stable@lfdr.de>; Sat, 10 Aug 2019 22:51:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726690AbfHJUny (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Aug 2019 16:43:54 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54288 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726634AbfHJUny (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Aug 2019 16:43:54 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDP-00053L-66; Sat, 10 Aug 2019 21:43:51 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDM-0003fo-Eo; Sat, 10 Aug 2019 21:43:48 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Zhiqiang Liu" <liuzhiqiang26@huawei.com>,
        "Jie Liu" <liujie165@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Miaohe Lin" <linmiaohe@huawei.com>,
        "Qiang Ning" <ningqiang1@huawei.com>
Date:   Sat, 10 Aug 2019 21:40:07 +0100
Message-ID: <lsq.1565469607.25428937@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 095/157] tipc: set sysctl_tipc_rmem and named_timeout
 right range
In-Reply-To: <lsq.1565469607.188083258@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.72-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Jie Liu <liujie165@huawei.com>

commit 4bcd4ec1017205644a2697bccbc3b5143f522f5f upstream.

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
[bwh: Backported to 3.16: only the tipc_rmem sysctl exists here]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/net/tipc/sysctl.c
+++ b/net/tipc/sysctl.c
@@ -37,6 +37,7 @@
 
 #include <linux/sysctl.h>
 
+static int one = 1;
 static struct ctl_table_header *tipc_ctl_hdr;
 
 static struct ctl_table tipc_table[] = {
@@ -45,7 +46,8 @@ static struct ctl_table tipc_table[] = {
 		.data		= &sysctl_tipc_rmem,
 		.maxlen		= sizeof(sysctl_tipc_rmem),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1         = &one,
 	},
 	{}
 };

