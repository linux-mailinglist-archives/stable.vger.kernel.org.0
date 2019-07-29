Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9387F796F3
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 21:56:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391049AbfG2Tzk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:55:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:48466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391047AbfG2Tzi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:55:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E62C2204EC;
        Mon, 29 Jul 2019 19:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564430137;
        bh=T2jjRL4C0aJe4QicyVoBE1EXvP3PYDkgBDX+2pELYFA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pHJCkmnXXCETsgb65XnfDzFMr0PVuZcJpkGGo4i74OcWM069VSU33/dCTvwc1Hy8A
         pyOIXpdCDvGCinvBMTolzsix5fCpsYxfBDFwx1HWusf5Kx5guRh4SnN9/EnxOT3SG9
         qYzdZUEadLL6ewJn2MeqUvcFF1fZ1uF9FHJooLLw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 5.2 209/215] structleak: disable STRUCTLEAK_BYREF in combination with KASAN_STACK
Date:   Mon, 29 Jul 2019 21:23:25 +0200
Message-Id: <20190729190816.215884327@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190739.971253303@linuxfoundation.org>
References: <20190729190739.971253303@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

commit 173e6ee21e2b3f477f07548a79c43b8d9cfbb37d upstream.

The combination of KASAN_STACK and GCC_PLUGIN_STRUCTLEAK_BYREF
leads to much larger kernel stack usage, as seen from the warnings
about functions that now exceed the 2048 byte limit:

drivers/media/i2c/tvp5150.c:253:1: error: the frame size of 3936 bytes is larger than 2048 bytes
drivers/media/tuners/r820t.c:1327:1: error: the frame size of 2816 bytes is larger than 2048 bytes
drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_n.c:16552:1: error: the frame size of 3144 bytes is larger than 2048 bytes [-Werror=frame-larger-than=]
fs/ocfs2/aops.c:1892:1: error: the frame size of 2088 bytes is larger than 2048 bytes
fs/ocfs2/dlm/dlmrecovery.c:737:1: error: the frame size of 2088 bytes is larger than 2048 bytes
fs/ocfs2/namei.c:1677:1: error: the frame size of 2584 bytes is larger than 2048 bytes
fs/ocfs2/super.c:1186:1: error: the frame size of 2640 bytes is larger than 2048 bytes
fs/ocfs2/xattr.c:3678:1: error: the frame size of 2176 bytes is larger than 2048 bytes
net/bluetooth/l2cap_core.c:7056:1: error: the frame size of 2144 bytes is larger than 2048 bytes [-Werror=frame-larger-than=]
net/bluetooth/l2cap_core.c: In function 'l2cap_recv_frame':
net/bridge/br_netlink.c:1505:1: error: the frame size of 2448 bytes is larger than 2048 bytes
net/ieee802154/nl802154.c:548:1: error: the frame size of 2232 bytes is larger than 2048 bytes
net/wireless/nl80211.c:1726:1: error: the frame size of 2224 bytes is larger than 2048 bytes
net/wireless/nl80211.c:2357:1: error: the frame size of 4584 bytes is larger than 2048 bytes
net/wireless/nl80211.c:5108:1: error: the frame size of 2760 bytes is larger than 2048 bytes
net/wireless/nl80211.c:6472:1: error: the frame size of 2112 bytes is larger than 2048 bytes

The structleak plugin was previously disabled for CONFIG_COMPILE_TEST,
but meant we missed some bugs, so this time we should address them.

The frame size warnings are distracting, and risking a kernel stack
overflow is generally not beneficial to performance, so it may be best
to disallow that particular combination. This can be done by turning
off either one. I picked the dependency in GCC_PLUGIN_STRUCTLEAK_BYREF
and GCC_PLUGIN_STRUCTLEAK_BYREF_ALL, as this option is designed to
make uninitialized stack usage less harmful when enabled on its own,
but it also prevents KASAN from detecting those cases in which it was
in fact needed.

KASAN_STACK is currently implied by KASAN on gcc, but could be made a
user selectable option if we want to allow combining (non-stack) KASAN
with GCC_PLUGIN_STRUCTLEAK_BYREF.

Note that it would be possible to specifically address the files that
print the warning, but presumably the overall stack usage is still
significantly higher than in other configurations, so this would not
address the full problem.

I could not test this with CONFIG_INIT_STACK_ALL, which may or may not
suffer from a similar problem.

Fixes: 81a56f6dcd20 ("gcc-plugins: structleak: Generalize to all variable types")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/r/20190722114134.3123901-1-arnd@arndb.de
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 security/Kconfig.hardening |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/security/Kconfig.hardening
+++ b/security/Kconfig.hardening
@@ -61,6 +61,7 @@ choice
 	config GCC_PLUGIN_STRUCTLEAK_BYREF
 		bool "zero-init structs passed by reference (strong)"
 		depends on GCC_PLUGINS
+		depends on !(KASAN && KASAN_STACK=1)
 		select GCC_PLUGIN_STRUCTLEAK
 		help
 		  Zero-initialize any structures on the stack that may
@@ -70,9 +71,15 @@ choice
 		  exposures, like CVE-2017-1000410:
 		  https://git.kernel.org/linus/06e7e776ca4d3654
 
+		  As a side-effect, this keeps a lot of variables on the
+		  stack that can otherwise be optimized out, so combining
+		  this with CONFIG_KASAN_STACK can lead to a stack overflow
+		  and is disallowed.
+
 	config GCC_PLUGIN_STRUCTLEAK_BYREF_ALL
 		bool "zero-init anything passed by reference (very strong)"
 		depends on GCC_PLUGINS
+		depends on !(KASAN && KASAN_STACK=1)
 		select GCC_PLUGIN_STRUCTLEAK
 		help
 		  Zero-initialize any stack variables that may be passed


