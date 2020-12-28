Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77CFD2E650D
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:57:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390509AbgL1NgS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:36:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:35674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390495AbgL1NgS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:36:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0648D20867;
        Mon, 28 Dec 2020 13:36:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162562;
        bh=3pitrn+OSz+zq9Mn/OzSQ97Z+lpLb4gLAO+mHS1U07o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xe3vK3tZSLhgagdhhtFrRZrw0C+ng5H5Dc/8QbTZLTMBpN/js+AwZ+UFqEkxQ7U3P
         CaDWbm+EOdUiQ8M0v8XOm38FUokN2BG+TmMtF7kz6mZg+VY/iRojoFSjJnQCbe5uDU
         a9YMJIzWLuVhbjtU0PT2lW2GqV2FOKbuOs16LqQk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, SeongJae Park <sjpark@amazon.de>,
        Michael Kurth <mku@amazon.de>,
        Pawel Wieczorkiewicz <wipawel@amazon.de>,
        Juergen Gross <jgross@suse.com>
Subject: [PATCH 4.19 341/346] xen/xenbus/xen_bus_type: Support will_handle watch callback
Date:   Mon, 28 Dec 2020 13:51:00 +0100
Message-Id: <20201228124936.237274859@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124919.745526410@linuxfoundation.org>
References: <20201228124919.745526410@linuxfoundation.org>
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
 drivers/xen/xenbus/xenbus.h       |    2 ++
 drivers/xen/xenbus/xenbus_probe.c |    3 ++-
 2 files changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/xen/xenbus/xenbus.h
+++ b/drivers/xen/xenbus/xenbus.h
@@ -44,6 +44,8 @@ struct xen_bus_type {
 	int (*get_bus_id)(char bus_id[XEN_BUS_ID_SIZE], const char *nodename);
 	int (*probe)(struct xen_bus_type *bus, const char *type,
 		     const char *dir);
+	bool (*otherend_will_handle)(struct xenbus_watch *watch,
+				     const char *path, const char *token);
 	void (*otherend_changed)(struct xenbus_watch *watch, const char *path,
 				 const char *token);
 	struct bus_type bus;
--- a/drivers/xen/xenbus/xenbus_probe.c
+++ b/drivers/xen/xenbus/xenbus_probe.c
@@ -136,7 +136,8 @@ static int watch_otherend(struct xenbus_
 		container_of(dev->dev.bus, struct xen_bus_type, bus);
 
 	return xenbus_watch_pathfmt(dev, &dev->otherend_watch,
-				    NULL, bus->otherend_changed,
+				    bus->otherend_will_handle,
+				    bus->otherend_changed,
 				    "%s/%s", dev->otherend, "state");
 }
 


