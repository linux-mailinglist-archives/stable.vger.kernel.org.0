Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CD3A499A9E
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:55:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1573620AbiAXVpZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:45:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378331AbiAXVjT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:39:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 803ACC034005;
        Mon, 24 Jan 2022 12:24:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0B42761491;
        Mon, 24 Jan 2022 20:24:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFCB8C340E7;
        Mon, 24 Jan 2022 20:24:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055856;
        bh=+mc7XH6ZHrcnhKZMatKve+G3YzRkXog/jm9bBkgtgnU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dsIkEDc3qQAUOaGkvaG9vthmBZjx/RtFZEjHpt5H0SbfrWTP5dV7epL4Zb097FuG7
         rPhSnWSN2cbuUvuOVUPalA0kudiH6q2LgrBacB2zG3oQTn87XizbYMeeEQCXDWvbEQ
         Bv99fJrIg4oktKZf7n12D1/ZSAibaOxH9tgeEUWQ=
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
Subject: [PATCH 5.15 287/846] backlight: qcom-wled: Pass number of elements to read to read_u32_array
Date:   Mon, 24 Jan 2022 19:36:44 +0100
Message-Id: <20220124184110.822340218@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marijn Suijten <marijn.suijten@somainline.org>

[ Upstream commit e29e24bdabfeddbf8b1a4ecac1af439a85150438 ]

of_property_read_u32_array takes the number of elements to read as last
argument. This does not always need to be 4 (sizeof(u32)) but should
instead be the size of the array in DT as read just above with
of_property_count_elems_of_size.

To not make such an error go unnoticed again the driver now bails
accordingly when of_property_read_u32_array returns an error.
Surprisingly the indentation of newlined arguments is lining up again
after prepending `rc = `.

Fixes: 775d2ffb4af6 ("backlight: qcom-wled: Restructure the driver for WLED3")
Signed-off-by: Marijn Suijten <marijn.suijten@somainline.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@somainline.org>
Reviewed-by: Daniel Thompson <daniel.thompson@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Link: https://lore.kernel.org/r/20211115203459.1634079-3-marijn.suijten@somainline.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/backlight/qcom-wled.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/video/backlight/qcom-wled.c b/drivers/video/backlight/qcom-wled.c
index 8a42ed89c59c9..d413b913fef32 100644
--- a/drivers/video/backlight/qcom-wled.c
+++ b/drivers/video/backlight/qcom-wled.c
@@ -1535,10 +1535,15 @@ static int wled_configure(struct wled *wled)
 			return -EINVAL;
 		}
 
-		of_property_read_u32_array(dev->of_node,
+		rc = of_property_read_u32_array(dev->of_node,
 						"qcom,enabled-strings",
 						wled->cfg.enabled_strings,
-						sizeof(u32));
+						string_len);
+		if (rc) {
+			dev_err(dev, "Failed to read %d elements from qcom,enabled-strings: %d\n",
+				string_len, rc);
+			return rc;
+		}
 
 		for (i = 0; i < string_len; ++i) {
 			if (wled->cfg.enabled_strings[i] >= wled->max_string_count) {
-- 
2.34.1



