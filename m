Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14BD52E4172
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:07:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439569AbgL1PG7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:06:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:44854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439001AbgL1OKT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:10:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DD2C1207B6;
        Mon, 28 Dec 2020 14:09:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164579;
        bh=wZyR5rv27nXpWJW44xZWFHzMeEP09gHplB6lbNBH8ig=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rd5yF79P+z1/BcslNgugaq3KfNFt33T4Rtgcjs+kgL6sKrf+HH9gmF/yxmNLwqvVM
         1gjmZehgDEbdFUT7tm5F9sSM82vtkipZqNRWiAYnQ6t9PdNql9kFPOceR/MWDu1Tlp
         QeLoHMZhtyT4t4/g0eMvKVV1TCBx789F8586DeUA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jing Xiangfeng <jingxiangfeng@huawei.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 225/717] HSI: omap_ssi: Dont jump to free ID in ssi_add_controller()
Date:   Mon, 28 Dec 2020 13:43:43 +0100
Message-Id: <20201228125031.760485201@linuxfoundation.org>
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
index fa69b94debd9b..7596dc1646484 100644
--- a/drivers/hsi/controllers/omap_ssi_core.c
+++ b/drivers/hsi/controllers/omap_ssi_core.c
@@ -355,7 +355,7 @@ static int ssi_add_controller(struct hsi_controller *ssi,
 
 	err = ida_simple_get(&platform_omap_ssi_ida, 0, 0, GFP_KERNEL);
 	if (err < 0)
-		goto out_err;
+		return err;
 	ssi->id = err;
 
 	ssi->owner = THIS_MODULE;
-- 
2.27.0



