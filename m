Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B558845C4E2
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:49:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352330AbhKXNwz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:52:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:41982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352028AbhKXNux (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:50:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 48F7561C19;
        Wed, 24 Nov 2021 13:04:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637759043;
        bh=tqpN3gXnWopqGetBBiFAQHr6fgZWEqZOJpnpFBjko/Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0ZMeKZw+hrlabLX8YXooCoZnQ513KtACsZhmqhqWXFYOMYmUZaS+AaU03tC6QornG
         RRv8MFd6teEZLflRytZxKE1DXdHpHBm1Rb8OPp+xp6ClWPd3bcz2kjK38flvEHBtXl
         cf15boO2iv5IzM9OZty6R42kPxAWqOL5UteWRK4Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Rich Felker <dalias@libc.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 087/279] sh: define __BIG_ENDIAN for math-emu
Date:   Wed, 24 Nov 2021 12:56:14 +0100
Message-Id: <20211124115721.719342942@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit b929926f01f2d14635345d22eafcf60feed1085e ]

Fix this by defining both ENDIAN macros in
<asm/sfp-machine.h> so that they can be utilized in
<math-emu/soft-fp.h> according to the latter's comment:
/* Allow sfp-machine to have its own byte order definitions. */

(This is what is done in arch/nds32/include/asm/sfp-machine.h.)

This placates these build warnings:

In file included from ../arch/sh/math-emu/math.c:23:
.../include/math-emu/single.h:50:21: warning: "__BIG_ENDIAN" is not defined, evaluates to 0 [-Wundef]
   50 | #if __BYTE_ORDER == __BIG_ENDIAN
In file included from ../arch/sh/math-emu/math.c:24:
.../include/math-emu/double.h:59:21: warning: "__BIG_ENDIAN" is not defined, evaluates to 0 [-Wundef]
   59 | #if __BYTE_ORDER == __BIG_ENDIAN

Fixes: 4b565680d163 ("sh: math-emu support")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Tested-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Signed-off-by: Rich Felker <dalias@libc.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/sh/include/asm/sfp-machine.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/sh/include/asm/sfp-machine.h b/arch/sh/include/asm/sfp-machine.h
index cbc7cf8c97ce6..2d2423478b71d 100644
--- a/arch/sh/include/asm/sfp-machine.h
+++ b/arch/sh/include/asm/sfp-machine.h
@@ -13,6 +13,14 @@
 #ifndef _SFP_MACHINE_H
 #define _SFP_MACHINE_H
 
+#ifdef __BIG_ENDIAN__
+#define __BYTE_ORDER __BIG_ENDIAN
+#define __LITTLE_ENDIAN 0
+#else
+#define __BYTE_ORDER __LITTLE_ENDIAN
+#define __BIG_ENDIAN 0
+#endif
+
 #define _FP_W_TYPE_SIZE		32
 #define _FP_W_TYPE		unsigned long
 #define _FP_WS_TYPE		signed long
-- 
2.33.0



