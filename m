Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 122CF422876
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 15:50:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235296AbhJENwg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Oct 2021 09:52:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:59128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235395AbhJENwc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 Oct 2021 09:52:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 41E5661507;
        Tue,  5 Oct 2021 13:50:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633441841;
        bh=L+jMaaG/8pRWgi1FsFhAGXLlP1/3PEjKzRLMNI8wZrk=;
        h=Subject:To:From:Date:From;
        b=Y7naVbEOEQYR2md46y57IrYMiWG5LNqTWllqBiyiSzYEONV1fVQTD9LiljGrrbXJN
         Z+QXMdDyEYyAXTFIJTxiHLdHKhfZU8Jkf0y4vGErCbnyk1eu5ChsU9cQYkJCHqiXOE
         W3G8Zrutb2/eOtLW5djVQMTHyWQ1u0IjdMTmP6Ks=
Subject: patch "cb710: avoid NULL pointer subtraction" added to char-misc-linus
To:     arnd@arndb.de, gregkh@linuxfoundation.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 05 Oct 2021 15:50:39 +0200
Message-ID: <163344183919229@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    cb710: avoid NULL pointer subtraction

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 42641042c10c757fe10cc09088cf3f436cec5007 Mon Sep 17 00:00:00 2001
From: Arnd Bergmann <arnd@arndb.de>
Date: Mon, 27 Sep 2021 14:13:57 +0200
Subject: cb710: avoid NULL pointer subtraction

clang-14 complains about an unusual way of converting a pointer to
an integer:

drivers/misc/cb710/sgbuf2.c:50:15: error: performing pointer subtraction with a null pointer has undefined behavior [-Werror,-Wnull-pointer-subtraction]
        return ((ptr - NULL) & 3) != 0;

Replace this with a normal cast to uintptr_t.

Fixes: 5f5bac8272be ("mmc: Driver for CB710/720 memory card reader (MMC part)")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/r/20210927121408.939246-1-arnd@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/cb710/sgbuf2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/misc/cb710/sgbuf2.c b/drivers/misc/cb710/sgbuf2.c
index e5a4ed3701eb..a798fad5f03c 100644
--- a/drivers/misc/cb710/sgbuf2.c
+++ b/drivers/misc/cb710/sgbuf2.c
@@ -47,7 +47,7 @@ static inline bool needs_unaligned_copy(const void *ptr)
 #ifdef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
 	return false;
 #else
-	return ((ptr - NULL) & 3) != 0;
+	return ((uintptr_t)ptr & 3) != 0;
 #endif
 }
 
-- 
2.33.0


