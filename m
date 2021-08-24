Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31FFC3F63EF
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:00:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234973AbhHXQ7K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 12:59:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:39268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237916AbhHXQ6G (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 12:58:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 937B061505;
        Tue, 24 Aug 2021 16:57:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824230;
        bh=10ppWwsutgLxe02LhILcoq5ChQZYGwDKTujjCSNGd5M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pIf8g9kBAmaTLk7bhjo4idTjXHC4pR9FHm3KH33Heiiw/4iOdfPNdBhvFe5GPRHQ/
         HW3rJ0XvJ4RHm6QAWGdvYOJK2cP2IGGrOI145pi5GTMz820LG3qfxh+AdFat5OnK1S
         6RGyKCoEeFcEUkPACmuLlgZA8XY/8mHMYapfl+2syQ5cqB7kQkm0rrHyr1eShUK2sc
         SCkE0fejpBlau/f8NREUaaUpKU58aN965UY4aqQumTizCJiOVd4+mZJwpRbM3eSe5c
         1hdrXBNbUwTV1suOI9eSsXH15qgaCVazoEahD9smmKHpGZF8+zC4sQTZLg6iUpDkh6
         K0Q+sLrM5SwZg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 063/127] net: qlcnic: add missed unlock in qlcnic_83xx_flash_read32
Date:   Tue, 24 Aug 2021 12:55:03 -0400
Message-Id: <20210824165607.709387-64-sashal@kernel.org>
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

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

[ Upstream commit 0a298d133893c72c96e2156ed7cb0f0c4a306a3e ]

qlcnic_83xx_unlock_flash() is called on all paths after we call
qlcnic_83xx_lock_flash(), except for one error path on failure
of QLCRD32(), which may cause a deadlock. This bug is suggested
by a static analysis tool, please advise.

Fixes: 81d0aeb0a4fff ("qlcnic: flash template based firmware reset recovery")
Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Link: https://lore.kernel.org/r/20210816131405.24024-1-dinghao.liu@zju.edu.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c
index d8882d0b6b49..d51bac7ba5af 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c
@@ -3156,8 +3156,10 @@ int qlcnic_83xx_flash_read32(struct qlcnic_adapter *adapter, u32 flash_addr,
 
 		indirect_addr = QLC_83XX_FLASH_DIRECT_DATA(addr);
 		ret = QLCRD32(adapter, indirect_addr, &err);
-		if (err == -EIO)
+		if (err == -EIO) {
+			qlcnic_83xx_unlock_flash(adapter);
 			return err;
+		}
 
 		word = ret;
 		*(u32 *)p_data  = word;
-- 
2.30.2

