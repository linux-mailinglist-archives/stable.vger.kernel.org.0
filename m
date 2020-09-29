Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7314F27CA66
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:19:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732223AbgI2MS4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:18:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:49122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729972AbgI2LgV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:36:21 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AAC7F23E23;
        Tue, 29 Sep 2020 11:31:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379093;
        bh=H8WaB6BrPJvOK0/+mDoNVBymGhqmdOHaFv38C5S0Xow=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hM40HNjQcg03T2qojviegKp5Dd2nRIRn/cuSeomKqJYO7QnTm7rc5ncKqDQcsAy88
         23GkN9NfmVFU3G4IpimMIjpMZWZH5Zsqs8wvvwgShSJKN+mOvzsniUY1C2DB6gapbM
         LaVsYTkySZKfMDk8GioBUTyBDLeCdqdLTlYq7wZ0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqing Pan <miaoqing@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 011/388] ath10k: fix memory leak for tpc_stats_final
Date:   Tue, 29 Sep 2020 12:55:42 +0200
Message-Id: <20200929110011.033121168@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaoqing Pan <miaoqing@codeaurora.org>

[ Upstream commit 486a8849843455298d49e694cca9968336ce2327 ]

The memory of ar->debug.tpc_stats_final is reallocated every debugfs
reading, it should be freed in ath10k_debug_destroy() for the last
allocation.

Tested HW: QCA9984
Tested FW: 10.4-3.9.0.2-00035

Signed-off-by: Miaoqing Pan <miaoqing@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/debug.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index 40baf25ac99f3..04c50a26a4f47 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -2532,6 +2532,7 @@ void ath10k_debug_destroy(struct ath10k *ar)
 	ath10k_debug_fw_stats_reset(ar);
 
 	kfree(ar->debug.tpc_stats);
+	kfree(ar->debug.tpc_stats_final);
 }
 
 int ath10k_debug_register(struct ath10k *ar)
-- 
2.25.1



