Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1AB4111C35
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 23:41:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728571AbfLCWli (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:41:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:56136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728010AbfLCWlh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:41:37 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC224206EC;
        Tue,  3 Dec 2019 22:41:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575412896;
        bh=rVZzP/AuY95X8lLF2WPC13H6Ownzzvvg4e07Aeokemg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=phDpWh07NSfw36yYfTK2zYGmngx1k4BiMG4iGPP2dOmTlpsob2Aj8Ao/wQGIHjAUX
         fGnBL/Jl/bCWT/Lq8S14Cq//CVy+/3xRlNkHnmDHSOzdufEiIiFbycceHrM3x3K+Oq
         Ib99zmdmUZ1Pg0l8jDQVL1ftpDc8GVabXYSmHcws=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, noreply@ellerman.id.au,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 041/135] fbdev: c2p: Fix link failure on non-inlining
Date:   Tue,  3 Dec 2019 23:34:41 +0100
Message-Id: <20191203213014.848583874@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203213005.828543156@linuxfoundation.org>
References: <20191203213005.828543156@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>

[ Upstream commit b330f3972f4f2a829d41fb9e9b552bec7d73a840 ]

When the compiler decides not to inline the Chunky-to-Planar core
functions, the build fails with:

    c2p_planar.c:(.text+0xd6): undefined reference to `c2p_unsupported'
    c2p_planar.c:(.text+0x1dc): undefined reference to `c2p_unsupported'
    c2p_iplan2.c:(.text+0xc4): undefined reference to `c2p_unsupported'
    c2p_iplan2.c:(.text+0x150): undefined reference to `c2p_unsupported'

Fix this by marking the functions __always_inline.

While this could be triggered before by manually enabling both
CONFIG_OPTIMIZE_INLINING and CONFIG_CC_OPTIMIZE_FOR_SIZE, it was exposed
in the m68k defconfig by commit ac7c3e4ff401b304 ("compiler: enable
CONFIG_OPTIMIZE_INLINING forcibly").

Fixes: 9012d011660ea5cf ("compiler: allow all arches to enable CONFIG_OPTIMIZE_INLINING")
Reported-by: noreply@ellerman.id.au
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Reviewed-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Link: https://patchwork.freedesktop.org/patch/msgid/20190927094708.11563-1-geert@linux-m68k.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/c2p_core.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/video/fbdev/c2p_core.h b/drivers/video/fbdev/c2p_core.h
index e1035a865fb94..45a6d895a7d72 100644
--- a/drivers/video/fbdev/c2p_core.h
+++ b/drivers/video/fbdev/c2p_core.h
@@ -29,7 +29,7 @@ static inline void _transp(u32 d[], unsigned int i1, unsigned int i2,
 
 extern void c2p_unsupported(void);
 
-static inline u32 get_mask(unsigned int n)
+static __always_inline u32 get_mask(unsigned int n)
 {
 	switch (n) {
 	case 1:
@@ -57,7 +57,7 @@ static inline u32 get_mask(unsigned int n)
      *  Transpose operations on 8 32-bit words
      */
 
-static inline void transp8(u32 d[], unsigned int n, unsigned int m)
+static __always_inline void transp8(u32 d[], unsigned int n, unsigned int m)
 {
 	u32 mask = get_mask(n);
 
@@ -99,7 +99,7 @@ static inline void transp8(u32 d[], unsigned int n, unsigned int m)
      *  Transpose operations on 4 32-bit words
      */
 
-static inline void transp4(u32 d[], unsigned int n, unsigned int m)
+static __always_inline void transp4(u32 d[], unsigned int n, unsigned int m)
 {
 	u32 mask = get_mask(n);
 
@@ -126,7 +126,7 @@ static inline void transp4(u32 d[], unsigned int n, unsigned int m)
      *  Transpose operations on 4 32-bit words (reverse order)
      */
 
-static inline void transp4x(u32 d[], unsigned int n, unsigned int m)
+static __always_inline void transp4x(u32 d[], unsigned int n, unsigned int m)
 {
 	u32 mask = get_mask(n);
 
-- 
2.20.1



