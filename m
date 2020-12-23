Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C80C62E13D7
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 03:38:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729524AbgLWCfe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:35:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:50890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730289AbgLWCYl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:24:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BB1DC22A83;
        Wed, 23 Dec 2020 02:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690266;
        bh=AeLGneNumqsKiJ0ejLw8pRSsPio2RJ6NzKssWVIDVfk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j45OD9XfNNhx33rLfVPiedJZFMic3VBcTsX2nD0m4GMahQ0uTgewbu0H9Qad9nlm7
         yoIuAqNqXbts1bWuFI9+AK126QpAX7mXzZ11I2XSIPSUQ98E6MxFKTzbofFBTWUFT6
         iCWsF4LY6LBuWFciEe3SMVHsOQcCgVB6oGa41lR7mvHXcBXCtBMqY8dmrMVMir3OtG
         qQKjqPPUzfypuVzmLwttITw2wpbhiUwe+CYEz74zKFCnCdVCegU0OCzTBMagLKdixE
         AN/qwEXsjdfN1a4ZPANAVxDrro1atfIhY+yVHuaY2KicHrsac44YYxBNGwmlvfb4Xg
         7QIhyNLsKVjlA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhang Qilong <zhangqilong3@huawei.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, devel@driverdev.osuosl.org
Subject: [PATCH AUTOSEL 4.9 07/48] staging: rtl8192u: fix wrong judgement in rtl8192_rx_isr
Date:   Tue, 22 Dec 2020 21:23:35 -0500
Message-Id: <20201223022417.2794032-7-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223022417.2794032-1-sashal@kernel.org>
References: <20201223022417.2794032-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Qilong <zhangqilong3@huawei.com>

[ Upstream commit 071dc1787a2f8bb636f864c1f306280deea3b1d5 ]

The 'EPERM' cannot appear in the previous path, we
should use '-EPERM' to check it. For example:

Call trace:
->rtl8192_rx_isr
    ->usb_submit_urb
       ->usb_hcd_submit_urb
           ->rh_urb_enqueue
	       ->rh_queue_status
	           ->usb_hcd_link_urb_to_ep

Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
Link: https://lore.kernel.org/r/20201028122648.47959-1-zhangqilong3@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/rtl8192u/r8192U_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8192u/r8192U_core.c b/drivers/staging/rtl8192u/r8192U_core.c
index fa4c47c7d2166..f5e53df9d49db 100644
--- a/drivers/staging/rtl8192u/r8192U_core.c
+++ b/drivers/staging/rtl8192u/r8192U_core.c
@@ -970,7 +970,7 @@ static void rtl8192_rx_isr(struct urb *urb)
 	urb->context = skb;
 	skb_queue_tail(&priv->rx_queue, skb);
 	err = usb_submit_urb(urb, GFP_ATOMIC);
-	if (err && err != EPERM)
+	if (err && err != -EPERM)
 		netdev_err(dev,
 			   "can not submit rxurb, err is %x, URB status is %x\n",
 			   err, urb->status);
-- 
2.27.0

