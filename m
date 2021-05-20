Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A98D938A748
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:36:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232666AbhETKgm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:36:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:60752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237065AbhETKdr (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:33:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3AEA061C55;
        Thu, 20 May 2021 09:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621504391;
        bh=o13Mt/lsms794xZ8ZPtyRv9zpO+Y43TGEBGBmRL6zhM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jZrRYcvTGDwkmQLUVVWS9ge1WheayKYHHAv0LXtl75nwY+J7a6OZosUgKODw1jLKh
         z6CnWD0BzcfFk0g2ub1x8gcAiEn1uOMT/7lAfU2XIGTQkpV30s0e/ATwVDV5EXyfRN
         OVtzPiqFO/QcJ0nqdpkYLCC28ypEMf3D8itn+fWM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 224/323] powerpc/52xx: Fix an invalid ASM expression (addi used instead of add)
Date:   Thu, 20 May 2021 11:21:56 +0200
Message-Id: <20210520092127.822491042@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092120.115153432@linuxfoundation.org>
References: <20210520092120.115153432@linuxfoundation.org>
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
index 3a9969c429b3..054f927bfef9 100644
--- a/arch/powerpc/platforms/52xx/lite5200_sleep.S
+++ b/arch/powerpc/platforms/52xx/lite5200_sleep.S
@@ -181,7 +181,7 @@ sram_code:
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



