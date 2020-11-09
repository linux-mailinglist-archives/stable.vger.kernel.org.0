Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 593E32AB8D9
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 13:58:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730147AbgKIM62 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 07:58:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:52716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730134AbgKIM6X (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 07:58:23 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F0A5B20684;
        Mon,  9 Nov 2020 12:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604926702;
        bh=pVl1vEuLNYukmaug9/oUF7KB7Q+AK0keRAjaMtok43s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=viWLQwckzlojK/dZru76OQ4bMhMHJr/wWm15quRAOEVAorATaSDoAcbBT58xu6Oem
         KW3Dp/uvFBKRccFtvgg8z1PKl8YvCvHxYflWC9CoPklC3aj2B8UhT5LsnaKq7A+Pdc
         mDebdh4z3QjrVOZp+1QgtJzYbg8/t1e1tBl+JjUM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ferry Toth <fntoth@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 4.4 62/86] device property: Dont clear secondary pointer for shared primary firmware node
Date:   Mon,  9 Nov 2020 13:55:09 +0100
Message-Id: <20201109125023.749624942@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125020.852643676@linuxfoundation.org>
References: <20201109125020.852643676@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

commit 99aed9227073fb34ce2880cbc7063e04185a65e1 upstream.

It appears that firmware nodes can be shared between devices. In such case
when a (child) device is about to be deleted, its firmware node may be shared
and ACPI_COMPANION_SET(..., NULL) call for it breaks the secondary link
of the shared primary firmware node.

In order to prevent that, check, if the device has a parent and parent's
firmware node is shared with its child, and avoid crashing the link.

Fixes: c15e1bdda436 ("device property: Fix the secondary firmware node handling in set_primary_fwnode()")
Reported-by: Ferry Toth <fntoth@gmail.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Tested-by: Ferry Toth <fntoth@gmail.com>
Cc: 5.9+ <stable@vger.kernel.org> # 5.9+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/base/core.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -2344,6 +2344,7 @@ static inline bool fwnode_is_primary(str
  */
 void set_primary_fwnode(struct device *dev, struct fwnode_handle *fwnode)
 {
+	struct device *parent = dev->parent;
 	struct fwnode_handle *fn = dev->fwnode;
 
 	if (fwnode) {
@@ -2355,7 +2356,8 @@ void set_primary_fwnode(struct device *d
 	} else {
 		if (fwnode_is_primary(fn)) {
 			dev->fwnode = fn->secondary;
-			fn->secondary = ERR_PTR(-ENODEV);
+			if (!(parent && fn == parent->fwnode))
+				fn->secondary = ERR_PTR(-ENODEV);
 		} else {
 			dev->fwnode = NULL;
 		}


