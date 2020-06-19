Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 173892012BA
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:56:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405340AbgFSPzj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:55:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:52592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392839AbgFSPVS (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:21:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B843320B80;
        Fri, 19 Jun 2020 15:21:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592580077;
        bh=V2+xHMTqohevdbiF822LvwMu8HBv9ms+KvauSS3xlIc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YaMKVR7zvpKCiVbOkbC+yIZblgpp10JFITuFucNiJXx3qbiEOaoFVyQMN4IwPmIj2
         qiRD13ocy6AymIV8cMelBDrVpnDnd7cY+9CbAsUD8yi7YsbgpSbpOfFt0D4KutD8ks
         c3M5RfYlNokA3QkvMuQc9mGnVW+SWyW12fEy94mU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 083/376] ath11k: fix error message to correctly report the command that failed
Date:   Fri, 19 Jun 2020 16:30:01 +0200
Message-Id: <20200619141714.272757900@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141710.350494719@linuxfoundation.org>
References: <20200619141710.350494719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit 9a8074e3bcd7956ec6b4f7c26360af1b0b0abe38 ]

Currently the error message refers to the command WMI_TWT_DIeABLE_CMDID
which looks like a cut-n-paste mangled typo. Fix the message to match
the command WMI_BSS_COLOR_CHANGE_ENABLE_CMDID that failed.

Fixes: 5a032c8d1953 ("ath11k: add WMI calls required for handling BSS color")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20200327192639.363354-1-colin.king@canonical.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/wmi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath11k/wmi.c b/drivers/net/wireless/ath/ath11k/wmi.c
index e7ce36966d6a..6fec62846279 100644
--- a/drivers/net/wireless/ath/ath11k/wmi.c
+++ b/drivers/net/wireless/ath/ath11k/wmi.c
@@ -2779,7 +2779,7 @@ int ath11k_wmi_send_bss_color_change_enable_cmd(struct ath11k *ar, u32 vdev_id,
 	ret = ath11k_wmi_cmd_send(wmi, skb,
 				  WMI_BSS_COLOR_CHANGE_ENABLE_CMDID);
 	if (ret) {
-		ath11k_warn(ab, "Failed to send WMI_TWT_DIeABLE_CMDID");
+		ath11k_warn(ab, "Failed to send WMI_BSS_COLOR_CHANGE_ENABLE_CMDID");
 		dev_kfree_skb(skb);
 	}
 	return ret;
-- 
2.25.1



