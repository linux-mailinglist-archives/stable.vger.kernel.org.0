Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 742681A5118
	for <lists+stable@lfdr.de>; Sat, 11 Apr 2020 14:23:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728415AbgDKMT0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 08:19:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:54838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728792AbgDKMTZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 08:19:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F9202084D;
        Sat, 11 Apr 2020 12:19:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586607565;
        bh=G/fsmouMPqeGL+ojewb25nKuHbsV2AApGz5o0aVaTkg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=heQzgtpS8dR14ArPZsboeNfH/SX9e8XBn2vfLBrKrbIDtN8+2wJDScblRXBvsmNo+
         UCcMtz2IiLJlYnIVeL27/cYBjmTOLGKMfEXVbDTEUtiEhsTkefVNXwzqYhN/Z+FwzQ
         uPmThnLwwbFxAWsEq+DfYF+be3nOiiau+g4sI21k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Saravana Kannan <saravanak@google.com>
Subject: [PATCH 5.5 30/44] driver core: Reevaluate dev->links.need_for_probe as suppliers are added
Date:   Sat, 11 Apr 2020 14:09:50 +0200
Message-Id: <20200411115459.715810444@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200411115456.934174282@linuxfoundation.org>
References: <20200411115456.934174282@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Saravana Kannan <saravanak@google.com>

commit 1745d299af5b373abad08fa29bff0d31dc6aff21 upstream.

A previous patch 03324507e66c ("driver core: Allow
fwnode_operations.add_links to differentiate errors") forgot to update
all call sites to fwnode_operations.add_links. This patch fixes that.

Legend:
-> Denotes RHS is an optional/potential supplier for LHS
=> Denotes RHS is a mandatory supplier for LHS

Example:

Device A => Device X
Device A -> Device Y

Before this patch:
1. Device A is added.
2. Device A is marked as waiting for mandatory suppliers
3. Device X is added
4. Device A is left marked as waiting for mandatory suppliers

Step 4 is wrong since all mandatory suppliers of Device A have been
added.

After this patch:
1. Device A is added.
2. Device A is marked as waiting for mandatory suppliers
3. Device X is added
4. Device A is no longer considered as waiting for mandatory suppliers

This is the correct behavior.

Fixes: 03324507e66c ("driver core: Allow fwnode_operations.add_links to differentiate errors")
Signed-off-by: Saravana Kannan <saravanak@google.com>
Link: https://lore.kernel.org/r/20200222014038.180923-2-saravanak@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/base/core.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -523,9 +523,13 @@ static void device_link_add_missing_supp
 
 	mutex_lock(&wfs_lock);
 	list_for_each_entry_safe(dev, tmp, &wait_for_suppliers,
-				 links.needs_suppliers)
-		if (!fwnode_call_int_op(dev->fwnode, add_links, dev))
+				 links.needs_suppliers) {
+		int ret = fwnode_call_int_op(dev->fwnode, add_links, dev);
+		if (!ret)
 			list_del_init(&dev->links.needs_suppliers);
+		else if (ret != -ENODEV)
+			dev->links.need_for_probe = false;
+	}
 	mutex_unlock(&wfs_lock);
 }
 


