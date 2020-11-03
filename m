Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C121D2A54C6
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:14:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389133AbgKCVNQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:13:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:56096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389130AbgKCVNP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 16:13:15 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ED8AB205ED;
        Tue,  3 Nov 2020 21:13:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604437994;
        bh=YWUyu+ew4eM/nt1X0GD9nL/As3YpU0EoRoRYthGqG9U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X9jTU2Q63XQrM8vtXyyw6TgxSsJSkoWsyU05N5i7m7+z000EOf7dU+289l/lwsGkj
         5YVyDlUj3z8uOeu/pgbNAGA48BIC5tulraslVEvJa9zXw9XpWEfYbLit0RmEE20imK
         PEXPUtlqQJSVFFSZUJVWaBhAFc8dDz1RWxeBd3hk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ferry Toth <fntoth@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 4.14 120/125] device property: Keep secondary firmware node secondary by type
Date:   Tue,  3 Nov 2020 21:38:17 +0100
Message-Id: <20201103203214.823768688@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203156.372184213@linuxfoundation.org>
References: <20201103203156.372184213@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

commit d5dcce0c414fcbfe4c2037b66ac69ea5f9b3f75c upstream.

Behind primary and secondary we understand the type of the nodes
which might define their ordering. However, if primary node gone,
we can't maintain the ordering by definition of the linked list.
Thus, by ordering secondary node becomes first in the list.
But in this case the meaning of it is still secondary (or auxiliary).
The type of the node is maintained by the secondary pointer in it:

	secondary pointer		Meaning
	NULL or valid			primary node
	ERR_PTR(-ENODEV)		secondary node

So, if by some reason we do the following sequence of calls

	set_primary_fwnode(dev, NULL);
	set_primary_fwnode(dev, primary);

we should preserve secondary node.

This concept is supported by the description of set_primary_fwnode()
along with implementation of set_secondary_fwnode(). Hence, fix
the commit c15e1bdda436 to follow this as well.

Fixes: c15e1bdda436 ("device property: Fix the secondary firmware node handling in set_primary_fwnode()")
Cc: Ferry Toth <fntoth@gmail.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Tested-by: Ferry Toth <fntoth@gmail.com>
Cc: 5.9+ <stable@vger.kernel.org> # 5.9+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/base/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -3088,7 +3088,7 @@ void set_primary_fwnode(struct device *d
 	} else {
 		if (fwnode_is_primary(fn)) {
 			dev->fwnode = fn->secondary;
-			fn->secondary = NULL;
+			fn->secondary = ERR_PTR(-ENODEV);
 		} else {
 			dev->fwnode = NULL;
 		}


