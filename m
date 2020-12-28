Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54EEF2E68BF
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:42:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729193AbgL1M6h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 07:58:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:54934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728162AbgL1M6h (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 07:58:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B1F3B22573;
        Mon, 28 Dec 2020 12:57:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609160276;
        bh=ZhPJvr4T5Hc51Jhsmbvw8vrcuIYjwobBSzb5/C5zD2Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GD/AOkMRbe/eXitbUba25C02f0sPMshZyGHdmMHbauQcRxeCzj01Fnc1JWi1HSXYg
         YThFKEEIz45yAGCmgMibGCU2JH7ZyNPQ0yBKSBH9j0oJVJObgTpszDdpPDOj8nbGby
         NpuT8lJDLtaweaR11CHKHnGwPC4suaeRk1zdj6SA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, SeongJae Park <sjpark@amazon.de>,
        Michael Kurth <mku@amazon.de>,
        Pawel Wieczorkiewicz <wipawel@amazon.de>,
        Juergen Gross <jgross@suse.com>
Subject: [PATCH 4.4 129/132] xen/xenbus/xen_bus_type: Support will_handle watch callback
Date:   Mon, 28 Dec 2020 13:50:13 +0100
Message-Id: <20201228124852.641102092@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124846.409999325@linuxfoundation.org>
References: <20201228124846.409999325@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: SeongJae Park <sjpark@amazon.de>

commit be987200fbaceaef340872841d4f7af2c5ee8dc3 upstream.

This commit adds support of the 'will_handle' watch callback for
'xen_bus_type' users.

This is part of XSA-349

Cc: stable@vger.kernel.org
Signed-off-by: SeongJae Park <sjpark@amazon.de>
Reported-by: Michael Kurth <mku@amazon.de>
Reported-by: Pawel Wieczorkiewicz <wipawel@amazon.de>
Reviewed-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 drivers/xen/xenbus/xenbus_probe.c |    3 ++-
 drivers/xen/xenbus/xenbus_probe.h |    2 ++
 2 files changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/xen/xenbus/xenbus_probe.c
+++ b/drivers/xen/xenbus/xenbus_probe.c
@@ -137,7 +137,8 @@ static int watch_otherend(struct xenbus_
 		container_of(dev->dev.bus, struct xen_bus_type, bus);
 
 	return xenbus_watch_pathfmt(dev, &dev->otherend_watch,
-				    NULL, bus->otherend_changed,
+				    bus->otherend_will_handle,
+				    bus->otherend_changed,
 				    "%s/%s", dev->otherend, "state");
 }
 
--- a/drivers/xen/xenbus/xenbus_probe.h
+++ b/drivers/xen/xenbus/xenbus_probe.h
@@ -42,6 +42,8 @@ struct xen_bus_type {
 	int (*get_bus_id)(char bus_id[XEN_BUS_ID_SIZE], const char *nodename);
 	int (*probe)(struct xen_bus_type *bus, const char *type,
 		     const char *dir);
+	bool (*otherend_will_handle)(struct xenbus_watch *watch,
+				     const char **vec, unsigned int len);
 	void (*otherend_changed)(struct xenbus_watch *watch, const char **vec,
 				 unsigned int len);
 	struct bus_type bus;


