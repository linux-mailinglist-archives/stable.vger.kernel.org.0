Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98BFB329026
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:08:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242683AbhCAUDO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:03:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:58994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242340AbhCATxJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:53:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D1B23652EF;
        Mon,  1 Mar 2021 17:53:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621191;
        bh=PLk9iq11IF6QGS0K1+ZHwi7OSpuxjvyczOiwjo4UNO8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vpbuQU42ko1WQIoY9VHpPPvx7JGQT1I2dsNaLUVmsORz+HH40Qch16o6bvtfnVLDZ
         ROEQb7J5MS1BYXJq8trAZVoyKaL7HybOPLTw4Swos5hUaEMSusM1HOWbDFvGVfoWFd
         TYUVn7QnZT05yH7aroW5X9Es28cEuqXnXNzZNkuk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sandipan Das <sandipan@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 425/775] powerpc/sstep: Fix darn emulation
Date:   Mon,  1 Mar 2021 17:09:53 +0100
Message-Id: <20210301161222.573329054@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sandipan Das <sandipan@linux.ibm.com>

[ Upstream commit 22b89ba178dd0a66a26699ead014a3e73ff8e044 ]

Commit 8813ff49607e ("powerpc/sstep: Check instruction validity
against ISA version before emulation") introduced a proper way to skip
unknown instructions. This makes sure that the same is used for the
darn instruction when the range selection bits have a reserved value.

Fixes: a23987ef267a ("powerpc: sstep: Add support for darn instruction")
Signed-off-by: Sandipan Das <sandipan@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20210204080744.135785-2-sandipan@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/lib/sstep.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/lib/sstep.c b/arch/powerpc/lib/sstep.c
index 25cfa9c622c58..bb5c20d4ca91c 100644
--- a/arch/powerpc/lib/sstep.c
+++ b/arch/powerpc/lib/sstep.c
@@ -1918,7 +1918,7 @@ int analyse_instr(struct instruction_op *op, const struct pt_regs *regs,
 				goto compute_done;
 			}
 
-			return -1;
+			goto unknown_opcode;
 #ifdef __powerpc64__
 		case 777:	/* modsd */
 			if (!cpu_has_feature(CPU_FTR_ARCH_300))
-- 
2.27.0



