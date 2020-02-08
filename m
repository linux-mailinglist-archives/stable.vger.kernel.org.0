Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AAFAE156672
	for <lists+stable@lfdr.de>; Sat,  8 Feb 2020 19:35:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727935AbgBHSev (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Feb 2020 13:34:51 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34166 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727870AbgBHS3o (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Feb 2020 13:29:44 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrK-0003fo-7Z; Sat, 08 Feb 2020 18:29:38 +0000
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrJ-000CR1-6e; Sat, 08 Feb 2020 18:29:37 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Jann Horn" <jannh@google.com>,
        "Christian Brauner" <christian.brauner@ubuntu.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Date:   Sat, 08 Feb 2020 18:20:33 +0000
Message-ID: <lsq.1581185940.741520546@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 094/148] binder: Handle start==NULL in
 binder_update_page_range()
In-Reply-To: <lsq.1581185939.857586636@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.82-rc1 review patch.  If anyone has any objections, please let me know.

------------------

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

Fixes: 457b9a6f09f0 ("Staging: android: add binder driver")
Signed-off-by: Jann Horn <jannh@google.com>
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
Link: https://lore.kernel.org/r/20191018205631.248274-3-jannh@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[bwh: Backported to 3.16: There is no continue statement in the loop,
 so we only need to check the exit condition at the bottom]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/drivers/staging/android/binder.c
+++ b/drivers/staging/android/binder.c
@@ -624,8 +624,7 @@ static int binder_update_page_range(stru
 	return 0;
 
 free_range:
-	for (page_addr = end - PAGE_SIZE; page_addr >= start;
-	     page_addr -= PAGE_SIZE) {
+	for (page_addr = end - PAGE_SIZE; 1; page_addr -= PAGE_SIZE) {
 		page = &proc->pages[(page_addr - proc->buffer) / PAGE_SIZE];
 		if (vma)
 			zap_page_range(vma, (uintptr_t)page_addr +
@@ -636,7 +635,8 @@ err_map_kernel_failed:
 		__free_page(*page);
 		*page = NULL;
 err_alloc_page_failed:
-		;
+		if (page_addr == start)
+			break;
 	}
 err_no_vma:
 	if (mm) {

