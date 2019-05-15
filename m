Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 505981EE98
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:23:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731169AbfEOLXZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:23:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:33764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731641AbfEOLXY (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:23:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A163020843;
        Wed, 15 May 2019 11:23:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557919404;
        bh=oy2kEOxIb6zKFnVnzlNUiUlY5ldvM1xcaN4RpTUfQFc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=unUp4PSGxQJR9JiGhpurvKNeS+fLJkgU6sZSt99l9FQVQclNySPhPFztAHTUmiEPz
         IsBgQNlk9fZj7NNJ0ewVWWoDeo17frMH1uMUADlU+Bq5kQxEb3um4RQlRNbOW/My5i
         OrQ0LsU4K+4rHK1XbchsL6+cDP0Zg/RLKAVRyA0Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pan Bian <bianpan2016@163.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 062/113] Input: synaptics-rmi4 - fix possible double free
Date:   Wed, 15 May 2019 12:55:53 +0200
Message-Id: <20190515090658.270679295@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090652.640988966@linuxfoundation.org>
References: <20190515090652.640988966@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index fc3ab93b7aea4..7fb358f961957 100644
--- a/drivers/input/rmi4/rmi_driver.c
+++ b/drivers/input/rmi4/rmi_driver.c
@@ -860,7 +860,7 @@ static int rmi_create_function(struct rmi_device *rmi_dev,
 
 	error = rmi_register_function(fn);
 	if (error)
-		goto err_put_fn;
+		return error;
 
 	if (pdt->function_number == 0x01)
 		data->f01_container = fn;
@@ -870,10 +870,6 @@ static int rmi_create_function(struct rmi_device *rmi_dev,
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



