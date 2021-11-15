Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82867450C21
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:32:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236819AbhKORfC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:35:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:45792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238176AbhKORdi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:33:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0531A60F22;
        Mon, 15 Nov 2021 17:21:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636996902;
        bh=iIKX5yfv9uwF+P+1c+mH0hmTXAkbWkdnhEr6khbfSpI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A23Pin89CkGH/fkHRMK+mMUvsbBhbFqBbMlJl4doOCuxHyRCQGCx5yvYJSM06MCq2
         NYWqNlDX9a+MJf61N7RgLM97sCEVqXM0Gjg2hapCsjSlo9ulDY6CakQPI0CMQbIQxs
         0pzXf+O76/6WgTrfkOL/Q5u0HLYeI6OBFQHQZiVw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Greg Ungerer <gerg@linux-m68k.org>,
        linux-m68k@lists.linux-m68k.org, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 308/355] m68k: set a default value for MEMORY_RESERVE
Date:   Mon, 15 Nov 2021 18:03:52 +0100
Message-Id: <20211115165323.686018432@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165313.549179499@linuxfoundation.org>
References: <20211115165313.549179499@linuxfoundation.org>
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
index 1bbe0dd0c4fe5..b88a980f56f8a 100644
--- a/arch/m68k/Kconfig.machine
+++ b/arch/m68k/Kconfig.machine
@@ -190,6 +190,7 @@ config INIT_LCD
 config MEMORY_RESERVE
 	int "Memory reservation (MiB)"
 	depends on (UCSIMM || UCDIMM)
+	default 0
 	help
 	  Reserve certain memory regions on 68x328 based boards.
 
-- 
2.33.0



