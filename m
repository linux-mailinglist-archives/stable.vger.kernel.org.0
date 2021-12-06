Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CF15469B5F
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:13:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359376AbhLFPRK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:17:10 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:34964 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346600AbhLFPOt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:14:49 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 56A08612EB;
        Mon,  6 Dec 2021 15:11:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FE84C341C5;
        Mon,  6 Dec 2021 15:11:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638803479;
        bh=+ES4ZAtP0ze0k3iOABTrk9vvFws3JdOqdRI/dQQ11+Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Aie+rcHxJ3Zmq2adzZhDTnLsW4IxMfQhStJ1WwXxBLBh28+2ZTlhek7MjJY6kEp0h
         KBLd4fj1IRCFyjp77kHV7LzPs54Mj+JavgXrJcznBNpiNUMuLV2Psie2rgaHsUTrmE
         QZDVkmM5f4QSBFFE+i0EdhaHk1defKrvwByCFRAE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ioanna Alifieraki <ioanna-maria.alifieraki@canonical.com>,
        Corey Minyard <cminyard@mvista.com>
Subject: [PATCH 4.19 19/48] ipmi: Move remove_work to dedicated workqueue
Date:   Mon,  6 Dec 2021 15:56:36 +0100
Message-Id: <20211206145549.506806769@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145548.859182340@linuxfoundation.org>
References: <20211206145548.859182340@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ioanna Alifieraki <ioanna-maria.alifieraki@canonical.com>

commit 1d49eb91e86e8c1c1614c72e3e958b6b7e2472a9 upstream.

Currently when removing an ipmi_user the removal is deferred as a work on
the system's workqueue. Although this guarantees the free operation will
occur in non atomic context, it can race with the ipmi_msghandler module
removal (see [1]) . In case a remove_user work is scheduled for removal
and shortly after ipmi_msghandler module is removed we can end up in a
situation where the module is removed fist and when the work is executed
the system crashes with :
BUG: unable to handle page fault for address: ffffffffc05c3450
PF: supervisor instruction fetch in kernel mode
PF: error_code(0x0010) - not-present page
because the pages of the module are gone. In cleanup_ipmi() there is no
easy way to detect if there are any pending works to flush them before
removing the module. This patch creates a separate workqueue and schedules
the remove_work works on it. When removing the module the workqueue is
drained when destroyed to avoid the race.

[1] https://bugs.launchpad.net/bugs/1950666

Cc: stable@vger.kernel.org # 5.1
Fixes: 3b9a907223d7 (ipmi: fix sleep-in-atomic in free_user at cleanup SRCU user->release_barrier)
Signed-off-by: Ioanna Alifieraki <ioanna-maria.alifieraki@canonical.com>
Message-Id: <20211115131645.25116-1-ioanna-maria.alifieraki@canonical.com>
Signed-off-by: Corey Minyard <cminyard@mvista.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/ipmi/ipmi_msghandler.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/drivers/char/ipmi/ipmi_msghandler.c
+++ b/drivers/char/ipmi/ipmi_msghandler.c
@@ -219,6 +219,8 @@ struct ipmi_user {
 	struct work_struct remove_work;
 };
 
+struct workqueue_struct *remove_work_wq;
+
 static struct ipmi_user *acquire_ipmi_user(struct ipmi_user *user, int *index)
 	__acquires(user->release_barrier)
 {
@@ -1207,7 +1209,7 @@ static void free_user(struct kref *ref)
 	struct ipmi_user *user = container_of(ref, struct ipmi_user, refcount);
 
 	/* SRCU cleanup must happen in task context. */
-	schedule_work(&user->remove_work);
+	queue_work(remove_work_wq, &user->remove_work);
 }
 
 static void _ipmi_destroy_user(struct ipmi_user *user)
@@ -5090,6 +5092,13 @@ static int ipmi_init_msghandler(void)
 
 	atomic_notifier_chain_register(&panic_notifier_list, &panic_block);
 
+	remove_work_wq = create_singlethread_workqueue("ipmi-msghandler-remove-wq");
+	if (!remove_work_wq) {
+		pr_err("unable to create ipmi-msghandler-remove-wq workqueue");
+		rv = -ENOMEM;
+		goto out;
+	}
+
 	initialized = true;
 
 out:
@@ -5115,6 +5124,8 @@ static void __exit cleanup_ipmi(void)
 	int count;
 
 	if (initialized) {
+		destroy_workqueue(remove_work_wq);
+
 		atomic_notifier_chain_unregister(&panic_notifier_list,
 						 &panic_block);
 


