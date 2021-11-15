Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9722C45221A
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:07:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232380AbhKPBJ7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:09:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:44614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244839AbhKOTRl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:17:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7DC0F634D6;
        Mon, 15 Nov 2021 18:24:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000679;
        bh=7J8bKQyvNqfgWZyP5BSAD1z8Bk+pzfZqEaKjqjnVTO8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vaco6BBJCzrvkdybzBraGMC64NU8xPA7vsQkVslecCYc4HbcW8dcNxxgXHZoT4j0z
         tXVchWCTKrVetZ327hYVKfuJi9tIxpRwSdOZcIgeusD5+wMCKfqggqC4wOxaijcGUp
         HXtaa015DXCXhrSVW6vnXM2/wiG3eJV3tqDxoVpc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Greg Ungerer <gerg@linux-m68k.org>,
        linux-m68k@lists.linux-m68k.org, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 707/849] m68k: set a default value for MEMORY_RESERVE
Date:   Mon, 15 Nov 2021 18:03:10 +0100
Message-Id: <20211115165444.177969196@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 1aaa557b2db95c9506ed0981bc34505c32d6b62b ]

'make randconfig' can produce a .config file with
"CONFIG_MEMORY_RESERVE=" (no value) since it has no default.
When a subsequent 'make all' is done, kconfig restarts the config
and prompts for a value for MEMORY_RESERVE. This breaks
scripting/automation where there is no interactive user input.

Add a default value for MEMORY_RESERVE. (Any integer value will
work here for kconfig.)

Fixes a kconfig warning:

.config:214:warning: symbol value '' invalid for MEMORY_RESERVE
* Restart config...
Memory reservation (MiB) (MEMORY_RESERVE) [] (NEW)

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2") # from beginning of git history
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Greg Ungerer <gerg@linux-m68k.org>
Cc: linux-m68k@lists.linux-m68k.org
Signed-off-by: Greg Ungerer <gerg@linux-m68k.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/m68k/Kconfig.machine | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/m68k/Kconfig.machine b/arch/m68k/Kconfig.machine
index 6a07a68178856..a5222aaa19f67 100644
--- a/arch/m68k/Kconfig.machine
+++ b/arch/m68k/Kconfig.machine
@@ -203,6 +203,7 @@ config INIT_LCD
 config MEMORY_RESERVE
 	int "Memory reservation (MiB)"
 	depends on (UCSIMM || UCDIMM)
+	default 0
 	help
 	  Reserve certain memory regions on 68x328 based boards.
 
-- 
2.33.0



