Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6939C3C52BD
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:50:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244505AbhGLHtG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:49:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:51704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239930AbhGLHrQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:47:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4036F613E8;
        Mon, 12 Jul 2021 07:42:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075747;
        bh=C7yM1rCc6c5fY5xJxIRKLHhsb2lu0bDEcYCq30oc7bg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x6+Ay0ay3mnQ9lrMzNrcX2J/gXdff6i4GP9cEkRs3rgCjm9oAq6p0ZcfJAVHnvKJ5
         D8/wNlGE0ZLYY3lGcx3T/tYCf5K4e2YMRlBI2q9WBJKI9senuh9bPFe4itHiMRBFAe
         cFjRVuFlp9O8QeXfSDvy6c6fozA6Z6S9fi5uT0+o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joe Lawrence <joe.lawrence@redhat.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 348/800] objtool: Dont make .altinstructions writable
Date:   Mon, 12 Jul 2021 08:06:11 +0200
Message-Id: <20210712061004.066851395@linuxfoundation.org>
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

From: Josh Poimboeuf <jpoimboe@redhat.com>

[ Upstream commit e31694e0a7a709293319475d8001e05e31f2178c ]

When objtool creates the .altinstructions section, it sets the SHF_WRITE
flag to make the section writable -- unless the section had already been
previously created by the kernel.  The mismatch between kernel-created
and objtool-created section flags can cause failures with external
tooling (kpatch-build).  And the section doesn't need to be writable
anyway.

Make the section flags consistent with the kernel's.

Fixes: 9bc0bb50727c ("objtool/x86: Rewrite retpoline thunk calls")
Reported-by: Joe Lawrence <joe.lawrence@redhat.com>
Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lore.kernel.org/r/6c284ae89717889ea136f9f0064d914cd8329d31.1624462939.git.jpoimboe@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/objtool/arch/x86/decode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/objtool/arch/x86/decode.c b/tools/objtool/arch/x86/decode.c
index 523aa4157f80..bc821056aba9 100644
--- a/tools/objtool/arch/x86/decode.c
+++ b/tools/objtool/arch/x86/decode.c
@@ -684,7 +684,7 @@ static int elf_add_alternative(struct elf *elf,
 	sec = find_section_by_name(elf, ".altinstructions");
 	if (!sec) {
 		sec = elf_create_section(elf, ".altinstructions",
-					 SHF_WRITE, size, 0);
+					 SHF_ALLOC, size, 0);
 
 		if (!sec) {
 			WARN_ELF("elf_create_section");
-- 
2.30.2



