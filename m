Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 994001199CD
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:52:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727907AbfLJVIj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:08:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:56092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727451AbfLJVIg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:08:36 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B117524696;
        Tue, 10 Dec 2019 21:08:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012115;
        bh=V1NUZndACQbO4v7EBwinVF/JrUe//xaw0pdq45yfOd4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HiaUQHazJqhTCYKMQmz9rY7YMdIoFPECW+KZMHeUQ/pZ/NnlGoBssDpE5pxY+ilTD
         UC7HwDMZ1GR0nuvdMBnwvEV+5LoZDUxOp8qCk7xeCe6/MpbO0AyKyUNn3kjmtuQMdy
         Q8c3gIeXgy2vPJ38bx2d/qWAhqtnCHgN8cdXz+cI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 087/350] misc: fastrpc: fix memory leak from miscdev->name
Date:   Tue, 10 Dec 2019 16:03:12 -0500
Message-Id: <20191210210735.9077-48-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210735.9077-1-sashal@kernel.org>
References: <20191210210735.9077-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

[ Upstream commit 2d10d2d170723e9278282458a6704552dcb77eac ]

Fix a memory leak in miscdev->name by using devm_variant

Orignally reported by kmemleak:
    [<ffffff80088b74d8>] kmemleak_alloc+0x50/0x84
    [<ffffff80081e015c>] __kmalloc_track_caller+0xe8/0x168
    [<ffffff8008371ab0>] kvasprintf+0x78/0x100
    [<ffffff8008371c6c>] kasprintf+0x50/0x74
    [<ffffff8008507f2c>] fastrpc_rpmsg_probe+0xd8/0x20c
    [<ffffff80086b63b4>] rpmsg_dev_probe+0xa8/0x148
    [<ffffff80084de50c>] really_probe+0x208/0x248
    [<ffffff80084de2dc>] driver_probe_device+0x98/0xc0
    [<ffffff80084dec6c>] __device_attach_driver+0x9c/0xac
    [<ffffff80084dca8c>] bus_for_each_drv+0x60/0x8c
    [<ffffff80084de64c>] __device_attach+0x8c/0x100
    [<ffffff80084de6e0>] device_initial_probe+0x20/0x28
    [<ffffff80084dcbd0>] bus_probe_device+0x34/0x7c
    [<ffffff80084da32c>] device_add+0x420/0x498
    [<ffffff80084da680>] device_register+0x24/0x2c

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20191009144123.24583-3-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/fastrpc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/fastrpc.c b/drivers/misc/fastrpc.c
index 1b1a794d639d0..842f2210dc7e2 100644
--- a/drivers/misc/fastrpc.c
+++ b/drivers/misc/fastrpc.c
@@ -1430,8 +1430,8 @@ static int fastrpc_rpmsg_probe(struct rpmsg_device *rpdev)
 		return -ENOMEM;
 
 	data->miscdev.minor = MISC_DYNAMIC_MINOR;
-	data->miscdev.name = kasprintf(GFP_KERNEL, "fastrpc-%s",
-				domains[domain_id]);
+	data->miscdev.name = devm_kasprintf(rdev, GFP_KERNEL, "fastrpc-%s",
+					    domains[domain_id]);
 	data->miscdev.fops = &fastrpc_fops;
 	err = misc_register(&data->miscdev);
 	if (err)
-- 
2.20.1

