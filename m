Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C134D1A6835
	for <lists+stable@lfdr.de>; Mon, 13 Apr 2020 16:33:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728868AbgDMOdb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Apr 2020 10:33:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:53562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728807AbgDMOda (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Apr 2020 10:33:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B10662072C;
        Mon, 13 Apr 2020 14:33:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586788410;
        bh=//WjxLReYTUMlJS3N92Wpc1L20tla422Ok6LMWVTcpw=;
        h=Subject:To:From:Date:From;
        b=sQuxr2SDZr/X1RKJs/1/qcQ7xpOEQupe/LtD2KwuUVN7zOWqwaUjkEubTfp6qc1xE
         SUJms2jofKuqlStzppH68CRX+keODadwG1gZpPJiVZ6uD6kZ76CHKn9mSp8Ez14nyC
         3ZeJJIW+vrdvyK7NmphStTiJyB6et+go5V5O8diI=
Subject: patch "staging: gasket: Fix incongruency in handling of sysfs entries" added to staging-linus
To:     luis.p.mendes@gmail.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 13 Apr 2020 16:33:28 +0200
Message-ID: <158678840834128@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    staging: gasket: Fix incongruency in handling of sysfs entries

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 9195d762042b0e5e4ded63606b4b30a93cba4400 Mon Sep 17 00:00:00 2001
From: Luis Mendes <luis.p.mendes@gmail.com>
Date: Fri, 3 Apr 2020 16:15:34 +0100
Subject: staging: gasket: Fix incongruency in handling of sysfs entries
 creation

Fix incongruency in handling of sysfs entries creation.
This issue could cause invalid memory accesses, by not properly
detecting the end of the sysfs attributes array.

Fixes: 84c45d5f3bf1 ("staging: gasket: Replace macro __ATTR with __ATTR_NULL")
Signed-off-by: Luis Mendes <luis.p.mendes@gmail.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200403151534.20753-1-luis.p.mendes@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/gasket/gasket_sysfs.c | 3 +--
 drivers/staging/gasket/gasket_sysfs.h | 4 ----
 2 files changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/staging/gasket/gasket_sysfs.c b/drivers/staging/gasket/gasket_sysfs.c
index a2d67c28f530..5f0e089573a2 100644
--- a/drivers/staging/gasket/gasket_sysfs.c
+++ b/drivers/staging/gasket/gasket_sysfs.c
@@ -228,8 +228,7 @@ int gasket_sysfs_create_entries(struct device *device,
 	}
 
 	mutex_lock(&mapping->mutex);
-	for (i = 0; strcmp(attrs[i].attr.attr.name, GASKET_ARRAY_END_MARKER);
-		i++) {
+	for (i = 0; attrs[i].attr.attr.name != NULL; i++) {
 		if (mapping->attribute_count == GASKET_SYSFS_MAX_NODES) {
 			dev_err(device,
 				"Maximum number of sysfs nodes reached for device\n");
diff --git a/drivers/staging/gasket/gasket_sysfs.h b/drivers/staging/gasket/gasket_sysfs.h
index 1d0eed66a7f4..ab5aa351d555 100644
--- a/drivers/staging/gasket/gasket_sysfs.h
+++ b/drivers/staging/gasket/gasket_sysfs.h
@@ -30,10 +30,6 @@
  */
 #define GASKET_SYSFS_MAX_NODES 196
 
-/* End markers for sysfs struct arrays. */
-#define GASKET_ARRAY_END_TOKEN GASKET_RESERVED_ARRAY_END
-#define GASKET_ARRAY_END_MARKER __stringify(GASKET_ARRAY_END_TOKEN)
-
 /*
  * Terminator struct for a gasket_sysfs_attr array. Must be at the end of
  * all gasket_sysfs_attribute arrays.
-- 
2.26.0


