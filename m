Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2121B452412
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:33:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355834AbhKPBf7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:35:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:46050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242566AbhKOSiq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:38:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0792E632E5;
        Mon, 15 Nov 2021 18:03:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636999415;
        bh=8GwS4AjwiiTZMorK0iz3ID6+BH3cgVcnS/xU0obfKNM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jhTQ58skQtZ0LOmjH0YqzbmtwCZG5GA5rHad6JZK7mTUp5culz4bOckH+L6abkx1p
         TY+c+m03oyeuL/4q8HFrCBzLPPVoj5Naajhe0+UdQMfMStroktmNnxAWeDnQxx6pjQ
         qag+igv/Hcd5DD8ZwP0GErb9DBFgVWtISmis96+0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ansuel Smith <ansuelsmth@gmail.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 281/849] thermal/drivers/tsens: Add timeout to get_temp_tsens_valid
Date:   Mon, 15 Nov 2021 17:56:04 +0100
Message-Id: <20211115165429.781604287@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ansuel Smith <ansuelsmth@gmail.com>

[ Upstream commit d012f9189fda0f3a1b303780ba0bbc7298d0d349 ]

The function can loop and lock the system if for whatever reason the bit
for the target sensor is NEVER valid. This is the case if a sensor is
disabled by the factory and the valid bit is never reported as actually
valid. Add a timeout check and exit if a timeout occurs. As this is
a very rare condition, handle the timeout only if the first read fails.
While at it also rework the function to improve readability and convert
to poll_timeout generic macro.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20211007172859.583-1-ansuelsmth@gmail.com
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/qcom/tsens.c | 29 ++++++++++++++---------------
 1 file changed, 14 insertions(+), 15 deletions(-)

diff --git a/drivers/thermal/qcom/tsens.c b/drivers/thermal/qcom/tsens.c
index b1162e566a707..99a8d9f3e03ca 100644
--- a/drivers/thermal/qcom/tsens.c
+++ b/drivers/thermal/qcom/tsens.c
@@ -603,22 +603,21 @@ int get_temp_tsens_valid(const struct tsens_sensor *s, int *temp)
 	int ret;
 
 	/* VER_0 doesn't have VALID bit */
-	if (tsens_version(priv) >= VER_0_1) {
-		ret = regmap_field_read(priv->rf[valid_idx], &valid);
-		if (ret)
-			return ret;
-		while (!valid) {
-			/* Valid bit is 0 for 6 AHB clock cycles.
-			 * At 19.2MHz, 1 AHB clock is ~60ns.
-			 * We should enter this loop very, very rarely.
-			 */
-			ndelay(400);
-			ret = regmap_field_read(priv->rf[valid_idx], &valid);
-			if (ret)
-				return ret;
-		}
-	}
+	if (tsens_version(priv) == VER_0)
+		goto get_temp;
+
+	/* Valid bit is 0 for 6 AHB clock cycles.
+	 * At 19.2MHz, 1 AHB clock is ~60ns.
+	 * We should enter this loop very, very rarely.
+	 * Wait 1 us since it's the min of poll_timeout macro.
+	 * Old value was 400 ns.
+	 */
+	ret = regmap_field_read_poll_timeout(priv->rf[valid_idx], valid,
+					     valid, 1, 20 * USEC_PER_MSEC);
+	if (ret)
+		return ret;
 
+get_temp:
 	/* Valid bit is set, OK to read the temperature */
 	*temp = tsens_hw_to_mC(s, temp_idx);
 
-- 
2.33.0



