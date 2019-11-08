Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89EDCF477F
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 12:50:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391648AbfKHLrq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 06:47:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:36488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391643AbfKHLrq (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 06:47:46 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 82DB420656;
        Fri,  8 Nov 2019 11:47:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213665;
        bh=K08qYBsV8gIGodec1gOeRpkimbF/syiDZ9dHNTWL40Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1VTBHqPQHTtjYBN/Pn/xG7NODHpCCcWEWn+kk3KcqauJAyApceNntrpKDa7PMnM3p
         kpV8aYZzez2lZwGlD3BWm1X/6fD6ohi2Qn10VOtOBDPQu8uP5gVIhBT37v/hgDfmpS
         l4VsSlFWPPkF4uUg8YWJR06sIS3p1/ZcQhXqMesE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ding Xiang <dingxiang@cmss.chinamobile.com>,
        Atsushi Nemoto <anemo@mba.ocn.ne.jp>,
        Paul Burton <paul.burton@mips.com>, ralf@linux-mips.org,
        jhogan@kernel.org, linux-mips@linux-mips.org,
        Sasha Levin <sashal@kernel.org>, linux-mips@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 18/44] mips: txx9: fix iounmap related issue
Date:   Fri,  8 Nov 2019 06:46:54 -0500
Message-Id: <20191108114721.15944-18-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108114721.15944-1-sashal@kernel.org>
References: <20191108114721.15944-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ding Xiang <dingxiang@cmss.chinamobile.com>

[ Upstream commit c6e1241a82e6e74d1ae5cc34581dab2ffd6022d0 ]

if device_register return error, iounmap should be called, also iounmap
need to call before put_device.

Signed-off-by: Ding Xiang <dingxiang@cmss.chinamobile.com>
Reviewed-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Signed-off-by: Paul Burton <paul.burton@mips.com>
Patchwork: https://patchwork.linux-mips.org/patch/20476/
Cc: ralf@linux-mips.org
Cc: jhogan@kernel.org
Cc: linux-mips@linux-mips.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/txx9/generic/setup.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/mips/txx9/generic/setup.c b/arch/mips/txx9/generic/setup.c
index 9d9962ab7d25c..7dc97e944d5aa 100644
--- a/arch/mips/txx9/generic/setup.c
+++ b/arch/mips/txx9/generic/setup.c
@@ -961,12 +961,11 @@ void __init txx9_sramc_init(struct resource *r)
 		goto exit_put;
 	err = sysfs_create_bin_file(&dev->dev.kobj, &dev->bindata_attr);
 	if (err) {
-		device_unregister(&dev->dev);
 		iounmap(dev->base);
-		kfree(dev);
+		device_unregister(&dev->dev);
 	}
 	return;
 exit_put:
+	iounmap(dev->base);
 	put_device(&dev->dev);
-	return;
 }
-- 
2.20.1

