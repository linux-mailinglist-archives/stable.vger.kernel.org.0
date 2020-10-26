Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AC2C299F74
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 01:23:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437440AbgJ0AWb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 20:22:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:34336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2410929AbgJZXzl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Oct 2020 19:55:41 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C79692151B;
        Mon, 26 Oct 2020 23:55:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603756540;
        bh=IpT/K6eK2wh43wNZVDZJWmzMRqa5zzWcj3v8qvoAwCs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IGD052Y6RGDrF/fla8t9KSmpQfXo5Tq/vTgyZun/L/+UTtKkhqjJDNqGw0B7Pk2KW
         6NCXhauXhqC9klMyDdnmyRUc61r7cJBspG4FvCcwTWPzGO/kRB+xRdvGc9rrfnjL8x
         uBPo/Qpf49Hwvh8zlfdWcbd1s9fw79qUURx7N17w=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nadezda Lutovinova <lutovinova@ispras.ru>,
        Sam Ravnborg <sam@ravnborg.org>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 19/80] drm/brige/megachips: Add checking if ge_b850v3_lvds_init() is working correctly
Date:   Mon, 26 Oct 2020 19:54:15 -0400
Message-Id: <20201026235516.1025100-19-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201026235516.1025100-1-sashal@kernel.org>
References: <20201026235516.1025100-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nadezda Lutovinova <lutovinova@ispras.ru>

[ Upstream commit f688a345f0d7a6df4dd2aeca8e4f3c05e123a0ee ]

If ge_b850v3_lvds_init() does not allocate memory for ge_b850v3_lvds_ptr,
then a null pointer dereference is accessed.

The patch adds checking of the return value of ge_b850v3_lvds_init().

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Nadezda Lutovinova <lutovinova@ispras.ru>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20200819143756.30626-1-lutovinova@ispras.ru
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/bridge/megachips-stdpxxxx-ge-b850v3-fw.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/bridge/megachips-stdpxxxx-ge-b850v3-fw.c b/drivers/gpu/drm/bridge/megachips-stdpxxxx-ge-b850v3-fw.c
index 6e81e5db57f25..b050fd1f3d201 100644
--- a/drivers/gpu/drm/bridge/megachips-stdpxxxx-ge-b850v3-fw.c
+++ b/drivers/gpu/drm/bridge/megachips-stdpxxxx-ge-b850v3-fw.c
@@ -295,8 +295,12 @@ static int stdp4028_ge_b850v3_fw_probe(struct i2c_client *stdp4028_i2c,
 				       const struct i2c_device_id *id)
 {
 	struct device *dev = &stdp4028_i2c->dev;
+	int ret;
+
+	ret = ge_b850v3_lvds_init(dev);
 
-	ge_b850v3_lvds_init(dev);
+	if (ret)
+		return ret;
 
 	ge_b850v3_lvds_ptr->stdp4028_i2c = stdp4028_i2c;
 	i2c_set_clientdata(stdp4028_i2c, ge_b850v3_lvds_ptr);
@@ -354,8 +358,12 @@ static int stdp2690_ge_b850v3_fw_probe(struct i2c_client *stdp2690_i2c,
 				       const struct i2c_device_id *id)
 {
 	struct device *dev = &stdp2690_i2c->dev;
+	int ret;
+
+	ret = ge_b850v3_lvds_init(dev);
 
-	ge_b850v3_lvds_init(dev);
+	if (ret)
+		return ret;
 
 	ge_b850v3_lvds_ptr->stdp2690_i2c = stdp2690_i2c;
 	i2c_set_clientdata(stdp2690_i2c, ge_b850v3_lvds_ptr);
-- 
2.25.1

