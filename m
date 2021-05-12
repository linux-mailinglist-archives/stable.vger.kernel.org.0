Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8632037C8C5
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:43:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236844AbhELQMh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:12:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:36288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239077AbhELQHQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:07:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B552B61C33;
        Wed, 12 May 2021 15:35:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833757;
        bh=sCBOWjPFlsAS3ZI4sQKtAA1bAk5Y6r/rQizYVdgRpKw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g0TSst37pwhLnwymfxCBHIj3UP66sp9k8+KW8eTdbBodscxK9U/BKDXPGnX4Lc3cZ
         vVJYY8+5in8J1/lI/62mniRDBtQTL/JN8Qe2ect4ywOotE42xO0OXW5mSFY0QT8kTp
         CnJTk6Y3SKv4oNMoaFLuHQ2Nfsatidmsf1afaq3o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 276/601] tty: actually undefine superseded ASYNC flags
Date:   Wed, 12 May 2021 16:45:53 +0200
Message-Id: <20210512144836.908437876@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
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
index 900a32e63424..6a3ac496a56c 100644
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



