Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EDB066D23
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 14:27:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728522AbfGLM07 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 08:26:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:38746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728523AbfGLM04 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Jul 2019 08:26:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8B49421019;
        Fri, 12 Jul 2019 12:26:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562934416;
        bh=AyMrDlvK9JOOsXx47vtxuqCDRX8Yg+Jq+LLv0NVejhc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D0SDyr3Aju6+KGb4vnKI9Zk+7f/Q/F9hZ3A0E4FB5bL7IBOfQ+xDR0mFSaOa/nPt8
         4x3yUl67i/w0jyCZjFSYWPJHqARAOQQqic24ymsYhDy2w5RX22EgjgnsEVPCAg0usA
         FXp40UVSL4U+xUpxERlZAicS8lysZLQ/SGm1nYT4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nick Hu <nickhu@andestech.com>,
        Palmer Dabbelt <palmer@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 048/138] riscv: Fix udelay in RV32.
Date:   Fri, 12 Jul 2019 14:18:32 +0200
Message-Id: <20190712121630.508073629@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190712121628.731888964@linuxfoundation.org>
References: <20190712121628.731888964@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit d0e1f2110a5eeb6e410b2dd37d98bc5b30da7bc7 ]

In RV32, udelay would delay the wrong cycle. When it shifts right
"UDELAY_SHIFT" bits, it either delays 0 cycle or 1 cycle. It only works
correctly in RV64. Because the 'ucycles' always needs to be 64 bits
variable.

Signed-off-by: Nick Hu <nickhu@andestech.com>
Reviewed-by: Palmer Dabbelt <palmer@sifive.com>
[paul.walmsley@sifive.com: fixed minor spelling error]
Signed-off-by: Paul Walmsley <paul.walmsley@sifive.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/lib/delay.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/lib/delay.c b/arch/riscv/lib/delay.c
index dce8ae24c6d3..ee6853c1e341 100644
--- a/arch/riscv/lib/delay.c
+++ b/arch/riscv/lib/delay.c
@@ -88,7 +88,7 @@ EXPORT_SYMBOL(__delay);
 
 void udelay(unsigned long usecs)
 {
-	unsigned long ucycles = usecs * lpj_fine * UDELAY_MULT;
+	u64 ucycles = (u64)usecs * lpj_fine * UDELAY_MULT;
 
 	if (unlikely(usecs > MAX_UDELAY_US)) {
 		__delay((u64)usecs * riscv_timebase / 1000000ULL);
-- 
2.20.1



