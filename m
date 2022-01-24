Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D4BF499284
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:21:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381647AbiAXUV1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:21:27 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:57132 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349285AbiAXURw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:17:52 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 26F55B812AA;
        Mon, 24 Jan 2022 20:17:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BF32C340E5;
        Mon, 24 Jan 2022 20:17:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055469;
        bh=RQ5Ca9+CytE6FpXfdzRkzs6Fgfx0IT5jkMAAFnh6LJY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SeGqEkZA2sNUb0CfgaymO3RUZORy1vcCqHfyzZCOSjvqkyNO2Q3IK61+25x2JtrkL
         uvKxnW6ZyBSq0uQNvd4cFPN9MNFgKweAEkUtrlcIzgfiq6lkPORZkVqdW6Rjr32+jk
         qvlqnTzPDq296ZIaaDhqwLxrRUZvyWpMg+5xW3iM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 162/846] media: i2c: ov8865: Fix lockdep error
Date:   Mon, 24 Jan 2022 19:34:39 +0100
Message-Id: <20220124184106.572115467@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 6e1c9bc9ae96e57bcd8807174f2c0f44f9ef7938 ]

ov8865_state_init() calls ov8865_state_mipi_configure() which uses
__v4l2_ctrl_s_ctrl[_int64](). This means that sensor->mutex (which
is also sensor->ctrls.handler.lock) must be locked before calling
ov8865_state_init().

Note ov8865_state_mipi_configure() is also used in other places where
the lock is already held so it cannot be changed itself.

This fixes the following lockdep kernel WARN:

[   13.233421] WARNING: CPU: 0 PID: 8 at drivers/media/v4l2-core/v4l2-ctrls-api.c:833 __v4l2_ctrl_s_ctrl+0x4d/0x60 [videodev]
...
[   13.234063] Call Trace:
[   13.234074]  ov8865_state_configure+0x98b/0xc00 [ov8865]
[   13.234095]  ov8865_probe+0x4b1/0x54c [ov8865]
[   13.234117]  i2c_device_probe+0x13c/0x2d0

Fixes: 11c0d8fdccc5 ("media: i2c: Add support for the OV8865 image sensor")
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ov8865.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/media/i2c/ov8865.c
+++ b/drivers/media/i2c/ov8865.c
@@ -2893,7 +2893,9 @@ static int ov8865_probe(struct i2c_clien
 	if (ret)
 		goto error_mutex;
 
+	mutex_lock(&sensor->mutex);
 	ret = ov8865_state_init(sensor);
+	mutex_unlock(&sensor->mutex);
 	if (ret)
 		goto error_ctrls;
 


