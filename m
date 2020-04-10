Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CCF61A3EF8
	for <lists+stable@lfdr.de>; Fri, 10 Apr 2020 05:47:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726873AbgDJDqx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Apr 2020 23:46:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:57066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726865AbgDJDqw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Apr 2020 23:46:52 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1C76220936;
        Fri, 10 Apr 2020 03:46:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586490412;
        bh=zMBCe1mPTUuYlis/A+ipA59U/N5RLtlx/E7hzsEDSls=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sz4mxHQAv83/DjecPhz2IR9QGftRbQ7wckAFphdoKAVRQ7EAtNIA36fEuaiqwyAWw
         jeMOqji13bjyS8TXdWeViFAtLNv0t2KqFp0tSzHPgbc2a2GmRTwE621BUiooNFPN0x
         QtidM9FCRbEXmAi5mTpPj/hWltooXIAat5F/O86I=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Saravana Kannan <saravanak@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.6 14/68] driver core: Reevaluate dev->links.need_for_probe as suppliers are added
Date:   Thu,  9 Apr 2020 23:45:39 -0400
Message-Id: <20200410034634.7731-14-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200410034634.7731-1-sashal@kernel.org>
References: <20200410034634.7731-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Saravana Kannan <saravanak@google.com>

[ Upstream commit 1745d299af5b373abad08fa29bff0d31dc6aff21 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/core.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index dbb0f9130f42d..d32a3aefff32f 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -523,9 +523,13 @@ static void device_link_add_missing_supplier_links(void)
 
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
 
-- 
2.20.1

