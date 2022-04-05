Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A9704F2823
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:19:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233625AbiDEIKy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:10:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235483AbiDEH7r (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:59:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A0BA5EBF7;
        Tue,  5 Apr 2022 00:54:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9A0AA615CD;
        Tue,  5 Apr 2022 07:54:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9659C340EE;
        Tue,  5 Apr 2022 07:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145279;
        bh=CaPjrMepGUncNKEa4UU9hfroCy8AfZBlohBfmt7mJRc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RG2+ob9Ss4wn53+iaaEpZ5t+vaivVsL6hqvUfRmETHmvK1Q+MceoNq+CA0HwlerVx
         FvSP8T5yprh1D4WAVpuMVgFOvdGSjLDIjL0vL/jc83n8AsBmYy5mZ6HJxoQUeD0oO5
         Vx23JoxP4GkdSptBp3pxFpMcT7XJw5W5dsBErZIs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Rix <trix@redhat.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0350/1126] media: video/hdmi: handle short reads of hdmi info frame.
Date:   Tue,  5 Apr 2022 09:18:17 +0200
Message-Id: <20220405070417.902302808@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tom Rix <trix@redhat.com>

[ Upstream commit 4a92fc6e55da5b87cecb572275deaff6ac9dd27e ]

Calling hdmi_infoframe_unpack() with static sizeof(buffer) skips all
the size checking done later in hdmi_infoframe_unpack().  A better
value is the amount of data read into buffer.

Fixes: 480b8b3e42c3 ("video/hdmi: Pass buffer size to infoframe unpack functions")
Signed-off-by: Tom Rix <trix@redhat.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/adv7511-v4l2.c | 2 +-
 drivers/media/i2c/adv7604.c      | 2 +-
 drivers/media/i2c/adv7842.c      | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/i2c/adv7511-v4l2.c b/drivers/media/i2c/adv7511-v4l2.c
index 8e13cae40ec5..db7f41a80770 100644
--- a/drivers/media/i2c/adv7511-v4l2.c
+++ b/drivers/media/i2c/adv7511-v4l2.c
@@ -522,7 +522,7 @@ static void log_infoframe(struct v4l2_subdev *sd, const struct adv7511_cfg_read_
 	buffer[3] = 0;
 	buffer[3] = hdmi_infoframe_checksum(buffer, len + 4);
 
-	if (hdmi_infoframe_unpack(&frame, buffer, sizeof(buffer)) < 0) {
+	if (hdmi_infoframe_unpack(&frame, buffer, len + 4) < 0) {
 		v4l2_err(sd, "%s: unpack of %s infoframe failed\n", __func__, cri->desc);
 		return;
 	}
diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index a2fa408d2d9f..bb0c8fc6d383 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -2484,7 +2484,7 @@ static int adv76xx_read_infoframe(struct v4l2_subdev *sd, int index,
 		buffer[i + 3] = infoframe_read(sd,
 				       adv76xx_cri[index].payload_addr + i);
 
-	if (hdmi_infoframe_unpack(frame, buffer, sizeof(buffer)) < 0) {
+	if (hdmi_infoframe_unpack(frame, buffer, len + 3) < 0) {
 		v4l2_err(sd, "%s: unpack of %s infoframe failed\n", __func__,
 			 adv76xx_cri[index].desc);
 		return -ENOENT;
diff --git a/drivers/media/i2c/adv7842.c b/drivers/media/i2c/adv7842.c
index 9d6eed0f8281..22caa070273b 100644
--- a/drivers/media/i2c/adv7842.c
+++ b/drivers/media/i2c/adv7842.c
@@ -2583,7 +2583,7 @@ static void log_infoframe(struct v4l2_subdev *sd, const struct adv7842_cfg_read_
 	for (i = 0; i < len; i++)
 		buffer[i + 3] = infoframe_read(sd, cri->payload_addr + i);
 
-	if (hdmi_infoframe_unpack(&frame, buffer, sizeof(buffer)) < 0) {
+	if (hdmi_infoframe_unpack(&frame, buffer, len + 3) < 0) {
 		v4l2_err(sd, "%s: unpack of %s infoframe failed\n", __func__, cri->desc);
 		return;
 	}
-- 
2.34.1



