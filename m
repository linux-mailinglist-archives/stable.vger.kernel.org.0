Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C83C727C465
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:13:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728541AbgI2LNn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:13:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:55950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729359AbgI2LNd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:13:33 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 11D4D22262;
        Tue, 29 Sep 2020 11:13:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601378012;
        bh=tcuUKKILO72swrjqzzeVh0J2bi9hs49yfJ+0qZsSLU4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IGP3EYXwg9rMrgrB4gilkG+zYu/eLxSlHMOZg0+bv5u1BmlQRQYTLF/72zGZreaxf
         jDQ0EXCTZj6ehF1Kx8YUtGyBXi8ivoxddJt60GAbsSonM81Jw0Mx6qqQaAz//iIlNr
         U9RuC0d5eZznXw/W7xaGrbx8sIKd+7onfdSyf0oM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hou Tao <houtao1@huawei.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 031/166] mtd: cfi_cmdset_0002: dont free cfi->cfiq in error path of cfi_amdstd_setup()
Date:   Tue, 29 Sep 2020 12:59:03 +0200
Message-Id: <20200929105936.763812658@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105935.184737111@linuxfoundation.org>
References: <20200929105935.184737111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



