Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 189DD499FC2
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:23:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1842122AbiAXXA5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:00:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1836497AbiAXWjh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:39:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19BE0C054878;
        Mon, 24 Jan 2022 13:02:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ADE086136A;
        Mon, 24 Jan 2022 21:02:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F6DBC340E7;
        Mon, 24 Jan 2022 21:02:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058127;
        bh=RQ5Ca9+CytE6FpXfdzRkzs6Fgfx0IT5jkMAAFnh6LJY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XyvmvvLes6ARkkVJW8Qvt/rbI+eovfZJy3Die87KQt8FYVxSSST7fqHfxH9n5cbSf
         lbzAoA2OLjFCqEvKdHF42h/tdkm3YyxrQY4NpQoDz+6I9LtXGgwfRRGzXbVKh2Izz7
         EPmWq4WHa1ACdn2/Cex9h4Cp4rFdBp1R7suMPpZM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0187/1039] media: i2c: ov8865: Fix lockdep error
Date:   Mon, 24 Jan 2022 19:32:56 +0100
Message-Id: <20220124184131.586323555@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
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
 


