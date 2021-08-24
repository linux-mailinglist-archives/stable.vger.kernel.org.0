Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADA7F3F63B8
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 18:57:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233954AbhHXQ56 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 12:57:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:39542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234194AbhHXQ51 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 12:57:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0F022613B1;
        Tue, 24 Aug 2021 16:56:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824202;
        bh=5GkxJ/uysXH+AciU0UQE3ODT8MTstUCYeJtqNtYgWDE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gurek7LdcDSDTk0usj50BZzqpepgNlDm02vkekTF0+lExaYKuVsWMK3CXla7jVsC1
         q/wNLEGYgFo2N92+kSICnmv9I0DkhaB9t7w9igDG1u9+hWChIAjGZDOZ8MEh5sHUsY
         cjOHiSzvuThl7ZMoC9HJHhVanukQdcHtZOZEnanYtiPc5JOQuhAndNtDlxCa/6VwFF
         x5xpQB8/AL5O6W6sVhtKqdbL+It57oZAj0oVjDZT0wGZRswo/bw4mCGOHcThkwiJG9
         HCdr74ozvoo9IoANUlfqt3NnWtY20h5LtzyqnEnX6ai6Z3VnEyaYgMHtRspWL7sM/s
         RNhEufMcoT5zg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Martin Kaiser <martin@kaiser.cx>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 035/127] mtd: rawnand: Fix probe failure due to of_get_nand_secure_regions()
Date:   Tue, 24 Aug 2021 12:54:35 -0400
Message-Id: <20210824165607.709387-36-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824165607.709387-1-sashal@kernel.org>
References: <20210824165607.709387-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.13-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.13.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.13.13-rc1
X-KernelTest-Deadline: 2021-08-26T16:55+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

[ Upstream commit b48027083a78b13356695555a05b0e085e378687 ]

Due to 14f97f0b8e2b, the rawnand platforms without "secure-regions"
property defined in DT fails to probe. The issue is,
of_get_nand_secure_regions() errors out if
of_property_count_elems_of_size() returns a negative error code.

If the "secure-regions" property is not present in DT, then also we'll
get -EINVAL from of_property_count_elems_of_size() but it should not
be treated as an error for platforms not declaring "secure-regions"
in DT.

So fix this behaviour by checking for the existence of that property in
DT and return 0 if it is not present.

Fixes: 14f97f0b8e2b ("mtd: rawnand: Add a check in of_get_nand_secure_regions()")
Reported-by: Martin Kaiser <martin@kaiser.cx>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Reviewed-by: Martin Kaiser <martin@kaiser.cx>
Tested-by: Martin Kaiser <martin@kaiser.cx>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20210727062813.32619-1-manivannan.sadhasivam@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/nand_base.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/mtd/nand/raw/nand_base.c b/drivers/mtd/nand/raw/nand_base.c
index b18c089a7dca..4412fdc240a2 100644
--- a/drivers/mtd/nand/raw/nand_base.c
+++ b/drivers/mtd/nand/raw/nand_base.c
@@ -5056,8 +5056,14 @@ static bool of_get_nand_on_flash_bbt(struct device_node *np)
 static int of_get_nand_secure_regions(struct nand_chip *chip)
 {
 	struct device_node *dn = nand_get_flash_node(chip);
+	struct property *prop;
 	int nr_elem, i, j;
 
+	/* Only proceed if the "secure-regions" property is present in DT */
+	prop = of_find_property(dn, "secure-regions", NULL);
+	if (!prop)
+		return 0;
+
 	nr_elem = of_property_count_elems_of_size(dn, "secure-regions", sizeof(u64));
 	if (nr_elem <= 0)
 		return nr_elem;
-- 
2.30.2

