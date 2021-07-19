Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B93CD3CD9F0
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:13:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244874AbhGSOcN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:32:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:46154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242097AbhGSOad (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:30:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DE8CB61073;
        Mon, 19 Jul 2021 15:11:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626707470;
        bh=JVs+USAqbQwyWosver9IEvaSkLoC7t8CAAanoNskeOs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WDP69A6+WlqDDBDET4UToqv0e9adsR7FJKsBEKQXylbnyciHoIylxKK0pE+chd4Ww
         /FKjKOXmjA+DtF77FO5uz9DfvWT1SMrac2LFbn0Ihx7eOEFKP3fcJ+hoC2pB7SIBR+
         R6HgzcBoP1aR6fdv/3AbfPvFtmQ+tTeoi+cwiu/M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lee Gibson <leegib@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 143/245] wl1251: Fix possible buffer overflow in wl1251_cmd_scan
Date:   Mon, 19 Jul 2021 16:51:25 +0200
Message-Id: <20210719144945.031408848@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144940.288257948@linuxfoundation.org>
References: <20210719144940.288257948@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lee Gibson <leegib@gmail.com>

[ Upstream commit d10a87a3535cce2b890897914f5d0d83df669c63 ]

Function wl1251_cmd_scan calls memcpy without checking the length.
Harden by checking the length is within the maximum allowed size.

Signed-off-by: Lee Gibson <leegib@gmail.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20210428115508.25624-1-leegib@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ti/wl1251/cmd.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ti/wl1251/cmd.c b/drivers/net/wireless/ti/wl1251/cmd.c
index ede31f048ef9..247f4310a38f 100644
--- a/drivers/net/wireless/ti/wl1251/cmd.c
+++ b/drivers/net/wireless/ti/wl1251/cmd.c
@@ -465,9 +465,12 @@ int wl1251_cmd_scan(struct wl1251 *wl, u8 *ssid, size_t ssid_len,
 		cmd->channels[i].channel = channels[i]->hw_value;
 	}
 
-	cmd->params.ssid_len = ssid_len;
-	if (ssid)
-		memcpy(cmd->params.ssid, ssid, ssid_len);
+	if (ssid) {
+		int len = clamp_val(ssid_len, 0, IEEE80211_MAX_SSID_LEN);
+
+		cmd->params.ssid_len = len;
+		memcpy(cmd->params.ssid, ssid, len);
+	}
 
 	ret = wl1251_cmd_send(wl, CMD_SCAN, cmd, sizeof(*cmd));
 	if (ret < 0) {
-- 
2.30.2



