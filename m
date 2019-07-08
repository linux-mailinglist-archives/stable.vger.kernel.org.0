Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18D1C624BF
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:45:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387852AbfGHPWC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:22:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:48214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730971AbfGHPWB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:22:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 01E8521734;
        Mon,  8 Jul 2019 15:22:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562599321;
        bh=KawLcqAK8Jtlnzz5LbCaBUmEuHDVz6zoCaHEviFevVk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V9loN213sl9t7WNp4KeyDiWVjfcZ02yJpm6a0hnPjTCpek6uV0XVMk/P7TnKN1f2I
         rHC1HzBWyx96lgisDgf36AzOr+OOWaR1zFNJKX0G578pvCHt368+GCBTUEuIa2BoeP
         RGY0vpF6ReqUh9X7HnNZRHQKvS6O2QMR8hyH5X7M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Burton <paul.burton@mips.com>,
        Ganesan Ramalingam <ganesanr@broadcom.com>,
        James Hogan <jhogan@kernel.org>,
        Jayachandran C <jnair@caviumnetworks.com>,
        John Crispin <john@phrozen.org>,
        Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 077/102] MIPS: netlogic: xlr: Remove erroneous check in nlm_fmn_send()
Date:   Mon,  8 Jul 2019 17:13:10 +0200
Message-Id: <20190708150530.442187589@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708150525.973820964@linuxfoundation.org>
References: <20190708150525.973820964@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 02eec6c9fc0cb13169cc97a6139771768791f92b ]

In nlm_fmn_send() we have a loop which attempts to send a message
multiple times in order to handle the transient failure condition of a
lack of available credit. When examining the status register to detect
the failure we check for a condition that can never be true, which falls
foul of gcc 8's -Wtautological-compare:

  In file included from arch/mips/netlogic/common/irq.c:65:
  ./arch/mips/include/asm/netlogic/xlr/fmn.h: In function 'nlm_fmn_send':
  ./arch/mips/include/asm/netlogic/xlr/fmn.h:304:22: error: bitwise
    comparison always evaluates to false [-Werror=tautological-compare]
     if ((status & 0x2) == 1)
                        ^~

If the path taken if this condition were true all we do is print a
message to the kernel console. Since failures seem somewhat expected
here (making the console message questionable anyway) and the condition
has clearly never evaluated true we simply remove it, rather than
attempting to fix it to check status correctly.

Signed-off-by: Paul Burton <paul.burton@mips.com>
Patchwork: https://patchwork.linux-mips.org/patch/20174/
Cc: Ganesan Ramalingam <ganesanr@broadcom.com>
Cc: James Hogan <jhogan@kernel.org>
Cc: Jayachandran C <jnair@caviumnetworks.com>
Cc: John Crispin <john@phrozen.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/include/asm/netlogic/xlr/fmn.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/mips/include/asm/netlogic/xlr/fmn.h b/arch/mips/include/asm/netlogic/xlr/fmn.h
index 5604db3d1836..d79c68fa78d9 100644
--- a/arch/mips/include/asm/netlogic/xlr/fmn.h
+++ b/arch/mips/include/asm/netlogic/xlr/fmn.h
@@ -301,8 +301,6 @@ static inline int nlm_fmn_send(unsigned int size, unsigned int code,
 	for (i = 0; i < 8; i++) {
 		nlm_msgsnd(dest);
 		status = nlm_read_c2_status0();
-		if ((status & 0x2) == 1)
-			pr_info("Send pending fail!\n");
 		if ((status & 0x4) == 0)
 			return 0;
 	}
-- 
2.20.1



