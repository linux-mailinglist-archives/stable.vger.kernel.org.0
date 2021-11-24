Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC26245BE14
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:41:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243582AbhKXMog (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:44:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:44902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344234AbhKXMmm (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:42:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2DA1A61401;
        Wed, 24 Nov 2021 12:25:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637756721;
        bh=jT/8A8Y1sg1F60qNUNPOGGswM2LgQvQGCL4U+19B91s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PD+1G6M7D7AHZBzgGFdJ/PRmSYsgMNZvc5OENZAqrpTgYE3rWXr0cS63AzrMc/UyU
         xA9w85MKRK/Niq2KqqLcfclN47UuW4wkCGjlgABZHy+jVPyzQOFLrTquOCdlamJ2+5
         Mh0Fu05kYSr/Crq8i4B0oYEFBJaVjkhvaIqzNd3Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Greg Ungerer <gerg@linux-m68k.org>,
        linux-m68k@lists.linux-m68k.org, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 174/251] m68k: set a default value for MEMORY_RESERVE
Date:   Wed, 24 Nov 2021 12:56:56 +0100
Message-Id: <20211124115716.317461738@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115710.214900256@linuxfoundation.org>
References: <20211124115710.214900256@linuxfoundation.org>
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
index 5cd57b4d36156..4a1697fa9a37d 100644
--- a/arch/m68k/Kconfig.machine
+++ b/arch/m68k/Kconfig.machine
@@ -185,6 +185,7 @@ config INIT_LCD
 config MEMORY_RESERVE
 	int "Memory reservation (MiB)"
 	depends on (UCSIMM || UCDIMM)
+	default 0
 	help
 	  Reserve certain memory regions on 68x328 based boards.
 
-- 
2.33.0



