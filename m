Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DCFA68D13
	for <lists+stable@lfdr.de>; Mon, 15 Jul 2019 15:56:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732155AbfGON4F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jul 2019 09:56:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:60424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732774AbfGON4C (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jul 2019 09:56:02 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9925F20C01;
        Mon, 15 Jul 2019 13:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563198961;
        bh=XjWXZhO01zT/rlf4XT5hYz1JGLk/R5HgAI6sRkUAsbM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wok7ENwHgAhuOMsOr9DIz4g3rHy0ToTgxqRcIzTDIxK+qddlZSOp6Y1uDA504lh1u
         k2Roa/Mx3PvbcYtKScbwLg/Pbiu9YZhm/ZLmmboXf71vkfYSdUtJdNSWAJetC4v4tx
         gEhu/Tv+emPc1JwnyO0K7xOSgHdC0PsofyO76Rpg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Andr=C3=A9=20Almeida?= <andrealmeid@collabora.com>,
        Helen Koike <helen.koike@collabora.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 154/249] media: vimc: cap: check v4l2_fill_pixfmt return value
Date:   Mon, 15 Jul 2019 09:45:19 -0400
Message-Id: <20190715134655.4076-154-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715134655.4076-1-sashal@kernel.org>
References: <20190715134655.4076-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: André Almeida <andrealmeid@collabora.com>

[ Upstream commit 77ae46e11df5c96bb4582633851f838f5d954df4 ]

v4l2_fill_pixfmt() returns -EINVAL if the pixelformat used as parameter is
invalid or if the user is trying to use a multiplanar format with the
singleplanar API. Currently, the vimc_cap_try_fmt_vid_cap() returns such
value, but vimc_cap_s_fmt_vid_cap() is ignoring it. Fix that and returns
an error value if vimc_cap_try_fmt_vid_cap() has failed.

Signed-off-by: André Almeida <andrealmeid@collabora.com>
Suggested-by: Helen Koike <helen.koike@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/vimc/vimc-capture.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/vimc/vimc-capture.c b/drivers/media/platform/vimc/vimc-capture.c
index 946dc0908566..664855708fdf 100644
--- a/drivers/media/platform/vimc/vimc-capture.c
+++ b/drivers/media/platform/vimc/vimc-capture.c
@@ -142,12 +142,15 @@ static int vimc_cap_s_fmt_vid_cap(struct file *file, void *priv,
 				  struct v4l2_format *f)
 {
 	struct vimc_cap_device *vcap = video_drvdata(file);
+	int ret;
 
 	/* Do not change the format while stream is on */
 	if (vb2_is_busy(&vcap->queue))
 		return -EBUSY;
 
-	vimc_cap_try_fmt_vid_cap(file, priv, f);
+	ret = vimc_cap_try_fmt_vid_cap(file, priv, f);
+	if (ret)
+		return ret;
 
 	dev_dbg(vcap->dev, "%s: format update: "
 		"old:%dx%d (0x%x, %d, %d, %d, %d) "
-- 
2.20.1

