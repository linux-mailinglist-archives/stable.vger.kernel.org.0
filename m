Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFEE825930A
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 17:20:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729612AbgIAPU2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:20:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:40472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729606AbgIAPU1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:20:27 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 586B5206FA;
        Tue,  1 Sep 2020 15:20:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598973626;
        bh=F3CfCHGHySuUWWNVaJBbuYS2V+uCwRkrEAJps+lQ6DI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mElynAdH1ls9MvesqYCTGubLqKQ/uoOVDuQi9oFeBfqtaRgNHbswR0o02fDrJ4kPC
         Kc4Qrp6cxReZJQdKZYfllMh86iTG0+U+PnBFjevW7rNy+lY6yDZQsb1tNeFIl+/Y9U
         N/Z6VuYkLkqH2DcG422j5BPgROJ7TGVCqnD8jBw8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 4.14 75/91] device property: Fix the secondary firmware node handling in set_primary_fwnode()
Date:   Tue,  1 Sep 2020 17:10:49 +0200
Message-Id: <20200901150931.917488506@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150928.096174795@linuxfoundation.org>
References: <20200901150928.096174795@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heikki Krogerus <heikki.krogerus@linux.intel.com>

commit c15e1bdda4365a5f17cdadf22bf1c1df13884a9e upstream.

When the primary firmware node pointer is removed from a
device (set to NULL) the secondary firmware node pointer,
when it exists, is made the primary node for the device.
However, the secondary firmware node pointer of the original
primary firmware node is never cleared (set to NULL).

To avoid situation where the secondary firmware node pointer
is pointing to a non-existing object, clearing it properly
when the primary node is removed from a device in
set_primary_fwnode().

Fixes: 97badf873ab6 ("device property: Make it possible to use secondary firmware nodes")
Cc: All applicable <stable@vger.kernel.org>
Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/base/core.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -3074,9 +3074,9 @@ static inline bool fwnode_is_primary(str
  */
 void set_primary_fwnode(struct device *dev, struct fwnode_handle *fwnode)
 {
-	if (fwnode) {
-		struct fwnode_handle *fn = dev->fwnode;
+	struct fwnode_handle *fn = dev->fwnode;
 
+	if (fwnode) {
 		if (fwnode_is_primary(fn))
 			fn = fn->secondary;
 
@@ -3086,8 +3086,12 @@ void set_primary_fwnode(struct device *d
 		}
 		dev->fwnode = fwnode;
 	} else {
-		dev->fwnode = fwnode_is_primary(dev->fwnode) ?
-			dev->fwnode->secondary : NULL;
+		if (fwnode_is_primary(fn)) {
+			dev->fwnode = fn->secondary;
+			fn->secondary = NULL;
+		} else {
+			dev->fwnode = NULL;
+		}
 	}
 }
 EXPORT_SYMBOL_GPL(set_primary_fwnode);


