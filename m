Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 075091EAEB8
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:56:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727996AbgFAS40 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:56:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:43370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729668AbgFASAh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 14:00:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 123592073B;
        Mon,  1 Jun 2020 18:00:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591034436;
        bh=NR2Eju7ZDcxi7t4Urn2zUNlYUweZkyenQGSSfGDr1Wc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mprP0BB5XKf9q0F9NUkp0KCX0O3ed8BrUv2lSsvDBYq3/jbSy1nhoN56e8YJJ2aoK
         3pMZcTy3uIsGi5e19jXIeiuaa1owh7parGyjB7xjkJbOtT/yTHjdgyi3Kwp+w+xZwS
         gdPvalivAx8TZbsXbRA3gOmeuvmUyMOd1n7HAQIQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wei Yongjun <weiyongjun1@huawei.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 31/77] Input: synaptics-rmi4 - fix error return code in rmi_driver_probe()
Date:   Mon,  1 Jun 2020 19:53:36 +0200
Message-Id: <20200601174022.192428957@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174016.396817032@linuxfoundation.org>
References: <20200601174016.396817032@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

[ Upstream commit 5caab2da63207d6d631007f592f5219459e3454d ]

Fix to return a negative error code from the input_register_device()
error handling case instead of 0, as done elsewhere in this function.

Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Link: https://lore.kernel.org/r/20200428134948.78343-1-weiyongjun1@huawei.com
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/rmi4/rmi_driver.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/input/rmi4/rmi_driver.c b/drivers/input/rmi4/rmi_driver.c
index 633fd0d660c1..30a8d816c45c 100644
--- a/drivers/input/rmi4/rmi_driver.c
+++ b/drivers/input/rmi4/rmi_driver.c
@@ -1220,7 +1220,8 @@ static int rmi_driver_probe(struct device *dev)
 	if (data->input) {
 		rmi_driver_set_input_name(rmi_dev, data->input);
 		if (!rmi_dev->xport->input) {
-			if (input_register_device(data->input)) {
+			retval = input_register_device(data->input);
+			if (retval) {
 				dev_err(dev, "%s: Failed to register input device.\n",
 					__func__);
 				goto err_destroy_functions;
-- 
2.25.1



