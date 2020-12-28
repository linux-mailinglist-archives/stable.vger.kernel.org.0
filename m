Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 406292E3E10
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:24:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502466AbgL1OXG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:23:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:58134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439205AbgL1OXC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:23:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 31C31206D4;
        Mon, 28 Dec 2020 14:22:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165366;
        bh=WRweE56Sggq+j1TTQlMOnNqJFbetII3+OiqQ4iwFQzQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nQWLcePOcqq1nA/TwvKH2iM81Wqy6dugxhEuV1/VTf90+/JgzbEfGX4ddxbEYjBJY
         lL1vuhkOmj7NL31d/oqJyufnmfQYbXEnVLV6i3yQbu1h1W+BK1/sbjTzs/3NUG7RsV
         kdkfIQ2AXmf7qmXV5Ev17i65RP8Vo6ckfSZSvkkc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 504/717] ARM: 9036/1: uncompress: Fix dbgadtb size parameter name
Date:   Mon, 28 Dec 2020 13:48:22 +0100
Message-Id: <20201228125045.105550253@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 1ecec38547d415054fdb63a231234f44396b6d06 ]

The dbgadtb macro is passed the size of the appended DTB, not the end
address.

Fixes: c03e41470e901123 ("ARM: 9010/1: uncompress: Print the location of appended DTB")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/compressed/head.S | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/compressed/head.S b/arch/arm/boot/compressed/head.S
index caa27322a0ab7..3a392983ac079 100644
--- a/arch/arm/boot/compressed/head.S
+++ b/arch/arm/boot/compressed/head.S
@@ -116,7 +116,7 @@
 		/*
 		 * Debug print of the final appended DTB location
 		 */
-		.macro dbgadtb, begin, end
+		.macro dbgadtb, begin, size
 #ifdef DEBUG
 		kputc   #'D'
 		kputc   #'T'
@@ -129,7 +129,7 @@
 		kputc	#'('
 		kputc	#'0'
 		kputc	#'x'
-		kphex	\end, 8		/* End of appended DTB */
+		kphex	\size, 8	/* Size of appended DTB */
 		kputc	#')'
 		kputc	#'\n'
 #endif
-- 
2.27.0



