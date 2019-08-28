Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C2D4A0B9C
	for <lists+stable@lfdr.de>; Wed, 28 Aug 2019 22:35:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726583AbfH1Ufl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Aug 2019 16:35:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:51742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726400AbfH1Ufl (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 28 Aug 2019 16:35:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9B4DF22CED;
        Wed, 28 Aug 2019 20:35:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567024540;
        bh=M0i4p+iyEMFq5hg1I1e+81FwvOseyDzRVzMnhLiMz1k=;
        h=Subject:To:From:Date:From;
        b=UHmn1fIC0YubmPs6DpNMMXA81jnLG5mcbOLtjWFSsAVryQqKqs633djxDUosYRicP
         U/+yk8ZzM5xq3wpG+VEJZ2TgbuM2usDY+MCBq7LY8iK/b5VK9qlXfvDsJ6oroPW/lH
         TZ9i+zYUikSpxXbbc7hkjOYPWq6336E3NyZ157ys=
Subject: patch "lkdtm/bugs: fix build error in lkdtm_EXHAUST_STACK" added to char-misc-linus
To:     rrangel@chromium.org, gregkh@linuxfoundation.org,
        keescook@chromium.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 28 Aug 2019 22:35:37 +0200
Message-ID: <1567024537137103@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    lkdtm/bugs: fix build error in lkdtm_EXHAUST_STACK

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From b9bc7b8b1e9e815b231c1ca0b566ee723f480987 Mon Sep 17 00:00:00 2001
From: Raul E Rangel <rrangel@chromium.org>
Date: Tue, 27 Aug 2019 11:36:19 -0600
Subject: lkdtm/bugs: fix build error in lkdtm_EXHAUST_STACK

lkdtm/bugs.c:94:2: error: format '%d' expects argument of type 'int', but argument 2 has type 'long unsigned int' [-Werror=format=]
  pr_info("Calling function with %d frame size to depth %d ...\n",
  ^
THREAD_SIZE is defined as a unsigned long, cast CONFIG_FRAME_WARN to
unsigned long as well.

Fixes: 24cccab42c419 ("lkdtm/bugs: Adjust recursion test to avoid elision")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Raul E Rangel <rrangel@chromium.org>
Acked-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20190827173619.170065-1-rrangel@chromium.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/lkdtm/bugs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/lkdtm/bugs.c b/drivers/misc/lkdtm/bugs.c
index 1606658b9b7e..24245ccdba72 100644
--- a/drivers/misc/lkdtm/bugs.c
+++ b/drivers/misc/lkdtm/bugs.c
@@ -22,7 +22,7 @@ struct lkdtm_list {
  * recurse past the end of THREAD_SIZE by default.
  */
 #if defined(CONFIG_FRAME_WARN) && (CONFIG_FRAME_WARN > 0)
-#define REC_STACK_SIZE (CONFIG_FRAME_WARN / 2)
+#define REC_STACK_SIZE (_AC(CONFIG_FRAME_WARN, UL) / 2)
 #else
 #define REC_STACK_SIZE (THREAD_SIZE / 8)
 #endif
@@ -91,7 +91,7 @@ void lkdtm_LOOP(void)
 
 void lkdtm_EXHAUST_STACK(void)
 {
-	pr_info("Calling function with %d frame size to depth %d ...\n",
+	pr_info("Calling function with %lu frame size to depth %d ...\n",
 		REC_STACK_SIZE, recur_count);
 	recursive_loop(recur_count);
 	pr_info("FAIL: survived without exhausting stack?!\n");
-- 
2.23.0


