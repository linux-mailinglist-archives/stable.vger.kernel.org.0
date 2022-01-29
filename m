Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69EC74A2E9A
	for <lists+stable@lfdr.de>; Sat, 29 Jan 2022 13:00:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236379AbiA2MA6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Jan 2022 07:00:58 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:39416 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233572AbiA2MA5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 Jan 2022 07:00:57 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8CBE960BBE
        for <stable@vger.kernel.org>; Sat, 29 Jan 2022 12:00:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8430FC340E5;
        Sat, 29 Jan 2022 12:00:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643457657;
        bh=He+ZDa1yv9PilFdBkbPab01ORjImxPFZ673Dby723ZM=;
        h=Subject:To:Cc:From:Date:From;
        b=13p0dqUQm8IzsKjEGB4bXb8XDWwH4YojG6e4eNILY9T9ClCFzuvx4lPMdRc3qoKP0
         wnj1/yBlHQ7TcijhbDxvHfxDQ28PNE5tHWd/Qo2F4sBzCkB2lnXTpOh+TcqX04vvSP
         DBLIDlhpYMY6YDW4ebW2EIa/GzgPlglFzuiRt/aI=
Subject: FAILED: patch "[PATCH] net: sfp: ignore disabled SFP node" failed to apply to 5.4-stable tree
To:     kabel@kernel.org, davem@davemloft.net
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 29 Jan 2022 13:00:49 +0100
Message-ID: <164345764948199@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 2148927e6ed43a1667baf7c2ae3e0e05a44b51a0 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Date: Wed, 19 Jan 2022 17:44:55 +0100
Subject: [PATCH] net: sfp: ignore disabled SFP node
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Commit ce0aa27ff3f6 ("sfp: add sfp-bus to bridge between network devices
and sfp cages") added code which finds SFP bus DT node even if the node
is disabled with status = "disabled". Because of this, when phylink is
created, it ends with non-null .sfp_bus member, even though the SFP
module is not probed (because the node is disabled).

We need to ignore disabled SFP bus node.

Fixes: ce0aa27ff3f6 ("sfp: add sfp-bus to bridge between network devices and sfp cages")
Signed-off-by: Marek Behún <kabel@kernel.org>
Cc: stable@vger.kernel.org # 2203cbf2c8b5 ("net: sfp: move fwnode parsing into sfp-bus layer")
Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/drivers/net/phy/sfp-bus.c b/drivers/net/phy/sfp-bus.c
index 0c6c0d1843bc..c1512c9925a6 100644
--- a/drivers/net/phy/sfp-bus.c
+++ b/drivers/net/phy/sfp-bus.c
@@ -651,6 +651,11 @@ struct sfp_bus *sfp_bus_find_fwnode(struct fwnode_handle *fwnode)
 	else if (ret < 0)
 		return ERR_PTR(ret);
 
+	if (!fwnode_device_is_available(ref.fwnode)) {
+		fwnode_handle_put(ref.fwnode);
+		return NULL;
+	}
+
 	bus = sfp_bus_get(ref.fwnode);
 	fwnode_handle_put(ref.fwnode);
 	if (!bus)

