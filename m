Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB23A3C53C5
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:52:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348613AbhGLHzy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:55:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:36642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350692AbhGLHvN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:51:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6202E61C36;
        Mon, 12 Jul 2021 07:47:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076036;
        bh=0b/YuAoCh8t96THwiH8qIsROPJqr3iST3x+hyxvR1WA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VZK1Uv+nGmB1uMt5XjsdcysTmRpEkF5N0BrsWdVyOm5OIFYxEMFYNZXaNYMI7qu2u
         aMP3za8x6iPXVMJthDxhp/cv7hKXkkScOfcPej4yQ3rB5TfhII8N3NK0Lv3HrDt6aV
         nuMSFv8RgstdqMTtExi0Q7UtOQTcRQtIdjwv9euk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Abaci Robot <abaci@linux.alibaba.com>,
        Yang Li <yang.lee@linux.alibaba.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 469/800] ath10k: Fix an error code in ath10k_add_interface()
Date:   Mon, 12 Jul 2021 08:08:12 +0200
Message-Id: <20210712061017.067667099@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
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
index 5ce4f8d038b9..c272b290fa73 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -5592,6 +5592,7 @@ static int ath10k_add_interface(struct ieee80211_hw *hw,
 
 	if (arvif->nohwcrypt &&
 	    !test_bit(ATH10K_FLAG_RAW_MODE, &ar->dev_flags)) {
+		ret = -EINVAL;
 		ath10k_warn(ar, "cryptmode module param needed for sw crypto\n");
 		goto err;
 	}
-- 
2.30.2



