Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4AA938A734
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:36:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234457AbhETKg0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:36:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:36796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236964AbhETKcY (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:32:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 406DA61585;
        Thu, 20 May 2021 09:52:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621504349;
        bh=OYdXUJnQLKHa4ZP4d2D5NhiOWYXIomhjQc7Si0a9dgA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SH5bU4SNawEKUDXEETMuh2dm5/gakIg7nDo6yRb/oZCMjCJGfHzpqaoyCo0WbI0G0
         xffGIXhtXhBo/x+ATeY4lKDetVAEEqQVWsf0qcBRIhv9NDbMd40IKwXA+Y/lRTpX5B
         fcIk+6FYfOHf6RBh6LmPs/B73C7YWlpDTHGPhdZ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 172/323] tty: actually undefine superseded ASYNC flags
Date:   Thu, 20 May 2021 11:21:04 +0200
Message-Id: <20210520092126.008346413@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092120.115153432@linuxfoundation.org>
References: <20210520092120.115153432@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

[ Upstream commit d09845e98a05850a8094ea8fd6dd09a8e6824fff ]

Some kernel-internal ASYNC flags have been superseded by tty-port flags
and should no longer be used by kernel drivers.

Fix the misspelled "__KERNEL__" compile guards which failed their sole
purpose to break out-of-tree drivers that have not yet been updated.

Fixes: 5c0517fefc92 ("tty: core: Undefine ASYNC_* flags superceded by TTY_PORT* flags")
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20210407095208.31838-2-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/tty_flags.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/tty_flags.h b/include/uapi/linux/tty_flags.h
index 6ac609a00dea..31e106168ebb 100644
--- a/include/uapi/linux/tty_flags.h
+++ b/include/uapi/linux/tty_flags.h
@@ -39,7 +39,7 @@
  * WARNING: These flags are no longer used and have been superceded by the
  *	    TTY_PORT_ flags in the iflags field (and not userspace-visible)
  */
-#ifndef _KERNEL_
+#ifndef __KERNEL__
 #define ASYNCB_INITIALIZED	31 /* Serial port was initialized */
 #define ASYNCB_SUSPENDED	30 /* Serial port is suspended */
 #define ASYNCB_NORMAL_ACTIVE	29 /* Normal device is active */
@@ -81,7 +81,7 @@
 #define ASYNC_SPD_WARP		(ASYNC_SPD_HI|ASYNC_SPD_SHI)
 #define ASYNC_SPD_MASK		(ASYNC_SPD_HI|ASYNC_SPD_VHI|ASYNC_SPD_SHI)
 
-#ifndef _KERNEL_
+#ifndef __KERNEL__
 /* These flags are no longer used (and were always masked from userspace) */
 #define ASYNC_INITIALIZED	(1U << ASYNCB_INITIALIZED)
 #define ASYNC_NORMAL_ACTIVE	(1U << ASYNCB_NORMAL_ACTIVE)
-- 
2.30.2



