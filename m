Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A91A13E230
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 17:54:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731807AbgAPQyY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 11:54:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:38936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729903AbgAPQyX (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 11:54:23 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 781182464B;
        Thu, 16 Jan 2020 16:54:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193663;
        bh=d5Dp4/iefDU1JBWw7HWrWettcgUtKFnOxwNMP9rNjHM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U+SHBsBQ8ayS7r99yqTYX+tEqoo1o7Az/PZJ+fRM5r2s/OXCG9kLvlEvUxWhoJh0C
         8ESJxUj5bikoaJxH9pURFBR5ZxGtN5GMcxavONGGJy2bKDUX4XNMhuEMZROT8YgSea
         KgV4/Icsq801ZA49cr1EvPL5uDsph8wk02EG0zAc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.4 190/205] powerpc/archrandom: fix arch_get_random_seed_int()
Date:   Thu, 16 Jan 2020 11:42:45 -0500
Message-Id: <20200116164300.6705-190-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116164300.6705-1-sashal@kernel.org>
References: <20200116164300.6705-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ard Biesheuvel <ardb@kernel.org>

[ Upstream commit b6afd1234cf93aa0d71b4be4788c47534905f0be ]

Commit 01c9348c7620ec65

  powerpc: Use hardware RNG for arch_get_random_seed_* not arch_get_random_*

updated arch_get_random_[int|long]() to be NOPs, and moved the hardware
RNG backing to arch_get_random_seed_[int|long]() instead. However, it
failed to take into account that arch_get_random_int() was implemented
in terms of arch_get_random_long(), and so we ended up with a version
of the former that is essentially a NOP as well.

Fix this by calling arch_get_random_seed_long() from
arch_get_random_seed_int() instead.

Fixes: 01c9348c7620ec65 ("powerpc: Use hardware RNG for arch_get_random_seed_* not arch_get_random_*")
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20191204115015.18015-1-ardb@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/archrandom.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/include/asm/archrandom.h b/arch/powerpc/include/asm/archrandom.h
index 9c63b596e6ce..a09595f00cab 100644
--- a/arch/powerpc/include/asm/archrandom.h
+++ b/arch/powerpc/include/asm/archrandom.h
@@ -28,7 +28,7 @@ static inline int arch_get_random_seed_int(unsigned int *v)
 	unsigned long val;
 	int rc;
 
-	rc = arch_get_random_long(&val);
+	rc = arch_get_random_seed_long(&val);
 	if (rc)
 		*v = val;
 
-- 
2.20.1

