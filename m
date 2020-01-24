Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE3CB147AD9
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 10:40:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730904AbgAXJiq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 04:38:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:35976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731011AbgAXJio (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 04:38:44 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9E89D2070A;
        Fri, 24 Jan 2020 09:38:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579858724;
        bh=531QMMqu/j6aQNWMHtkEaCOjaiT2MCErzTciQl9Vjr8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oDJ8tynTCnF6bTgwaZthTZTvt2jgXyuN7VMAfJu+8WmXrbEB4AJsZ15zDdDExLeIt
         Gfv+I3d0X6giiduJzHbEhdvlQFJwZbgP3LcqhfHvkRVbLWVeE+jvuCMewhsr78+id8
         K/Mn29VK5sjxdneyjSbJxJyStoCBn41iBupJVs5A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Venkata Narendra Kumar Gutta <vnkgutta@codeaurora.org>,
        Evan Green <evgreen@chromium.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Subject: [PATCH 5.4 042/102] soc: qcom: llcc: Name regmaps to avoid collisions
Date:   Fri, 24 Jan 2020 10:30:43 +0100
Message-Id: <20200124092812.633099432@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092806.004582306@linuxfoundation.org>
References: <20200124092806.004582306@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephen Boyd <swboyd@chromium.org>

commit 2bfd3e7651addcaf48f12d4f11ea9d8fca6c3aa8 upstream.

We'll end up with debugfs collisions if we don't give names to the
regmaps created by this driver. Change the name of the config before
registering it so we don't collide in debugfs.

Fixes: 7f9c136216c7 ("soc: qcom: Add broadcast base for Last Level Cache Controller (LLCC)")
Cc: Venkata Narendra Kumar Gutta <vnkgutta@codeaurora.org>
Reviewed-by: Evan Green <evgreen@chromium.org>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/soc/qcom/llcc-slice.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/soc/qcom/llcc-slice.c
+++ b/drivers/soc/qcom/llcc-slice.c
@@ -48,7 +48,7 @@
 
 static struct llcc_drv_data *drv_data = (void *) -EPROBE_DEFER;
 
-static const struct regmap_config llcc_regmap_config = {
+static struct regmap_config llcc_regmap_config = {
 	.reg_bits = 32,
 	.reg_stride = 4,
 	.val_bits = 32,
@@ -323,6 +323,7 @@ static struct regmap *qcom_llcc_init_mmi
 	if (IS_ERR(base))
 		return ERR_CAST(base);
 
+	llcc_regmap_config.name = name;
 	return devm_regmap_init_mmio(&pdev->dev, base, &llcc_regmap_config);
 }
 


