Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7EEC40E7ED
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:59:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349953AbhIPRnZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:43:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:54410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354085AbhIPRie (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:38:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DCC7D63238;
        Thu, 16 Sep 2021 16:50:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631811032;
        bh=6WZrpTMDNvbUVof9OeKTjctXW5wSRixLJU4HNjVieB8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y1HUqfFgVRF5vNFERHJo3ZQu1qpzFmcZzYsG1+3DWlmOLH4RWJ9eZz1Qt3VOlFjzC
         5pJ5vssOyfa/OQ8mGRMWNfkmkBwwGSG7sD5056YrYkjpSdrj6yDs/3k5N+kjZ1nyQF
         YR634SsZW5z1lluZ6d8+Z6jPO1ZO68JlVparS4xA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pi Hsun <pihsun@google.com>,
        Chunfeng Yun <chunfeng.yun@mediatek.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 358/432] usb: xhci-mtk: fix use-after-free of mtk->hcd
Date:   Thu, 16 Sep 2021 18:01:47 +0200
Message-Id: <20210916155822.938303326@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 2548976bcf05..cb27569186a0 100644
--- a/drivers/usb/host/xhci-mtk.c
+++ b/drivers/usb/host/xhci-mtk.c
@@ -569,7 +569,7 @@ static int xhci_mtk_probe(struct platform_device *pdev)
 	xhci_mtk_ldos_disable(mtk);
 
 disable_pm:
-	pm_runtime_put_sync_autosuspend(dev);
+	pm_runtime_put_noidle(dev);
 	pm_runtime_disable(dev);
 	return ret;
 }
-- 
2.30.2



