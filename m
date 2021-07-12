Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C7923C4E0E
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:41:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243186AbhGLHQg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:16:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:49360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238080AbhGLHPv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:15:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 609B66140F;
        Mon, 12 Jul 2021 07:12:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626073953;
        bh=l+L/5yP3+BxOgABFQ/+tCuHTQVC9oPdDF//wXq+d+eM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=emv3EURK2DyApsOePCG0UfOhbUpiOHHMsvuOnQzT2JoojGQty4oyUqb7a0IO8KNfz
         qZyo4xNmBsTRH4XYeyWv71JoN8YhZHeqRLnO30Qe4mDMSYgXx3RO0OWSzqXpnSmIAs
         h/4N/h1RQ0QXf69WKMkQ0oh0KOCJFvQCK4HT3C94=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Abaci Robot <abaci@linux.alibaba.com>,
        Yang Li <yang.lee@linux.alibaba.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 415/700] ath10k: Fix an error code in ath10k_add_interface()
Date:   Mon, 12 Jul 2021 08:08:18 +0200
Message-Id: <20210712061020.523403949@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Li <yang.lee@linux.alibaba.com>

[ Upstream commit e9ca70c735ce66fc6a0e02c8b6958434f74ef8de ]

When the code execute this if statement, the value of ret is 0.
However, we can see from the ath10k_warn() log that the value of
ret should be -EINVAL.

Clean up smatch warning:

drivers/net/wireless/ath/ath10k/mac.c:5596 ath10k_add_interface() warn:
missing error code 'ret'

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Fixes: ccec9038c721 ("ath10k: enable raw encap mode and software crypto engine")
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/1621939577-62218-1-git-send-email-yang.lee@linux.alibaba.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/mac.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index bb6c5ee43ac0..def52df829d4 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -5590,6 +5590,7 @@ static int ath10k_add_interface(struct ieee80211_hw *hw,
 
 	if (arvif->nohwcrypt &&
 	    !test_bit(ATH10K_FLAG_RAW_MODE, &ar->dev_flags)) {
+		ret = -EINVAL;
 		ath10k_warn(ar, "cryptmode module param needed for sw crypto\n");
 		goto err;
 	}
-- 
2.30.2



