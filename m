Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 598FE13AD34
	for <lists+stable@lfdr.de>; Tue, 14 Jan 2020 16:11:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728516AbgANPLj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jan 2020 10:11:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:54430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726297AbgANPLj (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jan 2020 10:11:39 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE67F222C4;
        Tue, 14 Jan 2020 15:11:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579014698;
        bh=+Gah0KLN/d3H1L8ZQWBH8YniRPe2zzrzu6gY3UIa1TQ=;
        h=Subject:To:From:Date:From;
        b=rbpUwZdH9XUbeXgBJR7LXCW9J+zczhqNYNrohqrKExN7oFK/plf84swoGKNhpFemO
         e5Tqu6bZMlkmRio75kAYlY5mYvlWws/S6clTlDQ7WfQ2p4nF1OwbRf92Ovoz0EVHf2
         HCMdFnKDH2KiIWCR4LPb4hOjk4AuJCqvmdccytIQ=
Subject: patch "component: do not dereference opaque pointer in debugfs" added to driver-core-testing
To:     lkundrak@v3.sk, arnaud.pouliquen@st.com,
        gregkh@linuxfoundation.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 14 Jan 2020 16:11:27 +0100
Message-ID: <1579014687143254@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    component: do not dereference opaque pointer in debugfs

to my driver-core git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core.git
in the driver-core-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the driver-core-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From ef9ffc1e5f1ac73ecd2fb3b70db2a3b2472ff2f7 Mon Sep 17 00:00:00 2001
From: Lubomir Rintel <lkundrak@v3.sk>
Date: Mon, 18 Nov 2019 12:54:31 +0100
Subject: component: do not dereference opaque pointer in debugfs

The match data does not have to be a struct device pointer, and indeed
very often is not. Attempt to treat it as such easily results in a
crash.

For the components that are not registered, we don't know which device
is missing. Once it it is there, we can use the struct component to get
the device and whether it's bound or not.

Fixes: 59e73854b5fd ('component: add debugfs support')
Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
Cc: stable <stable@vger.kernel.org>
Cc: Arnaud Pouliquen <arnaud.pouliquen@st.com>
Link: https://lore.kernel.org/r/20191118115431.63626-1-lkundrak@v3.sk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/component.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/base/component.c b/drivers/base/component.c
index 3a09036e772a..c7879f5ae2fb 100644
--- a/drivers/base/component.c
+++ b/drivers/base/component.c
@@ -101,11 +101,11 @@ static int component_devices_show(struct seq_file *s, void *data)
 	seq_printf(s, "%-40s %20s\n", "device name", "status");
 	seq_puts(s, "-------------------------------------------------------------\n");
 	for (i = 0; i < match->num; i++) {
-		struct device *d = (struct device *)match->compare[i].data;
+		struct component *component = match->compare[i].component;
 
-		seq_printf(s, "%-40s %20s\n", dev_name(d),
-			   match->compare[i].component ?
-			   "registered" : "not registered");
+		seq_printf(s, "%-40s %20s\n",
+			   component ? dev_name(component->dev) : "(unknown)",
+			   component ? (component->bound ? "bound" : "not bound") : "not registered");
 	}
 	mutex_unlock(&component_mutex);
 
-- 
2.24.1


