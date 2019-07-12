Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EABF66D11
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 14:26:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727788AbfGLM0K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 08:26:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:36876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728395AbfGLM0H (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Jul 2019 08:26:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0DF682084B;
        Fri, 12 Jul 2019 12:26:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562934366;
        bh=vQBdzWuLn1sqfRcFF+gUmWpDuYA8gg4YVK5T3Ukjz2A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N9sVsrrhc+GeEMtUcQ0/NsIDwh6ML3Yc0tWS547HF7M2xB/Onp52h7k4gpdV9LrOS
         vHCwhs+TmQmpdKO9938cDoVdt33G0jC+rs0xjpZ7eyvoYwwMRQdJEC1HA5dWwjO27k
         zv0OUP1I/+RPvi40B/Cvp0UWHtqeAlGdreQPtw9Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 009/138] soc: bcm: brcmstb: biuctrl: Register writes require a barrier
Date:   Fri, 12 Jul 2019 14:17:53 +0200
Message-Id: <20190712121629.069994333@linuxfoundation.org>
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

[ Upstream commit 6b23af0783a54efb348f0bd781b7850636023dbb ]

The BIUCTRL register writes require that a data barrier be inserted
after comitting the write to the register for the block to latch in the
recently written values. Reads have no such requirement and are not
changed.

Fixes: 34642650e5bc ("soc: Move brcmstb to bcm/brcmstb")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/bcm/brcmstb/biuctrl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/soc/bcm/brcmstb/biuctrl.c b/drivers/soc/bcm/brcmstb/biuctrl.c
index c16273b31b94..20b63bee5b09 100644
--- a/drivers/soc/bcm/brcmstb/biuctrl.c
+++ b/drivers/soc/bcm/brcmstb/biuctrl.c
@@ -56,7 +56,7 @@ static inline void cbc_writel(u32 val, int reg)
 	if (offset == -1)
 		return;
 
-	writel_relaxed(val,  cpubiuctrl_base + offset);
+	writel(val, cpubiuctrl_base + offset);
 }
 
 enum cpubiuctrl_regs {
-- 
2.20.1



