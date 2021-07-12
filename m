Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BA683C5373
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:51:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352423AbhGLHyq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:54:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:36234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350376AbhGLHu6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:50:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CF6EF614A7;
        Mon, 12 Jul 2021 07:44:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075885;
        bh=7Yg+r15AMz/DCNPhSSl49mMUAuoRK2BGZGtJvKaYNvs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w5YifSSWewOlXz8lKo5MtPPAG9HmJhMMiRACGvNkvoeA94XdJW1mBLVfbTC+3RxRb
         xXicAErLvLzNzstUXS8D5pZd1ahp+dUuDGv2fgMGz2TcIvRGythG0Gj2cYoglTfDK1
         3bA2XXZ7+4RpBkyUw6RzQF+/UiGWQVyupiC1sOdU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 406/800] libbpf: Fix ELF symbol visibility update logic
Date:   Mon, 12 Jul 2021 08:07:09 +0200
Message-Id: <20210712061010.364789174@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrii Nakryiko <andrii@kernel.org>

[ Upstream commit 247b8634e6446dbc8024685f803290501cba226f ]

Fix silly bug in updating ELF symbol's visibility.

Fixes: a46349227cd8 ("libbpf: Add linker extern resolution support for functions and global variables")
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20210507054119.270888-6-andrii@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/linker.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/bpf/linker.c b/tools/lib/bpf/linker.c
index 9de084b1c699..f44f8a37f780 100644
--- a/tools/lib/bpf/linker.c
+++ b/tools/lib/bpf/linker.c
@@ -1780,7 +1780,7 @@ static void sym_update_visibility(Elf64_Sym *sym, int sym_vis)
 	/* libelf doesn't provide setters for ST_VISIBILITY,
 	 * but it is stored in the lower 2 bits of st_other
 	 */
-	sym->st_other &= 0x03;
+	sym->st_other &= ~0x03;
 	sym->st_other |= sym_vis;
 }
 
-- 
2.30.2



