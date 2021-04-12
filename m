Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DD9A35BE1A
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 10:56:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238788AbhDLI46 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 04:56:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:46690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238869AbhDLIzI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 04:55:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9A2C56135C;
        Mon, 12 Apr 2021 08:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217604;
        bh=frdF8M4X2fy+10Gp7tFNWmoY2xvOCK0S4zLMJ7tAeI4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=in/06KlMvtUCSX6fhgioAi9lkPAuLRHZ0lmUYPCQ26KnEAzO4uOdc1IWTfN+3irph
         IXCuKqejp1ZOO7vrFgqvfYIHDKfYgbJfek0JJ5aCgLh+h4tfEYoPZtuAntz1kKb/xQ
         midEQBdTYSsenFSvcDp3ThOR9MGASWgW9QyJvHpM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Saravana Kannan <saravanak@google.com>
Subject: [PATCH 5.10 077/188] driver core: Fix locking bug in deferred_probe_timeout_work_func()
Date:   Mon, 12 Apr 2021 10:39:51 +0200
Message-Id: <20210412084016.216762765@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084013.643370347@linuxfoundation.org>
References: <20210412084013.643370347@linuxfoundation.org>
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
@@ -292,14 +292,16 @@ int driver_deferred_probe_check_state(st
 
 static void deferred_probe_timeout_work_func(struct work_struct *work)
 {
-	struct device_private *private, *p;
+	struct device_private *p;
 
 	driver_deferred_probe_timeout = 0;
 	driver_deferred_probe_trigger();
 	flush_work(&deferred_probe_work);
 
-	list_for_each_entry_safe(private, p, &deferred_probe_pending_list, deferred_probe)
-		dev_info(private->device, "deferred probe pending\n");
+	mutex_lock(&deferred_probe_mutex);
+	list_for_each_entry(p, &deferred_probe_pending_list, deferred_probe)
+		dev_info(p->device, "deferred probe pending\n");
+	mutex_unlock(&deferred_probe_mutex);
 	wake_up_all(&probe_timeout_waitqueue);
 }
 static DECLARE_DELAYED_WORK(deferred_probe_timeout_work, deferred_probe_timeout_work_func);


