Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C719B6675B4
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:24:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236441AbjALOYC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:24:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236806AbjALOXV (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:23:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACF6259D3B
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:14:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6B9FAB81DCC
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:14:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3911C433D2;
        Thu, 12 Jan 2023 14:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673532891;
        bh=iR9CSVL3OzO/45l3jpkdubm5TVK9SuUA7NkwndLpoqg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2KjHBZgqZ0ll8Kx5nXItoesADS+G4A2s8fDopi8I4bPDUI/Z04wk1tFXrc611UrCz
         FH5PLNVZbdWkfPjrfJk+K8vs5EvVSIrfsK4mLW5RRi7loETNxU8hAfoB49J2obrb2V
         uSS164O3Aw15cQ0xEaj7mgN92IZmK9DtOjjevebU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Firo Yang <firo.yang@suse.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 268/783] sctp: sysctl: make extra pointers netns aware
Date:   Thu, 12 Jan 2023 14:49:44 +0100
Message-Id: <20230112135536.844853923@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Firo Yang <firo.yang@suse.com>

[ Upstream commit da05cecc4939c0410d56c29e252998b192756318 ]

Recently, a customer reported that from their container whose
net namespace is different to the host's init_net, they can't set
the container's net.sctp.rto_max to any value smaller than
init_net.sctp.rto_min.

For instance,
Host:
sudo sysctl net.sctp.rto_min
net.sctp.rto_min = 1000

Container:
echo 100 > /mnt/proc-net/sctp/rto_min
echo 400 > /mnt/proc-net/sctp/rto_max
echo: write error: Invalid argument

This is caused by the check made from this'commit 4f3fdf3bc59c
("sctp: add check rto_min and rto_max in sysctl")'
When validating the input value, it's always referring the boundary
value set for the init_net namespace.

Having container's rto_max smaller than host's init_net.sctp.rto_min
does make sense. Consider that the rto between two containers on the
same host is very likely smaller than it for two hosts.

So to fix this problem, as suggested by Marcelo, this patch makes the
extra pointers of rto_min, rto_max, pf_retrans, and ps_retrans point
to the corresponding variables from the newly created net namespace while
the new net namespace is being registered in sctp_sysctl_net_register.

Fixes: 4f3fdf3bc59c ("sctp: add check rto_min and rto_max in sysctl")
Reviewed-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Reviewed-by: Jakub Kicinski <kuba@kernel.org>
Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Signed-off-by: Firo Yang <firo.yang@suse.com>
Link: https://lore.kernel.org/r/20221209054854.23889-1-firo.yang@suse.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/sysctl.c | 73 ++++++++++++++++++++++++++++-------------------
 1 file changed, 44 insertions(+), 29 deletions(-)

diff --git a/net/sctp/sysctl.c b/net/sctp/sysctl.c
index c16c80963e55..e4af050aec1b 100644
--- a/net/sctp/sysctl.c
+++ b/net/sctp/sysctl.c
@@ -79,17 +79,18 @@ static struct ctl_table sctp_table[] = {
 	{ /* sentinel */ }
 };
 
+/* The following index defines are used in sctp_sysctl_net_register().
+ * If you add new items to the sctp_net_table, please ensure that
+ * the index values of these defines hold the same meaning indicated by
+ * their macro names when they appear in sctp_net_table.
+ */
+#define SCTP_RTO_MIN_IDX       0
+#define SCTP_RTO_MAX_IDX       1
+#define SCTP_PF_RETRANS_IDX    2
+#define SCTP_PS_RETRANS_IDX    3
+
 static struct ctl_table sctp_net_table[] = {
-	{
-		.procname	= "rto_initial",
-		.data		= &init_net.sctp.rto_initial,
-		.maxlen		= sizeof(unsigned int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1         = SYSCTL_ONE,
-		.extra2         = &timer_max
-	},
-	{
+	[SCTP_RTO_MIN_IDX] = {
 		.procname	= "rto_min",
 		.data		= &init_net.sctp.rto_min,
 		.maxlen		= sizeof(unsigned int),
@@ -98,7 +99,7 @@ static struct ctl_table sctp_net_table[] = {
 		.extra1         = SYSCTL_ONE,
 		.extra2         = &init_net.sctp.rto_max
 	},
-	{
+	[SCTP_RTO_MAX_IDX] =  {
 		.procname	= "rto_max",
 		.data		= &init_net.sctp.rto_max,
 		.maxlen		= sizeof(unsigned int),
@@ -107,6 +108,33 @@ static struct ctl_table sctp_net_table[] = {
 		.extra1         = &init_net.sctp.rto_min,
 		.extra2         = &timer_max
 	},
+	[SCTP_PF_RETRANS_IDX] = {
+		.procname	= "pf_retrans",
+		.data		= &init_net.sctp.pf_retrans,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= &init_net.sctp.ps_retrans,
+	},
+	[SCTP_PS_RETRANS_IDX] = {
+		.procname	= "ps_retrans",
+		.data		= &init_net.sctp.ps_retrans,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &init_net.sctp.pf_retrans,
+		.extra2		= &ps_retrans_max,
+	},
+	{
+		.procname	= "rto_initial",
+		.data		= &init_net.sctp.rto_initial,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1         = SYSCTL_ONE,
+		.extra2         = &timer_max
+	},
 	{
 		.procname	= "rto_alpha_exp_divisor",
 		.data		= &init_net.sctp.rto_alpha,
@@ -202,24 +230,6 @@ static struct ctl_table sctp_net_table[] = {
 		.extra1		= SYSCTL_ONE,
 		.extra2		= SYSCTL_INT_MAX,
 	},
-	{
-		.procname	= "pf_retrans",
-		.data		= &init_net.sctp.pf_retrans,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= SYSCTL_ZERO,
-		.extra2		= &init_net.sctp.ps_retrans,
-	},
-	{
-		.procname	= "ps_retrans",
-		.data		= &init_net.sctp.ps_retrans,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= &init_net.sctp.pf_retrans,
-		.extra2		= &ps_retrans_max,
-	},
 	{
 		.procname	= "sndbuf_policy",
 		.data		= &init_net.sctp.sndbuf_policy,
@@ -489,6 +499,11 @@ int sctp_sysctl_net_register(struct net *net)
 	for (i = 0; table[i].data; i++)
 		table[i].data += (char *)(&net->sctp) - (char *)&init_net.sctp;
 
+	table[SCTP_RTO_MIN_IDX].extra2 = &net->sctp.rto_max;
+	table[SCTP_RTO_MAX_IDX].extra1 = &net->sctp.rto_min;
+	table[SCTP_PF_RETRANS_IDX].extra2 = &net->sctp.ps_retrans;
+	table[SCTP_PS_RETRANS_IDX].extra1 = &net->sctp.pf_retrans;
+
 	net->sctp.sysctl_header = register_net_sysctl(net, "net/sctp", table);
 	if (net->sctp.sysctl_header == NULL) {
 		kfree(table);
-- 
2.35.1



