Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07EE1404BDE
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 13:54:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237612AbhIILxm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 07:53:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:53688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239526AbhIILvh (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 07:51:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 89B4B6120F;
        Thu,  9 Sep 2021 11:44:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631187854;
        bh=NBZ3JN46V0IjrFhuFn+RcDf9fW23nxajn0eDeMrhbLI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G876cbTMac4td+loziqYQyBd1bK0BwwlSgw53ZRuWCsBiQrnKZZa/K+JCJAV+rg/w
         SFn6Kzgl1Ax5C6I6Oru6hn1hcVaMPRJ2oYIhc9YX3a3FSqkPQEr1H9bFjqCo33U2GO
         ElKmzh0kV8Jx0awmsCIGS8rMYD7uvW8FhFBrDnzpILyJk4PGH6LTo1MB5kGzWbqbNj
         UItytxLqUqcDJ6o+Lkiii/UVUcYlO7pPvSgUa8+T3f4euEE5bivUhaZGLxQbEFP8fC
         XIX7lgkEM1BehJgmjucPfmJm5wuUnjpHO3RbeZ78WL46cIq/bIhhk+DojoAKTAJ6zs
         gv8NCh1+rQh1A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kuogee Hsieh <khsieh@codeaurora.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org,
        dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.14 144/252] drm/msm/dp: return correct edid checksum after corrupted edid checksum read
Date:   Thu,  9 Sep 2021 07:39:18 -0400
Message-Id: <20210909114106.141462-144-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114106.141462-1-sashal@kernel.org>
References: <20210909114106.141462-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kuogee Hsieh <khsieh@codeaurora.org>

[ Upstream commit 7948fe12d47a946fb8025a0534c900e3dd4b5839 ]

Response with correct edid checksum saved at connector after corrupted edid
checksum read. This fixes Link Layer CTS cases 4.2.2.3, 4.2.2.6.

Signed-off-by: Kuogee Hsieh <khsieh@codeaurora.org>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Link: https://lore.kernel.org/r/1628196295-7382-6-git-send-email-khsieh@codeaurora.org
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dp/dp_panel.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/msm/dp/dp_panel.c b/drivers/gpu/drm/msm/dp/dp_panel.c
index 440b32753430..2181b60e1d1d 100644
--- a/drivers/gpu/drm/msm/dp/dp_panel.c
+++ b/drivers/gpu/drm/msm/dp/dp_panel.c
@@ -271,7 +271,7 @@ static u8 dp_panel_get_edid_checksum(struct edid *edid)
 {
 	struct edid *last_block;
 	u8 *raw_edid;
-	bool is_edid_corrupt;
+	bool is_edid_corrupt = false;
 
 	if (!edid) {
 		DRM_ERROR("invalid edid input\n");
@@ -303,7 +303,12 @@ void dp_panel_handle_sink_request(struct dp_panel *dp_panel)
 	panel = container_of(dp_panel, struct dp_panel_private, dp_panel);
 
 	if (panel->link->sink_request & DP_TEST_LINK_EDID_READ) {
-		u8 checksum = dp_panel_get_edid_checksum(dp_panel->edid);
+		u8 checksum;
+
+		if (dp_panel->edid)
+			checksum = dp_panel_get_edid_checksum(dp_panel->edid);
+		else
+			checksum = dp_panel->connector->real_edid_checksum;
 
 		dp_link_send_edid_checksum(panel->link, checksum);
 		dp_link_send_test_response(panel->link);
-- 
2.30.2

