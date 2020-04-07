Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E017C1A0220
	for <lists+stable@lfdr.de>; Tue,  7 Apr 2020 02:04:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727447AbgDGABo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Apr 2020 20:01:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:35136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727421AbgDGABn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 Apr 2020 20:01:43 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2808B208E4;
        Tue,  7 Apr 2020 00:01:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586217702;
        bh=Cu0bIJ+vz5khx9IVzUJPi8H2/VKCJ3eiUPqW2uMzAk8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E/NUX8p/xVlJgOX5TJ11GGyc5BoCrNq9dxdwZ1UClrUlJtEqrrM+0DOs7RhR6aV8w
         KZThioS5YFOmLTykLbDOuGyyuy/h5g+rQ/EaMOQrppganuTCBsU0Tn3GPMj2gw1iqM
         Oei5qpJxE3FYZ2DBIIK4Crm+OxU8hEoqwCPHQE0c=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chris Packham <chris.packham@alliedtelesis.co.nz>,
        Wolfram Sang <wsa@the-dreams.de>,
        Sasha Levin <sashal@kernel.org>, linux-i2c@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 35/35] i2c: pca-platform: Use platform_irq_get_optional
Date:   Mon,  6 Apr 2020 20:00:57 -0400
Message-Id: <20200407000058.16423-35-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200407000058.16423-1-sashal@kernel.org>
References: <20200407000058.16423-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Packham <chris.packham@alliedtelesis.co.nz>

[ Upstream commit 14c1fe699cad9cb0acda4559c584f136d18fea50 ]

The interrupt is not required so use platform_irq_get_optional() to
avoid error messages like

  i2c-pca-platform 22080000.i2c: IRQ index 0 not found

Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-pca-platform.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-pca-platform.c b/drivers/i2c/busses/i2c-pca-platform.c
index a7a81846d5b1d..635dd697ac0bb 100644
--- a/drivers/i2c/busses/i2c-pca-platform.c
+++ b/drivers/i2c/busses/i2c-pca-platform.c
@@ -140,7 +140,7 @@ static int i2c_pca_pf_probe(struct platform_device *pdev)
 	int ret = 0;
 	int irq;
 
-	irq = platform_get_irq(pdev, 0);
+	irq = platform_get_irq_optional(pdev, 0);
 	/* If irq is 0, we do polling. */
 	if (irq < 0)
 		irq = 0;
-- 
2.20.1

