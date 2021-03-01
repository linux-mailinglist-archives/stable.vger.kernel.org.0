Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 122E23286D9
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:17:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237589AbhCARQY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:16:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:35322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236705AbhCARIk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:08:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A77F46501A;
        Mon,  1 Mar 2021 16:42:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614616937;
        bh=IQm274TH81NJQAivFceA9UbgaBsm3T1pEjaL593cptA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pLqffyJnlMEHnhO1dTT1Fbpfqi5Ax1c4DbehBVGNQhd6q8oENO6yW2L4xsAOgdgsD
         EDolMUhyUqLEP2sMjGtQ2123pNzUOIbaLZi7eo4b8s81uM6uH8F8cEK7ttRXlzIftI
         FSojMAcGBRD9SbSk5OQ+QGMq7pTSLq1oNQZUZjwo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 146/247] powerpc/8xx: Fix software emulation interrupt
Date:   Mon,  1 Mar 2021 17:12:46 +0100
Message-Id: <20210301161038.821615480@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161031.684018251@linuxfoundation.org>
References: <20210301161031.684018251@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@csgroup.eu>

[ Upstream commit 903178d0ce6bb30ef80a3604ab9ee2b57869fbc9 ]

For unimplemented instructions or unimplemented SPRs, the 8xx triggers
a "Software Emulation Exception" (0x1000). That interrupt doesn't set
reason bits in SRR1 as the "Program Check Exception" does.

Go through emulation_assist_interrupt() to set REASON_ILLEGAL.

Fixes: fbbcc3bb139e ("powerpc/8xx: Remove SoftwareEmulation()")
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/ad782af87a222efc79cfb06079b0fd23d4224eaf.1612515180.git.christophe.leroy@csgroup.eu
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/head_8xx.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/head_8xx.S b/arch/powerpc/kernel/head_8xx.S
index dc99258f2e8c6..08c16aa0dd534 100644
--- a/arch/powerpc/kernel/head_8xx.S
+++ b/arch/powerpc/kernel/head_8xx.S
@@ -269,7 +269,7 @@ SystemCall:
 /* On the MPC8xx, this is a software emulation interrupt.  It occurs
  * for all unimplemented and illegal instructions.
  */
-	EXCEPTION(0x1000, SoftEmu, program_check_exception, EXC_XFER_STD)
+	EXCEPTION(0x1000, SoftEmu, emulation_assist_interrupt, EXC_XFER_STD)
 
 	. = 0x1100
 /*
-- 
2.27.0



