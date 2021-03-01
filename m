Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44A423288F8
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:52:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236903AbhCARrh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:47:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:60208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238366AbhCARmV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:42:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E655A650CE;
        Mon,  1 Mar 2021 16:57:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614617833;
        bh=KSNNDpiBWAYQDdr8QuWekYCume0XCLW8s3WZlSMMBt4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vPwZxwFc/Fdg61l+nhWMkTqgf6qJ/oIHjQozl/+7tggzHQb+3Rv/blwQYwGk8UpZN
         RHCjWDRegaLK011C9kQ0s2ir1QEYdrJB03NpSFfNe1rEogHjxyjZsDLu9jedHbEcHP
         2XuJ2GuHdt153w1nz36ByS0MrWANgnh0VKFJU2ns=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 195/340] Input: sur40 - fix an error code in sur40_probe()
Date:   Mon,  1 Mar 2021 17:12:19 +0100
Message-Id: <20210301161057.907206151@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161048.294656001@linuxfoundation.org>
References: <20210301161048.294656001@linuxfoundation.org>
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
index 2e2ea5719c90e..902522df03592 100644
--- a/drivers/input/touchscreen/sur40.c
+++ b/drivers/input/touchscreen/sur40.c
@@ -774,6 +774,7 @@ static int sur40_probe(struct usb_interface *interface,
 		dev_err(&interface->dev,
 			"Unable to register video controls.");
 		v4l2_ctrl_handler_free(&sur40->hdl);
+		error = sur40->hdl.error;
 		goto err_unreg_v4l2;
 	}
 
-- 
2.27.0



