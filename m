Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A8A62E9A35
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 17:12:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728512AbhADQBM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 11:01:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:38400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727785AbhADQBM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 11:01:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 306C02245C;
        Mon,  4 Jan 2021 16:00:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609776031;
        bh=xCZw4h1gUVy5W+RXm5Qkfjq27sAVjQQ4+42yUPxqyMY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ljPCR5FtqFK8TZVU5qIQbLLY5053BhL8g2MXkp+SYFqucspBlaLVyXUXsdXI8pRrg
         V3pAEjd/K7XsBH00dpFHHFuX2SMO1qp491y7La6sv9wCV2P8IeWTFVoxjJCCrnjEn/
         oCIW0rQhNhZKc3PzwJzPLCgqbSRk42tlFruk9XlA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qinglang Miao <miaoqinglang@huawei.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 38/47] powerpc: sysdev: add missing iounmap() on error in mpic_msgr_probe()
Date:   Mon,  4 Jan 2021 16:57:37 +0100
Message-Id: <20210104155707.575016961@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210104155705.740576914@linuxfoundation.org>
References: <20210104155705.740576914@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qinglang Miao <miaoqinglang@huawei.com>

[ Upstream commit ffa1797040c5da391859a9556be7b735acbe1242 ]

I noticed that iounmap() of msgr_block_addr before return from
mpic_msgr_probe() in the error handling case is missing. So use
devm_ioremap() instead of just ioremap() when remapping the message
register block, so the mapping will be automatically released on
probe failure.

Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20201028091551.136400-1-miaoqinglang@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/sysdev/mpic_msgr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/sysdev/mpic_msgr.c b/arch/powerpc/sysdev/mpic_msgr.c
index f6b253e2be409..36ec0bdd8b63c 100644
--- a/arch/powerpc/sysdev/mpic_msgr.c
+++ b/arch/powerpc/sysdev/mpic_msgr.c
@@ -191,7 +191,7 @@ static int mpic_msgr_probe(struct platform_device *dev)
 
 	/* IO map the message register block. */
 	of_address_to_resource(np, 0, &rsrc);
-	msgr_block_addr = ioremap(rsrc.start, resource_size(&rsrc));
+	msgr_block_addr = devm_ioremap(&dev->dev, rsrc.start, resource_size(&rsrc));
 	if (!msgr_block_addr) {
 		dev_err(&dev->dev, "Failed to iomap MPIC message registers");
 		return -EFAULT;
-- 
2.27.0



