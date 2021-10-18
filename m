Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D2AB431AF6
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:28:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232308AbhJRN3y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:29:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:41820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232029AbhJRN3U (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:29:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D51C460295;
        Mon, 18 Oct 2021 13:27:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634563629;
        bh=lO0DuIKUZ5zkgHkfV2sRjPBl0xkSfEwWiAYLq1/9Cq4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OOn8uW3tsgB79PpTisrrLjj1++QVj83kGSAA1xAFqqsUCcjrJ3VKMCffp+SKjCOBr
         7b6YhZacFbiBZ1I7H62KJoRTjHDqYHqZOLz13aHmaAEV3N2j1i1NIuzfav1vA5RCca
         xspRYn2QqvBTM6BfxpA4HoG2TLx18QXlVeIZmvTI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 4.14 09/39] cb710: avoid NULL pointer subtraction
Date:   Mon, 18 Oct 2021 15:24:18 +0200
Message-Id: <20211018132325.751304440@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132325.426739023@linuxfoundation.org>
References: <20211018132325.426739023@linuxfoundation.org>
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
@@ -50,7 +50,7 @@ static inline bool needs_unaligned_copy(
 #ifdef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
 	return false;
 #else
-	return ((ptr - NULL) & 3) != 0;
+	return ((uintptr_t)ptr & 3) != 0;
 #endif
 }
 


