Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 111AC404DCD
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:15:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236014AbhIIMGn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:06:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:40846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344324AbhIIL7D (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 07:59:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B770D6140B;
        Thu,  9 Sep 2021 11:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631187952;
        bh=6WZrpTMDNvbUVof9OeKTjctXW5wSRixLJU4HNjVieB8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i5BPmJTLXXzsEx8vZY0lCr3ZS/Jy/i3FUz30zr0w8d+WwN7LYER87O4hIJEYew3o3
         Hgtc5mrxD/mBZ1zzuLm4koOqRo0fF0UCfUKDbr0aWU/gv5dTNdExoNL56tkU7G2KRa
         7cqmjUZ9oH5KDayQwZqTQ3L/kxUmeA3WAsA5AC73Yba/iSJAdKZ/+Fqb00putqFT41
         jVRGc1pYibGNkj+9va9RPO4IFPV674wYe687xocqQXkpQTUv0cF8tKGG/BlVgoWkGO
         W0Q0fVK3lsVQh9ezP6vPjS2O9NNjug5YMwHqaotLuaKUGIQnnKuoV2GQHvzq9c2xnu
         buL1J67jKR6+w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chunfeng Yun <chunfeng.yun@mediatek.com>,
        Pi Hsun <pihsun@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.14 220/252] usb: xhci-mtk: fix use-after-free of mtk->hcd
Date:   Thu,  9 Sep 2021 07:40:34 -0400
Message-Id: <20210909114106.141462-220-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114106.141462-1-sashal@kernel.org>
References: <20210909114106.141462-1-sashal@kernel.org>
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

