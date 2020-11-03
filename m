Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 447DD2A54C7
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:14:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388686AbgKCVOW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:14:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:56180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389138AbgKCVNR (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 16:13:17 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 74FCC205ED;
        Tue,  3 Nov 2020 21:13:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604437997;
        bh=924KVnQ69d42PZvimNfif7jZE2gQ1f6Mcb+WrTvRF+c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y2FHtuEDpiYSgTaeDrCsab2epkUSyXiicY7Jpbqhpe4fvtieUrmxvi7utyKiAgTnz
         3HZwfV5pNp/HLxslb7hHyfUO/jE8gJuzlk8ZbEr/ST/gekuW0rBsKcu4L4ee6V8CyZ
         oJ5gHNG6fGm9vC0EY/CZrQcnxN8Oa9eW+pqwWYJ0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ferry Toth <fntoth@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 4.14 121/125] device property: Dont clear secondary pointer for shared primary firmware node
Date:   Tue,  3 Nov 2020 21:38:18 +0100
Message-Id: <20201103203214.964257680@linuxfoundation.org>
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
@@ -3074,6 +3074,7 @@ static inline bool fwnode_is_primary(str
  */
 void set_primary_fwnode(struct device *dev, struct fwnode_handle *fwnode)
 {
+	struct device *parent = dev->parent;
 	struct fwnode_handle *fn = dev->fwnode;
 
 	if (fwnode) {
@@ -3088,7 +3089,8 @@ void set_primary_fwnode(struct device *d
 	} else {
 		if (fwnode_is_primary(fn)) {
 			dev->fwnode = fn->secondary;
-			fn->secondary = ERR_PTR(-ENODEV);
+			if (!(parent && fn == parent->fwnode))
+				fn->secondary = ERR_PTR(-ENODEV);
 		} else {
 			dev->fwnode = NULL;
 		}


