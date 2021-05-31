Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02B8E39605F
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:24:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233005AbhEaOZZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:25:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:47640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231717AbhEaOXB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:23:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 32792613AE;
        Mon, 31 May 2021 13:45:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468723;
        bh=CaRJbwEvVyUIgOBqZyWjNDLt31TvcBOvLoCPxtKykGU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YLugF+eypoI3y2CtqsRVmN+XFhNYb4AOitExJ543EO4tQukPV1PD6AobHWImscjcx
         9ji2/peHeOelmmmzFywDI8NN6tAxaXy/s7zWCi6SlEdrwQuNK4OrUACfX22WPpOq+Y
         ZTaRwenwzNjngEeLBK/sPN4ElRt/Knit82M7DO+E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kangjie Lu <kjlu@umn.edu>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 103/177] Revert "ath6kl: return error code in ath6kl_wmi_set_roam_lrssi_cmd()"
Date:   Mon, 31 May 2021 15:14:20 +0200
Message-Id: <20210531130651.462074727@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130647.887605866@linuxfoundation.org>
References: <20210531130647.887605866@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit efba106f89fc6848726716c101f4c84e88720a9c ]

This reverts commit fc6a6521556c8250e356ddc6a3f2391aa62dc976.

Because of recent interactions with developers from @umn.edu, all
commits from them have been recently re-reviewed to ensure if they were
correct or not.

Upon review, this commit was found to be incorrect for the reasons
below, so it must be reverted.  It will be fixed up "correctly" in a
later kernel change.

The change being reverted does NOTHING as the caller to this function
does not even look at the return value of the call.  So the "claim" that
this fixed an an issue is not true.  It will be fixed up properly in a
future patch by propagating the error up the stack correctly.

Cc: Kangjie Lu <kjlu@umn.edu>
Cc: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20210503115736.2104747-43-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath6kl/wmi.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index c610fe21c85c..d27b4088b874 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -776,8 +776,10 @@ int ath6kl_wmi_set_roam_lrssi_cmd(struct wmi *wmi, u8 lrssi)
 	cmd->info.params.roam_rssi_floor = DEF_LRSSI_ROAM_FLOOR;
 	cmd->roam_ctrl = WMI_SET_LRSSI_SCAN_PARAMS;
 
-	return ath6kl_wmi_cmd_send(wmi, 0, skb, WMI_SET_ROAM_CTRL_CMDID,
+	ath6kl_wmi_cmd_send(wmi, 0, skb, WMI_SET_ROAM_CTRL_CMDID,
 			    NO_SYNC_WMIFLAG);
+
+	return 0;
 }
 
 int ath6kl_wmi_force_roam_cmd(struct wmi *wmi, const u8 *bssid)
-- 
2.30.2



