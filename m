Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01B422E411A
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:03:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408083AbgL1PCf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:02:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:47560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439974AbgL1OMv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:12:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0BD8622BF3;
        Mon, 28 Dec 2020 14:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164730;
        bh=mi/DeJzRXz47S3VNF9DlNrEgzgIcmxls+PobV+WzrQE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O8xXIu+4r8CMs9nPangDpCIOJ7qvPqceQkhoqmGPmyA7IMLPr0WkaWwocVbQNNVoi
         fsTNVxulHP8SePmKh44LP1Tby9Fj964XU54T9Y38oNMBMzNqr3FwAHKfAOAxOw2/+J
         rRXFKalyJe+u8/HpfQvMO0MHgtcS7Ukyum+kbUtI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yu Kuai <yukuai3@huawei.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 246/717] soc: amlogic: canvas: add missing put_device() call in meson_canvas_get()
Date:   Mon, 28 Dec 2020 13:44:04 +0100
Message-Id: <20201228125032.770101033@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit 28f851e6afa858f182802e23ac60c3ed7d1c04a1 ]

if of_find_device_by_node() succeed, meson_canvas_get() doesn't have
a corresponding put_device(). Thus add put_device() to fix the exception
handling for this function implementation.

Fixes: 382f8be04551 ("soc: amlogic: canvas: Fix meson_canvas_get when probe failed")
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Neil Armstrong <narmstrong@baylibre.com>
Signed-off-by: Kevin Hilman <khilman@baylibre.com>
Link: https://lore.kernel.org/r/20201117011322.522477-1-yukuai3@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/amlogic/meson-canvas.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/soc/amlogic/meson-canvas.c b/drivers/soc/amlogic/meson-canvas.c
index c655f5f92b124..d0329ad170d13 100644
--- a/drivers/soc/amlogic/meson-canvas.c
+++ b/drivers/soc/amlogic/meson-canvas.c
@@ -72,8 +72,10 @@ struct meson_canvas *meson_canvas_get(struct device *dev)
 	 * current state, this driver probe cannot return -EPROBE_DEFER
 	 */
 	canvas = dev_get_drvdata(&canvas_pdev->dev);
-	if (!canvas)
+	if (!canvas) {
+		put_device(&canvas_pdev->dev);
 		return ERR_PTR(-EINVAL);
+	}
 
 	return canvas;
 }
-- 
2.27.0



