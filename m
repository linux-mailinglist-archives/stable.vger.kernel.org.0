Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9650E11AD48
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 15:23:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729786AbfLKOXC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 09:23:02 -0500
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:40027 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726242AbfLKOXC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Dec 2019 09:23:02 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 63571A12;
        Wed, 11 Dec 2019 09:23:01 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Wed, 11 Dec 2019 09:23:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=vaHFBA
        46FduGmuznAgm94ojJTq5mBcN43jtRI2aOevc=; b=E17MbBKd5XyUH8yTEoR2PD
        XQRpuoYbmTBxnMNPgm12y5Ny1ARisAr+iL/udoe6RbiwWQ+buR5z5inwWYVsOCD9
        HZMrbSphp5b9wqJGdG+oN2MhXwMY6MrdD8qqNkvUgdw6O7n6435Sc+FzAh/s+PZU
        g74coVG4Q/hZN9DD9n53kwvKtfzTuOghkVAP+e0LgL7Ew6myDsZybusg84YnrmhV
        jc4jc1+Mjj+s++HJrrZcB9yR85Xut28jneQ4NOAm5M1VDJIRIL0+wB/yi2YC2hbb
        JZ8ExT+3ZABa7OK+JtDO/ZBNJl6SRBG78GRXTGiybVxrmezEvHn7v0ZKJozK/Spg
        ==
X-ME-Sender: <xms:xPvwXZazBxRdbEyidpHi1PCDWH4YjNQcnwsJSAPEHLymYW8zPFr7xg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudelhedgiedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:xPvwXSCa91jb8EkWxF658Nvc8AIx2OwyDa5tTKx9a35sRUtX80dx6A>
    <xmx:xPvwXaoJV8_iYueGjYVwyxHJCkfBNb3TniXZufZEC36UBtORf14Z8A>
    <xmx:xPvwXQIxbYeSJcFfT9j3NRrZ-nGluglI5jRi-G3DKdq_UoaYGnH1sQ>
    <xmx:xfvwXe_L46gIn6svi2b21TLCQxbHXvqCVK71QfueHp8Y_DNL_1TmhQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0298B80064;
        Wed, 11 Dec 2019 09:22:59 -0500 (EST)
Subject: FAILED: patch "[PATCH] binder: Handle start==NULL in binder_update_page_range()" failed to apply to 4.9-stable tree
To:     jannh@google.com, christian.brauner@ubuntu.com,
        gregkh@linuxfoundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 11 Dec 2019 15:22:57 +0100
Message-ID: <15760741774172@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 2a9edd056ed4fbf9d2e797c3fc06335af35bccc4 Mon Sep 17 00:00:00 2001
From: Jann Horn <jannh@google.com>
Date: Fri, 18 Oct 2019 22:56:31 +0200
Subject: [PATCH] binder: Handle start==NULL in binder_update_page_range()

The old loop wouldn't stop when reaching `start` if `start==NULL`, instead
continuing backwards to index -1 and crashing.

Luckily you need to be highly privileged to map things at NULL, so it's not
a big problem.

Fix it by adjusting the loop so that the loop variable is always in bounds.

This patch is deliberately minimal to simplify backporting, but IMO this
function could use a refactor. The jump labels in the second loop body are
horrible (the error gotos should be jumping to free_range instead), and
both loops would look nicer if they just iterated upwards through indices.
And the up_read()+mmput() shouldn't be duplicated like that.

Cc: stable@vger.kernel.org
Fixes: 457b9a6f09f0 ("Staging: android: add binder driver")
Signed-off-by: Jann Horn <jannh@google.com>
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
Link: https://lore.kernel.org/r/20191018205631.248274-3-jannh@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/android/binder_alloc.c b/drivers/android/binder_alloc.c
index 1f73d12409e3..2d8b9b91dee0 100644
--- a/drivers/android/binder_alloc.c
+++ b/drivers/android/binder_alloc.c
@@ -276,8 +276,7 @@ static int binder_update_page_range(struct binder_alloc *alloc, int allocate,
 	return 0;
 
 free_range:
-	for (page_addr = end - PAGE_SIZE; page_addr >= start;
-	     page_addr -= PAGE_SIZE) {
+	for (page_addr = end - PAGE_SIZE; 1; page_addr -= PAGE_SIZE) {
 		bool ret;
 		size_t index;
 
@@ -290,6 +289,8 @@ static int binder_update_page_range(struct binder_alloc *alloc, int allocate,
 		WARN_ON(!ret);
 
 		trace_binder_free_lru_end(alloc, index);
+		if (page_addr == start)
+			break;
 		continue;
 
 err_vm_insert_page_failed:
@@ -297,7 +298,8 @@ static int binder_update_page_range(struct binder_alloc *alloc, int allocate,
 		page->page_ptr = NULL;
 err_alloc_page_failed:
 err_page_ptr_cleared:
-		;
+		if (page_addr == start)
+			break;
 	}
 err_no_vma:
 	if (mm) {

