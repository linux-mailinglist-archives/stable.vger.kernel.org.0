Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CECE938AB27
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 13:21:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237692AbhETLVA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 07:21:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:38286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240756AbhETLTS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 07:19:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0418361D7B;
        Thu, 20 May 2021 10:10:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621505428;
        bh=00WXR+OlTujK/PkeXnndoqQ066Ja43WCBFFxGxfv10g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vO9n2cwUOJM+QuloevJUJieWS8hyJ3Of6WWKedt4+UaS0U0rVRMd7ZUux1HgnsH8a
         4GtLlcvPrfRqfCjbfAhIUtmX4d2Mt4iP3GwEMf5pZ9kcyChVC82UwXfhbNRjeP2HUo
         RrBzxTkOmcxmPiYj+fQJgRupfBfZAlKc4PNgM8GE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 130/190] powerpc/52xx: Fix an invalid ASM expression (addi used instead of add)
Date:   Thu, 20 May 2021 11:23:14 +0200
Message-Id: <20210520092106.497133849@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092102.149300807@linuxfoundation.org>
References: <20210520092102.149300807@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@csgroup.eu>

[ Upstream commit 8a87a507714386efc39c3ae6fa24d4f79846b522 ]

  AS      arch/powerpc/platforms/52xx/lite5200_sleep.o
arch/powerpc/platforms/52xx/lite5200_sleep.S: Assembler messages:
arch/powerpc/platforms/52xx/lite5200_sleep.S:184: Warning: invalid register expression

In the following code, 'addi' is wrong, has to be 'add'

	/* local udelay in sram is needed */
  udelay: /* r11 - tb_ticks_per_usec, r12 - usecs, overwrites r13 */
	mullw	r12, r12, r11
	mftb	r13	/* start */
	addi	r12, r13, r12 /* end */

Fixes: ee983079ce04 ("[POWERPC] MPC5200 low power mode")
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/cb4cec9131c8577803367f1699209a7e104cec2a.1619025821.git.christophe.leroy@csgroup.eu
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/52xx/lite5200_sleep.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/platforms/52xx/lite5200_sleep.S b/arch/powerpc/platforms/52xx/lite5200_sleep.S
index 08ab6fefcf7a..5f44e9223413 100644
--- a/arch/powerpc/platforms/52xx/lite5200_sleep.S
+++ b/arch/powerpc/platforms/52xx/lite5200_sleep.S
@@ -180,7 +180,7 @@ sram_code:
   udelay: /* r11 - tb_ticks_per_usec, r12 - usecs, overwrites r13 */
 	mullw	r12, r12, r11
 	mftb	r13	/* start */
-	addi	r12, r13, r12 /* end */
+	add	r12, r13, r12 /* end */
     1:
 	mftb	r13	/* current */
 	cmp	cr0, r13, r12
-- 
2.30.2



