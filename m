Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 216ED2EDF5
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 05:43:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728741AbfE3Dmt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:42:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:60964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732439AbfE3DVF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:21:05 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BF330249AC;
        Thu, 30 May 2019 03:21:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186464;
        bh=EMYS1qhUe763nuCW1K+nwIWiN/wiyn9Qh5hzGuOl2mE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ciVQfx5u6NN/mbuWekVGhLs1KOkDBr8TOa6AFiJfd9yatiz9vcpDnWsrI5mIX7/9S
         y4KBQb4lKQ2/H3qd5NmMcSeKCY3P20N+QW/LizsYNR1dTLq/ligbiNYgLZSZ1HbSlq
         cAQBcTbmjqYZtu0hvCVr9FwrtXBtgZiewdQbrZAg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 043/128] mwifiex: prevent an array overflow
Date:   Wed, 29 May 2019 20:06:15 -0700
Message-Id: <20190530030442.254322473@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030432.977908967@linuxfoundation.org>
References: <20190530030432.977908967@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit b4c35c17227fe437ded17ce683a6927845f8c4a4 ]

The "rate_index" is only used as an index into the phist_data->rx_rate[]
array in the mwifiex_hist_data_set() function.  That array has
MWIFIEX_MAX_AC_RX_RATES (74) elements and it's used to generate some
debugfs information.  The "rate_index" variable comes from the network
skb->data[] and it is a u8 so it's in the 0-255 range.  We need to cap
it to prevent an array overflow.

Fixes: cbf6e05527a7 ("mwifiex: add rx histogram statistics support")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/marvell/mwifiex/cfp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/cfp.c b/drivers/net/wireless/marvell/mwifiex/cfp.c
index 1ff22055e54f8..9ddaa767ea747 100644
--- a/drivers/net/wireless/marvell/mwifiex/cfp.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfp.c
@@ -533,5 +533,8 @@ u8 mwifiex_adjust_data_rate(struct mwifiex_private *priv,
 		rate_index = (rx_rate > MWIFIEX_RATE_INDEX_OFDM0) ?
 			      rx_rate - 1 : rx_rate;
 
+	if (rate_index >= MWIFIEX_MAX_AC_RX_RATES)
+		rate_index = MWIFIEX_MAX_AC_RX_RATES - 1;
+
 	return rate_index;
 }
-- 
2.20.1



