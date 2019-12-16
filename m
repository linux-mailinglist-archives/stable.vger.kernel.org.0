Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AE3B1218BE
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:46:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727921AbfLPSqG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:46:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:54840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727067AbfLPR4d (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 12:56:33 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D7A3621582;
        Mon, 16 Dec 2019 17:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576518993;
        bh=Kq/Fq7kyvsgnTWJMezzUi0YYEWQPd0NAaOiejOwwiTE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qIyH/aiQN+QQdFqIoq2RXQEUDaQn3SGAmsoDVkGh8H7n1+2pzN6gW/tIog5R04hd+
         jfJF8L8iW+0tAA/dFZAXWa2HYVlgKSnL1V6BvISiQDRSAXb6zZrsZFW6aTz5sEOOYf
         QAJSuL+sCvEsUEEqooa8EZQcnikv07p1Qu+u/Cvw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jann Horn <jannh@google.com>,
        Christian Brauner <christian.brauner@ubuntu.com>
Subject: [PATCH 4.14 152/267] binder: Handle start==NULL in binder_update_page_range()
Date:   Mon, 16 Dec 2019 18:47:58 +0100
Message-Id: <20191216174910.820997337@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174848.701533383@linuxfoundation.org>
References: <20191216174848.701533383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jann Horn <jannh@google.com>

commit 2a9edd056ed4fbf9d2e797c3fc06335af35bccc4 upstream.

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

---
 drivers/android/binder_alloc.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/android/binder_alloc.c
+++ b/drivers/android/binder_alloc.c
@@ -289,8 +289,7 @@ static int binder_update_page_range(stru
 	return 0;
 
 free_range:
-	for (page_addr = end - PAGE_SIZE; page_addr >= start;
-	     page_addr -= PAGE_SIZE) {
+	for (page_addr = end - PAGE_SIZE; 1; page_addr -= PAGE_SIZE) {
 		bool ret;
 		size_t index;
 
@@ -303,6 +302,8 @@ free_range:
 		WARN_ON(!ret);
 
 		trace_binder_free_lru_end(alloc, index);
+		if (page_addr == start)
+			break;
 		continue;
 
 err_vm_insert_page_failed:
@@ -312,7 +313,8 @@ err_map_kernel_failed:
 		page->page_ptr = NULL;
 err_alloc_page_failed:
 err_page_ptr_cleared:
-		;
+		if (page_addr == start)
+			break;
 	}
 err_no_vma:
 	if (mm) {


