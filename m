Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F9EB328B9C
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:40:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240219AbhCASiF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:38:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:43166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239414AbhCASau (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:30:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C5E9B651DE;
        Mon,  1 Mar 2021 17:19:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619150;
        bh=za8EdQ/t5PSQ4vUBu+pQG1IXy1/URJZkNPyVRLTta5g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JV02ABfyRD8vHGfBcIsmDt4sbtAjHB0WloIbLLgBUgu4J7ZclUXrUgRgKDRShYZe+
         cZIPGkcY3pG5zbzF40ihJSoGRxy/8bR+DM0Ff5ZbH9BIVWFHlnI0y4MtC1wBSrWEE6
         f37jZy+4mU4VTenfjt6MqWTUSj4fTbTSmejs0b74=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Lee Jones <lee.jones@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 350/663] mfd: wm831x-auxadc: Prevent use after free in wm831x_auxadc_read_irq()
Date:   Mon,  1 Mar 2021 17:09:58 +0100
Message-Id: <20210301161159.167329715@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 26783d74cc6a440ee3ef9836a008a697981013d0 ]

The "req" struct is always added to the "wm831x->auxadc_pending" list,
but it's only removed from the list on the success path.  If a failure
occurs then the "req" struct is freed but it's still on the list,
leading to a use after free.

Fixes: 78bb3688ea18 ("mfd: Support multiple active WM831x AUXADC conversions")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/wm831x-auxadc.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/mfd/wm831x-auxadc.c b/drivers/mfd/wm831x-auxadc.c
index 8a7cc0f86958b..65b98f3fbd929 100644
--- a/drivers/mfd/wm831x-auxadc.c
+++ b/drivers/mfd/wm831x-auxadc.c
@@ -93,11 +93,10 @@ static int wm831x_auxadc_read_irq(struct wm831x *wm831x,
 	wait_for_completion_timeout(&req->done, msecs_to_jiffies(500));
 
 	mutex_lock(&wm831x->auxadc_lock);
-
-	list_del(&req->list);
 	ret = req->val;
 
 out:
+	list_del(&req->list);
 	mutex_unlock(&wm831x->auxadc_lock);
 
 	kfree(req);
-- 
2.27.0



