Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBC0C2E3B5F
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:49:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404789AbgL1NtV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:49:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:50704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406079AbgL1NtP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:49:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D0BD5205CB;
        Mon, 28 Dec 2020 13:48:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163309;
        bh=Cmb693dGfu5XqjbxWgjFllW0Sh+XN/ynuZvm/MDpHs0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SIVLgtUHBcJtZIpA8dkt0ojeOuFOmXqg/NNN4V9yQc53Jgh2T+tJqv/QJHWVheNMb
         RW80kjCFxzIO5VCsAA9NMLHiqLTQhaCS6ZVm8F8n1DgZ3+UzTLEZg3+/aoAHSNYg4e
         4Op1TDMA7ZmDUwy4uN54cFT/lPtK5c3y60eNAmh8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jordan Niethe <jniethe5@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 211/453] powerpc/64: Fix an EMIT_BUG_ENTRY in head_64.S
Date:   Mon, 28 Dec 2020 13:47:27 +0100
Message-Id: <20201228124947.372918904@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jordan Niethe <jniethe5@gmail.com>

[ Upstream commit fe18a35e685c9bdabc8b11b3e19deb85a068b75d ]

Commit 63ce271b5e37 ("powerpc/prom: convert PROM_BUG() to standard
trap") added an EMIT_BUG_ENTRY for the trap after the branch to
start_kernel(). The EMIT_BUG_ENTRY was for the address "0b", however the
trap was not labeled with "0". Hence the address used for bug is in
relative_toc() where the previous "0" label is. Label the trap as "0" so
the correct address is used.

Fixes: 63ce271b5e37 ("powerpc/prom: convert PROM_BUG() to standard trap")
Signed-off-by: Jordan Niethe <jniethe5@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20201130004404.30953-1-jniethe5@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/head_64.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/head_64.S b/arch/powerpc/kernel/head_64.S
index d61b3b13a6ec8..9019f1395d39a 100644
--- a/arch/powerpc/kernel/head_64.S
+++ b/arch/powerpc/kernel/head_64.S
@@ -992,7 +992,7 @@ start_here_common:
 	bl	start_kernel
 
 	/* Not reached */
-	trap
+0:	trap
 	EMIT_BUG_ENTRY 0b, __FILE__, __LINE__, 0
 
 /*
-- 
2.27.0



