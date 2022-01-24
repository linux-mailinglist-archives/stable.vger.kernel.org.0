Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7E78499423
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:41:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357596AbiAXUja (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:39:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348276AbiAXUeT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:34:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76045C07E2BC;
        Mon, 24 Jan 2022 11:48:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3F81DB811FB;
        Mon, 24 Jan 2022 19:48:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 699C7C340E5;
        Mon, 24 Jan 2022 19:48:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053683;
        bh=fntRpshkPH1kBf19IZiQRtlhXjIeJ4hCEiSlfehiMwY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U23bKL5fsGRndt9amdc0pDIfynUYC9QYRnJJPSZ3uKfFiABYw9n26Rhx98iBKPKI+
         YiNRoFemHLboxzkIFqOjbKoYtQaJjoDhfAxo9Wj2gezFN+P040wAEZykp/r2FlDrUq
         d8yPhiKKSnX2frzHsG6hB/PULz9LBFvlj0VWiPF4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 110/563] media: si470x-i2c: fix possible memory leak in si470x_i2c_probe()
Date:   Mon, 24 Jan 2022 19:37:55 +0100
Message-Id: <20220124184028.219961437@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit ef054e345ed8c79ce1121a3599b5a2dfd78e57a0 ]

n the 'radio->hdl.error' error handling, ctrl handler allocated by
v4l2_ctrl_new_std() does not released, and caused memory leak as
follows:

unreferenced object 0xffff888033d54200 (size 256):
  comm "i2c-si470x-19", pid 909, jiffies 4294914203 (age 8.072s)
  hex dump (first 32 bytes):
    e8 69 11 03 80 88 ff ff 00 46 d5 33 80 88 ff ff  .i.......F.3....
    10 42 d5 33 80 88 ff ff 10 42 d5 33 80 88 ff ff  .B.3.....B.3....
  backtrace:
    [<00000000086bd4ed>] __kmalloc_node+0x1eb/0x360
    [<00000000bdb68871>] kvmalloc_node+0x66/0x120
    [<00000000fac74e4c>] v4l2_ctrl_new+0x7b9/0x1c60 [videodev]
    [<00000000693bf940>] v4l2_ctrl_new_std+0x19b/0x270 [videodev]
    [<00000000c0cb91bc>] si470x_i2c_probe+0x2d3/0x9a0 [radio_si470x_i2c]
    [<0000000056a6f01f>] i2c_device_probe+0x4d8/0xbe0

Fix the error handling path to avoid memory leak.

Reported-by: Hulk Robot <hulkci@huawei.com>
Fixes: 8c081b6f9a9b ("media: radio: Critical v4l2 registration...")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/radio/si470x/radio-si470x-i2c.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/radio/si470x/radio-si470x-i2c.c b/drivers/media/radio/si470x/radio-si470x-i2c.c
index a972c0705ac79..76d39e2e87706 100644
--- a/drivers/media/radio/si470x/radio-si470x-i2c.c
+++ b/drivers/media/radio/si470x/radio-si470x-i2c.c
@@ -368,7 +368,7 @@ static int si470x_i2c_probe(struct i2c_client *client)
 	if (radio->hdl.error) {
 		retval = radio->hdl.error;
 		dev_err(&client->dev, "couldn't register control\n");
-		goto err_dev;
+		goto err_all;
 	}
 
 	/* video device initialization */
@@ -463,7 +463,6 @@ static int si470x_i2c_probe(struct i2c_client *client)
 	return 0;
 err_all:
 	v4l2_ctrl_handler_free(&radio->hdl);
-err_dev:
 	v4l2_device_unregister(&radio->v4l2_dev);
 err_initial:
 	return retval;
-- 
2.34.1



