Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C482A38A835
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:46:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235049AbhETKrk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:47:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:44704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237733AbhETKph (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:45:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2439561CA9;
        Thu, 20 May 2021 09:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621504659;
        bh=GCoE0KCXoQnp3kjoAssNrYQLQ+dFEDm9VHBfETPFS0Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hro1s9kU4NCZEgTxGbF22U7adWSJYZntHMS/l7QVw2VHkaMzKSF3iZZ/XI26zRhB0
         Vc6VOcq3C0dTLBzrYIxWzZpNukenudHfW9gR4uQ28UluQr+dbbmtVXnKCohkywSbZu
         SrqHjklxPieaLcbPiTxjMjo62tZpwqbv7fZ1P3vI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 022/240] spi: dln2: Fix reference leak to master
Date:   Thu, 20 May 2021 11:20:14 +0200
Message-Id: <20210520092109.372838285@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092108.587553970@linuxfoundation.org>
References: <20210520092108.587553970@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

[ Upstream commit 9b844b087124c1538d05f40fda8a4fec75af55be ]

Call spi_master_get() holds the reference count to master device, thus
we need an additional spi_master_put() call to reduce the reference
count, otherwise we will leak a reference to master.

This commit fix it by removing the unnecessary spi_master_get().

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Link: https://lore.kernel.org/r/20210409082955.2907950-1-weiyongjun1@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-dln2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-dln2.c b/drivers/spi/spi-dln2.c
index b62a99caacc0..a41adea48618 100644
--- a/drivers/spi/spi-dln2.c
+++ b/drivers/spi/spi-dln2.c
@@ -783,7 +783,7 @@ exit_free_master:
 
 static int dln2_spi_remove(struct platform_device *pdev)
 {
-	struct spi_master *master = spi_master_get(platform_get_drvdata(pdev));
+	struct spi_master *master = platform_get_drvdata(pdev);
 	struct dln2_spi *dln2 = spi_master_get_devdata(master);
 
 	pm_runtime_disable(&pdev->dev);
-- 
2.30.2



