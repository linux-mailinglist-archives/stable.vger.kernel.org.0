Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB451431DB2
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:53:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233224AbhJRNyN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:54:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:56110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233867AbhJRNwF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:52:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3FF9261356;
        Mon, 18 Oct 2021 13:38:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634564319;
        bh=V5q8jqpNLEFvULBQ/nLGImYDqTsVmi2RD6LJkW5bd4g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ocvc7rYBu9DosRp8KNsdKtJrVopQtSte0UalZDFXY5VgxQ5cftf12q0R5uz2CWF07
         mUNL+Uw0+IxC4gBdomyIKf/YouMPVcH4EciQpKRywi2Cgwb96VfPPZQwRNdugahvl7
         PMdKqY3IgOddmwhg+1JPGfVhWNSqfCtuQfqyxftc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 5.14 045/151] cb710: avoid NULL pointer subtraction
Date:   Mon, 18 Oct 2021 15:23:44 +0200
Message-Id: <20211018132342.169193215@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132340.682786018@linuxfoundation.org>
References: <20211018132340.682786018@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

commit 42641042c10c757fe10cc09088cf3f436cec5007 upstream.

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
 drivers/misc/cb710/sgbuf2.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/misc/cb710/sgbuf2.c
+++ b/drivers/misc/cb710/sgbuf2.c
@@ -47,7 +47,7 @@ static inline bool needs_unaligned_copy(
 #ifdef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
 	return false;
 #else
-	return ((ptr - NULL) & 3) != 0;
+	return ((uintptr_t)ptr & 3) != 0;
 #endif
 }
 


