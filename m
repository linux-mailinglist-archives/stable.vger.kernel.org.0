Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB61749A275
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:00:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2365775AbiAXXvl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:51:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1584588AbiAXWro (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:47:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42D6BC058C9B;
        Mon, 24 Jan 2022 13:06:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AC64561361;
        Mon, 24 Jan 2022 21:06:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83507C340E5;
        Mon, 24 Jan 2022 21:06:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058411;
        bh=09yRgeLES2N2n9ituhlM51IdST8TeNWGNqFMD706Uh8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jSkyok+LoOw2Y+I9p1fxOEFFGjbnMokyGZljmiaLEkW9rT/ZTfO7hFV2xetvhyc30
         7cqWkVLQzBxydhmfpdz7Q/dXYZwhIP+uu/j0bfGdKjNrdo5UJs8KR9Sf3yBP2cB59Z
         UyX/+J6/Y2MRu0VVTr0jdgClkHL7+POs7Kdu/51c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Loic Poulain <loic.poulain@linaro.org>,
        Kalle Valo <quic_kvalo@quicinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0263/1039] wcn36xx: Fix max channels retrieval
Date:   Mon, 24 Jan 2022 19:34:12 +0100
Message-Id: <20220124184134.143694355@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Loic Poulain <loic.poulain@linaro.org>

[ Upstream commit 09cab4308bf9b8076ee4a3c56015daf9ef9cb23e ]

Kernel test robot reported:drivers/net/wireless/ath/wcn36xx/smd.c:943:33:
   sparse: sparse: cast truncates bits from constant value (780 becomes 80)

The 'channels' field is not a simple u8 array but an array of
channel_params. Using sizeof for retrieving the max number of
channels is then wrong.

In practice, it was not an issue, because the sizeof returned
value is 780, which is truncated in min_t (u8) to 80, which is
the value we expect...

Fix that properly using ARRAY_SIZE instead of sizeof.

Fixes: d707f812bb05 ("wcn36xx: Channel list update before hardware scan")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/1638435732-14657-1-git-send-email-loic.poulain@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/wcn36xx/smd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/smd.c b/drivers/net/wireless/ath/wcn36xx/smd.c
index d3285a504429d..bb07740149456 100644
--- a/drivers/net/wireless/ath/wcn36xx/smd.c
+++ b/drivers/net/wireless/ath/wcn36xx/smd.c
@@ -944,7 +944,7 @@ int wcn36xx_smd_update_channel_list(struct wcn36xx *wcn, struct cfg80211_scan_re
 
 	INIT_HAL_MSG((*msg_body), WCN36XX_HAL_UPDATE_CHANNEL_LIST_REQ);
 
-	msg_body->num_channel = min_t(u8, req->n_channels, sizeof(msg_body->channels));
+	msg_body->num_channel = min_t(u8, req->n_channels, ARRAY_SIZE(msg_body->channels));
 	for (i = 0; i < msg_body->num_channel; i++) {
 		struct wcn36xx_hal_channel_param *param = &msg_body->channels[i];
 		u32 min_power = WCN36XX_HAL_DEFAULT_MIN_POWER;
-- 
2.34.1



