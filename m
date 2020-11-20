Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71B782BA82E
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 12:05:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728102AbgKTLFN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Nov 2020 06:05:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:52918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728124AbgKTLFM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Nov 2020 06:05:12 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 239A6206E3;
        Fri, 20 Nov 2020 11:05:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1605870311;
        bh=AZLsmIPNPAilBs+BoMq2gA0uY08IdxmkzWMcW4lV+XY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aXdKzxxBRaIoNJlOijtYdMR2KKLC9GUFj20bsyL0yrT2oBp7F2HI5p/bvLe2z/RbT
         EMgxLiyrkKv2bkiZoU3x85rcuqy0yg5dOhFSBz/F9vgEoniJZ5h9yDGRBmaNY2oWyg
         +AQWdtSyubOOshgToBfFteWgpUz3NpvhNbyT02WA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Zhang Changzhong <zhangchangzhong@huawei.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 4.14 15/17] can: proc: can_remove_proc(): silence remove_proc_entry warning
Date:   Fri, 20 Nov 2020 12:03:26 +0100
Message-Id: <20201120104541.164938956@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201120104540.414709708@linuxfoundation.org>
References: <20201120104540.414709708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Changzhong <zhangchangzhong@huawei.com>

commit 3accbfdc36130282f5ae9e6eecfdf820169fedce upstream.

If can_init_proc() fail to create /proc/net/can directory, can_remove_proc()
will trigger a warning:

WARNING: CPU: 6 PID: 7133 at fs/proc/generic.c:672 remove_proc_entry+0x17b0
Kernel panic - not syncing: panic_on_warn set ...

Fix to return early from can_remove_proc() if can proc_dir does not exists.

Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
Link: https://lore.kernel.org/r/1594709090-3203-1-git-send-email-zhangchangzhong@huawei.com
Fixes: 8e8cda6d737d ("can: initial support for network namespaces")
Acked-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/can/proc.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/net/can/proc.c
+++ b/net/can/proc.c
@@ -554,6 +554,9 @@ void can_init_proc(struct net *net)
  */
 void can_remove_proc(struct net *net)
 {
+	if (!net->can.proc_dir)
+		return;
+
 	if (net->can.pde_version)
 		remove_proc_entry(CAN_PROC_VERSION, net->can.proc_dir);
 
@@ -581,6 +584,5 @@ void can_remove_proc(struct net *net)
 	if (net->can.pde_rcvlist_sff)
 		remove_proc_entry(CAN_PROC_RCVLIST_SFF, net->can.proc_dir);
 
-	if (net->can.proc_dir)
-		remove_proc_entry("can", net->proc_net);
+	remove_proc_entry("can", net->proc_net);
 }


