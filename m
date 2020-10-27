Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DFAB29BCAF
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:41:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1810992AbgJ0Qgi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 12:36:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:40466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1801893AbgJ0Po6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:44:58 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CED8122456;
        Tue, 27 Oct 2020 15:44:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813473;
        bh=KEqOOfrAnkfyiT2/q98UFhQvP+8j/UPZzmzHPa4vKyg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ut20jQJmMlSnjpITF6DuQNmxgBBXMwjC/I07YiRA5RSO8uMyy7Py5Ls2x0FquJ8a1
         QXopCq/ANvIfkJzVQDpvzKQYsCcyeTvOu2e/NAGpsoy93jX8vtfMWXgMaxo5iM6rIe
         3gTybwr9t8ppyq169yLLdbkPNI2yQvwdY17L7I7s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 563/757] Input: imx6ul_tsc - clean up some errors in imx6ul_tsc_resume()
Date:   Tue, 27 Oct 2020 14:53:33 +0100
Message-Id: <20201027135516.908603611@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 30df23c5ecdfb8da5b0bc17ceef67eff9e1b0957 ]

If imx6ul_tsc_init() fails then we need to clean up the clocks.

I reversed the "if (input_dev->users) {" condition to make the code a
bit simpler.

Fixes: 6cc527b05847 ("Input: imx6ul_tsc - propagate the errors")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lore.kernel.org/r/20200905124942.GC183976@mwanda
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/touchscreen/imx6ul_tsc.c | 27 +++++++++++++++-----------
 1 file changed, 16 insertions(+), 11 deletions(-)

diff --git a/drivers/input/touchscreen/imx6ul_tsc.c b/drivers/input/touchscreen/imx6ul_tsc.c
index 9ed258854349b..5e6ba5c4eca2a 100644
--- a/drivers/input/touchscreen/imx6ul_tsc.c
+++ b/drivers/input/touchscreen/imx6ul_tsc.c
@@ -530,20 +530,25 @@ static int __maybe_unused imx6ul_tsc_resume(struct device *dev)
 
 	mutex_lock(&input_dev->mutex);
 
-	if (input_dev->users) {
-		retval = clk_prepare_enable(tsc->adc_clk);
-		if (retval)
-			goto out;
-
-		retval = clk_prepare_enable(tsc->tsc_clk);
-		if (retval) {
-			clk_disable_unprepare(tsc->adc_clk);
-			goto out;
-		}
+	if (!input_dev->users)
+		goto out;
 
-		retval = imx6ul_tsc_init(tsc);
+	retval = clk_prepare_enable(tsc->adc_clk);
+	if (retval)
+		goto out;
+
+	retval = clk_prepare_enable(tsc->tsc_clk);
+	if (retval) {
+		clk_disable_unprepare(tsc->adc_clk);
+		goto out;
 	}
 
+	retval = imx6ul_tsc_init(tsc);
+	if (retval) {
+		clk_disable_unprepare(tsc->tsc_clk);
+		clk_disable_unprepare(tsc->adc_clk);
+		goto out;
+	}
 out:
 	mutex_unlock(&input_dev->mutex);
 	return retval;
-- 
2.25.1



