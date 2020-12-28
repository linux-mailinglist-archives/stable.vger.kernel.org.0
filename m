Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1F932E668E
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:14:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732888AbgL1QOQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 11:14:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:47572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732996AbgL1NTQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:19:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 760D8208D5;
        Mon, 28 Dec 2020 13:19:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609161541;
        bh=+pSnwWsCMByYdsFsfpHiPyCaC6g7YzUC9AlAXhW96sA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DAA9kyO5XZ30sWVgl3pQjjSXCRmJDtEtFLmJVo+muO0ekHhh10i4pa6Kp/PivxpUA
         qYIpx8+8cvPBGdwxswRH8+OHTS9yfJLZ/3zHCUtqRQbWXVUTL0pjl9q+ugqx7UDK7W
         5+ijhecpgIZmapBjjTcmI1xA+ywxT5Gfokn28l3s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, SeongJae Park <sjpark@amazon.de>,
        Michael Kurth <mku@amazon.de>,
        Pawel Wieczorkiewicz <wipawel@amazon.de>,
        Juergen Gross <jgross@suse.com>
Subject: [PATCH 4.14 240/242] xenbus/xenbus_backend: Disallow pending watch messages
Date:   Mon, 28 Dec 2020 13:50:45 +0100
Message-Id: <20201228124916.501288077@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124904.654293249@linuxfoundation.org>
References: <20201228124904.654293249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: SeongJae Park <sjpark@amazon.de>

commit 9996bd494794a2fe393e97e7a982388c6249aa76 upstream.

'xenbus_backend' watches 'state' of devices, which is writable by
guests.  Hence, if guests intensively updates it, dom0 will have lots of
pending events that exhausting memory of dom0.  In other words, guests
can trigger dom0 memory pressure.  This is known as XSA-349.  However,
the watch callback of it, 'frontend_changed()', reads only 'state', so
doesn't need to have the pending events.

To avoid the problem, this commit disallows pending watch messages for
'xenbus_backend' using the 'will_handle()' watch callback.

This is part of XSA-349

Cc: stable@vger.kernel.org
Signed-off-by: SeongJae Park <sjpark@amazon.de>
Reported-by: Michael Kurth <mku@amazon.de>
Reported-by: Pawel Wieczorkiewicz <wipawel@amazon.de>
Reviewed-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/xen/xenbus/xenbus_probe_backend.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/xen/xenbus/xenbus_probe_backend.c
+++ b/drivers/xen/xenbus/xenbus_probe_backend.c
@@ -180,6 +180,12 @@ static int xenbus_probe_backend(struct x
 	return err;
 }
 
+static bool frontend_will_handle(struct xenbus_watch *watch,
+				 const char *path, const char *token)
+{
+	return watch->nr_pending == 0;
+}
+
 static void frontend_changed(struct xenbus_watch *watch,
 			     const char *path, const char *token)
 {
@@ -191,6 +197,7 @@ static struct xen_bus_type xenbus_backen
 	.levels = 3,		/* backend/type/<frontend>/<id> */
 	.get_bus_id = backend_bus_id,
 	.probe = xenbus_probe_backend,
+	.otherend_will_handle = frontend_will_handle,
 	.otherend_changed = frontend_changed,
 	.bus = {
 		.name		= "xen-backend",


