Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1B60226748
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:10:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728849AbgGTQKS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:10:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:48758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731840AbgGTQKS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:10:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F168322CBB;
        Mon, 20 Jul 2020 16:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595261417;
        bh=SctYfMR3QP81Kg16x2UXd6MhWrHdYmtqjLLE50S52Qg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eazYyY2TkPI8QVLzNoo+0T/TQ4LjNUEQk/8Wqh2NIKh30gHbvmsJy3sijGYrSrxmP
         FxpIW8C3qRj0Yq5OksbUsaO56k2Vfx2pQDuNquR7c9YTPan3Vg4/8HOk0T9qMAhNUQ
         5sAHIkc+zeLIzfTGsXW9QsY1msUkxjNKayIetpgw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Syed Nayyar Waris <syednwaris@gmail.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 078/244] counter: 104-quad-8: Add lock guards - differential encoder
Date:   Mon, 20 Jul 2020 17:35:49 +0200
Message-Id: <20200720152829.552887673@linuxfoundation.org>
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

[ Upstream commit 708d98932893cea609386cefdfd190f757f5a61c ]

Add lock protection from race conditions to 104-quad-8 counter driver
for differential encoder status code changes. Mutex lock calls used for
protection.

Signed-off-by: Syed Nayyar Waris <syednwaris@gmail.com>
Fixes: 954ab5cc5f3e ("counter: 104-quad-8: Support Differential Encoder Cable Status")
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/counter/104-quad-8.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/counter/104-quad-8.c b/drivers/counter/104-quad-8.c
index aa13708c2bc30..9364dc188f8ff 100644
--- a/drivers/counter/104-quad-8.c
+++ b/drivers/counter/104-quad-8.c
@@ -1274,18 +1274,26 @@ static ssize_t quad8_signal_cable_fault_read(struct counter_device *counter,
 					     struct counter_signal *signal,
 					     void *private, char *buf)
 {
-	const struct quad8_iio *const priv = counter->priv;
+	struct quad8_iio *const priv = counter->priv;
 	const size_t channel_id = signal->id / 2;
-	const bool disabled = !(priv->cable_fault_enable & BIT(channel_id));
+	bool disabled;
 	unsigned int status;
 	unsigned int fault;
 
-	if (disabled)
+	mutex_lock(&priv->lock);
+
+	disabled = !(priv->cable_fault_enable & BIT(channel_id));
+
+	if (disabled) {
+		mutex_unlock(&priv->lock);
 		return -EINVAL;
+	}
 
 	/* Logic 0 = cable fault */
 	status = inb(priv->base + QUAD8_DIFF_ENCODER_CABLE_STATUS);
 
+	mutex_unlock(&priv->lock);
+
 	/* Mask respective channel and invert logic */
 	fault = !(status & BIT(channel_id));
 
@@ -1317,6 +1325,8 @@ static ssize_t quad8_signal_cable_fault_enable_write(
 	if (ret)
 		return ret;
 
+	mutex_lock(&priv->lock);
+
 	if (enable)
 		priv->cable_fault_enable |= BIT(channel_id);
 	else
@@ -1327,6 +1337,8 @@ static ssize_t quad8_signal_cable_fault_enable_write(
 
 	outb(cable_fault_enable, priv->base + QUAD8_DIFF_ENCODER_CABLE_STATUS);
 
+	mutex_unlock(&priv->lock);
+
 	return len;
 }
 
-- 
2.25.1



