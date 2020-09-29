Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4029227CBF9
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:34:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732502AbgI2McB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:32:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:37338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729608AbgI2LXC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:23:02 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC85A23A9A;
        Tue, 29 Sep 2020 11:21:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601378468;
        bh=kXiBFLPXfbltYOYkIjUF8bZhx7YJNIxV8jyvFjFZf5k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vyx33szIKnxmdg1VsQsU1OUicMwmQFHOK5Q2bbhRahNOvoSeXmV3CDMn7a+M7KNpM
         Pd5x39pHzwV1l2VspCdL7A6hiVyY9vj2MNJPD1Uc7L15xupLouUS8DvuVoPnPjsCWP
         eUOgMwVTtdhh8LcqQoyvF+RdOVE3akxdqJDE5ttA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hou Tao <houtao1@huawei.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 025/245] mtd: cfi_cmdset_0002: dont free cfi->cfiq in error path of cfi_amdstd_setup()
Date:   Tue, 29 Sep 2020 12:57:56 +0200
Message-Id: <20200929105948.226822523@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105946.978650816@linuxfoundation.org>
References: <20200929105946.978650816@linuxfoundation.org>
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
index 1dbc9554a0786..3ab75d3e2ce32 100644
--- a/drivers/mtd/chips/cfi_cmdset_0002.c
+++ b/drivers/mtd/chips/cfi_cmdset_0002.c
@@ -727,7 +727,6 @@ static struct mtd_info *cfi_amdstd_setup(struct mtd_info *mtd)
 	kfree(mtd->eraseregions);
 	kfree(mtd);
 	kfree(cfi->cmdset_priv);
-	kfree(cfi->cfiq);
 	return NULL;
 }
 
-- 
2.25.1



