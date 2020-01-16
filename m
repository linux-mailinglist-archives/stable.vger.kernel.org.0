Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34E0F13E6B1
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 18:21:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729431AbgAPRVi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:21:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:43194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730357AbgAPRRi (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:17:38 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 79AB92087E;
        Thu, 16 Jan 2020 17:17:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579195058;
        bh=GNZp0UeonDfLmB9+iQmd4E5uDQXciC8j7pjaO1xySas=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=udtg47BXvtViavBBOQy4uzZkOc/y8vK/EcCoMmP9Si3Tul8SGtBduSTxshYhMRYc+
         IbHiIhvZCPSgEOskbEXReYFJWgNMBVRxCFD/qdgP4Jpbml4ettlz8BGqNe5ud3kwbn
         E3sQgZUGia9WvsfLPbPHOx3q4/McpqYgnBAu9A8k=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Maxime Ripard <maxime.ripard@bootlin.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Giulio Benetti <giulio.benetti@micronovasrl.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.14 014/371] drm/sun4i: hdmi: Fix double flag assignation
Date:   Thu, 16 Jan 2020 12:11:22 -0500
Message-Id: <20200116171719.16965-14-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116171719.16965-1-sashal@kernel.org>
References: <20200116171719.16965-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxime Ripard <maxime.ripard@bootlin.com>

[ Upstream commit 1e0ff648940e603cab6c52cf3723017d30d78f30 ]

The is_double flag is a boolean currently assigned to the value of the d
variable, that is either 1 or 2. It means that this is_double variable is
always set to true, even though the initial intent was to have it set to
true when d is 2.

Fix this.

Fixes: 9c5681011a0c ("drm/sun4i: Add HDMI support")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
Reviewed-by: Giulio Benetti <giulio.benetti@micronovasrl.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20181021163446.29135-2-maxime.ripard@bootlin.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/sun4i/sun4i_hdmi_tmds_clk.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/sun4i/sun4i_hdmi_tmds_clk.c b/drivers/gpu/drm/sun4i/sun4i_hdmi_tmds_clk.c
index 5cf2527bffc8..d7a8fea94557 100644
--- a/drivers/gpu/drm/sun4i/sun4i_hdmi_tmds_clk.c
+++ b/drivers/gpu/drm/sun4i/sun4i_hdmi_tmds_clk.c
@@ -50,7 +50,7 @@ static unsigned long sun4i_tmds_calc_divider(unsigned long rate,
 			    (rate - tmp_rate) < (rate - best_rate)) {
 				best_rate = tmp_rate;
 				best_m = m;
-				is_double = d;
+				is_double = (d == 2) ? true : false;
 			}
 		}
 	}
-- 
2.20.1

