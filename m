Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCF614803A7
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 20:04:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232207AbhL0TEi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 14:04:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232277AbhL0TEg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 14:04:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7FD1C061759;
        Mon, 27 Dec 2021 11:04:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A5CCCB8113A;
        Mon, 27 Dec 2021 19:04:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37777C36AEB;
        Mon, 27 Dec 2021 19:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640631873;
        bh=q8GQ0idVUk6E53tZV9x+Gz/Ls/J93W3qTYLPAqfTOk4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XVjBhDBHGtu2Swa6OuTfAyIh1uqtQAxrhs+szTEx3W/eRiZaY8F8QXzEkocqlWHMx
         PzzuyNHe9FQYf+GurjHwSEI9i4pyOoeL6R2AQPrbC6CH3k3t/kHbq6Y+96AfwkN0Y/
         YfdiEVITEyCMoOvNFSr5Zc3xvQA7g+YKDUsC8ErLQIkDidPLw8TwbmXGWLN5c4HMkr
         SYvsppY4kiWszEKJkV2Rxcd5loZwNfEhJoa9u3Ih89QhMZQl2FUc53b+zm/xFLt3oa
         BZ7Mo3pxQmr3W6k7e6YutaCXkRnvy2cSjbacbKW0PrMFCVK3tMphFbgyh0EUi9J01f
         VSsR2BsSUyY3Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Helge Deller <deller@gmx.de>,
        John David Anglin <dave.anglin@bell.net>,
        Sasha Levin <sashal@kernel.org>,
        James.Bottomley@HansenPartnership.com, svens@stackframe.org,
        akpm@linux-foundation.org, mpe@ellerman.id.au,
        rmk+kernel@armlinux.org.uk, wangkefeng.wang@huawei.com,
        linux-parisc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 20/26] parisc: Clear stale IIR value on instruction access rights trap
Date:   Mon, 27 Dec 2021 14:03:21 -0500
Message-Id: <20211227190327.1042326-20-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227190327.1042326-1-sashal@kernel.org>
References: <20211227190327.1042326-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Helge Deller <deller@gmx.de>

[ Upstream commit 484730e5862f6b872dca13840bed40fd7c60fa26 ]

When a trap 7 (Instruction access rights) occurs, this means the CPU
couldn't execute an instruction due to missing execute permissions on
the memory region.  In this case it seems the CPU didn't even fetched
the instruction from memory and thus did not store it in the cr19 (IIR)
register before calling the trap handler. So, the trap handler will find
some random old stale value in cr19.

This patch simply overwrites the stale IIR value with a constant magic
"bad food" value (0xbaadf00d), in the hope people don't start to try to
understand the various random IIR values in trap 7 dumps.

Noticed-by: John David Anglin <dave.anglin@bell.net>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/parisc/kernel/traps.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/parisc/kernel/traps.c b/arch/parisc/kernel/traps.c
index 747c328fb8862..197cb8480350c 100644
--- a/arch/parisc/kernel/traps.c
+++ b/arch/parisc/kernel/traps.c
@@ -729,6 +729,8 @@ void notrace handle_interruption(int code, struct pt_regs *regs)
 			}
 			mmap_read_unlock(current->mm);
 		}
+		/* CPU could not fetch instruction, so clear stale IIR value. */
+		regs->iir = 0xbaadf00d;
 		fallthrough;
 	case 27: 
 		/* Data memory protection ID trap */
-- 
2.34.1

