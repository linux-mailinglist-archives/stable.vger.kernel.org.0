Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C6792595E2
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 17:57:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730178AbgIAP5G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:57:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:60550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731815AbgIAPop (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:44:45 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5126C2078B;
        Tue,  1 Sep 2020 15:44:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598975084;
        bh=DxqAMXBtBi+lpyycBbxEJvoY8NTVhAWr+ZxGejRWmXA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UEeXud6wlBAuS8lwAlVyAVreyc4uGz72iGXfN+pkULHMVL8Hr94MECmwGWRKwOmB8
         oqAEPbw5dNv9MG4K0juNDDTWKSs6o0Angw3epf+yA3z0muxaMQ/TW7ZHNXm8ENPMns
         yt0MR5uYjuC7bnF3b5uozSWl1fH3TWjaHWVuPmpw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.8 203/255] device property: Fix the secondary firmware node handling in set_primary_fwnode()
Date:   Tue,  1 Sep 2020 17:10:59 +0200
Message-Id: <20200901151010.425011611@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901151000.800754757@linuxfoundation.org>
References: <20200901151000.800754757@linuxfoundation.org>
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
@@ -3988,9 +3988,9 @@ static inline bool fwnode_is_primary(str
  */
 void set_primary_fwnode(struct device *dev, struct fwnode_handle *fwnode)
 {
-	if (fwnode) {
-		struct fwnode_handle *fn = dev->fwnode;
+	struct fwnode_handle *fn = dev->fwnode;
 
+	if (fwnode) {
 		if (fwnode_is_primary(fn))
 			fn = fn->secondary;
 
@@ -4000,8 +4000,12 @@ void set_primary_fwnode(struct device *d
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


