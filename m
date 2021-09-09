Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F1D34050C9
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:42:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350671AbhIIMcE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:32:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:56842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353471AbhIIMUz (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:20:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8616061ACD;
        Thu,  9 Sep 2021 11:50:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188245;
        bh=CMCz4wgfopq1siqVPDI2lcL9DaVBit26X5lA7lAwMnU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zqf6OaAT0x3j/G+5vKUomXlWuMls6lYdQpmqBnPtYWzvL5zqmgSVfTLRwLqVgdFhV
         t9J8H8H6uIwKvpXvLji/gftPZ4/Maomm3XhxE7avuVSq8PoDGB3RmaSJrxyOmaj1X6
         oMfqZpADY33i4IiJR7P6ds1wJN5hwLdhntjByIypFqp4MOyaZ5t2pqToYc69d2Cte4
         R2FoCantXYJRMzb/ju5EPQU5cFSXZfGNcCR11Ea8y7QM0wAzkUPHmTaBMqZbfg++va
         yvyuVNT2NXOolaeJz82DQX1691DqFyvLh8D9tjOd1etMRqJB9aXMmglZ7pOew1darN
         Zcao8NEzJs8yA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chunfeng Yun <chunfeng.yun@mediatek.com>,
        Pi Hsun <pihsun@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.13 194/219] usb: xhci-mtk: fix use-after-free of mtk->hcd
Date:   Thu,  9 Sep 2021 07:46:10 -0400
Message-Id: <20210909114635.143983-194-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114635.143983-1-sashal@kernel.org>
References: <20210909114635.143983-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chunfeng Yun <chunfeng.yun@mediatek.com>

[ Upstream commit 7f85c16f40d8be5656fb3476909db5c3a5a9c6ea ]

 BUG: KASAN: use-after-free in usb_hcd_is_primary_hcd+0x38/0x60
 Call trace:
  dump_backtrace+0x0/0x3dc
  show_stack+0x20/0x2c
  dump_stack+0x15c/0x1d4
  print_address_description+0x7c/0x510
  kasan_report+0x164/0x1ac
  __asan_report_load8_noabort+0x44/0x50
  usb_hcd_is_primary_hcd+0x38/0x60
  xhci_mtk_runtime_suspend+0x68/0x148
  pm_generic_runtime_suspend+0x90/0xac
  __rpm_callback+0xb8/0x1f4
  rpm_callback+0x54/0x1d0
  rpm_suspend+0x4e0/0xc84
  __pm_runtime_suspend+0xc4/0x114
  xhci_mtk_probe+0xa58/0xd00

This may happen when probe fails, needn't suspend it synchronously,
fix it by using pm_runtime_put_noidle().

Reported-by: Pi Hsun <pihsun@google.com>
Signed-off-by: Chunfeng Yun <chunfeng.yun@mediatek.com>
Link: https://lore.kernel.org/r/1629189389-18779-3-git-send-email-chunfeng.yun@mediatek.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci-mtk.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/host/xhci-mtk.c b/drivers/usb/host/xhci-mtk.c
index b2058b3bc834..86e5710a5307 100644
--- a/drivers/usb/host/xhci-mtk.c
+++ b/drivers/usb/host/xhci-mtk.c
@@ -571,7 +571,7 @@ static int xhci_mtk_probe(struct platform_device *pdev)
 	xhci_mtk_ldos_disable(mtk);
 
 disable_pm:
-	pm_runtime_put_sync_autosuspend(dev);
+	pm_runtime_put_noidle(dev);
 	pm_runtime_disable(dev);
 	return ret;
 }
-- 
2.30.2

