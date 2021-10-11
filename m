Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40A2F42900C
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 16:02:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237778AbhJKOEv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 10:04:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:49584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238254AbhJKOC0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 10:02:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4FFA0610C7;
        Mon, 11 Oct 2021 13:57:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960673;
        bh=aqIMde/IbE456poK236f3QZEFoBxFYexbryBLuZJPhg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c2kEqgcANdGrzUQMOpoEKQ4zzeEymWguUhDdMJrRlYojGV80mG9gSGWxtb/hcSXxu
         1SRoMjdbUpS8/6d2L9tsdZBBH969tVX0ARTSSnfaeTTEbjSD7WIaiwXZ6m+2ROJ14h
         4XBfR1vX0norWMZ4CM8+vkRLtbY505aGY+vh1T0Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Regupathy, Rajaram" <rajaram.regupathy@intel.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 5.14 009/151] usb: typec: tipd: Remove dependency on "connector" child fwnode
Date:   Mon, 11 Oct 2021 15:44:41 +0200
Message-Id: <20211011134518.148420921@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134517.833565002@linuxfoundation.org>
References: <20211011134517.833565002@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heikki Krogerus <heikki.krogerus@linux.intel.com>

commit b87d8d0d4c43c29ccdc57d15b2ebc1df886a34b4 upstream.

There is no "connector" child node available on every
platform, so the driver can't fail to probe when it's
missing.

Fixes: 57560ee95cb7 ("usb: typec: tipd: Don't block probing of consumer of "connector" nodes")
Cc: stable@vger.kernel.org # 5.14+
Reported-by: "Regupathy, Rajaram" <rajaram.regupathy@intel.com>
Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20210930124758.23233-1-heikki.krogerus@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tipd/core.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/drivers/usb/typec/tipd/core.c
+++ b/drivers/usb/typec/tipd/core.c
@@ -625,10 +625,6 @@ static int tps6598x_probe(struct i2c_cli
 	if (ret < 0)
 		return ret;
 
-	fwnode = device_get_named_child_node(&client->dev, "connector");
-	if (!fwnode)
-		return -ENODEV;
-
 	/*
 	 * This fwnode has a "compatible" property, but is never populated as a
 	 * struct device. Instead we simply parse it to read the properties.
@@ -636,7 +632,9 @@ static int tps6598x_probe(struct i2c_cli
 	 * with existing DT files, we work around this by deleting any
 	 * fwnode_links to/from this fwnode.
 	 */
-	fw_devlink_purge_absent_suppliers(fwnode);
+	fwnode = device_get_named_child_node(&client->dev, "connector");
+	if (fwnode)
+		fw_devlink_purge_absent_suppliers(fwnode);
 
 	tps->role_sw = fwnode_usb_role_switch_get(fwnode);
 	if (IS_ERR(tps->role_sw)) {


