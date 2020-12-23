Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FDBF2E1222
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 03:20:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728577AbgLWCTU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:19:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:46290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728560AbgLWCTT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:19:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D595423331;
        Wed, 23 Dec 2020 02:18:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608689916;
        bh=saxJV46MuKRNndViJBgAO/+pmg7QGSYPkXKtESLKSLk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bWlSi0aCxjGglcwvMuYEk2vbbPT4EdUY18iHKrlp/gtqmDRCorqKN6deqqyoobsO7
         AbRnJ0B3XHseoKxLxbBK/ucQQAK4t/KoYQy4fbY6btvcBWrrjnNpSwznQrFrPW1qzT
         cZyqwdSk1sCUqUc2fpBcgIBhVbcVJ5p9u/VcEPVSoKvB66tNDeh6Chw27hkMg7tqYN
         SdG7SLzl9I37ZHq7Ya2zvghCEbSMJ1bsMn9UFx3JVO7WKMP50oSzswYAqIcX26VCcp
         nbDuXOt69IwkTpb8AhDEs1MXiTPKCYY4Y40wtXU5UlN3v2kIgDAmNTml1VXZdUnQBX
         KRbAt/8igxTzQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhang Qilong <zhangqilong3@huawei.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, devel@driverdev.osuosl.org
Subject: [PATCH AUTOSEL 5.4 017/130] staging: rtl8192u: fix wrong judgement in rtl8192_rx_isr
Date:   Tue, 22 Dec 2020 21:16:20 -0500
Message-Id: <20201223021813.2791612-17-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223021813.2791612-1-sashal@kernel.org>
References: <20201223021813.2791612-1-sashal@kernel.org>
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
index ddc09616248a5..56655a0b16906 100644
--- a/drivers/staging/rtl8192u/r8192U_core.c
+++ b/drivers/staging/rtl8192u/r8192U_core.c
@@ -883,7 +883,7 @@ static void rtl8192_rx_isr(struct urb *urb)
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

