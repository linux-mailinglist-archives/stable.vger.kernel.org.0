Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 655B7A9164
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:39:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390159AbfIDSPL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 14:15:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:60628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390892AbfIDSPI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 14:15:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3740022CF7;
        Wed,  4 Sep 2019 18:15:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567620907;
        bh=bORFE6K2QGLqcpSI8tloPJ26KDM+tXzJwoFqYpq1sYk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CNF7xSKm3E1VD0bSoYf2nLl2dSvnYc5Qzn14F48CQlbE5ew6P0QHtr5DUCv+JHGdG
         Cdn6Tp/bVYrqAvUZ7ELrBUiOZOoIU/5ZdAqjtvutwvJ2ZuoW0KdVQwBnehrUEm8DlH
         aVfjt6+iM2UfI+v+UMWobFJ1lmofBky/ldc4OBy4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Raul E Rangel <rrangel@chromium.org>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 5.2 103/143] lkdtm/bugs: fix build error in lkdtm_EXHAUST_STACK
Date:   Wed,  4 Sep 2019 19:54:06 +0200
Message-Id: <20190904175318.345521443@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175314.206239922@linuxfoundation.org>
References: <20190904175314.206239922@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Raul E Rangel <rrangel@chromium.org>

commit b9bc7b8b1e9e815b231c1ca0b566ee723f480987 upstream.

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
 drivers/misc/lkdtm/bugs.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

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


