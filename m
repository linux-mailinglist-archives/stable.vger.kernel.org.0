Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F23F37CCA6
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:06:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238222AbhELQos (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:44:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:49322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242324AbhELQeW (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:34:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9830261CBE;
        Wed, 12 May 2021 15:59:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835165;
        bh=2o6DU6hH7ysLOdTIQHG/FewhYFKML5hyRDqHm0YzfW0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ch3x6J8LBPky/i0ANKjocPjd+F4JqJPfYvmapX7Yx/p9tGldisF8IhOBKYHDl8PYK
         rQv6VysbuG/atlmDzBcvOF3s64Mj3JN8Ase1txACXlkRn+9g2FPuRANNTpltrHta+d
         dahyQUfBePFK6j5TBDoI0kd9KgMG01k0MvG45tG8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Pan Bian <bianpan2016@163.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 235/677] bus: qcom: Put child node before return
Date:   Wed, 12 May 2021 16:44:41 +0200
Message-Id: <20210512144845.048412658@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pan Bian <bianpan2016@163.com>

[ Upstream commit ac6ad7c2a862d682bb584a4bc904d89fa7721af8 ]

Put child node before return to fix potential reference count leak.
Generally, the reference count of child is incremented and decremented
automatically in the macro for_each_available_child_of_node() and should
be decremented manually if the loop is broken in loop body.

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Fixes: 335a12754808 ("bus: qcom: add EBI2 driver")
Signed-off-by: Pan Bian <bianpan2016@163.com>
Link: https://lore.kernel.org/r/20210121114907.109267-1-bianpan2016@163.com
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/qcom-ebi2.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/bus/qcom-ebi2.c b/drivers/bus/qcom-ebi2.c
index 03ddcf426887..0b8f53a688b8 100644
--- a/drivers/bus/qcom-ebi2.c
+++ b/drivers/bus/qcom-ebi2.c
@@ -353,8 +353,10 @@ static int qcom_ebi2_probe(struct platform_device *pdev)
 
 		/* Figure out the chipselect */
 		ret = of_property_read_u32(child, "reg", &csindex);
-		if (ret)
+		if (ret) {
+			of_node_put(child);
 			return ret;
+		}
 
 		if (csindex > 5) {
 			dev_err(dev,
-- 
2.30.2



