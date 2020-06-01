Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0066D1EAE40
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:53:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730723AbgFASwQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:52:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:48260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729667AbgFASD6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 14:03:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 83117206E2;
        Mon,  1 Jun 2020 18:03:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591034638;
        bh=GKjFn3wxmv0gubGQZn6YoTfMCpvhx8WXfBG7hchkfLU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PgzVxnQ5MM6IKD8e2BJhji5+5sRA71M0aIP9T6F6wkOvikMBRUYHni6v/UQcd4KXC
         1VWWpnzbOP2sSYLrmR6IyGFM5JlUWdmr2ywt54Mj6+YDxT5pvYxZlO+DrTGavNjy3o
         wqu4oOw5dxpv+82CZKxyoYWJemMiTZ+qqy/QqTVo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Evan Green <evgreen@chromium.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 43/95] Input: synaptics-rmi4 - really fix attn_data use-after-free
Date:   Mon,  1 Jun 2020 19:53:43 +0200
Message-Id: <20200601174027.630196604@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174020.759151073@linuxfoundation.org>
References: <20200601174020.759151073@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Evan Green <evgreen@chromium.org>

[ Upstream commit d5a5e5b5fa7b86c05bf073acc0ba98fa280174ec ]

Fix a use-after-free noticed by running with KASAN enabled. If
rmi_irq_fn() is run twice in a row, then rmi_f11_attention() (among
others) will end up reading from drvdata->attn_data.data, which was
freed and left dangling in rmi_irq_fn().

Commit 55edde9fff1a ("Input: synaptics-rmi4 - prevent UAF reported by
KASAN") correctly identified and analyzed this bug. However the attempted
fix only NULLed out a local variable, missing the fact that
drvdata->attn_data is a struct, not a pointer.

NULL out the correct pointer in the driver data to prevent the attention
functions from copying from it.

Fixes: 55edde9fff1a ("Input: synaptics-rmi4 - prevent UAF reported by KASAN")
Fixes: b908d3cd812a ("Input: synaptics-rmi4 - allow to add attention data")
Signed-off-by: Evan Green <evgreen@chromium.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20200427145537.1.Ic8f898e0147beeee2c005ee7b20f1aebdef1e7eb@changeid
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/rmi4/rmi_driver.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/input/rmi4/rmi_driver.c b/drivers/input/rmi4/rmi_driver.c
index 162526a0d463..24a1ff34964c 100644
--- a/drivers/input/rmi4/rmi_driver.c
+++ b/drivers/input/rmi4/rmi_driver.c
@@ -208,7 +208,7 @@ static irqreturn_t rmi_irq_fn(int irq, void *dev_id)
 
 	if (count) {
 		kfree(attn_data.data);
-		attn_data.data = NULL;
+		drvdata->attn_data.data = NULL;
 	}
 
 	if (!kfifo_is_empty(&drvdata->attn_fifo))
-- 
2.25.1



