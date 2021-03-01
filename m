Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B130E3285AD
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 17:59:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236522AbhCAQ4r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 11:56:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:50422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235742AbhCAQte (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:49:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1934464FA8;
        Mon,  1 Mar 2021 16:32:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614616368;
        bh=BZzsVErNgiH1I1NapwYKPOpvHbLEZOWfA8JSE17bWzQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vUfPhkKE7sSLslJt/Q1j7fip1HiRuLk/kmoOAtf/dCdAQ1VDiJff+nWOif9PjmmlH
         AtGaqdCOaVHOTcNTHJZmrED2juCJ085qj6irb7olxPl8VuCFJPNm7tUkvqgt4k/Hb4
         9JgyxmevM/i7fsKIsQ170fQekVhncJqH4Mk+z3TM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 097/176] powerpc/8xx: Fix software emulation interrupt
Date:   Mon,  1 Mar 2021 17:12:50 +0100
Message-Id: <20210301161025.801266931@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161020.931630716@linuxfoundation.org>
References: <20210301161020.931630716@linuxfoundation.org>
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
index 43884af0e35c4..95ecfec96b495 100644
--- a/arch/powerpc/kernel/head_8xx.S
+++ b/arch/powerpc/kernel/head_8xx.S
@@ -301,7 +301,7 @@ SystemCall:
 /* On the MPC8xx, this is a software emulation interrupt.  It occurs
  * for all unimplemented and illegal instructions.
  */
-	EXCEPTION(0x1000, SoftEmu, program_check_exception, EXC_XFER_STD)
+	EXCEPTION(0x1000, SoftEmu, emulation_assist_interrupt, EXC_XFER_STD)
 
 	. = 0x1100
 /*
-- 
2.27.0



