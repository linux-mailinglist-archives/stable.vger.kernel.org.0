Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA1E23A01AC
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:17:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234117AbhFHSzk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 14:55:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:49356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236060AbhFHSwR (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 14:52:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C88BC61492;
        Tue,  8 Jun 2021 18:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177606;
        bh=3HLOSHYbngO5BTWzrLQDEolTQ9SamV+ldW+DLUFDxnM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JmGEbnzCIlfPAu00G3n6CtmAr55lwyYmu2yitORsW49O18j+SaHjcLMowXoImk6HU
         +5b0Y3s6Rj+/MKd/p7zAyN18Wyc+ot8fN+8nWhydkXRPgBY1xnGjcYy1gSy45zobHu
         lV8OhLF2DOC8JFGZQHYX1bApxWMjW2jJmQsGmYy0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Changbin Du <changbin.du@gmail.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 006/137] efi/fdt: fix panic when no valid fdt found
Date:   Tue,  8 Jun 2021 20:25:46 +0200
Message-Id: <20210608175942.598702332@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175942.377073879@linuxfoundation.org>
References: <20210608175942.377073879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Changbin Du <changbin.du@gmail.com>

[ Upstream commit 668a84c1bfb2b3fd5a10847825a854d63fac7baa ]

setup_arch() would invoke efi_init()->efi_get_fdt_params(). If no
valid fdt found then initial_boot_params will be null. So we
should stop further fdt processing here. I encountered this
issue on risc-v.

Signed-off-by: Changbin Du <changbin.du@gmail.com>
Fixes: b91540d52a08b ("RISC-V: Add EFI runtime services")
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/efi/fdtparams.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/firmware/efi/fdtparams.c b/drivers/firmware/efi/fdtparams.c
index bb042ab7c2be..e901f8564ca0 100644
--- a/drivers/firmware/efi/fdtparams.c
+++ b/drivers/firmware/efi/fdtparams.c
@@ -98,6 +98,9 @@ u64 __init efi_get_fdt_params(struct efi_memory_map_data *mm)
 	BUILD_BUG_ON(ARRAY_SIZE(target) != ARRAY_SIZE(name));
 	BUILD_BUG_ON(ARRAY_SIZE(target) != ARRAY_SIZE(dt_params[0].params));
 
+	if (!fdt)
+		return 0;
+
 	for (i = 0; i < ARRAY_SIZE(dt_params); i++) {
 		node = fdt_path_offset(fdt, dt_params[i].path);
 		if (node < 0)
-- 
2.30.2



