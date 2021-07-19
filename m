Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 332873CD7D5
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:00:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242204AbhGSOTW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:19:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:52736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242049AbhGSOR7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:17:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 861946113A;
        Mon, 19 Jul 2021 14:58:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626706719;
        bh=X5CYAT9QLlML+vNLLoMTH8v5to9glRLKpo5b3VcsGss=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vV1B762li6AZJR4220p8y9YtDDRs2wOF+xDHpX1O0u1Iesq0vnpIFjeOjad+FbUsh
         +nHIaZWVj26PmGw+PYGGItybKzuYicqxRFsdmlJeouZeYYQtAT+nx3TXvO6pqPzwUx
         JRJKjHXTtBZh9PEAFvAFz/Rm0gH6jrF78Oc9iPzI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Abaci Robot <abaci@linux.alibaba.com>,
        Yang Li <yang.lee@linux.alibaba.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 067/188] ath10k: Fix an error code in ath10k_add_interface()
Date:   Mon, 19 Jul 2021 16:50:51 +0200
Message-Id: <20210719144928.583243334@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144913.076563739@linuxfoundation.org>
References: <20210719144913.076563739@linuxfoundation.org>
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
index 5fad38c3feb1..7993ca956ede 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -4450,6 +4450,7 @@ static int ath10k_add_interface(struct ieee80211_hw *hw,
 
 	if (arvif->nohwcrypt &&
 	    !test_bit(ATH10K_FLAG_RAW_MODE, &ar->dev_flags)) {
+		ret = -EINVAL;
 		ath10k_warn(ar, "cryptmode module param needed for sw crypto\n");
 		goto err;
 	}
-- 
2.30.2



