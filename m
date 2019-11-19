Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9E331013F3
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:28:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728376AbfKSF2z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:28:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:47382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728914AbfKSF2y (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:28:54 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 59A92208C3;
        Tue, 19 Nov 2019 05:28:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141333;
        bh=OAtHG/F8nBW8c4mMLCGf7zBGV5ZEDDZIMPsERjw+RGI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X1bgE57btG7SUFtk1miq8OMnW3540Z7zF6KAQj6JlOfsYdEEP9gjQZtUzsAKeep87
         t+kuESzcmL0ixwp84RVxFf6EnUMjtaZ45OSeOBd/y1+0JM09eRBewwUsCIXfThRKMG
         a1Wt+8x7EaLjzG5/7f0TJLRaUK8vJDMigB2CurOE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "K.T.VIJAYAKUMAAR" <vijay.bvb@samsung.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 124/422] ath10k: avoid possible memory access violation
Date:   Tue, 19 Nov 2019 06:15:21 +0100
Message-Id: <20191119051407.022963313@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: K.T.VIJAYAKUMAAR <vijay.bvb@samsung.com>

[ Upstream commit 97c69a70dc2cecb2c3b96a66529e0082dabc2d2c ]

array "ctl_power_table" access index "pream" is initialized with -1 and
is raised as a static analysis tool issue.
[drivers\net\wireless\ath\ath10k\wmi.c:4719] ->
[drivers\net\wireless\ath\ath10k\wmi.c:4730]: (error) Array index -1 is
out of bounds.

Since the "pream" index for accessing ctl_power_table array is initialized
with -1, there is a chance of memory access violation for the cases below.
1) wmi_pdev_tpc_final_table_event change frequency is between 2483 and 5180
2) pream_idx is out of the enumeration ranges of wmi_tpc_pream_2ghz,
wmi_tpc_pream_5ghz

Signed-off-by: K.T.VIJAYAKUMAAR <vijay.bvb@samsung.com>
[kvalo@codeaurora.org: clean up the warning message]
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/wmi.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 9f31b9a108507..583147f00fa4e 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -4785,6 +4785,13 @@ ath10k_wmi_tpc_final_get_rate(struct ath10k *ar,
 		}
 	}
 
+	if (pream == -1) {
+		ath10k_warn(ar, "unknown wmi tpc final index and frequency: %u, %u\n",
+			    pream_idx, __le32_to_cpu(ev->chan_freq));
+		tpc = 0;
+		goto out;
+	}
+
 	if (pream == 4)
 		tpc = min_t(u8, ev->rates_array[rate_idx],
 			    ev->max_reg_allow_pow[ch]);
-- 
2.20.1



