Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86A3C499549
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:09:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1392523AbiAXUvZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:51:25 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:46710 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390720AbiAXUqG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:46:06 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 31C84B81061;
        Mon, 24 Jan 2022 20:46:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E2A1C340E5;
        Mon, 24 Jan 2022 20:46:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057163;
        bh=1UkMZa/royLpHMxGh9IRPXpsoz9kl6dKbdO4wAyXQCA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2Pqtye1jbfVWluzV/MSxWVZLvYQ80GIYrpaeS3V/KSVGPzm0DxhMpPWfKDAoVeQVS
         80Q4eYZ+2RV0RDJtVkWgtyKmjXz17LrK1MINnFo0IoM5jicNs8U8h/TeyfpepCt+JX
         XpZU9IdafJUZosqmGroTkvony6pgrEvuQFiVovNQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.15 689/846] device property: Fix fwnode_graph_devcon_match() fwnode leak
Date:   Mon, 24 Jan 2022 19:43:26 +0100
Message-Id: <20220124184124.825727206@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sakari Ailus <sakari.ailus@linux.intel.com>

commit 4a7f4110f79163fd53ea65438041994ed615e3af upstream.

For each endpoint it encounters, fwnode_graph_devcon_match() checks
whether the endpoint's remote port parent device is available. If it is
not, it ignores the endpoint but does not put the reference to the remote
endpoint port parent fwnode. For available devices the fwnode handle
reference is put as expected.

Put the reference for unavailable devices now.

Fixes: 637e9e52b185 ("device connection: Find device connections also from device graphs")
Cc: 5.1+ <stable@vger.kernel.org> # 5.1+
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/property.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/base/property.c
+++ b/drivers/base/property.c
@@ -1269,8 +1269,10 @@ fwnode_graph_devcon_match(struct fwnode_
 
 	fwnode_graph_for_each_endpoint(fwnode, ep) {
 		node = fwnode_graph_get_remote_port_parent(ep);
-		if (!fwnode_device_is_available(node))
+		if (!fwnode_device_is_available(node)) {
+			fwnode_handle_put(node);
 			continue;
+		}
 
 		ret = match(node, con_id, data);
 		fwnode_handle_put(node);


