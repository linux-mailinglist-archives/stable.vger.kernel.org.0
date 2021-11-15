Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 491E04525DF
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:57:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240523AbhKPB7t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:59:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:49920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240433AbhKOSJn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:09:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1D13B633AE;
        Mon, 15 Nov 2021 17:46:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998401;
        bh=KR3+Fl7Pstcu+h0z3QgDS9jHtpp2Nbp43keS4jBEWE0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L7NGiqlfg7KpdP6GLLw+0HRihgWgdVNd6QGB50d0XTywm4/s/49M6vvVpXLR2XEG1
         63yGycOZRWdBrg1pSsXEBWudgnd+0IXCb0ZTJda4HeLmSyqnuX17aGhJtLqOEQAoTR
         fsOhh6A/IA/gSMn+pVlcf+VN9LhjMODB9H31ESOM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Greg Ungerer <gerg@linux-m68k.org>,
        linux-m68k@lists.linux-m68k.org, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 495/575] m68k: set a default value for MEMORY_RESERVE
Date:   Mon, 15 Nov 2021 18:03:40 +0100
Message-Id: <20211115165400.804139580@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
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
index e161a4e1493b4..51a878803fb6d 100644
--- a/arch/m68k/Kconfig.machine
+++ b/arch/m68k/Kconfig.machine
@@ -191,6 +191,7 @@ config INIT_LCD
 config MEMORY_RESERVE
 	int "Memory reservation (MiB)"
 	depends on (UCSIMM || UCDIMM)
+	default 0
 	help
 	  Reserve certain memory regions on 68x328 based boards.
 
-- 
2.33.0



