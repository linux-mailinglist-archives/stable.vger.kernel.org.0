Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C647C3B639B
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:56:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234855AbhF1O6a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:58:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:34082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236947AbhF1O41 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:56:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 80E2161C75;
        Mon, 28 Jun 2021 14:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624891213;
        bh=HwkUWxdB04+3z1cNU4FKIS3SuMuWux3wDGdui7mJktI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eg1Cg3YH3fgeqqWvvvA07+QSITJ7/jFUFc3oiq2QPiB5Lwm5ZRf8nWhKE+UaG9cej
         ZsV2+BVWLoz9GRo/s8b5fegREepJKnGWhavG7LIRldObP5XwidP6wuvp2kZt3lETqR
         CMdCa2N4R/KD74GvuO6RxeplYEn+erzkbVtC16ckyhz2O0XGlCCHjc5APEbu0SuX2d
         /5f8GNvrNnlDaPjehz6jmS4VH4giRXXcfDp3QDQOYUP3y8gzG6Z91ApTurq1cYFy1z
         DHe2pyNQZtmKFsosdJMPASXCoowY0BLZLMNkMN+EyQ6bqaXwpfhJuLkOl1AiiZw4tl
         XzLXwewnW5WLA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 09/71] ethernet: myri10ge: Fix missing error code in myri10ge_probe()
Date:   Mon, 28 Jun 2021 10:39:01 -0400
Message-Id: <20210628144003.34260-10-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628144003.34260-1-sashal@kernel.org>
References: <20210628144003.34260-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.274-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.274-rc1
X-KernelTest-Deadline: 2021-06-30T14:39+00:00
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
index 02ec326cb129..5eeba263b5f8 100644
--- a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
+++ b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
@@ -4050,6 +4050,7 @@ static int myri10ge_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		dev_err(&pdev->dev,
 			"invalid sram_size %dB or board span %ldB\n",
 			mgp->sram_size, mgp->board_span);
+		status = -EINVAL;
 		goto abort_with_ioremap;
 	}
 	memcpy_fromio(mgp->eeprom_strings,
-- 
2.30.2

