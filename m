Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66FC23B621D
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:39:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234794AbhF1OmH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:42:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:43938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235528AbhF1OkE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:40:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 96B4261C86;
        Mon, 28 Jun 2021 14:33:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890797;
        bh=Cw4UaKHcG/ggN9nNPKsrQpMa1gOSUyjhbRfKSlwnzcY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RcXvX3ROXTSq6nENnwNfRQSlJBkxgXd09Gt/j7IOfbVf2HJ7aUfp0ghqGh5PpoKi6
         1yAZrKTaatoGZxbBH0RbI9oUjXFLddbwk4hta+qYLmNrm6D2heY/kmb5DQHw8435fg
         Pady2czxLYaLsPjRJMpHo6JfvvL1VIPZGHe4C4n5E2LZrLSzPC2iuAyaSPElFGH1UH
         B7I7bqKV8RZciPtjFL6f+6A3hi/nNru2Xt4+SuhxSLvlpnlhuURsKbE4iCyA6hzcuM
         PCH8+Q0ZJa/BB5UwV5htIwR7q0KWjUzrm1zdqAFtZSpuw/JyvxUGDPwOFNASvUPa/G
         f8yoAlKciREXw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 011/109] ethernet: myri10ge: Fix missing error code in myri10ge_probe()
Date:   Mon, 28 Jun 2021 10:31:27 -0400
Message-Id: <20210628143305.32978-12-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628143305.32978-1-sashal@kernel.org>
References: <20210628143305.32978-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.196-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.196-rc1
X-KernelTest-Deadline: 2021-06-30T14:32+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>

[ Upstream commit f336d0b93ae978f12c5e27199f828da89b91e56a ]

The error code is missing in this code scenario, add the error code
'-EINVAL' to the return value 'status'.

Eliminate the follow smatch warning:

drivers/net/ethernet/myricom/myri10ge/myri10ge.c:3818 myri10ge_probe()
warn: missing error code 'status'.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/myricom/myri10ge/myri10ge.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
index 6789eed78ff7..3bc570c46f81 100644
--- a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
+++ b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
@@ -3853,6 +3853,7 @@ static int myri10ge_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		dev_err(&pdev->dev,
 			"invalid sram_size %dB or board span %ldB\n",
 			mgp->sram_size, mgp->board_span);
+		status = -EINVAL;
 		goto abort_with_ioremap;
 	}
 	memcpy_fromio(mgp->eeprom_strings,
-- 
2.30.2

