Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98408499DD2
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:04:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1586275AbiAXW0J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 17:26:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1583166AbiAXWRV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:17:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD72AC04A2E2;
        Mon, 24 Jan 2022 12:45:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5715260918;
        Mon, 24 Jan 2022 20:45:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D89FC340E5;
        Mon, 24 Jan 2022 20:45:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057154;
        bh=i+A0p5YDl/+X2W0iDwOvletNHGtjkJkx/hwzAXm/3HA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XcHTW4A1MLFS1WWquG0Fu2bTPHPZdbdc5CJtxof8UJXFqQ/4x5CNZNdoiKDQM/NwZ
         SAtDOE98PymrAkeJURqCkbUJTIYY44nqelWHzeoNcP1n1VULUqPT8t0NI8jueeJa6J
         s/T8whC7CzLUFz1zHMAzNcrsf+eQLQhJSQeU6H/U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Peng Fan <peng.fan@nxp.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: [PATCH 5.15 686/846] remoteproc: imx_rproc: Fix a resource leak in the remove function
Date:   Mon, 24 Jan 2022 19:43:23 +0100
Message-Id: <20220124184124.725359035@linuxfoundation.org>
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

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

commit 4da96175014be67c846fd274eace08066e525d75 upstream.

'priv->workqueue' is destroyed in the error handling path of the probe but
not in the remove function.

Add the missing call to release some resources.

Cc: stable <stable@vger.kernel.org>
Fixes: 2df7062002d0 ("remoteproc: imx_proc: enable virtio/mailbox")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Tested-by: Peng Fan <peng.fan@nxp.com>
Link: https://lore.kernel.org/r/d28ca94a4031bd7297d47c2164e18885a5a6ec19.1634366546.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/remoteproc/imx_rproc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/remoteproc/imx_rproc.c
+++ b/drivers/remoteproc/imx_rproc.c
@@ -830,6 +830,7 @@ static int imx_rproc_remove(struct platf
 	clk_disable_unprepare(priv->clk);
 	rproc_del(rproc);
 	imx_rproc_free_mbox(rproc);
+	destroy_workqueue(priv->workqueue);
 	rproc_free(rproc);
 
 	return 0;


