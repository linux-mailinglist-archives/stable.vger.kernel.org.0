Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E713328B28
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:30:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239392AbhCAS3d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:29:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:41508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239782AbhCASXD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:23:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 88DF764EBE;
        Mon,  1 Mar 2021 17:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619241;
        bh=eehc2PSi7rAwMI1saIfUbgojscN4kYGZBmXr4spBp6Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H9bPHTAvUC+iXJcuvmx4/QCX+E4G616UOI4shC2V1pqEC2Z1eFYbWexLBRLakhRtP
         qinwjkkHc3P2QdahxgW0A8YDdSbvK+WE1miH6y8jvhk2rcZO68UVWTinqVS4y8nV8C
         xo5VYzzPl5SXl9RitfyH37NZg9wBX4AAwyb5IpPk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 383/663] Input: sur40 - fix an error code in sur40_probe()
Date:   Mon,  1 Mar 2021 17:10:31 +0100
Message-Id: <20210301161200.812294207@linuxfoundation.org>
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

[ Upstream commit b0b7d2815839024e5181bd2572f5d8d4f65363b3 ]

If v4l2_ctrl_handler_setup() fails then probe() should return an error
code instead of returning success.

Fixes: cee1e3e2ef39 ("media: add video control handlers using V4L2 control framework")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lore.kernel.org/r/YBKFkbATXa5fA3xj@mwanda
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/touchscreen/sur40.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/input/touchscreen/sur40.c b/drivers/input/touchscreen/sur40.c
index 620cdd7d214a6..12f2562b0141b 100644
--- a/drivers/input/touchscreen/sur40.c
+++ b/drivers/input/touchscreen/sur40.c
@@ -787,6 +787,7 @@ static int sur40_probe(struct usb_interface *interface,
 		dev_err(&interface->dev,
 			"Unable to register video controls.");
 		v4l2_ctrl_handler_free(&sur40->hdl);
+		error = sur40->hdl.error;
 		goto err_unreg_v4l2;
 	}
 
-- 
2.27.0



