Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 076D6483348
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 15:35:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235031AbiACOfb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 09:35:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234836AbiACOdw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 09:33:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FDDBC08E84C;
        Mon,  3 Jan 2022 06:32:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2758FB80EF1;
        Mon,  3 Jan 2022 14:32:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60886C36AEB;
        Mon,  3 Jan 2022 14:32:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641220327;
        bh=q8GQ0idVUk6E53tZV9x+Gz/Ls/J93W3qTYLPAqfTOk4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rl1i6zJ9jORyXr38gzvSeKwxIERB12bKz2wQYDhH31FUWD/zI81FTmKEtRabmpNzx
         HJB90/GDZxl1sHqQW82PFT2fbmbQxgiLvZVLkrqWQ82nhzsMpV7C+wQ9Zvtbhkk63Z
         xeic8oMJCxnPJAAbbCHG4oRPDF/3bgFSqfBlSnzQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Helge Deller <deller@gmx.de>,
        Sasha Levin <sashal@kernel.org>,
        John David Anglin <dave.anglin@bell.net>
Subject: [PATCH 5.15 06/73] parisc: Clear stale IIR value on instruction access rights trap
Date:   Mon,  3 Jan 2022 15:23:27 +0100
Message-Id: <20220103142057.121102372@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220103142056.911344037@linuxfoundation.org>
References: <20220103142056.911344037@linuxfoundation.org>
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



