Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96232246C0A
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 18:08:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388449AbgHQQIV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 12:08:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:57420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388446AbgHQQIS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 12:08:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5609620658;
        Mon, 17 Aug 2020 16:08:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597680497;
        bh=T5us2k8hg03pCpop1vMg7wZST1JOLVXdB83orq0Yb5s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tej8uAPjhrxnVN6n4lny2VVzBhh4n9mxlORGgC7cESeRfe2e1RZso/DacbtHB2uFG
         84W9SmblO3aLBySZ8Qb7ttx+JLnaXo44f3ZnqBeGrWhTpVEvEe0c1B0KJqvipQK9oT
         tBI/qzjKBxHSK54kLjlWcMRl6bOD/KhbHig4ilwQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tsang-Shian Lin <thlin@realtek.com>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 193/270] rtw88: fix LDPC field for RA info
Date:   Mon, 17 Aug 2020 17:16:34 +0200
Message-Id: <20200817143805.405657453@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143755.807583758@linuxfoundation.org>
References: <20200817143755.807583758@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tsang-Shian Lin <thlin@realtek.com>

[ Upstream commit ae44fa993e8e6c1a1d22e5ca03d9eadd53b2745b ]

Convert the type of LDPC field to boolen because
LDPC field of RA info H2C command to firmware
is only one bit.

Fixes: e3037485c68e ("rtw88: new Realtek 802.11ac driver")
Signed-off-by: Tsang-Shian Lin <thlin@realtek.com>
Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20200717064937.27966-2-yhchuang@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw88/fw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw88/fw.c b/drivers/net/wireless/realtek/rtw88/fw.c
index 35dbdb3c4f1e5..8efaee7571f35 100644
--- a/drivers/net/wireless/realtek/rtw88/fw.c
+++ b/drivers/net/wireless/realtek/rtw88/fw.c
@@ -340,7 +340,7 @@ void rtw_fw_send_ra_info(struct rtw_dev *rtwdev, struct rtw_sta_info *si)
 	SET_RA_INFO_INIT_RA_LVL(h2c_pkt, si->init_ra_lv);
 	SET_RA_INFO_SGI_EN(h2c_pkt, si->sgi_enable);
 	SET_RA_INFO_BW_MODE(h2c_pkt, si->bw_mode);
-	SET_RA_INFO_LDPC(h2c_pkt, si->ldpc_en);
+	SET_RA_INFO_LDPC(h2c_pkt, !!si->ldpc_en);
 	SET_RA_INFO_NO_UPDATE(h2c_pkt, no_update);
 	SET_RA_INFO_VHT_EN(h2c_pkt, si->vht_enable);
 	SET_RA_INFO_DIS_PT(h2c_pkt, disable_pt);
-- 
2.25.1



