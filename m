Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1BA615B1A
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 07:52:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728912AbfEGFjj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 01:39:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:59188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728900AbfEGFjf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 May 2019 01:39:35 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 374E720675;
        Tue,  7 May 2019 05:39:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557207574;
        bh=Us5MfCv6Q/pgiAo/5s7jo6BS3pLRtJC0q0qVQztNazA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A132cDbtJnYfSRyZjmE11lEuu/onVImyzFFD47/z4Md+5Btg8doc6EKqUpqhwNoPi
         HiANO2g5QBu/ob1K/UlWkcyvSY37PWy2dO+p3rtk0DdiMqYxh88oInJWYjcEER+ZYm
         ERV4epg8mrlW9KPDDdEAMZyFCBbUzipgIUtuiwvg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pan Bian <bianpan2016@163.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>, linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 34/95] Input: synaptics-rmi4 - fix possible double free
Date:   Tue,  7 May 2019 01:37:23 -0400
Message-Id: <20190507053826.31622-34-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190507053826.31622-1-sashal@kernel.org>
References: <20190507053826.31622-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pan Bian <bianpan2016@163.com>

[ Upstream commit bce1a78423961fce676ac65540a31b6ffd179e6d ]

The RMI4 function structure has been released in rmi_register_function
if error occurs. However, it will be released again in the function
rmi_create_function, which may result in a double-free bug.

Signed-off-by: Pan Bian <bianpan2016@163.com>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/rmi4/rmi_driver.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/input/rmi4/rmi_driver.c b/drivers/input/rmi4/rmi_driver.c
index f5954981e9ee..997ccae7ee05 100644
--- a/drivers/input/rmi4/rmi_driver.c
+++ b/drivers/input/rmi4/rmi_driver.c
@@ -883,7 +883,7 @@ static int rmi_create_function(struct rmi_device *rmi_dev,
 
 	error = rmi_register_function(fn);
 	if (error)
-		goto err_put_fn;
+		return error;
 
 	if (pdt->function_number == 0x01)
 		data->f01_container = fn;
@@ -893,10 +893,6 @@ static int rmi_create_function(struct rmi_device *rmi_dev,
 	list_add_tail(&fn->node, &data->function_list);
 
 	return RMI_SCAN_CONTINUE;
-
-err_put_fn:
-	put_device(&fn->dev);
-	return error;
 }
 
 void rmi_enable_irq(struct rmi_device *rmi_dev, bool clear_wake)
-- 
2.20.1

