Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C58463B62EF
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:48:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235091AbhF1OuZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:50:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:54532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236328AbhF1OrW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:47:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 133F66192F;
        Mon, 28 Jun 2021 14:36:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890998;
        bh=i1zJ5xSc8Sfmde+KY3el5b++VGj1rNSB8rjx38J9gXs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ORhXERaLY6UGJGlBZlyVGi88Ub55syZcY1kaWKxtRauviX3rnY+rO+CEZFSIQD+vw
         xogBdqDC21vafhInj8yGpjIsf2aV8tIwsjN7eQlvahh3HrQKegQ8v+YK5Hv/Eg4RGp
         xsIfrfaViOP/OREBxBpvt0g0cguiMx4zrrApU3ecDhfKxEOXzGeJX0ik8x9DU6mood
         3Bi70X5e8Td5w/gr5oUCi3GsokY/K1ejlcORWKP2Gm0VV3nhHUp/fXoLkuj0KzwJz4
         vzEaRmKQKY2EyaRnY/un7lbgs6x8oMO6Rm8r9G3H6HXVri9+73/TxIbnwcJJhQeLh+
         48xNuV4X4B1BA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 09/88] ethernet: myri10ge: Fix missing error code in myri10ge_probe()
Date:   Mon, 28 Jun 2021 10:35:09 -0400
Message-Id: <20210628143628.33342-10-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628143628.33342-1-sashal@kernel.org>
References: <20210628143628.33342-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.238-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.238-rc1
X-KernelTest-Deadline: 2021-06-30T14:36+00:00
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
index a0a555052d8c..1ac2bc75edb1 100644
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

