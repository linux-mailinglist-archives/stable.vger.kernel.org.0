Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EB192BA852
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 12:09:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728393AbgKTLG1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Nov 2020 06:06:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:54134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728383AbgKTLGX (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Nov 2020 06:06:23 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2E2242240C;
        Fri, 20 Nov 2020 11:06:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1605870382;
        bh=+OEMdV7f+aW1tiV8eTWtyPfHVbglZl1WZyyVr6W4+CU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xjqzmHQIHzOzqiq6pRyZUCni/5HKHJf3xFDLLzkXPyR283OyPrmfSjSnMBSMeozDW
         yXP/U+UeuPLXabl9uc9Al1l0C6EI7lDqeXQMApz+MyJjj0ZNhQ0gx2GdDtJQphF7+e
         M2UOMqB0Wc7ZMvTmR4TFr69WlJ8Fby8d/JtPHa0Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Zhang Changzhong <zhangchangzhong@huawei.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 4.19 12/14] can: proc: can_remove_proc(): silence remove_proc_entry warning
Date:   Fri, 20 Nov 2020 12:03:33 +0100
Message-Id: <20201120104540.420581857@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201120104539.806156260@linuxfoundation.org>
References: <20201120104539.806156260@linuxfoundation.org>
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
@@ -467,6 +467,9 @@ void can_init_proc(struct net *net)
  */
 void can_remove_proc(struct net *net)
 {
+	if (!net->can.proc_dir)
+		return;
+
 	if (net->can.pde_version)
 		remove_proc_entry(CAN_PROC_VERSION, net->can.proc_dir);
 
@@ -494,6 +497,5 @@ void can_remove_proc(struct net *net)
 	if (net->can.pde_rcvlist_sff)
 		remove_proc_entry(CAN_PROC_RCVLIST_SFF, net->can.proc_dir);
 
-	if (net->can.proc_dir)
-		remove_proc_entry("can", net->proc_net);
+	remove_proc_entry("can", net->proc_net);
 }


