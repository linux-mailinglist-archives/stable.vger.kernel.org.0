Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 719E6134C03
	for <lists+stable@lfdr.de>; Wed,  8 Jan 2020 20:49:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727782AbgAHTs6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jan 2020 14:48:58 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43604 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730438AbgAHTqD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jan 2020 14:46:03 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1ipHHD-0006p9-Ir; Wed, 08 Jan 2020 19:45:59 +0000
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1ipHHC-007dnz-Pq; Wed, 08 Jan 2020 19:45:58 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Will Deacon" <will.deacon@arm.com>,
        "Arnd Bergmann" <arnd@arndb.de>,
        "Eric Biggers" <ebiggers@google.com>
Date:   Wed, 08 Jan 2020 19:43:42 +0000
Message-ID: <lsq.1578512578.323963673@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 44/63] arm64: support keyctl() system call in 32-bit mode
In-Reply-To: <lsq.1578512578.117275639@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.81-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Biggers <ebiggers@google.com>

commit 5c2a625937ba49bc691089370638223d310cda9a upstream.

As is the case for a number of other architectures that have a 32-bit
compat mode, enable KEYS_COMPAT if both COMPAT and KEYS are enabled.
This allows AArch32 programs to use the keyctl() system call when
running on an AArch64 kernel.

Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/arm64/Kconfig | 4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -352,6 +352,10 @@ config SYSVIPC_COMPAT
 	def_bool y
 	depends on COMPAT && SYSVIPC
 
+config KEYS_COMPAT
+	def_bool y
+	depends on COMPAT && KEYS
+
 endmenu
 
 menu "Power management options"

