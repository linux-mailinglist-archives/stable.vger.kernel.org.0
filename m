Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E663B4A432D
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:21:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376684AbiAaLRh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:17:37 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:49122 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245596AbiAaLPi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:15:38 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3CD4C61211;
        Mon, 31 Jan 2022 11:15:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC5E9C340E8;
        Mon, 31 Jan 2022 11:15:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627737;
        bh=aNFs42xQbWeVHlU591NmPk9cEXwa3Dh+sxOSlJyGGKI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Do0zlCsQ+ArA2je5mJ7NIC8xOtAmZ6kZU7zC447SZ9/cvFZ9JqziyMgjHIQBoynqv
         fDS79Hgu9xJL9fHWosHk95XhWmG6lMyucm+Rc4XfmChHAHVu4ysyN+289j+xoWjFAH
         ld7MA4z3xEVP7osIqukUicxffA8X324bZuUlaMyw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.16 010/200] net: sfp: ignore disabled SFP node
Date:   Mon, 31 Jan 2022 11:54:33 +0100
Message-Id: <20220131105233.909066856@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105233.561926043@linuxfoundation.org>
References: <20220131105233.561926043@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Behún <kabel@kernel.org>

commit 2148927e6ed43a1667baf7c2ae3e0e05a44b51a0 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/sfp-bus.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/net/phy/sfp-bus.c
+++ b/drivers/net/phy/sfp-bus.c
@@ -651,6 +651,11 @@ struct sfp_bus *sfp_bus_find_fwnode(stru
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


