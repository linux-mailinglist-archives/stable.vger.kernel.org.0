Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0E1426EFBB
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 04:38:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728492AbgIRChr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:37:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:39024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728791AbgIRCMd (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:12:33 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B159208E4;
        Fri, 18 Sep 2020 02:12:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600395153;
        bh=tcuUKKILO72swrjqzzeVh0J2bi9hs49yfJ+0qZsSLU4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wHvjeKuxarqd2iCxL860fYoNG7zjB/FpMo25ErnbjK5q4DavUUMW/mZAh5HH1AxfJ
         ZQgCRLGK0VhqLG66q0epRGLb4MWsQooaGmHDk+5LnIfuKK0g7T6SIFPs5wGLxvMfIR
         EuXlgt0bNODYhHyVxeh7hTJgenQDSkI6nywvwens=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hou Tao <houtao1@huawei.com>, Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Sasha Levin <sashal@kernel.org>, linux-mtd@lists.infradead.org
Subject: [PATCH AUTOSEL 4.14 011/127] mtd: cfi_cmdset_0002: don't free cfi->cfiq in error path of cfi_amdstd_setup()
Date:   Thu, 17 Sep 2020 22:10:24 -0400
Message-Id: <20200918021220.2066485-11-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918021220.2066485-1-sashal@kernel.org>
References: <20200918021220.2066485-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hou Tao <houtao1@huawei.com>

[ Upstream commit 03976af89e3bd9489d542582a325892e6a8cacc0 ]

Else there may be a double-free problem, because cfi->cfiq will
be freed by mtd_do_chip_probe() if both the two invocations of
check_cmd_set() return failure.

Signed-off-by: Hou Tao <houtao1@huawei.com>
Reviewed-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/chips/cfi_cmdset_0002.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/mtd/chips/cfi_cmdset_0002.c b/drivers/mtd/chips/cfi_cmdset_0002.c
index 1f0d83086cb09..870d1f1331b18 100644
--- a/drivers/mtd/chips/cfi_cmdset_0002.c
+++ b/drivers/mtd/chips/cfi_cmdset_0002.c
@@ -726,7 +726,6 @@ static struct mtd_info *cfi_amdstd_setup(struct mtd_info *mtd)
 	kfree(mtd->eraseregions);
 	kfree(mtd);
 	kfree(cfi->cmdset_priv);
-	kfree(cfi->cfiq);
 	return NULL;
 }
 
-- 
2.25.1

