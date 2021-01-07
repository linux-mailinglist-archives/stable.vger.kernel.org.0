Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D5532ED28B
	for <lists+stable@lfdr.de>; Thu,  7 Jan 2021 15:38:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726864AbhAGOeF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 09:34:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:48110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729721AbhAGOeE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 Jan 2021 09:34:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 70BE52311E;
        Thu,  7 Jan 2021 14:33:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610030003;
        bh=k8HANda9vHdo/YhUH3O5lb2EDbCd9m0YJFr0I/puVYY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EGZe5ECeDFctyZClSK11iHg7hkEwhLlijr27oODnSzzXBIf5dAcjTdpyL6bN1PTUt
         1/+b4VxXXtPVF0SJTkYkftZi5bJvT7YvwqLz/FECQx26Z7Pm0cTOP4nN1DEluiVQsj
         MwRejwkMpLFOq3dGJejOHrZpm2Vh4CVb9mbaBPIU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Xiaohui <ruc_zhangxiaohui@163.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 20/20] mwifiex: Fix possible buffer overflows in mwifiex_cmd_802_11_ad_hoc_start
Date:   Thu,  7 Jan 2021 15:34:15 +0100
Message-Id: <20210107143055.225834422@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210107143052.392839477@linuxfoundation.org>
References: <20210107143052.392839477@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Xiaohui <ruc_zhangxiaohui@163.com>

[ Upstream commit 5c455c5ab332773464d02ba17015acdca198f03d ]

mwifiex_cmd_802_11_ad_hoc_start() calls memcpy() without checking
the destination size may trigger a buffer overflower,
which a local user could use to cause denial of service
or the execution of arbitrary code.
Fix it by putting the length check before calling memcpy().

Signed-off-by: Zhang Xiaohui <ruc_zhangxiaohui@163.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20201206084801.26479-1-ruc_zhangxiaohui@163.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/marvell/mwifiex/join.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/join.c b/drivers/net/wireless/marvell/mwifiex/join.c
index 5934f71475477..173ccf79cbfcc 100644
--- a/drivers/net/wireless/marvell/mwifiex/join.c
+++ b/drivers/net/wireless/marvell/mwifiex/join.c
@@ -877,6 +877,8 @@ mwifiex_cmd_802_11_ad_hoc_start(struct mwifiex_private *priv,
 
 	memset(adhoc_start->ssid, 0, IEEE80211_MAX_SSID_LEN);
 
+	if (req_ssid->ssid_len > IEEE80211_MAX_SSID_LEN)
+		req_ssid->ssid_len = IEEE80211_MAX_SSID_LEN;
 	memcpy(adhoc_start->ssid, req_ssid->ssid, req_ssid->ssid_len);
 
 	mwifiex_dbg(adapter, INFO, "info: ADHOC_S_CMD: SSID = %s\n",
-- 
2.27.0



