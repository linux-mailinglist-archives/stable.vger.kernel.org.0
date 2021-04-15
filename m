Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEA80360D68
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 17:02:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233966AbhDOPCP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 11:02:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:46150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234743AbhDOO7e (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Apr 2021 10:59:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1921261407;
        Thu, 15 Apr 2021 14:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618498545;
        bh=cQU0+XOWp0nJM700UOu15PgUUqFBCwBNwQGEhRmYy+Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zTNs4jouX6vjcDfU9rshbhwTKxzXwCKkfL+beioy3cV8YpGhTN+tgiD76dve4PR6E
         Onl+RAVgBxy31uhBqRPI7YlzMXN2nyjToxcmL7eKQIZ81e6WKoHFkkeWH/Dbq8DQ3S
         kKyS0BpA5+GHANVH8PgYjB13YjXPjqLXErgTyszY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Saravana Kannan <saravanak@google.com>
Subject: [PATCH 4.19 11/13] driver core: Fix locking bug in deferred_probe_timeout_work_func()
Date:   Thu, 15 Apr 2021 16:48:00 +0200
Message-Id: <20210415144411.970293701@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210415144411.596695196@linuxfoundation.org>
References: <20210415144411.596695196@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Saravana Kannan <saravanak@google.com>

commit eed6e41813deb9ee622cd9242341f21430d7789f upstream.

list_for_each_entry_safe() is only useful if we are deleting nodes in a
linked list within the loop. It doesn't protect against other threads
adding/deleting nodes to the list in parallel. We need to grab
deferred_probe_mutex when traversing the deferred_probe_pending_list.

Cc: stable@vger.kernel.org
Fixes: 25b4e70dcce9 ("driver core: allow stopping deferred probe after init")
Signed-off-by: Saravana Kannan <saravanak@google.com>
Link: https://lore.kernel.org/r/20210402040342.2944858-2-saravanak@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/base/dd.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -254,14 +254,16 @@ int driver_deferred_probe_check_state(st
 
 static void deferred_probe_timeout_work_func(struct work_struct *work)
 {
-	struct device_private *private, *p;
+	struct device_private *p;
 
 	deferred_probe_timeout = 0;
 	driver_deferred_probe_trigger();
 	flush_work(&deferred_probe_work);
 
-	list_for_each_entry_safe(private, p, &deferred_probe_pending_list, deferred_probe)
-		dev_info(private->device, "deferred probe pending");
+	mutex_lock(&deferred_probe_mutex);
+	list_for_each_entry(p, &deferred_probe_pending_list, deferred_probe)
+		dev_info(p->device, "deferred probe pending\n");
+	mutex_unlock(&deferred_probe_mutex);
 }
 static DECLARE_DELAYED_WORK(deferred_probe_timeout_work, deferred_probe_timeout_work_func);
 


