Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDDEE33B9A5
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:08:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231433AbhCOOG0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:06:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:38284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233453AbhCOOBm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:01:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0631364F0B;
        Mon, 15 Mar 2021 14:01:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816891;
        bh=xcBrq3kDGzZjHnI73Sxcu29nEqrkieYemkYWm+6nhbI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rnSWnOttZyaUMi0ogGozT6th6/aKioJfelGQ75hXUDxWfWkMOOaPWbZOWt+AASvo/
         /jawX+MXbGDIVBElGbxdhFVAXLDpTPtrK/SGZr2wiW0T1H8VXA4CTJvqHR9+412CKK
         v0SYJUBnMym4BKxREUQvTsd3YPRFWjs/Yx3zx/hM=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.11 185/306] software node: Fix node registration
Date:   Mon, 15 Mar 2021 14:54:08 +0100
Message-Id: <20210315135513.870106728@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135507.611436477@linuxfoundation.org>
References: <20210315135507.611436477@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Heikki Krogerus <heikki.krogerus@linux.intel.com>

commit 8891123f9cbb9c1ee531e5a87fa116f0af685c48 upstream.

Software node can not be registered before its parent.

Fixes: 80488a6b1d3c ("software node: Add support for static node descriptors")
Cc: 5.10+ <stable@vger.kernel.org> # 5.10+
Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Tested-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/swnode.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/base/swnode.c
+++ b/drivers/base/swnode.c
@@ -786,6 +786,9 @@ int software_node_register(const struct
 	if (software_node_to_swnode(node))
 		return -EEXIST;
 
+	if (node->parent && !parent)
+		return -EINVAL;
+
 	return PTR_ERR_OR_ZERO(swnode_register(node, parent, 0));
 }
 EXPORT_SYMBOL_GPL(software_node_register);


