Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B37662ABC38
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:35:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731869AbgKINf1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:35:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:58212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730839AbgKINFW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:05:22 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DCDDE21D40;
        Mon,  9 Nov 2020 13:05:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927119;
        bh=0d5mbr8golkF2uyLE7azfmyXcCyXmpgRp8/Y4gZob2s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fu+D/3bdk6vI5KpFtUEmCnBhxCPfbv+uNt0engwIXH2dRAk5YAOmjLLWdhNCWPqyA
         TOo43LvUoMcQpYn+iw6TmmrIjmxCureblgAwIdGpeoAXDyHPngvstN0Yz1P8H/ZmQs
         HsbwijMaXcEQwlgk3q9kyJ6L9EKFf32iNE1AznJ8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ferry Toth <fntoth@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 4.9 086/117] device property: Keep secondary firmware node secondary by type
Date:   Mon,  9 Nov 2020 13:55:12 +0100
Message-Id: <20201109125029.772123248@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125025.630721781@linuxfoundation.org>
References: <20201109125025.630721781@linuxfoundation.org>
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
@@ -2362,7 +2362,7 @@ void set_primary_fwnode(struct device *d
 	} else {
 		if (fwnode_is_primary(fn)) {
 			dev->fwnode = fn->secondary;
-			fn->secondary = NULL;
+			fn->secondary = ERR_PTR(-ENODEV);
 		} else {
 			dev->fwnode = NULL;
 		}


