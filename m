Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD5E81F2CCB
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:30:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730149AbgFHXQB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 19:16:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:37204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730142AbgFHXQA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:16:00 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 74F742068D;
        Mon,  8 Jun 2020 23:15:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658159;
        bh=SGCaoOMYYcm8aE6If3PJMgTqwZ7DYL1Rsw+HKEuNXM0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1Ng9fo0pcWdT8ksumAzqmILuA5Rj2r/P3x2FeyFNJAbANEHZ5BpnkUt76Z0FSwZI2
         JGBKO9u+5m4ugCY/ppoD0A/KfNn8VBSsCp7jvmjp1DBinXmTEefuFX3m2uVRM3wBCb
         0UrsWK+l6v48lpX78swFeKxgQGCPcT/BbKbuDavE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>,
        John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Rich Felker <dalias@libc.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-sh@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 189/606] sh: include linux/time_types.h for sockios
Date:   Mon,  8 Jun 2020 19:05:14 -0400
Message-Id: <20200608231211.3363633-189-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

commit fc94cf2092c7c1267fa2deb8388d624f50eba808 upstream.

Using the socket ioctls on arch/sh (and only there) causes build time
problems when __kernel_old_timeval/__kernel_old_timespec are not already
visible to the compiler.

Add an explict include line for the header that defines these
structures.

Fixes: 8c709f9a0693 ("y2038: sh: remove timeval/timespec usage from headers")
Fixes: 0768e17073dc ("net: socket: implement 64-bit timestamps")
Reported-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Tested-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Rich Felker <dalias@libc.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: <stable@vger.kernel.org>
Link: http://lkml.kernel.org/r/20200519131327.1836482-1-arnd@arndb.de
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/sh/include/uapi/asm/sockios.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/sh/include/uapi/asm/sockios.h b/arch/sh/include/uapi/asm/sockios.h
index 3da561453260..ef01ced9e169 100644
--- a/arch/sh/include/uapi/asm/sockios.h
+++ b/arch/sh/include/uapi/asm/sockios.h
@@ -2,6 +2,8 @@
 #ifndef __ASM_SH_SOCKIOS_H
 #define __ASM_SH_SOCKIOS_H
 
+#include <linux/time_types.h>
+
 /* Socket-level I/O control calls. */
 #define FIOGETOWN	_IOR('f', 123, int)
 #define FIOSETOWN 	_IOW('f', 124, int)
-- 
2.25.1

