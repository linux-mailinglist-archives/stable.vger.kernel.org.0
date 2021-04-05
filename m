Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05251353F30
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:35:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239395AbhDEJKi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:10:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:56472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238845AbhDEJKT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:10:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1AA8461399;
        Mon,  5 Apr 2021 09:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617613812;
        bh=L/ouUvXPcjfupPz+rGsjZl+tj2CS6fb8QU4+/3xAreY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Uodi+R9mYEUgnpdGJR0InQDdQMLnzxOMFazrxbkYhIGR4dcOhtiP+eO45PKNCDMNd
         lMDCx5JYXvuw0S+p831xMjTYgahg0IlyRAFPDCFAidzaSOgdi1kHkYziyxkZEzVwz+
         dcWwzg6Yz+dvArXKyEOxaLu/FSORh7QodwgJkT+w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 100/126] extcon: Fix error handling in extcon_dev_register
Date:   Mon,  5 Apr 2021 10:54:22 +0200
Message-Id: <20210405085034.357047941@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085031.040238881@linuxfoundation.org>
References: <20210405085031.040238881@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

[ Upstream commit d3bdd1c3140724967ca4136755538fa7c05c2b4e ]

When devm_kcalloc() fails, we should execute device_unregister()
to unregister edev->dev from system.

Fixes: 046050f6e623e ("extcon: Update the prototype of extcon_register_notifier() with enum extcon")
Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/extcon/extcon.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/extcon/extcon.c b/drivers/extcon/extcon.c
index 0a6438cbb3f3..e7a9561a826d 100644
--- a/drivers/extcon/extcon.c
+++ b/drivers/extcon/extcon.c
@@ -1241,6 +1241,7 @@ int extcon_dev_register(struct extcon_dev *edev)
 				sizeof(*edev->nh), GFP_KERNEL);
 	if (!edev->nh) {
 		ret = -ENOMEM;
+		device_unregister(&edev->dev);
 		goto err_dev;
 	}
 
-- 
2.30.2



