Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F35DE31139C
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 22:34:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232250AbhBEVdt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 16:33:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:45592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233019AbhBEPAA (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Feb 2021 10:00:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4024F65052;
        Fri,  5 Feb 2021 14:12:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612534338;
        bh=OCMQnjJPCi1dx8063Pqa+B+Pdskt7p/0dDR+1YtO/bk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1eayAgjLpRfth3mB8RHOikfw9Qr+X0QUHQklUgw5m8ewqqXpPE0SKZQ2AmouTpysF
         8tdZMvYlaquY7OVGFUwm9d7JA+4dfvekuHo/xM16wE3JTfv0xhGLYygAE3wAakkSro
         MEJO3eBzb3mz3/a8laE17FpFVgu+3fxuutv7oXLA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Petr Machata <petrm@nvidia.com>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 02/32] net: switchdev: dont set port_obj_info->handled true when -EOPNOTSUPP
Date:   Fri,  5 Feb 2021 15:07:17 +0100
Message-Id: <20210205140652.456963490@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210205140652.348864025@linuxfoundation.org>
References: <20210205140652.348864025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rasmus Villemoes <rasmus.villemoes@prevas.dk>

commit 20776b465c0c249f5e5b5b4fe077cd24ef1cda86 upstream.

It's not true that switchdev_port_obj_notify() only inspects the
->handled field of "struct switchdev_notifier_port_obj_info" if
call_switchdev_blocking_notifiers() returns 0 - there's a WARN_ON()
triggering for a non-zero return combined with ->handled not being
true. But the real problem here is that -EOPNOTSUPP is not being
properly handled.

The wrapper functions switchdev_handle_port_obj_add() et al change a
return value of -EOPNOTSUPP to 0, and the treatment of ->handled in
switchdev_port_obj_notify() seems to be designed to change that back
to -EOPNOTSUPP in case nobody actually acted on the notifier (i.e.,
everybody returned -EOPNOTSUPP).

Currently, as soon as some device down the stack passes the check_cb()
check, ->handled gets set to true, which means that
switchdev_port_obj_notify() cannot actually ever return -EOPNOTSUPP.

This, for example, means that the detection of hardware offload
support in the MRP code is broken: switchdev_port_obj_add() used by
br_mrp_switchdev_send_ring_test() always returns 0, so since the MRP
code thinks the generation of MRP test frames has been offloaded, no
such frames are actually put on the wire. Similarly,
br_mrp_switchdev_set_ring_role() also always returns 0, causing
mrp->ring_role_offloaded to be set to 1.

To fix this, continue to set ->handled true if any callback returns
success or any error distinct from -EOPNOTSUPP. But if all the
callbacks return -EOPNOTSUPP, make sure that ->handled stays false, so
the logic in switchdev_port_obj_notify() can propagate that
information.

Fixes: 9a9f26e8f7ea ("bridge: mrp: Connect MRP API with the switchdev API")
Fixes: f30f0601eb93 ("switchdev: Add helpers to aid traversal through lower devices")
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Link: https://lore.kernel.org/r/20210125124116.102928-1-rasmus.villemoes@prevas.dk
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/switchdev/switchdev.c |   23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

--- a/net/switchdev/switchdev.c
+++ b/net/switchdev/switchdev.c
@@ -461,10 +461,11 @@ static int __switchdev_handle_port_obj_a
 	extack = switchdev_notifier_info_to_extack(&port_obj_info->info);
 
 	if (check_cb(dev)) {
-		/* This flag is only checked if the return value is success. */
-		port_obj_info->handled = true;
-		return add_cb(dev, port_obj_info->obj, port_obj_info->trans,
-			      extack);
+		err = add_cb(dev, port_obj_info->obj, port_obj_info->trans,
+			     extack);
+		if (err != -EOPNOTSUPP)
+			port_obj_info->handled = true;
+		return err;
 	}
 
 	/* Switch ports might be stacked under e.g. a LAG. Ignore the
@@ -513,9 +514,10 @@ static int __switchdev_handle_port_obj_d
 	int err = -EOPNOTSUPP;
 
 	if (check_cb(dev)) {
-		/* This flag is only checked if the return value is success. */
-		port_obj_info->handled = true;
-		return del_cb(dev, port_obj_info->obj);
+		err = del_cb(dev, port_obj_info->obj);
+		if (err != -EOPNOTSUPP)
+			port_obj_info->handled = true;
+		return err;
 	}
 
 	/* Switch ports might be stacked under e.g. a LAG. Ignore the
@@ -563,9 +565,10 @@ static int __switchdev_handle_port_attr_
 	int err = -EOPNOTSUPP;
 
 	if (check_cb(dev)) {
-		port_attr_info->handled = true;
-		return set_cb(dev, port_attr_info->attr,
-			      port_attr_info->trans);
+		err = set_cb(dev, port_attr_info->attr, port_attr_info->trans);
+		if (err != -EOPNOTSUPP)
+			port_attr_info->handled = true;
+		return err;
 	}
 
 	/* Switch ports might be stacked under e.g. a LAG. Ignore the


