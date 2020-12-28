Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 690A42E670E
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:22:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732182AbgL1NNG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:13:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:41046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732184AbgL1NND (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:13:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 911B42076D;
        Mon, 28 Dec 2020 13:12:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609161143;
        bh=8eCHzQ4BLhUXnqS/nK/Jn00izLL+xMFmE2s9i2yfi7c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QMEYyDW0qer3BUkKcGPHZYGO83xkyszxK06mMK8sqI8psInUjmCpQTkg0mbkI0wXc
         eeXEIU7lNSrZORto7o6dqS7DO8tavJaIx1TfkzLjj6+gKH/Spoexmu+sbvrm3FSAL4
         2fXWF2Bwv18+l0nWybmW6mV1GJ1aQvpGZxwZauBk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jing Xiangfeng <jingxiangfeng@huawei.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 116/242] HSI: omap_ssi: Dont jump to free ID in ssi_add_controller()
Date:   Mon, 28 Dec 2020 13:48:41 +0100
Message-Id: <20201228124910.404259769@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124904.654293249@linuxfoundation.org>
References: <20201228124904.654293249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jing Xiangfeng <jingxiangfeng@huawei.com>

[ Upstream commit 41fff6e19bc8d6d8bca79ea388427c426e72e097 ]

In current code, it jumps to ida_simple_remove() when ida_simple_get()
failes to allocate an ID. Just return to fix it.

Fixes: 0fae198988b8 ("HSI: omap_ssi: built omap_ssi and omap_ssi_port into one module")
Signed-off-by: Jing Xiangfeng <jingxiangfeng@huawei.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hsi/controllers/omap_ssi_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hsi/controllers/omap_ssi_core.c b/drivers/hsi/controllers/omap_ssi_core.c
index 88e48b3469164..3554443a609cb 100644
--- a/drivers/hsi/controllers/omap_ssi_core.c
+++ b/drivers/hsi/controllers/omap_ssi_core.c
@@ -389,7 +389,7 @@ static int ssi_add_controller(struct hsi_controller *ssi,
 
 	err = ida_simple_get(&platform_omap_ssi_ida, 0, 0, GFP_KERNEL);
 	if (err < 0)
-		goto out_err;
+		return err;
 	ssi->id = err;
 
 	ssi->owner = THIS_MODULE;
-- 
2.27.0



