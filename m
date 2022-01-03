Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CA4E4832C4
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 15:31:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234199AbiACOao (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 09:30:44 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:60396 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234390AbiACO3E (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 09:29:04 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 567E9B80F4B;
        Mon,  3 Jan 2022 14:29:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90335C36AEB;
        Mon,  3 Jan 2022 14:29:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641220142;
        bh=KN/rfn8uLbLW12jyH3PUZ8URqNdpwFCpFYUNeRo93vw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jX6pxKJVH5SSf48d+rgZTRnFxh//NceBpPn4wly8Sv06hMJPkhfSaMSq9vnknNUFf
         lZ7BvXAfUZO6hYl0S78eR+Ytqn8QiG23rtAtRLKkmqDJ4d+YhsvXw4YrMD0G0vX27O
         Z3ZBNgbnfYu60aYAMCGO+G1xjJSn++kQJHUTBMa0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Helge Deller <deller@gmx.de>,
        Sasha Levin <sashal@kernel.org>,
        John David Anglin <dave.anglin@bell.net>
Subject: [PATCH 5.10 05/48] parisc: Clear stale IIR value on instruction access rights trap
Date:   Mon,  3 Jan 2022 15:23:42 +0100
Message-Id: <20220103142053.666629092@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220103142053.466768714@linuxfoundation.org>
References: <20220103142053.466768714@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index a52c7abf2ca49..43f56335759a4 100644
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



