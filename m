Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 970B432907C
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:09:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242947AbhCAUIw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:08:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:60332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242370AbhCAT5q (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:57:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9509364F95;
        Mon,  1 Mar 2021 17:56:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621371;
        bh=eehc2PSi7rAwMI1saIfUbgojscN4kYGZBmXr4spBp6Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tb4EEqYsj2GdtJCawbjFOW66VYsQkX7JR5F4VIdF3TDRjy/iSY+hJvui2dn0yER2v
         3BClhP9RI352Fz65/0aENmncdQ16n1WQV6B8s7aj3NfazA+0fOziERnuyWmkMB3pSM
         X7IJicqPf7ih3wva8mGTqvFP9/nK3aEsHLgZWHGI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 464/775] Input: sur40 - fix an error code in sur40_probe()
Date:   Mon,  1 Mar 2021 17:10:32 +0100
Message-Id: <20210301161224.477590285@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
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



