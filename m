Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5FB22DEFB5
	for <lists+stable@lfdr.de>; Sat, 19 Dec 2020 14:08:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727628AbgLSNH2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Dec 2020 08:07:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:45032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727536AbgLSM62 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 19 Dec 2020 07:58:28 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jianguo Wu <wujianguo@chinatelecom.cn>,
        Florian Westphal <fw@strlen.de>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.9 13/49] mptcp: print new line in mptcp_seq_show() if mptcp isnt in use
Date:   Sat, 19 Dec 2020 13:58:17 +0100
Message-Id: <20201219125345.327202354@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201219125344.671832095@linuxfoundation.org>
References: <20201219125344.671832095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jianguo Wu <wujianguo@chinatelecom.cn>

[ Upstream commit f55628b3e7648198e9c072b52080c5dea8678adf ]

When do cat /proc/net/netstat, the output isn't append with a new line, it looks like this:
[root@localhost ~]# cat /proc/net/netstat
...
MPTcpExt: 0 0 0 0 0 0 0 0 0 0 0 0 0[root@localhost ~]#

This is because in mptcp_seq_show(), if mptcp isn't in use, net->mib.mptcp_statistics is NULL,
so it just puts all 0 after "MPTcpExt:", and return, forgot the '\n'.

After this patch:

[root@localhost ~]# cat /proc/net/netstat
...
MPTcpExt: 0 0 0 0 0 0 0 0 0 0 0 0 0
[root@localhost ~]#

Fixes: fc518953bc9c8d7d ("mptcp: add and use MIB counter infrastructure")
Signed-off-by: Jianguo Wu <wujianguo@chinatelecom.cn>
Acked-by: Florian Westphal <fw@strlen.de>
Link: https://lore.kernel.org/r/142e2fd9-58d9-bb13-fb75-951cccc2331e@163.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/mib.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/mptcp/mib.c
+++ b/net/mptcp/mib.c
@@ -58,6 +58,7 @@ void mptcp_seq_show(struct seq_file *seq
 		for (i = 0; mptcp_snmp_list[i].name; i++)
 			seq_puts(seq, " 0");
 
+		seq_putc(seq, '\n');
 		return;
 	}
 


