Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67D3C2E37EC
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:04:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730132AbgL1NCo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:02:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:58244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730111AbgL1NCg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:02:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 840D3208B6;
        Mon, 28 Dec 2020 13:02:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609160541;
        bh=DHj/ZKV+fJ20N51NHcGxptF1iAO6LZ9Wh37cjrB0aZQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tAmKGdbf8fRKu1gZvBlVidMgpsah75MfiPZzwBywhQ5rOrTeKQkNA33aBbuC+ELui
         vRWOtqbKcubLKrcyorTLRbv46a2/8ROMeEoH2VYIWJA8AX02VY0JFcXmib8yKmgO//
         xOpUUrBZMAxIr2qFlg2oiIXYHVlOmsdbvbjTTyMU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jing Xiangfeng <jingxiangfeng@huawei.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 084/175] HSI: omap_ssi: Dont jump to free ID in ssi_add_controller()
Date:   Mon, 28 Dec 2020 13:48:57 +0100
Message-Id: <20201228124857.312961290@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124853.216621466@linuxfoundation.org>
References: <20201228124853.216621466@linuxfoundation.org>
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
index 9a29b34ed2c82..22cd7169011d1 100644
--- a/drivers/hsi/controllers/omap_ssi_core.c
+++ b/drivers/hsi/controllers/omap_ssi_core.c
@@ -391,7 +391,7 @@ static int ssi_add_controller(struct hsi_controller *ssi,
 
 	err = ida_simple_get(&platform_omap_ssi_ida, 0, 0, GFP_KERNEL);
 	if (err < 0)
-		goto out_err;
+		return err;
 	ssi->id = err;
 
 	ssi->owner = THIS_MODULE;
-- 
2.27.0



