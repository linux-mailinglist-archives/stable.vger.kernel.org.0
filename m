Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6824D2EA773
	for <lists+stable@lfdr.de>; Tue,  5 Jan 2021 10:33:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728373AbhAEJ3s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jan 2021 04:29:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:49298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728357AbhAEJ3k (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 Jan 2021 04:29:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 61C6522ADF;
        Tue,  5 Jan 2021 09:29:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609838943;
        bh=bDaH0qxvKMZ3wwj/g24R05lfirUzzJc70cmssiyJNZU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D3kPjj6YrSyj/Xx82bw6fr9YX39JSxNUmWjFxq4UIpKumpOOLtHBDamnqKj0YN1d2
         nt/W1ZLy39rM2Yi88GQo2TuaqVwKq4Jt5YEma5Tk0Rl1McaRg5LhswgiSFVFEWy1Wv
         TjzZ52NvDzMKvOh1mhzFNxgME1Ui2kLIOFjAOyDI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qinglang Miao <miaoqinglang@huawei.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 25/29] powerpc: sysdev: add missing iounmap() on error in mpic_msgr_probe()
Date:   Tue,  5 Jan 2021 10:29:11 +0100
Message-Id: <20210105090821.795042691@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210105090818.518271884@linuxfoundation.org>
References: <20210105090818.518271884@linuxfoundation.org>
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
index 280e964e1aa88..497e86cfb12e0 100644
--- a/arch/powerpc/sysdev/mpic_msgr.c
+++ b/arch/powerpc/sysdev/mpic_msgr.c
@@ -196,7 +196,7 @@ static int mpic_msgr_probe(struct platform_device *dev)
 
 	/* IO map the message register block. */
 	of_address_to_resource(np, 0, &rsrc);
-	msgr_block_addr = ioremap(rsrc.start, resource_size(&rsrc));
+	msgr_block_addr = devm_ioremap(&dev->dev, rsrc.start, resource_size(&rsrc));
 	if (!msgr_block_addr) {
 		dev_err(&dev->dev, "Failed to iomap MPIC message registers");
 		return -EFAULT;
-- 
2.27.0



