Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FC0B2268B5
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:23:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733213AbgGTQKX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:10:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:48826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387656AbgGTQKU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:10:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8522920684;
        Mon, 20 Jul 2020 16:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595261420;
        bh=Ei8M7Vswo4eUwg7xiB3VR63fvxyvSUHoXgg/uOrPlCo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ml1e/gtTqHSqp/zCdiauIyRCe8YGUm+pAoVJyn5g8/DS5Y1/C3bqdD5bk5hwRKaPr
         9iRIEF2TxsKXAloyqELTPqFyNmIi5DKl23ctCmtbCfqE4sxJki6g66+/4loyoX3WMB
         OoMK1811bPg91Gk+Av5OFcxglsX1lAtLAOMoBT8M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Syed Nayyar Waris <syednwaris@gmail.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 079/244] counter: 104-quad-8: Add lock guards - filter clock prescaler
Date:   Mon, 20 Jul 2020 17:35:50 +0200
Message-Id: <20200720152829.600731933@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152825.863040590@linuxfoundation.org>
References: <20200720152825.863040590@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Syed Nayyar Waris <syednwaris@gmail.com>

[ Upstream commit d5ed76adb926a90fada98f518abc1ab6ef07d28f ]

Add lock protection from race conditions to the 104-quad-8 counter
driver for filter clock prescaler code changes. Mutex calls used for
protection.

Signed-off-by: Syed Nayyar Waris <syednwaris@gmail.com>
Fixes: de65d0556343 ("counter: 104-quad-8: Support Filter Clock Prescaler")
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/counter/104-quad-8.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/counter/104-quad-8.c b/drivers/counter/104-quad-8.c
index 9364dc188f8ff..d22cfae1b0198 100644
--- a/drivers/counter/104-quad-8.c
+++ b/drivers/counter/104-quad-8.c
@@ -1365,6 +1365,8 @@ static ssize_t quad8_signal_fck_prescaler_write(struct counter_device *counter,
 	if (ret)
 		return ret;
 
+	mutex_lock(&priv->lock);
+
 	priv->fck_prescaler[channel_id] = prescaler;
 
 	/* Reset Byte Pointer */
@@ -1375,6 +1377,8 @@ static ssize_t quad8_signal_fck_prescaler_write(struct counter_device *counter,
 	outb(QUAD8_CTR_RLD | QUAD8_RLD_RESET_BP | QUAD8_RLD_PRESET_PSC,
 	     base_offset + 1);
 
+	mutex_unlock(&priv->lock);
+
 	return len;
 }
 
-- 
2.25.1



