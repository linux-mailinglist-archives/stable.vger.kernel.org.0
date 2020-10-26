Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76EEF299B59
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 00:50:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409160AbgJZXuj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 19:50:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:48426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408850AbgJZXty (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Oct 2020 19:49:54 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6ADED20773;
        Mon, 26 Oct 2020 23:49:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603756194;
        bh=N+QUqyILg2SxO8jRm/qHzOz1JqZ74n+tGeJYBcQYaTI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KOCWKWABet5tE+B5WfOFKlWoUUexNYUwWlREQk0BLBou4dGZbBnjEKehyaRzNWMA9
         YHgn2KtimpXQM+iNPceMylg7tFGpuTvpmkdGLc6yXnFWGaUvDj4N2Qi+hmYZ02Zdjy
         PS25hg0Iq+vfjXCixXOd+YVNfZuXBZtpm4MvbpY4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nadezda Lutovinova <lutovinova@ispras.ru>,
        Sam Ravnborg <sam@ravnborg.org>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.9 038/147] drm/brige/megachips: Add checking if ge_b850v3_lvds_init() is working correctly
Date:   Mon, 26 Oct 2020 19:47:16 -0400
Message-Id: <20201026234905.1022767-38-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201026234905.1022767-1-sashal@kernel.org>
References: <20201026234905.1022767-1-sashal@kernel.org>
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
index 6200f12a37e69..ab8174831cf40 100644
--- a/drivers/gpu/drm/bridge/megachips-stdpxxxx-ge-b850v3-fw.c
+++ b/drivers/gpu/drm/bridge/megachips-stdpxxxx-ge-b850v3-fw.c
@@ -302,8 +302,12 @@ static int stdp4028_ge_b850v3_fw_probe(struct i2c_client *stdp4028_i2c,
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
@@ -361,8 +365,12 @@ static int stdp2690_ge_b850v3_fw_probe(struct i2c_client *stdp2690_i2c,
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

