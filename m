Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62B63498FA2
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:55:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351912AbiAXTxr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:53:47 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:47446 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350903AbiAXTug (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:50:36 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E9D7E60920;
        Mon, 24 Jan 2022 19:50:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2803C340E5;
        Mon, 24 Jan 2022 19:50:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053833;
        bh=P1FEAYpAUHwEE1RE/qP8LxkIT85JWa3N48CBRmLc0jU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bdLDwe/nhgeqexLnUky4q6uZMwMeaLQbBW2HTflr47B2ne60jDLa30engkCT8fA2i
         ZNmNM7Wv3E9nBFjMhkiSz+w1gyzazt0OmU427BIJqumlDDV+lDH9XrL7BPoAh41Wx7
         niVXk4fmrmJVUbdQhERLog9/UmuKkM6PmtDlcrlA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marijn Suijten <marijn.suijten@somainline.org>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@somainline.org>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Lee Jones <lee.jones@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 192/563] backlight: qcom-wled: Override default length with qcom,enabled-strings
Date:   Mon, 24 Jan 2022 19:39:17 +0100
Message-Id: <20220124184031.069588962@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marijn Suijten <marijn.suijten@somainline.org>

[ Upstream commit 2b4b49602f9feca7b7a84eaa33ad9e666c8aa695 ]

The length of qcom,enabled-strings as property array is enough to
determine the number of strings to be enabled, without needing to set
qcom,num-strings to override the default number of strings when less
than the default (which is also the maximum) is provided in DT.

This also introduces an extra warning when qcom,num-strings is set,
denoting that it is not necessary to set both anymore.  It is usually
more concise to set just qcom,num-length when a zero-based, contiguous
range of strings is needed (the majority of the cases), or to only set
qcom,enabled-strings when a specific set of indices is desired.

Fixes: 775d2ffb4af6 ("backlight: qcom-wled: Restructure the driver for WLED3")
Signed-off-by: Marijn Suijten <marijn.suijten@somainline.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@somainline.org>
Reviewed-by: Daniel Thompson <daniel.thompson@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Link: https://lore.kernel.org/r/20211115203459.1634079-6-marijn.suijten@somainline.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/backlight/qcom-wled.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/video/backlight/qcom-wled.c b/drivers/video/backlight/qcom-wled.c
index 9e09165984b48..70fcee74866a5 100644
--- a/drivers/video/backlight/qcom-wled.c
+++ b/drivers/video/backlight/qcom-wled.c
@@ -1521,6 +1521,8 @@ static int wled_configure(struct wled *wled)
 				return -EINVAL;
 			}
 		}
+
+		cfg->num_strings = string_len;
 	}
 
 	rc = of_property_read_u32(dev->of_node, "qcom,num-strings", &val);
@@ -1531,9 +1533,13 @@ static int wled_configure(struct wled *wled)
 			return -EINVAL;
 		}
 
-		if (string_len > 0 && val > string_len) {
-			dev_err(dev, "qcom,num-strings exceeds qcom,enabled-strings\n");
-			return -EINVAL;
+		if (string_len > 0) {
+			dev_warn(dev, "Only one of qcom,num-strings or qcom,enabled-strings"
+				      " should be set\n");
+			if (val > string_len) {
+				dev_err(dev, "qcom,num-strings exceeds qcom,enabled-strings\n");
+				return -EINVAL;
+			}
 		}
 
 		cfg->num_strings = val;
-- 
2.34.1



