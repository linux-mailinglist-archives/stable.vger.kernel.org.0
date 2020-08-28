Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 395D825589D
	for <lists+stable@lfdr.de>; Fri, 28 Aug 2020 12:33:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729040AbgH1Kc6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Aug 2020 06:32:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:57430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728362AbgH1Kc5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 28 Aug 2020 06:32:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B40B42086A;
        Fri, 28 Aug 2020 10:32:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598610777;
        bh=CNp/cFxI2LaBRZQxICDB2qLRK842hYKrHqEsEl/CtKA=;
        h=Subject:To:From:Date:From;
        b=PNiqdmo3N1TkWZ3igYkUm5VnROPZGbCL3vPYT1lhs6aHYqBdvXKuPCFEZP1J8DBTm
         j/o3PRBE6OzlrpQghfyE2KvlMcj/UZic7JNCHIpiOjyXOKk1zxhxXgGPGCH0Xbypgz
         F5x4jQPiGYYw0E7nWH/qG/Vqwz5ZiYLdUSrLEdfU=
Subject: patch "kobject: Restore old behaviour of kobject_del(NULL)" added to driver-core-linus
To:     andriy.shevchenko@linux.intel.com, gregkh@linuxfoundation.org,
        heikki.krogerus@linux.intel.com, quwenruo.btrfs@gmx.com,
        stable@vger.kernel.org, wqu@suse.com
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 28 Aug 2020 12:33:09 +0200
Message-ID: <1598610789203124@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    kobject: Restore old behaviour of kobject_del(NULL)

to my driver-core git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core.git
in the driver-core-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 40b8b826a6998639dd1c26f0e127f18371e1058d Mon Sep 17 00:00:00 2001
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Date: Mon, 3 Aug 2020 11:27:06 +0300
Subject: kobject: Restore old behaviour of kobject_del(NULL)

The commit 079ad2fb4bf9 ("kobject: Avoid premature parent object freeing in
kobject_cleanup()") inadvertently dropped a possibility to call kobject_del()
with NULL pointer. Restore the old behaviour.

Fixes: 079ad2fb4bf9 ("kobject: Avoid premature parent object freeing in kobject_cleanup()")
Cc: stable <stable@vger.kernel.org>
Reported-by: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Qu Wenruo <wqu@suse.com>
Link: https://lore.kernel.org/r/20200803082706.65347-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/kobject.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/lib/kobject.c b/lib/kobject.c
index 3afb939f2a1c..9dce68c378e6 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -637,8 +637,12 @@ static void __kobject_del(struct kobject *kobj)
  */
 void kobject_del(struct kobject *kobj)
 {
-	struct kobject *parent = kobj->parent;
+	struct kobject *parent;
+
+	if (!kobj)
+		return;
 
+	parent = kobj->parent;
 	__kobject_del(kobj);
 	kobject_put(parent);
 }
-- 
2.28.0


